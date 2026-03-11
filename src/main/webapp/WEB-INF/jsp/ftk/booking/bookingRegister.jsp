<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  /**
  * @Class Name : bookingRegister.jsp
  * @Description : 예매 등록/상세 화면
  *   - create 모드 : 공연일정 선택 -> 티켓가격별 수량 입력 -> 예매자 정보 입력 -> 저장
  *   - modify 모드 : 예매 정보 읽기전용 표시 + 예매상세 목록 표시 + 상태 변경 가능
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <c:set var="registerFlag" value="${empty bookingVO.bookingId ? 'create' : 'modify'}"/>
    <title>예매 <c:if test="${registerFlag == 'create'}">등록</c:if><c:if test="${registerFlag == 'modify'}">상세/수정</c:if></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=5"/>
    <style type="text/css">
        table.detail-table { width:100%; border-collapse:collapse; margin-top:10px; }
        table.detail-table th { background:#e8f0f8; border:1px solid #c2d0db; padding:5px 8px; text-align:center; }
        table.detail-table td { border:1px solid #d3e2ec; padding:5px 8px; }
        .price-row td { text-align:center; }
        .section-title { font-weight:bold; font-size:13px; color:#336699; margin:12px 0 5px 0; text-align:left; }
        input.qty-input { width:50px; text-align:right; }
        .total-box { text-align:right; padding:6px 4px; font-weight:bold; font-size:13px; }
        .err-msg { color:red; font-size:12px; padding:4px; }
    </style>
    <script type="text/javaScript" language="javascript" defer="defer">
        <!--

        /* 공연일정 선택 시 해당 일정의 티켓가격 목록 로드 (페이지 재제출) */
        function fn_egov_selectSchedule() {
            var sel = document.getElementById("scheduleId");
            var scheduleId = sel.options[sel.selectedIndex].value;
            if (scheduleId == "") {
                return;
            }
            location.href = "<c:url value='/addBooking.do'/>?scheduleId=" + scheduleId;
        }

        /* 수량 변경 시 합계 재계산 */
        function fn_egov_calcTotal() {
            var rows = document.querySelectorAll(".price-row");
            var totalQty = 0;
            var totalAmt = 0;
            for (var i = 0; i < rows.length; i++) {
                var qtyInput = rows[i].querySelector(".qty-input");
                var priceVal = parseInt(rows[i].getAttribute("data-price"), 10);
                if (isNaN(priceVal)) priceVal = 0;
                var qty = parseInt(qtyInput.value, 10);
                if (isNaN(qty) || qty < 0) {
                    qty = 0;
                    qtyInput.value = 0;
                }
                totalQty += qty;
                totalAmt += (qty * priceVal);
            }
            document.getElementById("totalQty").innerHTML = totalQty;
            document.getElementById("totalAmt").innerHTML = totalAmt.toLocaleString();
        }

        /* 예매 등록 저장 */
        function fn_egov_save() {
            var frm = document.detailForm;
            var bookerNm = frm.bookerNm.value;
            var bookerTel = frm.bookerTel.value;
            var scheduleId = document.getElementById("scheduleId");

            if (scheduleId && scheduleId.value == "") {
                alert("공연일정을 선택해 주세요.");
                return;
            }
            if (bookerNm == null || bookerNm.trim() == "") {
                alert("예매자명을 입력해 주세요.");
                frm.bookerNm.focus();
                return;
            }
            if (bookerTel == null || bookerTel.trim() == "") {
                alert("연락처를 입력해 주세요.");
                frm.bookerTel.focus();
                return;
            }

            // 수량 합계 검증
            var rows = document.querySelectorAll(".price-row");
            var totalQty = 0;
            for (var i = 0; i < rows.length; i++) {
                var qtyInput = rows[i].querySelector(".qty-input");
                var qty = parseInt(qtyInput.value, 10);
                if (!isNaN(qty) && qty > 0) totalQty += qty;
            }
            if (rows.length > 0 && totalQty == 0) {
                alert("1매 이상 선택해 주세요.");
                return;
            }

            frm.action = "<c:url value='/addBooking.do'/>";
            frm.submit();
        }

        /* 예매 상태 수정 저장 */
        function fn_egov_update() {
            document.detailForm.action = "<c:url value='/updateBooking.do'/>";
            document.detailForm.submit();
        }

        /* 예매 삭제 */
        function fn_egov_delete() {
            if (!confirm("예매를 삭제하시겠습니까? 예매상세도 함께 삭제됩니다.")) {
                return;
            }
            document.detailForm.action = "<c:url value='/deleteBooking.do'/>";
            document.detailForm.submit();
        }

        /* 목록으로 이동 */
        function fn_egov_selectList() {
            document.detailForm.action = "<c:url value='/bookingList.do'/>";
            document.detailForm.submit();
        }

        //-->
    </script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />

<form:form modelAttribute="bookingVO" id="detailForm" name="detailForm" method="post">

    <div id="content_pop">

        <!-- 타이틀 -->
        <div id="title">
            <ul>
                <li>
                    <img src="<c:url value='/images/ftk/title_dot.gif'/>" alt=""/>
                    예매 <c:if test="${registerFlag == 'create'}">등록</c:if><c:if test="${registerFlag == 'modify'}">상세/수정</c:if>
                </li>
            </ul>
        </div>

        <!-- 오류 메시지 -->
        <c:if test="${not empty errorMessage}">
            <div class="err-msg"><c:out value="${errorMessage}"/></div>
        </c:if>

        <div id="table" class="table-responsive">

            <%-- ===================================================== --%>
            <%-- CREATE 모드 --%>
            <%-- ===================================================== --%>
            <c:if test="${registerFlag == 'create'}">

                <!-- 공연일정 선택 -->
                <p class="section-title">1. 공연일정 선택</p>
                <table class="table" style="border-top:2px solid #C2D0DB; border-collapse:collapse;">
                    <colgroup>
                        <col width="150"/>
                        <col/>
                    </colgroup>
                    <tr>
                        <td class="tbtd_caption"><label for="scheduleId">공연일정 *</label></td>
                        <td class="tbtd_content">
                            <select id="scheduleId" name="scheduleId" class="use" onchange="fn_egov_selectSchedule();">
                                <option value="">-- 일정 선택 --</option>
                                <c:forEach var="sch" items="${scheduleList}">
                                    <option value="<c:out value="${sch.schedule_id}"/>"
                                        <c:if test="${bookingVO.scheduleId == sch.schedule_id}">selected="selected"</c:if>>
                                        <c:out value="${sch.program_nm}"/>
                                        (<c:out value="${sch.event_date}"/>
                                        <c:if test="${not empty sch.event_time}"> <c:out value="${sch.event_time}"/></c:if>)
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                </table>

                <!-- 티켓가격 및 수량 선택 (일정 선택 후 표시) -->
                <c:if test="${not empty priceList}">
                    <p class="section-title">2. 티켓 수량 선택</p>
                    <table class="detail-table">
                        <colgroup>
                            <col width="30%"/>
                            <col width="20%"/>
                            <col width="20%"/>
                            <col width="15%"/>
                            <col width="15%"/>
                        </colgroup>
                        <tr>
                            <th>티켓종류</th>
                            <th>가격유형</th>
                            <th>단가 (원)</th>
                            <th>수량</th>
                            <th>소계 (원)</th>
                        </tr>
                        <c:forEach var="price" items="${priceList}" varStatus="pStatus">
                            <tr class="price-row" data-price="<c:out value="${price.price}"/>">
                                <td align="left">
                                    <c:out value="${price.price_nm}"/>
                                    <!-- hidden inputs for form binding -->
                                    <input type="hidden" name="bookingDetails[<c:out value="${pStatus.index}"/>].priceId"
                                           value="<c:out value="${price.price_id}"/>"/>
                                    <input type="hidden" name="bookingDetails[<c:out value="${pStatus.index}"/>].ticketAmt"
                                           id="ticketAmt_<c:out value="${pStatus.index}"/>"
                                           value="<c:out value="${price.price}"/>"/>
                                </td>
                                <td align="center">
                                    <c:choose>
                                        <c:when test="${price.price_type == 'ADULT'}">성인</c:when>
                                        <c:when test="${price.price_type == 'CHILD'}">어린이</c:when>
                                        <c:when test="${price.price_type == 'INFANT'}">유아</c:when>
                                        <c:when test="${price.price_type == 'SENIOR'}">경로</c:when>
                                        <c:when test="${price.price_type == 'DISABLED'}">장애인</c:when>
                                        <c:otherwise><c:out value="${price.price_type}"/></c:otherwise>
                                    </c:choose>
                                </td>
                                <td align="right">
                                    <fmt:formatNumber value="${price.price}" type="number" groupingUsed="true"/>
                                </td>
                                <td align="center">
                                    <input type="text"
                                           name="bookingDetails[<c:out value="${pStatus.index}"/>].qty"
                                           class="qty-input"
                                           value="0"
                                           onchange="fn_egov_calcTotal();"
                                           onkeyup="fn_egov_calcTotal();"/>
                                </td>
                                <td align="right" id="subtotal_<c:out value="${pStatus.index}"/>">0</td>
                            </tr>
                        </c:forEach>
                        <tr>
                            <td colspan="3" align="right" class="total-box">합계</td>
                            <td align="center" class="total-box"><span id="totalQty">0</span> 매</td>
                            <td align="right" class="total-box"><span id="totalAmt">0</span> 원</td>
                        </tr>
                    </table>
                    <script type="text/javascript">
                    /* 소계 실시간 갱신 추가 */
                    (function() {
                        var rows = document.querySelectorAll(".price-row");
                        for (var i = 0; i < rows.length; i++) {
                            (function(idx, row) {
                                var qtyInput = row.querySelector(".qty-input");
                                var priceVal = parseInt(row.getAttribute("data-price"), 10) || 0;
                                var subtotalCell = document.getElementById("subtotal_" + idx);
                                function updateRow() {
                                    var qty = parseInt(qtyInput.value, 10) || 0;
                                    if (subtotalCell) {
                                        subtotalCell.innerHTML = (qty * priceVal).toLocaleString();
                                    }
                                    fn_egov_calcTotal();
                                }
                                qtyInput.addEventListener("change", updateRow);
                                qtyInput.addEventListener("keyup", updateRow);
                            })(i, rows[i]);
                        }
                    })();
                    </script>
                </c:if>

                <!-- 예매자 정보 입력 -->
                <p class="section-title">3. 예매자 정보</p>
                <table class="table" style="border-top:2px solid #C2D0DB; border-collapse:collapse;">
                    <colgroup>
                        <col width="150"/>
                        <col/>
                    </colgroup>
                    <tr>
                        <td class="tbtd_caption"><label for="bookerNm">예매자명 *</label></td>
                        <td class="tbtd_content">
                            <form:input path="bookerNm" cssClass="txt" maxlength="50"/>
                            &nbsp;<form:errors path="bookerNm" cssStyle="color:red;"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="tbtd_caption"><label for="bookerTel">연락처 *</label></td>
                        <td class="tbtd_content">
                            <form:input path="bookerTel" cssClass="txt" maxlength="20"/>
                            &nbsp;<form:errors path="bookerTel" cssStyle="color:red;"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="tbtd_caption"><label for="bookerEmail">이메일</label></td>
                        <td class="tbtd_content">
                            <form:input path="bookerEmail" cssClass="txt" maxlength="100"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="tbtd_caption"><label for="memberId">회원ID</label></td>
                        <td class="tbtd_content">
                            <form:input path="memberId" cssClass="txt" maxlength="16"/>
                            <span style="color:#666; font-size:11px;">&nbsp;(비회원은 입력 불필요)</span>
                        </td>
                    </tr>
                </table>

            </c:if><%-- END create mode --%>

            <%-- ===================================================== --%>
            <%-- MODIFY 모드 (예매 상세 + 상태 변경) --%>
            <%-- ===================================================== --%>
            <c:if test="${registerFlag == 'modify'}">

                <!-- 예매 기본 정보 (읽기전용) -->
                <p class="section-title">예매 정보</p>
                <table class="table" style="border-top:2px solid #C2D0DB; border-collapse:collapse;">
                    <colgroup>
                        <col width="150"/>
                        <col width="40%"/>
                        <col width="150"/>
                        <col/>
                    </colgroup>
                    <tr>
                        <td class="tbtd_caption">예매ID</td>
                        <td class="tbtd_content">
                            <form:input path="bookingId" cssClass="essentiality" readonly="true"/>
                        </td>
                        <td class="tbtd_caption">등록일시</td>
                        <td class="tbtd_content">
                            <c:out value="${bookingVO.regDt}"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="tbtd_caption">프로그램</td>
                        <td class="tbtd_content">
                            <c:out value="${bookingVO.programNm}"/>
                        </td>
                        <td class="tbtd_caption">공연일시</td>
                        <td class="tbtd_content">
                            <c:out value="${bookingVO.eventDate}"/>
                            <c:if test="${not empty bookingVO.eventTime}">
                                &nbsp;<c:out value="${bookingVO.eventTime}"/>
                            </c:if>
                        </td>
                    </tr>
                    <tr>
                        <td class="tbtd_caption">장소/시설</td>
                        <td class="tbtd_content" colspan="3">
                            <c:out value="${bookingVO.venueNm}"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="tbtd_caption">예매자명</td>
                        <td class="tbtd_content">
                            <c:out value="${bookingVO.bookerNm}"/>
                        </td>
                        <td class="tbtd_caption">연락처</td>
                        <td class="tbtd_content">
                            <c:out value="${bookingVO.bookerTel}"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="tbtd_caption">이메일</td>
                        <td class="tbtd_content">
                            <c:out value="${bookingVO.bookerEmail}"/>
                        </td>
                        <td class="tbtd_caption">회원ID</td>
                        <td class="tbtd_content">
                            <c:out value="${bookingVO.memberId}"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="tbtd_caption">총 수량</td>
                        <td class="tbtd_content">
                            <c:out value="${bookingVO.totalQty}"/> 매
                        </td>
                        <td class="tbtd_caption">총 금액</td>
                        <td class="tbtd_content">
                            <fmt:formatNumber value="${bookingVO.totalAmt}" type="number" groupingUsed="true"/> 원
                        </td>
                    </tr>
                    <tr>
                        <td class="tbtd_caption"><label for="bookingStatus">예매상태</label></td>
                        <td class="tbtd_content">
                            <form:select path="bookingStatus" cssClass="use">
                                <form:option value="RESERVED" label="예매완료"/>
                                <form:option value="COMPLETED" label="완료"/>
                                <form:option value="CANCELED" label="취소"/>
                            </form:select>
                        </td>
                        <td class="tbtd_caption"><label for="paymentStatus">결제상태</label></td>
                        <td class="tbtd_content">
                            <form:select path="paymentStatus" cssClass="use">
                                <form:option value="PENDING" label="미결제"/>
                                <form:option value="PAID" label="결제완료"/>
                                <form:option value="REFUNDED" label="환불"/>
                            </form:select>
                        </td>
                    </tr>
                </table>

                <!-- 예매상세 목록 -->
                <p class="section-title">예매 상세 내역</p>
                <table class="detail-table">
                    <colgroup>
                        <col width="40"/>
                        <col width="20%"/>
                        <col width="15%"/>
                        <col width="15%"/>
                        <col width="15%"/>
                        <col width="15%"/>
                    </colgroup>
                    <tr>
                        <th>No</th>
                        <th>티켓종류</th>
                        <th>가격유형</th>
                        <th>단가 (원)</th>
                        <th>좌석</th>
                        <th>취소여부</th>
                    </tr>
                    <c:forEach var="detail" items="${bookingVO.bookingDetails}" varStatus="dStatus">
                        <tr>
                            <td align="center"><c:out value="${dStatus.count}"/></td>
                            <td align="left"><c:out value="${detail.priceNm}"/>&nbsp;</td>
                            <td align="center">
                                <c:choose>
                                    <c:when test="${detail.priceType == 'ADULT'}">성인</c:when>
                                    <c:when test="${detail.priceType == 'CHILD'}">어린이</c:when>
                                    <c:when test="${detail.priceType == 'INFANT'}">유아</c:when>
                                    <c:when test="${detail.priceType == 'SENIOR'}">경로</c:when>
                                    <c:when test="${detail.priceType == 'DISABLED'}">장애인</c:when>
                                    <c:otherwise><c:out value="${detail.priceType}"/></c:otherwise>
                                </c:choose>
                            </td>
                            <td align="right">
                                <fmt:formatNumber value="${detail.price}" type="number" groupingUsed="true"/>
                            </td>
                            <td align="center">
                                <c:if test="${not empty detail.seatRow}">
                                    <c:out value="${detail.seatRow}"/>-<c:out value="${detail.seatNo}"/>
                                </c:if>
                                <c:if test="${empty detail.seatRow}">-</c:if>
                            </td>
                            <td align="center">
                                <c:choose>
                                    <c:when test="${detail.cancelYn == 'Y'}">취소</c:when>
                                    <c:otherwise>정상</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty bookingVO.bookingDetails}">
                        <tr>
                            <td colspan="6" align="center">예매상세 내역이 없습니다.</td>
                        </tr>
                    </c:if>
                </table>

            </c:if><%-- END modify mode --%>

        </div><%-- END #table --%>

        <!-- 버튼 영역 -->
        <div id="sysbtn">
            <a class="btn btn-outline-secondary btn-sm" href="javascript:fn_egov_selectList();">목록</a>
            <c:if test="${registerFlag == 'create'}">
                <a class="btn btn-primary btn-sm" href="javascript:fn_egov_save();">등록</a>
            </c:if>
            <c:if test="${registerFlag == 'modify'}">
                <a class="btn btn-primary btn-sm" href="javascript:fn_egov_update();">저장</a>
                <a class="btn btn-danger btn-sm" href="javascript:fn_egov_delete();">삭제</a>
            </c:if>
        </div>

        <!-- 검색조건 유지 -->
        <input type="hidden" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
        <input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
        <input type="hidden" name="pageIndex" value="<c:out value='${searchVO.pageIndex}'/>"/>

        <!-- modify 모드 hidden fields -->
        <c:if test="${registerFlag == 'modify'}">
            <form:hidden path="bookingId"/>
            <form:hidden path="scheduleId"/>
            <form:hidden path="totalQty"/>
            <form:hidden path="totalAmt"/>
        </c:if>

    </div><%-- END #content_pop --%>

</form:form>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
