<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>프로그램 목록</title>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=2"/>
    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        function fn_egov_select(id) {
            document.listForm.selectedId.value = id;
            document.listForm.action = "<c:url value='/updateProgramView.do'/>";
            document.listForm.submit();
        }

        function fn_egov_addView() {
            document.listForm.action = "<c:url value='/addProgram.do'/>";
            document.listForm.submit();
        }

        function fn_egov_selectList() {
            document.listForm.action = "<c:url value='/programList.do'/>";
            document.listForm.submit();
        }

        function fn_egov_link_page(pageNo) {
            document.listForm.pageIndex.value = pageNo;
            document.listForm.action = "<c:url value='/programList.do'/>";
            document.listForm.submit();
        }
        //-->
    </script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/egovframework/example/cmmn/header.jsp" />
    <form:form commandName="searchVO" id="listForm" name="listForm" method="post">
        <input type="hidden" name="selectedId" />
        <div id="content_pop">
            <!-- 타이틀 -->
            <div id="title">
                <ul>
                    <li><img src="<c:url value='/images/egovframework/example/title_dot.gif'/>" alt=""/>프로그램 목록</li>
                </ul>
            </div>
            <!-- // 타이틀 -->
            <div id="search">
                <ul>
                    <li>
                        <label for="searchCondition" style="visibility:hidden;">검색조건</label>
                        <form:select path="searchCondition" cssClass="use">
                            <form:option value="1" label="프로그램명" />
                            <form:option value="0" label="프로그램ID" />
                        </form:select>
                    </li>
                    <li>
                        <label for="searchKeyword" style="visibility:hidden;display:none;">검색어</label>
                        <form:input path="searchKeyword" cssClass="txt"/>
                    </li>
                    <li>
                        <span class="btn_blue_l">
                            <a href="javascript:fn_egov_selectList();">검색</a>
                            <img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" style="margin-left:6px;" alt=""/>
                        </span>
                    </li>
                </ul>
            </div>
            <!-- List -->
            <div id="table">
                <table width="100%" border="0" cellpadding="0" cellspacing="0" summary="프로그램 목록 테이블">
                    <caption style="visibility:hidden">프로그램ID, 프로그램명, 유형, 공연장, 시작일, 종료일, 사용여부 표시 테이블</caption>
                    <colgroup>
                        <col width="40"/>
                        <col width="110"/>
                        <col width="160"/>
                        <col width="100"/>
                        <col width="120"/>
                        <col width="90"/>
                        <col width="90"/>
                        <col width="70"/>
                    </colgroup>
                    <tr>
                        <th align="center">No</th>
                        <th align="center">프로그램ID</th>
                        <th align="center">프로그램명</th>
                        <th align="center">유형</th>
                        <th align="center">공연장</th>
                        <th align="center">시작일</th>
                        <th align="center">종료일</th>
                        <th align="center">사용여부</th>
                    </tr>
                    <c:forEach var="result" items="${resultList}" varStatus="status">
                        <tr>
                            <td align="center" class="listtd"><c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/></td>
                            <td align="center" class="listtd"><a href="javascript:fn_egov_select('<c:out value="${result.programId}"/>')"><c:out value="${result.programId}"/></a></td>
                            <td align="left"   class="listtd"><c:out value="${result.programNm}"/>&nbsp;</td>
                            <td align="center" class="listtd">
                                <c:choose>
                                    <c:when test="${result.programType == 'ADMISSION'}">입장권</c:when>
                                    <c:when test="${result.programType == 'PERFORMANCE'}">공연</c:when>
                                    <c:when test="${result.programType == 'MUSICAL'}">뮤지컬</c:when>
                                    <c:otherwise><c:out value="${result.programType}"/></c:otherwise>
                                </c:choose>
                            </td>
                            <td align="left"   class="listtd"><c:out value="${result.venueNm}"/>&nbsp;</td>
                            <td align="center" class="listtd"><c:out value="${result.startDate}"/>&nbsp;</td>
                            <td align="center" class="listtd"><c:out value="${result.endDate}"/>&nbsp;</td>
                            <td align="center" class="listtd"><c:out value="${result.useYn}"/>&nbsp;</td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
            <!-- /List -->
            <div id="paging">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
                <form:hidden path="pageIndex" />
            </div>
            <div id="sysbtn">
                <ul>
                    <li>
                        <span class="btn_blue_l">
                            <a href="javascript:fn_egov_addView();">등록</a>
                            <img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" style="margin-left:6px;" alt=""/>
                        </span>
                    </li>
                </ul>
            </div>
        </div>
    </form:form>
</body>
</html>
