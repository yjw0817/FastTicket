package com.ftk.rolemenu.mapper;

import java.util.List;

import com.ftk.rolemenu.vo.RoleMenuVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Class Name : RoleMenuMapper.java
 * @Description : 권한-메뉴 매핑 MyBatis Mapper 인터페이스
 */
@Mapper("roleMenuMapper")
public interface RoleMenuMapper {

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
	 */
	List<?> selectMenusByRole(String roleId);

	/**
	 * 권한에 매핑된 메뉴 ID 목록을 조회한다.
	 * @param roleId - 권한ID
	 * @return 메뉴 ID 목록
	 */
	List<String> selectMenuIdsByRole(String roleId);

	/**
	 * 권한의 전체 메뉴 매핑을 삭제한다.
	 * @param roleId - 권한ID
	 */
	void deleteRoleMenuByRole(String roleId);

	/**
	 * 드롭다운용: 전체 활성 권한 목록을 조회한다.
	 * @return 권한 목록
	 */
	List<?> selectAllRoles();

	/**
	 * 드롭다운용: 전체 활성 메뉴 목록을 조회한다.
	 * @return 메뉴 목록
	 */
	List<?> selectAllMenus();

}
