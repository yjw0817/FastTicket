<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="uri" value="${requestScope['javax.servlet.forward.request_uri']}" />
<%-- 현재 URL에 해당하는 메뉴명 자동 매칭 --%>
<c:set var="currentMenuNm" value="" />
<c:forEach var="m" items="${sessionScope.menuList}">
    <c:if test="${not empty m.menuUrl && fn:endsWith(uri, m.menuUrl)}">
        <c:set var="currentMenuNm" value="${m.menuNm}" />
    </c:if>
</c:forEach>

<!-- Sidebar -->
<div class="offcanvas-lg offcanvas-start" tabindex="-1" id="sidebar" aria-labelledby="sidebarLabel" style="width:232px;">
    <div class="offcanvas-header d-lg-none" style="background:#222;border-bottom:1px solid rgba(255,255,255,.07);">
        <h5 class="offcanvas-title" id="sidebarLabel" style="font-weight:700;color:#fff;font-size:17px;letter-spacing:-.3px;"><span style="color:#5AC8FA;margin-right:4px;">Fast</span>&nbsp;Ticket</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" data-bs-target="#sidebar" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body p-0">
        <div class="sidebar-title d-none d-lg-flex"><span>Fast</span>&nbsp;Ticket</div>
        <ul class="menu">
            <c:forEach var="m" items="${sessionScope.menuList}">
                <c:if test="${empty m.parentId && m.useYn == 'Y'}">
                    <c:choose>
                        <%-- 하위메뉴 보유 (URL 없음) = 그룹 메뉴 --%>
                        <c:when test="${empty m.menuUrl}">
                            <li class="menu-parent">
                                <a href="javascript:;" class="menu-parent-toggle">
                                    <i data-feather="${m.icon}" class="menu-icon"></i>
                                    <c:out value="${m.menuNm}"/>
                                    <i data-feather="chevron-down" class="menu-arrow"></i>
                                </a>
                                <ul class="menu-sub">
                                    <c:forEach var="child" items="${sessionScope.menuList}">
                                        <c:if test="${child.parentId == m.menuId && child.useYn == 'Y'}">
                                            <li class="${fn:endsWith(uri, child.menuUrl) ? 'active' : ''}">
                                                <a href="<c:url value='${child.menuUrl}'/>">
                                                    <i data-feather="${child.icon}" class="menu-icon"></i>
                                                    <c:out value="${child.menuNm}"/>
                                                </a>
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                </ul>
                            </li>
                        </c:when>
                        <%-- 일반 메뉴 --%>
                        <c:otherwise>
                            <li class="${fn:endsWith(uri, m.menuUrl) ? 'active' : ''}">
                                <a href="<c:url value='${m.menuUrl}'/>">
                                    <i data-feather="${m.icon}" class="menu-icon"></i>
                                    <c:out value="${m.menuNm}"/>
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </c:forEach>
        </ul>
    </div>
</div>

<!-- Topbar -->
<div id="topbar">
    <button class="topbar-hamburger" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebar" aria-controls="sidebar">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" stroke="#495057" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
            <line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/>
        </svg>
    </button>
    <h1 id="topbar-title"><c:out value="${currentMenuNm}"/></h1>
    <div class="topbar-right">
        <span class="topbar-admin">${sessionScope.loginVO.memberNm}</span>
        <div class="topbar-avatar">${fn:substring(sessionScope.loginVO.memberNm, 0, 1)}</div>
        <a href="<c:url value='/logout.do'/>" class="btn btn-outline-secondary btn-sm" style="margin-left:8px;font-size:12px;">로그아웃</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Feather Icons 렌더링
    feather.replace({width:18, height:18});

    // 그룹 메뉴 토글 (높이 계산 애니메이션)
    function toggleMenu(parent, open) {
        var sub = parent.querySelector('.menu-sub');
        if (open) {
            parent.classList.add('open');
            sub.style.height = sub.scrollHeight + 'px';
        } else {
            sub.style.height = sub.scrollHeight + 'px';
            sub.offsetHeight; // reflow
            parent.classList.remove('open');
            sub.style.height = '0';
        }
        sub.addEventListener('transitionend', function handler(e) {
            if (e.propertyName !== 'height') return;
            sub.removeEventListener('transitionend', handler);
            if (parent.classList.contains('open')) {
                sub.style.height = 'auto';
            }
        });
    }
    document.querySelectorAll('.menu-parent-toggle').forEach(function(toggle) {
        var parent = toggle.closest('.menu-parent');
        if (parent.querySelector('.menu-sub li.active')) {
            parent.classList.add('open');
            parent.querySelector('.menu-sub').style.height = 'auto';
        }
        toggle.addEventListener('click', function() {
            toggleMenu(parent, !parent.classList.contains('open'));
        });
    });

    // 메뉴명은 서버사이드에서 설정됨. #title div가 있으면 덮어쓰기 (등록/수정 페이지용 fallback)
    var tb = document.getElementById('topbar-title');
    var t = document.querySelector('#title li');
    if (t && t.textContent.trim()) tb.textContent = t.textContent.trim();

    var pg = document.getElementById('paging');
    var tbl = document.getElementById('table');
    if (pg) {
        var n = 0;
        pg.querySelectorAll('a').forEach(function(a) { if (/^\d+$/.test(a.textContent.trim())) n++; });
        pg.querySelectorAll('strong').forEach(function(s) { if (/^\d+$/.test(s.textContent.trim())) n++; });
        if (n <= 1) {
            pg.classList.add('single-page');
        } else if (tbl) {
            tbl.style.borderRadius = '8px 8px 0 0';
            tbl.style.boxShadow = 'none';
        }
    }
});
</script>
