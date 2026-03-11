package com.ftk.menu.vo;

import com.ftk.common.vo.CommonDefaultVO;

/**
 * @Class Name : MenuVO.java
 * @Description : 메뉴 VO Class
 */
public class MenuVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** 메뉴ID */
	private String menuId;

	/** 메뉴명 */
	private String menuNm;

	/** 메뉴URL */
	private String menuUrl;

	/** 아이콘 (Bootstrap Icons 클래스명) */
	private String icon;

	/** 상위메뉴ID */
	private String parentId;

	/** 정렬순서 */
	private int sortOrder;

	/** 사용여부 */
	private String useYn;

	/** 등록일시 */
	private String regDt;

	/** 설명 */
	private String description;

	public String getMenuId() {
		return menuId;
	}

	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}

	public String getMenuNm() {
		return menuNm;
	}

	public void setMenuNm(String menuNm) {
		this.menuNm = menuNm;
	}

	public String getMenuUrl() {
		return menuUrl;
	}

	public void setMenuUrl(String menuUrl) {
		this.menuUrl = menuUrl;
	}

	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

}
