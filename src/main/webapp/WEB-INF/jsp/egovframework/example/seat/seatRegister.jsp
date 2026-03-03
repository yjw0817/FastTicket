<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <c:set var="registerFlag" value="${empty seatVO.seatId ? 'create' : 'modify'}"/>
    <title>좌석 <c:if test="${registerFlag == 'create'}">등록</c:if><c:if test="${registerFlag == 'modify'}">수정</c:if></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=4"/>
    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        function fn_egov_selectList() {
            document.detailForm.action = "<c:url value='/seatList.do'/>";
            document.detailForm.submit();
        }

        function fn_egov_delete() {
            document.detailForm.action = "<c:url value='/deleteSeat.do'/>";
            document.detailForm.submit();
        }

        function fn_egov_save() {
            var frm = document.detailForm;
            if (frm.venueId.value == '') {
                alert('공연장을 선택하세요.');
                frm.venueId.focus();
                return;
            }
            if (frm.seatRow.value == '') {
                alert('열(Row)을 입력하세요.');
                frm.seatRow.focus();
                return;
            }
            if (frm.seatNo.value == '' || isNaN(frm.seatNo.value)) {
                alert('좌석번호를 올바르게 입력하세요.');
                frm.seatNo.focus();
                return;
            }
            frm.action = "<c:url value="${registerFlag == 'create' ? '/addSeat.do' : '/updateSeat.do'}"/>";
            frm.submit();
        }
        //-->
    </script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/egovframework/example/cmmn/header.jsp" />
<form:form commandName="seatVO" id="detailForm" name="detailForm">
    <div id="content_pop">
        <!-- 타이틀 -->
        <div id="title">
            <ul>
                <li><img src="<c:url value='/images/egovframework/example/title_dot.gif'/>" alt=""/>
                    <c:if test="${registerFlag == 'create'}">좌석 등록</c:if>
                    <c:if test="${registerFlag == 'modify'}">좌석 수정</c:if>
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
                        <td class="tbtd_caption"><label for="seatId">좌석ID</label></td>
                        <td class="tbtd_content">
                            <form:input path="seatId" cssClass="essentiality" maxlength="16" readonly="true" />
                        </td>
                    </tr>
                </c:if>
                <tr>
                    <td class="tbtd_caption"><label for="venueId">공연장</label></td>
                    <td class="tbtd_content">
                        <select name="venueId" id="venueId" class="use">
                            <option value="">-- 공연장 선택 --</option>
                            <c:forEach var="venue" items="${venueList}">
                                <option value="${venue.venueId}"
                                    <c:if test="${seatVO.venueId == venue.venueId}">selected</c:if>>
                                    <c:out value="${venue.venueNm}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="seatRow">열(Row)</label></td>
                    <td class="tbtd_content">
                        <form:input path="seatRow" cssClass="txt" maxlength="5" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="seatNo">좌석번호</label></td>
                    <td class="tbtd_content">
                        <form:input path="seatNo" cssClass="txt" maxlength="5" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="seatGrade">등급</label></td>
                    <td class="tbtd_content">
                        <form:select path="seatGrade" cssClass="use">
                            <form:option value="VIP" label="VIP" />
                            <form:option value="R"   label="R" />
                            <form:option value="S"   label="S" />
                            <form:option value="A"   label="A" />
                        </form:select>
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="useYn">사용여부</label></td>
                    <td class="tbtd_content">
                        <form:select path="useYn" cssClass="use">
                            <form:option value="Y" label="사용" />
                            <form:option value="N" label="미사용" />
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
    <input type="hidden" name="searchKeyword"   value="<c:out value='${searchVO.searchKeyword}'/>"/>
    <input type="hidden" name="pageIndex"       value="<c:out value='${searchVO.pageIndex}'/>"/>
</form:form>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
