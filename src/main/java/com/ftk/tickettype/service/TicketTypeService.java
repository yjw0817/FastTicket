package com.ftk.tickettype.service;

import java.util.List;

import com.ftk.tickettype.vo.TicketTypeVO;
import com.ftk.common.vo.CommonDefaultVO;

/**
 * @Class Name : TicketTypeService.java
 * @Description : 권종 서비스 인터페이스
 */
public interface TicketTypeService {

	String insertTicketType(TicketTypeVO vo) throws Exception;

	void updateTicketType(TicketTypeVO vo) throws Exception;

	void deleteTicketType(TicketTypeVO vo) throws Exception;

	TicketTypeVO selectTicketType(TicketTypeVO vo) throws Exception;

	List<?> selectTicketTypeList(CommonDefaultVO searchVO) throws Exception;

	int selectTicketTypeListTotCnt(CommonDefaultVO searchVO);

	List<TicketTypeVO> selectTicketTypeListAll() throws Exception;

}
