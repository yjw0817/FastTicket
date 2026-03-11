<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>FastTicket - 온라인 예약</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet"/>
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background: #f5f7fa; }
        .booking-header { background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%); color: #fff; padding: 2rem 0; text-align: center; }
        .booking-header h1 { font-size: 1.6rem; font-weight: 700; margin: 0; }
        .booking-header p { margin: 0.3rem 0 0; opacity: 0.85; font-size: 0.9rem; }
        .step-container { max-width: 700px; margin: 2rem auto; padding: 0 1rem; }
        .step-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 1.2rem; overflow: hidden; }
        .step-header { background: #f8fafc; padding: 0.8rem 1.2rem; border-bottom: 1px solid #e2e8f0; display: flex; align-items: center; gap: 0.6rem; }
        .step-num { background: #2563eb; color: #fff; width: 28px; height: 28px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.85rem; font-weight: 700; }
        .step-num.done { background: #16a34a; }
        .step-title { font-weight: 600; font-size: 0.95rem; }
        .step-body { padding: 1.2rem; }
        .step-card.disabled { opacity: 0.5; pointer-events: none; }
        .date-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(110px, 1fr)); gap: 0.5rem; }
        .date-btn { border: 1px solid #e2e8f0; border-radius: 8px; padding: 0.6rem; text-align: center; cursor: pointer; transition: all 0.15s; background: #fff; }
        .date-btn:hover { border-color: #2563eb; background: #eff6ff; }
        .date-btn.selected { border-color: #2563eb; background: #2563eb; color: #fff; }
        .date-btn .day { font-size: 0.75rem; opacity: 0.7; }
        .session-list { display: flex; flex-wrap: wrap; gap: 0.5rem; }
        .session-btn { border: 1px solid #e2e8f0; border-radius: 8px; padding: 0.5rem 1rem; cursor: pointer; transition: all 0.15s; background: #fff; text-align: center; min-width: 120px; }
        .session-btn:hover { border-color: #2563eb; background: #eff6ff; }
        .session-btn.selected { border-color: #2563eb; background: #2563eb; color: #fff; }
        .session-btn .time { font-weight: 600; }
        .session-btn .avail { font-size: 0.78rem; opacity: 0.7; }
        .price-table { width: 100%; }
        .price-table th { background: #f8fafc; font-weight: 500; font-size: 0.85rem; padding: 0.6rem; }
        .price-table td { padding: 0.6rem; vertical-align: middle; }
        .qty-input { width: 60px; text-align: center; }
        .total-row { font-weight: 700; font-size: 1.05rem; background: #f0f9ff; }
        .result-card { text-align: center; padding: 2rem; }
        .result-card .check { color: #16a34a; font-size: 3rem; }
        .admin-link { text-align: center; padding: 1rem; }
        .admin-link a { color: #64748b; font-size: 0.8rem; text-decoration: none; }
    </style>
</head>
<body>

<div class="booking-header">
    <h1>FastTicket 온라인 예약</h1>
    <p>간편하게 입장권을 예약하세요</p>
</div>

<div class="step-container">

    <!-- Step 1: 프로그램 선택 -->
    <div class="step-card" id="step1">
        <div class="step-header">
            <div class="step-num" id="sn1">1</div>
            <div class="step-title">프로그램 선택</div>
        </div>
        <div class="step-body">
            <select class="form-select" id="selProgram" onchange="onProgramChange()">
                <option value="">-- 프로그램을 선택하세요 --</option>
                <c:forEach var="p" items="${programList}">
                    <option value="${p.programId}">${p.programNm}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <!-- Step 2: 날짜 선택 -->
    <div class="step-card disabled" id="step2">
        <div class="step-header">
            <div class="step-num" id="sn2">2</div>
            <div class="step-title">날짜 선택</div>
        </div>
        <div class="step-body">
            <div id="dateGrid" class="date-grid"></div>
            <div id="dateEmpty" style="display:none;text-align:center;color:#94a3b8;padding:1rem;">예약 가능한 날짜가 없습니다.</div>
        </div>
    </div>

    <!-- Step 3: 회차 선택 -->
    <div class="step-card disabled" id="step3">
        <div class="step-header">
            <div class="step-num" id="sn3">3</div>
            <div class="step-title">회차 선택</div>
        </div>
        <div class="step-body">
            <div id="sessionList" class="session-list"></div>
        </div>
    </div>

    <!-- Step 4: 권종/수량 선택 -->
    <div class="step-card disabled" id="step4">
        <div class="step-header">
            <div class="step-num" id="sn4">4</div>
            <div class="step-title">권종 및 수량 선택</div>
        </div>
        <div class="step-body">
            <table class="table price-table" id="priceTable">
                <thead><tr><th>권종</th><th>단가</th><th>수량</th><th>소계</th></tr></thead>
                <tbody id="priceBody"></tbody>
                <tfoot>
                    <tr class="total-row"><td colspan="2">합계</td><td id="totalQty">0</td><td id="totalAmt">0원</td></tr>
                </tfoot>
            </table>
        </div>
    </div>

    <!-- Step 5: 예약자 정보 -->
    <div class="step-card disabled" id="step5">
        <div class="step-header">
            <div class="step-num" id="sn5">5</div>
            <div class="step-title">예약자 정보</div>
        </div>
        <div class="step-body">
            <div class="mb-3">
                <label class="form-label fw-bold">이름 <span class="text-danger">*</span></label>
                <input type="text" class="form-control form-control-sm" id="bookerNm" placeholder="예약자 이름"/>
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">연락처 <span class="text-danger">*</span></label>
                <input type="tel" class="form-control form-control-sm" id="bookerTel" placeholder="010-0000-0000"/>
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">이메일</label>
                <input type="email" class="form-control form-control-sm" id="bookerEmail" placeholder="선택사항"/>
            </div>
            <button class="btn btn-primary w-100" onclick="submitBooking()">예약 완료</button>
        </div>
    </div>

    <!-- 예약 완료 결과 (숨김) -->
    <div class="step-card" id="resultCard" style="display:none">
        <div class="result-card">
            <div class="check">&#10003;</div>
            <h4>예약이 완료되었습니다!</h4>
            <p class="text-muted" id="resultMsg"></p>
            <p style="margin-top:1rem"><strong>예약번호: </strong><span id="resultBookingId" style="color:#2563eb;font-size:1.1rem"></span></p>
            <button class="btn btn-outline-primary btn-sm mt-3" onclick="location.reload()">새 예약하기</button>
        </div>
    </div>

</div>

<div class="admin-link">
    <a href="<c:url value='/login.do'/>">관리자 로그인</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
var ctx = '${pageContext.request.contextPath}/';
var dayNames = ['일', '월', '화', '수', '목', '금', '토'];
var selectedProgram = '';
var selectedDate = '';
var selectedScheduleId = '';
var selectedOnlineAvail = 0;
var selectedSessionNo = 1;
var selectedDayType = 'WEEKDAY';
var currentDiscounts = [];

/* 할인 적용 - PROGRAM_DISCOUNT 기반 (중복적용 불가, 최대 할인 자동 적용) */
function applyBestDiscount(originalPrice, typeId, discounts) {
    if (!discounts || discounts.length === 0) return { price: originalPrice, discountNm: '', verifyRequired: false };
    var bestPrice = originalPrice;
    var bestName = '';
    var bestVerify = false;
    for (var i = 0; i < discounts.length; i++) {
        var d = discounts[i];
        if (d.useYn === 'N') continue;
        var dType = d.discountType;
        var dVal = parseInt(d.discountValue) || 0;
        var dNm = d.discountNm || '';
        var rUnit = parseInt(d.roundingUnit) || 1;
        var rType = d.roundingType || 'ROUND';
        var verify = d.verifyRequired === 'Y';
        var result;
        if (dType === 'AMOUNT') {
            result = Math.max(originalPrice - dVal, 0);
        } else {
            result = originalPrice * (1 - dVal / 100.0);
            if (result <= 0) { result = 0; }
            else {
                if (rType === 'CEIL') result = Math.ceil(result / rUnit) * rUnit;
                else if (rType === 'FLOOR') result = Math.floor(result / rUnit) * rUnit;
                else result = Math.round(result / rUnit) * rUnit;
            }
        }
        result = Math.max(Math.round(result), 0);
        if (result < bestPrice) { bestPrice = result; bestName = dNm; bestVerify = verify; }
    }
    return { price: bestPrice, discountNm: bestName, verifyRequired: bestVerify };
}

function enableStep(n) {
    document.getElementById('step' + n).classList.remove('disabled');
}
function disableStep(n) {
    document.getElementById('step' + n).classList.add('disabled');
}
function markDone(n) {
    document.getElementById('sn' + n).classList.add('done');
}

/* === Step 1: 프로그램 선택 === */
function onProgramChange() {
    selectedProgram = document.getElementById('selProgram').value;
    selectedDate = '';
    selectedScheduleId = '';
    disableStep(3); disableStep(4); disableStep(5);

    if (!selectedProgram) { disableStep(2); return; }
    markDone(1);
    enableStep(2);

    fetch(ctx + 'onlineBookingDates.do?programId=' + encodeURIComponent(selectedProgram))
        .then(function(r) { return r.json(); })
        .then(function(dates) {
            var grid = document.getElementById('dateGrid');
            var empty = document.getElementById('dateEmpty');
            grid.innerHTML = '';
            if (!dates || dates.length === 0) {
                empty.style.display = '';
                return;
            }
            empty.style.display = 'none';
            dates.forEach(function(dt) {
                var d = new Date(dt);
                var dayIdx = d.getDay();
                var dayNm = dayNames[dayIdx] + '요일';
                var div = document.createElement('div');
                div.className = 'date-btn';
                div.setAttribute('data-date', dt);
                div.innerHTML = '<div>' + dt + '</div><div class="day">' + dayNm + '</div>';
                if (dayIdx === 0) div.style.color = '#dc3545';
                if (dayIdx === 6) div.style.color = '#2563eb';
                div.onclick = function() { selectDate(dt, div); };
                grid.appendChild(div);
            });
        });
}

/* === Step 2: 날짜 선택 === */
function selectDate(dt, el) {
    selectedDate = dt;
    document.querySelectorAll('.date-btn').forEach(function(b) { b.classList.remove('selected'); b.style.color = ''; });
    el.classList.add('selected');
    el.style.color = '#fff';
    markDone(2);
    enableStep(3);
    disableStep(4); disableStep(5);

    fetch(ctx + 'onlineBookingSessions.do?programId=' + encodeURIComponent(selectedProgram) + '&eventDate=' + dt)
        .then(function(r) { return r.json(); })
        .then(function(sessions) {
            var list = document.getElementById('sessionList');
            list.innerHTML = '';
            sessions.forEach(function(s) {
                var div = document.createElement('div');
                div.className = 'session-btn';
                div.setAttribute('data-id', s.scheduleId);
                div.setAttribute('data-avail', s.onlineAvail);
                div.setAttribute('data-session-no', s.sessionNo);
                div.innerHTML = '<div class="time">' + (s.eventTime || '') + '</div>'
                    + '<div class="avail">' + s.sessionNo + '회차 / 잔여 ' + s.onlineAvail + '석</div>';
                div.onclick = function() { selectSession(s.scheduleId, s.onlineAvail, s.sessionNo, div); };
                list.appendChild(div);
            });
        });
}

/* === Step 3: 회차 선택 === */
function selectSession(scheduleId, avail, sessionNo, el) {
    selectedScheduleId = scheduleId;
    selectedOnlineAvail = avail;
    selectedSessionNo = sessionNo;

    // dayType 판단 (간이: 토/일=WEEKEND, 나머지=WEEKDAY. HOLIDAY는 서버에서 판단)
    var d = new Date(selectedDate);
    var dow = d.getDay();
    selectedDayType = (dow === 0 || dow === 6) ? 'WEEKEND' : 'WEEKDAY';

    document.querySelectorAll('.session-btn').forEach(function(b) { b.classList.remove('selected'); });
    el.classList.add('selected');
    markDone(3);
    enableStep(4);
    enableStep(5);

    fetch(ctx + 'onlineBookingPrices.do?scheduleId=' + encodeURIComponent(scheduleId)
            + '&programId=' + encodeURIComponent(selectedProgram) + '&eventDate=' + encodeURIComponent(selectedDate)
            + '&sessionNo=' + sessionNo + '&dayType=' + selectedDayType)
        .then(function(r) { return r.json(); })
        .then(function(data) {
            var prices = data.prices || [];
            var discounts = data.discounts || [];
            currentDiscounts = discounts;

            var body = document.getElementById('priceBody');
            body.innerHTML = '';
            if (!prices || prices.length === 0) {
                body.innerHTML = '<tr><td colspan="5" style="text-align:center;color:#94a3b8">가격 정보가 없습니다.</td></tr>';
                return;
            }
            prices.forEach(function(p) {
                var typeId = p.typeId || p.TYPE_ID;
                var typeNm = p.typeNm || p.TYPE_NM;
                var price = parseInt(p.price || p.PRICE);
                var isOverride = (p.isOverride || p.IS_OVERRIDE) === 'Y';
                var best = applyBestDiscount(price, typeId, discounts);
                var discounted = best.price;
                var tr = document.createElement('tr');
                var priceHtml = '';
                if (discounted < price) {
                    priceHtml = '<del class="text-muted">' + Number(price).toLocaleString() + '</del> '
                        + '<span class="text-danger fw-bold">' + Number(discounted).toLocaleString() + '원</span>'
                        + '<br><small class="text-info">' + best.discountNm + '</small>';
                    if (best.verifyRequired) {
                        priceHtml += '<br><small class="text-warning fw-bold">현장 확인 필요</small>';
                    }
                } else {
                    priceHtml = Number(price).toLocaleString() + '원';
                }
                if (isOverride) {
                    priceHtml += '<br><small class="text-muted">(특별가)</small>';
                }
                tr.innerHTML = '<td>' + typeNm + '</td>'
                    + '<td>' + priceHtml + '</td>'
                    + '<td><input type="number" class="form-control form-control-sm qty-input" min="0" value="0" '
                    + 'data-type-id="' + typeId + '" data-price="' + discounted + '" onchange="calcTotal()" oninput="calcTotal()"/></td>'
                    + '<td class="sub-total">0원</td>';
                body.appendChild(tr);
            });
            calcTotal();
        });
}

/* === Step 4: 수량 계산 === */
function calcTotal() {
    var inputs = document.querySelectorAll('.qty-input');
    var tQty = 0, tAmt = 0;
    inputs.forEach(function(inp) {
        var qty = parseInt(inp.value) || 0;
        var price = parseInt(inp.getAttribute('data-price')) || 0;
        var sub = qty * price;
        inp.closest('tr').querySelector('.sub-total').textContent = sub.toLocaleString() + '원';
        tQty += qty;
        tAmt += sub;
    });
    document.getElementById('totalQty').textContent = tQty;
    document.getElementById('totalAmt').textContent = tAmt.toLocaleString() + '원';
}

/* === Step 5: 예약 제출 === */
function submitBooking() {
    var bookerNm = document.getElementById('bookerNm').value.trim();
    var bookerTel = document.getElementById('bookerTel').value.trim();
    if (!bookerNm) { alert('이름을 입력하세요.'); return; }
    if (!bookerTel) { alert('연락처를 입력하세요.'); return; }

    var inputs = document.querySelectorAll('.qty-input');
    var typeIds = [], prices = [], qtys = [];
    var totalQty = 0;
    inputs.forEach(function(inp) {
        typeIds.push(inp.getAttribute('data-type-id'));
        prices.push(inp.getAttribute('data-price'));
        var q = parseInt(inp.value) || 0;
        qtys.push(q);
        totalQty += q;
    });

    if (totalQty <= 0) { alert('수량을 1개 이상 선택하세요.'); return; }
    if (totalQty > selectedOnlineAvail) {
        alert('선택한 수량(' + totalQty + ')이 온라인 잔여석(' + selectedOnlineAvail + ')을 초과합니다.');
        return;
    }

    if (!confirm('총 ' + totalQty + '매를 예약하시겠습니까?')) return;

    var params = 'scheduleId=' + encodeURIComponent(selectedScheduleId)
        + '&bookerNm=' + encodeURIComponent(bookerNm)
        + '&bookerTel=' + encodeURIComponent(bookerTel)
        + '&bookerEmail=' + encodeURIComponent(document.getElementById('bookerEmail').value || '')
        + '&typeIds=' + encodeURIComponent(typeIds.join(','))
        + '&prices=' + encodeURIComponent(prices.join(','))
        + '&qtys=' + encodeURIComponent(qtys.join(','));

    fetch(ctx + 'submitOnlineBooking.do', {
        method: 'POST',
        headers: {'Content-Type':'application/x-www-form-urlencoded'},
        body: params
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) {
            // 입력 영역 숨기고 결과 표시
            for (var i = 1; i <= 5; i++) document.getElementById('step' + i).style.display = 'none';
            document.getElementById('resultBookingId').textContent = data.bookingId;
            document.getElementById('resultMsg').textContent = data.totalQty + '매 / ' + Number(data.totalAmt).toLocaleString() + '원';
            document.getElementById('resultCard').style.display = '';
        } else {
            alert(data.message || '예약에 실패했습니다.');
        }
    });
}
</script>
</body>
</html>
