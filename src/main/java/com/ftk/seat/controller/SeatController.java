package com.ftk.seat.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;

import com.ftk.common.vo.CommonDefaultVO;
import com.ftk.seat.service.SeatService;
import com.ftk.seat.vo.SeatVO;
import com.ftk.venue.service.VenueService;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springmodules.validation.commons.DefaultBeanValidator;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : SeatController.java
 * @Description : 좌석 Controller Class
 */
@Controller
@RequiredArgsConstructor
public class SeatController {

	/** SeatService */
	private final SeatService seatService;

	/** VenueService (콤보박스용) */
	private final VenueService venueService;

	/** EgovPropertyService */
	private final EgovPropertyService propertiesService;

	/** Validator */
	private final DefaultBeanValidator beanValidator;

	/**
	 * 좌석 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 CommonDefaultVO
	 * @param model
	 * @return "seat/seatList"
	 * @exception Exception
	 */
	@RequestMapping(value = "/seatList.do")
	public String selectSeatList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {

		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> seatList = seatService.selectSeatList(searchVO);
		model.addAttribute("resultList", seatList);

		int totCnt = seatService.selectSeatListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		return "seat/seatList";
	}

	/**
	 * 좌석 등록 화면을 조회한다.
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "seat/seatRegister"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addSeat.do", method = RequestMethod.GET)
	public String addSeatView(@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		model.addAttribute("seatVO", new SeatVO());

		CommonDefaultVO venueSearchVO = new CommonDefaultVO();
		venueSearchVO.setRecordCountPerPage(9999);
		venueSearchVO.setFirstIndex(0);
		List<?> venueList = venueService.selectVenueList(venueSearchVO);
		model.addAttribute("venueList", venueList);

		return "seat/seatRegister";
	}

	/**
	 * 좌석을 등록한다.
	 * @param seatVO - 등록할 정보가 담긴 SeatVO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/seatList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addSeat.do", method = RequestMethod.POST)
	public String addSeat(@ModelAttribute("searchVO") CommonDefaultVO searchVO, SeatVO seatVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {

		if (bindingResult.hasErrors()) {
			CommonDefaultVO venueSearchVO = new CommonDefaultVO();
			venueSearchVO.setRecordCountPerPage(9999);
			venueSearchVO.setFirstIndex(0);
			model.addAttribute("venueList", venueService.selectVenueList(venueSearchVO));
			model.addAttribute("seatVO", seatVO);
			return "seat/seatRegister";
		}

		seatService.insertSeat(seatVO);
		status.setComplete();
		return "forward:/seatList.do";
	}

	/**
	 * 좌석 수정화면을 조회한다.
	 * @param id - 수정할 좌석 id
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "seat/seatRegister"
	 * @exception Exception
	 */
	@RequestMapping("/updateSeatView.do")
	public String updateSeatView(@RequestParam("selectedId") String id,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {

		SeatVO seatVO = new SeatVO();
		seatVO.setSeatId(id);
		SeatVO result = seatService.selectSeat(seatVO);
		model.addAttribute("seatVO", result);

		CommonDefaultVO venueSearchVO = new CommonDefaultVO();
		venueSearchVO.setRecordCountPerPage(9999);
		venueSearchVO.setFirstIndex(0);
		List<?> venueList = venueService.selectVenueList(venueSearchVO);
		model.addAttribute("venueList", venueList);

		return "seat/seatRegister";
	}

	/**
	 * 좌석을 수정한다.
	 * @param seatVO - 수정할 정보가 담긴 SeatVO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/seatList.do"
	 * @exception Exception
	 */
	@RequestMapping("/updateSeat.do")
	public String updateSeat(@ModelAttribute("searchVO") CommonDefaultVO searchVO, SeatVO seatVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {

		if (bindingResult.hasErrors()) {
			CommonDefaultVO venueSearchVO = new CommonDefaultVO();
			venueSearchVO.setRecordCountPerPage(9999);
			venueSearchVO.setFirstIndex(0);
			model.addAttribute("venueList", venueService.selectVenueList(venueSearchVO));
			model.addAttribute("seatVO", seatVO);
			return "seat/seatRegister";
		}

		seatService.updateSeat(seatVO);
		status.setComplete();
		return "forward:/seatList.do";
	}

	/**
	 * 좌석을 삭제한다.
	 * @param seatVO - 삭제할 정보가 담긴 SeatVO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/seatList.do"
	 * @exception Exception
	 */
	@RequestMapping("/deleteSeat.do")
	public String deleteSeat(SeatVO seatVO, @ModelAttribute("searchVO") CommonDefaultVO searchVO,
			SessionStatus status) throws Exception {
		seatService.deleteSeat(seatVO);
		status.setComplete();
		return "forward:/seatList.do";
	}

}
