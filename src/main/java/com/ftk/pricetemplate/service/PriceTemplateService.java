package com.ftk.pricetemplate.service;

import java.util.List;
import java.util.Map;

import com.ftk.pricetemplate.vo.SessionTemplateVO;
import com.ftk.pricetemplate.vo.PriceTemplateVO;

/**
 * 가격 템플릿 서비스 인터페이스
 */
public interface PriceTemplateService {

	/** 회차 템플릿 조회 (프로그램+dayType) */
	List<SessionTemplateVO> selectSessionTemplates(String programId, String dayType);

	/** 가격 템플릿 조회 (프로그램+dayType) */
	List<PriceTemplateVO> selectPriceTemplates(String programId, String dayType);

	/** 가격 템플릿 단건 수정 */
	void updatePriceTemplate(PriceTemplateVO vo);

	/** 회차 활성/비활성 토글 */
	void updateSessionTemplateEnabled(SessionTemplateVO vo);

	/** 일괄 가격 조정 (평일 대비 +/- 금액) */
	void applyBulkPriceAdjust(String programId, String dayType, int adjustAmount);

	/** 템플릿 데이터 맵 조회 (화면 렌더링용) */
	Map<String, Object> selectTemplateData(String programId, String dayType);

}
