package com.ftk.commoncode.mapper;

import java.util.List;

import com.ftk.commoncode.vo.CommonCodeVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Class Name : CommonCodeMapper.java
 * @Description : 공통코드 MyBatis Mapper 인터페이스
 */
@Mapper("commonCodeMapper")
public interface CommonCodeMapper {

	void insertCommonCode(CommonCodeVO vo) throws Exception;

	void updateCommonCode(CommonCodeVO vo) throws Exception;

	void deleteCommonCode(CommonCodeVO vo) throws Exception;

	CommonCodeVO selectCommonCode(CommonCodeVO vo) throws Exception;

	/** 특정 depth + parentId 기준 목록 조회 */
	List<CommonCodeVO> selectCommonCodeListByParent(CommonCodeVO vo);

	/** 하위 코드 존재 여부 확인 */
	int selectChildCount(String codeId);

}
