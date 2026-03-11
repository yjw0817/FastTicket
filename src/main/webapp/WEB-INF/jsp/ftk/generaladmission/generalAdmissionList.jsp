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
    <title>일반 입장권</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=5"/>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />
<form:form modelAttribute="searchVO" id="listForm" name="listForm" method="post">
    <input type="hidden" name="selectedId" />
    <div id="content_pop">
        <div id="search">
            <div class="d-flex flex-wrap align-items-center gap-2">
                <a class="btn btn-primary btn-sm" href="javascript:openModal();">등록</a>
                <div class="d-flex align-items-center gap-2 ms-auto">
                    <form:select path="searchCondition" cssClass="form-select form-select-sm">
                        <form:option value="1" label="상품명" />
                        <form:option value="0" label="상품ID" />
                    </form:select>
                    <form:input path="searchKeyword" cssClass="form-control form-control-sm"/>
                    <a class="btn btn-outline-secondary btn-sm" href="javascript:fn_egov_selectList();">검색</a>
                </div>
            </div>
        </div>
        <div id="table" class="table-responsive">
            <table class="table table-hover table-striped" summary="일반 입장권 목록 테이블">
                <caption style="visibility:hidden">일반 입장권 목록</caption>
                <colgroup>
                    <col width="40"/>
                    <col width="100"/>
                    <col width="160"/>
                    <col width="120"/>
                    <col/>
                    <col width="70"/>
                </colgroup>
                <tr>
                    <th>No</th>
                    <th>상품ID</th>
                    <th>상품명</th>
                    <th>장소/시설</th>
                    <th>가격 요약</th>
                    <th>사용여부</th>
                </tr>
                <c:forEach var="result" items="${resultList}" varStatus="status">
                    <tr style="cursor:pointer" onclick="openEditModal('${result.programId}')">
                        <td align="center"><c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/></td>
                        <td align="center"><c:out value="${result.programId}"/></td>
                        <td><c:out value="${result.programNm}"/></td>
                        <td><c:out value="${result.venueNm}"/></td>
                        <td class="price-summary" id="ps_${result.programId}">-</td>
                        <td align="center">
                            <c:choose>
                                <c:when test="${result.useYn == 'Y'}"><span class="badge-active">Y</span></c:when>
                                <c:otherwise><span class="badge-inactive">N</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty resultList}">
                    <tr><td colspan="6">
                        <div class="empty-state">
                            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/><line x1="7" y1="7" x2="7.01" y2="7"/></svg>
                            <p>등록된 일반 입장권이 없습니다.</p>
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
<div class="modal fade" id="gaModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">일반 입장권 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="m_programId" />
                <div class="row mb-3">
                    <div class="col-md-8">
                        <label class="form-label fw-bold">상품명 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control form-control-sm" id="m_programNm" required />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">장소/시설</label>
                        <select class="form-select form-select-sm" id="m_venueId">
                            <option value="">-- 선택 --</option>
                            <c:forEach var="v" items="${venueList}">
                                <option value="${v.venueId}">${v.venueNm}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">설명</label>
                    <textarea class="form-control form-control-sm" id="m_description" rows="2"></textarea>
                </div>
                <hr/>
                <h6 class="fw-bold mb-3">권종별 가격</h6>
                <div class="row g-2" id="priceInputs">
                    <c:forEach var="tt" items="${ticketTypeList}">
                        <div class="col-md-3">
                            <label class="form-label">${tt.typeNm}</label>
                            <div class="input-group input-group-sm">
                                <input type="number" class="form-control" id="price_${tt.typeId}" data-type-id="${tt.typeId}" min="0" value="0"/>
                                <span class="input-group-text">원</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <c:if test="${empty ticketTypeList}">
                    <div class="alert alert-warning mt-2">등록된 권종이 없습니다. 먼저 기초설정 > 권종관리에서 권종을 등록하세요.</div>
                </c:if>
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
var ticketTypes = [];
<c:forEach var="tt" items="${ticketTypeList}">
ticketTypes.push({ typeId: '${tt.typeId}', typeNm: '${tt.typeNm}' });
</c:forEach>

document.addEventListener('DOMContentLoaded', function() {
    modal = new bootstrap.Modal(document.getElementById('gaModal'));
    // 목록의 각 행에 가격 요약 로드
    document.querySelectorAll('.price-summary').forEach(function(el) {
        var pid = el.id.replace('ps_', '');
        loadPriceSummary(pid, el);
    });
});

function loadPriceSummary(programId, el) {
    fetch(ctx + 'generalAdmissionDetail.do?programId=' + encodeURIComponent(programId))
        .then(function(r) { return r.json(); })
        .then(function(data) {
            var prices = data.prices || [];
            if (prices.length === 0) { el.textContent = '-'; return; }
            var parts = [];
            for (var i = 0; i < prices.length; i++) {
                parts.push(prices[i].typeNm + ' ' + Number(prices[i].price).toLocaleString() + '원');
            }
            el.textContent = parts.join(' / ');
        });
}

function fn_egov_selectList() {
    document.listForm.action = ctx + 'generalAdmissionList.do';
    document.listForm.submit();
}

function fn_egov_link_page(pageNo) {
    document.listForm.pageIndex.value = pageNo;
    document.listForm.action = ctx + 'generalAdmissionList.do';
    document.listForm.submit();
}

function openModal() {
    document.getElementById('modalTitle').textContent = '일반 입장권 등록';
    document.getElementById('m_programId').value = '';
    document.getElementById('m_programNm').value = '';
    document.getElementById('m_venueId').value = '';
    document.getElementById('m_description').value = '';
    document.getElementById('btnDelete').style.display = 'none';
    // 가격 초기화
    for (var i = 0; i < ticketTypes.length; i++) {
        var el = document.getElementById('price_' + ticketTypes[i].typeId);
        if (el) el.value = '0';
    }
    modal.show();
}

function openEditModal(programId) {
    fetch(ctx + 'generalAdmissionDetail.do?programId=' + encodeURIComponent(programId))
        .then(function(r) { return r.json(); })
        .then(function(data) {
            var p = data.program;
            document.getElementById('modalTitle').textContent = '일반 입장권 수정';
            document.getElementById('m_programId').value = p.programId;
            document.getElementById('m_programNm').value = p.programNm || '';
            document.getElementById('m_venueId').value = p.venueId || '';
            document.getElementById('m_description').value = p.description || '';
            document.getElementById('btnDelete').style.display = '';

            // 가격 초기화
            for (var i = 0; i < ticketTypes.length; i++) {
                var el = document.getElementById('price_' + ticketTypes[i].typeId);
                if (el) el.value = '0';
            }
            // 기존 가격 설정
            var prices = data.prices || [];
            for (var i = 0; i < prices.length; i++) {
                var el = document.getElementById('price_' + prices[i].typeId);
                if (el) el.value = prices[i].price;
            }
            modal.show();
        });
}

function saveItem() {
    var programNm = document.getElementById('m_programNm').value.trim();
    if (!programNm) { alert('상품명을 입력하세요.'); return; }

    var programId = document.getElementById('m_programId').value;
    var isEdit = !!programId;

    var typeIds = [];
    var prices = [];
    for (var i = 0; i < ticketTypes.length; i++) {
        var el = document.getElementById('price_' + ticketTypes[i].typeId);
        if (el) {
            typeIds.push(ticketTypes[i].typeId);
            prices.push(el.value || '0');
        }
    }

    var params = 'programNm=' + encodeURIComponent(programNm)
        + '&venueId=' + encodeURIComponent(document.getElementById('m_venueId').value)
        + '&description=' + encodeURIComponent(document.getElementById('m_description').value)
        + '&useYn=Y'
        + '&typeIds=' + encodeURIComponent(typeIds.join(','))
        + '&prices=' + encodeURIComponent(prices.join(','));

    var url;
    if (isEdit) {
        params += '&programId=' + encodeURIComponent(programId);
        url = ctx + 'modifyGeneralAdmission.do';
    } else {
        url = ctx + 'saveGeneralAdmission.do';
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
    var programId = document.getElementById('m_programId').value;
    if (!programId) return;
    if (!confirm('이 일반 입장권을 삭제하시겠습니까?')) return;

    fetch(ctx + 'removeGeneralAdmission.do', {
        method: 'POST',
        headers: {'Content-Type':'application/x-www-form-urlencoded'},
        body: 'programId=' + encodeURIComponent(programId)
    })
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
</script>
</body>
</html>
