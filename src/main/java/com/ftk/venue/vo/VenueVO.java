package com.ftk.venue.vo;

import com.ftk.common.vo.CommonDefaultVO;

/**
 * @Class Name : VenueVO.java
 * @Description : 공연장 VO Class
 */
public class VenueVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** 공연장ID */
	private String venueId;

	/** 공연장명 */
	private String venueNm;

	/** 위치 */
	private String location;

	/** 총좌석수 */
	private int totalSeats;

	/** 좌석유형 (F:자유석, A:지정석) */
	private String seatType;

	/** 설명 */
	private String description;

	/** 사용여부 */
	private String useYn;

	/** 등록자 */
	private String regUser;

	/** 등록일시 */
	private String regDt;

	public String getVenueId() {
		return venueId;
	}

	public void setVenueId(String venueId) {
		this.venueId = venueId;
	}

	public String getVenueNm() {
		return venueNm;
	}

	public void setVenueNm(String venueNm) {
		this.venueNm = venueNm;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public int getTotalSeats() {
		return totalSeats;
	}

	public void setTotalSeats(int totalSeats) {
		this.totalSeats = totalSeats;
	}

	public String getSeatType() {
		return seatType;
	}

	public void setSeatType(String seatType) {
		this.seatType = seatType;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getRegUser() {
		return regUser;
	}

	public void setRegUser(String regUser) {
		this.regUser = regUser;
	}

	public String getRegDt() {
		return regDt;
	}

	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}

}
