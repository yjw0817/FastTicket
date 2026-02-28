<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <c:set var="registerFlag" value="${empty programVO.programId ? 'create' : 'modify'}"/>
    <title>프로그램 <c:if test="${registerFlag == 'create'}">등록</c:if><c:if test="${registerFlag == 'modify'}">수정</c:if></title>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=2"/>
    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        function fn_egov_selectList() {
            document.detailForm.action = "<c:url value='/programList.do'/>";
            document.detailForm.submit();
        }

        function fn_egov_delete() {
            document.detailForm.action = "<c:url value='/deleteProgram.do'/>";
            document.detailForm.submit();
        }

        function fn_egov_save() {
            var frm = document.detailForm;
            if (frm.programNm.value == '') {
                alert('프로그램명을 입력하세요.');
                frm.programNm.focus();
                return;
            }
            if (frm.programType.value == '') {
                alert('프로그램 유형을 선택하세요.');
                frm.programType.focus();
                return;
            }
            frm.action = "<c:url value="${registerFlag == 'create' ? '/addProgram.do' : '/updateProgram.do'}"/>";
            frm.submit();
        }
        //-->
    </script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/egovframework/example/cmmn/header.jsp" />
<form:form commandName="programVO" id="detailForm" name="detailForm">
    <div id="content_pop">
        <!-- 타이틀 -->
        <div id="title">
            <ul>
                <li><img src="<c:url value='/images/egovframework/example/title_dot.gif'/>" alt=""/>
                    <c:if test="${registerFlag == 'create'}">프로그램 등록</c:if>
                    <c:if test="${registerFlag == 'modify'}">프로그램 수정</c:if>
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
                        <td class="tbtd_caption"><label for="programId">프로그램ID</label></td>
                        <td class="tbtd_content">
                            <form:input path="programId" cssClass="essentiality" maxlength="16" readonly="true" />
                        </td>
                    </tr>
                </c:if>
                <tr>
                    <td class="tbtd_caption"><label for="programNm">프로그램명</label></td>
                    <td class="tbtd_content">
                        <form:input path="programNm" cssClass="txt" maxlength="200" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="programType">유형</label></td>
                    <td class="tbtd_content">
                        <form:select path="programType" cssClass="use">
                            <form:option value=""           label="-- 유형 선택 --" />
                            <form:option value="ADMISSION"  label="입장권 (ADMISSION)" />
                            <form:option value="PERFORMANCE" label="공연 (PERFORMANCE)" />
                            <form:option value="MUSICAL"    label="뮤지컬 (MUSICAL)" />
                        </form:select>
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="venueId">공연장</label></td>
                    <td class="tbtd_content">
                        <select name="venueId" id="venueId" class="use">
                            <option value="">-- 공연장 선택 --</option>
                            <c:forEach var="venue" items="${venueList}">
                                <option value="${venue.venueId}"
                                    <c:if test="${programVO.venueId == venue.venueId}">selected</c:if>>
                                    <c:out value="${venue.venueNm}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="description">설명</label></td>
                    <td class="tbtd_content">
                        <form:textarea path="description" rows="5" cols="58" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="ageLimit">연령제한</label></td>
                    <td class="tbtd_content">
                        <form:input path="ageLimit" cssClass="txt" maxlength="50" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="runningTime">공연시간 (분)</label></td>
                    <td class="tbtd_content">
                        <form:input path="runningTime" cssClass="txt" maxlength="5" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="startDate">시작일</label></td>
                    <td class="tbtd_content">
                        <form:input path="startDate" cssClass="txt" maxlength="10" placeholder="YYYY-MM-DD" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="endDate">종료일</label></td>
                    <td class="tbtd_content">
                        <form:input path="endDate" cssClass="txt" maxlength="10" placeholder="YYYY-MM-DD" />
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
                <tr>
                    <td class="tbtd_caption"><label for="regUser">등록자</label></td>
                    <td class="tbtd_content">
                        <c:if test="${registerFlag == 'modify'}">
                            <form:input path="regUser" cssClass="essentiality" maxlength="10" readonly="true" />
                        </c:if>
                        <c:if test="${registerFlag != 'modify'}">
                            <form:input path="regUser" cssClass="txt" maxlength="10" />
                        </c:if>
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
    <input type="hidden" name="searchKeyword"   value="<c:out value='${searchVO.searchKeyword}'/>"/>
    <input type="hidden" name="pageIndex"       value="<c:out value='${searchVO.pageIndex}'/>"/>
</form:form>
</body>
</html>
