package com.ftk.member.service;

import com.ftk.member.mapper.MemberMapper;
import com.ftk.common.util.CryptoUtil;

import java.util.List;

import com.ftk.member.vo.MemberVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : MemberServiceImpl.java
 * @Description : 회원 서비스 구현 클래스
 */
@Service("memberService")
@RequiredArgsConstructor
public class MemberServiceImpl extends EgovAbstractServiceImpl implements MemberService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MemberServiceImpl.class);

	/** MemberMapper */
	private final MemberMapper memberMapper;

	/** ID Generation */
	private final EgovIdGnrService memberIdGnrService;

	/**
	 * 회원을 등록한다.
	 */
	@Override
	public String insertMember(MemberVO vo) throws Exception {
		LOGGER.debug(vo.toString());
		String id = memberIdGnrService.getNextStringId();
		vo.setMemberId(id);

		// 비밀번호 BCrypt 해싱
		vo.setPassword(CryptoUtil.hashPassword(vo.getPassword()));

		// 전화번호 뒷4자리 추출 후 AES 암호화
		vo.setTelLast4(CryptoUtil.extractLast4(vo.getTel()));
		vo.setTel(CryptoUtil.encrypt(vo.getTel()));

		memberMapper.insertMember(vo);
		return id;
	}

	/**
	 * 회원을 수정한다.
	 */
	@Override
	public void updateMember(MemberVO vo) throws Exception {
		// 비밀번호가 입력된 경우만 재해싱 (빈 값이면 SQL에서 UPDATE 제외)
		if (vo.getPassword() != null && !vo.getPassword().isEmpty()) {
			vo.setPassword(CryptoUtil.hashPassword(vo.getPassword()));
		}

		// 전화번호 뒷4자리 추출 후 AES 암호화
		if (vo.getTel() != null && !vo.getTel().isEmpty()) {
			vo.setTelLast4(CryptoUtil.extractLast4(vo.getTel()));
			vo.setTel(CryptoUtil.encrypt(vo.getTel()));
		}

		memberMapper.updateMember(vo);
	}

	/**
	 * 회원을 삭제한다.
	 */
	@Override
	public void deleteMember(MemberVO vo) throws Exception {
		memberMapper.deleteMember(vo);
	}

	/**
	 * 로그인 정보로 회원을 조회한다.
	 * BCrypt 비교는 여기서 수행.
	 */
	@Override
	public MemberVO selectMemberByLogin(MemberVO vo) throws Exception {
		String rawPassword = vo.getPassword();
		MemberVO memberVO = memberMapper.selectMemberByLogin(vo);

		if (memberVO == null) {
			return null;
		}

		// BCrypt 비밀번호 비교
		if (!CryptoUtil.matchPassword(rawPassword, memberVO.getPassword())) {
			return null;
		}

		// 전화번호 복호화
		memberVO.setTel(CryptoUtil.decrypt(memberVO.getTel()));

		return memberVO;
	}

	/**
	 * 회원을 조회한다.
	 */
	@Override
	public MemberVO selectMember(MemberVO vo) throws Exception {
		MemberVO resultVO = memberMapper.selectMember(vo);
		if (resultVO == null)
			throw processException("info.nodata.msg");

		// 전화번호 복호화
		resultVO.setTel(CryptoUtil.decrypt(resultVO.getTel()));

		return resultVO;
	}

	/**
	 * 회원 목록을 조회한다.
	 * (목록에서는 TEL_LAST4만 표시, 암호화된 TEL은 조회하지 않음)
	 */
	@Override
	public List<?> selectMemberList(CommonDefaultVO searchVO) throws Exception {
		return memberMapper.selectMemberList(searchVO);
	}

	/**
	 * 회원 총 갯수를 조회한다.
	 */
	@Override
	public int selectMemberListTotCnt(CommonDefaultVO searchVO) {
		return memberMapper.selectMemberListTotCnt(searchVO);
	}

}
