package com.ftk.tickettype.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ftk.tickettype.service.TicketTypeService;
import com.ftk.tickettype.vo.TicketTypeVO;
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

/**
 * @Class Name : TicketTypeController.java
 * @Description : 권종 관리 Controller 클래스 (기초 설정)
 */
@Controller
@RequiredArgsConstructor
public class TicketTypeController {

	private final TicketTypeService ticketTypeService;

	private final EgovPropertyService propertiesService;

	/**
	 * 권종 목록 페이지
	 */
	@RequestMapping(value = "/ticketTypeList.do")
	public String selectTicketTypeList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {

		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> ticketTypeList = ticketTypeService.selectTicketTypeList(searchVO);
		model.addAttribute("resultList", ticketTypeList);

		int totCnt = ticketTypeService.selectTicketTypeListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		return "tickettype/ticketTypeList";
	}

	/**
	 * 권종 상세 조회 (AJAX)
	 */
	@RequestMapping(value = "/ticketTypeDetail.do")
	@ResponseBody
	public TicketTypeVO selectTicketTypeDetail(@RequestParam("typeId") String typeId) throws Exception {
		TicketTypeVO vo = new TicketTypeVO();
		vo.setTypeId(typeId);
		return ticketTypeService.selectTicketType(vo);
	}

	/**
	 * 권종 저장 (AJAX)
	 */
	@RequestMapping(value = "/saveTicketType.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveTicketType(TicketTypeVO vo) throws Exception {
		Map<String, Object> result = new HashMap<>();
		String typeId = ticketTypeService.insertTicketType(vo);
		result.put("success", true);
		result.put("typeId", typeId);
		result.put("message", "등록되었습니다.");
		return result;
	}

	/**
	 * 권종 수정 (AJAX)
	 */
	@RequestMapping(value = "/modifyTicketType.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> modifyTicketType(TicketTypeVO vo) throws Exception {
		Map<String, Object> result = new HashMap<>();
		ticketTypeService.updateTicketType(vo);
		result.put("success", true);
		result.put("message", "수정되었습니다.");
		return result;
	}

	/**
	 * 권종 삭제 (AJAX)
	 */
	@RequestMapping(value = "/removeTicketType.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> removeTicketType(@RequestParam("typeId") String typeId) throws Exception {
		Map<String, Object> result = new HashMap<>();
		TicketTypeVO vo = new TicketTypeVO();
		vo.setTypeId(typeId);
		ticketTypeService.deleteTicketType(vo);
		result.put("success", true);
		result.put("message", "삭제되었습니다.");
		return result;
	}

}
