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
    <c:set var="registerFlag" value="${empty ticketTypeVO.typeId ? 'create' : 'modify'}"/>
    <title>권종
        <c:if test="${registerFlag == 'create'}">등록</c:if>
        <c:if test="${registerFlag == 'modify'}">수정</c:if>
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=5"/>

    <script type="text/javascript" src="<c:url value='/cmmn/validator.do'/>"></script>
    <validator:javascript formName="ticketTypeVO" staticJavascript="false" xhtml="true" cdata="false"/>

    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        function fn_egov_selectList() {
            document.detailForm.action = "<c:url value='/ticketTypeList.do'/>";
            document.detailForm.submit();
        }

        function fn_egov_delete() {
            if (confirm("삭제하시겠습니까?")) {
                document.detailForm.action = "<c:url value='/deleteTicketType.do'/>";
                document.detailForm.submit();
            }
        }

        function fn_egov_save() {
            frm = document.detailForm;
            if (!validateTicketTypeVO(frm)) {
                return;
            } else {
                frm.action = "<c:url value="${registerFlag == 'create' ? '/addTicketType.do' : '/updateTicketType.do'}"/>";
                frm.submit();
            }
        }
        //-->
    </script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />

<form:form modelAttribute="ticketTypeVO" id="detailForm" name="detailForm">
    <div id="content_pop">
        <!-- 타이틀 -->
        <div id="title">
            <ul>
                <li><img src="<c:url value='/images/ftk/title_dot.gif'/>" alt=""/>
                    <c:if test="${registerFlag == 'create'}">권종 등록</c:if>
                    <c:if test="${registerFlag == 'modify'}">권종 수정</c:if>
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
                        <td class="tbtd_caption"><label for="typeId">권종ID</label></td>
                        <td class="tbtd_content">
                            <form:input path="typeId" cssClass="essentiality" maxlength="16" readonly="true" />
                        </td>
                    </tr>
                </c:if>
                <tr>
                    <td class="tbtd_caption"><label for="typeNm">권종명</label></td>
                    <td class="tbtd_content">
                        <form:input path="typeNm" maxlength="100" cssClass="txt" placeholder="예: 어린이, 청소년, 성인, 경로"/>
                        &nbsp;<form:errors path="typeNm" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="sortOrder">정렬순서</label></td>
                    <td class="tbtd_content">
                        <form:input path="sortOrder" maxlength="3" cssClass="txt" placeholder="숫자가 작을수록 먼저 표시"/>
                        &nbsp;<form:errors path="sortOrder" />
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
    <input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
    <input type="hidden" name="pageIndex" value="<c:out value='${searchVO.pageIndex}'/>"/>
</form:form>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
