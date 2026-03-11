package com.ftk.generaladmission.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ftk.common.vo.CommonDefaultVO;
import com.ftk.program.service.ProgramService;
import com.ftk.program.vo.ProgramVO;
import com.ftk.productprice.service.ProductPriceService;
import com.ftk.productprice.vo.ProductPriceVO;
import com.ftk.tickettype.service.TicketTypeService;
import com.ftk.venue.service.VenueService;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : GeneralAdmissionController.java
 * @Description : 일반 입장권 Controller (PROGRAM_TYPE = 'GENERAL')
 */
@Controller
@RequiredArgsConstructor
public class GeneralAdmissionController {

	private final ProgramService programService;
	private final ProductPriceService productPriceService;
	private final TicketTypeService ticketTypeService;
	private final VenueService venueService;
	private final EgovPropertyService propertiesService;

	/**
	 * 일반 입장권 목록 페이지
	 */
	@RequestMapping(value = "/generalAdmissionList.do")
	public String selectList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {
		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		// GENERAL 타입만 조회
		searchVO.setSearchCondition2("GENERAL");

		List<?> resultList = programService.selectProgramList(searchVO);
		model.addAttribute("resultList", resultList);

		int totCnt = programService.selectProgramListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		// 권종 목록 (가격 입력용)
		model.addAttribute("ticketTypeList", ticketTypeService.selectTicketTypeListAll());

		// 장소 목록
		CommonDefaultVO venueSearchVO = new CommonDefaultVO();
		venueSearchVO.setRecordCountPerPage(9999);
		venueSearchVO.setFirstIndex(0);
		model.addAttribute("venueList", venueService.selectVenueList(venueSearchVO));

		return "generaladmission/generalAdmissionList";
	}

	/**
	 * 일반 입장권 상세 조회 (AJAX)
	 */
	@RequestMapping(value = "/generalAdmissionDetail.do")
	@ResponseBody
	public Map<String, Object> selectDetail(@RequestParam("programId") String programId) throws Exception {
		Map<String, Object> result = new HashMap<>();

		ProgramVO vo = new ProgramVO();
		vo.setProgramId(programId);
		ProgramVO program = programService.selectProgram(vo);
		result.put("program", program);

		List<ProductPriceVO> prices = productPriceService.selectProductPriceListByProgram(programId);
		result.put("prices", prices);

		return result;
	}

	/**
	 * 일반 입장권 등록 (AJAX) — 프로그램 + 가격 함께 저장
	 */
	@RequestMapping(value = "/saveGeneralAdmission.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> save(ProgramVO programVO,
			@RequestParam(value = "typeIds", required = false) String typeIds,
			@RequestParam(value = "prices", required = false) String prices) throws Exception {
		Map<String, Object> result = new HashMap<>();
		try {
			programVO.setProgramType("GENERAL");
			programVO.setUseYn("Y");
			String programId = programService.insertProgram(programVO);

			// 가격 저장
			savePrices(programId, typeIds, prices);

			result.put("success", true);
			result.put("message", "등록되었습니다.");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "오류: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 일반 입장권 수정 (AJAX)
	 */
	@RequestMapping(value = "/modifyGeneralAdmission.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> modify(ProgramVO programVO,
			@RequestParam(value = "typeIds", required = false) String typeIds,
			@RequestParam(value = "prices", required = false) String prices) throws Exception {
		Map<String, Object> result = new HashMap<>();
		try {
			programVO.setProgramType("GENERAL");
			if (programVO.getUseYn() == null || programVO.getUseYn().isEmpty()) {
				programVO.setUseYn("Y");
			}
			programService.updateProgram(programVO);

			// 기존 가격 삭제 후 재등록
			productPriceService.deleteProductPriceByProgram(programVO.getProgramId());
			savePrices(programVO.getProgramId(), typeIds, prices);

			result.put("success", true);
			result.put("message", "수정되었습니다.");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "오류: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 일반 입장권 삭제 (AJAX)
	 */
	@RequestMapping(value = "/removeGeneralAdmission.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> remove(@RequestParam("programId") String programId) throws Exception {
		Map<String, Object> result = new HashMap<>();
		try {
			// 가격 먼저 삭제
			productPriceService.deleteProductPriceByProgram(programId);

			ProgramVO vo = new ProgramVO();
			vo.setProgramId(programId);
			programService.deleteProgram(vo);

			result.put("success", true);
			result.put("message", "삭제되었습니다.");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "오류: " + e.getMessage());
		}
		return result;
	}

	/** 권종별 가격 일괄 저장 */
	private void savePrices(String programId, String typeIds, String pricesStr) throws Exception {
		if (typeIds == null || typeIds.isEmpty()) return;

		String[] tIds = typeIds.split(",");
		String[] pVals = (pricesStr != null) ? pricesStr.split(",") : new String[0];

		for (int i = 0; i < tIds.length; i++) {
			ProductPriceVO pp = new ProductPriceVO();
			pp.setProgramId(programId);
			pp.setTypeId(tIds[i].trim());
			int priceVal = 0;
			if (i < pVals.length && !pVals[i].trim().isEmpty()) {
				priceVal = Integer.parseInt(pVals[i].trim());
			}
			pp.setPrice(priceVal);
			productPriceService.insertProductPrice(pp);
		}
	}

}
