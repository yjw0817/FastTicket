package com.ftk.program.mapper;

import java.util.List;
import java.util.Map;

import com.ftk.program.vo.ProgramVO;
import com.ftk.program.vo.ProgramTicketTypeVO;
import com.ftk.program.vo.ProgramDiscountVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

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

	List<?> selectProgramListAllByType(String programType) throws Exception;

	/** 프로그램-권종 매핑 저장 (기본가격 포함) */
	void insertProgramTicketType(ProgramTicketTypeVO vo);

	/** 프로그램-권종 매핑 삭제 */
	void deleteProgramTicketTypes(String programId);

	/** 프로그램에 매핑된 권종 ID 목록 조회 */
	List<String> selectProgramTicketTypeIds(String programId);

	/** 프로그램별 권종+기본가격 목록 조회 */
	List<ProgramTicketTypeVO> selectProgramTicketTypes(String programId);

	/** 프로그램별 할인 등록 */
	void insertProgramDiscount(ProgramDiscountVO vo);

	/** 프로그램별 할인 삭제 (전체) */
	void deleteProgramDiscounts(String programId);

	/** 프로그램별 할인 목록 조회 */
	List<ProgramDiscountVO> selectProgramDiscounts(String programId);

	/** 회차 템플릿 저장 */
	void insertSessionTemplate(Map<String, Object> param);

	/** 회차 템플릿 삭제 (프로그램 전체) */
	void deleteSessionTemplates(String programId);

	/** 가격 템플릿 저장 */
	void insertPriceTemplate(Map<String, Object> param);

	/** 가격 템플릿 삭제 (프로그램 전체) */
	void deletePriceTemplates(String programId);

	/** 회차 템플릿 조회 */
	List<Map<String, Object>> selectSessionTemplates(String programId);

	/** 가격 템플릿 조회 */
	List<Map<String, Object>> selectPriceTemplates(String programId);

}
