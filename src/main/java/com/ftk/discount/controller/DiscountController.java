package com.ftk.discount.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ftk.discount.service.DiscountService;
import com.ftk.discount.vo.DiscountVO;
import com.ftk.tickettype.service.TicketTypeService;
import com.ftk.program.service.ProgramService;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class DiscountController {

	private final DiscountService discountService;
	private final TicketTypeService ticketTypeService;
	private final ProgramService programService;
	private final EgovPropertyService propertiesService;

	@RequestMapping(value = "/discountList.do")
	public String selectDiscountList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {
		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> list = discountService.selectDiscountList(searchVO);
		model.addAttribute("resultList", list);

		int totCnt = discountService.selectDiscountListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		model.addAttribute("ticketTypeList", ticketTypeService.selectTicketTypeListAll());
		model.addAttribute("programList", programService.selectProgramListAll());

		return "discount/discountList";
	}

	@RequestMapping(value = "/discountDetail.do")
	@ResponseBody
	public Map<String, Object> selectDiscountDetail(@RequestParam("discountId") String discountId) throws Exception {
		DiscountVO vo = new DiscountVO();
		vo.setDiscountId(discountId);
		DiscountVO detail = discountService.selectDiscount(vo);
		List<?> programsWithValues = discountService.selectDiscountProgramsWithValues(discountId);

		Map<String, Object> result = new HashMap<>();
		result.put("discountId", detail.getDiscountId());
		result.put("discountNm", detail.getDiscountNm());
		result.put("discountType", detail.getDiscountType());
		result.put("discountValue", detail.getDiscountValue());
		result.put("startDate", detail.getStartDate());
		result.put("endDate", detail.getEndDate());
		result.put("applyTimeFrom", detail.getApplyTimeFrom());
		result.put("applyTimeTo", detail.getApplyTimeTo());
		result.put("applyDays", detail.getApplyDays());
		result.put("applyTicketTypeId", detail.getApplyTicketTypeId());
		result.put("roundingUnit", detail.getRoundingUnit());
		result.put("roundingType", detail.getRoundingType());
		result.put("useYn", detail.getUseYn());
		result.put("remark", detail.getRemark());
		result.put("programsWithValues", programsWithValues);
		return result;
	}

	@RequestMapping(value = "/saveDiscount.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveDiscount(DiscountVO vo) throws Exception {
		Map<String, Object> result = new HashMap<>();
		discountService.insertDiscount(vo);
		result.put("success", true);
		result.put("message", "등록되었습니다.");
		return result;
	}

	@RequestMapping(value = "/modifyDiscount.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> modifyDiscount(DiscountVO vo) throws Exception {
		Map<String, Object> result = new HashMap<>();
		discountService.updateDiscount(vo);
		result.put("success", true);
		result.put("message", "수정되었습니다.");
		return result;
	}

	@RequestMapping(value = "/removeDiscount.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> removeDiscount(@RequestParam("discountId") String discountId) throws Exception {
		Map<String, Object> result = new HashMap<>();
		DiscountVO vo = new DiscountVO();
		vo.setDiscountId(discountId);
		discountService.deleteDiscount(vo);
		result.put("success", true);
		result.put("message", "삭제되었습니다.");
		return result;
	}

}
