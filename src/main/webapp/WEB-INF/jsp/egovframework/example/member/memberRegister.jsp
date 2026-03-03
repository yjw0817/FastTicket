<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<%
  /**
  * @Class Name : memberRegister.jsp
  * @Description : 회원 등록/수정 화면
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <c:set var="registerFlag" value="${empty memberVO.memberId ? 'create' : 'modify'}"/>
    <title>회원
        <c:if test="${registerFlag == 'create'}">등록</c:if>
        <c:if test="${registerFlag == 'modify'}">수정</c:if>
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=4"/>

    <!--For Commons Validator Client Side-->
    <script type="text/javascript" src="<c:url value='/cmmn/validator.do'/>"></script>
    <validator:javascript formName="memberVO" staticJavascript="false" xhtml="true" cdata="false"/>

    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        /* 목록 화면 function */
        function fn_egov_selectList() {
            document.detailForm.action = "<c:url value='/memberList.do'/>";
            document.detailForm.submit();
        }

        /* 삭제 function */
        function fn_egov_delete() {
            document.detailForm.action = "<c:url value='/deleteMember.do'/>";
            document.detailForm.submit();
        }

        /* 저장 function */
        function fn_egov_save() {
            frm = document.detailForm;
            if (!validateMemberVO(frm)) {
                return;
            } else {
                frm.action = "<c:url value="${registerFlag == 'create' ? '/addMember.do' : '/updateMember.do'}"/>";
                frm.submit();
            }
        }

        //-->
    </script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/egovframework/example/cmmn/header.jsp" />

<form:form commandName="memberVO" id="detailForm" name="detailForm">
    <div id="content_pop">
        <!-- 타이틀 -->
        <div id="title">
            <ul>
                <li><img src="<c:url value='/images/egovframework/example/title_dot.gif'/>" alt=""/>
                    <c:if test="${registerFlag == 'create'}">회원 등록</c:if>
                    <c:if test="${registerFlag == 'modify'}">회원 수정</c:if>
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
                        <td class="tbtd_caption"><label for="memberId">회원ID</label></td>
                        <td class="tbtd_content">
                            <form:input path="memberId" cssClass="essentiality" maxlength="16" readonly="true" />
                        </td>
                    </tr>
                </c:if>
                <tr>
                    <td class="tbtd_caption"><label for="memberNm">이름</label></td>
                    <td class="tbtd_content">
                        <form:input path="memberNm" maxlength="50" cssClass="txt"/>
                        &nbsp;<form:errors path="memberNm" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="password">비밀번호</label></td>
                    <td class="tbtd_content">
                        <input type="password" id="password" name="password" maxlength="100" class="txt" value=""/>
                        &nbsp;<form:errors path="password" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="tel">전화번호</label></td>
                    <td class="tbtd_content">
                        <form:input path="tel" maxlength="20" cssClass="txt"/>
                        &nbsp;<form:errors path="tel" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="email">이메일</label></td>
                    <td class="tbtd_content">
                        <form:input path="email" maxlength="100" cssClass="txt"/>
                        &nbsp;<form:errors path="email" />
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
