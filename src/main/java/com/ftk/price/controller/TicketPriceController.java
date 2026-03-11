package com.ftk.price.controller;

import java.util.List;

import com.ftk.price.service.TicketPriceService;
import com.ftk.price.vo.TicketPriceVO;
import com.ftk.program.service.ProgramService;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;
import org.springmodules.validation.commons.DefaultBeanValidator;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : TicketPriceController.java
 * @Description : 티켓가격 Controller 클래스
 */
@Controller
@RequiredArgsConstructor
public class TicketPriceController {

	/** TicketPriceService */
	private final TicketPriceService ticketPriceService;

	/** ProgramService */
	private final ProgramService programService;

	/** EgovPropertyService */
	private final EgovPropertyService propertiesService;

	/** Validator */
	private final DefaultBeanValidator beanValidator;

	/**
	 * 티켓가격 목록을 조회한다. (페이징)
	 * @param searchVO - 조회할 정보가 담긴 CommonDefaultVO
	 * @param model
	 * @return "price/ticketPriceList"
	 * @exception Exception
	 */
	@RequestMapping(value = "/ticketPriceList.do")
	public String selectTicketPriceList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {

		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> ticketPriceList = ticketPriceService.selectTicketPriceList(searchVO);
		model.addAttribute("resultList", ticketPriceList);

		int totCnt = ticketPriceService.selectTicketPriceListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		return "price/ticketPriceList";
	}

	/**
	 * 티켓가격 등록 화면을 조회한다.
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "price/ticketPriceRegister"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addTicketPrice.do", method = RequestMethod.GET)
	public String addTicketPriceView(@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		model.addAttribute("ticketPriceVO", new TicketPriceVO());
		model.addAttribute("programList", programService.selectProgramListAll());
		return "price/ticketPriceRegister";
	}

	/**
	 * 티켓가격을 등록한다.
	 * @param ticketPriceVO - 등록할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/ticketPriceList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addTicketPrice.do", method = RequestMethod.POST)
	public String addTicketPrice(@ModelAttribute("searchVO") CommonDefaultVO searchVO, TicketPriceVO ticketPriceVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {

		beanValidator.validate(ticketPriceVO, bindingResult);

		if (bindingResult.hasErrors()) {
			model.addAttribute("ticketPriceVO", ticketPriceVO);
			model.addAttribute("programList", programService.selectProgramListAll());
			return "price/ticketPriceRegister";
		}

		ticketPriceService.insertTicketPrice(ticketPriceVO);
		status.setComplete();
		return "forward:/ticketPriceList.do";
	}

	/**
	 * 티켓가격 수정화면을 조회한다.
	 * @param id - 수정할 가격 ID
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "price/ticketPriceRegister"
	 * @exception Exception
	 */
	@RequestMapping("/updateTicketPriceView.do")
	public String updateTicketPriceView(@RequestParam("selectedId") String id,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		TicketPriceVO ticketPriceVO = new TicketPriceVO();
		ticketPriceVO.setPriceId(id);
		model.addAttribute(selectTicketPrice(ticketPriceVO, searchVO));
		model.addAttribute("programList", programService.selectProgramListAll());
		return "price/ticketPriceRegister";
	}

	/**
	 * 티켓가격을 조회한다.
	 * @param ticketPriceVO - 조회할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @return 조회한 티켓가격
	 * @exception Exception
	 */
	public TicketPriceVO selectTicketPrice(TicketPriceVO ticketPriceVO,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO) throws Exception {
		return ticketPriceService.selectTicketPrice(ticketPriceVO);
	}

	/**
	 * 티켓가격을 수정한다.
	 * @param ticketPriceVO - 수정할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/ticketPriceList.do"
	 * @exception Exception
	 */
	@RequestMapping("/updateTicketPrice.do")
	public String updateTicketPrice(@ModelAttribute("searchVO") CommonDefaultVO searchVO, TicketPriceVO ticketPriceVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {

		beanValidator.validate(ticketPriceVO, bindingResult);

		if (bindingResult.hasErrors()) {
			model.addAttribute("ticketPriceVO", ticketPriceVO);
			model.addAttribute("programList", programService.selectProgramListAll());
			return "price/ticketPriceRegister";
		}

		ticketPriceService.updateTicketPrice(ticketPriceVO);
		status.setComplete();
		return "forward:/ticketPriceList.do";
	}

	/**
	 * 티켓가격을 삭제한다.
	 * @param ticketPriceVO - 삭제할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/ticketPriceList.do"
	 * @exception Exception
	 */
	@RequestMapping("/deleteTicketPrice.do")
	public String deleteTicketPrice(TicketPriceVO ticketPriceVO,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO, SessionStatus status) throws Exception {
		ticketPriceService.deleteTicketPrice(ticketPriceVO);
		status.setComplete();
		return "forward:/ticketPriceList.do";
	}

}
