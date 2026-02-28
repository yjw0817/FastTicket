package egovframework.example.seat.service;

import java.util.List;

import egovframework.example.cmmn.service.CommonDefaultVO;

/**
 * @Class Name : SeatService.java
 * @Description : 좌석 서비스 인터페이스
 */
public interface SeatService {

	/**
	 * 좌석을 등록한다.
	 * @param vo - 등록할 정보가 담긴 SeatVO
	 * @return 등록된 좌석ID
	 * @exception Exception
	 */
	String insertSeat(SeatVO vo) throws Exception;

	/**
	 * 좌석을 수정한다.
	 * @param vo - 수정할 정보가 담긴 SeatVO
	 * @exception Exception
	 */
	void updateSeat(SeatVO vo) throws Exception;

	/**
	 * 좌석을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 SeatVO
	 * @exception Exception
	 */
	void deleteSeat(SeatVO vo) throws Exception;

	/**
	 * 좌석을 조회한다.
	 * @param vo - 조회할 정보가 담긴 SeatVO
	 * @return 조회한 좌석
	 * @exception Exception
	 */
	SeatVO selectSeat(SeatVO vo) throws Exception;

	/**
	 * 좌석 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 좌석 목록
	 * @exception Exception
	 */
	List<?> selectSeatList(CommonDefaultVO searchVO) throws Exception;

	/**
	 * 좌석 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 좌석 총 갯수
	 */
	int selectSeatListTotCnt(CommonDefaultVO searchVO);

}
