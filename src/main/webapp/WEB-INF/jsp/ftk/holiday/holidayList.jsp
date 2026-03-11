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
    <title>휴무일 관리</title>
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
                    <form:input path="searchKeyword" cssClass="form-control form-control-sm" placeholder="휴무일명 검색"/>
                    <a class="btn btn-outline-secondary btn-sm" href="javascript:fn_egov_selectList();">검색</a>
                </div>
            </div>
        </div>
        <div id="table" class="table-responsive">
            <table class="table table-hover table-striped" summary="휴무일 목록">
                <caption style="visibility:hidden">휴무일 목록</caption>
                <colgroup>
                    <col width="50"/>
                    <col width="120"/>
                    <col width="120"/>
                    <col/>
                    <col width="70"/>
                </colgroup>
                <tr>
                    <th>No</th>
                    <th>날짜</th>
                    <th>요일</th>
                    <th>휴무일명</th>
                    <th>사용</th>
                </tr>
                <c:forEach var="result" items="${resultList}" varStatus="status">
                    <tr style="cursor:pointer" onclick="openEditModal('${result.holidayId}')">
                        <td align="center"><c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/></td>
                        <td align="center"><c:out value="${result.holidayDate}"/></td>
                        <td align="center" class="day-label" data-date="${result.holidayDate}"></td>
                        <td><c:out value="${result.holidayNm}"/></td>
                        <td align="center">
                            <c:choose>
                                <c:when test="${result.useYn == 'Y'}"><span class="badge-active">Y</span></c:when>
                                <c:otherwise><span class="badge-inactive">N</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty resultList}">
                    <tr><td colspan="5">
                        <div class="empty-state">
                            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                            <p>등록된 휴무일이 없습니다.</p>
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
<div class="modal fade" id="holidayModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">휴무일 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="m_holidayId" />
                <div class="mb-3">
                    <label class="form-label fw-bold">날짜 <span class="text-danger">*</span></label>
                    <input type="date" class="form-control form-control-sm" id="m_holidayDate" required />
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">휴무일명 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control form-control-sm" id="m_holidayNm" placeholder="예: 설날, 추석, 정기휴무 등" />
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
var dayNames = ['일', '월', '화', '수', '목', '금', '토'];

document.addEventListener('DOMContentLoaded', function() {
    modal = new bootstrap.Modal(document.getElementById('holidayModal'));
    document.querySelectorAll('.day-label').forEach(function(el) {
        var dateStr = el.getAttribute('data-date');
        if (dateStr) {
            var d = new Date(dateStr);
            var day = dayNames[d.getDay()];
            el.textContent = day + '요일';
            if (d.getDay() === 0) el.style.color = '#dc3545';
            if (d.getDay() === 6) el.style.color = '#0d6efd';
        }
    });
});

function fn_egov_selectList() {
    document.listForm.action = ctx + 'holidayList.do';
    document.listForm.submit();
}

function fn_egov_link_page(pageNo) {
    document.listForm.pageIndex.value = pageNo;
    document.listForm.action = ctx + 'holidayList.do';
    document.listForm.submit();
}

function openModal() {
    document.getElementById('modalTitle').textContent = '휴무일 등록';
    document.getElementById('m_holidayId').value = '';
    document.getElementById('m_holidayDate').value = '';
    document.getElementById('m_holidayNm').value = '';
    document.getElementById('btnDelete').style.display = 'none';
    modal.show();
}

function openEditModal(holidayId) {
    fetch(ctx + 'holidayDetail.do?holidayId=' + encodeURIComponent(holidayId))
        .then(function(r) { return r.json(); })
        .then(function(data) {
            document.getElementById('modalTitle').textContent = '휴무일 수정';
            document.getElementById('m_holidayId').value = data.holidayId;
            document.getElementById('m_holidayDate').value = data.holidayDate;
            document.getElementById('m_holidayNm').value = data.holidayNm || '';
            document.getElementById('btnDelete').style.display = '';
            modal.show();
        });
}

function saveItem() {
    var holidayDate = document.getElementById('m_holidayDate').value;
    var holidayNm = document.getElementById('m_holidayNm').value.trim();
    if (!holidayDate) { alert('날짜를 선택하세요.'); return; }
    if (!holidayNm) { alert('휴무일명을 입력하세요.'); return; }

    var holidayId = document.getElementById('m_holidayId').value;
    var isEdit = !!holidayId;

    var params = 'holidayDate=' + encodeURIComponent(holidayDate)
        + '&holidayNm=' + encodeURIComponent(holidayNm);

    var url;
    if (isEdit) {
        params += '&holidayId=' + encodeURIComponent(holidayId);
        url = ctx + 'modifyHoliday.do';
    } else {
        url = ctx + 'saveHoliday.do';
    }

    fetch(url, { method: 'POST', headers: {'Content-Type':'application/x-www-form-urlencoded'}, body: params })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) {
                modal.hide();
                location.reload();
            } else {
                alert(data.message || '오류가 발생했습니다.');
            }
        });
}

function deleteItem() {
    var holidayId = document.getElementById('m_holidayId').value;
    if (!holidayId) return;
    if (!confirm('이 휴무일을 삭제하시겠습니까?')) return;

    fetch(ctx + 'removeHoliday.do', {
        method: 'POST',
        headers: {'Content-Type':'application/x-www-form-urlencoded'},
        body: 'holidayId=' + encodeURIComponent(holidayId)
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
