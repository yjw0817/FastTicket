package com.ftk.pricetemplate.mapper;

import java.util.List;
import java.util.Map;

import com.ftk.pricetemplate.vo.SessionTemplateVO;
import com.ftk.pricetemplate.vo.PriceTemplateVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * 가격 템플릿 MyBatis Mapper
 */
@Mapper("priceTemplateMapper")
public interface PriceTemplateMapper {

	/** 회차 템플릿 목록 조회 */
	List<SessionTemplateVO> selectSessionTemplates(Map<String, Object> param);

	/** 가격 템플릿 목록 조회 */
	List<PriceTemplateVO> selectPriceTemplates(Map<String, Object> param);

	/** 가격 템플릿 단건 수정 */
	void updatePriceTemplate(PriceTemplateVO vo);

	/** 회차 템플릿 활성/비활성 수정 */
	void updateSessionTemplateEnabled(SessionTemplateVO vo);

	/** 가격 템플릿 일괄 업데이트 (dayType별) */
	void updatePriceTemplateBulk(Map<String, Object> param);

}
