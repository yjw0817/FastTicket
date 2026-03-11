package com.ftk.sessionprice.vo;

import com.ftk.common.vo.CommonDefaultVO;

/**
 * @Class Name : SessionPriceVO.java
 * @Description : 회차별 가격 VO Class (SCHEDULE × TICKET_TYPE → 가격)
 */
public class SessionPriceVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** 회차가격ID */
	private String spriceId;

	/** 일정ID (SCHEDULE FK) */
	private String scheduleId;

	/** 권종ID (TICKET_TYPE FK) */
	private String typeId;

	/** 가격 */
	private int price;

	/** 사용여부 */
	private String useYn;

	/** 등록일시 */
	private String regDt;

	/* 조인용 */
	/** 권종명 */
	private String typeNm;

	/** 프로그램명 */
	private String programNm;

	/** 공연일 */
	private String eventDate;

	/** 공연시간 */
	private String eventTime;

	/** 회차번호 */
	private int sessionNo;

	public String getSpriceId() {
		return spriceId;
	}

	public void setSpriceId(String spriceId) {
		this.spriceId = spriceId;
	}

	public String getScheduleId() {
		return scheduleId;
	}

	public void setScheduleId(String scheduleId) {
		this.scheduleId = scheduleId;
	}

	public String getTypeId() {
		return typeId;
	}

	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getRegDt() {
		return regDt;
	}

	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}

	public String getTypeNm() {
		return typeNm;
	}

	public void setTypeNm(String typeNm) {
		this.typeNm = typeNm;
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

	public int getSessionNo() {
		return sessionNo;
	}

	public void setSessionNo(int sessionNo) {
		this.sessionNo = sessionNo;
	}

}
