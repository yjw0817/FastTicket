package com.ftk.sessionprice.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ftk.sessionprice.service.SessionPriceService;
import com.ftk.sessionprice.vo.SessionPriceVO;
import com.ftk.schedule.service.ScheduleService;
import com.ftk.schedule.vo.ScheduleVO;
import com.ftk.tickettype.service.TicketTypeService;
import com.ftk.tickettype.vo.TicketTypeVO;
import com.ftk.program.service.ProgramService;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.property.EgovPropertyService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : SessionPriceController.java
 * @Description : 회차별 가격 Controller 클래스
 */
@Controller
@RequiredArgsConstructor
public class SessionPriceController {

	private final SessionPriceService sessionPriceService;

	private final ScheduleService scheduleService;

	private final TicketTypeService ticketTypeService;

	private final ProgramService programService;

	private final EgovPropertyService propertiesService;

	/**
	 * 회차별 가격 관리 페이지 (그리드)
	 */
	@RequestMapping(value = "/sessionPriceList.do")
	public String selectSessionPriceList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {
		model.addAttribute("programList", programService.selectProgramListAllByType("SESSION"));
		model.addAttribute("ticketTypeList", ticketTypeService.selectTicketTypeListAll());
		return "sessionprice/sessionPriceList";
	}

	/**
	 * 특정 프로그램의 회차 목록 + 각 회차의 가격 데이터 조회 (AJAX)
	 */
	@RequestMapping(value = "/sessionPriceData.do")
	@ResponseBody
	public Map<String, Object> selectSessionPriceData(@RequestParam("programId") String programId) throws Exception {
		Map<String, Object> result = new HashMap<>();

		// 해당 프로그램의 일정 목록
		ScheduleVO scheduleParam = new ScheduleVO();
		scheduleParam.setProgramId(programId);
		List<?> scheduleList = scheduleService.selectScheduleListByProgram(scheduleParam);
		result.put("scheduleList", scheduleList);

		// 사용중인 권종 목록
		List<TicketTypeVO> ticketTypeList = ticketTypeService.selectTicketTypeListAll();
		result.put("ticketTypeList", ticketTypeList);

		// 각 회차의 가격 데이터 (Map: scheduleId → priceList)
		Map<String, Object> priceMap = new HashMap<>();
		for (Object obj : scheduleList) {
			org.egovframe.rte.psl.dataaccess.util.EgovMap schedule = (org.egovframe.rte.psl.dataaccess.util.EgovMap) obj;
			String scheduleId = (String) schedule.get("scheduleId");
			SessionPriceVO priceParam = new SessionPriceVO();
			priceParam.setScheduleId(scheduleId);
			List<?> prices = sessionPriceService.selectSessionPriceListBySchedule(priceParam);
			priceMap.put(scheduleId, prices);
		}
		result.put("priceMap", priceMap);

		return result;
	}

	/**
	 * 회차별 가격 개별 저장/수정 (AJAX)
	 */
	@RequestMapping(value = "/saveSessionPrice.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSessionPrice(SessionPriceVO vo) throws Exception {
		Map<String, Object> result = new HashMap<>();

		if (vo.getSpriceId() != null && !vo.getSpriceId().isEmpty()) {
			sessionPriceService.updateSessionPrice(vo);
			result.put("message", "수정되었습니다.");
		} else {
			vo.setUseYn("Y");
			String id = sessionPriceService.insertSessionPrice(vo);
			result.put("spriceId", id);
			result.put("message", "등록되었습니다.");
		}
		result.put("success", true);
		return result;
	}

	/**
	 * 기본 가격 일괄 적용 (AJAX)
	 * 선택한 프로그램의 전 회차에 동일 가격 설정
	 */
	@RequestMapping(value = "/applyDefaultPrice.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> applyDefaultPrice(
			@RequestParam("programId") String programId,
			@RequestParam("typeIds") String typeIds,
			@RequestParam("prices") String prices) throws Exception {

		Map<String, Object> result = new HashMap<>();

		String[] typeIdArr = typeIds.split(",");
		String[] priceArr = prices.split(",");

		// 해당 프로그램의 일정 목록
		ScheduleVO scheduleParam = new ScheduleVO();
		scheduleParam.setProgramId(programId);
		List<?> scheduleList = scheduleService.selectScheduleListByProgram(scheduleParam);

		int totalCreated = 0;

		for (Object obj : scheduleList) {
			org.egovframe.rte.psl.dataaccess.util.EgovMap schedule = (org.egovframe.rte.psl.dataaccess.util.EgovMap) obj;
			String scheduleId = (String) schedule.get("scheduleId");

			// 기존 가격 삭제
			SessionPriceVO delParam = new SessionPriceVO();
			delParam.setScheduleId(scheduleId);
			sessionPriceService.deleteSessionPriceBySchedule(delParam);

			// 권종별 가격 등록
			for (int i = 0; i < typeIdArr.length; i++) {
				SessionPriceVO priceVO = new SessionPriceVO();
				priceVO.setScheduleId(scheduleId);
				priceVO.setTypeId(typeIdArr[i].trim());
				priceVO.setPrice(Integer.parseInt(priceArr[i].trim()));
				priceVO.setUseYn("Y");
				sessionPriceService.insertSessionPrice(priceVO);
				totalCreated++;
			}
		}

		result.put("success", true);
		result.put("totalCreated", totalCreated);
		result.put("message", scheduleList.size() + "개 회차에 가격이 적용되었습니다.");
		return result;
	}

}
