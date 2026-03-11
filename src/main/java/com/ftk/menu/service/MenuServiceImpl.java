package com.ftk.menu.service;

import com.ftk.menu.mapper.MenuMapper;

import java.util.List;

import com.ftk.menu.vo.MenuVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : MenuServiceImpl.java
 * @Description : 메뉴 서비스 구현 클래스
 */
@Service("menuService")
@RequiredArgsConstructor
public class MenuServiceImpl extends EgovAbstractServiceImpl implements MenuService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MenuServiceImpl.class);

	/** MenuMapper */
	private final MenuMapper menuMapper;

	/** ID Generation */
	private final EgovIdGnrService menuIdGnrService;

	/**
	 * 메뉴를 등록한다.
	 * @param vo - 등록할 정보가 담긴 MenuVO
	 * @return 등록된 메뉴ID
	 * @exception Exception
	 */
	@Override
	public String insertMenu(MenuVO vo) throws Exception {
		LOGGER.debug(vo.toString());
		String id = menuIdGnrService.getNextStringId();
		vo.setMenuId(id);
		LOGGER.debug(vo.toString());
		menuMapper.insertMenu(vo);
		return id;
	}

	/**
	 * 메뉴를 수정한다.
	 * @param vo - 수정할 정보가 담긴 MenuVO
	 * @exception Exception
	 */
	@Override
	public void updateMenu(MenuVO vo) throws Exception {
		menuMapper.updateMenu(vo);
	}

	/**
	 * 메뉴를 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 MenuVO
	 * @exception Exception
	 */
	@Override
	public void deleteMenu(MenuVO vo) throws Exception {
		menuMapper.deleteMenu(vo);
	}

	/**
	 * 메뉴를 조회한다.
	 * @param vo - 조회할 정보가 담긴 MenuVO
	 * @return 조회한 메뉴
	 * @exception Exception
	 */
	@Override
	public MenuVO selectMenu(MenuVO vo) throws Exception {
		MenuVO resultVO = menuMapper.selectMenu(vo);
		if (resultVO == null)
			throw processException("info.nodata.msg");
		return resultVO;
	}

	/**
	 * 메뉴 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 메뉴 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectMenuList(CommonDefaultVO searchVO) throws Exception {
		return menuMapper.selectMenuList(searchVO);
	}

	/**
	 * 메뉴 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 메뉴 총 갯수
	 */
	@Override
	public int selectMenuListTotCnt(CommonDefaultVO searchVO) {
		return menuMapper.selectMenuListTotCnt(searchVO);
	}

	/**
	 * 상위메뉴 목록을 조회한다. (등록/수정 화면 select box 용)
	 * @return 상위메뉴 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectParentMenuList() throws Exception {
		return menuMapper.selectParentMenuList();
	}

	/**
	 * 전체 메뉴 목록을 조회한다. (트리 구성용, 페이징 없음)
	 * @return 전체 메뉴 목록
	 */
	@Override
	public List<MenuVO> selectAllMenuList() {
		return menuMapper.selectAllMenuList();
	}

	/**
	 * 회원의 역할에 해당하는 메뉴 목록을 조회한다.
	 * @param memberId - 회원ID
	 * @return 역할 기반 메뉴 목록
	 */
	@Override
	public List<MenuVO> selectMenuListByMemberId(String memberId) {
		return menuMapper.selectMenuListByMemberId(memberId);
	}

}
