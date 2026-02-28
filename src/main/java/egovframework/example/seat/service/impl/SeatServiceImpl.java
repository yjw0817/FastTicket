package egovframework.example.seat.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.example.cmmn.service.CommonDefaultVO;
import egovframework.example.seat.service.SeatService;
import egovframework.example.seat.service.SeatVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

/**
 * @Class Name : SeatServiceImpl.java
 * @Description : 좌석 서비스 구현 클래스
 */
@Service("seatService")
public class SeatServiceImpl extends EgovAbstractServiceImpl implements SeatService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SeatServiceImpl.class);

	/** SeatMapper */
	@Resource(name = "seatMapper")
	private SeatMapper seatMapper;

	/** ID Generation Service */
	@Resource(name = "seatIdGnrService")
	private EgovIdGnrService seatIdGnrService;

	/**
	 * 좌석을 등록한다.
	 * @param vo - 등록할 정보가 담긴 SeatVO
	 * @return 등록된 좌석ID
	 * @exception Exception
	 */
	@Override
	public String insertSeat(SeatVO vo) throws Exception {
		LOGGER.debug(vo.toString());

		String id = seatIdGnrService.getNextStringId();
		vo.setSeatId(id);
		LOGGER.debug(vo.toString());

		seatMapper.insertSeat(vo);
		return id;
	}

	/**
	 * 좌석을 수정한다.
	 * @param vo - 수정할 정보가 담긴 SeatVO
	 * @exception Exception
	 */
	@Override
	public void updateSeat(SeatVO vo) throws Exception {
		seatMapper.updateSeat(vo);
	}

	/**
	 * 좌석을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 SeatVO
	 * @exception Exception
	 */
	@Override
	public void deleteSeat(SeatVO vo) throws Exception {
		seatMapper.deleteSeat(vo);
	}

	/**
	 * 좌석을 조회한다.
	 * @param vo - 조회할 정보가 담긴 SeatVO
	 * @return 조회한 좌석
	 * @exception Exception
	 */
	@Override
	public SeatVO selectSeat(SeatVO vo) throws Exception {
		SeatVO resultVO = seatMapper.selectSeat(vo);
		if (resultVO == null) {
			throw processException("info.nodata.msg");
		}
		return resultVO;
	}

	/**
	 * 좌석 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 좌석 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectSeatList(CommonDefaultVO searchVO) throws Exception {
		return seatMapper.selectSeatList(searchVO);
	}

	/**
	 * 좌석 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 좌석 총 갯수
	 */
	@Override
	public int selectSeatListTotCnt(CommonDefaultVO searchVO) {
		return seatMapper.selectSeatListTotCnt(searchVO);
	}

}
