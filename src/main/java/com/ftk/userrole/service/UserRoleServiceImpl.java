package com.ftk.userrole.service;

import java.util.List;

import com.ftk.common.vo.CommonDefaultVO;
import com.ftk.userrole.mapper.UserRoleMapper;
import com.ftk.userrole.vo.UserRoleVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : UserRoleServiceImpl.java
 * @Description : 사용자-권한 매핑 서비스 구현 클래스
 */
@Service("userRoleService")
@RequiredArgsConstructor
public class UserRoleServiceImpl extends EgovAbstractServiceImpl implements UserRoleService {

	private static final Logger LOGGER = LoggerFactory.getLogger(UserRoleServiceImpl.class);

	/** UserRoleMapper */
	private final UserRoleMapper userRoleMapper;

	/**
	 * 사용자에게 권한을 부여한다.
	 * @param vo - 등록할 정보가 담긴 UserRoleVO
	 * @exception Exception
	 */
	@Override
	public void insertUserRole(UserRoleVO vo) throws Exception {
		LOGGER.debug("insertUserRole - memberId: {}, roleId: {}", vo.getMemberId(), vo.getRoleId());
		userRoleMapper.insertUserRole(vo);
	}

	/**
	 * 사용자의 권한을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 UserRoleVO
	 * @exception Exception
	 */
	@Override
	public void deleteUserRole(UserRoleVO vo) throws Exception {
		userRoleMapper.deleteUserRole(vo);
	}

	/**
	 * 사용자-권한 매핑 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 사용자-권한 매핑 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectUserRoleList(CommonDefaultVO searchVO) throws Exception {
		return userRoleMapper.selectUserRoleList(searchVO);
	}

	/**
	 * 사용자-권한 매핑 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 총 갯수
	 */
	@Override
	public int selectUserRoleListTotCnt(CommonDefaultVO searchVO) {
		return userRoleMapper.selectUserRoleListTotCnt(searchVO);
	}

	/**
	 * 특정 회원의 권한 목록을 조회한다.
	 * @param memberId - 회원ID
	 * @return 권한 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectRolesByMember(String memberId) throws Exception {
		return userRoleMapper.selectRolesByMember(memberId);
	}

}
