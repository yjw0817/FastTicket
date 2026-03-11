package com.ftk.tickettype.vo;

import com.ftk.common.vo.CommonDefaultVO;

/**
 * @Class Name : TicketTypeVO.java
 * @Description : 권종 VO Class (기초 설정)
 */
public class TicketTypeVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** 권종ID */
	private String typeId;

	/** 권종명 (어린이, 청소년, 성인, 경로 등) */
	private String typeNm;

	/** 정렬순서 */
	private int sortOrder;

	/** 사용여부 */
	private String useYn;

	/** 등록일시 */
	private String regDt;

	public String getTypeId() {
		return typeId;
	}

	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}

	public String getTypeNm() {
		return typeNm;
	}

	public void setTypeNm(String typeNm) {
		this.typeNm = typeNm;
	}

	public int getSortOrder() {
		return sortOrder;
	}

	public void setSortOrder(int sortOrder) {
		this.sortOrder = sortOrder;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getRegDt() {
		return regDt;
	}

	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}

}
