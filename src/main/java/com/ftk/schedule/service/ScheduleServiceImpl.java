package com.ftk.schedule.service;

import com.ftk.schedule.mapper.ScheduleMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ftk.schedule.service.ScheduleService;
import com.ftk.schedule.vo.ScheduleVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : ScheduleServiceImpl.java
 * @Description : 공연일정 서비스 구현 클래스
 */
@Service("scheduleService")
@RequiredArgsConstructor
public class ScheduleServiceImpl extends EgovAbstractServiceImpl implements ScheduleService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ScheduleServiceImpl.class);

	/** ScheduleMapper */
	private final ScheduleMapper scheduleMapper;

	/** ID Generation */
	private final EgovIdGnrService scheduleIdGnrService;

	/**
	 * 공연일정을 등록한다.
	 * @param vo - 등록할 정보가 담긴 ScheduleVO
	 * @return 등록된 일정ID
	 * @exception Exception
	 */
	@Override
	public String insertSchedule(ScheduleVO vo) throws Exception {
		LOGGER.debug(vo.toString());
		String id = scheduleIdGnrService.getNextStringId();
		vo.setScheduleId(id);
		LOGGER.debug(vo.toString());
		scheduleMapper.insertSchedule(vo);
		return id;
	}

	/**
	 * 공연일정을 수정한다.
	 * @param vo - 수정할 정보가 담긴 ScheduleVO
	 * @exception Exception
	 */
	@Override
	public void updateSchedule(ScheduleVO vo) throws Exception {
		scheduleMapper.updateSchedule(vo);
	}

	/**
	 * 공연일정을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 ScheduleVO
	 * @exception Exception
	 */
	@Override
	public void deleteSchedule(ScheduleVO vo) throws Exception {
		scheduleMapper.deleteSchedule(vo);
	}

	/**
	 * 공연일정을 조회한다.
	 * @param vo - 조회할 정보가 담긴 ScheduleVO
	 * @return 조회한 공연일정
	 * @exception Exception
	 */
	@Override
	public ScheduleVO selectSchedule(ScheduleVO vo) throws Exception {
		ScheduleVO resultVO = scheduleMapper.selectSchedule(vo);
		if (resultVO == null)
			throw processException("info.nodata.msg");
		return resultVO;
	}

	/**
	 * 공연일정 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 공연일정 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectScheduleList(CommonDefaultVO searchVO) throws Exception {
		return scheduleMapper.selectScheduleList(searchVO);
	}

	/**
	 * 공연일정 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 공연일정 총 갯수
	 */
	@Override
	public int selectScheduleListTotCnt(CommonDefaultVO searchVO) {
		return scheduleMapper.selectScheduleListTotCnt(searchVO);
	}

	/**
	 * 특정 프로그램의 공연일정 목록을 조회한다.
	 * @param vo - 프로그램ID가 담긴 ScheduleVO
	 * @return 공연일정 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectScheduleListByProgram(ScheduleVO vo) throws Exception {
		return scheduleMapper.selectScheduleListByProgram(vo);
	}

	@Override
	public List<String> selectAvailableDates(String programId) {
		ScheduleVO vo = new ScheduleVO();
		vo.setProgramId(programId);
		return scheduleMapper.selectAvailableDates(vo);
	}

	@Override
	public List<ScheduleVO> selectAvailableSessions(String programId, String eventDate) {
		ScheduleVO vo = new ScheduleVO();
		vo.setProgramId(programId);
		vo.setEventDate(eventDate);
		return scheduleMapper.selectAvailableSessions(vo);
	}

	@Override
	public int decreaseOnlineAvail(String scheduleId, int qty) {
		ScheduleVO vo = new ScheduleVO();
		vo.setScheduleId(scheduleId);
		vo.setOnlineAvail(qty);
		return scheduleMapper.decreaseOnlineAvail(vo);
	}

	@Override
	public List<?> selectCalendarSummary(String programId, String yearMonth) {
		Map<String, Object> param = new HashMap<>();
		param.put("programId", programId);
		param.put("yearMonth", yearMonth);
		return scheduleMapper.selectCalendarSummary(param);
	}

	@Override
	public List<?> selectDateDetail(String programId, String eventDate) {
		Map<String, Object> param = new HashMap<>();
		param.put("programId", programId);
		param.put("eventDate", eventDate);
		return scheduleMapper.selectDateDetail(param);
	}

	@Override
	public List<?> selectDatePrices(String programId, String eventDate, int sessionNo, String dayType) {
		Map<String, Object> param = new HashMap<>();
		param.put("programId", programId);
		param.put("eventDate", eventDate);
		param.put("sessionNo", sessionNo);
		param.put("dayType", dayType);
		return scheduleMapper.selectDatePrices(param);
	}

	@Override
	public void saveDatePriceOverride(Map<String, Object> param) {
		scheduleMapper.insertDatePriceOverride(param);
	}

	@Override
	public void deleteDatePriceOverride(Map<String, Object> param) {
		scheduleMapper.deleteDatePriceOverride(param);
	}

	@Override
	public void saveDateSessionOverride(Map<String, Object> param) {
		scheduleMapper.insertDateSessionOverride(param);
	}

	@Override
	public void deleteDateSessionOverride(Map<String, Object> param) {
		scheduleMapper.deleteDateSessionOverride(param);
	}

}
