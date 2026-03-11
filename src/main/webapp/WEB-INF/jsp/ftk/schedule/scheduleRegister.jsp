<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <c:set var="registerFlag" value="${empty scheduleVO.scheduleId ? 'create' : 'modify'}"/>
    <title>일정
        <c:if test="${registerFlag == 'create'}">등록</c:if>
        <c:if test="${registerFlag == 'modify'}">수정</c:if>
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=5"/>

    <script type="text/javascript" src="<c:url value='/cmmn/validator.do'/>"></script>
    <validator:javascript formName="scheduleVO" staticJavascript="false" xhtml="true" cdata="false"/>

    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        function fn_egov_selectList() {
            document.detailForm.action = "<c:url value='/scheduleList.do'/>";
            document.detailForm.submit();
        }

        function fn_egov_delete() {
            if (confirm("삭제하시겠습니까?")) {
                document.detailForm.action = "<c:url value='/deleteSchedule.do'/>";
                document.detailForm.submit();
            }
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
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />

<form:form modelAttribute="scheduleVO" id="detailForm" name="detailForm">
    <div id="content_pop">
        <!-- 타이틀 -->
        <div id="title">
            <ul>
                <li><img src="<c:url value='/images/ftk/title_dot.gif'/>" alt=""/>
                    <c:if test="${registerFlag == 'create'}">일정 등록</c:if>
                    <c:if test="${registerFlag == 'modify'}">일정 수정</c:if>
                </li>
            </ul>
        </div>
        <!-- // 타이틀 -->
        <div id="table" class="table-responsive">
            <table class="table" style="border-top:2px solid #C2D0DB; border-collapse:collapse;">
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
                                <form:option value="${program.programId}" label="${program.programNm}" />
                            </c:forEach>
                        </form:select>
                        &nbsp;<form:errors path="programId" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="eventDate">날짜</label></td>
                    <td class="tbtd_content">
                        <form:input path="eventDate" maxlength="10" cssClass="txt" placeholder="YYYY-MM-DD"/>
                        &nbsp;<form:errors path="eventDate" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="eventTime">시간</label></td>
                    <td class="tbtd_content">
                        <form:input path="eventTime" maxlength="5" cssClass="txt" placeholder="HH:mm"/>
                        &nbsp;<form:errors path="eventTime" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="sessionNo">회차</label></td>
                    <td class="tbtd_content">
                        <form:input path="sessionNo" maxlength="3" cssClass="txt" placeholder="예: 1, 2, 3"/>
                        &nbsp;<form:errors path="sessionNo" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="onlineCapacity">온라인 정원</label></td>
                    <td class="tbtd_content">
                        <form:input path="onlineCapacity" maxlength="6" cssClass="txt"/>
                        &nbsp;<form:errors path="onlineCapacity" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="offlineCapacity">오프라인 정원</label></td>
                    <td class="tbtd_content">
                        <form:input path="offlineCapacity" maxlength="6" cssClass="txt"/>
                        &nbsp;<form:errors path="offlineCapacity" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="totalSeats">총정원</label></td>
                    <td class="tbtd_content">
                        <form:input path="totalSeats" maxlength="6" cssClass="txt" readonly="true"/>
                        <span class="text-muted" style="font-size:12px;">(온라인 + 오프라인 자동 계산)</span>
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
            <a class="btn btn-outline-secondary btn-sm" href="javascript:fn_egov_selectList();">목록</a>
            <a class="btn btn-primary btn-sm" href="javascript:fn_egov_save();">
                <c:if test="${registerFlag == 'create'}">등록</c:if>
                <c:if test="${registerFlag == 'modify'}">수정</c:if>
            </a>
            <c:if test="${registerFlag == 'modify'}">
                <a class="btn btn-danger btn-sm" href="javascript:fn_egov_delete();">삭제</a>
            </c:if>
            <a class="btn btn-outline-secondary btn-sm" href="javascript:document.detailForm.reset();">초기화</a>
        </div>
    </div>
    <!-- 검색조건 유지 -->
    <input type="hidden" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
    <input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
    <input type="hidden" name="pageIndex" value="<c:out value='${searchVO.pageIndex}'/>"/>
</form:form>

<script>
// 온라인 + 오프라인 정원 합산 → 총정원 자동 계산
(function() {
    var onlineEl = document.getElementById('onlineCapacity');
    var offlineEl = document.getElementById('offlineCapacity');
    var totalEl = document.getElementById('totalSeats');

    function calcTotal() {
        var online = parseInt(onlineEl.value) || 0;
        var offline = parseInt(offlineEl.value) || 0;
        totalEl.value = online + offline;
    }

    if (onlineEl && offlineEl && totalEl) {
        onlineEl.addEventListener('input', calcTotal);
        offlineEl.addEventListener('input', calcTotal);
    }
})();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
