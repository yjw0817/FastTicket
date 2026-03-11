<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<%
  /**
  * @Class Name : roleRegister.jsp
  * @Description : 권한 등록/수정 화면
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <c:set var="registerFlag" value="${empty roleVO.roleId ? 'create' : 'modify'}"/>
    <title>권한
        <c:if test="${registerFlag == 'create'}">등록</c:if>
        <c:if test="${registerFlag == 'modify'}">수정</c:if>
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=5"/>

    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        /* 목록 화면 function */
        function fn_egov_selectList() {
            document.detailForm.action = "<c:url value='/roleList.do'/>";
            document.detailForm.submit();
        }

        /* 삭제 function */
        function fn_egov_delete() {
            document.detailForm.action = "<c:url value='/deleteRole.do'/>";
            document.detailForm.submit();
        }

        /* 저장 function */
        function fn_egov_save() {
            frm = document.detailForm;

            if (frm.roleId.value == '') {
                alert('권한ID를 입력하세요.');
                frm.roleId.focus();
                return;
            }
            if (frm.roleNm.value == '') {
                alert('권한명을 입력하세요.');
                frm.roleNm.focus();
                return;
            }

            frm.action = "<c:url value="${registerFlag == 'create' ? '/addRole.do' : '/updateRole.do'}"/>";
            frm.submit();
        }

        //-->
    </script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />

<form:form modelAttribute="roleVO" id="detailForm" name="detailForm">
    <div id="content_pop">
        <!-- 타이틀 -->
        <div id="title">
            <ul>
                <li><img src="<c:url value='/images/ftk/title_dot.gif'/>" alt=""/>
                    <c:if test="${registerFlag == 'create'}">권한 등록</c:if>
                    <c:if test="${registerFlag == 'modify'}">권한 수정</c:if>
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
                <tr>
                    <td class="tbtd_caption"><label for="roleId">권한ID</label></td>
                    <td class="tbtd_content">
                        <c:if test="${registerFlag == 'create'}">
                            <form:input path="roleId" maxlength="20" cssClass="txt"/>
                        </c:if>
                        <c:if test="${registerFlag == 'modify'}">
                            <form:input path="roleId" cssClass="essentiality" maxlength="20" readonly="true" />
                        </c:if>
                        &nbsp;<form:errors path="roleId" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="roleNm">권한명</label></td>
                    <td class="tbtd_content">
                        <form:input path="roleNm" maxlength="50" cssClass="txt"/>
                        &nbsp;<form:errors path="roleNm" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="description">설명</label></td>
                    <td class="tbtd_content">
                        <form:textarea path="description" rows="5" cols="58" />
                        &nbsp;<form:errors path="description" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="useYn">사용여부</label></td>
                    <td class="tbtd_content">
                        <form:select path="useYn" cssClass="use">
                            <form:option value="Y" label="Yes" />
                            <form:option value="N" label="No" />
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
