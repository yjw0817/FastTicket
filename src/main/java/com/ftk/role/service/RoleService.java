package com.ftk.role.service;

import java.util.List;

import com.ftk.common.vo.CommonDefaultVO;
import com.ftk.role.vo.RoleVO;

/**
 * @Class Name : RoleService.java
 * @Description : 권한 서비스 인터페이스
 */
public interface RoleService {

	/**
	 * 권한을 등록한다.
	 * @param vo - 등록할 정보가 담긴 RoleVO
	 * @exception Exception
	 */
	void insertRole(RoleVO vo) throws Exception;

	/**
	 * 권한을 수정한다.
	 * @param vo - 수정할 정보가 담긴 RoleVO
	 * @exception Exception
	 */
	void updateRole(RoleVO vo) throws Exception;

	/**
	 * 권한을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 RoleVO
	 * @exception Exception
	 */
	void deleteRole(RoleVO vo) throws Exception;

	/**
	 * 권한을 조회한다.
	 * @param vo - 조회할 정보가 담긴 RoleVO
	 * @return 조회한 권한
	 * @exception Exception
	 */
	RoleVO selectRole(RoleVO vo) throws Exception;

	/**
	 * 권한 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 권한 목록
	 * @exception Exception
	 */
	List<?> selectRoleList(CommonDefaultVO searchVO) throws Exception;

	/**
	 * 권한 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 권한 총 갯수
	 */
	int selectRoleListTotCnt(CommonDefaultVO searchVO);

}
