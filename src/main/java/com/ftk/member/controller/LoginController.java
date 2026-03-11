package com.ftk.member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.ftk.member.service.MemberService;
import com.ftk.member.vo.MemberVO;
import com.ftk.menu.service.MenuService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : LoginController.java
 * @Description : 로그인/로그아웃 Controller 클래스
 */
@Controller
@RequiredArgsConstructor
public class LoginController {

	private final MemberService memberService;
	private final MenuService menuService;

	/**
	 * 로그인 화면을 표시한다.
	 * @return "member/login"
	 */
	@RequestMapping(value = "/login.do", method = RequestMethod.GET)
	public String loginView() {
		return "member/login";
	}

	/**
	 * 로그인을 처리한다.
	 * @param vo - 회원ID, 비밀번호가 담긴 MemberVO
	 * @param request - HttpServletRequest
	 * @param model
	 * @return 성공 시 redirect:/venueList.do, 실패 시 member/login
	 */
	@RequestMapping(value = "/login.do", method = RequestMethod.POST)
	public String login(MemberVO vo, HttpServletRequest request, Model model) throws Exception {

		MemberVO loginVO = memberService.selectMemberByLogin(vo);

		if (loginVO == null) {
			model.addAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
			return "member/login";
		}

		// 세션 고정 공격 방지: 기존 세션 무효화 후 새 세션 생성
		loginVO.setPassword(null);
		HttpSession oldSession = request.getSession(false);
		if (oldSession != null) {
			oldSession.invalidate();
		}
		HttpSession session = request.getSession(true);
		session.setAttribute("loginVO", loginVO);
		session.setAttribute("menuList", menuService.selectMenuListByMemberId(loginVO.getMemberId()));

		return "redirect:/venueList.do";
	}

	/**
	 * 로그아웃을 처리한다.
	 * @param request - HttpServletRequest
	 * @return "redirect:/login.do"
	 */
	@RequestMapping(value = "/logout.do", method = RequestMethod.GET)
	public String logout(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}
		return "redirect:/login.do";
	}

}
