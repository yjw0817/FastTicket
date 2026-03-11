package com.ftk.pricetemplate.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.ftk.pricetemplate.mapper.PriceTemplateMapper;
import com.ftk.pricetemplate.vo.SessionTemplateVO;
import com.ftk.pricetemplate.vo.PriceTemplateVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

import lombok.RequiredArgsConstructor;

/**
 * 가격 템플릿 서비스 구현
 */
@Service("priceTemplateService")
@RequiredArgsConstructor
public class PriceTemplateServiceImpl extends EgovAbstractServiceImpl implements PriceTemplateService {

	private final PriceTemplateMapper priceTemplateMapper;

	@Override
	public List<SessionTemplateVO> selectSessionTemplates(String programId, String dayType) {
		Map<String, Object> param = new HashMap<>();
		param.put("programId", programId);
		param.put("dayType", dayType);
		return priceTemplateMapper.selectSessionTemplates(param);
	}

	@Override
	public List<PriceTemplateVO> selectPriceTemplates(String programId, String dayType) {
		Map<String, Object> param = new HashMap<>();
		param.put("programId", programId);
		param.put("dayType", dayType);
		return priceTemplateMapper.selectPriceTemplates(param);
	}

	@Override
	public void updatePriceTemplate(PriceTemplateVO vo) {
		priceTemplateMapper.updatePriceTemplate(vo);
	}

	@Override
	public void updateSessionTemplateEnabled(SessionTemplateVO vo) {
		priceTemplateMapper.updateSessionTemplateEnabled(vo);
	}

	@Override
	public void applyBulkPriceAdjust(String programId, String dayType, int adjustAmount) {
		Map<String, Object> param = new HashMap<>();
		param.put("programId", programId);
		param.put("dayType", dayType);
		param.put("adjustAmount", adjustAmount);
		priceTemplateMapper.updatePriceTemplateBulk(param);
	}

	@Override
	public Map<String, Object> selectTemplateData(String programId, String dayType) {
		Map<String, Object> result = new HashMap<>();
		result.put("sessions", selectSessionTemplates(programId, dayType));
		result.put("prices", selectPriceTemplates(programId, dayType));
		return result;
	}

}
