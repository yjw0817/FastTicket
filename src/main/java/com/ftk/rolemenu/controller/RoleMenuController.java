package com.ftk.rolemenu.controller;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ftk.menu.service.MenuService;
import com.ftk.rolemenu.mapper.RoleMenuMapper;
import com.ftk.rolemenu.service.RoleMenuService;
import com.ftk.rolemenu.vo.RoleMenuVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.property.EgovPropertyService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : RoleMenuController.java
 * @Description : 권한-메뉴 매핑 Controller 클래스
 */
@Controller
@RequiredArgsConstructor
public class RoleMenuController {

	/** RoleMenuService */
	private final RoleMenuService roleMenuService;

	/** RoleMenuMapper (드롭다운 목록 조회용) */
	private final RoleMenuMapper roleMenuMapper;

	/** MenuService (전체 메뉴 트리 조회용) */
	private final MenuService menuService;

	/**
	 * 권한-메뉴 매핑 화면 (좌: 권한 목록, 우: 체크박스 메뉴 트리)
	 */
	@RequestMapping(value = "/roleMenuList.do")
	public String selectRoleMenuList(Model model) throws Exception {
		model.addAttribute("roleList", roleMenuMapper.selectAllRoles());
		model.addAttribute("allMenuList", menuService.selectAllMenuList());
		return "rolemenu/roleMenuList";
	}

	/**
	 * 권한에 매핑된 메뉴 ID 목록 조회 (AJAX)
	 */
	@RequestMapping(value = "/roleMenuData.do")
	@ResponseBody
	public List<String> selectRoleMenuData(@RequestParam("roleId") String roleId) {
		return roleMenuService.selectMenuIdsByRole(roleId);
	}

	/**
	 * 권한의 메뉴 매핑 일괄 저장 (AJAX)
	 */
	@RequestMapping(value = "/saveRoleMenus.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveRoleMenus(
			@RequestParam("roleId") String roleId,
			@RequestParam(value = "menuIds", required = false) String menuIds) throws Exception {
		Map<String, Object> result = new HashMap<>();
		List<String> menuIdList = (menuIds != null && !menuIds.isEmpty())
				? Arrays.asList(menuIds.split(","))
				: Collections.emptyList();
		roleMenuService.saveRoleMenus(roleId, menuIdList);
		result.put("success", true);
		result.put("message", "저장되었습니다.");
		return result;
	}

}
