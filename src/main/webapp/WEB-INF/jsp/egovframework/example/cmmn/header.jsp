<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="uri" value="${requestScope['javax.servlet.forward.request_uri']}" />

<!-- Sidebar -->
<div class="offcanvas-lg offcanvas-start" tabindex="-1" id="sidebar" aria-labelledby="sidebarLabel" style="width:232px;">
    <div class="offcanvas-header d-lg-none" style="background:#222;border-bottom:1px solid rgba(255,255,255,.07);">
        <h5 class="offcanvas-title" id="sidebarLabel" style="font-weight:700;color:#fff;font-size:17px;letter-spacing:-.3px;"><span style="color:#5AC8FA;margin-right:4px;">Fast</span>&nbsp;Ticket</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" data-bs-target="#sidebar" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body p-0">
        <div class="sidebar-title d-none d-lg-flex"><span>Fast</span>&nbsp;Ticket</div>
        <ul class="menu">
            <li class="${fn:contains(uri, 'venue') ? 'active' : ''}">
                <a href="<c:url value='/venueList.do'/>">
                    <svg class="menu-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                    공연장
                </a>
            </li>
            <li class="${fn:contains(uri, 'program') ? 'active' : ''}">
                <a href="<c:url value='/programList.do'/>">
                    <svg class="menu-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
                    프로그램
                </a>
            </li>
            <li class="${fn:contains(uri, 'schedule') ? 'active' : ''}">
                <a href="<c:url value='/scheduleList.do'/>">
                    <svg class="menu-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                    일정
                </a>
            </li>
            <li class="${fn:contains(uri, 'ticketPrice') ? 'active' : ''}">
                <a href="<c:url value='/ticketPriceList.do'/>">
                    <svg class="menu-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                    가격
                </a>
            </li>
            <li class="${fn:contains(uri, 'seat') ? 'active' : ''}">
                <a href="<c:url value='/seatList.do'/>">
                    <svg class="menu-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="2" width="16" height="20" rx="2"/><line x1="4" y1="10" x2="20" y2="10"/><line x1="12" y1="2" x2="12" y2="10"/></svg>
                    좌석
                </a>
            </li>
            <li class="${fn:contains(uri, 'booking') ? 'active' : ''}">
                <a href="<c:url value='/bookingList.do'/>">
                    <svg class="menu-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                    예매
                </a>
            </li>
            <li class="${fn:contains(uri, 'member') ? 'active' : ''}">
                <a href="<c:url value='/memberList.do'/>">
                    <svg class="menu-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    회원
                </a>
            </li>
            <li class="d-none ${fn:contains(uri, 'Sample') || fn:contains(uri, 'sample') ? 'active' : ''}">
                <a href="<c:url value='/egovSampleList.do'/>">
                    <svg class="menu-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
                    Sample
                </a>
            </li>
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
    <h1 id="topbar-title"></h1>
    <div class="topbar-right">
        <span class="topbar-admin">관리자</span>
        <div class="topbar-avatar">A</div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var t = document.querySelector('#title li');
    if (t) document.getElementById('topbar-title').textContent = t.textContent.trim();

    var pg = document.getElementById('paging');
    var tb = document.getElementById('table');
    if (pg) {
        var n = 0;
        pg.querySelectorAll('a').forEach(function(a) { if (/^\d+$/.test(a.textContent.trim())) n++; });
        pg.querySelectorAll('strong').forEach(function(s) { if (/^\d+$/.test(s.textContent.trim())) n++; });
        if (n <= 1) {
            pg.classList.add('single-page');
        } else if (tb) {
            tb.style.borderRadius = '8px 8px 0 0';
            tb.style.boxShadow = 'none';
        }
    }
});
</script>
