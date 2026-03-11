package com.ftk.member.mapper;

import java.util.List;

import com.ftk.member.vo.MemberVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Class Name : MemberMapper.java
 * @Description : 회원 MyBatis Mapper 인터페이스
 */
@Mapper("memberMapper")
public interface MemberMapper {

	/**
	 * 회원을 등록한다.
	 * @param vo - 등록할 정보가 담긴 MemberVO
	 * @exception Exception
	 */
	void insertMember(MemberVO vo) throws Exception;

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
	 * 전체 회원을 조회한다. (마이그레이션용)
	 */
	List<MemberVO> selectAllMembers() throws Exception;

	/**
	 * 회원 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 회원 총 갯수
	 */
	int selectMemberListTotCnt(CommonDefaultVO searchVO);

}
