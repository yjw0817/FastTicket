package com.ftk.tickettype.mapper;

import java.util.List;

import com.ftk.tickettype.vo.TicketTypeVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Class Name : TicketTypeMapper.java
 * @Description : 권종 MyBatis Mapper 인터페이스
 */
@Mapper("ticketTypeMapper")
public interface TicketTypeMapper {

	void insertTicketType(TicketTypeVO vo) throws Exception;

	void updateTicketType(TicketTypeVO vo) throws Exception;

	void deleteTicketType(TicketTypeVO vo) throws Exception;

	TicketTypeVO selectTicketType(TicketTypeVO vo) throws Exception;

	List<?> selectTicketTypeList(CommonDefaultVO searchVO) throws Exception;

	int selectTicketTypeListTotCnt(CommonDefaultVO searchVO);

	/** 사용중인 전체 권종 목록 (드롭다운/가격설정용) */
	List<TicketTypeVO> selectTicketTypeListAll() throws Exception;

	/** 권종명 중복 체크 (0=없음, 1이상=중복) */
	int selectTicketTypeByName(TicketTypeVO vo);

}
