package egovframework.example.seat.service;

import egovframework.example.cmmn.service.CommonDefaultVO;

/**
 * @Class Name : SeatVO.java
 * @Description : 좌석 VO Class
 */
public class SeatVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** 좌석ID */
	private String seatId;

	/** 공연장ID */
	private String venueId;

	/** 열 */
	private String seatRow;

	/** 번호 */
	private int seatNo;

	/** 등급 (VIP, R, S, A) */
	private String seatGrade;

	/** 사용여부 */
	private String useYn;

	/** 공연장명 (조인 표시용) */
	private String venueNm;

	public String getSeatId() {
		return seatId;
	}

	public void setSeatId(String seatId) {
		this.seatId = seatId;
	}

	public String getVenueId() {
		return venueId;
	}

	public void setVenueId(String venueId) {
		this.venueId = venueId;
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

	public String getSeatGrade() {
		return seatGrade;
	}

	public void setSeatGrade(String seatGrade) {
		this.seatGrade = seatGrade;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getVenueNm() {
		return venueNm;
	}

	public void setVenueNm(String venueNm) {
		this.venueNm = venueNm;
	}

}
