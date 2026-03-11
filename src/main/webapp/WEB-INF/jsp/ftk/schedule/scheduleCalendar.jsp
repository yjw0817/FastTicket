<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>일정 관리 - 달력</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=6"/>
    <style>
        .cal-nav { display: flex; align-items: center; gap: 15px; margin-bottom: 15px; }
        .cal-nav button { border: 1px solid #dee2e6; background: #f8f9fa; padding: 4px 12px; cursor: pointer; font-size: 18px; }
        .cal-nav .month-label { font-size: 18px; font-weight: 600; min-width: 160px; text-align: center; }
        .cal-grid { width: 100%; border-collapse: collapse; table-layout: fixed; }
        .cal-grid th { background: #f0f4f8; padding: 8px; text-align: center; font-size: 13px; border: 1px solid #dee2e6; }
        .cal-grid td { border: 1px solid #dee2e6; vertical-align: top; height: 90px; padding: 4px; cursor: pointer; font-size: 12px; }
        .cal-grid td:hover { background: #e8f4fd; }
        .cal-grid .day-num { font-weight: 600; font-size: 14px; margin-bottom: 3px; }
        .cal-grid .empty { background: #fafafa; cursor: default; }
        .cal-grid .holiday { background: #fff5f5; }
        .cal-grid .weekend { background: #f5f5ff; }
        .cal-grid .has-override { position: relative; }
        .cal-grid .has-override::after { content: ''; position: absolute; top: 3px; right: 3px; width: 8px; height: 8px; background: #ffc107; border-radius: 50%; }
        .badge-day { font-size: 10px; padding: 1px 5px; border-radius: 3px; }
        .badge-weekday { background: #d1ecf1; color: #0c5460; }
        .badge-weekend { background: #d4c5f9; color: #4a2d7a; }
        .badge-holiday { background: #f5c6cb; color: #721c24; }

        /* Detail panel */
        .detail-panel { display: none; border: 1px solid #dee2e6; border-radius: 4px; padding: 15px; margin-top: 15px; background: #fff; }
        .detail-panel.show { display: block; }
        .detail-title { font-size: 15px; font-weight: 600; margin-bottom: 10px; }
        .session-row { display: flex; align-items: center; gap: 10px; padding: 6px 0; border-bottom: 1px solid #f0f0f0; font-size: 13px; }
        .price-cell { display: inline-flex; align-items: center; gap: 4px; }
        .price-cell input { width: 80px; text-align: right; font-size: 12px; padding: 2px 4px; border: 1px solid #ced4da; border-radius: 3px; }
        .price-cell .override { background: #fff3cd; }
        .reason-input { width: 200px; font-size: 12px; padding: 2px 6px; }
        .gen-area { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 4px; padding: 10px; margin-bottom: 15px; display: flex; align-items: center; gap: 10px; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />
<div id="content_pop">
    <div id="title">
        <ul><li><img src="<c:url value='/images/ftk/title_dot.gif'/>" alt=""/>일정 관리</li></ul>
    </div>

    <!-- 프로그램 선택 -->
    <div style="margin-bottom:10px;">
        <label style="font-weight:600;font-size:14px;">프로그램</label>
        <select id="programId" class="form-select form-select-sm" style="width:300px;display:inline-block;margin-left:8px;">
            <option value="">-- 프로그램 선택 --</option>
            <c:forEach var="p" items="${programList}">
                <option value="${p.programId}">${p.programNm}</option>
            </c:forEach>
        </select>
        <button type="button" class="btn btn-primary btn-sm" onclick="loadCalendar()" style="margin-left:5px;">조회</button>
        <a href="<c:url value='/scheduleList.do'/>" class="btn btn-outline-secondary btn-sm" style="margin-left:10px;">목록 보기</a>
    </div>

    <!-- 스케줄 생성 영역 -->
    <div class="gen-area">
        <span style="font-size:13px;font-weight:500;">스케줄 생성:</span>
        <input type="date" id="genStartDate" class="form-control form-control-sm" style="width:140px;"/>
        <span>~</span>
        <input type="date" id="genEndDate" class="form-control form-control-sm" style="width:140px;"/>
        <button type="button" class="btn btn-success btn-sm" onclick="generateSchedules()">템플릿 기반 생성</button>
    </div>

    <!-- 달력 네비게이션 -->
    <div class="cal-nav">
        <button onclick="changeMonth(-1)">&lt;</button>
        <div class="month-label" id="monthLabel"></div>
        <button onclick="changeMonth(1)">&gt;</button>
    </div>

    <!-- 달력 -->
    <table class="cal-grid" id="calendarGrid">
        <thead>
            <tr><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th style="color:#4a2d7a">토</th><th style="color:#c0392b">일</th></tr>
        </thead>
        <tbody id="calendarBody"></tbody>
    </table>

    <!-- 날짜 상세 패널 -->
    <div id="detailPanel" class="detail-panel">
        <div class="detail-title" id="detailTitle"></div>
        <div id="detailContent"></div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
var currentYear, currentMonth;
var calendarData = {};

(function() {
    var now = new Date();
    currentYear = now.getFullYear();
    currentMonth = now.getMonth() + 1;
    updateMonthLabel();
})();

function updateMonthLabel() {
    document.getElementById('monthLabel').textContent = currentYear + '년 ' + currentMonth + '월';
}

function changeMonth(delta) {
    currentMonth += delta;
    if (currentMonth < 1) { currentMonth = 12; currentYear--; }
    if (currentMonth > 12) { currentMonth = 1; currentYear++; }
    updateMonthLabel();
    loadCalendar();
}

function loadCalendar() {
    var programId = document.getElementById('programId').value;
    if (!programId) return;

    var ym = currentYear + '-' + String(currentMonth).padStart(2, '0');
    fetch('<c:url value="/calendarSummary.do"/>?programId=' + encodeURIComponent(programId) + '&yearMonth=' + ym)
        .then(function(r) { return r.json(); })
        .then(function(data) {
            calendarData = {};
            for (var i = 0; i < data.length; i++) {
                var d = data[i];
                calendarData[d.eventDate] = d;
            }
            renderCalendar();
        });
}

function renderCalendar() {
    var tbody = document.getElementById('calendarBody');
    tbody.innerHTML = '';

    var firstDay = new Date(currentYear, currentMonth - 1, 1);
    var lastDay = new Date(currentYear, currentMonth, 0);
    var startDow = (firstDay.getDay() + 6) % 7; // 0=Mon
    var totalDays = lastDay.getDate();

    var html = '';
    var day = 1;

    for (var row = 0; row < 6; row++) {
        if (day > totalDays) break;
        html += '<tr>';
        for (var col = 0; col < 7; col++) {
            if ((row === 0 && col < startDow) || day > totalDays) {
                html += '<td class="empty"></td>';
            } else {
                var dateStr = currentYear + '-' + String(currentMonth).padStart(2, '0') + '-' + String(day).padStart(2, '0');
                var info = calendarData[dateStr];
                var classes = [];
                var content = '<div class="day-num">' + day + '</div>';

                if (info) {
                    if (info.dayType === 'HOLIDAY') classes.push('holiday');
                    else if (info.dayType === 'WEEKEND') classes.push('weekend');
                    if (info.hasPriceOverride === 'Y' || info.hasSessionOverride === 'Y') classes.push('has-override');

                    content += '<span class="badge-day badge-' + info.dayType.toLowerCase() + '">' + info.dayType + '</span> ';
                    content += '<span style="font-size:11px">' + info.sessionCnt + '회차</span>';
                } else if (col >= 5) {
                    classes.push('weekend');
                }

                html += '<td class="' + classes.join(' ') + '" onclick="showDateDetail(\'' + dateStr + '\')">' + content + '</td>';
                day++;
            }
        }
        html += '</tr>';
    }
    tbody.innerHTML = html;
}

function showDateDetail(dateStr) {
    var programId = document.getElementById('programId').value;
    if (!programId) return;

    var panel = document.getElementById('detailPanel');
    panel.classList.add('show');
    document.getElementById('detailTitle').textContent = dateStr + ' 상세';

    fetch('<c:url value="/calendarDateDetail.do"/>?programId=' + encodeURIComponent(programId) + '&eventDate=' + dateStr)
        .then(function(r) { return r.json(); })
        .then(function(sessions) {
            if (!sessions || sessions.length === 0) {
                document.getElementById('detailContent').innerHTML = '<p class="text-muted">이 날짜에 스케줄이 없습니다.</p>';
                return;
            }

            var dayType = sessions[0].dayType || 'WEEKDAY';
            var html = '<p><span class="badge-day badge-' + dayType.toLowerCase() + '">' + dayType + '</span></p>';

            for (var i = 0; i < sessions.length; i++) {
                var s = sessions[i];
                var overrideLabel = '';
                if (s.sessionOverride === 'N') {
                    overrideLabel = ' <span class="badge bg-danger" style="font-size:10px">비활성 (override)</span>';
                    if (s.sessionOverrideReason) overrideLabel += ' <small class="text-muted">' + s.sessionOverrideReason + '</small>';
                } else if (s.sessionOverride === 'Y') {
                    overrideLabel = ' <span class="badge bg-success" style="font-size:10px">강제활성</span>';
                }

                html += '<div class="session-row">';
                html += '<strong>' + s.sessionNo + '회차</strong> ' + s.eventTime;
                html += ' | 온라인: ' + s.onlineAvail + ' | 오프라인: ' + s.offlineAvail;
                html += ' | ' + s.status;
                html += overrideLabel;
                html += ' <button class="btn btn-outline-primary btn-sm" style="font-size:11px;padding:1px 6px;margin-left:8px" '
                    + 'onclick="loadSessionPrices(\'' + dateStr + '\',' + s.sessionNo + ',\'' + dayType + '\')">가격</button>';
                html += ' <button class="btn btn-outline-warning btn-sm" style="font-size:11px;padding:1px 6px" '
                    + 'onclick="toggleSessionOverride(\'' + dateStr + '\',' + s.sessionNo + ',\'' + (s.sessionOverride === 'N' ? 'Y' : 'N') + '\')">회차 토글</button>';
                html += '</div>';
            }

            html += '<div id="priceDetail" style="margin-top:10px;"></div>';
            document.getElementById('detailContent').innerHTML = html;
        });
}

function loadSessionPrices(dateStr, sessionNo, dayType) {
    var programId = document.getElementById('programId').value;
    fetch('<c:url value="/calendarDatePrices.do"/>?programId=' + encodeURIComponent(programId)
        + '&eventDate=' + dateStr + '&sessionNo=' + sessionNo + '&dayType=' + dayType)
        .then(function(r) { return r.json(); })
        .then(function(prices) {
            var html = '<div style="border-top:1px solid #dee2e6;padding-top:8px;margin-top:8px;">';
            html += '<strong>' + sessionNo + '회차 가격</strong><br/>';
            for (var i = 0; i < prices.length; i++) {
                var p = prices[i];
                var isOvr = p.isOverride === 'Y';
                html += '<div class="price-cell" style="margin:3px 0;">';
                html += '<span style="width:80px;display:inline-block">' + p.typeNm + ':</span>';
                html += '<input type="number" value="' + p.price + '" min="0" class="' + (isOvr ? 'override' : '') + '"'
                    + ' data-date="' + dateStr + '" data-session="' + sessionNo + '" data-type="' + p.typeId + '"/>';
                if (isOvr) {
                    html += ' <small class="text-warning">override</small>';
                    if (p.overrideReason) html += ' <small class="text-muted">(' + p.overrideReason + ')</small>';
                }
                html += '</div>';
            }
            html += '<div style="margin-top:6px;">';
            html += '<input type="text" id="priceReason" class="reason-input" placeholder="변동 사유 (필수)"/>';
            html += ' <button class="btn btn-warning btn-sm" style="font-size:11px" onclick="savePriceOverrides(\'' + dateStr + '\',' + sessionNo + ')">가격 override 저장</button>';
            html += '</div></div>';
            document.getElementById('priceDetail').innerHTML = html;
        });
}

function savePriceOverrides(dateStr, sessionNo) {
    var reason = document.getElementById('priceReason').value;
    if (!reason) { alert('변동 사유를 입력하세요.'); return; }

    var programId = document.getElementById('programId').value;
    var inputs = document.querySelectorAll('#priceDetail input[type="number"]');
    var promises = [];

    for (var i = 0; i < inputs.length; i++) {
        var inp = inputs[i];
        var params = 'programId=' + encodeURIComponent(programId)
            + '&eventDate=' + inp.getAttribute('data-date')
            + '&sessionNo=' + inp.getAttribute('data-session')
            + '&typeId=' + encodeURIComponent(inp.getAttribute('data-type'))
            + '&price=' + inp.value
            + '&reason=' + encodeURIComponent(reason);

        promises.push(
            fetch('<c:url value="/saveDatePriceOverride.do"/>', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: params
            })
        );
    }

    Promise.all(promises).then(function() {
        alert('저장되었습니다.');
        showDateDetail(dateStr);
    });
}

function toggleSessionOverride(dateStr, sessionNo, newEnabled) {
    var reason = prompt((newEnabled === 'N' ? '비활성' : '활성') + ' 사유를 입력하세요:');
    if (!reason) return;

    var programId = document.getElementById('programId').value;
    var params = 'programId=' + encodeURIComponent(programId)
        + '&eventDate=' + dateStr
        + '&sessionNo=' + sessionNo
        + '&enabled=' + newEnabled
        + '&reason=' + encodeURIComponent(reason);

    fetch('<c:url value="/saveDateSessionOverride.do"/>', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params
    }).then(function() {
        showDateDetail(dateStr);
        loadCalendar();
    });
}

function generateSchedules() {
    var programId = document.getElementById('programId').value;
    if (!programId) { alert('프로그램을 선택하세요.'); return; }
    var startDate = document.getElementById('genStartDate').value;
    var endDate = document.getElementById('genEndDate').value;
    if (!startDate || !endDate) { alert('기간을 선택하세요.'); return; }
    if (!confirm('템플릿 기반으로 ' + startDate + ' ~ ' + endDate + ' 스케줄을 생성합니다.')) return;

    var params = 'programId=' + encodeURIComponent(programId)
        + '&startDate=' + startDate + '&endDate=' + endDate;

    fetch('<c:url value="/generateFromTemplate.do"/>', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params
    }).then(function(r) { return r.json(); })
    .then(function(res) {
        alert(res.message);
        if (res.success) loadCalendar();
    });
}
</script>
</body>
</html>
