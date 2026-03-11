package com.ftk.program.vo;

import java.util.List;

import com.ftk.common.vo.CommonDefaultVO;

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

	/** 운영 시작시간 (HH:mm) */
	private String openTime;

	/** 운영 종료시간 (HH:mm) */
	private String closeTime;

	/** 공연장명 (조인 표시용) */
	private String venueNm;

	/** 프로그램별 사용 권종 ID 목록 */
	private List<String> typeIds;

	/** 회차 수 */
	private Integer sessionCount;

	/** 첫 회차 시작시간 (HH:mm) */
	private String firstSessionTime;

	/** 회차 간격 (분) */
	private Integer sessionInterval;

	/** 기본 온라인 정원 */
	private Integer defaultOnlineCap;

	/** 기본 오프라인 정원 */
	private Integer defaultOfflineCap;

	/** 프로그램별 권종+기본가격 목록 (화면 바인딩) */
	private List<ProgramTicketTypeVO> ticketTypes;

	/** 프로그램별 할인 목록 (화면 바인딩) */
	private List<ProgramDiscountVO> discounts;

	/** 가격 템플릿 JSON (화면에서 편집한 데이터) */
	private String templateJson;

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

	public String getOpenTime() {
		return openTime;
	}

	public void setOpenTime(String openTime) {
		this.openTime = openTime;
	}

	public String getCloseTime() {
		return closeTime;
	}

	public void setCloseTime(String closeTime) {
		this.closeTime = closeTime;
	}

	public String getVenueNm() {
		return venueNm;
	}

	public void setVenueNm(String venueNm) {
		this.venueNm = venueNm;
	}

	public List<String> getTypeIds() {
		return typeIds;
	}

	public void setTypeIds(List<String> typeIds) {
		this.typeIds = typeIds;
	}

	public Integer getSessionCount() {
		return sessionCount;
	}

	public void setSessionCount(Integer sessionCount) {
		this.sessionCount = sessionCount;
	}

	public String getFirstSessionTime() {
		return firstSessionTime;
	}

	public void setFirstSessionTime(String firstSessionTime) {
		this.firstSessionTime = firstSessionTime;
	}

	public Integer getSessionInterval() {
		return sessionInterval;
	}

	public void setSessionInterval(Integer sessionInterval) {
		this.sessionInterval = sessionInterval;
	}

	public Integer getDefaultOnlineCap() {
		return defaultOnlineCap;
	}

	public void setDefaultOnlineCap(Integer defaultOnlineCap) {
		this.defaultOnlineCap = defaultOnlineCap;
	}

	public Integer getDefaultOfflineCap() {
		return defaultOfflineCap;
	}

	public void setDefaultOfflineCap(Integer defaultOfflineCap) {
		this.defaultOfflineCap = defaultOfflineCap;
	}

	public List<ProgramTicketTypeVO> getTicketTypes() {
		return ticketTypes;
	}

	public void setTicketTypes(List<ProgramTicketTypeVO> ticketTypes) {
		this.ticketTypes = ticketTypes;
	}

	public List<ProgramDiscountVO> getDiscounts() {
		return discounts;
	}

	public void setDiscounts(List<ProgramDiscountVO> discounts) {
		this.discounts = discounts;
	}

	public String getTemplateJson() {
		return templateJson;
	}

	public void setTemplateJson(String templateJson) {
		this.templateJson = templateJson;
	}

}
