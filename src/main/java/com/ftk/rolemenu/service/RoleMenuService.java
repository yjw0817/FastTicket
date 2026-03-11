package com.ftk.rolemenu.service;

import java.util.List;

import com.ftk.common.vo.CommonDefaultVO;
import com.ftk.rolemenu.vo.RoleMenuVO;

/**
 * @Class Name : RoleMenuService.java
 * @Description : 권한-메뉴 매핑 서비스 인터페이스
 */
public interface RoleMenuService {

	/**
	 * 권한에 메뉴를 매핑한다.
	 * @param vo - 등록할 정보가 담긴 RoleMenuVO
	 * @exception Exception
	 */
	void insertRoleMenu(RoleMenuVO vo) throws Exception;

	/**
	 * 권한-메뉴 매핑을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 RoleMenuVO
	 * @exception Exception
	 */
	void deleteRoleMenu(RoleMenuVO vo) throws Exception;

	/**
	 * 권한-메뉴 매핑 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 권한-메뉴 매핑 목록
	 * @exception Exception
	 */
	List<?> selectRoleMenuList(CommonDefaultVO searchVO) throws Exception;

	/**
	 * 권한-메뉴 매핑 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 권한-메뉴 매핑 총 갯수
	 */
	int selectRoleMenuListTotCnt(CommonDefaultVO searchVO);

	/**
	 * 특정 권한에 매핑된 메뉴 목록을 조회한다.
	 * @param roleId - 권한ID
	 * @return 메뉴 목록
	 * @exception Exception
	 */
	List<?> selectMenusByRole(String roleId) throws Exception;

	/**
	 * 권한에 매핑된 메뉴 ID 목록을 조회한다.
	 * @param roleId - 권한ID
	 * @return 메뉴 ID 목록
	 */
	List<String> selectMenuIdsByRole(String roleId);

	/**
	 * 권한의 메뉴 매핑을 일괄 저장한다. (기존 삭제 후 재등록)
	 * @param roleId - 권한ID
	 * @param menuIds - 메뉴ID 목록
	 * @exception Exception
	 */
	void saveRoleMenus(String roleId, List<String> menuIds) throws Exception;

}
