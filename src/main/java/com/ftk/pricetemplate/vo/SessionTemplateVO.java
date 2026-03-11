package com.ftk.pricetemplate.vo;

import lombok.Getter;
import lombok.Setter;

/**
 * 회차 템플릿 VO
 */
@Getter
@Setter
public class SessionTemplateVO {

	private String programId;
	private int sessionNo;
	private String dayType;   // WEEKDAY / WEEKEND / HOLIDAY
	private String eventTime; // HH:mm
	private String enabled;   // Y/N

}
