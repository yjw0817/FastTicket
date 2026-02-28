<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <c:set var="registerFlag" value="${empty scheduleVO.scheduleId ? 'create' : 'modify'}"/>
    <title>공연일정
        <c:if test="${registerFlag == 'create'}">등록</c:if>
        <c:if test="${registerFlag == 'modify'}">수정</c:if>
    </title>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=2"/>

    <script type="text/javascript" src="<c:url value='/cmmn/validator.do'/>"></script>
    <validator:javascript formName="scheduleVO" staticJavascript="false" xhtml="true" cdata="false"/>

    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        function fn_egov_selectList() {
            document.detailForm.action = "<c:url value='/scheduleList.do'/>";
            document.detailForm.submit();
        }

        function fn_egov_delete() {
            document.detailForm.action = "<c:url value='/deleteSchedule.do'/>";
            document.detailForm.submit();
        }

        function fn_egov_save() {
            frm = document.detailForm;
            if (!validateScheduleVO(frm)) {
                return;
            } else {
                frm.action = "<c:url value="${registerFlag == 'create' ? '/addSchedule.do' : '/updateSchedule.do'}"/>";
                frm.submit();
            }
        }
        //-->
    </script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/egovframework/example/cmmn/header.jsp" />

<form:form commandName="scheduleVO" id="detailForm" name="detailForm">
    <div id="content_pop">
        <!-- 타이틀 -->
        <div id="title">
            <ul>
                <li><img src="<c:url value='/images/egovframework/example/title_dot.gif'/>" alt=""/>
                    <c:if test="${registerFlag == 'create'}">공연일정 등록</c:if>
                    <c:if test="${registerFlag == 'modify'}">공연일정 수정</c:if>
                </li>
            </ul>
        </div>
        <!-- // 타이틀 -->
        <div id="table">
            <table width="100%" border="1" cellpadding="0" cellspacing="0"
                   style="bordercolor:#D3E2EC; bordercolordark:#FFFFFF; BORDER-TOP:#C2D0DB 2px solid; BORDER-LEFT:#ffffff 1px solid; BORDER-RIGHT:#ffffff 1px solid; BORDER-BOTTOM:#C2D0DB 1px solid; border-collapse: collapse;">
                <colgroup>
                    <col width="150"/>
                    <col width="?"/>
                </colgroup>
                <c:if test="${registerFlag == 'modify'}">
                    <tr>
                        <td class="tbtd_caption"><label for="scheduleId">일정ID</label></td>
                        <td class="tbtd_content">
                            <form:input path="scheduleId" cssClass="essentiality" maxlength="16" readonly="true" />
                        </td>
                    </tr>
                </c:if>
                <tr>
                    <td class="tbtd_caption"><label for="programId">프로그램</label></td>
                    <td class="tbtd_content">
                        <form:select path="programId" cssClass="use">
                            <form:option value="" label="-- 선택 --" />
                            <c:forEach var="program" items="${programList}">
                                <form:option value="${program.PROGRAM_ID}" label="${program.PROGRAM_NM}" />
                            </c:forEach>
                        </form:select>
                        &nbsp;<form:errors path="programId" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="eventDate">공연일</label></td>
                    <td class="tbtd_content">
                        <form:input path="eventDate" maxlength="10" cssClass="txt" placeholder="YYYY-MM-DD"/>
                        &nbsp;<form:errors path="eventDate" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="eventTime">공연시간</label></td>
                    <td class="tbtd_content">
                        <form:input path="eventTime" maxlength="5" cssClass="txt" placeholder="HH:mm"/>
                        &nbsp;<form:errors path="eventTime" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="totalSeats">총좌석수</label></td>
                    <td class="tbtd_content">
                        <form:input path="totalSeats" maxlength="6" cssClass="txt"/>
                        &nbsp;<form:errors path="totalSeats" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="availSeats">잔여좌석수</label></td>
                    <td class="tbtd_content">
                        <form:input path="availSeats" maxlength="6" cssClass="txt"/>
                        &nbsp;<form:errors path="availSeats" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="status">상태</label></td>
                    <td class="tbtd_content">
                        <form:select path="status" cssClass="use">
                            <form:option value="OPEN" label="오픈" />
                            <form:option value="CLOSED" label="마감" />
                            <form:option value="CANCELED" label="취소" />
                        </form:select>
                    </td>
                </tr>
            </table>
        </div>
        <div id="sysbtn">
            <ul>
                <li>
                    <span class="btn_blue_l">
                        <a href="javascript:fn_egov_selectList();">목록</a>
                        <img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" style="margin-left:6px;" alt=""/>
                    </span>
                </li>
                <li>
                    <span class="btn_blue_l">
                        <a href="javascript:fn_egov_save();">
                            <c:if test="${registerFlag == 'create'}">등록</c:if>
                            <c:if test="${registerFlag == 'modify'}">수정</c:if>
                        </a>
                        <img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" style="margin-left:6px;" alt=""/>
                    </span>
                </li>
                <c:if test="${registerFlag == 'modify'}">
                    <li>
                        <span class="btn_blue_l">
                            <a href="javascript:fn_egov_delete();">삭제</a>
                            <img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" style="margin-left:6px;" alt=""/>
                        </span>
                    </li>
                </c:if>
                <li>
                    <span class="btn_blue_l">
                        <a href="javascript:document.detailForm.reset();">초기화</a>
                        <img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" style="margin-left:6px;" alt=""/>
                    </span>
                </li>
            </ul>
        </div>
    </div>
    <!-- 검색조건 유지 -->
    <input type="hidden" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
    <input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
    <input type="hidden" name="pageIndex" value="<c:out value='${searchVO.pageIndex}'/>"/>
</form:form>
</body>
</html>
