package com.ftk.schedule.mapper;

import java.util.List;
import java.util.Map;

import com.ftk.schedule.vo.ScheduleVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Class Name : ScheduleMapper.java
 * @Description : 공연일정 MyBatis Mapper 인터페이스
 */
@Mapper("scheduleMapper")
public interface ScheduleMapper {

	/**
	 * 공연일정을 등록한다.
	 * @param vo - 등록할 정보가 담긴 ScheduleVO
	 * @exception Exception
	 */
	void insertSchedule(ScheduleVO vo) throws Exception;

	/**
	 * 공연일정을 수정한다.
	 * @param vo - 수정할 정보가 담긴 ScheduleVO
	 * @exception Exception
	 */
	void updateSchedule(ScheduleVO vo) throws Exception;

	/**
	 * 공연일정을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 ScheduleVO
	 * @exception Exception
	 */
	void deleteSchedule(ScheduleVO vo) throws Exception;

	/**
	 * 공연일정을 조회한다.
	 * @param vo - 조회할 정보가 담긴 ScheduleVO
	 * @return 조회한 공연일정
	 * @exception Exception
	 */
	ScheduleVO selectSchedule(ScheduleVO vo) throws Exception;

	/**
	 * 공연일정 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 공연일정 목록
	 * @exception Exception
	 */
	List<?> selectScheduleList(CommonDefaultVO searchVO) throws Exception;

	/**
	 * 공연일정 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 공연일정 총 갯수
	 */
	int selectScheduleListTotCnt(CommonDefaultVO searchVO);

	/**
	 * 특정 프로그램의 공연일정 목록을 조회한다.
	 * @param vo - 프로그램ID가 담긴 ScheduleVO
	 * @return 공연일정 목록
	 * @exception Exception
	 */
	List<?> selectScheduleListByProgram(ScheduleVO vo) throws Exception;

	/** 온라인 예약 가능 날짜 목록 */
	List<String> selectAvailableDates(ScheduleVO vo);

	/** 특정 날짜의 예약 가능 회차 목록 */
	List<ScheduleVO> selectAvailableSessions(ScheduleVO vo);

	/** 온라인 잔여석 차감 (반환값: 업데이트 건수, 0이면 잔여석 부족) */
	int decreaseOnlineAvail(ScheduleVO vo);

	/** 달력 뷰: 월별 일정 요약 */
	List<?> selectCalendarSummary(Map<String, Object> param);

	/** 달력 뷰: 날짜별 상세 */
	List<?> selectDateDetail(Map<String, Object> param);

	/** 달력 뷰: 날짜별 가격 (템플릿+override) */
	List<?> selectDatePrices(Map<String, Object> param);

	/** 날짜별 가격 override 저장 (MERGE) */
	void insertDatePriceOverride(Map<String, Object> param);

	/** 날짜별 가격 override 삭제 */
	void deleteDatePriceOverride(Map<String, Object> param);

	/** 날짜별 회차 override 저장 (MERGE) */
	void insertDateSessionOverride(Map<String, Object> param);

	/** 날짜별 회차 override 삭제 */
	void deleteDateSessionOverride(Map<String, Object> param);

	/** 특정 날짜+회차에 스케줄이 존재하는지 확인 */
	int existsScheduleForDate(Map<String, Object> param);

}
