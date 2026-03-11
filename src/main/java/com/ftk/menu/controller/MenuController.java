package com.ftk.menu.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.ftk.menu.service.MenuService;
import com.ftk.menu.vo.MenuVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : MenuController.java
 * @Description : 메뉴 Controller 클래스
 */
@Controller
@RequiredArgsConstructor
public class MenuController {

	/** MenuService */
	private final MenuService menuService;

	/** EgovPropertyService */
	private final EgovPropertyService propertiesService;

	/**
	 * 메뉴 관리 화면 (트리 UI)
	 */
	@RequestMapping(value = "/menuList.do")
	public String selectMenuList(Model model) throws Exception {
		model.addAttribute("allMenuList", menuService.selectAllMenuList());
		return "menu/menuList";
	}

	/**
	 * 전체 메뉴 목록 (AJAX - 트리 갱신용)
	 */
	@RequestMapping(value = "/menuTreeData.do")
	@ResponseBody
	public List<MenuVO> selectMenuTreeData() {
		return menuService.selectAllMenuList();
	}

	/**
	 * 메뉴 상세 조회 (AJAX)
	 */
	@RequestMapping(value = "/menuDetail.do")
	@ResponseBody
	public MenuVO selectMenuDetail(@RequestParam("menuId") String menuId) throws Exception {
		MenuVO vo = new MenuVO();
		vo.setMenuId(menuId);
		return menuService.selectMenu(vo);
	}

	/**
	 * 메뉴 저장 - 신규 등록 (AJAX)
	 */
	@RequestMapping(value = "/saveMenu.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMenu(MenuVO menuVO, HttpServletRequest request) throws Exception {
		Map<String, Object> result = new HashMap<>();
		String menuId = menuService.insertMenu(menuVO);
		refreshSessionMenu(request);
		result.put("success", true);
		result.put("menuId", menuId);
		result.put("message", "등록되었습니다.");
		return result;
	}

	/**
	 * 메뉴 수정 (AJAX)
	 */
	@RequestMapping(value = "/modifyMenu.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> modifyMenu(MenuVO menuVO, HttpServletRequest request) throws Exception {
		Map<String, Object> result = new HashMap<>();
		menuService.updateMenu(menuVO);
		refreshSessionMenu(request);
		result.put("success", true);
		result.put("message", "수정되었습니다.");
		return result;
	}

	/**
	 * 메뉴 삭제 (AJAX)
	 */
	@RequestMapping(value = "/removeMenu.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> removeMenu(@RequestParam("menuId") String menuId, HttpServletRequest request) throws Exception {
		Map<String, Object> result = new HashMap<>();
		MenuVO vo = new MenuVO();
		vo.setMenuId(menuId);
		menuService.deleteMenu(vo);
		refreshSessionMenu(request);
		result.put("success", true);
		result.put("message", "삭제되었습니다.");
		return result;
	}

	/**
	 * 세션의 메뉴 목록을 갱신한다. (역할 기반)
	 */
	private void refreshSessionMenu(HttpServletRequest request) {
		com.ftk.member.vo.MemberVO loginVO =
			(com.ftk.member.vo.MemberVO) request.getSession().getAttribute("loginVO");
		if (loginVO != null) {
			request.getSession().setAttribute("menuList",
				menuService.selectMenuListByMemberId(loginVO.getMemberId()));
		}
	}

	// ── 기존 폼 기반 엔드포인트 (하위 호환) ──

	@RequestMapping(value = "/addMenu.do", method = RequestMethod.GET)
	public String addMenuView(@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		model.addAttribute("menuVO", new MenuVO());
		model.addAttribute("parentMenuList", menuService.selectParentMenuList());
		return "menu/menuRegister";
	}

	@RequestMapping(value = "/addMenu.do", method = RequestMethod.POST)
	public String addMenu(@ModelAttribute("searchVO") CommonDefaultVO searchVO, MenuVO menuVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {
		if (bindingResult.hasErrors()) {
			model.addAttribute("menuVO", menuVO);
			model.addAttribute("parentMenuList", menuService.selectParentMenuList());
			return "menu/menuRegister";
		}
		menuService.insertMenu(menuVO);
		status.setComplete();
		return "forward:/menuList.do";
	}

	@RequestMapping("/updateMenuView.do")
	public String updateMenuView(@RequestParam("selectedId") String id,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		MenuVO menuVO = new MenuVO();
		menuVO.setMenuId(id);
		model.addAttribute("menuVO", menuService.selectMenu(menuVO));
		model.addAttribute("parentMenuList", menuService.selectParentMenuList());
		return "menu/menuRegister";
	}

	@RequestMapping("/updateMenu.do")
	public String updateMenu(@ModelAttribute("searchVO") CommonDefaultVO searchVO, MenuVO menuVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {
		if (bindingResult.hasErrors()) {
			model.addAttribute("menuVO", menuVO);
			model.addAttribute("parentMenuList", menuService.selectParentMenuList());
			return "menu/menuRegister";
		}
		menuService.updateMenu(menuVO);
		status.setComplete();
		return "forward:/menuList.do";
	}

	@RequestMapping("/deleteMenu.do")
	public String deleteMenu(MenuVO menuVO, @ModelAttribute("searchVO") CommonDefaultVO searchVO,
			SessionStatus status) throws Exception {
		menuService.deleteMenu(menuVO);
		status.setComplete();
		return "forward:/menuList.do";
	}

}
