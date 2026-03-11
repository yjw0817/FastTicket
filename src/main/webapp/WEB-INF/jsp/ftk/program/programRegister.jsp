<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"        uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <c:set var="registerFlag" value="${empty programVO.programId ? 'create' : 'modify'}"/>
    <title>프로그램 <c:if test="${registerFlag == 'create'}">등록</c:if><c:if test="${registerFlag == 'modify'}">수정</c:if></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=6"/>
    <style>
        .section-title {
            font-size: 15px;
            font-weight: 600;
            color: #2c3e50;
            padding: 10px 15px;
            background: #f8f9fa;
            border-left: 3px solid #3498db;
            margin: 20px 0 10px 0;
        }
        .inline-table { width: 100%; border-collapse: collapse; }
        .inline-table th { background: #f0f4f8; padding: 6px 10px; font-size: 13px; font-weight: 500; border: 1px solid #dee2e6; text-align: center; }
        .inline-table td { padding: 4px 6px; border: 1px solid #dee2e6; vertical-align: middle; }
        .inline-table input, .inline-table select { font-size: 13px; padding: 4px 8px; }
        .btn-add-row { font-size: 12px; padding: 2px 10px; }
        .btn-del-row { font-size: 11px; padding: 1px 6px; cursor: pointer; }
        .session-preview { background: #f0f8ff; border: 1px solid #b8daff; border-radius: 4px; padding: 8px 12px; font-size: 13px; margin-top: 6px; }
        .session-preview span { display: inline-block; margin-right: 15px; color: #0d6efd; }
    </style>
    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        function fn_egov_selectList() {
            document.detailForm.action = "<c:url value='/programList.do'/>";
            document.detailForm.submit();
        }

        function fn_egov_delete() {
            if (!confirm('삭제하시겠습니까? 관련 템플릿과 할인 데이터도 함께 삭제됩니다.')) return;
            document.detailForm.action = "<c:url value='/deleteProgram.do'/>";
            document.detailForm.submit();
        }

        function fn_egov_save() {
            var frm = document.detailForm;
            if (frm.programNm.value == '') {
                alert('프로그램명을 입력하세요.');
                frm.programNm.focus();
                return;
            }
            // disabled 입력 필드를 submit 전에 enable (값 유지)
            var disabledInputs = frm.querySelectorAll('#ticketTypeBody input[disabled], #discountBody input[disabled]');
            for (var i = 0; i < disabledInputs.length; i++) {
                disabledInputs[i].disabled = false;
            }
            frm.action = "<c:url value="${registerFlag == 'create' ? '/addProgram.do' : '/updateProgram.do'}"/>";
            frm.submit();
        }

        /* === 권종 인라인 추가/삭제 === */
        var ticketTypeIdx = ${fn:length(programVO.ticketTypes) > 0 ? fn:length(programVO.ticketTypes) : 0};

        function addTicketTypeRow() {
            var tbody = document.getElementById('ticketTypeBody');
            var tr = document.createElement('tr');
            tr.innerHTML =
                '<td><select name="ticketTypes[' + ticketTypeIdx + '].typeId" class="form-select form-select-sm" onchange="refreshTypeOptions()">' +
                '<option value="">-- 선택 --</option>' +
                <c:forEach var="tt" items="${ticketTypeList}">
                    '<option value="${tt.typeId}">${tt.typeNm}</option>' +
                </c:forEach>
                '</select></td>' +
                '<td data-col="0"><input type="number" name="ticketTypes[' + ticketTypeIdx + '].basePrice" class="form-control form-control-sm" value="0" min="0" style="text-align:right"/></td>' +
                '<td data-col="1"><input type="number" name="ticketTypes[' + ticketTypeIdx + '].satPrice" class="form-control form-control-sm" value="0" min="0" style="text-align:right"/></td>' +
                '<td data-col="2"><input type="number" name="ticketTypes[' + ticketTypeIdx + '].sunPrice" class="form-control form-control-sm" value="0" min="0" style="text-align:right"/></td>' +
                '<td data-col="3"><input type="number" name="ticketTypes[' + ticketTypeIdx + '].holPrice" class="form-control form-control-sm" value="0" min="0" style="text-align:right"/></td>' +
                '<td class="text-center"><button type="button" class="btn btn-outline-danger btn-del-row" onclick="removeRow(this)">X</button></td>';
            tbody.appendChild(tr);
            ticketTypeIdx++;
            applyDayColStates(tr);
            attachPriceAutoFill(tr);
            refreshTypeOptions();
        }

        /* === 요일별 열 활성/비활성 토글 === */
        var dayColChecks = ['chkWeekday', 'chkSat', 'chkSun', 'chkHol'];
        var dayColFields = ['basePrice', 'satPrice', 'sunPrice', 'holPrice'];

        function toggleDayCol(colIdx, enabled) {
            var tbody = document.getElementById('ticketTypeBody');
            var rows = tbody.getElementsByTagName('tr');
            for (var i = 0; i < rows.length; i++) {
                var tds = rows[i].getElementsByTagName('td');
                // td[0]=권종명, td[1]=평일, td[2]=토, td[3]=일, td[4]=공휴
                var td = tds[colIdx + 1];
                if (!td) continue;
                var input = td.querySelector('input[type="number"]');
                if (input) {
                    input.disabled = !enabled;
                    if (!enabled) {
                        input.value = '0';
                        td.style.opacity = '0.4';
                    } else {
                        td.style.opacity = '1';
                    }
                }
            }
        }

        function applyDayColStates(tr) {
            for (var c = 0; c < dayColChecks.length; c++) {
                var chk = document.getElementById(dayColChecks[c]);
                if (chk && !chk.checked) {
                    var tds = tr.getElementsByTagName('td');
                    var td = tds[c + 1];
                    if (td) {
                        var input = td.querySelector('input[type="number"]');
                        if (input) { input.disabled = true; input.value = '0'; td.style.opacity = '0.4'; }
                    }
                }
            }
        }

        /* === 할인 인라인 추가/삭제 === */
        var discountIdx = ${fn:length(programVO.discounts) > 0 ? fn:length(programVO.discounts) : 0};

        function addDiscountRow() {
            var tbody = document.getElementById('discountBody');
            var tr = document.createElement('tr');
            tr.innerHTML =
                '<td><input type="text" name="discounts[' + discountIdx + '].discountNm" class="form-control form-control-sm" placeholder="할인명"/></td>' +
                '<td><select name="discounts[' + discountIdx + '].discountType" class="form-select form-select-sm">' +
                '<option value="AMOUNT">정액</option><option value="PERCENT">정률(%)</option></select></td>' +
                '<td><input type="number" name="discounts[' + discountIdx + '].discountValue" class="form-control form-control-sm" value="0" min="0" style="text-align:right"/></td>' +
                '<td class="text-center"><input type="checkbox" name="discounts[' + discountIdx + '].verifyRequired" value="Y" class="form-check-input dc-verify-chk" onchange="toggleVerifyItem(this)"/></td>' +
                '<td><input type="text" name="discounts[' + discountIdx + '].verifyItem" class="form-control form-control-sm dc-verify-item" placeholder="예: 신분증" disabled style="opacity:0.4"/></td>' +
                '<td class="text-center"><button type="button" class="btn btn-outline-danger btn-del-row" onclick="removeRow(this)">X</button></td>';
            tbody.appendChild(tr);
            discountIdx++;
        }

        function toggleVerifyItem(chk) {
            var tr = chk.closest('tr');
            var item = tr.querySelector('.dc-verify-item');
            if (item) {
                item.disabled = !chk.checked;
                item.style.opacity = chk.checked ? '1' : '0.4';
                if (!chk.checked) item.value = '';
            }
        }

        function removeRow(btn) {
            var tr = btn.closest('tr');
            tr.parentNode.removeChild(tr);
            refreshTypeOptions();
        }

        /* === 이미 선택된 권종을 다른 행의 select에서 disable === */
        function refreshTypeOptions() {
            var tbody = document.getElementById('ticketTypeBody');
            var selects = tbody.querySelectorAll('select');
            // 현재 선택된 값 수집
            var usedIds = [];
            for (var i = 0; i < selects.length; i++) {
                if (selects[i].value) usedIds.push(selects[i].value);
            }
            // 각 select의 option을 enable/disable
            for (var i = 0; i < selects.length; i++) {
                var opts = selects[i].options;
                for (var j = 0; j < opts.length; j++) {
                    if (!opts[j].value) continue; // -- 선택 -- skip
                    opts[j].disabled = (usedIds.indexOf(opts[j].value) >= 0 && opts[j].value !== selects[i].value);
                }
            }
        }

        /* === 회차 미리보기 === */
        function updateSessionPreview() {
            var count = parseInt(document.getElementById('sessionCount').value) || 0;
            var first = document.getElementById('firstSessionTime').value || '';
            var interval = parseInt(document.getElementById('sessionInterval').value) || 0;
            var preview = document.getElementById('sessionPreview');

            if (count <= 0 || first.length < 5) {
                preview.innerHTML = '<span class="text-muted">회차 수와 시작시간을 입력하세요</span>';
                return;
            }

            var parts = first.split(':');
            var totalMin = parseInt(parts[0]) * 60 + parseInt(parts[1]);
            var html = '';
            for (var i = 1; i <= count; i++) {
                var h = Math.floor(totalMin / 60);
                var m = totalMin % 60;
                html += '<span>' + i + '회차 ' + String(h).padStart(2, '0') + ':' + String(m).padStart(2, '0') + '</span>';
                totalMin += interval;
            }
            preview.innerHTML = html;
        }

        /* === 공통 할인 가져오기 === */
        function importCommonDiscounts() {
            fetch('<c:url value="/selectCommonDiscounts.do"/>')
                .then(function(res) { return res.json(); })
                .then(function(list) {
                    if (!list || list.length === 0) {
                        alert('등록된 공통 할인 템플릿이 없습니다.');
                        return;
                    }
                    var tbody = document.getElementById('discountBody');
                    for (var i = 0; i < list.length; i++) {
                        var d = list[i];
                        var tr = document.createElement('tr');
                        tr.innerHTML =
                            '<td><input type="text" name="discounts[' + discountIdx + '].discountNm" class="form-control form-control-sm" value="' + (d.discountNm || '') + '"/></td>' +
                            '<td><select name="discounts[' + discountIdx + '].discountType" class="form-select form-select-sm">' +
                            '<option value="AMOUNT"' + (d.discountType === 'AMOUNT' ? ' selected' : '') + '>정액</option>' +
                            '<option value="PERCENT"' + (d.discountType === 'PERCENT' ? ' selected' : '') + '>정률(%)</option></select></td>' +
                            '<td><input type="number" name="discounts[' + discountIdx + '].discountValue" class="form-control form-control-sm" value="' + (d.discountValue || 0) + '" style="text-align:right"/></td>' +
                            '<td class="text-center"><input type="checkbox" name="discounts[' + discountIdx + '].verifyRequired" value="Y" class="form-check-input"/></td>' +
                            '<td class="text-center"><button type="button" class="btn btn-outline-danger btn-del-row" onclick="removeRow(this)">X</button></td>';
                        tbody.appendChild(tr);
                        discountIdx++;
                    }
                });
        }
        //-->
    </script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />
<form:form modelAttribute="programVO" id="detailForm" name="detailForm">
    <div id="content_pop">
        <!-- 타이틀 -->
        <div id="title">
            <ul>
                <li><img src="<c:url value='/images/ftk/title_dot.gif'/>" alt=""/>
                    <c:if test="${registerFlag == 'create'}">프로그램 등록</c:if>
                    <c:if test="${registerFlag == 'modify'}">프로그램 수정</c:if>
                </li>
            </ul>
        </div>

        <!-- ========== 기본 정보 ========== -->
        <div class="section-title">기본 정보</div>
        <div id="table" class="table-responsive">
            <table class="table" style="border-top:2px solid #C2D0DB; border-collapse:collapse;">
                <colgroup>
                    <col width="150"/>
                    <col width="*"/>
                </colgroup>
                <c:if test="${registerFlag == 'modify'}">
                    <tr>
                        <td class="tbtd_caption"><label for="programId">프로그램ID</label></td>
                        <td class="tbtd_content">
                            <form:input path="programId" cssClass="essentiality" maxlength="16" readonly="true" />
                        </td>
                    </tr>
                </c:if>
                <tr>
                    <td class="tbtd_caption"><label for="programNm">프로그램명</label></td>
                    <td class="tbtd_content">
                        <form:input path="programNm" cssClass="txt" maxlength="200" />
                    </td>
                </tr>
                <form:hidden path="programType" value="SESSION" />
                <tr>
                    <td class="tbtd_caption"><label for="venueId">장소/시설</label></td>
                    <td class="tbtd_content">
                        <select name="venueId" id="venueId" class="use">
                            <option value="">-- 장소/시설 선택 --</option>
                            <c:forEach var="venue" items="${venueList}">
                                <option value="${venue.venueId}"
                                    <c:if test="${programVO.venueId == venue.venueId}">selected</c:if>>
                                    <c:out value="${venue.venueNm}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="description">설명</label></td>
                    <td class="tbtd_content">
                        <form:textarea path="description" rows="3" cols="58" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="ageLimit">연령제한</label></td>
                    <td class="tbtd_content">
                        <form:input path="ageLimit" cssClass="txt" maxlength="50" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="runningTime">공연시간 (분)</label></td>
                    <td class="tbtd_content">
                        <form:input path="runningTime" cssClass="txt" maxlength="5" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="startDate">시작일</label></td>
                    <td class="tbtd_content">
                        <form:input path="startDate" cssClass="txt" maxlength="10" placeholder="YYYY-MM-DD" style="width:140px;display:inline" />
                        <span> ~ </span>
                        <form:input path="endDate" cssClass="txt" maxlength="10" placeholder="YYYY-MM-DD" style="width:140px;display:inline" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="openTime">운영시간</label></td>
                    <td class="tbtd_content">
                        <form:input path="openTime" cssClass="txt" maxlength="5" placeholder="HH:mm" style="width:80px;display:inline" />
                        <span> ~ </span>
                        <form:input path="closeTime" cssClass="txt" maxlength="5" placeholder="HH:mm" style="width:80px;display:inline" />
                        <span class="text-muted" style="margin-left:8px;font-size:12px">비워두면 기본 영업시간 적용</span>
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="useYn">사용여부</label></td>
                    <td class="tbtd_content">
                        <form:select path="useYn" cssClass="use">
                            <form:option value="Y" label="사용" />
                            <form:option value="N" label="미사용" />
                        </form:select>
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="regUser">등록자</label></td>
                    <td class="tbtd_content">
                        <c:if test="${registerFlag == 'modify'}">
                            <form:input path="regUser" cssClass="essentiality" maxlength="10" readonly="true" />
                        </c:if>
                        <c:if test="${registerFlag != 'modify'}">
                            <form:input path="regUser" cssClass="txt" maxlength="10" />
                        </c:if>
                    </td>
                </tr>
            </table>
        </div>

        <!-- ========== 권종 및 기본가격 ========== -->
        <div class="section-title">권종 및 기본가격</div>
        <div class="table-responsive" style="margin-bottom:10px;">
            <table class="inline-table">
                <thead>
                    <tr>
                        <th style="width:25%">권종명</th>
                        <th style="width:15%"><label style="cursor:pointer;margin:0"><input type="checkbox" class="form-check-input" id="chkWeekday" checked onchange="toggleDayCol(0, this.checked)"/> 평일</label></th>
                        <th style="width:15%"><label style="cursor:pointer;margin:0"><input type="checkbox" class="form-check-input" id="chkSat" checked onchange="toggleDayCol(1, this.checked)"/> 토요일</label></th>
                        <th style="width:15%"><label style="cursor:pointer;margin:0"><input type="checkbox" class="form-check-input" id="chkSun" checked onchange="toggleDayCol(2, this.checked)"/> 일요일</label></th>
                        <th style="width:15%"><label style="cursor:pointer;margin:0"><input type="checkbox" class="form-check-input" id="chkHol" checked onchange="toggleDayCol(3, this.checked)"/> 공휴일</label></th>
                        <th style="width:15%"></th>
                    </tr>
                </thead>
                <tbody id="ticketTypeBody">
                    <c:forEach var="tt" items="${programVO.ticketTypes}" varStatus="st">
                        <tr>
                            <td>
                                <select name="ticketTypes[${st.index}].typeId" class="form-select form-select-sm" onchange="refreshTypeOptions()">
                                    <option value="">-- 선택 --</option>
                                    <c:forEach var="allTt" items="${ticketTypeList}">
                                        <option value="${allTt.typeId}" <c:if test="${tt.typeId == allTt.typeId}">selected</c:if>><c:out value="${allTt.typeNm}"/></option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td data-col="0"><input type="number" name="ticketTypes[${st.index}].basePrice" class="form-control form-control-sm" value="${tt.basePrice}" min="0" style="text-align:right"/></td>
                            <td data-col="1"><input type="number" name="ticketTypes[${st.index}].satPrice" class="form-control form-control-sm" value="${tt.satPrice}" min="0" style="text-align:right"/></td>
                            <td data-col="2"><input type="number" name="ticketTypes[${st.index}].sunPrice" class="form-control form-control-sm" value="${tt.sunPrice}" min="0" style="text-align:right"/></td>
                            <td data-col="3"><input type="number" name="ticketTypes[${st.index}].holPrice" class="form-control form-control-sm" value="${tt.holPrice}" min="0" style="text-align:right"/></td>
                            <td class="text-center"><button type="button" class="btn btn-outline-danger btn-del-row" onclick="removeRow(this)">X</button></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div style="margin-top:6px;">
                <button type="button" class="btn btn-outline-primary btn-sm btn-add-row" onclick="addTicketTypeRow()">+ 권종 추가</button>
            </div>
        </div>

        <!-- ========== 회차 설정 ========== -->
        <div class="section-title">회차 설정</div>
        <div class="table-responsive" style="margin-bottom:10px;">
            <table class="table" style="border-top:2px solid #C2D0DB; border-collapse:collapse;">
                <colgroup>
                    <col width="150"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="tbtd_caption"><label for="firstSessionTime">첫 회차 시작</label></td>
                    <td class="tbtd_content">
                        <form:input path="firstSessionTime" id="firstSessionTime" cssClass="txt" maxlength="5" placeholder="HH:mm" style="width:80px;display:inline" onchange="updateSessionPreview()" onkeyup="updateSessionPreview()" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="sessionCount">회차 수</label></td>
                    <td class="tbtd_content">
                        <form:input path="sessionCount" id="sessionCount" cssClass="txt" maxlength="3" style="width:60px;display:inline" onchange="updateSessionPreview()" onkeyup="updateSessionPreview()" />
                        <span class="text-muted" style="margin-left:8px;font-size:12px">회</span>
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption"><label for="sessionInterval">회차 간격</label></td>
                    <td class="tbtd_content">
                        <form:input path="sessionInterval" id="sessionInterval" cssClass="txt" maxlength="4" style="width:80px;display:inline" onchange="updateSessionPreview()" onkeyup="updateSessionPreview()" />
                        <span class="text-muted" style="margin-left:8px;font-size:12px">분 (공연시간+휴식 포함)</span>
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption">정원</td>
                    <td class="tbtd_content">
                        <span style="font-size:13px">온라인</span>
                        <form:input path="defaultOnlineCap" cssClass="txt" maxlength="5" style="width:70px;display:inline;text-align:right" />
                        <span style="font-size:13px;margin-left:15px">오프라인</span>
                        <form:input path="defaultOfflineCap" cssClass="txt" maxlength="5" style="width:70px;display:inline;text-align:right" />
                    </td>
                </tr>
                <tr>
                    <td class="tbtd_caption">미리보기</td>
                    <td class="tbtd_content">
                        <div id="sessionPreview" class="session-preview">
                            <span class="text-muted">회차 수와 시작시간을 입력하세요</span>
                        </div>
                    </td>
                </tr>
            </table>
        </div>

        <!-- ========== 가격 템플릿 ========== -->
        <div class="section-title">가격 템플릿
            <button type="button" class="btn btn-outline-primary btn-sm" style="margin-left:10px;font-size:11px;padding:1px 10px" onclick="generateTemplate()">템플릿 생성</button>
        </div>
        <div id="templateSection" style="display:none; margin-bottom:10px;">
            <div style="margin-bottom:8px;">
                <button type="button" class="btn btn-sm btn-outline-warning" onclick="scrollToGroup('weekday')">평일 (월~금)</button>
                <button type="button" class="btn btn-sm btn-outline-primary" onclick="scrollToGroup('weekend')">주말 (토~일)</button>
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="scrollToGroup('holiday')">공휴일</button>
            </div>
            <div id="templateScrollWrapper" style="overflow-x:auto; max-width:100%; border:1px solid #dee2e6; border-radius:4px;">
                <div id="templateGrid"></div>
            </div>
        </div>
        <input type="hidden" name="templateJson" id="templateJson" />

        <!-- ========== 할인 설정 ========== -->
        <div class="section-title">할인 설정
            <span style="font-size:12px;color:#6c757d;font-weight:normal;margin-left:10px">중복적용 불가, 최대 할인 자동 적용</span>
        </div>
        <div class="table-responsive" style="margin-bottom:10px;">
            <table class="inline-table">
                <thead>
                    <tr>
                        <th style="width:25%">할인명</th>
                        <th style="width:12%">유형</th>
                        <th style="width:15%">할인값</th>
                        <th style="width:10%">확인필요</th>
                        <th style="width:20%">확인항목</th>
                        <th style="width:18%"></th>
                    </tr>
                </thead>
                <tbody id="discountBody">
                    <c:forEach var="dc" items="${programVO.discounts}" varStatus="st">
                        <tr>
                            <td><input type="text" name="discounts[${st.index}].discountNm" class="form-control form-control-sm" value="<c:out value='${dc.discountNm}'/>"/></td>
                            <td>
                                <select name="discounts[${st.index}].discountType" class="form-select form-select-sm">
                                    <option value="AMOUNT" <c:if test="${dc.discountType == 'AMOUNT'}">selected</c:if>>정액</option>
                                    <option value="PERCENT" <c:if test="${dc.discountType == 'PERCENT'}">selected</c:if>>정률(%)</option>
                                </select>
                            </td>
                            <td><input type="number" name="discounts[${st.index}].discountValue" class="form-control form-control-sm" value="${dc.discountValue}" min="0" style="text-align:right"/></td>
                            <td class="text-center"><input type="checkbox" name="discounts[${st.index}].verifyRequired" value="Y" class="form-check-input dc-verify-chk" <c:if test="${dc.verifyRequired == 'Y'}">checked</c:if> onchange="toggleVerifyItem(this)"/></td>
                            <td><input type="text" name="discounts[${st.index}].verifyItem" class="form-control form-control-sm dc-verify-item" value="<c:out value='${dc.verifyItem}'/>" placeholder="예: 신분증" <c:if test="${dc.verifyRequired != 'Y'}">disabled style="opacity:0.4"</c:if>/></td>
                            <td class="text-center"><button type="button" class="btn btn-outline-danger btn-del-row" onclick="removeRow(this)">X</button></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div style="margin-top:6px;">
                <button type="button" class="btn btn-outline-primary btn-sm btn-add-row" onclick="addDiscountRow()">+ 할인 추가</button>
                <button type="button" class="btn btn-outline-secondary btn-sm btn-add-row" onclick="importCommonDiscounts()" style="margin-left:5px">공통할인에서 가져오기</button>
            </div>
        </div>

        <!-- 버튼 -->
        <div id="sysbtn">
            <a class="btn btn-outline-secondary btn-sm" href="javascript:fn_egov_selectList();">목록</a>
            <a class="btn btn-primary btn-sm" href="javascript:fn_egov_save();">
                <c:if test="${registerFlag == 'create'}">등록</c:if>
                <c:if test="${registerFlag == 'modify'}">수정</c:if>
            </a>
            <c:if test="${registerFlag == 'modify'}">
                <a class="btn btn-danger btn-sm" href="javascript:fn_egov_delete();">삭제</a>
            </c:if>
            <a class="btn btn-outline-secondary btn-sm" href="javascript:document.detailForm.reset();">초기화</a>
        </div>
    </div>
    <!-- 검색조건 유지 -->
    <input type="hidden" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
    <input type="hidden" name="searchKeyword"   value="<c:out value='${searchVO.searchKeyword}'/>"/>
    <input type="hidden" name="pageIndex"       value="<c:out value='${searchVO.pageIndex}'/>"/>
</form:form>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        updateSessionPreview();
        initDayColChecks();
        initPriceAutoFill();
        refreshTypeOptions();

        // 회차 설정 변경 시 자동 업데이트
        ['sessionCount', 'firstSessionTime', 'sessionInterval', 'defaultOnlineCap', 'defaultOfflineCap'].forEach(function(id) {
            var el = document.getElementById(id);
            if (el) {
                el.addEventListener('change', function() { autoUpdateTemplate(); });
            }
        });

        // 권종 기본가격 변경 시 자동 업데이트 (이벤트 위임)
        document.getElementById('ticketTypeBody').addEventListener('change', function(e) {
            if (e.target.tagName === 'SELECT' || e.target.type === 'number') {
                autoUpdateTemplate();
            }
        });

        // 수정 모드: 기존 템플릿 로드
        <c:if test="${not empty existingTemplateJson}">
        try {
            var rawJson = '<c:out value="${existingTemplateJson}" escapeXml="false"/>';
            templateData = JSON.parse(rawJson);
            templateData = migrateWeekendData(templateData);
            if (templateData && templateData.sessions && templateData.sessions.length > 0) {
                document.getElementById('templateSection').style.display = 'block';
                renderTemplateGrid();
                syncTemplateJson();
            }
        } catch(e) { console.error('템플릿 로드 실패', e); }
        </c:if>
    });

    /* === 가격 자동채움: 왼쪽 열 값을 오른쪽 빈(0) 열에 복사 === */
    function attachPriceAutoFill(tr) {
        var priceTds = []; // data-col 0,1,2,3 순서
        var tds = tr.getElementsByTagName('td');
        for (var i = 0; i < tds.length; i++) {
            if (tds[i].hasAttribute('data-col')) priceTds.push(tds[i]);
        }
        for (var c = 0; c < priceTds.length; c++) {
            var input = priceTds[c].querySelector('input[type="number"]');
            if (input) input.addEventListener('blur', (function(colIdx, tdsRef) {
                return function() {
                    var val = parseInt(this.value) || 0;
                    if (val <= 0) return;
                    for (var nc = colIdx + 1; nc < tdsRef.length; nc++) {
                        var nextInput = tdsRef[nc].querySelector('input[type="number"]');
                        if (nextInput && !nextInput.disabled && (!nextInput.value || parseInt(nextInput.value) === 0)) {
                            nextInput.value = val;
                        }
                    }
                };
            })(c, priceTds));
        }
    }

    function initPriceAutoFill() {
        var tbody = document.getElementById('ticketTypeBody');
        var rows = tbody.getElementsByTagName('tr');
        for (var i = 0; i < rows.length; i++) attachPriceAutoFill(rows[i]);
    }

    /* === 가격 템플릿 === */
    var templateData = null;
    var TPL_DAY_TYPES = ['WEEKDAY', 'SATURDAY', 'SUNDAY', 'HOLIDAY'];
    var ALL_DAYS = [
        {key:'WEEKDAY',  label:'월', group:'weekday'},
        {key:'WEEKDAY',  label:'화', group:'weekday'},
        {key:'WEEKDAY',  label:'수', group:'weekday'},
        {key:'WEEKDAY',  label:'목', group:'weekday'},
        {key:'WEEKDAY',  label:'금', group:'weekday'},
        {key:'SATURDAY', label:'토', group:'weekend'},
        {key:'SUNDAY',   label:'일', group:'sunday'},
        {key:'HOLIDAY',  label:'공휴일', group:'holiday'}
    ];
    var GROUP_COLORS = {weekday:'#fff3e0', weekend:'#e8f0fe', sunday:'#fce4ec', holiday:'#fce4ec'};
    var CELL_COLORS  = {weekday:'#fffaf0', weekend:'#f8fbff', sunday:'#fff5f5', holiday:'#fff5f5'};

    function scrollToGroup(group) {
        var wrapper = document.getElementById('templateScrollWrapper');
        var th = wrapper.querySelector('th[data-group="' + group + '"]');
        if (th) {
            // 첫 2열(회차/항목) 너비만큼 보정
            var stickyWidth = 145;
            wrapper.scrollTo({left: th.offsetLeft - stickyWidth, behavior: 'smooth'});
        }
    }

    /* 권종+기본가격 섹션에서 현재 입력된 권종 목록 읽기 */
    function readTicketTypesFromForm() {
        var tbody = document.getElementById('ticketTypeBody');
        var rows = tbody.getElementsByTagName('tr');
        var ticketTypes = [];
        for (var i = 0; i < rows.length; i++) {
            var sel = rows[i].querySelector('select');
            if (sel && sel.value) {
                var tds = rows[i].getElementsByTagName('td');
                ticketTypes.push({
                    typeId: sel.value,
                    typeNm: sel.options[sel.selectedIndex].text,
                    basePrice: parseInt((tds[1] && tds[1].querySelector('input')) ? tds[1].querySelector('input').value : 0) || 0,
                    satPrice:  parseInt((tds[2] && tds[2].querySelector('input')) ? tds[2].querySelector('input').value : 0) || 0,
                    sunPrice:  parseInt((tds[3] && tds[3].querySelector('input')) ? tds[3].querySelector('input').value : 0) || 0,
                    holPrice:  parseInt((tds[4] && tds[4].querySelector('input')) ? tds[4].querySelector('input').value : 0) || 0
                });
            }
        }
        return ticketTypes;
    }

    /* 회차 설정에서 현재 세션 목록 계산 */
    function readSessionsFromForm() {
        var count = parseInt(document.getElementById('sessionCount').value) || 0;
        var first = document.getElementById('firstSessionTime').value || '';
        var interval = parseInt(document.getElementById('sessionInterval').value) || 0;
        if (count <= 0 || first.indexOf(':') < 0) return [];

        var timeParts = first.split(':');
        var totalMin = parseInt(timeParts[0]) * 60 + parseInt(timeParts[1]);
        var sessions = [];
        for (var s = 1; s <= count; s++) {
            var h = Math.floor(totalMin / 60), m = totalMin % 60;
            sessions.push({no: s, time: String(h).padStart(2,'0') + ':' + String(m).padStart(2,'0')});
            totalMin += interval;
        }
        return sessions;
    }

    function getDefaultPrice(dt, tt) {
        if (dt === 'SATURDAY') return tt.satPrice;
        if (dt === 'SUNDAY') return tt.sunPrice;
        if (dt === 'HOLIDAY') return tt.holPrice;
        return tt.basePrice;
    }

    function generateTemplate() {
        var sessions = readSessionsFromForm();
        if (sessions.length === 0) { alert('회차 수와 시작시간을 먼저 입력하세요.'); return; }

        var ticketTypes = readTicketTypesFromForm();
        if (ticketTypes.length === 0) { alert('권종을 추가하세요.'); return; }

        var onlineCap = parseInt(document.getElementById('defaultOnlineCap').value) || 0;
        var offlineCap = parseInt(document.getElementById('defaultOfflineCap').value) || 0;

        if (templateData && templateData.sessions && templateData.sessions.length > 0) {
            if (!confirm('기존 템플릿을 덮어쓰시겠습니까?')) return;
        }

        templateData = {sessions: sessions, ticketTypes: ticketTypes, data: {}};
        for (var d = 0; d < TPL_DAY_TYPES.length; d++) {
            var dt = TPL_DAY_TYPES[d];
            templateData.data[dt] = {};
            for (var si = 0; si < sessions.length; si++) {
                var entry = {enabled: 'Y', types: {}, onlineCap: onlineCap, offlineCap: offlineCap};
                for (var t = 0; t < ticketTypes.length; t++) {
                    entry.types[ticketTypes[t].typeId] = getDefaultPrice(dt, ticketTypes[t]);
                }
                templateData.data[dt][sessions[si].no] = entry;
            }
        }

        document.getElementById('templateSection').style.display = 'block';
        renderTemplateGrid();
        syncTemplateJson();
    }

    /* 템플릿 자동 업데이트: 회차/권종 변경시 기존 데이터 유지하며 반영 */
    function autoUpdateTemplate() {
        if (!templateData) return;

        var sessions = readSessionsFromForm();
        var ticketTypes = readTicketTypesFromForm();
        if (sessions.length === 0 || ticketTypes.length === 0) return;

        var onlineCap = parseInt(document.getElementById('defaultOnlineCap').value) || 0;
        var offlineCap = parseInt(document.getElementById('defaultOfflineCap').value) || 0;

        templateData.sessions = sessions;
        templateData.ticketTypes = ticketTypes;

        for (var d = 0; d < TPL_DAY_TYPES.length; d++) {
            var dt = TPL_DAY_TYPES[d];
            if (!templateData.data[dt]) templateData.data[dt] = {};
            var oldData = templateData.data[dt];
            var newData = {};

            for (var si = 0; si < sessions.length; si++) {
                var sNo = sessions[si].no;
                var oldEntry = oldData[sNo];
                var entry = {enabled: 'Y', types: {}, onlineCap: onlineCap, offlineCap: offlineCap};

                if (oldEntry) {
                    if (oldEntry.enabled !== undefined) entry.enabled = oldEntry.enabled;
                    if (oldEntry.onlineCap !== undefined) entry.onlineCap = oldEntry.onlineCap;
                    if (oldEntry.offlineCap !== undefined) entry.offlineCap = oldEntry.offlineCap;
                }

                for (var t = 0; t < ticketTypes.length; t++) {
                    var tt = ticketTypes[t];
                    if (oldEntry && oldEntry.types && oldEntry.types[tt.typeId] !== undefined) {
                        entry.types[tt.typeId] = oldEntry.types[tt.typeId];
                    } else {
                        entry.types[tt.typeId] = getDefaultPrice(dt, tt);
                    }
                }
                newData[sNo] = entry;
            }
            templateData.data[dt] = newData;
        }
        renderTemplateGrid();
        syncTemplateJson();
    }

    function fmtComma(n) { return n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','); }
    function stripComma(s) { return parseInt(String(s).replace(/,/g, '')) || 0; }
    var INPUT_STYLE = 'text-align:center;width:76px;padding:2px 4px;font-size:12px';

    function renderTemplateGrid() {
        if (!templateData || !templateData.sessions || templateData.sessions.length === 0) return;
        var sessions = templateData.sessions;
        var types = templateData.ticketTypes;
        var rowsPerSession = types.length + 3; // types + onlineCap + offlineCap + enabled

        var html = '<table class="inline-table" style="min-width:950px;border-collapse:collapse">';
        // header — 항목 colspan=2 (구분 + 세부)
        html += '<thead><tr>';
        html += '<th style="width:65px;position:sticky;left:0;z-index:3;background:#f0f4f8;border-right:2px solid #adb5bd">회차</th>';
        html += '<th colspan="2" style="position:sticky;left:65px;z-index:3;background:#f0f4f8;border-right:1px solid #dee2e6">항목</th>';
        for (var di = 0; di < ALL_DAYS.length; di++) {
            var day = ALL_DAYS[di];
            html += '<th data-group="' + day.group + '" style="min-width:80px;background:' + GROUP_COLORS[day.group] + '">'
                + day.label + '<br><input type="checkbox" class="form-check-input tpl-day-all" data-di="' + di + '" data-daykey="' + day.key + '" checked style="margin-top:2px"/></th>';
        }
        html += '</tr></thead><tbody>';

        for (var s = 0; s < sessions.length; s++) {
            var sNo = sessions[s].no;

            // ticket type price rows
            for (var t = 0; t < types.length; t++) {
                html += '<tr>';
                if (t === 0) {
                    html += '<td rowspan="' + rowsPerSession + '" class="text-center" style="position:sticky;left:0;background:#fff;z-index:2;font-weight:600;border-right:2px solid #adb5bd;vertical-align:middle">'
                        + sNo + '회차<br><small style="color:#6c757d">' + sessions[s].time + '</small></td>';
                }
                html += '<td colspan="2" style="position:sticky;left:65px;background:#fff;z-index:2;font-size:12px;white-space:nowrap;border-right:1px solid #dee2e6">' + types[t].typeNm + '</td>';
                for (var di = 0; di < ALL_DAYS.length; di++) {
                    var dayKey = ALL_DAYS[di].key;
                    var entry = templateData.data[dayKey] && templateData.data[dayKey][sNo];
                    var price = (entry && entry.types && entry.types[types[t].typeId] !== undefined) ? entry.types[types[t].typeId] : 0;
                    html += '<td class="text-center" style="background:' + CELL_COLORS[ALL_DAYS[di].group] + '"><input type="text" class="form-control form-control-sm tpl-price" '
                        + 'value="' + fmtComma(price) + '" style="' + INPUT_STYLE + '" '
                        + 'data-sno="' + sNo + '" data-tid="' + types[t].typeId + '" data-daykey="' + dayKey + '" data-di="' + di + '"/></td>';
                }
                html += '</tr>';
            }

            // onlineCap row (with 정원 rowspan=2 vertical header)
            html += '<tr style="border-top:1px dashed #adb5bd">';
            html += '<td rowspan="2" style="position:sticky;left:65px;background:#f8f9fa;z-index:2;writing-mode:vertical-rl;text-orientation:mixed;text-align:center;font-size:11px;font-weight:600;color:#495057;letter-spacing:2px;width:28px;padding:4px 2px">정원</td>';
            html += '<td style="position:sticky;left:93px;background:#fff;z-index:2;font-size:12px;color:#0d6efd;border-right:1px solid #dee2e6;white-space:nowrap">온라인</td>';
            for (var di = 0; di < ALL_DAYS.length; di++) {
                var dayKey = ALL_DAYS[di].key;
                var entry = templateData.data[dayKey] && templateData.data[dayKey][sNo];
                var val = entry ? (entry.onlineCap || 0) : 0;
                html += '<td class="text-center" style="background:' + CELL_COLORS[ALL_DAYS[di].group] + '"><input type="text" class="form-control form-control-sm tpl-cap" '
                    + 'value="' + fmtComma(val) + '" style="' + INPUT_STYLE + '" '
                    + 'data-sno="' + sNo + '" data-field="onlineCap" data-daykey="' + dayKey + '" data-di="' + di + '"/></td>';
            }
            html += '</tr>';

            // offlineCap row (정원 rowspan continues)
            html += '<tr>';
            html += '<td style="position:sticky;left:93px;background:#fff;z-index:2;font-size:12px;color:#198754;border-right:1px solid #dee2e6;white-space:nowrap">오프라인</td>';
            for (var di = 0; di < ALL_DAYS.length; di++) {
                var dayKey = ALL_DAYS[di].key;
                var entry = templateData.data[dayKey] && templateData.data[dayKey][sNo];
                var val = entry ? (entry.offlineCap || 0) : 0;
                html += '<td class="text-center" style="background:' + CELL_COLORS[ALL_DAYS[di].group] + '"><input type="text" class="form-control form-control-sm tpl-cap" '
                    + 'value="' + fmtComma(val) + '" style="' + INPUT_STYLE + '" '
                    + 'data-sno="' + sNo + '" data-field="offlineCap" data-daykey="' + dayKey + '" data-di="' + di + '"/></td>';
            }
            html += '</tr>';

            // enabled row
            html += '<tr style="border-bottom:3px solid #6c757d">';
            html += '<td colspan="2" style="position:sticky;left:65px;background:#fff;z-index:2;font-size:12px;color:#dc3545;border-right:1px solid #dee2e6;white-space:nowrap">'
                + '활성 <input type="checkbox" class="form-check-input tpl-row-all" data-sno="' + sNo + '" checked style="margin-left:4px;vertical-align:middle"/></td>';
            for (var di = 0; di < ALL_DAYS.length; di++) {
                var dayKey = ALL_DAYS[di].key;
                var entry = templateData.data[dayKey] && templateData.data[dayKey][sNo];
                var chk = (!entry || entry.enabled === 'Y') ? ' checked' : '';
                html += '<td class="text-center" style="background:' + CELL_COLORS[ALL_DAYS[di].group] + '"><input type="checkbox" class="form-check-input tpl-enabled"'
                    + chk + ' data-sno="' + sNo + '" data-daykey="' + dayKey + '" data-di="' + di + '"/></td>';
            }
            html += '</tr>';
        }

        html += '</tbody></table>';
        document.getElementById('templateGrid').innerHTML = html;

        // 이벤트 위임: change + focus/blur for comma formatting
        // 헤더 전체 체크박스 초기 상태 반영
        updateAllDayChecks();
        updateAllRowChecks();

        var grid = document.getElementById('templateGrid');
        grid.onchange = function(e) {
            var el = e.target;
            if (el.classList.contains('tpl-price')) { onTplPriceChange(el); }
            else if (el.classList.contains('tpl-cap')) { onTplCapChange(el); }
            else if (el.classList.contains('tpl-enabled')) { onTplEnabledChange(el); updateAllDayChecks(); updateAllRowChecks(); }
            else if (el.classList.contains('tpl-day-all')) { onTplDayAllChange(el); }
            else if (el.classList.contains('tpl-row-all')) { onTplRowAllChange(el); }
        };
        grid.addEventListener('focus', function(e) {
            var el = e.target;
            if (el.classList.contains('tpl-price') || el.classList.contains('tpl-cap')) {
                el.value = String(stripComma(el.value));
                el.select();
            }
        }, true);
        grid.addEventListener('blur', function(e) {
            var el = e.target;
            if (el.classList.contains('tpl-price') || el.classList.contains('tpl-cap')) {
                el.value = fmtComma(stripComma(el.value));
            }
        }, true);
    }

    function syncWeekdayCells(selector, attr, val) {
        var cells = document.querySelectorAll(selector + '[data-daykey="WEEKDAY"]');
        for (var i = 0; i < cells.length; i++) {
            if (attr === 'checked') cells[i].checked = val;
            else cells[i].value = val;
        }
    }

    function onTplPriceChange(el) {
        var sNo = el.getAttribute('data-sno');
        var tid = el.getAttribute('data-tid');
        var dayKey = el.getAttribute('data-daykey');
        var val = stripComma(el.value);
        templateData.data[dayKey][sNo].types[tid] = val;
        if (dayKey === 'WEEKDAY') {
            syncWeekdayCells('.tpl-price[data-sno="' + sNo + '"][data-tid="' + tid + '"]', 'value', fmtComma(val));
        }
        syncTemplateJson();
    }

    function onTplCapChange(el) {
        var sNo = el.getAttribute('data-sno');
        var field = el.getAttribute('data-field');
        var dayKey = el.getAttribute('data-daykey');
        var val = stripComma(el.value);
        templateData.data[dayKey][sNo][field] = val;
        if (dayKey === 'WEEKDAY') {
            syncWeekdayCells('.tpl-cap[data-sno="' + sNo + '"][data-field="' + field + '"]', 'value', fmtComma(val));
        }
        syncTemplateJson();
    }

    function onTplEnabledChange(el) {
        var sNo = el.getAttribute('data-sno');
        var dayKey = el.getAttribute('data-daykey');
        templateData.data[dayKey][sNo].enabled = el.checked ? 'Y' : 'N';
        if (dayKey === 'WEEKDAY') {
            syncWeekdayCells('.tpl-enabled[data-sno="' + sNo + '"]', 'checked', el.checked);
        }
        syncTemplateJson();
    }

    /* 세로 전체: 요일 헤더 체크박스 → 해당 열의 모든 회차 활성 토글 */
    function onTplDayAllChange(el) {
        var di = el.getAttribute('data-di');
        var dayKey = el.getAttribute('data-daykey');
        var checked = el.checked;
        var cells = document.querySelectorAll('.tpl-enabled[data-di="' + di + '"]');
        for (var i = 0; i < cells.length; i++) {
            cells[i].checked = checked;
            var sNo = cells[i].getAttribute('data-sno');
            templateData.data[dayKey][sNo].enabled = checked ? 'Y' : 'N';
        }
        // WEEKDAY 동기화: 한 평일 열 전체 토글 시 나머지 평일 열도 동기화
        if (dayKey === 'WEEKDAY') {
            var wkCells = document.querySelectorAll('.tpl-enabled[data-daykey="WEEKDAY"]');
            for (var i = 0; i < wkCells.length; i++) wkCells[i].checked = checked;
            var wkHeaders = document.querySelectorAll('.tpl-day-all[data-daykey="WEEKDAY"]');
            for (var i = 0; i < wkHeaders.length; i++) wkHeaders[i].checked = checked;
        }
        updateAllRowChecks();
        syncTemplateJson();
    }

    /* 가로 전체: 활성 행 체크박스 → 해당 회차의 모든 요일 활성 토글 */
    function onTplRowAllChange(el) {
        var sNo = el.getAttribute('data-sno');
        var checked = el.checked;
        var cells = document.querySelectorAll('.tpl-enabled[data-sno="' + sNo + '"]');
        for (var i = 0; i < cells.length; i++) {
            cells[i].checked = checked;
            var dayKey = cells[i].getAttribute('data-daykey');
            templateData.data[dayKey][sNo].enabled = checked ? 'Y' : 'N';
        }
        updateAllDayChecks();
        syncTemplateJson();
    }

    /* 개별 체크 변경 시 전체 체크박스 상태 동기화 */
    function updateAllDayChecks() {
        for (var di = 0; di < ALL_DAYS.length; di++) {
            var cells = document.querySelectorAll('.tpl-enabled[data-di="' + di + '"]');
            var allChecked = true;
            for (var i = 0; i < cells.length; i++) { if (!cells[i].checked) { allChecked = false; break; } }
            var hdr = document.querySelector('.tpl-day-all[data-di="' + di + '"]');
            if (hdr) hdr.checked = allChecked;
        }
    }

    function updateAllRowChecks() {
        var rowAlls = document.querySelectorAll('.tpl-row-all');
        for (var r = 0; r < rowAlls.length; r++) {
            var sNo = rowAlls[r].getAttribute('data-sno');
            var cells = document.querySelectorAll('.tpl-enabled[data-sno="' + sNo + '"]');
            var allChecked = true;
            for (var i = 0; i < cells.length; i++) { if (!cells[i].checked) { allChecked = false; break; } }
            rowAlls[r].checked = allChecked;
        }
    }

    function syncTemplateJson() {
        document.getElementById('templateJson').value = JSON.stringify(templateData);
    }

    /* 레거시 WEEKEND 데이터 → SATURDAY + SUNDAY 변환 */
    function migrateWeekendData(data) {
        if (data && data.data && data.data['WEEKEND']) {
            if (!data.data['SATURDAY']) data.data['SATURDAY'] = data.data['WEEKEND'];
            if (!data.data['SUNDAY']) data.data['SUNDAY'] = JSON.parse(JSON.stringify(data.data['WEEKEND']));
            delete data.data['WEEKEND'];
        }
        return data;
    }

    function initDayColChecks() {
        var tbody = document.getElementById('ticketTypeBody');
        var rows = tbody.getElementsByTagName('tr');
        if (rows.length === 0) return;
        for (var c = 0; c < dayColChecks.length; c++) {
            var allZero = true;
            for (var r = 0; r < rows.length; r++) {
                var tds = rows[r].getElementsByTagName('td');
                var td = tds[c + 1];
                if (td) {
                    var input = td.querySelector('input[type="number"]');
                    if (input && parseInt(input.value) > 0) { allZero = false; break; }
                }
            }
            if (allZero && rows.length > 0) {
                var chk = document.getElementById(dayColChecks[c]);
                if (c === 0) continue;
                if (chk) { chk.checked = false; toggleDayCol(c, false); }
            }
        }
    }
</script>
</body>
</html>
