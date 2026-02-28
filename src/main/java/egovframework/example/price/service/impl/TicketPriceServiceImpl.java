package egovframework.example.price.service.impl;

import java.util.List;

import egovframework.example.price.service.TicketPriceService;
import egovframework.example.price.service.TicketPriceVO;
import egovframework.example.cmmn.service.CommonDefaultVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * @Class Name : TicketPriceServiceImpl.java
 * @Description : 티켓가격 서비스 구현 클래스
 */
@Service("ticketPriceService")
public class TicketPriceServiceImpl extends EgovAbstractServiceImpl implements TicketPriceService {

	private static final Logger LOGGER = LoggerFactory.getLogger(TicketPriceServiceImpl.class);

	/** TicketPriceMapper */
	@Resource(name = "ticketPriceMapper")
	private TicketPriceMapper ticketPriceMapper;

	/** ID Generation */
	@Resource(name = "ticketPriceIdGnrService")
	private EgovIdGnrService ticketPriceIdGnrService;

	/**
	 * 티켓가격을 등록한다.
	 * @param vo - 등록할 정보가 담긴 TicketPriceVO
	 * @return 등록된 가격ID
	 * @exception Exception
	 */
	@Override
	public String insertTicketPrice(TicketPriceVO vo) throws Exception {
		LOGGER.debug(vo.toString());
		String id = ticketPriceIdGnrService.getNextStringId();
		vo.setPriceId(id);
		LOGGER.debug(vo.toString());
		ticketPriceMapper.insertTicketPrice(vo);
		return id;
	}

	/**
	 * 티켓가격을 수정한다.
	 * @param vo - 수정할 정보가 담긴 TicketPriceVO
	 * @exception Exception
	 */
	@Override
	public void updateTicketPrice(TicketPriceVO vo) throws Exception {
		ticketPriceMapper.updateTicketPrice(vo);
	}

	/**
	 * 티켓가격을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 TicketPriceVO
	 * @exception Exception
	 */
	@Override
	public void deleteTicketPrice(TicketPriceVO vo) throws Exception {
		ticketPriceMapper.deleteTicketPrice(vo);
	}

	/**
	 * 티켓가격을 조회한다.
	 * @param vo - 조회할 정보가 담긴 TicketPriceVO
	 * @return 조회한 티켓가격
	 * @exception Exception
	 */
	@Override
	public TicketPriceVO selectTicketPrice(TicketPriceVO vo) throws Exception {
		TicketPriceVO resultVO = ticketPriceMapper.selectTicketPrice(vo);
		if (resultVO == null)
			throw processException("info.nodata.msg");
		return resultVO;
	}

	/**
	 * 티켓가격 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 티켓가격 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectTicketPriceList(CommonDefaultVO searchVO) throws Exception {
		return ticketPriceMapper.selectTicketPriceList(searchVO);
	}

	/**
	 * 티켓가격 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 티켓가격 총 갯수
	 */
	@Override
	public int selectTicketPriceListTotCnt(CommonDefaultVO searchVO) {
		return ticketPriceMapper.selectTicketPriceListTotCnt(searchVO);
	}

	/**
	 * 특정 프로그램의 티켓가격 목록을 조회한다.
	 * @param vo - 프로그램ID가 담긴 TicketPriceVO
	 * @return 티켓가격 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectTicketPriceListByProgram(TicketPriceVO vo) throws Exception {
		return ticketPriceMapper.selectTicketPriceListByProgram(vo);
	}

}
