<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>프로그램 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=7"/>
    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        function fn_egov_select(id) {
            document.listForm.selectedId.value = id;
            document.listForm.action = "<c:url value='/updateProgramView.do'/>";
            document.listForm.submit();
        }

        function fn_egov_addView() {
            location.href = "<c:url value='/addProgram.do'/>";
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
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />
    <form:form modelAttribute="searchVO" id="listForm" name="listForm" method="post">
        <input type="hidden" name="selectedId" />
        <div id="content_pop">
            <div id="search">
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <a class="btn btn-primary btn-sm" href="javascript:fn_egov_addView();">등록</a>
                    <div class="d-flex align-items-center gap-2 ms-auto">
                        <select name="searchCondition3" class="form-select form-select-sm" style="width:auto" onchange="fn_egov_selectList();">
                            <option value="">전체 장소</option>
                            <c:forEach var="venue" items="${venueList}">
                                <option value="${venue.venueId}" <c:if test="${searchVO.searchCondition3 == venue.venueId}">selected</c:if>><c:out value="${venue.venueNm}"/></option>
                            </c:forEach>
                        </select>
                        <form:select path="searchCondition" cssClass="form-select form-select-sm" style="width:auto">
                            <form:option value="1" label="프로그램명" />
                            <form:option value="2" label="장소/시설" />
                            <form:option value="0" label="프로그램ID" />
                        </form:select>
                        <form:input path="searchKeyword" cssClass="form-control form-control-sm"/>
                        <a class="btn btn-outline-secondary btn-sm" href="javascript:fn_egov_selectList();">검색</a>
                    </div>
                </div>
            </div>
            <!-- List -->
            <div id="table" class="table-responsive">
                <table class="table table-hover table-striped" summary="프로그램 목록 테이블">
                    <caption style="visibility:hidden">장소/시설, 프로그램ID, 프로그램명, 유형, 시작일, 종료일, 사용여부 표시 테이블</caption>
                    <colgroup>
                        <col width="120"/>
                        <col width="110"/>
                        <col width="160"/>
                        <col width="100"/>
                        <col width="90"/>
                        <col width="90"/>
                        <col width="70"/>
                    </colgroup>
                    <tr>
                        <th align="center">장소/시설</th>
                        <th align="center">프로그램ID</th>
                        <th align="center">프로그램명</th>
                        <th align="center">유형</th>
                        <th align="center">시작일</th>
                        <th align="center">종료일</th>
                        <th align="center">사용여부</th>
                    </tr>
                    <c:forEach var="result" items="${resultList}" varStatus="status">
                        <tr>
                            <td align="left"   class="listtd"><c:out value="${result.venueNm}"/>&nbsp;</td>
                            <td align="center" class="listtd"><a href="javascript:fn_egov_select('<c:out value="${result.programId}"/>')"><c:out value="${result.programId}"/></a></td>
                            <td align="left"   class="listtd"><c:out value="${result.programNm}"/>&nbsp;</td>
                            <td align="center" class="listtd">
                                <c:choose>
                                    <c:when test="${result.programType == 'SESSION'}">회차 입장권</c:when>
                                    <c:when test="${result.programType == 'GENERAL'}">일반 입장권</c:when>
                                    <c:otherwise><c:out value="${result.programType}"/></c:otherwise>
                                </c:choose>
                            </td>
                            <td align="center" class="listtd"><c:out value="${result.startDate}"/>&nbsp;</td>
                            <td align="center" class="listtd"><c:out value="${result.endDate}"/>&nbsp;</td>
                            <td align="center" class="listtd">
                                <c:choose>
                                    <c:when test="${result.useYn == 'Y'}"><span class="badge-active">Y</span></c:when>
                                    <c:otherwise><span class="badge-inactive">N</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty resultList}">
                        <tr><td colspan="7" class="listtd">
                            <div class="empty-state">
                                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
                                <p>등록된 프로그램이 없습니다.</p>
                                <a class="btn btn-primary btn-sm" href="javascript:fn_egov_addView();">등록하기</a>
                            </div>
                        </td></tr>
                    </c:if>
                </table>
            </div>
            <!-- /List -->
            <div id="paging">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
                <form:hidden path="pageIndex" />
            </div>
            <div id="sysbtn"></div>
        </div>
    </form:form>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
