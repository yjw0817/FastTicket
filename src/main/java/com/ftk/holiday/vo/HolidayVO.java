package com.ftk.holiday.vo;

import com.ftk.common.vo.CommonDefaultVO;

/**
 * @Class Name : HolidayVO.java
 * @Description : 휴무일 VO
 */
public class HolidayVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	private String holidayId;
	private String holidayDate;
	private String holidayNm;
	private String useYn;
	private String regDt;

	public String getHolidayId() { return holidayId; }
	public void setHolidayId(String holidayId) { this.holidayId = holidayId; }

	public String getHolidayDate() { return holidayDate; }
	public void setHolidayDate(String holidayDate) { this.holidayDate = holidayDate; }

	public String getHolidayNm() { return holidayNm; }
	public void setHolidayNm(String holidayNm) { this.holidayNm = holidayNm; }

	public String getUseYn() { return useYn; }
	public void setUseYn(String useYn) { this.useYn = useYn; }

	public String getRegDt() { return regDt; }
	public void setRegDt(String regDt) { this.regDt = regDt; }

}
