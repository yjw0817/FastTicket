package egovframework.example.price.service;

import java.util.List;

import egovframework.example.cmmn.service.CommonDefaultVO;

/**
 * @Class Name : TicketPriceService.java
 * @Description : 티켓가격 서비스 인터페이스
 */
public interface TicketPriceService {

	/**
	 * 티켓가격을 등록한다.
	 * @param vo - 등록할 정보가 담긴 TicketPriceVO
	 * @return 등록된 가격ID
	 * @exception Exception
	 */
	String insertTicketPrice(TicketPriceVO vo) throws Exception;

	/**
	 * 티켓가격을 수정한다.
	 * @param vo - 수정할 정보가 담긴 TicketPriceVO
	 * @exception Exception
	 */
	void updateTicketPrice(TicketPriceVO vo) throws Exception;

	/**
	 * 티켓가격을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 TicketPriceVO
	 * @exception Exception
	 */
	void deleteTicketPrice(TicketPriceVO vo) throws Exception;

	/**
	 * 티켓가격을 조회한다.
	 * @param vo - 조회할 정보가 담긴 TicketPriceVO
	 * @return 조회한 티켓가격
	 * @exception Exception
	 */
	TicketPriceVO selectTicketPrice(TicketPriceVO vo) throws Exception;

	/**
	 * 티켓가격 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 티켓가격 목록
	 * @exception Exception
	 */
	List<?> selectTicketPriceList(CommonDefaultVO searchVO) throws Exception;

	/**
	 * 티켓가격 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 티켓가격 총 갯수
	 */
	int selectTicketPriceListTotCnt(CommonDefaultVO searchVO);

	/**
	 * 특정 프로그램의 티켓가격 목록을 조회한다.
	 * @param vo - 프로그램ID가 담긴 TicketPriceVO
	 * @return 티켓가격 목록
	 * @exception Exception
	 */
	List<?> selectTicketPriceListByProgram(TicketPriceVO vo) throws Exception;

}
