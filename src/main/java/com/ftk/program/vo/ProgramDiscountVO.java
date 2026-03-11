package com.ftk.program.vo;

import lombok.Getter;
import lombok.Setter;

/**
 * 프로그램별 할인 VO
 */
@Getter
@Setter
public class ProgramDiscountVO {

	private String pdId;
	private String programId;
	private String discountNm;
	private String discountType;  // PERCENT / AMOUNT
	private int discountValue;
	private String verifyRequired; // Y/N
	private String verifyItem;    // 확인항목 (신분증, 학생증 등)
	private int roundingUnit;
	private String roundingType;  // ROUND / CEIL / FLOOR
	private String useYn;
	private int sortOrder;
	private String regDt;

}
