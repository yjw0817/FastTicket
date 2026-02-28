package egovframework.example.schedule.service;

import java.util.List;

import egovframework.example.cmmn.service.CommonDefaultVO;

/**
 * @Class Name : ScheduleService.java
 * @Description : 공연일정 서비스 인터페이스
 */
public interface ScheduleService {

	/**
	 * 공연일정을 등록한다.
	 * @param vo - 등록할 정보가 담긴 ScheduleVO
	 * @return 등록된 일정ID
	 * @exception Exception
	 */
	String insertSchedule(ScheduleVO vo) throws Exception;

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
