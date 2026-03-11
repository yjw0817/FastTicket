package com.ftk.tickettype.service;

import java.util.List;

import com.ftk.tickettype.mapper.TicketTypeMapper;
import com.ftk.tickettype.vo.TicketTypeVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : TicketTypeServiceImpl.java
 * @Description : 권종 서비스 구현 클래스
 */
@Service("ticketTypeService")
@RequiredArgsConstructor
public class TicketTypeServiceImpl extends EgovAbstractServiceImpl implements TicketTypeService {

	private static final Logger LOGGER = LoggerFactory.getLogger(TicketTypeServiceImpl.class);

	private final TicketTypeMapper ticketTypeMapper;

	private final EgovIdGnrService ticketTypeIdGnrService;

	@Override
	public String insertTicketType(TicketTypeVO vo) throws Exception {
		LOGGER.debug(vo.toString());
		String id = ticketTypeIdGnrService.getNextStringId();
		vo.setTypeId(id);
		ticketTypeMapper.insertTicketType(vo);
		return id;
	}

	@Override
	public void updateTicketType(TicketTypeVO vo) throws Exception {
		ticketTypeMapper.updateTicketType(vo);
	}

	@Override
	public void deleteTicketType(TicketTypeVO vo) throws Exception {
		ticketTypeMapper.deleteTicketType(vo);
	}

	@Override
	public TicketTypeVO selectTicketType(TicketTypeVO vo) throws Exception {
		TicketTypeVO resultVO = ticketTypeMapper.selectTicketType(vo);
		if (resultVO == null)
			throw processException("info.nodata.msg");
		return resultVO;
	}

	@Override
	public List<?> selectTicketTypeList(CommonDefaultVO searchVO) throws Exception {
		return ticketTypeMapper.selectTicketTypeList(searchVO);
	}

	@Override
	public int selectTicketTypeListTotCnt(CommonDefaultVO searchVO) {
		return ticketTypeMapper.selectTicketTypeListTotCnt(searchVO);
	}

	@Override
	public List<TicketTypeVO> selectTicketTypeListAll() throws Exception {
		return ticketTypeMapper.selectTicketTypeListAll();
	}

}
