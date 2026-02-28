package egovframework.example.schedule.service.impl;

import java.util.List;

import egovframework.example.schedule.service.ScheduleVO;
import egovframework.example.cmmn.service.CommonDefaultVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

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

}
