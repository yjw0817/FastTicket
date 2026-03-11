<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
  /**
  * @Class Name : roleMenuRegister.jsp
  * @Description : 권한-메뉴 매핑 등록 화면
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>메뉴 매핑</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=5"/>

    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        /* 목록 화면 function */
        function fn_egov_selectList() {
            document.detailForm.action = "<c:url value='/roleMenuList.do'/>";
            document.detailForm.submit();
        }

        /* 저장 function */
        function fn_egov_save() {
            var frm = document.detailForm;
            if (frm.roleId.value == '') {
                alert('권한을 선택해주세요.');
                return;
            }
            if (frm.menuId.value == '') {
                alert('메뉴를 선택해주세요.');
                return;
            }
            frm.action = "<c:url value='/addRoleMenu.do'/>";
            frm.submit();
        }

        //-->
    </script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />

<form:form modelAttribute="roleMenuVO" id="detailForm" name="detailForm" method="post">
    <div id="content_pop">
        <!-- 타이틀 -->
        <div id="title">
            <ul>
                <li><img src="<c:url value='/images/ftk/title_dot.gif'/>" alt=""/>메뉴 매핑</li>
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
                    <td class="tbtd_caption"><label for="roleId">권한</label></td>
                    <td class="tbtd_content">
                        <form:select path="roleId" cssClass="form-select form-select-sm" style="width:auto;">
                            <form:option value="" label="-- 권한 선택 --" />
                            <c:forEach var="role" items="${roleList}">
                                <form:option value="${role.roleId}" label="${role.roleId} - ${role.roleNm}" />
                            </c:forEach>
                        </form:select>
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="menuId">메뉴</label></td>
                    <td class="tbtd_content">
                        <form:select path="menuId" cssClass="form-select form-select-sm" style="width:auto;">
                            <form:option value="" label="-- 메뉴 선택 --" />
                            <c:forEach var="menu" items="${menuList}">
                                <form:option value="${menu.menuId}" label="${menu.menuId} - ${menu.menuNm}" />
                            </c:forEach>
                        </form:select>
                    </td>
                </tr>
            </table>
        </div>
        <div id="sysbtn">
            <a class="btn btn-outline-secondary btn-sm" href="javascript:fn_egov_selectList();">목록</a>
            <a class="btn btn-primary btn-sm" href="javascript:fn_egov_save();">등록</a>
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
