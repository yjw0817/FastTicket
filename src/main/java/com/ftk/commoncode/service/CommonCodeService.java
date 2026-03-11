package com.ftk.commoncode.service;

import java.util.List;

import com.ftk.commoncode.vo.CommonCodeVO;

/**
 * @Class Name : CommonCodeService.java
 * @Description : 공통코드 서비스 인터페이스
 */
public interface CommonCodeService {

	String insertCommonCode(CommonCodeVO vo) throws Exception;

	void updateCommonCode(CommonCodeVO vo) throws Exception;

	void deleteCommonCode(CommonCodeVO vo) throws Exception;

	CommonCodeVO selectCommonCode(CommonCodeVO vo) throws Exception;

	List<CommonCodeVO> selectCommonCodeListByParent(CommonCodeVO vo);

	int selectChildCount(String codeId);

}
