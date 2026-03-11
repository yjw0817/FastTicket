package com.ftk.rolemenu.vo;

import com.ftk.common.vo.CommonDefaultVO;

/**
 * @Class Name : RoleMenuVO.java
 * @Description : 권한-메뉴 매핑 VO Class
 */
public class RoleMenuVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** 권한ID */
	private String roleId;

	/** 메뉴ID */
	private String menuId;

	/** 권한명 */
	private String roleNm;

	/** 메뉴명 */
	private String menuNm;

	/** 메뉴URL */
	private String menuUrl;

	/** 등록일시 */
	private String regDt;

	public String getRoleId() {
		return roleId;
	}

	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}

	public String getMenuId() {
		return menuId;
	}

	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}

	public String getRoleNm() {
		return roleNm;
	}

	public void setRoleNm(String roleNm) {
		this.roleNm = roleNm;
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

	public String getRegDt() {
		return regDt;
	}

	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}

}
