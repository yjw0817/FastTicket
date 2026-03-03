<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
  /**
  * @Class Name : bookingList.jsp
  * @Description : 예매 목록 화면
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>예매 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=4"/>
    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        /* 예매 상세/수정 화면 이동 */
        function fn_egov_select(id) {
            document.listForm.selectedId.value = id;
            document.listForm.action = "<c:url value='/updateBookingView.do'/>";
            document.listForm.submit();
        }

        /* 예매 등록 화면 이동 */
        function fn_egov_addView() {
            document.listForm.action = "<c:url value='/addBooking.do'/>";
            document.listForm.submit();
        }

        /* 목록 재조회 */
        function fn_egov_selectList() {
            document.listForm.action = "<c:url value='/bookingList.do'/>";
            document.listForm.submit();
        }

        /* 페이징 링크 */
        function fn_egov_link_page(pageNo) {
            document.listForm.pageIndex.value = pageNo;
            document.listForm.action = "<c:url value='/bookingList.do'/>";
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
                    <li><img src="<c:url value='/images/egovframework/example/title_dot.gif'/>" alt=""/>예매 목록</li>
                </ul>
            </div>
            <!-- 검색 -->
            <div id="search">
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <a class="btn btn-primary btn-sm" href="javascript:fn_egov_addView();">등록</a>
                    <div class="d-flex align-items-center gap-2 ms-auto">
                        <form:select path="searchCondition" cssClass="form-select form-select-sm">
                            <form:option value="1" label="예매자명" />
                            <form:option value="0" label="예매ID" />
                        </form:select>
                        <form:input path="searchKeyword" cssClass="form-control form-control-sm"/>
                        <a class="btn btn-outline-secondary btn-sm" href="javascript:fn_egov_selectList();">검색</a>
                    </div>
                </div>
            </div>
            <!-- 목록 테이블 -->
            <div id="table" class="table-responsive">
                <table class="table table-hover table-striped"
                       summary="예매 목록: 번호, 예매ID, 프로그램, 공연일시, 예매자, 연락처, 총수량, 총금액, 예매상태, 결제상태">
                    <caption style="visibility:hidden">예매 목록</caption>
                    <colgroup>
                        <col width="40"/>
                        <col width="110"/>
                        <col width="120"/>
                        <col width="120"/>
                        <col width="80"/>
                        <col width="100"/>
                        <col width="60"/>
                        <col width="80"/>
                        <col width="80"/>
                        <col width="80"/>
                    </colgroup>
                    <tr>
                        <th align="center">No</th>
                        <th align="center">예매ID</th>
                        <th align="center">프로그램</th>
                        <th align="center">공연일시</th>
                        <th align="center">예매자</th>
                        <th align="center">연락처</th>
                        <th align="center">총수량</th>
                        <th align="center">총금액</th>
                        <th align="center">예매상태</th>
                        <th align="center">결제상태</th>
                    </tr>
                    <c:forEach var="result" items="${resultList}" varStatus="status">
                        <tr>
                            <td align="center" class="listtd">
                                <c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/>
                            </td>
                            <td align="center" class="listtd">
                                <a href="javascript:fn_egov_select('<c:out value="${result.booking_id}"/>')">
                                    <c:out value="${result.booking_id}"/>
                                </a>
                            </td>
                            <td align="left" class="listtd">
                                <c:out value="${result.program_nm}"/>&nbsp;
                            </td>
                            <td align="center" class="listtd">
                                <c:out value="${result.event_date}"/>
                                <c:if test="${not empty result.event_time}">
                                    &nbsp;<c:out value="${result.event_time}"/>
                                </c:if>
                            </td>
                            <td align="center" class="listtd">
                                <c:out value="${result.booker_nm}"/>&nbsp;
                            </td>
                            <td align="center" class="listtd">
                                <c:out value="${result.booker_tel}"/>&nbsp;
                            </td>
                            <td align="center" class="listtd">
                                <c:out value="${result.total_qty}"/>
                            </td>
                            <td align="right" class="listtd">
                                <c:out value="${result.total_amt}"/>&nbsp;
                            </td>
                            <td align="center" class="listtd">
                                <c:choose>
                                    <c:when test="${result.booking_status == 'RESERVED'}"><span class="badge-info">예매완료</span></c:when>
                                    <c:when test="${result.booking_status == 'CANCELED'}"><span class="badge-cancel">취소</span></c:when>
                                    <c:when test="${result.booking_status == 'COMPLETED'}"><span class="badge-active">완료</span></c:when>
                                    <c:otherwise><span class="badge-inactive"><c:out value="${result.booking_status}"/></span></c:otherwise>
                                </c:choose>
                            </td>
                            <td align="center" class="listtd">
                                <c:choose>
                                    <c:when test="${result.payment_status == 'PENDING'}"><span class="badge-pending">미결제</span></c:when>
                                    <c:when test="${result.payment_status == 'PAID'}"><span class="badge-active">결제완료</span></c:when>
                                    <c:when test="${result.payment_status == 'REFUNDED'}"><span class="badge-inactive">환불</span></c:when>
                                    <c:otherwise><span class="badge-inactive"><c:out value="${result.payment_status}"/></span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty resultList}">
                        <tr><td colspan="10" class="listtd">
                            <div class="empty-state">
                                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                                <p>조회된 예매 내역이 없습니다.</p>
                                <a class="btn btn-primary btn-sm" href="javascript:fn_egov_addView();">등록하기</a>
                            </div>
                        </td></tr>
                    </c:if>
                </table>
            </div>
            <!-- 페이징 -->
            <div id="paging">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
                <form:hidden path="pageIndex" />
            </div>
            <!-- 버튼 -->
            <div id="sysbtn"></div>
        </div>
    </form:form>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
