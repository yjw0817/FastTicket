package egovframework.example.schedule.service;

import egovframework.example.cmmn.service.CommonDefaultVO;

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

	public String getProgramNm() {
		return programNm;
	}

	public void setProgramNm(String programNm) {
		this.programNm = programNm;
	}

}
