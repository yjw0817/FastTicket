package egovframework.example.program.service;

import egovframework.example.cmmn.service.CommonDefaultVO;

/**
 * @Class Name : ProgramVO.java
 * @Description : 프로그램 VO Class
 */
public class ProgramVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** 프로그램ID */
	private String programId;

	/** 프로그램명 */
	private String programNm;

	/** 프로그램유형 (ADMISSION/PERFORMANCE/MUSICAL) */
	private String programType;

	/** 공연장ID */
	private String venueId;

	/** 설명 */
	private String description;

	/** 연령제한 */
	private String ageLimit;

	/** 공연시간 (분) */
	private int runningTime;

	/** 포스터이미지 */
	private String posterImg;

	/** 시작일 */
	private String startDate;

	/** 종료일 */
	private String endDate;

	/** 사용여부 */
	private String useYn;

	/** 등록자 */
	private String regUser;

	/** 등록일시 */
	private String regDt;

	/** 공연장명 (조인 표시용) */
	private String venueNm;

	public String getProgramId() {
		return programId;
	}

	public void setProgramId(String programId) {
		this.programId = programId;
	}

	public String getProgramNm() {
		return programNm;
	}

	public void setProgramNm(String programNm) {
		this.programNm = programNm;
	}

	public String getProgramType() {
		return programType;
	}

	public void setProgramType(String programType) {
		this.programType = programType;
	}

	public String getVenueId() {
		return venueId;
	}

	public void setVenueId(String venueId) {
		this.venueId = venueId;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getAgeLimit() {
		return ageLimit;
	}

	public void setAgeLimit(String ageLimit) {
		this.ageLimit = ageLimit;
	}

	public int getRunningTime() {
		return runningTime;
	}

	public void setRunningTime(int runningTime) {
		this.runningTime = runningTime;
	}

	public String getPosterImg() {
		return posterImg;
	}

	public void setPosterImg(String posterImg) {
		this.posterImg = posterImg;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
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

	public String getVenueNm() {
		return venueNm;
	}

	public void setVenueNm(String venueNm) {
		this.venueNm = venueNm;
	}

}
