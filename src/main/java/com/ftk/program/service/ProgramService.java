package com.ftk.program.service;

import java.util.List;

import com.ftk.common.vo.CommonDefaultVO;
import com.ftk.program.vo.ProgramVO;
import com.ftk.program.vo.ProgramTicketTypeVO;
import com.ftk.program.vo.ProgramDiscountVO;

/**
 * @Class Name : ProgramService.java
 * @Description : 프로그램 서비스 인터페이스
 */
public interface ProgramService {

	/**
	 * 프로그램을 등록한다.
	 * @param vo - 등록할 정보가 담긴 ProgramVO
	 * @return 등록된 프로그램ID
	 * @exception Exception
	 */
	String insertProgram(ProgramVO vo) throws Exception;

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

	List<?> selectProgramListAllByType(String programType) throws Exception;

	/** 프로그램에 매핑된 권종 ID 목록 조회 */
	List<String> selectProgramTicketTypeIds(String programId);

	/** 프로그램별 권종+기본가격 목록 조회 */
	List<ProgramTicketTypeVO> selectProgramTicketTypes(String programId);

	/** 프로그램별 할인 목록 조회 */
	List<ProgramDiscountVO> selectProgramDiscounts(String programId);

	/** 기존 템플릿 데이터를 JSON 문자열로 반환 */
	String buildTemplateJson(String programId) throws Exception;

}
