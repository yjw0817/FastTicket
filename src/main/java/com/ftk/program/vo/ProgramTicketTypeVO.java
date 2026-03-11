package com.ftk.program.vo;

import lombok.Getter;
import lombok.Setter;

/**
 * 프로그램별 권종 + 기본가격 VO
 */
@Getter
@Setter
public class ProgramTicketTypeVO {

	private String programId;
	private String typeId;
	private String typeNm;
	private int basePrice;
	private int satPrice;
	private int sunPrice;
	private int holPrice;
	private int sortOrder;

}
