package com.ftk.venue.controller;

import java.util.List;

import com.ftk.venue.service.VenueService;
import com.ftk.venue.vo.VenueVO;
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
 * @Class Name : VenueController.java
 * @Description : 공연장 Controller 클래스
 */
@Controller
@RequiredArgsConstructor
public class VenueController {

	/** VenueService */
	private final VenueService venueService;

	/** EgovPropertyService */
	private final EgovPropertyService propertiesService;

	/** Validator */
	private final DefaultBeanValidator beanValidator;

	/**
	 * 공연장 목록을 조회한다. (페이징)
	 * @param searchVO - 조회할 정보가 담긴 CommonDefaultVO
	 * @param model
	 * @return "venue/venueList"
	 * @exception Exception
	 */
	@RequestMapping(value = "/venueList.do")
	public String selectVenueList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {

		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> venueList = venueService.selectVenueList(searchVO);
		model.addAttribute("resultList", venueList);

		int totCnt = venueService.selectVenueListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		return "venue/venueList";
	}

	/**
	 * 공연장 등록 화면을 조회한다.
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "venue/venueRegister"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addVenue.do", method = RequestMethod.GET)
	public String addVenueView(@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		model.addAttribute("venueVO", new VenueVO());
		return "venue/venueRegister";
	}

	/**
	 * 공연장을 등록한다.
	 * @param venueVO - 등록할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/venueList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addVenue.do", method = RequestMethod.POST)
	public String addVenue(@ModelAttribute("searchVO") CommonDefaultVO searchVO, VenueVO venueVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {

		beanValidator.validate(venueVO, bindingResult);

		if (bindingResult.hasErrors()) {
			model.addAttribute("venueVO", venueVO);
			return "venue/venueRegister";
		}

		venueService.insertVenue(venueVO);
		status.setComplete();
		return "forward:/venueList.do";
	}

	/**
	 * 공연장 수정화면을 조회한다.
	 * @param id - 수정할 공연장 ID
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "venue/venueRegister"
	 * @exception Exception
	 */
	@RequestMapping("/updateVenueView.do")
	public String updateVenueView(@RequestParam("selectedId") String id,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		VenueVO venueVO = new VenueVO();
		venueVO.setVenueId(id);
		model.addAttribute(selectVenue(venueVO, searchVO));
		return "venue/venueRegister";
	}

	/**
	 * 공연장을 조회한다.
	 * @param venueVO - 조회할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @return 조회한 공연장
	 * @exception Exception
	 */
	public VenueVO selectVenue(VenueVO venueVO, @ModelAttribute("searchVO") CommonDefaultVO searchVO) throws Exception {
		return venueService.selectVenue(venueVO);
	}

	/**
	 * 공연장을 수정한다.
	 * @param venueVO - 수정할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/venueList.do"
	 * @exception Exception
	 */
	@RequestMapping("/updateVenue.do")
	public String updateVenue(@ModelAttribute("searchVO") CommonDefaultVO searchVO, VenueVO venueVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {

		beanValidator.validate(venueVO, bindingResult);

		if (bindingResult.hasErrors()) {
			model.addAttribute("venueVO", venueVO);
			return "venue/venueRegister";
		}

		venueService.updateVenue(venueVO);
		status.setComplete();
		return "forward:/venueList.do";
	}

	/**
	 * 공연장을 삭제한다.
	 * @param venueVO - 삭제할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/venueList.do"
	 * @exception Exception
	 */
	@RequestMapping("/deleteVenue.do")
	public String deleteVenue(VenueVO venueVO, @ModelAttribute("searchVO") CommonDefaultVO searchVO,
			SessionStatus status) throws Exception {
		venueService.deleteVenue(venueVO);
		status.setComplete();
		return "forward:/venueList.do";
	}

}
