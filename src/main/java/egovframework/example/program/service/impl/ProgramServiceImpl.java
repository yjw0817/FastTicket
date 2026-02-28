package egovframework.example.program.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.example.cmmn.service.CommonDefaultVO;
import egovframework.example.program.service.ProgramService;
import egovframework.example.program.service.ProgramVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

/**
 * @Class Name : ProgramServiceImpl.java
 * @Description : 프로그램 서비스 구현 클래스
 */
@Service("programService")
public class ProgramServiceImpl extends EgovAbstractServiceImpl implements ProgramService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ProgramServiceImpl.class);

	/** ProgramMapper */
	@Resource(name = "programMapper")
	private ProgramMapper programMapper;

	/** ID Generation Service */
	@Resource(name = "programIdGnrService")
	private EgovIdGnrService programIdGnrService;

	/**
	 * 프로그램을 등록한다.
	 * @param vo - 등록할 정보가 담긴 ProgramVO
	 * @return 등록된 프로그램ID
	 * @exception Exception
	 */
	@Override
	public String insertProgram(ProgramVO vo) throws Exception {
		LOGGER.debug(vo.toString());

		String id = programIdGnrService.getNextStringId();
		vo.setProgramId(id);
		LOGGER.debug(vo.toString());

		programMapper.insertProgram(vo);
		return id;
	}

	/**
	 * 프로그램을 수정한다.
	 * @param vo - 수정할 정보가 담긴 ProgramVO
	 * @exception Exception
	 */
	@Override
	public void updateProgram(ProgramVO vo) throws Exception {
		programMapper.updateProgram(vo);
	}

	/**
	 * 프로그램을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 ProgramVO
	 * @exception Exception
	 */
	@Override
	public void deleteProgram(ProgramVO vo) throws Exception {
		programMapper.deleteProgram(vo);
	}

	/**
	 * 프로그램을 조회한다.
	 * @param vo - 조회할 정보가 담긴 ProgramVO
	 * @return 조회한 프로그램
	 * @exception Exception
	 */
	@Override
	public ProgramVO selectProgram(ProgramVO vo) throws Exception {
		ProgramVO resultVO = programMapper.selectProgram(vo);
		if (resultVO == null) {
			throw processException("info.nodata.msg");
		}
		return resultVO;
	}

	/**
	 * 프로그램 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 프로그램 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectProgramList(CommonDefaultVO searchVO) throws Exception {
		return programMapper.selectProgramList(searchVO);
	}

	/**
	 * 프로그램 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 프로그램 총 갯수
	 */
	@Override
	public int selectProgramListTotCnt(CommonDefaultVO searchVO) {
		return programMapper.selectProgramListTotCnt(searchVO);
	}

	/**
	 * 사용 중인 프로그램 전체 목록을 조회한다. (콤보박스용)
	 * @return 프로그램 전체 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectProgramListAll() throws Exception {
		return programMapper.selectProgramListAll();
	}

}
