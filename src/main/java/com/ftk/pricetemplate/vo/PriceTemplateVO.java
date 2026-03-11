package com.ftk.pricetemplate.vo;

import lombok.Getter;
import lombok.Setter;

/**
 * 가격 템플릿 VO
 */
@Getter
@Setter
public class PriceTemplateVO {

	private String programId;
	private int sessionNo;
	private String typeId;
	private String typeNm;    // JOIN용
	private String dayType;   // WEEKDAY / WEEKEND / HOLIDAY
	private int price;

}
