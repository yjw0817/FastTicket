package com.ftk.booking.vo;

import java.io.Serializable;

/**
 * @Class Name : BookingDetailVO.java
 * @Description : 예매상세 VO Class
 */
public class BookingDetailVO implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 상세ID */
	private String detailId;

	/** 예매ID */
	private String bookingId;

	/** 가격ID */
	private String priceId;

	/** 좌석ID (지정석인 경우) */
	private String seatId;

	/** 티켓금액 */
	private int ticketAmt;

	/** 취소여부 */
	private String cancelYn;

	/* ======================== 조인 표시용 필드 ======================== */

	/** 가격명 (조인) */
	private String priceNm;

	/** 가격유형 (조인) */
	private String priceType;

	/** 단가 (조인) */
	private int price;

	/** 좌석 열 (조인) */
	private String seatRow;

	/** 좌석 번호 (조인) */
	private int seatNo;

	/* ======================== 폼 입력용 필드 (DB 저장 안 함) ======================== */

	/** 수량 입력 필드 (화면에서 수량 입력 시 사용, DB 미저장) */
	private int qty;

	public String getDetailId() {
		return detailId;
	}

	public void setDetailId(String detailId) {
		this.detailId = detailId;
	}

	public String getBookingId() {
		return bookingId;
	}

	public void setBookingId(String bookingId) {
		this.bookingId = bookingId;
	}

	public String getPriceId() {
		return priceId;
	}

	public void setPriceId(String priceId) {
		this.priceId = priceId;
	}

	public String getSeatId() {
		return seatId;
	}

	public void setSeatId(String seatId) {
		this.seatId = seatId;
	}

	public int getTicketAmt() {
		return ticketAmt;
	}

	public void setTicketAmt(int ticketAmt) {
		this.ticketAmt = ticketAmt;
	}

	public String getCancelYn() {
		return cancelYn;
	}

	public void setCancelYn(String cancelYn) {
		this.cancelYn = cancelYn;
	}

	public String getPriceNm() {
		return priceNm;
	}

	public void setPriceNm(String priceNm) {
		this.priceNm = priceNm;
	}

	public String getPriceType() {
		return priceType;
	}

	public void setPriceType(String priceType) {
		this.priceType = priceType;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public String getSeatRow() {
		return seatRow;
	}

	public void setSeatRow(String seatRow) {
		this.seatRow = seatRow;
	}

	public int getSeatNo() {
		return seatNo;
	}

	public void setSeatNo(int seatNo) {
		this.seatNo = seatNo;
	}

	public int getQty() {
		return qty;
	}

	public void setQty(int qty) {
		this.qty = qty;
	}

}
