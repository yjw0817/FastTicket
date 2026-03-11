package com.ftk.member.service;

import java.util.List;

import com.ftk.common.vo.CommonDefaultVO;
import com.ftk.member.vo.MemberVO;

/**
 * @Class Name : MemberService.java
 * @Description : 회원 서비스 인터페이스
 */
public interface MemberService {

	/**
	 * 회원을 등록한다.
	 * @param vo - 등록할 정보가 담긴 MemberVO
	 * @return 등록된 회원ID
	 * @exception Exception
	 */
	String insertMember(MemberVO vo) throws Exception;

	/**
	 * 회원을 수정한다.
	 * @param vo - 수정할 정보가 담긴 MemberVO
	 * @exception Exception
	 */
	void updateMember(MemberVO vo) throws Exception;

	/**
	 * 회원을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 MemberVO
	 * @exception Exception
	 */
	void deleteMember(MemberVO vo) throws Exception;

	/**
	 * 회원을 조회한다.
	 * @param vo - 조회할 정보가 담긴 MemberVO
	 * @return 조회한 회원
	 * @exception Exception
	 */
	MemberVO selectMember(MemberVO vo) throws Exception;

	/**
	 * 로그인 정보로 회원을 조회한다.
	 * @param vo - 회원ID, 비밀번호가 담긴 MemberVO
	 * @return 조회한 회원 (없으면 null)
	 * @exception Exception
	 */
	MemberVO selectMemberByLogin(MemberVO vo) throws Exception;

	/**
	 * 회원 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 회원 목록
	 * @exception Exception
	 */
	List<?> selectMemberList(CommonDefaultVO searchVO) throws Exception;

	/**
	 * 회원 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 회원 총 갯수
	 */
	int selectMemberListTotCnt(CommonDefaultVO searchVO);

}
