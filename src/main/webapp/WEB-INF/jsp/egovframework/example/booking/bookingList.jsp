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
    <title>예매 관리</title>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=2"/>
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
                <ul>
                    <li>
                        <label for="searchCondition" style="visibility:hidden;">검색조건</label>
                        <form:select path="searchCondition" cssClass="use">
                            <form:option value="1" label="예매자명" />
                            <form:option value="0" label="예매ID" />
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
            <!-- 목록 테이블 -->
            <div id="table">
                <table width="100%" border="0" cellpadding="0" cellspacing="0"
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
                                    <c:when test="${result.booking_status == 'RESERVED'}">예매완료</c:when>
                                    <c:when test="${result.booking_status == 'CANCELED'}">취소</c:when>
                                    <c:when test="${result.booking_status == 'COMPLETED'}">완료</c:when>
                                    <c:otherwise><c:out value="${result.booking_status}"/></c:otherwise>
                                </c:choose>
                            </td>
                            <td align="center" class="listtd">
                                <c:choose>
                                    <c:when test="${result.payment_status == 'PENDING'}">미결제</c:when>
                                    <c:when test="${result.payment_status == 'PAID'}">결제완료</c:when>
                                    <c:when test="${result.payment_status == 'REFUNDED'}">환불</c:when>
                                    <c:otherwise><c:out value="${result.payment_status}"/></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty resultList}">
                        <tr>
                            <td colspan="10" align="center" class="listtd">조회된 예매 내역이 없습니다.</td>
                        </tr>
                    </c:if>
                </table>
            </div>
            <!-- 페이징 -->
            <div id="paging">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
                <form:hidden path="pageIndex" />
            </div>
            <!-- 버튼 -->
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
