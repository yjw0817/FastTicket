package com.ftk.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

/**
 * @Class Name : LoginInterceptor.java
 * @Description : 로그인 인증 체크 인터셉터
 */
public class LoginInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("loginVO") == null) {
			response.sendRedirect(request.getContextPath() + "/login.do");
			return false;
		}

		return true;
	}

}
