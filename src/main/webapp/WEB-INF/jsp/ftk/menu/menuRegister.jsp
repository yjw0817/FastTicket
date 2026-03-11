<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<%
  /**
  * @Class Name : menuRegister.jsp
  * @Description : 메뉴 등록/수정 화면
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <c:set var="registerFlag" value="${empty menuVO.menuId ? 'create' : 'modify'}"/>
    <title>메뉴
        <c:if test="${registerFlag == 'create'}">등록</c:if>
        <c:if test="${registerFlag == 'modify'}">수정</c:if>
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=5"/>

    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        /* 목록 화면 function */
        function fn_egov_selectList() {
            document.detailForm.action = "<c:url value='/menuList.do'/>";
            document.detailForm.submit();
        }

        /* 삭제 function */
        function fn_egov_delete() {
            document.detailForm.action = "<c:url value='/deleteMenu.do'/>";
            document.detailForm.submit();
        }

        /* 저장 function */
        function fn_egov_save() {
            frm = document.detailForm;
            frm.action = "<c:url value="${registerFlag == 'create' ? '/addMenu.do' : '/updateMenu.do'}"/>";
            frm.submit();
        }

        //-->
    </script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />

<form:form modelAttribute="menuVO" id="detailForm" name="detailForm">
    <div id="content_pop">
        <!-- 타이틀 -->
        <div id="title">
            <ul>
                <li><img src="<c:url value='/images/ftk/title_dot.gif'/>" alt=""/>
                    <c:if test="${registerFlag == 'create'}">메뉴 등록</c:if>
                    <c:if test="${registerFlag == 'modify'}">메뉴 수정</c:if>
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
                        <td class="tbtd_caption"><label for="menuId">메뉴ID</label></td>
                        <td class="tbtd_content">
                            <form:input path="menuId" cssClass="essentiality" maxlength="16" readonly="true" />
                        </td>
                    </tr>
                </c:if>
                <tr>
                    <td class="tbtd_caption"><label for="menuNm">메뉴명</label></td>
                    <td class="tbtd_content">
                        <form:input path="menuNm" maxlength="50" cssClass="txt"/>
                        &nbsp;<form:errors path="menuNm" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="menuUrl">URL</label></td>
                    <td class="tbtd_content">
                        <form:input path="menuUrl" maxlength="200" cssClass="txt"/>
                        &nbsp;<form:errors path="menuUrl" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="parentId">상위메뉴</label></td>
                    <td class="tbtd_content">
                        <form:select path="parentId" cssClass="use">
                            <form:option value="" label="-- 선택 --" />
                            <c:forEach var="parent" items="${parentMenuList}">
                                <form:option value="${parent.menuId}" label="${parent.menuNm}" />
                            </c:forEach>
                        </form:select>
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="sortOrder">정렬순서</label></td>
                    <td class="tbtd_content">
                        <form:input path="sortOrder" maxlength="10" cssClass="txt"/>
                        &nbsp;<form:errors path="sortOrder" />
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
