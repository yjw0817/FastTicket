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
    <title>권종 관리</title>
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
                        <form:select path="searchCondition" cssClass="form-select form-select-sm">
                            <form:option value="0" label="권종ID" />
                            <form:option value="1" label="권종명" />
                        </form:select>
                        <form:input path="searchKeyword" cssClass="form-control form-control-sm"/>
                        <a class="btn btn-outline-secondary btn-sm" href="javascript:fn_egov_selectList();">검색</a>
                    </div>
                </div>
            </div>
            <div id="table" class="table-responsive">
                <table class="table table-hover table-striped">
                    <caption style="visibility:hidden">권종 목록 테이블</caption>
                    <colgroup>
                        <col width="40"/><col width="100"/><col width="150"/>
                        <col width="80"/><col width="80"/><col width="120"/>
                    </colgroup>
                    <tr>
                        <th>No</th><th>권종ID</th><th>권종명</th>
                        <th>정렬순서</th><th>사용여부</th><th>등록일</th>
                    </tr>
                    <c:forEach var="result" items="${resultList}" varStatus="status">
                        <tr style="cursor:pointer" onclick="openModal('<c:out value="${result.typeId}"/>')">
                            <td align="center"><c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/></td>
                            <td align="center"><c:out value="${result.typeId}"/></td>
                            <td><c:out value="${result.typeNm}"/></td>
                            <td align="center"><c:out value="${result.sortOrder}"/></td>
                            <td align="center">
                                <c:choose>
                                    <c:when test="${result.useYn == 'Y'}"><span class="badge-active">사용</span></c:when>
                                    <c:otherwise><span class="badge-inactive">미사용</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td align="center"><c:out value="${result.regDt}"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty resultList}">
                        <tr><td colspan="6">
                            <div class="empty-state">
                                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/><line x1="7" y1="7" x2="7.01" y2="7"/></svg>
                                <p>등록된 권종이 없습니다.</p>
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

<!-- 권종 등록/수정 모달 -->
<div class="modal fade" id="ticketTypeModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">권종 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="modal_typeId"/>
                <div class="mb-3">
                    <label for="modal_typeNm" class="form-label">권종명 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="modal_typeNm" placeholder="예: 어린이, 청소년, 성인, 경로" maxlength="100"/>
                </div>
                <div class="mb-3">
                    <label for="modal_sortOrder" class="form-label">정렬순서</label>
                    <input type="number" class="form-control" id="modal_sortOrder" value="0" min="0"/>
                </div>
                <div class="mb-3">
                    <label for="modal_useYn" class="form-label">사용여부</label>
                    <select class="form-select" id="modal_useYn">
                        <option value="Y">사용</option>
                        <option value="N">미사용</option>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
var ctx = '<c:url value="/"/>';
var modal;

document.addEventListener('DOMContentLoaded', function() {
    modal = new bootstrap.Modal(document.getElementById('ticketTypeModal'));
});

function fn_egov_selectList() {
    document.listForm.action = ctx + 'ticketTypeList.do';
    document.listForm.submit();
}
function fn_egov_link_page(pageNo) {
    document.listForm.pageIndex.value = pageNo;
    fn_egov_selectList();
}

function openModal(typeId) {
    document.getElementById('modal_typeId').value = '';
    document.getElementById('modal_typeNm').value = '';
    document.getElementById('modal_sortOrder').value = '0';
    document.getElementById('modal_useYn').value = 'Y';
    document.getElementById('btnDelete').style.display = 'none';

    if (typeId) {
        document.getElementById('modalTitle').textContent = '권종 수정';
        fetch(ctx + 'ticketTypeDetail.do?typeId=' + encodeURIComponent(typeId))
            .then(function(r) { return r.json(); })
            .then(function(data) {
                document.getElementById('modal_typeId').value = data.typeId;
                document.getElementById('modal_typeNm').value = data.typeNm;
                document.getElementById('modal_sortOrder').value = data.sortOrder;
                document.getElementById('modal_useYn').value = data.useYn;
                document.getElementById('btnDelete').style.display = '';
                modal.show();
            });
    } else {
        document.getElementById('modalTitle').textContent = '권종 등록';
        modal.show();
    }
}

function doSave() {
    var typeNm = document.getElementById('modal_typeNm').value.trim();
    if (!typeNm) { alert('권종명을 입력하세요.'); return; }

    var typeId = document.getElementById('modal_typeId').value;
    var url = typeId ? (ctx + 'modifyTicketType.do') : (ctx + 'saveTicketType.do');
    var params = 'typeNm=' + encodeURIComponent(typeNm)
        + '&sortOrder=' + document.getElementById('modal_sortOrder').value
        + '&useYn=' + document.getElementById('modal_useYn').value;
    if (typeId) params += '&typeId=' + encodeURIComponent(typeId);

    fetch(url, { method: 'POST', headers: {'Content-Type':'application/x-www-form-urlencoded'}, body: params })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) { modal.hide(); location.reload(); }
            else { alert(data.message || '오류가 발생했습니다.'); }
        });
}

function doDelete() {
    if (!confirm('삭제하시겠습니까?')) return;
    var typeId = document.getElementById('modal_typeId').value;
    fetch(ctx + 'removeTicketType.do', { method: 'POST', headers: {'Content-Type':'application/x-www-form-urlencoded'}, body: 'typeId=' + encodeURIComponent(typeId) })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) { modal.hide(); location.reload(); }
            else { alert(data.message || '오류가 발생했습니다.'); }
        });
}
</script>
</body>
</html>
