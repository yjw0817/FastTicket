package com.ftk.discount.vo;

import java.util.List;

import com.ftk.common.vo.CommonDefaultVO;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DiscountVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** PK */
	private String discountId;

	/** 할인명 */
	private String discountNm;

	/** 할인유형 (PERCENT: 정률, AMOUNT: 정액) */
	private String discountType;

	/** 할인값 (PERCENT면 10=10%, AMOUNT면 1000=1000원) */
	private int discountValue;

	/** 적용 시작일 */
	private String startDate;

	/** 적용 종료일 */
	private String endDate;

	/** 사용여부 */
	private String useYn;

	/** 적용 조건 - 시작 시간 (HH:mm, NULL=제한없음) */
	private String applyTimeFrom;

	/** 적용 조건 - 종료 시간 (HH:mm, NULL=제한없음) */
	private String applyTimeTo;

	/** 적용 조건 - 요일 (1,2,3,4,5=평일, 6,7=주말, NULL=전체) */
	private String applyDays;

	/** 적용 조건 - 권종 ID (NULL=전체) */
	private String applyTicketTypeId;

	/** 적용 대상 프로그램 ID 목록 (폼 전송용) */
	private List<String> programIds;

	/** 프로그램별 할인값 override 목록 (programIds와 같은 순서) */
	private List<String> programValues;

	/** 반올림 단위 (1, 10, 100, 1000) */
	private int roundingUnit = 1;

	/** 반올림 방식 (ROUND, CEIL, FLOOR) */
	private String roundingType = "ROUND";

	/** 비고 */
	private String remark;

	/** 등록일 */
	private String regDt;

}
