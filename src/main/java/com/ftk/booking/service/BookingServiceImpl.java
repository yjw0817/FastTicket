package com.ftk.booking.service;

import com.ftk.booking.mapper.BookingMapper;
import com.ftk.booking.mapper.BookingDetailMapper;

import java.util.List;

import com.ftk.booking.vo.BookingDetailVO;
import com.ftk.booking.service.BookingService;
import com.ftk.booking.vo.BookingVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : BookingServiceImpl.java
 * @Description : 예매 서비스 구현 클래스
 */
@Service("bookingService")
@RequiredArgsConstructor
public class BookingServiceImpl extends EgovAbstractServiceImpl implements BookingService {

	private static final Logger LOGGER = LoggerFactory.getLogger(BookingServiceImpl.class);

	/** BookingMapper */
	private final BookingMapper bookingMapper;

	/** BookingDetailMapper */
	private final BookingDetailMapper bookingDetailMapper;

	/** 예매 ID 생성 서비스 */
	private final EgovIdGnrService bookingIdGnrService;

	/** 예매상세 ID 생성 서비스 */
	private final EgovIdGnrService bookingDetailIdGnrService;

	/**
	 * 예매를 등록한다. (예매상세 포함 일괄 저장)
	 * - 예매 ID 채번 후 BOOKING 테이블 INSERT
	 * - bookingDetails 목록을 순회하며 qty > 0인 항목에 대해 BOOKING_DETAIL INSERT
	 * @param vo - 등록할 정보가 담긴 BookingVO (bookingDetails 포함)
	 * @return 등록된 예매ID
	 * @exception Exception
	 */
	@Override
	public String insertBooking(BookingVO vo) throws Exception {
		LOGGER.debug(vo.toString());

		// 수량 검증: 1매 이상 선택 필수
		List<BookingDetailVO> details = vo.getBookingDetails();
		int preCheckQty = 0;
		if (details != null) {
			for (BookingDetailVO d : details) {
				preCheckQty += d.getQty();
			}
		}
		if (preCheckQty <= 0) {
			throw new IllegalArgumentException("1매 이상 선택해 주세요.");
		}

		String bookingId = bookingIdGnrService.getNextStringId();
		vo.setBookingId(bookingId);

		// 기본 상태값 설정
		if (vo.getBookingStatus() == null || vo.getBookingStatus().isEmpty()) {
			vo.setBookingStatus("RESERVED");
		}
		if (vo.getPaymentStatus() == null || vo.getPaymentStatus().isEmpty()) {
			vo.setPaymentStatus("PENDING");
		}

		bookingMapper.insertBooking(vo);

		// 예매상세 등록
		if (details != null) {
			int totalQty = 0;
			int totalAmt = 0;
			for (BookingDetailVO detail : details) {
				if (detail.getQty() <= 0) {
					continue;
				}
				// qty 수만큼 개별 BOOKING_DETAIL 레코드 생성
				for (int i = 0; i < detail.getQty(); i++) {
					String detailId = bookingDetailIdGnrService.getNextStringId();
					detail.setDetailId(detailId);
					detail.setBookingId(bookingId);
					if (detail.getCancelYn() == null || detail.getCancelYn().isEmpty()) {
						detail.setCancelYn("N");
					}
					bookingDetailMapper.insertBookingDetail(detail);
					totalAmt += detail.getTicketAmt();
				}
				totalQty += detail.getQty();
			}
			// 총수량, 총금액 업데이트
			vo.setTotalQty(totalQty);
			vo.setTotalAmt(totalAmt);
			bookingMapper.updateBooking(vo);
		}

		return bookingId;
	}

	/**
	 * 예매를 수정한다. (예매상태, 결제상태 변경)
	 * @param vo - 수정할 정보가 담긴 BookingVO
	 * @exception Exception
	 */
	@Override
	public void updateBooking(BookingVO vo) throws Exception {
		bookingMapper.updateBooking(vo);
	}

	/**
	 * 예매를 삭제한다. (예매상세 먼저 삭제 후 예매 삭제)
	 * @param vo - 삭제할 정보가 담긴 BookingVO
	 * @exception Exception
	 */
	@Override
	public void deleteBooking(BookingVO vo) throws Exception {
		BookingDetailVO detailVO = new BookingDetailVO();
		detailVO.setBookingId(vo.getBookingId());
		bookingDetailMapper.deleteBookingDetailByBooking(detailVO);
		bookingMapper.deleteBooking(vo);
	}

	/**
	 * 예매를 조회한다. (예매상세 목록 포함)
	 * @param vo - 조회할 정보가 담긴 BookingVO
	 * @return 조회한 예매 (bookingDetails 포함)
	 * @exception Exception
	 */
	@Override
	public BookingVO selectBooking(BookingVO vo) throws Exception {
		BookingVO resultVO = bookingMapper.selectBooking(vo);
		if (resultVO == null) {
			throw processException("info.nodata.msg");
		}
		// 예매상세 목록 조회 후 세팅
		BookingDetailVO detailVO = new BookingDetailVO();
		detailVO.setBookingId(resultVO.getBookingId());
		List<?> detailList = bookingDetailMapper.selectBookingDetailList(detailVO);
		resultVO.setBookingDetails(null);
		// 상세 목록을 VO에 담을 때 타입 안전성을 위해 새 목록 생성
		java.util.List<BookingDetailVO> typedList = new java.util.ArrayList<BookingDetailVO>();
		for (Object obj : detailList) {
			if (obj instanceof BookingDetailVO) {
				typedList.add((BookingDetailVO) obj);
			}
		}
		resultVO.setBookingDetails(typedList);
		return resultVO;
	}

	/**
	 * 예매 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 예매 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectBookingList(CommonDefaultVO searchVO) throws Exception {
		return bookingMapper.selectBookingList(searchVO);
	}

	/**
	 * 예매 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 예매 총 갯수
	 */
	@Override
	public int selectBookingListTotCnt(CommonDefaultVO searchVO) {
		return bookingMapper.selectBookingListTotCnt(searchVO);
	}

}
