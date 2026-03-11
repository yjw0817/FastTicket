package com.ftk.program.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;

import com.ftk.common.vo.CommonDefaultVO;
import com.ftk.program.service.ProgramService;
import com.ftk.program.vo.ProgramVO;
import com.ftk.program.vo.ProgramTicketTypeVO;
import com.ftk.program.vo.ProgramDiscountVO;
import com.ftk.tickettype.service.TicketTypeService;
import com.ftk.venue.service.VenueService;
import com.ftk.discount.service.DiscountService;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springmodules.validation.commons.DefaultBeanValidator;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : ProgramController.java
 * @Description : 프로그램 Controller Class (가격 템플릿 시스템 통합)
 */
@Controller
@RequiredArgsConstructor
public class ProgramController {

	private final ProgramService programService;
	private final VenueService venueService;
	private final TicketTypeService ticketTypeService;
	private final DiscountService discountService;
	private final EgovPropertyService propertiesService;
	private final DefaultBeanValidator beanValidator;

	/**
	 * 프로그램 목록을 조회한다.
	 */
	@RequestMapping(value = "/programList.do")
	public String selectProgramList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {

		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		// SESSION 타입만 조회 (회차 입장권)
		searchVO.setSearchCondition2("SESSION");

		List<?> programList = programService.selectProgramList(searchVO);
		model.addAttribute("resultList", programList);

		int totCnt = programService.selectProgramListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		// 장소/시설 목록 (필터용)
		CommonDefaultVO venueSearchVO = new CommonDefaultVO();
		venueSearchVO.setFirstIndex(0);
		venueSearchVO.setRecordCountPerPage(9999);
		model.addAttribute("venueList", venueService.selectVenueList(venueSearchVO));

		return "program/programList";
	}

	/**
	 * 프로그램 등록 화면을 조회한다.
	 */
	@RequestMapping(value = "/addProgram.do", method = RequestMethod.GET)
	public String addProgramView(@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		model.addAttribute("programVO", new ProgramVO());
		loadFormData(model);
		return "program/programRegister";
	}

	/**
	 * 프로그램을 등록한다.
	 */
	@RequestMapping(value = "/addProgram.do", method = RequestMethod.POST)
	public String addProgram(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ProgramVO programVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {

		if (bindingResult.hasErrors()) {
			loadFormData(model);
			model.addAttribute("programVO", programVO);
			return "program/programRegister";
		}

		if (programVO.getProgramType() == null || programVO.getProgramType().isEmpty()) {
			programVO.setProgramType("SESSION");
		}
		programService.insertProgram(programVO);
		status.setComplete();
		return "forward:/programList.do";
	}

	/**
	 * 프로그램 수정화면을 조회한다.
	 */
	@RequestMapping("/updateProgramView.do")
	public String updateProgramView(@RequestParam("selectedId") String id,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {

		ProgramVO programVO = new ProgramVO();
		programVO.setProgramId(id);
		ProgramVO result = programService.selectProgram(programVO);

		// 권종+기본가격 목록 로드
		result.setTicketTypes(programService.selectProgramTicketTypes(id));
		result.setTypeIds(programService.selectProgramTicketTypeIds(id));

		// 할인 목록 로드
		result.setDiscounts(programService.selectProgramDiscounts(id));

		// 기존 템플릿 JSON 로드
		String templateJson = programService.buildTemplateJson(id);
		model.addAttribute("existingTemplateJson", templateJson);

		model.addAttribute("programVO", result);
		loadFormData(model);

		return "program/programRegister";
	}

	/**
	 * 프로그램을 수정한다.
	 */
	@RequestMapping("/updateProgram.do")
	public String updateProgram(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ProgramVO programVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {

		if (bindingResult.hasErrors()) {
			loadFormData(model);
			model.addAttribute("programVO", programVO);
			return "program/programRegister";
		}

		programService.updateProgram(programVO);
		status.setComplete();
		return "forward:/programList.do";
	}

	/**
	 * 프로그램을 삭제한다.
	 */
	@RequestMapping("/deleteProgram.do")
	public String deleteProgram(ProgramVO programVO, @ModelAttribute("searchVO") CommonDefaultVO searchVO,
			SessionStatus status) throws Exception {
		programService.deleteProgram(programVO);
		status.setComplete();
		return "forward:/programList.do";
	}

	/**
	 * 공통 할인 템플릿 목록 조회 (프로그램 할인에서 가져오기용 AJAX)
	 */
	@RequestMapping("/selectCommonDiscounts.do")
	@ResponseBody
	public List<?> selectCommonDiscounts() throws Exception {
		CommonDefaultVO searchVO = new CommonDefaultVO();
		searchVO.setRecordCountPerPage(9999);
		searchVO.setFirstIndex(0);
		return discountService.selectDiscountList(searchVO);
	}

	/**
	 * 등록/수정 화면 공통 데이터 로드
	 */
	private void loadFormData(Model model) throws Exception {
		CommonDefaultVO venueSearchVO = new CommonDefaultVO();
		venueSearchVO.setRecordCountPerPage(9999);
		venueSearchVO.setFirstIndex(0);
		model.addAttribute("venueList", venueService.selectVenueList(venueSearchVO));
		model.addAttribute("ticketTypeList", ticketTypeService.selectTicketTypeListAll());
	}

}
