package com.ftk.userrole.service;

import java.util.List;

import com.ftk.common.vo.CommonDefaultVO;
import com.ftk.userrole.vo.UserRoleVO;

/**
 * @Class Name : UserRoleService.java
 * @Description : 사용자-권한 매핑 서비스 인터페이스
 */
public interface UserRoleService {

	/**
	 * 사용자에게 권한을 부여한다.
	 * @param vo - 등록할 정보가 담긴 UserRoleVO
	 * @exception Exception
	 */
	void insertUserRole(UserRoleVO vo) throws Exception;

	/**
	 * 사용자의 권한을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 UserRoleVO
	 * @exception Exception
	 */
	void deleteUserRole(UserRoleVO vo) throws Exception;

	/**
	 * 사용자-권한 매핑 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 사용자-권한 매핑 목록
	 * @exception Exception
	 */
	List<?> selectUserRoleList(CommonDefaultVO searchVO) throws Exception;

	/**
	 * 사용자-권한 매핑 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 총 갯수
	 */
	int selectUserRoleListTotCnt(CommonDefaultVO searchVO);

	/**
	 * 특정 회원의 권한 목록을 조회한다.
	 * @param memberId - 회원ID
	 * @return 권한 목록
	 * @exception Exception
	 */
	List<?> selectRolesByMember(String memberId) throws Exception;

}
