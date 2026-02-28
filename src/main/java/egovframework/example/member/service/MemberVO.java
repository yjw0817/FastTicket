package egovframework.example.member.service;

import egovframework.example.cmmn.service.CommonDefaultVO;

/**
 * @Class Name : MemberVO.java
 * @Description : 회원 VO Class
 */
public class MemberVO extends CommonDefaultVO {

	private static final long serialVersionUID = 1L;

	/** 회원ID */
	private String memberId;

	/** 이름 */
	private String memberNm;

	/** 비밀번호 */
	private String password;

	/** 전화번호 */
	private String tel;

	/** 이메일 */
	private String email;

	/** 사용여부 */
	private String useYn;

	/** 등록일시 */
	private String regDt;

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public String getMemberNm() {
		return memberNm;
	}

	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
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
