package com.ftk.menu.mapper;

import java.util.List;

import com.ftk.menu.vo.MenuVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Class Name : MenuMapper.java
 * @Description : 메뉴 MyBatis Mapper 인터페이스
 */
@Mapper("menuMapper")
public interface MenuMapper {

	/**
	 * 메뉴를 등록한다.
	 * @param vo - 등록할 정보가 담긴 MenuVO
	 * @exception Exception
	 */
	void insertMenu(MenuVO vo) throws Exception;

	/**
	 * 메뉴를 수정한다.
	 * @param vo - 수정할 정보가 담긴 MenuVO
	 * @exception Exception
	 */
	void updateMenu(MenuVO vo) throws Exception;

	/**
	 * 메뉴를 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 MenuVO
	 * @exception Exception
	 */
	void deleteMenu(MenuVO vo) throws Exception;

	/**
	 * 메뉴를 조회한다.
	 * @param vo - 조회할 정보가 담긴 MenuVO
	 * @return 조회한 메뉴
	 * @exception Exception
	 */
	MenuVO selectMenu(MenuVO vo) throws Exception;

	/**
	 * 메뉴 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 메뉴 목록
	 * @exception Exception
	 */
	List<?> selectMenuList(CommonDefaultVO searchVO) throws Exception;

	/**
	 * 메뉴 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 메뉴 총 갯수
	 */
	int selectMenuListTotCnt(CommonDefaultVO searchVO);

	/**
	 * 상위메뉴 목록을 조회한다. (등록/수정 화면 select box 용)
	 * @return 상위메뉴 목록
	 * @exception Exception
	 */
	List<?> selectParentMenuList() throws Exception;

	/**
	 * 전체 메뉴 목록을 조회한다. (트리 구성용, 페이징 없음)
	 * @return 전체 메뉴 목록
	 */
	List<MenuVO> selectAllMenuList();

	/**
	 * 회원의 역할에 해당하는 메뉴 목록을 조회한다.
	 * @param memberId - 회원ID
	 * @return 역할 기반 메뉴 목록
	 */
	List<MenuVO> selectMenuListByMemberId(String memberId);

}
