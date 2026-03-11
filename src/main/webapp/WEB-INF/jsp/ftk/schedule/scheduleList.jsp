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
    <title>일정 관리</title>
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
                    <a class="btn btn-success btn-sm" href="javascript:openBulkModal();">회차 자동생성</a>
                    <a class="btn btn-info btn-sm" href="<c:url value='/scheduleCalendar.do'/>">달력 보기</a>
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
            <div id="table" class="table-responsive">
                <table class="table table-hover table-striped">
                    <caption style="visibility:hidden">일정 목록 테이블</caption>
                    <colgroup>
                        <col width="40"/><col width="90"/><col width="120"/><col width="90"/>
                        <col width="60"/><col width="50"/><col width="80"/><col width="80"/><col width="70"/>
                    </colgroup>
                    <tr>
                        <th>No</th><th>일정ID</th><th>프로그램</th><th>날짜</th>
                        <th>시간</th><th>회차</th><th>온라인정원</th><th>오프라인정원</th><th>상태</th>
                    </tr>
                    <c:forEach var="result" items="${resultList}" varStatus="status">
                        <tr style="cursor:pointer" onclick="openModal('<c:out value="${result.scheduleId}"/>')">
                            <td align="center"><c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/></td>
                            <td align="center"><c:out value="${result.scheduleId}"/></td>
                            <td><c:out value="${result.programNm}"/></td>
                            <td align="center"><c:out value="${result.eventDate}"/></td>
                            <td align="center"><c:out value="${result.eventTime}"/></td>
                            <td align="center"><c:out value="${result.sessionNo}"/>회</td>
                            <td align="center"><c:out value="${result.onlineAvail}"/>/<c:out value="${result.onlineCapacity}"/></td>
                            <td align="center"><c:out value="${result.offlineAvail}"/>/<c:out value="${result.offlineCapacity}"/></td>
                            <td align="center">
                                <c:choose>
                                    <c:when test="${result.status == 'OPEN'}"><span class="badge-active">판매중</span></c:when>
                                    <c:when test="${result.status == 'CLOSED'}"><span class="badge-inactive">마감</span></c:when>
                                    <c:when test="${result.status == 'CANCELED'}"><span class="badge-cancel">취소</span></c:when>
                                    <c:otherwise><span class="badge-info">${not empty result.status ? result.status : '-'}</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty resultList}">
                        <tr><td colspan="9">
                            <div class="empty-state">
                                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                                <p>등록된 일정이 없습니다.</p>
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

<!-- 일정 등록/수정 모달 -->
<div class="modal fade" id="scheduleModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">일정 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="m_scheduleId"/>
                <div class="mb-3">
                    <label for="m_programId" class="form-label">프로그램 <span class="text-danger">*</span></label>
                    <select class="form-select" id="m_programId">
                        <option value="">-- 선택 --</option>
                        <c:forEach var="p" items="${programList}">
                            <option value="${p.programId}">${p.programNm}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="row mb-3">
                    <div class="col-6">
                        <label for="m_eventDate" class="form-label">날짜 <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" id="m_eventDate"/>
                    </div>
                    <div class="col-3">
                        <label for="m_eventTime" class="form-label">시간 <span class="text-danger">*</span></label>
                        <input type="time" class="form-control" id="m_eventTime"/>
                    </div>
                    <div class="col-3">
                        <label for="m_sessionNo" class="form-label">회차</label>
                        <input type="number" class="form-control" id="m_sessionNo" value="1" min="1"/>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-6">
                        <label for="m_onlineCapacity" class="form-label">온라인 정원</label>
                        <input type="number" class="form-control" id="m_onlineCapacity" value="0" min="0"/>
                    </div>
                    <div class="col-6">
                        <label for="m_offlineCapacity" class="form-label">오프라인 정원</label>
                        <input type="number" class="form-control" id="m_offlineCapacity" value="0" min="0"/>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="m_status" class="form-label">상태</label>
                    <select class="form-select" id="m_status">
                        <option value="OPEN">오픈</option>
                        <option value="CLOSED">마감</option>
                        <option value="CANCELED">취소</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger btn-sm" id="btnDelete" style="display:none" onclick="doDelete()">삭제</button>
                <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary btn-sm" onclick="doSave()">저장</button>
            </div>
        </div>
    </div>
</div>

<!-- 회차 벌크 자동 생성 모달 -->
<div class="modal fade" id="bulkModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">회차 자동 생성</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label for="b_programId" class="form-label">프로그램 <span class="text-danger">*</span></label>
                    <select class="form-select" id="b_programId">
                        <option value="">-- 선택 --</option>
                        <c:forEach var="p" items="${programList}">
                            <option value="${p.programId}">${p.programNm}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="row mb-3">
                    <div class="col-6">
                        <label for="b_startDate" class="form-label">시작일 <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" id="b_startDate"/>
                    </div>
                    <div class="col-6">
                        <label for="b_endDate" class="form-label">종료일 <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" id="b_endDate"/>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-3">
                        <label for="b_startTime" class="form-label">영업 시작 <span class="text-danger">*</span></label>
                        <input type="time" class="form-control" id="b_startTime" value="09:00"/>
                    </div>
                    <div class="col-3">
                        <label for="b_endTime" class="form-label">영업 종료 <span class="text-danger">*</span></label>
                        <input type="time" class="form-control" id="b_endTime" value="18:00"/>
                    </div>
                    <div class="col-3">
                        <label for="b_intervalMin" class="form-label">회차 단위(분) <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="b_intervalMin" value="60" min="10" step="5"/>
                    </div>
                    <div class="col-3">
                        <label for="b_breakMin" class="form-label">쉬는시간(분)</label>
                        <input type="number" class="form-control" id="b_breakMin" value="0" min="0" step="5"/>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-6">
                        <label for="b_onlineCapacity" class="form-label">온라인 정원</label>
                        <input type="number" class="form-control" id="b_onlineCapacity" value="0" min="0"/>
                    </div>
                    <div class="col-6">
                        <label for="b_offlineCapacity" class="form-label">오프라인 정원</label>
                        <input type="number" class="form-control" id="b_offlineCapacity" value="0" min="0"/>
                    </div>
                </div>
                <div class="alert alert-info" id="bulkPreview" style="display:none"></div>
                <div class="alert alert-warning py-2 mb-0" style="font-size:0.85rem">
                    <strong>참고:</strong> 휴무일 관리에 등록된 휴무일은 자동으로 제외됩니다.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-success btn-sm" onclick="doBulkGenerate()">자동 생성</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
var ctx = '<c:url value="/"/>';
var scheduleModal, bulkModal;

document.addEventListener('DOMContentLoaded', function() {
    scheduleModal = new bootstrap.Modal(document.getElementById('scheduleModal'));
    bulkModal = new bootstrap.Modal(document.getElementById('bulkModal'));

    // 벌크 미리보기 자동 갱신
    ['b_startDate','b_endDate','b_startTime','b_endTime','b_intervalMin','b_breakMin'].forEach(function(id) {
        document.getElementById(id).addEventListener('change', updateBulkPreview);
        document.getElementById(id).addEventListener('input', updateBulkPreview);
    });
});

function fn_egov_selectList() {
    document.listForm.action = ctx + 'scheduleList.do';
    document.listForm.submit();
}
function fn_egov_link_page(pageNo) {
    document.listForm.pageIndex.value = pageNo;
    fn_egov_selectList();
}

/* === 개별 등록/수정 모달 === */
function openModal(scheduleId) {
    document.getElementById('m_scheduleId').value = '';
    document.getElementById('m_programId').value = '';
    document.getElementById('m_eventDate').value = '';
    document.getElementById('m_eventTime').value = '';
    document.getElementById('m_sessionNo').value = '1';
    document.getElementById('m_onlineCapacity').value = '0';
    document.getElementById('m_offlineCapacity').value = '0';
    document.getElementById('m_status').value = 'OPEN';
    document.getElementById('btnDelete').style.display = 'none';

    if (scheduleId) {
        document.getElementById('modalTitle').textContent = '일정 수정';
        fetch(ctx + 'scheduleDetail.do?scheduleId=' + encodeURIComponent(scheduleId))
            .then(function(r) { return r.json(); })
            .then(function(d) {
                document.getElementById('m_scheduleId').value = d.scheduleId;
                document.getElementById('m_programId').value = d.programId;
                document.getElementById('m_eventDate').value = d.eventDate;
                document.getElementById('m_eventTime').value = d.eventTime;
                document.getElementById('m_sessionNo').value = d.sessionNo;
                document.getElementById('m_onlineCapacity').value = d.onlineCapacity;
                document.getElementById('m_offlineCapacity').value = d.offlineCapacity;
                document.getElementById('m_status').value = d.status;
                document.getElementById('btnDelete').style.display = '';
                scheduleModal.show();
            });
    } else {
        document.getElementById('modalTitle').textContent = '일정 등록';
        scheduleModal.show();
    }
}

function doSave() {
    var programId = document.getElementById('m_programId').value;
    var eventDate = document.getElementById('m_eventDate').value;
    var eventTime = document.getElementById('m_eventTime').value;
    if (!programId) { alert('프로그램을 선택하세요.'); return; }
    if (!eventDate) { alert('날짜를 입력하세요.'); return; }
    if (!eventTime) { alert('시간을 입력하세요.'); return; }

    var scheduleId = document.getElementById('m_scheduleId').value;
    var url = scheduleId ? (ctx + 'modifySchedule.do') : (ctx + 'saveSchedule.do');
    var params = 'programId=' + encodeURIComponent(programId)
        + '&eventDate=' + eventDate
        + '&eventTime=' + eventTime
        + '&sessionNo=' + document.getElementById('m_sessionNo').value
        + '&onlineCapacity=' + document.getElementById('m_onlineCapacity').value
        + '&offlineCapacity=' + document.getElementById('m_offlineCapacity').value
        + '&status=' + document.getElementById('m_status').value;
    if (scheduleId) params += '&scheduleId=' + encodeURIComponent(scheduleId);

    fetch(url, { method: 'POST', headers: {'Content-Type':'application/x-www-form-urlencoded'}, body: params })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) { scheduleModal.hide(); location.reload(); }
            else { alert(data.message || '오류가 발생했습니다.'); }
        });
}

function doDelete() {
    if (!confirm('삭제하시겠습니까?')) return;
    var scheduleId = document.getElementById('m_scheduleId').value;
    fetch(ctx + 'removeSchedule.do', { method: 'POST', headers: {'Content-Type':'application/x-www-form-urlencoded'}, body: 'scheduleId=' + encodeURIComponent(scheduleId) })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) { scheduleModal.hide(); location.reload(); }
            else { alert(data.message || '오류가 발생했습니다.'); }
        });
}

/* === 벌크 자동 생성 모달 === */
function openBulkModal() {
    document.getElementById('bulkPreview').style.display = 'none';
    // 영업시간 기본값 불러오기
    fetch(ctx + 'businessHoursApi.do')
        .then(function(r) { return r.json(); })
        .then(function(list) {
            if (list && list.length > 0) {
                var first = list.find(function(h) { return h.useYn === 'Y'; });
                if (first) {
                    document.getElementById('b_startTime').value = first.openTime || '09:00';
                    document.getElementById('b_endTime').value = first.closeTime || '18:00';
                }
            }
        })
        .catch(function() { /* 무시 — 기본값 유지 */ });
    bulkModal.show();
}

function updateBulkPreview() {
    var s = document.getElementById('b_startDate').value;
    var e = document.getElementById('b_endDate').value;
    var st = document.getElementById('b_startTime').value;
    var et = document.getElementById('b_endTime').value;
    var interval = parseInt(document.getElementById('b_intervalMin').value) || 0;
    var brk = parseInt(document.getElementById('b_breakMin').value) || 0;
    var preview = document.getElementById('bulkPreview');

    if (!s || !e || !st || !et || interval <= 0) { preview.style.display = 'none'; return; }

    var days = Math.floor((new Date(e) - new Date(s)) / 86400000) + 1;
    if (days <= 0) { preview.style.display = 'none'; return; }

    var startMin = parseInt(st.split(':')[0]) * 60 + parseInt(st.split(':')[1]);
    var endMin = parseInt(et.split(':')[0]) * 60 + parseInt(et.split(':')[1]);
    var sessionsPerDay = 0;
    var cur = startMin;
    while (cur + interval <= endMin) {
        sessionsPerDay++;
        cur += interval + brk;
    }

    var total = days * sessionsPerDay;
    preview.innerHTML = '<strong>' + days + '일</strong> x <strong>' + sessionsPerDay + '회차/일</strong> = <strong>' + total + '건</strong> 생성 예정';
    preview.style.display = '';
}

function doBulkGenerate() {
    var programId = document.getElementById('b_programId').value;
    if (!programId) { alert('프로그램을 선택하세요.'); return; }
    var startDate = document.getElementById('b_startDate').value;
    var endDate = document.getElementById('b_endDate').value;
    var startTime = document.getElementById('b_startTime').value;
    var endTime = document.getElementById('b_endTime').value;
    var intervalMin = document.getElementById('b_intervalMin').value;
    if (!startDate || !endDate || !startTime || !endTime || !intervalMin) {
        alert('필수 항목을 모두 입력하세요.'); return;
    }

    if (!confirm('회차를 자동 생성하시겠습니까?')) return;

    var params = 'programId=' + encodeURIComponent(programId)
        + '&startDate=' + startDate + '&endDate=' + endDate
        + '&startTime=' + startTime + '&endTime=' + endTime
        + '&intervalMin=' + intervalMin
        + '&breakMin=' + (document.getElementById('b_breakMin').value || '0')
        + '&onlineCapacity=' + document.getElementById('b_onlineCapacity').value
        + '&offlineCapacity=' + document.getElementById('b_offlineCapacity').value;

    fetch(ctx + 'generateScheduleBulk.do', { method: 'POST', headers: {'Content-Type':'application/x-www-form-urlencoded'}, body: params })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) {
                alert(data.message);
                bulkModal.hide();
                location.reload();
            } else {
                alert(data.message || '오류가 발생했습니다.');
            }
        });
}
</script>
</body>
</html>
