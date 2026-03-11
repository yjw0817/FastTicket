package com.ftk.sessionprice.mapper;

import java.util.List;

import com.ftk.sessionprice.vo.SessionPriceVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Class Name : SessionPriceMapper.java
 * @Description : 회차별 가격 MyBatis Mapper 인터페이스
 */
@Mapper("sessionPriceMapper")
public interface SessionPriceMapper {

	void insertSessionPrice(SessionPriceVO vo) throws Exception;

	void updateSessionPrice(SessionPriceVO vo) throws Exception;

	void deleteSessionPrice(SessionPriceVO vo) throws Exception;

	SessionPriceVO selectSessionPrice(SessionPriceVO vo) throws Exception;

	List<?> selectSessionPriceList(CommonDefaultVO searchVO) throws Exception;

	int selectSessionPriceListTotCnt(CommonDefaultVO searchVO);

	/** 특정 회차의 가격 목록 (권종별) */
	List<?> selectSessionPriceListBySchedule(SessionPriceVO vo) throws Exception;

	/** 회차가격 일괄 등록 */
	void insertSessionPriceBatch(SessionPriceVO vo) throws Exception;

	/** 특정 회차의 가격 전체 삭제 */
	void deleteSessionPriceBySchedule(SessionPriceVO vo) throws Exception;

}
