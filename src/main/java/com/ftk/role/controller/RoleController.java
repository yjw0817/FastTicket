package com.ftk.role.controller;

import java.util.List;

import com.ftk.role.service.RoleService;
import com.ftk.role.vo.RoleVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : RoleController.java
 * @Description : 권한 Controller 클래스
 */
@Controller
@RequiredArgsConstructor
public class RoleController {

	/** RoleService */
	private final RoleService roleService;

	/** EgovPropertyService */
	private final EgovPropertyService propertiesService;

	/**
	 * 권한 목록을 조회한다. (페이징)
	 * @param searchVO - 조회할 정보가 담긴 CommonDefaultVO
	 * @param model
	 * @return "role/roleList"
	 * @exception Exception
	 */
	@RequestMapping(value = "/roleList.do")
	public String selectRoleList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {

		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> roleList = roleService.selectRoleList(searchVO);
		model.addAttribute("resultList", roleList);

		int totCnt = roleService.selectRoleListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		return "role/roleList";
	}

	/**
	 * 권한 등록 화면을 조회한다.
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "role/roleRegister"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addRole.do", method = RequestMethod.GET)
	public String addRoleView(@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		model.addAttribute("roleVO", new RoleVO());
		return "role/roleRegister";
	}

	/**
	 * 권한을 등록한다.
	 * @param roleVO - 등록할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/roleList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addRole.do", method = RequestMethod.POST)
	public String addRole(@ModelAttribute("searchVO") CommonDefaultVO searchVO, RoleVO roleVO,
			Model model, SessionStatus status) throws Exception {

		roleService.insertRole(roleVO);
		status.setComplete();
		return "forward:/roleList.do";
	}

	/**
	 * 권한 수정화면을 조회한다.
	 * @param id - 수정할 권한 ID
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "role/roleRegister"
	 * @exception Exception
	 */
	@RequestMapping("/updateRoleView.do")
	public String updateRoleView(@RequestParam("selectedId") String id,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		RoleVO roleVO = new RoleVO();
		roleVO.setRoleId(id);
		model.addAttribute(selectRole(roleVO, searchVO));
		return "role/roleRegister";
	}

	/**
	 * 권한을 조회한다.
	 * @param roleVO - 조회할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @return 조회한 권한
	 * @exception Exception
	 */
	public RoleVO selectRole(RoleVO roleVO, @ModelAttribute("searchVO") CommonDefaultVO searchVO) throws Exception {
		return roleService.selectRole(roleVO);
	}

	/**
	 * 권한을 수정한다.
	 * @param roleVO - 수정할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/roleList.do"
	 * @exception Exception
	 */
	@RequestMapping("/updateRole.do")
	public String updateRole(@ModelAttribute("searchVO") CommonDefaultVO searchVO, RoleVO roleVO,
			Model model, SessionStatus status) throws Exception {

		roleService.updateRole(roleVO);
		status.setComplete();
		return "forward:/roleList.do";
	}

	/**
	 * 권한을 삭제한다.
	 * @param roleVO - 삭제할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/roleList.do"
	 * @exception Exception
	 */
	@RequestMapping("/deleteRole.do")
	public String deleteRole(RoleVO roleVO, @ModelAttribute("searchVO") CommonDefaultVO searchVO,
			SessionStatus status) throws Exception {
		roleService.deleteRole(roleVO);
		status.setComplete();
		return "forward:/roleList.do";
	}

}
