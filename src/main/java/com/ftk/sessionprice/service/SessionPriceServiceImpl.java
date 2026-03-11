package com.ftk.sessionprice.service;

import java.util.List;

import com.ftk.sessionprice.mapper.SessionPriceMapper;
import com.ftk.sessionprice.vo.SessionPriceVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : SessionPriceServiceImpl.java
 * @Description : 회차별 가격 서비스 구현 클래스
 */
@Service("sessionPriceService")
@RequiredArgsConstructor
public class SessionPriceServiceImpl extends EgovAbstractServiceImpl implements SessionPriceService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SessionPriceServiceImpl.class);

	private final SessionPriceMapper sessionPriceMapper;

	private final EgovIdGnrService sessionPriceIdGnrService;

	@Override
	public String insertSessionPrice(SessionPriceVO vo) throws Exception {
		LOGGER.debug(vo.toString());
		String id = sessionPriceIdGnrService.getNextStringId();
		vo.setSpriceId(id);
		sessionPriceMapper.insertSessionPrice(vo);
		return id;
	}

	@Override
	public void updateSessionPrice(SessionPriceVO vo) throws Exception {
		sessionPriceMapper.updateSessionPrice(vo);
	}

	@Override
	public void deleteSessionPrice(SessionPriceVO vo) throws Exception {
		sessionPriceMapper.deleteSessionPrice(vo);
	}

	@Override
	public SessionPriceVO selectSessionPrice(SessionPriceVO vo) throws Exception {
		SessionPriceVO resultVO = sessionPriceMapper.selectSessionPrice(vo);
		if (resultVO == null)
			throw processException("info.nodata.msg");
		return resultVO;
	}

	@Override
	public List<?> selectSessionPriceList(CommonDefaultVO searchVO) throws Exception {
		return sessionPriceMapper.selectSessionPriceList(searchVO);
	}

	@Override
	public int selectSessionPriceListTotCnt(CommonDefaultVO searchVO) {
		return sessionPriceMapper.selectSessionPriceListTotCnt(searchVO);
	}

	@Override
	public List<?> selectSessionPriceListBySchedule(SessionPriceVO vo) throws Exception {
		return sessionPriceMapper.selectSessionPriceListBySchedule(vo);
	}

	@Override
	public void deleteSessionPriceBySchedule(SessionPriceVO vo) throws Exception {
		sessionPriceMapper.deleteSessionPriceBySchedule(vo);
	}

}
