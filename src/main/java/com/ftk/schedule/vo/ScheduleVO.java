package com.ftk.schedule.vo;

import com.ftk.common.vo.CommonDefaultVO;

/**
 * @Class Name : ScheduleVO.java
 * @Description : 공연일정 VO Class
 */
public class ScheduleVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** 일정ID */
	private String scheduleId;

	/** 프로그램ID */
	private String programId;

	/** 공연일 */
	private String eventDate;

	/** 공연시간 (HH:mm) */
	private String eventTime;

	/** 총좌석수 */
	private int totalSeats;

	/** 잔여좌석수 */
	private int availSeats;

	/** 회차번호 */
	private int sessionNo;

	/** 온라인 정원 */
	private int onlineCapacity;

	/** 오프라인 정원 */
	private int offlineCapacity;

	/** 온라인 잔여 */
	private int onlineAvail;

	/** 오프라인 잔여 */
	private int offlineAvail;

	/** 상태 (OPEN/CLOSED/CANCELED) */
	private String status;

	/** 등록일시 */
	private String regDt;

	/** 프로그램명 (조인용) */
	private String programNm;

	public String getScheduleId() {
		return scheduleId;
	}

	public void setScheduleId(String scheduleId) {
		this.scheduleId = scheduleId;
	}

	public String getProgramId() {
		return programId;
	}

	public void setProgramId(String programId) {
		this.programId = programId;
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

	public int getTotalSeats() {
		return totalSeats;
	}

	public void setTotalSeats(int totalSeats) {
		this.totalSeats = totalSeats;
	}

	public int getAvailSeats() {
		return availSeats;
	}

	public void setAvailSeats(int availSeats) {
		this.availSeats = availSeats;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getRegDt() {
		return regDt;
	}

	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}

	public int getSessionNo() {
		return sessionNo;
	}

	public void setSessionNo(int sessionNo) {
		this.sessionNo = sessionNo;
	}

	public int getOnlineCapacity() {
		return onlineCapacity;
	}

	public void setOnlineCapacity(int onlineCapacity) {
		this.onlineCapacity = onlineCapacity;
	}

	public int getOfflineCapacity() {
		return offlineCapacity;
	}

	public void setOfflineCapacity(int offlineCapacity) {
		this.offlineCapacity = offlineCapacity;
	}

	public int getOnlineAvail() {
		return onlineAvail;
	}

	public void setOnlineAvail(int onlineAvail) {
		this.onlineAvail = onlineAvail;
	}

	public int getOfflineAvail() {
		return offlineAvail;
	}

	public void setOfflineAvail(int offlineAvail) {
		this.offlineAvail = offlineAvail;
	}

	public String getProgramNm() {
		return programNm;
	}

	public void setProgramNm(String programNm) {
		this.programNm = programNm;
	}

}
