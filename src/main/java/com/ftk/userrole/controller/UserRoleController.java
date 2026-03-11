package com.ftk.userrole.controller;

import java.util.List;

import com.ftk.userrole.mapper.UserRoleMapper;
import com.ftk.userrole.service.UserRoleService;
import com.ftk.userrole.vo.UserRoleVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.support.SessionStatus;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : UserRoleController.java
 * @Description : 사용자-권한 매핑 Controller 클래스
 */
@Controller
@RequiredArgsConstructor
public class UserRoleController {

	/** UserRoleService */
	private final UserRoleService userRoleService;

	/** UserRoleMapper (드롭다운 목록 조회용) */
	private final UserRoleMapper userRoleMapper;

	/** EgovPropertyService */
	private final EgovPropertyService propertiesService;

	/**
	 * 사용자-권한 매핑 목록을 조회한다. (페이징)
	 * @param searchVO - 조회할 정보가 담긴 CommonDefaultVO
	 * @param model
	 * @return "userrole/userRoleList"
	 * @exception Exception
	 */
	@RequestMapping(value = "/userRoleList.do")
	public String selectUserRoleList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {

		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> userRoleList = userRoleService.selectUserRoleList(searchVO);
		model.addAttribute("resultList", userRoleList);

		int totCnt = userRoleService.selectUserRoleListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		return "userrole/userRoleList";
	}

	/**
	 * 사용자-권한 부여 화면을 조회한다.
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "userrole/userRoleRegister"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addUserRoleView.do", method = RequestMethod.GET)
	public String addUserRoleView(@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		model.addAttribute("userRoleVO", new UserRoleVO());
		model.addAttribute("memberList", userRoleMapper.selectAllMembers());
		model.addAttribute("roleList", userRoleMapper.selectAllRoles());
		return "userrole/userRoleRegister";
	}

	/**
	 * 사용자에게 권한을 부여한다.
	 * @param userRoleVO - 등록할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/userRoleList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addUserRole.do", method = RequestMethod.POST)
	public String addUserRole(@ModelAttribute("searchVO") CommonDefaultVO searchVO, UserRoleVO userRoleVO,
			Model model, SessionStatus status) throws Exception {

		userRoleService.insertUserRole(userRoleVO);
		status.setComplete();
		return "forward:/userRoleList.do";
	}

	/**
	 * 사용자의 권한을 삭제한다.
	 * @param userRoleVO - 삭제할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/userRoleList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/deleteUserRole.do", method = RequestMethod.POST)
	public String deleteUserRole(UserRoleVO userRoleVO, @ModelAttribute("searchVO") CommonDefaultVO searchVO,
			SessionStatus status) throws Exception {
		userRoleService.deleteUserRole(userRoleVO);
		status.setComplete();
		return "forward:/userRoleList.do";
	}

}
