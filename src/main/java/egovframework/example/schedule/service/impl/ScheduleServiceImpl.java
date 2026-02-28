package egovframework.example.schedule.service.impl;

import java.util.List;

import egovframework.example.schedule.service.ScheduleService;
import egovframework.example.schedule.service.ScheduleVO;
import egovframework.example.cmmn.service.CommonDefaultVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * @Class Name : ScheduleServiceImpl.java
 * @Description : 공연일정 서비스 구현 클래스
 */
@Service("scheduleService")
public class ScheduleServiceImpl extends EgovAbstractServiceImpl implements ScheduleService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ScheduleServiceImpl.class);

	/** ScheduleMapper */
	@Resource(name = "scheduleMapper")
	private ScheduleMapper scheduleMapper;

	/** ID Generation */
	@Resource(name = "scheduleIdGnrService")
	private EgovIdGnrService scheduleIdGnrService;

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

}
