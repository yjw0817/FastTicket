package com.ftk.userrole.vo;

import com.ftk.common.vo.CommonDefaultVO;

/**
 * @Class Name : UserRoleVO.java
 * @Description : 사용자-권한 매핑 VO Class
 */
public class UserRoleVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** 회원ID */
	private String memberId;

	/** 권한ID */
	private String roleId;

	/** 회원명 */
	private String memberNm;

	/** 권한명 */
	private String roleNm;

	/** 등록일시 */
	private String regDt;

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public String getRoleId() {
		return roleId;
	}

	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}

	public String getMemberNm() {
		return memberNm;
	}

	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}

	public String getRoleNm() {
		return roleNm;
	}

	public void setRoleNm(String roleNm) {
		this.roleNm = roleNm;
	}

	public String getRegDt() {
		return regDt;
	}

	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}

}
