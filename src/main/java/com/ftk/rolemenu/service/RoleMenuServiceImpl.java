package com.ftk.rolemenu.service;

import java.util.List;

import com.ftk.rolemenu.mapper.RoleMenuMapper;
import com.ftk.rolemenu.vo.RoleMenuVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : RoleMenuServiceImpl.java
 * @Description : 권한-메뉴 매핑 서비스 구현 클래스
 */
@Service("roleMenuService")
@RequiredArgsConstructor
public class RoleMenuServiceImpl extends EgovAbstractServiceImpl implements RoleMenuService {

	private static final Logger LOGGER = LoggerFactory.getLogger(RoleMenuServiceImpl.class);

	/** RoleMenuMapper */
	private final RoleMenuMapper roleMenuMapper;

	/**
	 * 권한에 메뉴를 매핑한다.
	 * @param vo - 등록할 정보가 담긴 RoleMenuVO
	 * @exception Exception
	 */
	@Override
	public void insertRoleMenu(RoleMenuVO vo) throws Exception {
		LOGGER.debug("insertRoleMenu - roleId: {}, menuId: {}", vo.getRoleId(), vo.getMenuId());
		roleMenuMapper.insertRoleMenu(vo);
	}

	/**
	 * 권한-메뉴 매핑을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 RoleMenuVO
	 * @exception Exception
	 */
	@Override
	public void deleteRoleMenu(RoleMenuVO vo) throws Exception {
		roleMenuMapper.deleteRoleMenu(vo);
	}

	/**
	 * 권한-메뉴 매핑 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 권한-메뉴 매핑 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectRoleMenuList(CommonDefaultVO searchVO) throws Exception {
		return roleMenuMapper.selectRoleMenuList(searchVO);
	}

	/**
	 * 권한-메뉴 매핑 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 권한-메뉴 매핑 총 갯수
	 */
	@Override
	public int selectRoleMenuListTotCnt(CommonDefaultVO searchVO) {
		return roleMenuMapper.selectRoleMenuListTotCnt(searchVO);
	}

	/**
	 * 특정 권한에 매핑된 메뉴 목록을 조회한다.
	 * @param roleId - 권한ID
	 * @return 메뉴 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectMenusByRole(String roleId) throws Exception {
		return roleMenuMapper.selectMenusByRole(roleId);
	}

	/**
	 * 권한에 매핑된 메뉴 ID 목록을 조회한다.
	 * @param roleId - 권한ID
	 * @return 메뉴 ID 목록
	 */
	@Override
	public List<String> selectMenuIdsByRole(String roleId) {
		return roleMenuMapper.selectMenuIdsByRole(roleId);
	}

	/**
	 * 권한의 메뉴 매핑을 일괄 저장한다. (기존 삭제 후 재등록)
	 * @param roleId - 권한ID
	 * @param menuIds - 메뉴ID 목록
	 * @exception Exception
	 */
	@Override
	public void saveRoleMenus(String roleId, List<String> menuIds) throws Exception {
		roleMenuMapper.deleteRoleMenuByRole(roleId);
		for (String menuId : menuIds) {
			RoleMenuVO vo = new RoleMenuVO();
			vo.setRoleId(roleId);
			vo.setMenuId(menuId);
			roleMenuMapper.insertRoleMenu(vo);
		}
	}

}
