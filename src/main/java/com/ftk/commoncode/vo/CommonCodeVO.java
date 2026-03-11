package com.ftk.commoncode.vo;

import com.ftk.common.vo.CommonDefaultVO;

/**
 * @Class Name : CommonCodeVO.java
 * @Description : 공통코드 VO Class
 */
public class CommonCodeVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	private String codeId;
	private String codeNm;
	private String codeValue;
	private String parentId;
	private int depth;
	private int sortOrder;
	private String description;
	private String useYn;
	private String regDt;

	private String valLabel1;
	private String val1;
	private String valLabel2;
	private String val2;
	private String valLabel3;
	private String val3;
	private String valLabel4;
	private String val4;

	public String getCodeId() { return codeId; }
	public void setCodeId(String codeId) { this.codeId = codeId; }

	public String getCodeNm() { return codeNm; }
	public void setCodeNm(String codeNm) { this.codeNm = codeNm; }

	public String getCodeValue() { return codeValue; }
	public void setCodeValue(String codeValue) { this.codeValue = codeValue; }

	public String getParentId() { return parentId; }
	public void setParentId(String parentId) { this.parentId = parentId; }

	public int getDepth() { return depth; }
	public void setDepth(int depth) { this.depth = depth; }

	public int getSortOrder() { return sortOrder; }
	public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }

	public String getDescription() { return description; }
	public void setDescription(String description) { this.description = description; }

	public String getUseYn() { return useYn; }
	public void setUseYn(String useYn) { this.useYn = useYn; }

	public String getRegDt() { return regDt; }
	public void setRegDt(String regDt) { this.regDt = regDt; }

	public String getValLabel1() { return valLabel1; }
	public void setValLabel1(String valLabel1) { this.valLabel1 = valLabel1; }
	public String getVal1() { return val1; }
	public void setVal1(String val1) { this.val1 = val1; }

	public String getValLabel2() { return valLabel2; }
	public void setValLabel2(String valLabel2) { this.valLabel2 = valLabel2; }
	public String getVal2() { return val2; }
	public void setVal2(String val2) { this.val2 = val2; }

	public String getValLabel3() { return valLabel3; }
	public void setValLabel3(String valLabel3) { this.valLabel3 = valLabel3; }
	public String getVal3() { return val3; }
	public void setVal3(String val3) { this.val3 = val3; }

	public String getValLabel4() { return valLabel4; }
	public void setValLabel4(String valLabel4) { this.valLabel4 = valLabel4; }
	public String getVal4() { return val4; }
	public void setVal4(String val4) { this.val4 = val4; }

}
