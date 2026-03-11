package com.ftk.holiday.controller;

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

import com.ftk.holiday.service.HolidayService;
import com.ftk.holiday.vo.HolidayVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class HolidayController {

	private final HolidayService holidayService;
	private final EgovPropertyService propertiesService;

	@RequestMapping(value = "/holidayList.do")
	public String selectHolidayList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {
		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> resultList = holidayService.selectHolidayList(searchVO);
		model.addAttribute("resultList", resultList);

		int totCnt = holidayService.selectHolidayListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		return "holiday/holidayList";
	}

	@RequestMapping(value = "/holidayDetail.do")
	@ResponseBody
	public HolidayVO selectHolidayDetail(@RequestParam("holidayId") String holidayId) throws Exception {
		HolidayVO vo = new HolidayVO();
		vo.setHolidayId(holidayId);
		return holidayService.selectHoliday(vo);
	}

	@RequestMapping(value = "/saveHoliday.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveHoliday(HolidayVO vo) throws Exception {
		Map<String, Object> result = new HashMap<>();
		try {
			vo.setUseYn("Y");
			holidayService.insertHoliday(vo);
			result.put("success", true);
			result.put("message", "등록되었습니다.");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "오류: " + e.getMessage());
		}
		return result;
	}

	@RequestMapping(value = "/modifyHoliday.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> modifyHoliday(HolidayVO vo) throws Exception {
		Map<String, Object> result = new HashMap<>();
		try {
			vo.setUseYn("Y");
			holidayService.updateHoliday(vo);
			result.put("success", true);
			result.put("message", "수정되었습니다.");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "오류: " + e.getMessage());
		}
		return result;
	}

	@RequestMapping(value = "/removeHoliday.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> removeHoliday(@RequestParam("holidayId") String holidayId) throws Exception {
		Map<String, Object> result = new HashMap<>();
		try {
			HolidayVO vo = new HolidayVO();
			vo.setHolidayId(holidayId);
			holidayService.deleteHoliday(vo);
			result.put("success", true);
			result.put("message", "삭제되었습니다.");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "오류: " + e.getMessage());
		}
		return result;
	}

}
