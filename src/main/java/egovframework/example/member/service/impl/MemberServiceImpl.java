package egovframework.example.member.service.impl;

import java.util.List;

import egovframework.example.member.service.MemberService;
import egovframework.example.member.service.MemberVO;
import egovframework.example.cmmn.service.CommonDefaultVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * @Class Name : MemberServiceImpl.java
 * @Description : 회원 서비스 구현 클래스
 */
@Service("memberService")
public class MemberServiceImpl extends EgovAbstractServiceImpl implements MemberService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MemberServiceImpl.class);

	/** MemberMapper */
	@Resource(name = "memberMapper")
	private MemberMapper memberMapper;

	/** ID Generation */
	@Resource(name = "memberIdGnrService")
	private EgovIdGnrService memberIdGnrService;

	/**
	 * 회원을 등록한다.
	 * @param vo - 등록할 정보가 담긴 MemberVO
	 * @return 등록된 회원ID
	 * @exception Exception
	 */
	@Override
	public String insertMember(MemberVO vo) throws Exception {
		LOGGER.debug(vo.toString());
		String id = memberIdGnrService.getNextStringId();
		vo.setMemberId(id);
		LOGGER.debug(vo.toString());
		memberMapper.insertMember(vo);
		return id;
	}

	/**
	 * 회원을 수정한다.
	 * @param vo - 수정할 정보가 담긴 MemberVO
	 * @exception Exception
	 */
	@Override
	public void updateMember(MemberVO vo) throws Exception {
		memberMapper.updateMember(vo);
	}

	/**
	 * 회원을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 MemberVO
	 * @exception Exception
	 */
	@Override
	public void deleteMember(MemberVO vo) throws Exception {
		memberMapper.deleteMember(vo);
	}

	/**
	 * 회원을 조회한다.
	 * @param vo - 조회할 정보가 담긴 MemberVO
	 * @return 조회한 회원
	 * @exception Exception
	 */
	@Override
	public MemberVO selectMember(MemberVO vo) throws Exception {
		MemberVO resultVO = memberMapper.selectMember(vo);
		if (resultVO == null)
			throw processException("info.nodata.msg");
		return resultVO;
	}

	/**
	 * 회원 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 회원 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectMemberList(CommonDefaultVO searchVO) throws Exception {
		return memberMapper.selectMemberList(searchVO);
	}

	/**
	 * 회원 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 회원 총 갯수
	 */
	@Override
	public int selectMemberListTotCnt(CommonDefaultVO searchVO) {
		return memberMapper.selectMemberListTotCnt(searchVO);
	}

}
