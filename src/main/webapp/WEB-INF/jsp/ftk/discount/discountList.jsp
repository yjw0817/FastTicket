<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>할인 정책 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=5"/>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />
<form:form modelAttribute="searchVO" id="listForm" name="listForm" method="post">
    <div id="content_pop">
        <div id="search">
            <div class="d-flex flex-wrap align-items-center gap-2">
                <a class="btn btn-primary btn-sm" href="javascript:openModal();">등록</a>
                <div class="d-flex align-items-center gap-2 ms-auto">
                    <form:input path="searchKeyword" cssClass="form-control form-control-sm" placeholder="할인명 검색"/>
                    <a class="btn btn-outline-secondary btn-sm" href="javascript:fn_egov_selectList();">검색</a>
                </div>
            </div>
        </div>
        <div id="table" class="table-responsive">
            <table class="table table-hover table-striped" summary="할인 정책 목록">
                <caption style="visibility:hidden">할인 정책 목록</caption>
                <colgroup>
                    <col width="50"/>
                    <col/>
                    <col width="90"/>
                    <col width="90"/>
                    <col width="150"/>
                    <col width="180"/>
                    <col width="110"/>
                    <col width="110"/>
                    <col width="60"/>
                </colgroup>
                <tr>
                    <th>No</th>
                    <th>할인명</th>
                    <th>유형</th>
                    <th>할인값</th>
                    <th>적용 대상</th>
                    <th>적용 조건</th>
                    <th>시작일</th>
                    <th>종료일</th>
                    <th>사용</th>
                </tr>
                <c:forEach var="result" items="${resultList}" varStatus="status">
                    <tr style="cursor:pointer" onclick="openEditModal('${result.discountId}')">
                        <td align="center"><c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/></td>
                        <td><c:out value="${result.discountNm}"/></td>
                        <td align="center">
                            <c:choose>
                                <c:when test="${result.discountType == 'PERCENT'}"><span class="badge bg-info">정률(%)</span></c:when>
                                <c:otherwise><span class="badge bg-warning text-dark">정액(원)</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td align="center">
                            <c:choose>
                                <c:when test="${result.discountType == 'PERCENT'}"><c:out value="${result.discountValue}"/>%</c:when>
                                <c:otherwise><c:out value="${result.discountValue}"/>원</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty result.applyProgramNms}">
                                    <small><c:out value="${result.applyProgramNms}"/></small>
                                </c:when>
                                <c:otherwise><span class="text-muted">전체</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${not empty result.applyTimeFrom || not empty result.applyTimeTo}">
                                <span class="badge bg-secondary me-1"><c:out value="${not empty result.applyTimeFrom ? result.applyTimeFrom : '~'}"/>~<c:out value="${not empty result.applyTimeTo ? result.applyTimeTo : ''}"/></span>
                            </c:if>
                            <c:if test="${not empty result.applyDays}">
                                <span class="badge bg-dark me-1"><c:out value="${result.applyDays}"/></span>
                            </c:if>
                            <c:if test="${not empty result.applyTicketTypeNm}">
                                <span class="badge bg-success"><c:out value="${result.applyTicketTypeNm}"/></span>
                            </c:if>
                            <c:if test="${empty result.applyTimeFrom && empty result.applyTimeTo && empty result.applyDays && empty result.applyTicketTypeId}">
                                <span class="text-muted">-</span>
                            </c:if>
                        </td>
                        <td align="center"><c:out value="${result.startDate}"/></td>
                        <td align="center"><c:out value="${result.endDate}"/></td>
                        <td align="center">
                            <c:choose>
                                <c:when test="${result.useYn == 'Y'}"><span class="badge-active">Y</span></c:when>
                                <c:otherwise><span class="badge-inactive">N</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty resultList}">
                    <tr><td colspan="9">
                        <div class="empty-state">
                            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="8" y1="15" x2="16" y2="15"/><line x1="9" y1="9" x2="9.01" y2="9"/><line x1="15" y1="9" x2="15.01" y2="9"/></svg>
                            <p>등록된 할인 정책이 없습니다.</p>
                            <a class="btn btn-primary btn-sm" href="javascript:openModal();">등록하기</a>
                        </div>
                    </td></tr>
                </c:if>
            </table>
        </div>
        <div id="paging">
            <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
            <form:hidden path="pageIndex" />
        </div>
    </div>
</form:form>

<!-- 등록/수정 모달 -->
<div class="modal fade" id="discountModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">할인 정책 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="m_discountId" />

                <!-- 기본 정보 -->
                <h6 class="fw-bold mb-3" style="border-bottom:2px solid #0d6efd;padding-bottom:6px">기본 정보</h6>
                <div class="mb-3">
                    <label class="form-label fw-bold">할인명 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control form-control-sm" id="m_discountNm" placeholder="예: 조조할인, 야간할인, 경로할인 등" />
                </div>
                <div class="row mb-3">
                    <div class="col-4">
                        <label class="form-label fw-bold">할인 유형 <span class="text-danger">*</span></label>
                        <select class="form-select form-select-sm" id="m_discountType" onchange="updateValueLabel()">
                            <option value="PERCENT">정률 (%)</option>
                            <option value="AMOUNT">정액 (원)</option>
                        </select>
                    </div>
                    <div class="col-4">
                        <label class="form-label fw-bold" id="valueLabel">할인값 (%) <span class="text-danger">*</span></label>
                        <input type="number" class="form-control form-control-sm" id="m_discountValue" min="0" value="0" />
                    </div>
                    <div class="col-4" id="roundingArea">
                        <label class="form-label fw-bold">가격 <span id="roundingUnitLabel">1원</span> 단위 <span id="roundingTypeLabel">반올림</span></label>
                        <div class="d-flex gap-1">
                            <select class="form-select form-select-sm" id="m_roundingUnit" style="width:auto" onchange="updateRoundingLabel(); updatePricePreview();">
                                <option value="1">1원</option>
                                <option value="10">10원</option>
                                <option value="100">100원</option>
                                <option value="1000">1000원</option>
                            </select>
                            <select class="form-select form-select-sm" id="m_roundingType" style="width:auto" onchange="updateRoundingLabel(); updatePricePreview();">
                                <option value="ROUND">반올림</option>
                                <option value="CEIL">올림</option>
                                <option value="FLOOR">내림</option>
                            </select>
                        </div>
                    </div>
                </div>
                <!-- 할인 적용 미리보기 -->
                <div class="mb-3" id="pricePreviewArea">
                    <label class="form-label fw-bold">가격 미리보기 <small class="fw-normal text-muted">(예시)</small></label>
                    <div class="input-group input-group-sm" style="max-width:400px">
                        <span class="input-group-text">기본가격</span>
                        <input type="number" class="form-control" id="m_previewPrice" min="0" value="10000" oninput="updatePricePreview()" />
                        <span class="input-group-text">→</span>
                        <span class="input-group-text bg-light fw-bold" id="m_previewResult">10,000원</span>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-6">
                        <label class="form-label fw-bold">적용 시작일</label>
                        <input type="date" class="form-control form-control-sm" id="m_startDate" />
                    </div>
                    <div class="col-6">
                        <label class="form-label fw-bold">적용 종료일</label>
                        <input type="date" class="form-control form-control-sm" id="m_endDate" />
                    </div>
                </div>

                <!-- 적용 대상 프로그램 -->
                <h6 class="fw-bold mb-3 mt-4" style="border-bottom:2px solid #dc3545;padding-bottom:6px">적용 대상 입장권 <small class="fw-normal text-muted">(선택하지 않으면 모든 입장권에 적용)</small></h6>
                <div class="mb-3">
                    <table class="table table-sm table-bordered mb-0" style="max-width:600px" id="programTable">
                        <thead><tr><th style="width:30px"></th><th>입장권</th><th style="width:140px">할인값 (빈칸=기본값)</th></tr></thead>
                        <tbody>
                            <c:forEach var="prog" items="${programList}">
                                <tr>
                                    <td class="text-center"><input class="form-check-input prog-check" type="checkbox" value="${prog.programId}" id="prog_${prog.programId}" onchange="updateProgAll()"></td>
                                    <td><label class="form-check-label" for="prog_${prog.programId}"><c:out value="${prog.programNm}"/></label></td>
                                    <td><input type="number" class="form-control form-control-sm prog-value" min="0" data-program="${prog.programId}" placeholder="기본값" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <c:if test="${empty programList}">
                        <small class="text-muted">등록된 입장권이 없습니다.</small>
                    </c:if>
                </div>

                <!-- 적용 조건 -->
                <h6 class="fw-bold mb-3 mt-4" style="border-bottom:2px solid #198754;padding-bottom:6px">적용 조건 <small class="fw-normal text-muted">(비워두면 전체 적용)</small></h6>

                <div class="row mb-3">
                    <div class="col-6">
                        <label class="form-label fw-bold">시작 시간</label>
                        <input type="time" class="form-control form-control-sm" id="m_applyTimeFrom" />
                        <small class="text-muted">비워두면 영업 시작부터</small>
                    </div>
                    <div class="col-6">
                        <label class="form-label fw-bold">종료 시간</label>
                        <input type="time" class="form-control form-control-sm" id="m_applyTimeTo" />
                        <small class="text-muted">비워두면 영업 종료까지</small>
                    </div>
                </div>
                <div class="mb-1">
                    <small class="text-info">예) 조조할인: 종료 시간만 10:00 설정 / 야간할인: 시작 시간만 18:00 설정</small>
                </div>

                <div class="mb-3 mt-3">
                    <label class="form-label fw-bold">적용 요일</label>
                    <div class="d-flex gap-2 flex-wrap">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="day_all" onchange="toggleAllDays(this)">
                            <label class="form-check-label fw-bold" for="day_all">전체</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input day-check" type="checkbox" value="1" id="day_1" onchange="updateDayAll()">
                            <label class="form-check-label" for="day_1">월</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input day-check" type="checkbox" value="2" id="day_2" onchange="updateDayAll()">
                            <label class="form-check-label" for="day_2">화</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input day-check" type="checkbox" value="3" id="day_3" onchange="updateDayAll()">
                            <label class="form-check-label" for="day_3">수</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input day-check" type="checkbox" value="4" id="day_4" onchange="updateDayAll()">
                            <label class="form-check-label" for="day_4">목</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input day-check" type="checkbox" value="5" id="day_5" onchange="updateDayAll()">
                            <label class="form-check-label" for="day_5">금</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input day-check" type="checkbox" value="6" id="day_6" onchange="updateDayAll()">
                            <label class="form-check-label" for="day_6" style="color:#0d6efd">토</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input day-check" type="checkbox" value="7" id="day_7" onchange="updateDayAll()">
                            <label class="form-check-label" for="day_7" style="color:#dc3545">일</label>
                        </div>
                    </div>
                    <div class="mt-1">
                        <button type="button" class="btn btn-outline-secondary btn-sm py-0 px-2 me-1" onclick="setDayPreset('weekday')">평일</button>
                        <button type="button" class="btn btn-outline-secondary btn-sm py-0 px-2" onclick="setDayPreset('weekend')">주말</button>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">적용 권종</label>
                    <select class="form-select form-select-sm" id="m_applyTicketTypeId">
                        <option value="">전체 권종</option>
                        <c:forEach var="tt" items="${ticketTypeList}">
                            <option value="${tt.typeId}"><c:out value="${tt.typeNm}"/></option>
                        </c:forEach>
                    </select>
                </div>

                <!-- 적용 조건 미리보기 -->
                <div class="alert alert-light border mt-3 mb-0" id="conditionPreview">
                    <small class="fw-bold">미리보기:</small>
                    <span id="previewText" class="ms-1 text-muted">전체 적용 (조건 없음)</span>
                </div>

                <div class="mb-3 mt-3">
                    <label class="form-label fw-bold">비고</label>
                    <textarea class="form-control form-control-sm" id="m_remark" rows="2"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger btn-sm" id="btnDelete" style="display:none;margin-right:auto" onclick="deleteItem()">삭제</button>
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary btn-sm" onclick="saveItem()">저장</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
var ctx = '<c:url value="/"/>';
var modal;
var dayNames = {1:'월',2:'화',3:'수',4:'목',5:'금',6:'토',7:'일'};

document.addEventListener('DOMContentLoaded', function() {
    modal = new bootstrap.Modal(document.getElementById('discountModal'));
    // 미리보기 갱신 이벤트
    var els = ['m_applyTimeFrom','m_applyTimeTo','m_applyTicketTypeId','m_discountValue','m_discountType','m_roundingUnit','m_roundingType'];
    for (var i = 0; i < els.length; i++) {
        document.getElementById(els[i]).addEventListener('change', function() { updatePreview(); updatePricePreview(); });
        document.getElementById(els[i]).addEventListener('input', function() { updatePreview(); updatePricePreview(); });
    }
    // 프로그램 체크박스 이벤트
    var progChecks = document.querySelectorAll('.prog-check');
    for (var i = 0; i < progChecks.length; i++) {
        progChecks[i].addEventListener('change', updatePreview);
    }
});

function fn_egov_selectList() {
    document.listForm.action = ctx + 'discountList.do';
    document.listForm.submit();
}

function fn_egov_link_page(pageNo) {
    document.listForm.pageIndex.value = pageNo;
    document.listForm.action = ctx + 'discountList.do';
    document.listForm.submit();
}

function updateValueLabel() {
    var type = document.getElementById('m_discountType').value;
    document.getElementById('valueLabel').innerHTML = type === 'PERCENT'
        ? '할인값 (%) <span class="text-danger">*</span>'
        : '할인값 (원) <span class="text-danger">*</span>';
    // 반올림은 정률일 때만 표시
    document.getElementById('roundingArea').style.display = (type === 'PERCENT') ? '' : 'none';
    document.getElementById('pricePreviewArea').style.display = (type === 'PERCENT') ? '' : 'none';
    updateRoundingLabel();
    updatePreview();
    updatePricePreview();
}

/* ===== 요일 체크박스 ===== */
function toggleAllDays(el) {
    var checks = document.querySelectorAll('.day-check');
    for (var i = 0; i < checks.length; i++) checks[i].checked = el.checked;
    updatePreview();
}

function updateDayAll() {
    var checks = document.querySelectorAll('.day-check');
    var allChecked = true;
    for (var i = 0; i < checks.length; i++) { if (!checks[i].checked) { allChecked = false; break; } }
    document.getElementById('day_all').checked = allChecked;
    updatePreview();
}

function setDayPreset(preset) {
    var checks = document.querySelectorAll('.day-check');
    for (var i = 0; i < checks.length; i++) {
        var v = parseInt(checks[i].value);
        if (preset === 'weekday') checks[i].checked = (v >= 1 && v <= 5);
        else if (preset === 'weekend') checks[i].checked = (v >= 6);
    }
    updateDayAll();
}

function getSelectedDays() {
    var checks = document.querySelectorAll('.day-check:checked');
    var days = [];
    for (var i = 0; i < checks.length; i++) days.push(checks[i].value);
    if (days.length === 7) return '';
    return days.join(',');
}

function setDaysFromString(str) {
    var checks = document.querySelectorAll('.day-check');
    for (var i = 0; i < checks.length; i++) checks[i].checked = false;
    document.getElementById('day_all').checked = false;
    if (!str) return;
    var arr = str.split(',');
    for (var i = 0; i < arr.length; i++) {
        var el = document.getElementById('day_' + arr[i].trim());
        if (el) el.checked = true;
    }
    updateDayAll();
}

/* ===== 프로그램 체크박스 ===== */
function updateProgAll() {
    updatePreview();
}

function getSelectedProgramIds() {
    var checks = document.querySelectorAll('.prog-check:checked');
    var ids = [];
    for (var i = 0; i < checks.length; i++) ids.push(checks[i].value);
    return ids;
}

function getSelectedProgramValues() {
    var checks = document.querySelectorAll('.prog-check:checked');
    var vals = [];
    for (var i = 0; i < checks.length; i++) {
        var progId = checks[i].value;
        var input = document.querySelector('.prog-value[data-program="' + progId + '"]');
        vals.push(input ? (input.value || '') : '');
    }
    return vals;
}

function setSelectedProgramsWithValues(programsWithValues) {
    var checks = document.querySelectorAll('.prog-check');
    for (var i = 0; i < checks.length; i++) checks[i].checked = false;
    var valInputs = document.querySelectorAll('.prog-value');
    for (var i = 0; i < valInputs.length; i++) valInputs[i].value = '';
    if (!programsWithValues || !programsWithValues.length) return;
    for (var i = 0; i < programsWithValues.length; i++) {
        var pv = programsWithValues[i];
        var progId = pv.programId;
        var el = document.getElementById('prog_' + progId);
        if (el) el.checked = true;
        var valInput = document.querySelector('.prog-value[data-program="' + progId + '"]');
        if (valInput && pv.discountValue != null && pv.discountValue !== 0) {
            valInput.value = pv.discountValue;
        }
    }
}

/* ===== 미리보기 ===== */
function updatePreview() {
    var parts = [];

    // 프로그램
    var progChecks = document.querySelectorAll('.prog-check:checked');
    if (progChecks.length > 0) {
        var names = [];
        for (var i = 0; i < progChecks.length; i++) {
            var label = document.querySelector('label[for="' + progChecks[i].id + '"]');
            if (label) names.push(label.textContent);
        }
        parts.push('[' + names.join(', ') + ']');
    } else {
        parts.push('[모든 입장권]');
    }

    var timeFrom = document.getElementById('m_applyTimeFrom').value;
    var timeTo = document.getElementById('m_applyTimeTo').value;
    if (timeFrom || timeTo) {
        parts.push('시간 ' + (timeFrom || '영업시작') + '~' + (timeTo || '영업종료'));
    }

    var days = getSelectedDays();
    if (days) {
        var dayArr = days.split(',');
        var dayLabels = [];
        for (var i = 0; i < dayArr.length; i++) dayLabels.push(dayNames[parseInt(dayArr[i])]);
        parts.push(dayLabels.join(','));
    }

    var ttSel = document.getElementById('m_applyTicketTypeId');
    if (ttSel.value) parts.push(ttSel.options[ttSel.selectedIndex].text);

    var type = document.getElementById('m_discountType').value;
    var val = document.getElementById('m_discountValue').value;
    var discountLabel = '';
    if (val && parseInt(val) > 0) {
        discountLabel = type === 'PERCENT' ? val + '% 할인' : parseInt(val).toLocaleString() + '원 할인';
    }

    var text = parts.length > 0
        ? parts.join(' / ') + (discountLabel ? ' → ' + discountLabel : '')
        : '전체 적용 (조건 없음)' + (discountLabel ? ' → ' + discountLabel : '');

    document.getElementById('previewText').textContent = text;
}

/* ===== 반올림 라벨 갱신 ===== */
function updateRoundingLabel() {
    var unitSel = document.getElementById('m_roundingUnit');
    var typeSel = document.getElementById('m_roundingType');
    document.getElementById('roundingUnitLabel').textContent = unitSel.options[unitSel.selectedIndex].text;
    document.getElementById('roundingTypeLabel').textContent = typeSel.options[typeSel.selectedIndex].text;
}

/* ===== 가격 미리보기 ===== */
function updatePricePreview() {
    var type = document.getElementById('m_discountType').value;
    var val = parseInt(document.getElementById('m_discountValue').value) || 0;
    var price = parseInt(document.getElementById('m_previewPrice').value) || 0;
    var unit = parseInt(document.getElementById('m_roundingUnit').value) || 1;
    var rtype = document.getElementById('m_roundingType').value || 'ROUND';

    var result;
    if (type === 'AMOUNT') {
        result = Math.max(price - val, 0);
    } else {
        result = price * (1 - val / 100.0);
        if (result <= 0) { result = 0; }
        else {
            if (rtype === 'CEIL') result = Math.ceil(result / unit) * unit;
            else if (rtype === 'FLOOR') result = Math.floor(result / unit) * unit;
            else result = Math.round(result / unit) * unit;
        }
    }
    document.getElementById('m_previewResult').textContent = Math.max(Math.round(result), 0).toLocaleString() + '원';
}

/* ===== 모달 ===== */
function openModal() {
    document.getElementById('modalTitle').textContent = '할인 정책 등록';
    document.getElementById('m_discountId').value = '';
    document.getElementById('m_discountNm').value = '';
    document.getElementById('m_discountType').value = 'PERCENT';
    document.getElementById('m_discountValue').value = '';
    document.getElementById('m_startDate').value = '';
    document.getElementById('m_endDate').value = '';
    document.getElementById('m_applyTimeFrom').value = '';
    document.getElementById('m_applyTimeTo').value = '';
    document.getElementById('m_applyTicketTypeId').value = '';
    document.getElementById('m_roundingUnit').value = '1';
    document.getElementById('m_roundingType').value = 'ROUND';
    document.getElementById('m_remark').value = '';
    document.getElementById('btnDelete').style.display = 'none';
    setDaysFromString('');
    setSelectedProgramsWithValues([]);
    updateValueLabel();
    updatePreview();
    updatePricePreview();
    modal.show();
}

function openEditModal(discountId) {
    fetch(ctx + 'discountDetail.do?discountId=' + encodeURIComponent(discountId))
        .then(function(r) { return r.json(); })
        .then(function(data) {
            document.getElementById('modalTitle').textContent = '할인 정책 수정';
            document.getElementById('m_discountId').value = data.discountId;
            document.getElementById('m_discountNm').value = data.discountNm || '';
            document.getElementById('m_discountType').value = data.discountType || 'PERCENT';
            document.getElementById('m_discountValue').value = data.discountValue || 0;
            document.getElementById('m_startDate').value = data.startDate || '';
            document.getElementById('m_endDate').value = data.endDate || '';
            document.getElementById('m_applyTimeFrom').value = data.applyTimeFrom || '';
            document.getElementById('m_applyTimeTo').value = data.applyTimeTo || '';
            document.getElementById('m_applyTicketTypeId').value = data.applyTicketTypeId || '';
            document.getElementById('m_roundingUnit').value = data.roundingUnit || '1';
            document.getElementById('m_roundingType').value = data.roundingType || 'ROUND';
            document.getElementById('m_remark').value = data.remark || '';
            document.getElementById('btnDelete').style.display = '';
            setDaysFromString(data.applyDays || '');
            setSelectedProgramsWithValues(data.programsWithValues || []);
            updateValueLabel();
            updatePreview();
            updatePricePreview();
            modal.show();
        });
}

/* ===== 저장 ===== */
function saveItem() {
    var discountNm = document.getElementById('m_discountNm').value.trim();
    var discountValue = document.getElementById('m_discountValue').value;
    if (!discountNm) { alert('할인명을 입력하세요.'); return; }
    if (!discountValue || parseInt(discountValue) <= 0) { alert('할인값을 입력하세요.'); return; }
    var progIds = getSelectedProgramIds();
    // progIds 비어있으면 모든 입장권에 적용

    var discountId = document.getElementById('m_discountId').value;
    var isEdit = !!discountId;

    var params = 'discountNm=' + encodeURIComponent(discountNm)
        + '&discountType=' + document.getElementById('m_discountType').value
        + '&discountValue=' + discountValue
        + '&startDate=' + (document.getElementById('m_startDate').value || '')
        + '&endDate=' + (document.getElementById('m_endDate').value || '')
        + '&applyTimeFrom=' + (document.getElementById('m_applyTimeFrom').value || '')
        + '&applyTimeTo=' + (document.getElementById('m_applyTimeTo').value || '')
        + '&applyDays=' + getSelectedDays()
        + '&applyTicketTypeId=' + (document.getElementById('m_applyTicketTypeId').value || '')
        + '&roundingUnit=' + (document.getElementById('m_roundingUnit').value || '1')
        + '&roundingType=' + (document.getElementById('m_roundingType').value || 'ROUND')
        + '&remark=' + encodeURIComponent(document.getElementById('m_remark').value || '')
        + '&useYn=Y';

    // 선택된 프로그램 ID + 할인값 override 추가
    var progIds = getSelectedProgramIds();
    var progVals = getSelectedProgramValues();
    for (var i = 0; i < progIds.length; i++) {
        params += '&programIds=' + encodeURIComponent(progIds[i]);
        params += '&programValues=' + encodeURIComponent(progVals[i] || '');
    }

    var url;
    if (isEdit) {
        params += '&discountId=' + encodeURIComponent(discountId);
        url = ctx + 'modifyDiscount.do';
    } else {
        url = ctx + 'saveDiscount.do';
    }

    fetch(url, { method: 'POST', headers: {'Content-Type':'application/x-www-form-urlencoded'}, body: params })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) { modal.hide(); location.reload(); }
            else { alert(data.message || '오류가 발생했습니다.'); }
        });
}

function deleteItem() {
    var discountId = document.getElementById('m_discountId').value;
    if (!discountId) return;
    if (!confirm('이 할인 정책을 삭제하시겠습니까?')) return;

    fetch(ctx + 'removeDiscount.do', {
        method: 'POST',
        headers: {'Content-Type':'application/x-www-form-urlencoded'},
        body: 'discountId=' + encodeURIComponent(discountId)
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) { modal.hide(); location.reload(); }
        else { alert(data.message); }
    });
}
</script>
</body>
</html>
