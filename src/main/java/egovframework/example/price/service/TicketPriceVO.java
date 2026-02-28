package egovframework.example.price.service;

import egovframework.example.cmmn.service.CommonDefaultVO;

/**
 * @Class Name : TicketPriceVO.java
 * @Description : 티켓가격 VO Class
 */
public class TicketPriceVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** 가격ID */
	private String priceId;

	/** 프로그램ID */
	private String programId;

	/** 가격유형 (ADULT/CHILD/INFANT/SENIOR/DISABLED) */
	private String priceType;

	/** 가격명 */
	private String priceNm;

	/** 가격 */
	private int price;

	/** 사용여부 */
	private String useYn;

	/** 프로그램명 (조인용) */
	private String programNm;

	public String getPriceId() {
		return priceId;
	}

	public void setPriceId(String priceId) {
		this.priceId = priceId;
	}

	public String getProgramId() {
		return programId;
	}

	public void setProgramId(String programId) {
		this.programId = programId;
	}

	public String getPriceType() {
		return priceType;
	}

	public void setPriceType(String priceType) {
		this.priceType = priceType;
	}

	public String getPriceNm() {
		return priceNm;
	}

	public void setPriceNm(String priceNm) {
		this.priceNm = priceNm;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getProgramNm() {
		return programNm;
	}

	public void setProgramNm(String programNm) {
		this.programNm = programNm;
	}

}
