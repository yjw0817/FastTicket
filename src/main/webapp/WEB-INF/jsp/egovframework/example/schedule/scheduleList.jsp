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
    <title>공연일정 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=4"/>
    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        function fn_egov_select(id) {
            document.listForm.selectedId.value = id;
            document.listForm.action = "<c:url value='/updateScheduleView.do'/>";
            document.listForm.submit();
        }

        function fn_egov_addView() {
            document.listForm.action = "<c:url value='/addSchedule.do'/>";
            document.listForm.submit();
        }

        function fn_egov_selectList() {
            document.listForm.action = "<c:url value='/scheduleList.do'/>";
            document.listForm.submit();
        }

        function fn_egov_link_page(pageNo) {
            document.listForm.pageIndex.value = pageNo;
            document.listForm.action = "<c:url value='/scheduleList.do'/>";
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
                    <li><img src="<c:url value='/images/egovframework/example/title_dot.gif'/>" alt=""/>공연일정 목록</li>
                </ul>
            </div>
            <!-- // 타이틀 -->
            <div id="search">
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <a class="btn btn-primary btn-sm" href="javascript:fn_egov_addView();">등록</a>
                    <div class="d-flex align-items-center gap-2 ms-auto">
                        <form:select path="searchCondition" cssClass="form-select form-select-sm">
                            <form:option value="0" label="일정ID" />
                            <form:option value="1" label="상태" />
                        </form:select>
                        <form:input path="searchKeyword" cssClass="form-control form-control-sm"/>
                        <a class="btn btn-outline-secondary btn-sm" href="javascript:fn_egov_selectList();">검색</a>
                    </div>
                </div>
            </div>
            <!-- List -->
            <div id="table" class="table-responsive">
                <table class="table table-hover table-striped" summary="일정ID, 프로그램, 공연일, 공연시간, 총좌석, 잔여석, 상태 표시하는 테이블">
                    <caption style="visibility:hidden">공연일정 목록 테이블</caption>
                    <colgroup>
                        <col width="40"/>
                        <col width="100"/>
                        <col width="120"/>
                        <col width="90"/>
                        <col width="80"/>
                        <col width="70"/>
                        <col width="70"/>
                        <col width="70"/>
                    </colgroup>
                    <tr>
                        <th align="center">No</th>
                        <th align="center">일정ID</th>
                        <th align="center">프로그램</th>
                        <th align="center">공연일</th>
                        <th align="center">공연시간</th>
                        <th align="center">총좌석</th>
                        <th align="center">잔여석</th>
                        <th align="center">상태</th>
                    </tr>
                    <c:forEach var="result" items="${resultList}" varStatus="status">
                        <tr>
                            <td align="center" class="listtd"><c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/></td>
                            <td align="center" class="listtd"><a href="javascript:fn_egov_select('<c:out value="${result.SCHEDULE_ID}"/>')"><c:out value="${result.SCHEDULE_ID}"/></a></td>
                            <td align="left" class="listtd"><c:out value="${result.PROGRAM_NM}"/>&nbsp;</td>
                            <td align="center" class="listtd"><c:out value="${result.EVENT_DATE}"/>&nbsp;</td>
                            <td align="center" class="listtd"><c:out value="${result.EVENT_TIME}"/>&nbsp;</td>
                            <td align="right" class="listtd"><c:out value="${result.TOTAL_SEATS}"/>&nbsp;</td>
                            <td align="right" class="listtd"><c:out value="${result.AVAIL_SEATS}"/>&nbsp;</td>
                            <td align="center" class="listtd">
                                <c:choose>
                                    <c:when test="${result.STATUS == 'OPEN'}"><span class="badge-active">오픈</span></c:when>
                                    <c:when test="${result.STATUS == 'CLOSED'}"><span class="badge-inactive">마감</span></c:when>
                                    <c:when test="${result.STATUS == 'CANCELED'}"><span class="badge-cancel">취소</span></c:when>
                                    <c:otherwise><span class="badge-info"><c:out value="${result.STATUS}"/></span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty resultList}">
                        <tr><td colspan="8" class="listtd">
                            <div class="empty-state">
                                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                                <p>등록된 공연일정이 없습니다.</p>
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
