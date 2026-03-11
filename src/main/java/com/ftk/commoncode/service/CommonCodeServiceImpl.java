package com.ftk.commoncode.service;

import java.util.List;

import com.ftk.commoncode.mapper.CommonCodeMapper;
import com.ftk.commoncode.vo.CommonCodeVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : CommonCodeServiceImpl.java
 * @Description : 공통코드 서비스 구현 클래스
 */
@Service("commonCodeService")
@RequiredArgsConstructor
public class CommonCodeServiceImpl extends EgovAbstractServiceImpl implements CommonCodeService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonCodeServiceImpl.class);

	private final CommonCodeMapper commonCodeMapper;
	private final EgovIdGnrService commonCodeIdGnrService;

	@Override
	public String insertCommonCode(CommonCodeVO vo) throws Exception {
		String id = commonCodeIdGnrService.getNextStringId();
		vo.setCodeId(id);
		commonCodeMapper.insertCommonCode(vo);
		return id;
	}

	@Override
	public void updateCommonCode(CommonCodeVO vo) throws Exception {
		commonCodeMapper.updateCommonCode(vo);
	}

	@Override
	public void deleteCommonCode(CommonCodeVO vo) throws Exception {
		commonCodeMapper.deleteCommonCode(vo);
	}

	@Override
	public CommonCodeVO selectCommonCode(CommonCodeVO vo) throws Exception {
		CommonCodeVO result = commonCodeMapper.selectCommonCode(vo);
		if (result == null) throw processException("info.nodata.msg");
		return result;
	}

	@Override
	public List<CommonCodeVO> selectCommonCodeListByParent(CommonCodeVO vo) {
		return commonCodeMapper.selectCommonCodeListByParent(vo);
	}

	@Override
	public int selectChildCount(String codeId) {
		return commonCodeMapper.selectChildCount(codeId);
	}

}
