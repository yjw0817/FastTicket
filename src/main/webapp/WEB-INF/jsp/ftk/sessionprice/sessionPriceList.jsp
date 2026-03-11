<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>회차별 가격 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=5"/>
    <style>
        .price-grid { border-collapse: collapse; width: 100%; font-size: 13px; }
        .price-grid th, .price-grid td { border: 1px solid #dee2e6; padding: 6px 8px; text-align: center; vertical-align: middle; }
        .price-grid thead th { background: #f8f9fa; position: sticky; top: 0; z-index: 1; }
        .price-grid .col-schedule { background: #f8f9fa; font-weight: 500; white-space: nowrap; }
        .price-grid input[type="number"] { width: 80px; text-align: right; border: 1px solid #ced4da; border-radius: 4px; padding: 2px 6px; font-size: 13px; }
        .price-grid input[type="number"]:focus { border-color: #86b7fe; outline: 0; box-shadow: 0 0 0 .2rem rgba(13,110,253,.25); }
        .default-price-row { background: #e8f4fd; }
        .default-price-row label { font-weight: 600; font-size: 13px; }
        .default-price-row input { width: 100px; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />

<div id="content_pop">
    <div id="search">
        <div class="d-flex flex-wrap align-items-center gap-2">
            <label class="form-label mb-0 fw-bold">프로그램</label>
            <select class="form-select form-select-sm" id="selProgram" style="width:200px" onchange="loadPriceGrid()">
                <option value="">-- 선택 --</option>
                <c:forEach var="p" items="${programList}">
                    <option value="${p.programId}">${p.programNm}</option>
                </c:forEach>
            </select>
            <button class="btn btn-outline-primary btn-sm" onclick="loadPriceGrid()">조회</button>
            <button class="btn btn-success btn-sm" id="btnApplyDefault" style="display:none" onclick="applyDefaultPrice()">기본가격 일괄 적용</button>
        </div>
    </div>

    <!-- 기본가격 설정 행 -->
    <div id="defaultPriceArea" style="display:none" class="mb-3">
        <div class="card">
            <div class="card-body py-2">
                <div class="d-flex flex-wrap align-items-center gap-3 default-price-row" id="defaultPriceRow">
                    <span class="fw-bold text-primary">기본 가격 설정:</span>
                </div>
                <small class="text-muted">기본 가격을 입력 후 "기본가격 일괄 적용" 버튼을 누르면 전체 회차에 동일하게 적용됩니다.</small>
            </div>
        </div>
    </div>

    <!-- 가격 그리드 -->
    <div id="priceGridArea" class="table-responsive" style="max-height: 600px; overflow-y: auto;">
        <div class="empty-state" id="emptyState">
            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
            <p>프로그램을 선택하면 회차별 가격을 관리할 수 있습니다.</p>
        </div>
        <table class="price-grid" id="priceGrid" style="display:none">
            <thead id="priceGridHead"></thead>
            <tbody id="priceGridBody"></tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
var ctx = '<c:url value="/"/>';
var ticketTypes = [];
<c:forEach var="tt" items="${ticketTypeList}">
ticketTypes.push({ typeId: '${tt.typeId}', typeNm: '${tt.typeNm}' });
</c:forEach>

function formatDate(val) {
    if (!val) return '';
    if (typeof val === 'number') {
        var d = new Date(val);
        var y = d.getFullYear();
        var m = ('0' + (d.getMonth() + 1)).slice(-2);
        var dd = ('0' + d.getDate()).slice(-2);
        return y + '-' + m + '-' + dd;
    }
    return val;
}

function loadPriceGrid() {
    var programId = document.getElementById('selProgram').value;
    if (!programId) {
        document.getElementById('priceGrid').style.display = 'none';
        document.getElementById('emptyState').style.display = '';
        document.getElementById('defaultPriceArea').style.display = 'none';
        document.getElementById('btnApplyDefault').style.display = 'none';
        return;
    }

    fetch(ctx + 'sessionPriceData.do?programId=' + encodeURIComponent(programId))
        .then(function(r) { return r.json(); })
        .then(function(data) {
            renderGrid(data);
        });
}

function renderGrid(data) {
    var schedules = data.scheduleList || [];
    var types = data.ticketTypeList || [];
    var priceMap = data.priceMap || {};

    if (types.length === 0) {
        alert('등록된 권종이 없습니다. 먼저 기초설정 > 권종관리에서 권종을 등록하세요.');
        return;
    }

    // 기본가격 행 생성
    var defaultRow = document.getElementById('defaultPriceRow');
    defaultRow.innerHTML = '<span class="fw-bold text-primary">기본 가격:</span>';
    for (var t = 0; t < types.length; t++) {
        defaultRow.innerHTML += '<div class="d-flex align-items-center gap-1">'
            + '<label>' + types[t].typeNm + '</label>'
            + '<input type="number" class="form-control form-control-sm" id="dp_' + types[t].typeId + '" value="0" min="0" style="width:100px"/>'
            + '<span>원</span></div>';
    }

    // 테이블 헤더
    var thead = document.getElementById('priceGridHead');
    var headHtml = '<tr><th>날짜</th><th>시간</th><th>회차</th>';
    for (var t = 0; t < types.length; t++) {
        headHtml += '<th>' + types[t].typeNm + '</th>';
    }
    headHtml += '</tr>';
    thead.innerHTML = headHtml;

    // 테이블 바디
    var tbody = document.getElementById('priceGridBody');
    var bodyHtml = '';

    if (schedules.length === 0) {
        bodyHtml = '<tr><td colspan="' + (3 + types.length) + '">등록된 회차가 없습니다.</td></tr>';
    } else {
        for (var i = 0; i < schedules.length; i++) {
            var s = schedules[i];
            var sid = s.scheduleId;
            var prices = priceMap[sid] || [];

            bodyHtml += '<tr>';
            bodyHtml += '<td class="col-schedule">' + formatDate(s.eventDate) + '</td>';
            bodyHtml += '<td class="col-schedule">' + (s.eventTime || '') + '</td>';
            bodyHtml += '<td class="col-schedule">' + (s.sessionNo || '') + '회</td>';

            for (var t = 0; t < types.length; t++) {
                var typeId = types[t].typeId;
                var found = null;
                for (var p = 0; p < prices.length; p++) {
                    if (prices[p].typeId === typeId) { found = prices[p]; break; }
                }
                var spriceId = found ? found.spriceId : '';
                var priceVal = found ? found.price : '';
                bodyHtml += '<td><input type="number" '
                    + 'data-schedule-id="' + sid + '" '
                    + 'data-type-id="' + typeId + '" '
                    + 'data-sprice-id="' + spriceId + '" '
                    + 'value="' + priceVal + '" '
                    + 'min="0" placeholder="0" '
                    + 'onchange="saveCell(this)"/></td>';
            }
            bodyHtml += '</tr>';
        }
    }
    tbody.innerHTML = bodyHtml;

    document.getElementById('priceGrid').style.display = '';
    document.getElementById('emptyState').style.display = 'none';
    document.getElementById('defaultPriceArea').style.display = '';
    document.getElementById('btnApplyDefault').style.display = '';
}

function saveCell(input) {
    var scheduleId = input.getAttribute('data-schedule-id');
    var typeId = input.getAttribute('data-type-id');
    var spriceId = input.getAttribute('data-sprice-id');
    var price = input.value || '0';

    var params = 'scheduleId=' + encodeURIComponent(scheduleId)
        + '&typeId=' + encodeURIComponent(typeId)
        + '&price=' + price;
    if (spriceId) params += '&spriceId=' + encodeURIComponent(spriceId);

    input.style.background = '#fff3cd';
    fetch(ctx + 'saveSessionPrice.do', { method: 'POST', headers: {'Content-Type':'application/x-www-form-urlencoded'}, body: params })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) {
                input.style.background = '#d1e7dd';
                if (data.spriceId) input.setAttribute('data-sprice-id', data.spriceId);
                setTimeout(function() { input.style.background = ''; }, 1000);
            } else {
                input.style.background = '#f8d7da';
            }
        });
}

function applyDefaultPrice() {
    var programId = document.getElementById('selProgram').value;
    if (!programId) { alert('프로그램을 선택하세요.'); return; }

    var typeIds = [];
    var prices = [];
    for (var i = 0; i < ticketTypes.length; i++) {
        var el = document.getElementById('dp_' + ticketTypes[i].typeId);
        if (el) {
            typeIds.push(ticketTypes[i].typeId);
            prices.push(el.value || '0');
        }
    }

    if (typeIds.length === 0) { alert('권종이 없습니다.'); return; }
    if (!confirm('전체 회차에 기본 가격을 일괄 적용하시겠습니까?\n기존 가격은 덮어씌워집니다.')) return;

    var params = 'programId=' + encodeURIComponent(programId)
        + '&typeIds=' + encodeURIComponent(typeIds.join(','))
        + '&prices=' + encodeURIComponent(prices.join(','));

    fetch(ctx + 'applyDefaultPrice.do', { method: 'POST', headers: {'Content-Type':'application/x-www-form-urlencoded'}, body: params })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) {
                alert(data.message);
                loadPriceGrid();
            } else {
                alert(data.message || '오류가 발생했습니다.');
            }
        });
}
</script>
</body>
</html>
