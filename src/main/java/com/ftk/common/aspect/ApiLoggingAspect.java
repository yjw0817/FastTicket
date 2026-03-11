package com.ftk.common.aspect;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.ftk.member.vo.MemberVO;

/**
 * Controller 메서드 호출 시 API 파라미터를 자동 로깅하는 AOP Aspect.
 */
@Aspect
@Component
public class ApiLoggingAspect {

	private static final Logger API_LOG = LoggerFactory.getLogger("API_PARAM_LOGGER");

	private static final String SEPARATOR;
	static {
		StringBuilder sb = new StringBuilder(144);
		for (int i = 0; i < 144; i++) {
			sb.append('=');
		}
		SEPARATOR = sb.toString();
	}

	@Before("execution(* com.ftk..controller.*Controller.*(..))")
	public void logApiParams(JoinPoint joinPoint) {
		ServletRequestAttributes attrs =
				(ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
		if (attrs == null) {
			return;
		}

		HttpServletRequest request = attrs.getRequest();
		String controllerName = joinPoint.getSignature().getDeclaringType().getSimpleName();
		String methodName = joinPoint.getSignature().getName();
		String dateStr = new SimpleDateFormat("yyyy-MM-dd a h:mm:ss", Locale.KOREAN).format(new Date());
		String httpMethod = request.getMethod();
		String publicIp = getPublicIp(request);
		String localIp = toIpv4(request.getRemoteAddr());
		String userId = getLoginId(request);

		StringBuilder sb = new StringBuilder();
		sb.append("\n[").append(controllerName).append(".").append(methodName).append("] ")
		  .append("날짜 : ").append(dateStr)
		  .append(" | HTTP Method : ").append(httpMethod)
		  .append(" | 공인IP : ").append(publicIp)
		  .append(" | 로컬IP : ").append(localIp)
		  .append(" | 계정 : ").append(userId);

		Map<String, String[]> paramMap = request.getParameterMap();
		for (Map.Entry<String, String[]> entry : paramMap.entrySet()) {
			String value = (entry.getValue() != null && entry.getValue().length > 0)
					? String.join(", ", entry.getValue()) : "";
			sb.append("\n").append(entry.getKey()).append(" : ").append(value);
		}

		sb.append("\n").append(SEPARATOR);

		API_LOG.info(sb.toString());
	}

	/**
	 * 세션에서 로그인 계정 ID 추출.
	 */
	private String getLoginId(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session != null) {
			Object obj = session.getAttribute("loginVO");
			if (obj instanceof MemberVO) {
				return ((MemberVO) obj).getMemberId();
			}
		}
		return "-";
	}

	/**
	 * 공인 IP 추출 (프록시 헤더 우선).
	 * 프록시가 없으면 remoteAddr fallback.
	 */
	private String getPublicIp(HttpServletRequest request) {
		String ip = request.getHeader("X-Forwarded-For");
		if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		// X-Forwarded-For에 여러 IP가 있을 경우 첫 번째가 원본
		if (ip != null && ip.contains(",")) {
			ip = ip.split(",")[0].trim();
		}
		return toIpv4(ip);
	}

	/**
	 * IPv6 localhost → 127.0.0.1 변환.
	 */
	private String toIpv4(String ip) {
		if ("0:0:0:0:0:0:0:1".equals(ip) || "::1".equals(ip)) {
			return "127.0.0.1";
		}
		return ip;
	}

}
