package com.ftk.sessionprice.service;

import java.util.List;

import com.ftk.sessionprice.vo.SessionPriceVO;
import com.ftk.common.vo.CommonDefaultVO;

/**
 * @Class Name : SessionPriceService.java
 * @Description : 회차별 가격 서비스 인터페이스
 */
public interface SessionPriceService {

	String insertSessionPrice(SessionPriceVO vo) throws Exception;

	void updateSessionPrice(SessionPriceVO vo) throws Exception;

	void deleteSessionPrice(SessionPriceVO vo) throws Exception;

	SessionPriceVO selectSessionPrice(SessionPriceVO vo) throws Exception;

	List<?> selectSessionPriceList(CommonDefaultVO searchVO) throws Exception;

	int selectSessionPriceListTotCnt(CommonDefaultVO searchVO);

	List<?> selectSessionPriceListBySchedule(SessionPriceVO vo) throws Exception;

	/** 회차가격 전체 삭제 후 재등록 */
	void deleteSessionPriceBySchedule(SessionPriceVO vo) throws Exception;

}
