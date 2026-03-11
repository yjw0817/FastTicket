package com.ftk.schedule.controller;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ftk.schedule.service.ScheduleService;
import com.ftk.schedule.vo.ScheduleVO;
import com.ftk.program.service.ProgramService;
import com.ftk.holiday.service.HolidayService;
import com.ftk.common.vo.CommonDefaultVO;

import java.util.Set;
import java.util.HashSet;
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
 * @Class Name : ScheduleController.java
 * @Description : 일정 Controller 클래스
 */
@Controller
@RequiredArgsConstructor
public class ScheduleController {

	private final ScheduleService scheduleService;

	private final ProgramService programService;

	private final HolidayService holidayService;

	private final EgovPropertyService propertiesService;

	/**
	 * 달력 뷰 페이지
	 */
	@RequestMapping(value = "/scheduleCalendar.do")
	public String scheduleCalendar(ModelMap model) throws Exception {
		model.addAttribute("programList", programService.selectProgramListAllByType("SESSION"));
		return "schedule/scheduleCalendar";
	}

	/**
	 * 일정 목록 페이지
	 */
	@RequestMapping(value = "/scheduleList.do")
	public String selectScheduleList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {

		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> scheduleList = scheduleService.selectScheduleList(searchVO);
		model.addAttribute("resultList", scheduleList);

		int totCnt = scheduleService.selectScheduleListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		model.addAttribute("programList", programService.selectProgramListAllByType("SESSION"));

		return "schedule/scheduleList";
	}

	/**
	 * 일정 상세 조회 (AJAX)
	 */
	@RequestMapping(value = "/scheduleDetail.do")
	@ResponseBody
	public ScheduleVO selectScheduleDetail(@RequestParam("scheduleId") String scheduleId) throws Exception {
		ScheduleVO vo = new ScheduleVO();
		vo.setScheduleId(scheduleId);
		return scheduleService.selectSchedule(vo);
	}

	/**
	 * 일정 저장 (AJAX)
	 */
	@RequestMapping(value = "/saveSchedule.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSchedule(ScheduleVO vo) throws Exception {
		Map<String, Object> result = new HashMap<>();
		calcCapacity(vo);
		String id = scheduleService.insertSchedule(vo);
		result.put("success", true);
		result.put("scheduleId", id);
		result.put("message", "등록되었습니다.");
		return result;
	}

	/**
	 * 일정 수정 (AJAX)
	 */
	@RequestMapping(value = "/modifySchedule.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> modifySchedule(ScheduleVO vo) throws Exception {
		Map<String, Object> result = new HashMap<>();
		calcCapacity(vo);
		scheduleService.updateSchedule(vo);
		result.put("success", true);
		result.put("message", "수정되었습니다.");
		return result;
	}

	/**
	 * 일정 삭제 (AJAX)
	 */
	@RequestMapping(value = "/removeSchedule.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> removeSchedule(@RequestParam("scheduleId") String scheduleId) throws Exception {
		Map<String, Object> result = new HashMap<>();
		ScheduleVO vo = new ScheduleVO();
		vo.setScheduleId(scheduleId);
		scheduleService.deleteSchedule(vo);
		result.put("success", true);
		result.put("message", "삭제되었습니다.");
		return result;
	}

	/**
	 * 회차 벌크 자동 생성 (AJAX)
	 * 기간(startDate~endDate) + 시작시간~종료시간 + 단위(분) + 쉬는시간(분) → 일괄 생성
	 */
	@RequestMapping(value = "/generateScheduleBulk.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> generateScheduleBulk(
			@RequestParam("programId") String programId,
			@RequestParam("startDate") String startDate,
			@RequestParam("endDate") String endDate,
			@RequestParam("startTime") String startTime,
			@RequestParam("endTime") String endTime,
			@RequestParam("intervalMin") int intervalMin,
			@RequestParam(value = "breakMin", defaultValue = "0") int breakMin,
			@RequestParam("onlineCapacity") int onlineCapacity,
			@RequestParam("offlineCapacity") int offlineCapacity) throws Exception {

		Map<String, Object> result = new HashMap<>();

		DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");

		LocalDate dStart = LocalDate.parse(startDate, dateFmt);
		LocalDate dEnd = LocalDate.parse(endDate, dateFmt);
		LocalTime tStart = LocalTime.parse(startTime, timeFmt);
		LocalTime tEnd = LocalTime.parse(endTime, timeFmt);

		// 휴무일 조회 → 해당 날짜는 회차 생성 제외
		List<String> holidayDateList = holidayService.selectHolidayDatesBetween(startDate, endDate);
		Set<String> holidayDates = new HashSet<>(holidayDateList);
		int skippedDays = 0;

		int totalCreated = 0;

		for (LocalDate date = dStart; !date.isAfter(dEnd); date = date.plusDays(1)) {
			String dateStr = date.format(dateFmt);
			if (holidayDates.contains(dateStr)) {
				skippedDays++;
				continue;
			}
			int sessionNo = 1;
			LocalTime current = tStart;

			while (current.plusMinutes(intervalMin).compareTo(tEnd) <= 0
					|| current.plusMinutes(intervalMin).equals(tEnd)) {

				ScheduleVO vo = new ScheduleVO();
				vo.setProgramId(programId);
				vo.setEventDate(date.format(dateFmt));
				vo.setEventTime(current.format(timeFmt));
				vo.setSessionNo(sessionNo);
				vo.setOnlineCapacity(onlineCapacity);
				vo.setOfflineCapacity(offlineCapacity);
				vo.setStatus("OPEN");
				calcCapacity(vo);

				scheduleService.insertSchedule(vo);
				totalCreated++;
				sessionNo++;

				current = current.plusMinutes(intervalMin + breakMin);

				if (current.compareTo(tEnd) >= 0) break;
			}
		}

		result.put("success", true);
		result.put("totalCreated", totalCreated);
		result.put("skippedDays", skippedDays);
		String msg = totalCreated + "건의 회차가 생성되었습니다.";
		if (skippedDays > 0) {
			msg += " (휴무일 " + skippedDays + "일 제외)";
		}
		result.put("message", msg);
		return result;
	}

	/**
	 * 달력 뷰: 월별 일정 요약 (AJAX)
	 */
	@RequestMapping("/calendarSummary.do")
	@ResponseBody
	public List<?> calendarSummary(
			@RequestParam("programId") String programId,
			@RequestParam("yearMonth") String yearMonth) {
		return scheduleService.selectCalendarSummary(programId, yearMonth);
	}

	/**
	 * 달력 뷰: 날짜별 상세 (AJAX)
	 */
	@RequestMapping("/calendarDateDetail.do")
	@ResponseBody
	public List<?> calendarDateDetail(
			@RequestParam("programId") String programId,
			@RequestParam("eventDate") String eventDate) {
		return scheduleService.selectDateDetail(programId, eventDate);
	}

	/**
	 * 달력 뷰: 날짜별 가격 (AJAX)
	 */
	@RequestMapping("/calendarDatePrices.do")
	@ResponseBody
	public List<?> calendarDatePrices(
			@RequestParam("programId") String programId,
			@RequestParam("eventDate") String eventDate,
			@RequestParam("sessionNo") int sessionNo,
			@RequestParam("dayType") String dayType) {
		return scheduleService.selectDatePrices(programId, eventDate, sessionNo, dayType);
	}

	/**
	 * 날짜별 가격 override 저장 (AJAX)
	 */
	@RequestMapping(value = "/saveDatePriceOverride.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveDatePriceOverride(@RequestParam Map<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		try {
			scheduleService.saveDatePriceOverride(param);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		return result;
	}

	/**
	 * 날짜별 회차 override 저장 (AJAX)
	 */
	@RequestMapping(value = "/saveDateSessionOverride.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveDateSessionOverride(@RequestParam Map<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		try {
			scheduleService.saveDateSessionOverride(param);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		return result;
	}

	/**
	 * 템플릿 기반 스케줄 생성 (기간 선택, AJAX)
	 * 프로그램의 회차 설정(sessionCount, firstSessionTime, sessionInterval)을 기반으로 생성
	 */
	@RequestMapping(value = "/generateFromTemplate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> generateFromTemplate(
			@RequestParam("programId") String programId,
			@RequestParam("startDate") String startDate,
			@RequestParam("endDate") String endDate) throws Exception {

		Map<String, Object> result = new HashMap<>();
		DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate dStart = LocalDate.parse(startDate, dateFmt);
		LocalDate dEnd = LocalDate.parse(endDate, dateFmt);

		// 휴무일 조회
		List<String> holidayDateList = holidayService.selectHolidayDatesBetween(startDate, endDate);
		Set<String> holidayDates = new HashSet<>(holidayDateList);

		// 프로그램 정보 조회
		com.ftk.program.vo.ProgramVO progVO = new com.ftk.program.vo.ProgramVO();
		progVO.setProgramId(programId);
		com.ftk.program.vo.ProgramVO prog = programService.selectProgram(progVO);

		Integer sessionCount = prog.getSessionCount();
		String firstTime = prog.getFirstSessionTime();
		Integer interval = prog.getSessionInterval();

		if (sessionCount == null || sessionCount <= 0 || firstTime == null || firstTime.isEmpty()) {
			result.put("success", false);
			result.put("message", "프로그램에 회차 설정이 없습니다.");
			return result;
		}
		if (interval == null) interval = 0;

		int onlineCap = prog.getDefaultOnlineCap() != null ? prog.getDefaultOnlineCap() : 0;
		int offlineCap = prog.getDefaultOfflineCap() != null ? prog.getDefaultOfflineCap() : 0;

		int totalCreated = 0;
		int skippedDates = 0;

		for (LocalDate date = dStart; !date.isAfter(dEnd); date = date.plusDays(1)) {
			String dateStr = date.format(dateFmt);

			// 이미 스케줄이 존재하면 건너뜀
			List<?> existing = scheduleService.selectDateDetail(programId, dateStr);
			if (existing != null && !existing.isEmpty()) {
				skippedDates++;
				continue;
			}

			int startHour = Integer.parseInt(firstTime.substring(0, 2));
			int startMin = Integer.parseInt(firstTime.substring(3, 5));
			int totalMin = startHour * 60 + startMin;

			for (int sn = 1; sn <= sessionCount; sn++) {
				String eventTime = String.format("%02d:%02d", totalMin / 60, totalMin % 60);

				ScheduleVO svo = new ScheduleVO();
				svo.setProgramId(programId);
				svo.setEventDate(dateStr);
				svo.setEventTime(eventTime);
				svo.setSessionNo(sn);
				svo.setOnlineCapacity(onlineCap);
				svo.setOfflineCapacity(offlineCap);
				svo.setStatus("OPEN");
				calcCapacity(svo);

				scheduleService.insertSchedule(svo);
				totalCreated++;

				totalMin += interval;
			}
		}

		result.put("success", true);
		result.put("totalCreated", totalCreated);
		String msg = totalCreated + "건의 스케줄이 생성되었습니다.";
		if (skippedDates > 0) msg += " (" + skippedDates + "일 건너뜀 - 기존 스케줄 존재)";
		result.put("message", msg);
		return result;
	}

	/**
	 * 온라인+오프라인 정원으로 총정원/잔여석 자동 계산
	 */
	private void calcCapacity(ScheduleVO vo) {
		int total = vo.getOnlineCapacity() + vo.getOfflineCapacity();
		vo.setTotalSeats(total);
		vo.setAvailSeats(total);
		vo.setOnlineAvail(vo.getOnlineCapacity());
		vo.setOfflineAvail(vo.getOfflineCapacity());
	}

}
