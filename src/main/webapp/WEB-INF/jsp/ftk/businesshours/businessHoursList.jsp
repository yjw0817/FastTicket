<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>영업시간 설정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=5"/>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />

<div id="content_pop">
    <div id="search">
        <div class="d-flex align-items-center gap-2">
            <span class="text-muted" style="font-size:0.85rem">요일별 기본 영업시간을 설정합니다. 회차 자동 생성 시 기본값으로 활용됩니다.</span>
            <button type="button" class="btn btn-primary btn-sm ms-auto" onclick="saveAll()">전체 저장</button>
        </div>
    </div>

    <div id="table" class="table-responsive">
        <table class="table table-hover" summary="영업시간 설정">
            <caption style="visibility:hidden">영업시간 설정</caption>
            <colgroup>
                <col width="80"/>
                <col width="100"/>
                <col width="160"/>
                <col width="160"/>
                <col width="100"/>
            </colgroup>
            <thead>
                <tr>
                    <th>요일</th>
                    <th>영업여부</th>
                    <th>시작 시간</th>
                    <th>종료 시간</th>
                    <th>영업시간</th>
                </tr>
            </thead>
            <tbody id="hoursBody">
                <c:forEach var="h" items="${hoursList}" varStatus="st">
                    <tr class="bh-row" data-day="${h.dayOfWeek}">
                        <td align="center">
                            <input type="hidden" name="bhId" value="${h.bhId}"/>
                            <input type="hidden" name="dayOfWeek" value="${h.dayOfWeek}"/>
                            <span class="fw-bold day-label"
                                  style="<c:if test='${h.dayOfWeek == 7}'>color:#dc3545</c:if><c:if test='${h.dayOfWeek == 6}'>color:#0d6efd</c:if>">
                                <c:choose>
                                    <c:when test="${h.dayOfWeek == 1}">월요일</c:when>
                                    <c:when test="${h.dayOfWeek == 2}">화요일</c:when>
                                    <c:when test="${h.dayOfWeek == 3}">수요일</c:when>
                                    <c:when test="${h.dayOfWeek == 4}">목요일</c:when>
                                    <c:when test="${h.dayOfWeek == 5}">금요일</c:when>
                                    <c:when test="${h.dayOfWeek == 6}">토요일</c:when>
                                    <c:when test="${h.dayOfWeek == 7}">일요일</c:when>
                                </c:choose>
                            </span>
                        </td>
                        <td align="center">
                            <div class="form-check form-switch d-flex justify-content-center">
                                <input class="form-check-input use-toggle" type="checkbox" name="useYn"
                                       <c:if test="${h.useYn == 'Y'}">checked</c:if>
                                       onchange="toggleRow(this)"/>
                            </div>
                        </td>
                        <td align="center">
                            <input type="time" class="form-control form-control-sm open-time" name="openTime"
                                   value="${h.openTime}" onchange="calcDuration(this)"
                                   <c:if test="${h.useYn != 'Y'}">disabled</c:if>/>
                        </td>
                        <td align="center">
                            <input type="time" class="form-control form-control-sm close-time" name="closeTime"
                                   value="${h.closeTime}" onchange="calcDuration(this)"
                                   <c:if test="${h.useYn != 'Y'}">disabled</c:if>/>
                        </td>
                        <td align="center" class="duration-cell">
                            <c:if test="${h.useYn == 'Y'}">-</c:if>
                            <c:if test="${h.useYn != 'Y'}"><span class="text-muted">휴무</span></c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
var ctx = '<c:url value="/"/>';

document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.bh-row').forEach(function(row) {
        calcDurationForRow(row);
    });
});

function toggleRow(checkbox) {
    var row = checkbox.closest('tr');
    var open = row.querySelector('.open-time');
    var close = row.querySelector('.close-time');
    var dur = row.querySelector('.duration-cell');

    if (checkbox.checked) {
        open.disabled = false;
        close.disabled = false;
        calcDurationForRow(row);
    } else {
        open.disabled = true;
        close.disabled = true;
        dur.innerHTML = '<span class="text-muted">휴무</span>';
    }
}

function calcDuration(el) {
    calcDurationForRow(el.closest('tr'));
}

function calcDurationForRow(row) {
    var toggle = row.querySelector('.use-toggle');
    if (!toggle.checked) return;

    var open = row.querySelector('.open-time').value;
    var close = row.querySelector('.close-time').value;
    var dur = row.querySelector('.duration-cell');

    if (!open || !close) { dur.textContent = '-'; return; }

    var oMin = parseInt(open.split(':')[0]) * 60 + parseInt(open.split(':')[1]);
    var cMin = parseInt(close.split(':')[0]) * 60 + parseInt(close.split(':')[1]);
    var diff = cMin - oMin;

    if (diff <= 0) {
        dur.innerHTML = '<span class="text-danger">시간 오류</span>';
    } else {
        var h = Math.floor(diff / 60);
        var m = diff % 60;
        dur.textContent = h + '시간' + (m > 0 ? ' ' + m + '분' : '');
    }
}

function saveAll() {
    var rows = document.querySelectorAll('.bh-row');
    var params = [];

    rows.forEach(function(row) {
        var bhId = row.querySelector('input[name="bhId"]').value;
        var dayOfWeek = row.querySelector('input[name="dayOfWeek"]').value;
        var openTime = row.querySelector('.open-time').value || '09:00';
        var closeTime = row.querySelector('.close-time').value || '18:00';
        var useYn = row.querySelector('.use-toggle').checked ? 'Y' : 'N';

        params.push('bhId=' + encodeURIComponent(bhId));
        params.push('dayOfWeek=' + dayOfWeek);
        params.push('openTime=' + encodeURIComponent(openTime));
        params.push('closeTime=' + encodeURIComponent(closeTime));
        params.push('useYn=' + useYn);
    });

    fetch(ctx + 'saveBusinessHours.do', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params.join('&')
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) {
            alert(data.message);
        } else {
            alert(data.message || '오류가 발생했습니다.');
        }
    });
}
</script>
</body>
</html>
