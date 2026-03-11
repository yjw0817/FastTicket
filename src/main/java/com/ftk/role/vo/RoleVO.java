package com.ftk.role.vo;

import com.ftk.common.vo.CommonDefaultVO;

/**
 * @Class Name : RoleVO.java
 * @Description : 권한 VO Class
 */
public class RoleVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** 권한ID */
	private String roleId;

	/** 권한명 */
	private String roleNm;

	/** 설명 */
	private String description;

	/** 사용여부 */
	private String useYn;

	/** 등록일시 */
	private String regDt;

	public String getRoleId() {
		return roleId;
	}

	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}

	public String getRoleNm() {
		return roleNm;
	}

	public void setRoleNm(String roleNm) {
		this.roleNm = roleNm;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
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
