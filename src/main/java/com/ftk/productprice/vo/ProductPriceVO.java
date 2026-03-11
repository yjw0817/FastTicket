package com.ftk.productprice.vo;

import com.ftk.common.vo.CommonDefaultVO;

/**
 * @Class Name : ProductPriceVO.java
 * @Description : 상품 가격 VO (일반 입장권: PROGRAM × TICKET_TYPE → 가격)
 */
public class ProductPriceVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** 상품가격ID */
	private String ppriceId;

	/** 프로그램ID */
	private String programId;

	/** 권종ID */
	private String typeId;

	/** 가격 */
	private int price;

	/** 사용여부 */
	private String useYn;

	/** 등록일시 */
	private String regDt;

	/* 조인용 */
	private String typeNm;
	private String programNm;

	public String getPpriceId() { return ppriceId; }
	public void setPpriceId(String ppriceId) { this.ppriceId = ppriceId; }

	public String getProgramId() { return programId; }
	public void setProgramId(String programId) { this.programId = programId; }

	public String getTypeId() { return typeId; }
	public void setTypeId(String typeId) { this.typeId = typeId; }

	public int getPrice() { return price; }
	public void setPrice(int price) { this.price = price; }

	public String getUseYn() { return useYn; }
	public void setUseYn(String useYn) { this.useYn = useYn; }

	public String getRegDt() { return regDt; }
	public void setRegDt(String regDt) { this.regDt = regDt; }

	public String getTypeNm() { return typeNm; }
	public void setTypeNm(String typeNm) { this.typeNm = typeNm; }

	public String getProgramNm() { return programNm; }
	public void setProgramNm(String programNm) { this.programNm = programNm; }

}
