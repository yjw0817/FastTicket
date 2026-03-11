package com.ftk.role.service;

import java.util.List;

import com.ftk.role.mapper.RoleMapper;
import com.ftk.role.vo.RoleVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : RoleServiceImpl.java
 * @Description : 권한 서비스 구현 클래스
 */
@Service("roleService")
@RequiredArgsConstructor
public class RoleServiceImpl extends EgovAbstractServiceImpl implements RoleService {

	private static final Logger LOGGER = LoggerFactory.getLogger(RoleServiceImpl.class);

	/** RoleMapper */
	private final RoleMapper roleMapper;

	/**
	 * 권한을 등록한다.
	 * @param vo - 등록할 정보가 담긴 RoleVO
	 * @exception Exception
	 */
	@Override
	public void insertRole(RoleVO vo) throws Exception {
		LOGGER.debug(vo.toString());
		roleMapper.insertRole(vo);
	}

	/**
	 * 권한을 수정한다.
	 * @param vo - 수정할 정보가 담긴 RoleVO
	 * @exception Exception
	 */
	@Override
	public void updateRole(RoleVO vo) throws Exception {
		roleMapper.updateRole(vo);
	}

	/**
	 * 권한을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 RoleVO
	 * @exception Exception
	 */
	@Override
	public void deleteRole(RoleVO vo) throws Exception {
		roleMapper.deleteRole(vo);
	}

	/**
	 * 권한을 조회한다.
	 * @param vo - 조회할 정보가 담긴 RoleVO
	 * @return 조회한 권한
	 * @exception Exception
	 */
	@Override
	public RoleVO selectRole(RoleVO vo) throws Exception {
		RoleVO resultVO = roleMapper.selectRole(vo);
		if (resultVO == null)
			throw processException("info.nodata.msg");
		return resultVO;
	}

	/**
	 * 권한 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 권한 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectRoleList(CommonDefaultVO searchVO) throws Exception {
		return roleMapper.selectRoleList(searchVO);
	}

	/**
	 * 권한 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 권한 총 갯수
	 */
	@Override
	public int selectRoleListTotCnt(CommonDefaultVO searchVO) {
		return roleMapper.selectRoleListTotCnt(searchVO);
	}

}
