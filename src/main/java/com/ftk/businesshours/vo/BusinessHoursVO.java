package com.ftk.businesshours.vo;

import com.ftk.common.vo.CommonDefaultVO;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BusinessHoursVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** PK */
	private String bhId;

	/** 요일 (1=월 ~ 7=일) */
	private int dayOfWeek;

	/** 영업 시작 시간 (HH:mm) */
	private String openTime;

	/** 영업 종료 시간 (HH:mm) */
	private String closeTime;

	/** 사용여부 (Y=영업, N=휴무) */
	private String useYn;

	/** 등록일 */
	private String regDt;

}
