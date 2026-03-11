<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>가격 템플릿 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=6"/>
    <style>
        .tab-btn { padding: 8px 24px; border: 1px solid #dee2e6; background: #f8f9fa; cursor: pointer; font-size: 14px; }
        .tab-btn.active { background: #0d6efd; color: #fff; border-color: #0d6efd; }
        .price-grid { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .price-grid th { background: #f0f4f8; padding: 8px 10px; font-size: 13px; font-weight: 500; border: 1px solid #dee2e6; text-align: center; }
        .price-grid td { padding: 4px 6px; border: 1px solid #dee2e6; text-align: center; vertical-align: middle; }
        .price-grid input[type="number"] { width: 90px; text-align: right; font-size: 13px; padding: 3px 6px; border: 1px solid #ced4da; border-radius: 3px; }
        .price-grid .disabled-row { background: #f5f5f5; color: #999; }
        .bulk-area { background: #fff3cd; border: 1px solid #ffc107; border-radius: 4px; padding: 8px 12px; margin-bottom: 10px; display: none; }
        .save-ok { background-color: #d4edda !important; transition: background-color 0.3s; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />
<div id="content_pop">
    <div id="title">
        <ul>
            <li><img src="<c:url value='/images/ftk/title_dot.gif'/>" alt=""/>가격 템플릿 관리</li>
        </ul>
    </div>

    <!-- 프로그램 선택 -->
    <div style="margin-bottom:15px;">
        <label style="font-weight:600;font-size:14px;">프로그램</label>
        <select id="programId" class="form-select form-select-sm" style="width:300px;display:inline-block;margin-left:8px;">
            <option value="">-- 프로그램 선택 --</option>
            <c:forEach var="p" items="${programList}">
                <option value="${p.programId}" <c:if test="${p.programId == selectedProgramId}">selected</c:if>>${p.programNm}</option>
            </c:forEach>
        </select>
        <button type="button" class="btn btn-primary btn-sm" onclick="loadTemplate()" style="margin-left:5px;">조회</button>
    </div>

    <!-- 탭 -->
    <div style="margin-bottom:10px;">
        <button type="button" class="tab-btn active" data-day="WEEKDAY" onclick="switchTab(this)">평일</button>
        <button type="button" class="tab-btn" data-day="WEEKEND" onclick="switchTab(this)">주말</button>
        <button type="button" class="tab-btn" data-day="HOLIDAY" onclick="switchTab(this)">공휴일</button>
    </div>

    <!-- 일괄 가격 설정 (주말/공휴일 탭에서만 표시) -->
    <div id="bulkArea" class="bulk-area">
        <span style="font-size:13px;">평일 대비</span>
        <input type="number" id="adjustAmount" value="0" style="width:80px;text-align:right;font-size:13px;" />
        <span style="font-size:13px;">원 조정</span>
        <button type="button" class="btn btn-warning btn-sm" onclick="applyBulkAdjust()" style="margin-left:8px;">적용</button>
    </div>

    <!-- 그리드 -->
    <div id="gridArea">
        <p class="text-muted" style="font-size:13px;">프로그램을 선택하고 조회하세요.</p>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
var currentDayType = 'WEEKDAY';
var ticketTypeNames = []; // 권종명 배열 (그리드 헤더용)

function switchTab(btn) {
    document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
    btn.classList.add('active');
    currentDayType = btn.getAttribute('data-day');
    document.getElementById('bulkArea').style.display = (currentDayType !== 'WEEKDAY') ? 'block' : 'none';
    loadTemplate();
}

function loadTemplate() {
    var programId = document.getElementById('programId').value;
    if (!programId) { alert('프로그램을 선택하세요.'); return; }

    fetch('<c:url value="/priceTemplateData.do"/>?programId=' + encodeURIComponent(programId) + '&dayType=' + currentDayType)
        .then(function(r) { return r.json(); })
        .then(function(data) { renderGrid(data); })
        .catch(function(e) { document.getElementById('gridArea').innerHTML = '<p class="text-danger">데이터 로드 실패</p>'; });
}

function renderGrid(data) {
    var sessions = data.sessions || [];
    var prices = data.prices || [];
    var gridArea = document.getElementById('gridArea');

    if (sessions.length === 0) {
        gridArea.innerHTML = '<p class="text-muted" style="font-size:13px;">회차 템플릿이 없습니다. 프로그램 등록 화면에서 회차를 설정하세요.</p>';
        return;
    }

    // 권종 목록 추출 (첫 회차의 가격 정보에서)
    var typeMap = {};
    var typeOrder = [];
    for (var i = 0; i < prices.length; i++) {
        var p = prices[i];
        if (!typeMap[p.typeId]) {
            typeMap[p.typeId] = p.typeNm;
            typeOrder.push(p.typeId);
        }
    }

    // 가격을 sessionNo+typeId로 인덱싱
    var priceMap = {};
    for (var i = 0; i < prices.length; i++) {
        var p = prices[i];
        priceMap[p.sessionNo + '_' + p.typeId] = p.price;
    }

    var html = '<table class="price-grid"><thead><tr>';
    html += '<th>회차</th><th>시간</th>';
    for (var t = 0; t < typeOrder.length; t++) {
        html += '<th>' + typeMap[typeOrder[t]] + '</th>';
    }
    html += '<th>활성</th></tr></thead><tbody>';

    for (var s = 0; s < sessions.length; s++) {
        var sess = sessions[s];
        var rowClass = sess.enabled === 'N' ? ' class="disabled-row"' : '';
        html += '<tr' + rowClass + '>';
        html += '<td>' + sess.sessionNo + '회차</td>';
        html += '<td>' + sess.eventTime + '</td>';

        for (var t = 0; t < typeOrder.length; t++) {
            var key = sess.sessionNo + '_' + typeOrder[t];
            var val = priceMap[key] || 0;
            html += '<td><input type="number" value="' + val + '" min="0"'
                + ' data-session="' + sess.sessionNo + '"'
                + ' data-type="' + typeOrder[t] + '"'
                + ' onblur="savePrice(this)"'
                + (sess.enabled === 'N' ? ' disabled' : '')
                + '/></td>';
        }

        var checked = sess.enabled === 'Y' ? ' checked' : '';
        html += '<td><input type="checkbox"' + checked
            + ' data-session="' + sess.sessionNo + '"'
            + ' onchange="toggleSession(this)" class="form-check-input"/></td>';
        html += '</tr>';
    }
    html += '</tbody></table>';
    gridArea.innerHTML = html;
}

function savePrice(input) {
    var programId = document.getElementById('programId').value;
    var params = 'programId=' + encodeURIComponent(programId)
        + '&sessionNo=' + input.getAttribute('data-session')
        + '&typeId=' + encodeURIComponent(input.getAttribute('data-type'))
        + '&dayType=' + currentDayType
        + '&price=' + input.value;

    fetch('<c:url value="/savePriceTemplate.do"/>', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params
    }).then(function(r) { return r.json(); })
    .then(function(res) {
        if (res.success) {
            input.classList.add('save-ok');
            setTimeout(function() { input.classList.remove('save-ok'); }, 1000);
        }
    });
}

function toggleSession(checkbox) {
    var programId = document.getElementById('programId').value;
    var enabled = checkbox.checked ? 'Y' : 'N';
    var params = 'programId=' + encodeURIComponent(programId)
        + '&sessionNo=' + checkbox.getAttribute('data-session')
        + '&dayType=' + currentDayType
        + '&enabled=' + enabled;

    fetch('<c:url value="/saveSessionEnabled.do"/>', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params
    }).then(function(r) { return r.json(); })
    .then(function(res) {
        if (res.success) { loadTemplate(); }
    });
}

function applyBulkAdjust() {
    var programId = document.getElementById('programId').value;
    if (!programId) return;
    var amount = document.getElementById('adjustAmount').value;
    if (!confirm('평일 대비 ' + amount + '원을 ' + currentDayType + ' 가격에 일괄 적용합니다. 계속하시겠습니까?')) return;

    var params = 'programId=' + encodeURIComponent(programId)
        + '&dayType=' + currentDayType
        + '&adjustAmount=' + amount;

    fetch('<c:url value="/applyBulkPriceAdjust.do"/>', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params
    }).then(function(r) { return r.json(); })
    .then(function(res) {
        if (res.success) { loadTemplate(); }
    });
}

// 페이지 로드 시 자동 조회
document.addEventListener('DOMContentLoaded', function() {
    if (document.getElementById('programId').value) {
        loadTemplate();
    }
});
</script>
</body>
</html>
