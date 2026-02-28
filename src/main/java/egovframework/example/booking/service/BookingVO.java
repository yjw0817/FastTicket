package egovframework.example.booking.service;

import java.util.List;

import egovframework.example.cmmn.service.CommonDefaultVO;

/**
 * @Class Name : BookingVO.java
 * @Description : 예매 VO Class
 */
public class BookingVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** 예매ID */
	private String bookingId;

	/** 공연일정ID */
	private String scheduleId;

	/** 회원ID (비회원 예매 시 null) */
	private String memberId;

	/** 예매자명 */
	private String bookerNm;

	/** 예매자 연락처 */
	private String bookerTel;

	/** 예매자 이메일 */
	private String bookerEmail;

	/** 총 수량 */
	private int totalQty;

	/** 총 금액 */
	private int totalAmt;

	/** 예매상태 (RESERVED/CANCELED/COMPLETED) */
	private String bookingStatus;

	/** 결제상태 (PENDING/PAID/REFUNDED) */
	private String paymentStatus;

	/** 등록일시 */
	private String regDt;

	/* ======================== 조인 표시용 필드 ======================== */

	/** 프로그램명 (조인) */
	private String programNm;

	/** 공연일자 (조인) */
	private String eventDate;

	/** 공연시간 (조인) */
	private String eventTime;

	/** 공연장명 (조인) */
	private String venueNm;

	/* ======================== 폼 제출용 필드 ======================== */

	/** 예매상세 목록 (등록 시 복수 상세 일괄 제출용) */
	private List<BookingDetailVO> bookingDetails;

	public String getBookingId() {
		return bookingId;
	}

	public void setBookingId(String bookingId) {
		this.bookingId = bookingId;
	}

	public String getScheduleId() {
		return scheduleId;
	}

	public void setScheduleId(String scheduleId) {
		this.scheduleId = scheduleId;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public String getBookerNm() {
		return bookerNm;
	}

	public void setBookerNm(String bookerNm) {
		this.bookerNm = bookerNm;
	}

	public String getBookerTel() {
		return bookerTel;
	}

	public void setBookerTel(String bookerTel) {
		this.bookerTel = bookerTel;
	}

	public String getBookerEmail() {
		return bookerEmail;
	}

	public void setBookerEmail(String bookerEmail) {
		this.bookerEmail = bookerEmail;
	}

	public int getTotalQty() {
		return totalQty;
	}

	public void setTotalQty(int totalQty) {
		this.totalQty = totalQty;
	}

	public int getTotalAmt() {
		return totalAmt;
	}

	public void setTotalAmt(int totalAmt) {
		this.totalAmt = totalAmt;
	}

	public String getBookingStatus() {
		return bookingStatus;
	}

	public void setBookingStatus(String bookingStatus) {
		this.bookingStatus = bookingStatus;
	}

	public String getPaymentStatus() {
		return paymentStatus;
	}

	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}

	public String getRegDt() {
		return regDt;
	}

	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}

	public String getProgramNm() {
		return programNm;
	}

	public void setProgramNm(String programNm) {
		this.programNm = programNm;
	}

	public String getEventDate() {
		return eventDate;
	}

	public void setEventDate(String eventDate) {
		this.eventDate = eventDate;
	}

	public String getEventTime() {
		return eventTime;
	}

	public void setEventTime(String eventTime) {
		this.eventTime = eventTime;
	}

	public String getVenueNm() {
		return venueNm;
	}

	public void setVenueNm(String venueNm) {
		this.venueNm = venueNm;
	}

	public List<BookingDetailVO> getBookingDetails() {
		return bookingDetails;
	}

	public void setBookingDetails(List<BookingDetailVO> bookingDetails) {
		this.bookingDetails = bookingDetails;
	}

}
