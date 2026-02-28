package egovframework.example.program.service.impl;

import java.util.List;

import egovframework.example.program.service.ProgramVO;
import egovframework.example.cmmn.service.CommonDefaultVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Class Name : ProgramMapper.java
 * @Description : 프로그램 MyBatis Mapper 인터페이스
 */
@Mapper("programMapper")
public interface ProgramMapper {

	/**
	 * 프로그램을 등록한다.
	 * @param vo - 등록할 정보가 담긴 ProgramVO
	 * @exception Exception
	 */
	void insertProgram(ProgramVO vo) throws Exception;

	/**
	 * 프로그램을 수정한다.
	 * @param vo - 수정할 정보가 담긴 ProgramVO
	 * @exception Exception
	 */
	void updateProgram(ProgramVO vo) throws Exception;

	/**
	 * 프로그램을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 ProgramVO
	 * @exception Exception
	 */
	void deleteProgram(ProgramVO vo) throws Exception;

	/**
	 * 프로그램을 조회한다.
	 * @param vo - 조회할 정보가 담긴 ProgramVO
	 * @return 조회한 프로그램
	 * @exception Exception
	 */
	ProgramVO selectProgram(ProgramVO vo) throws Exception;

	/**
	 * 프로그램 목록을 조회한다. (페이징)
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 프로그램 목록
	 * @exception Exception
	 */
	List<?> selectProgramList(CommonDefaultVO searchVO) throws Exception;

	/**
	 * 프로그램 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 프로그램 총 갯수
	 */
	int selectProgramListTotCnt(CommonDefaultVO searchVO);

	/**
	 * 사용 중인 프로그램 전체 목록을 조회한다. (콤보박스용)
	 * @return 프로그램 전체 목록
	 * @exception Exception
	 */
	List<?> selectProgramListAll() throws Exception;

}
