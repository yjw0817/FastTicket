<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="uri" value="${requestScope['javax.servlet.forward.request_uri']}" />
<div id="sidebar">
    <div class="sidebar-title"><span>Fast</span>Ticket</div>
    <ul class="menu">
        <li class="${fn:contains(uri, 'venue') ? 'active' : ''}"><a href="<c:url value='/venueList.do'/>">공연장</a></li>
        <li class="${fn:contains(uri, 'program') ? 'active' : ''}"><a href="<c:url value='/programList.do'/>">프로그램</a></li>
        <li class="${fn:contains(uri, 'schedule') ? 'active' : ''}"><a href="<c:url value='/scheduleList.do'/>">일정</a></li>
        <li class="${fn:contains(uri, 'ticketPrice') ? 'active' : ''}"><a href="<c:url value='/ticketPriceList.do'/>">가격</a></li>
        <li class="${fn:contains(uri, 'seat') ? 'active' : ''}"><a href="<c:url value='/seatList.do'/>">좌석</a></li>
        <li class="${fn:contains(uri, 'booking') ? 'active' : ''}"><a href="<c:url value='/bookingList.do'/>">예매</a></li>
        <li class="${fn:contains(uri, 'member') ? 'active' : ''}"><a href="<c:url value='/memberList.do'/>">회원</a></li>
        <li class="${fn:contains(uri, 'Sample') || fn:contains(uri, 'sample') ? 'active' : ''}"><a href="<c:url value='/egovSampleList.do'/>">Sample</a></li>
    </ul>
</div>
<style>
/* Button overrides — ensures styles apply regardless of CSS cache */
.btn_blue_l { float:left; display:inline-block; background:#3b82f6 !important; padding:7px 18px; margin:0 2px; border-radius:6px; cursor:pointer; transition:background 0.2s; }
.btn_blue_l:hover { background:#2563eb !important; }
.btn_blue_l a, .btn_blue_l a:link, .btn_blue_l a:visited, .btn_blue_l a:hover, .btn_blue_l a:active { color:#fff !important; font-size:13px; font-weight:500; text-decoration:none; }
.btn_blue_l img { display:none !important; }
.btn_blue_r { display:inline-block; background:#3b82f6; color:#fff; padding:7px 18px; margin:0 2px; border-radius:6px; cursor:pointer; }
.btn_blue_r:hover { background:#2563eb; }
.btn_blue_r a, .btn_blue_r a:link, .btn_blue_r a:visited { color:#fff !important; text-decoration:none; }
</style>
