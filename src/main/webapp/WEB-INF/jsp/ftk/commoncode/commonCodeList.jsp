<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>공통코드 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=7"/>
    <style>
    .cc-wrap { display:flex; gap:16px; align-items:flex-start; }
    .cc-panel { flex:1; min-width:0; background:#fff; border:1px solid #e2e8f0; border-radius:10px; display:flex; flex-direction:column; }
    .cc-head {
        padding:12px 16px; font-weight:700; font-size:13.5px; color:#1a202c;
        border-bottom:1px solid #e2e8f0; background:#f8fafc; border-radius:10px 10px 0 0;
        display:flex; align-items:center; justify-content:space-between; flex-shrink:0;
    }
    .cc-head .badge { font-size:11px; font-weight:600; padding:3px 8px; }
    .cc-body { flex:1; overflow-y:auto; padding:0; }
    .cc-list { list-style:none; margin:0; padding:6px 0; }
    .cc-list li {
        padding:9px 16px; cursor:pointer; font-size:13px; color:#4a5568;
        border-left:3px solid transparent; transition:all .12s;
        display:flex; align-items:center; justify-content:space-between;
    }
    .cc-list li:hover { background:#f1f5f9; }
    .cc-list li.active { background:#ebf5ff; color:#2563eb; border-left-color:#2563eb; font-weight:600; }
    .cc-list li .code-val { font-size:11px; color:#94a3b8; font-weight:400; }
    .cc-list li.active .code-val { color:#60a5fa; }
    .cc-list li .use-n { opacity:.4; text-decoration:line-through; }

    .cc-search {
        padding:8px 10px; border-bottom:1px solid #e2e8f0; flex-shrink:0;
    }
    .cc-search input {
        width:100%; border:1px solid #e2e8f0; border-radius:6px; padding:5px 10px;
        font-size:12px; outline:none; transition:border-color .15s;
    }
    .cc-search input:focus { border-color:#2563eb; }
    .cc-search input::placeholder { color:#b0b8c4; }

    .cc-empty { text-align:center; padding:48px 16px; color:#94a3b8; font-size:13px; }
    .cc-empty svg { margin-bottom:8px; }

    /* 입력 폼 */
    .cc-form { padding:14px 16px; border-top:1px solid #e2e8f0; background:#fafbfc; flex-shrink:0; }
    .cc-form .form-label { font-size:12px; font-weight:600; color:#475569; margin-bottom:3px; }
    .cc-form .form-control, .cc-form .form-select { font-size:13px; }
    .cc-form .btn-row { display:flex; gap:6px; margin-top:10px; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />

<div id="content_pop">

    <div class="cc-wrap">
        <!-- 1뎁스: 카테고리 -->
        <div class="cc-panel">
            <div class="cc-head">
                카테고리
                <button type="button" class="btn btn-primary btn-sm" onclick="showForm(1)" style="font-size:12px;padding:2px 10px;">추가</button>
            </div>
            <div class="cc-search"><input type="text" id="search1" placeholder="카테고리 검색..." oninput="filterList(1)"/></div>
            <div class="cc-body">
                <ul class="cc-list" id="list1"></ul>
                <div class="cc-empty" id="empty1">
                    <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/></svg>
                    <p>카테고리을 추가하세요.</p>
                </div>
            </div>
            <div class="cc-form" id="form1" style="display:none;">
                <input type="hidden" id="f1_codeId"/>
                <div class="mb-2">
                    <label class="form-label">코드명</label>
                    <input type="text" class="form-control form-control-sm" id="f1_codeNm" placeholder="카테고리명"/>
                </div>
                <div class="mb-2">
                    <label class="form-label">코드값</label>
                    <input type="text" class="form-control form-control-sm" id="f1_codeValue" placeholder="코드값 (영문)"/>
                </div>
                <div class="mb-2">
                    <label class="form-label">설명</label>
                    <input type="text" class="form-control form-control-sm" id="f1_desc" placeholder="설명"/>
                </div>
                <div class="row g-2 mb-2">
                    <div class="col">
                        <label class="form-label">정렬</label>
                        <input type="number" class="form-control form-control-sm" id="f1_sort" value="0"/>
                    </div>
                    <div class="col">
                        <label class="form-label">사용</label>
                        <select class="form-select form-select-sm" id="f1_useYn">
                            <option value="Y">Y</option><option value="N">N</option>
                        </select>
                    </div>
                </div>
                <div class="btn-row">
                    <button type="button" class="btn btn-primary btn-sm flex-fill" onclick="saveCode(1)">저장</button>
                    <button type="button" class="btn btn-danger btn-sm" id="f1_delBtn" onclick="deleteCode(1)" style="display:none;">삭제</button>
                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="hideForm(1)">취소</button>
                </div>
            </div>
        </div>

        <!-- 2뎁스: 그룹 -->
        <div class="cc-panel">
            <div class="cc-head">
                그룹
                <button type="button" class="btn btn-primary btn-sm" id="addBtn2" onclick="showForm(2)" style="font-size:12px;padding:2px 10px;display:none;">추가</button>
            </div>
            <div class="cc-search"><input type="text" id="search2" placeholder="그룹 검색..." oninput="filterList(2)"/></div>
            <div class="cc-body">
                <ul class="cc-list" id="list2"></ul>
                <div class="cc-empty" id="empty2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><polyline points="9 11 12 14 22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                    <p>카테고리을 선택하세요.</p>
                </div>
            </div>
            <div class="cc-form" id="form2" style="display:none;">
                <input type="hidden" id="f2_codeId"/>
                <div class="mb-2">
                    <label class="form-label">코드명</label>
                    <input type="text" class="form-control form-control-sm" id="f2_codeNm" placeholder="그룹명"/>
                </div>
                <div class="mb-2">
                    <label class="form-label">코드값</label>
                    <input type="text" class="form-control form-control-sm" id="f2_codeValue" placeholder="코드값 (영문)"/>
                </div>
                <div class="mb-2">
                    <label class="form-label">설명</label>
                    <input type="text" class="form-control form-control-sm" id="f2_desc" placeholder="설명"/>
                </div>
                <div class="row g-2 mb-2">
                    <div class="col">
                        <label class="form-label">정렬</label>
                        <input type="number" class="form-control form-control-sm" id="f2_sort" value="0"/>
                    </div>
                    <div class="col">
                        <label class="form-label">사용</label>
                        <select class="form-select form-select-sm" id="f2_useYn">
                            <option value="Y">Y</option><option value="N">N</option>
                        </select>
                    </div>
                </div>
                <div class="btn-row">
                    <button type="button" class="btn btn-primary btn-sm flex-fill" onclick="saveCode(2)">저장</button>
                    <button type="button" class="btn btn-danger btn-sm" id="f2_delBtn" onclick="deleteCode(2)" style="display:none;">삭제</button>
                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="hideForm(2)">취소</button>
                </div>
            </div>
        </div>

        <!-- 3뎁스: 코드 -->
        <div class="cc-panel">
            <div class="cc-head">
                코드
                <button type="button" class="btn btn-primary btn-sm" id="addBtn3" onclick="showForm(3)" style="font-size:12px;padding:2px 10px;display:none;">추가</button>
            </div>
            <div class="cc-search"><input type="text" id="search3" placeholder="코드 검색..." oninput="filterList(3)"/></div>
            <div class="cc-body">
                <ul class="cc-list" id="list3"></ul>
                <div class="cc-empty" id="empty3">
                    <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                    <p>그룹을 선택하세요.</p>
                </div>
            </div>
            <div class="cc-form" id="form3" style="display:none;">
                <input type="hidden" id="f3_codeId"/>
                <div class="mb-2">
                    <label class="form-label">코드명</label>
                    <input type="text" class="form-control form-control-sm" id="f3_codeNm" placeholder="코드명"/>
                </div>
                <div class="mb-2">
                    <label class="form-label">코드값</label>
                    <input type="text" class="form-control form-control-sm" id="f3_codeValue" placeholder="코드값"/>
                </div>
                <div class="mb-2">
                    <label class="form-label" style="border-bottom:1px solid #e2e8f0;padding-bottom:4px;width:100%;">확장 값</label>
                </div>
                <div class="row g-2 mb-1">
                    <div class="col-5"><input type="text" class="form-control form-control-sm" id="f3_valLabel1" placeholder="값설명1"/></div>
                    <div class="col-7"><input type="text" class="form-control form-control-sm" id="f3_val1" placeholder="값1"/></div>
                </div>
                <div class="row g-2 mb-1">
                    <div class="col-5"><input type="text" class="form-control form-control-sm" id="f3_valLabel2" placeholder="값설명2"/></div>
                    <div class="col-7"><input type="text" class="form-control form-control-sm" id="f3_val2" placeholder="값2"/></div>
                </div>
                <div class="row g-2 mb-1">
                    <div class="col-5"><input type="text" class="form-control form-control-sm" id="f3_valLabel3" placeholder="값설명3"/></div>
                    <div class="col-7"><input type="text" class="form-control form-control-sm" id="f3_val3" placeholder="값3"/></div>
                </div>
                <div class="row g-2 mb-2">
                    <div class="col-5"><input type="text" class="form-control form-control-sm" id="f3_valLabel4" placeholder="값설명4"/></div>
                    <div class="col-7"><input type="text" class="form-control form-control-sm" id="f3_val4" placeholder="값4"/></div>
                </div>
                <div class="mb-2">
                    <label class="form-label">설명</label>
                    <input type="text" class="form-control form-control-sm" id="f3_desc" placeholder="설명"/>
                </div>
                <div class="row g-2 mb-2">
                    <div class="col">
                        <label class="form-label">정렬</label>
                        <input type="number" class="form-control form-control-sm" id="f3_sort" value="0"/>
                    </div>
                    <div class="col">
                        <label class="form-label">사용</label>
                        <select class="form-select form-select-sm" id="f3_useYn">
                            <option value="Y">Y</option><option value="N">N</option>
                        </select>
                    </div>
                </div>
                <div class="btn-row">
                    <button type="button" class="btn btn-primary btn-sm flex-fill" onclick="saveCode(3)">저장</button>
                    <button type="button" class="btn btn-danger btn-sm" id="f3_delBtn" onclick="deleteCode(3)" style="display:none;">삭제</button>
                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="hideForm(3)">취소</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function() {
    var sel = {1: null, 2: null}; // 선택된 카테고리/그룹 codeId

    // ── 초기 로드 ──
    loadList(1);

    // ── 목록 로드 ──
    function loadList(depth, parentId) {
        var url = '<c:url value="/commonCodeData.do"/>?depth=' + depth;
        if (parentId) url += '&parentId=' + encodeURIComponent(parentId);
        fetch(url).then(function(r){ return r.json(); }).then(function(list) {
            renderList(depth, list);
        });
    }

    function renderList(depth, list) {
        var ul = document.getElementById('list' + depth);
        var empty = document.getElementById('empty' + depth);
        ul.innerHTML = '';
        if (list.length === 0) {
            empty.style.display = '';
            if (depth > 1) empty.querySelector('p').textContent = '데이터가 없습니다.';
        } else {
            empty.style.display = 'none';
        }
        list.forEach(function(item) {
            var li = document.createElement('li');
            li.setAttribute('data-code-id', item.codeId);
            var cls = item.useYn === 'N' ? ' use-n' : '';
            li.innerHTML = '<span class="' + cls + '">' + escHtml(item.codeNm) + '</span>'
                + '<span class="code-val">' + escHtml(item.codeValue || '') + '</span>';
            li.addEventListener('click', function() { onSelect(depth, item); });
            ul.appendChild(li);
        });
    }

    // ── 선택 ──
    function onSelect(depth, item) {
        // 활성 상태
        document.querySelectorAll('#list' + depth + ' li').forEach(function(el){ el.classList.remove('active'); });
        var active = document.querySelector('#list' + depth + ' li[data-code-id="' + item.codeId + '"]');
        if (active) active.classList.add('active');

        sel[depth] = item.codeId;
        hideForm(depth);

        if (depth === 1) {
            // 2뎁스 로드, 3뎁스 초기화
            sel[2] = null;
            document.getElementById('addBtn2').style.display = '';
            document.getElementById('addBtn3').style.display = 'none';
            loadList(2, item.codeId);
            clearPanel(3);
            // 수정 폼 표시
            showEditForm(1, item);
        } else if (depth === 2) {
            // 3뎁스 로드
            document.getElementById('addBtn3').style.display = '';
            loadList(3, item.codeId);
            showEditForm(2, item);
        } else {
            showEditForm(3, item);
        }
    }

    function clearPanel(depth) {
        document.getElementById('list' + depth).innerHTML = '';
        var empty = document.getElementById('empty' + depth);
        empty.style.display = '';
        if (depth === 2) empty.querySelector('p').textContent = '카테고리을 선택하세요.';
        if (depth === 3) empty.querySelector('p').textContent = '그룹을 선택하세요.';
        hideForm(depth);
    }

    // ── 폼 ──
    // ── 자동 코드값 생성 ──
    function generateNextCodeValue(depth) {
        var items = document.querySelectorAll('#list' + depth + ' li');
        var values = [];
        items.forEach(function(li) {
            var valSpan = li.querySelector('.code-val');
            if (valSpan && valSpan.textContent.trim()) values.push(valSpan.textContent.trim());
        });
        if (values.length === 0) return '';

        // 접두사+숫자 패턴 분석 (예: TK0001, TK0002 → prefix=TK, numLen=4)
        var pattern = /^([A-Za-z_-]*)(\d+)$/;
        var parsed = [];
        values.forEach(function(v) {
            var m = v.match(pattern);
            if (m) parsed.push({ prefix: m[1], num: parseInt(m[2], 10), numLen: m[2].length, raw: v });
        });
        if (parsed.length === 0) return ''; // 숫자 패턴 없음 (White, Black 등)

        // 가장 많은 접두사 그룹 찾기
        var prefixCount = {};
        parsed.forEach(function(p) {
            prefixCount[p.prefix] = (prefixCount[p.prefix] || 0) + 1;
        });
        var bestPrefix = '', bestCount = 0;
        for (var pf in prefixCount) {
            if (prefixCount[pf] > bestCount) { bestCount = prefixCount[pf]; bestPrefix = pf; }
        }

        // 해당 접두사의 항목들만 추출
        var group = parsed.filter(function(p) { return p.prefix === bestPrefix; });
        group.sort(function(a, b) { return a.num - b.num; });

        // 증분 계산: 2개 이상이면 일정 간격 검출, 1개면 +1
        var lastNum = group[group.length - 1].num;
        var numLen = group[group.length - 1].numLen;
        var step = 1;
        if (group.length >= 2) {
            // 모든 인접 간격이 동일한지 확인
            var diffs = [];
            for (var i = 1; i < group.length; i++) {
                diffs.push(group[i].num - group[i - 1].num);
            }
            var allSame = diffs.every(function(d) { return d === diffs[0]; });
            if (allSame && diffs[0] > 0) step = diffs[0];
        }

        var nextNum = lastNum + step;
        var numStr = String(nextNum);
        while (numStr.length < numLen) numStr = '0' + numStr;
        return bestPrefix + numStr;
    }

    window.showForm = function(depth) {
        var f = document.getElementById('form' + depth);
        f.style.display = '';
        document.getElementById('f' + depth + '_codeId').value = '';
        document.getElementById('f' + depth + '_codeNm').value = '';
        document.getElementById('f' + depth + '_codeValue').value = generateNextCodeValue(depth);
        document.getElementById('f' + depth + '_desc').value = '';
        document.getElementById('f' + depth + '_sort').value = '0';
        document.getElementById('f' + depth + '_useYn').value = 'Y';
        document.getElementById('f' + depth + '_delBtn').style.display = 'none';
        if (depth === 3) clearValFields();
        document.getElementById('f' + depth + '_codeNm').focus();
    };

    function clearValFields() {
        for (var i = 1; i <= 4; i++) {
            document.getElementById('f3_valLabel' + i).value = '';
            document.getElementById('f3_val' + i).value = '';
        }
    }

    function showEditForm(depth, item) {
        fetch('<c:url value="/commonCodeDetail.do"/>?codeId=' + encodeURIComponent(item.codeId))
            .then(function(r){ return r.json(); })
            .then(function(data) {
                var f = document.getElementById('form' + depth);
                f.style.display = '';
                document.getElementById('f' + depth + '_codeId').value = data.codeId;
                document.getElementById('f' + depth + '_codeNm').value = data.codeNm || '';
                document.getElementById('f' + depth + '_codeValue').value = data.codeValue || '';
                document.getElementById('f' + depth + '_desc').value = data.description || '';
                document.getElementById('f' + depth + '_sort').value = data.sortOrder || 0;
                document.getElementById('f' + depth + '_useYn').value = data.useYn || 'Y';
                document.getElementById('f' + depth + '_delBtn').style.display = '';
                if (depth === 3) {
                    for (var i = 1; i <= 4; i++) {
                        document.getElementById('f3_valLabel' + i).value = data['valLabel' + i] || '';
                        document.getElementById('f3_val' + i).value = data['val' + i] || '';
                    }
                }
            });
    }

    window.hideForm = function(depth) {
        document.getElementById('form' + depth).style.display = 'none';
    };

    // ── 저장 ──
    window.saveCode = function(depth) {
        var codeId = document.getElementById('f' + depth + '_codeId').value;
        var codeNm = document.getElementById('f' + depth + '_codeNm').value.trim();
        if (!codeNm) { alert('코드명을 입력하세요.'); return; }

        var params = 'codeNm=' + encodeURIComponent(codeNm)
            + '&codeValue=' + encodeURIComponent(document.getElementById('f' + depth + '_codeValue').value.trim())
            + '&description=' + encodeURIComponent(document.getElementById('f' + depth + '_desc').value.trim())
            + '&sortOrder=' + document.getElementById('f' + depth + '_sort').value
            + '&useYn=' + document.getElementById('f' + depth + '_useYn').value
            + '&depth=' + depth;

        if (depth === 2) params += '&parentId=' + encodeURIComponent(sel[1]);
        if (depth === 3) {
            params += '&parentId=' + encodeURIComponent(sel[2]);
            for (var i = 1; i <= 4; i++) {
                params += '&valLabel' + i + '=' + encodeURIComponent(document.getElementById('f3_valLabel' + i).value.trim());
                params += '&val' + i + '=' + encodeURIComponent(document.getElementById('f3_val' + i).value.trim());
            }
        }

        var url, isEdit = !!codeId;
        if (isEdit) {
            url = '<c:url value="/modifyCommonCode.do"/>';
            params += '&codeId=' + encodeURIComponent(codeId);
        } else {
            url = '<c:url value="/saveCommonCode.do"/>';
        }

        fetch(url, {
            method: 'POST',
            headers: {'Content-Type':'application/x-www-form-urlencoded'},
            body: params
        }).then(function(r){ return r.json(); }).then(function(data) {
            if (data.success) {
                alert(data.message);
                hideForm(depth);
                if (depth === 1) loadList(1);
                else if (depth === 2) loadList(2, sel[1]);
                else loadList(3, sel[2]);
            }
        });
    };

    // ── 삭제 ──
    window.deleteCode = function(depth) {
        var codeId = document.getElementById('f' + depth + '_codeId').value;
        if (!codeId) return;
        if (!confirm('삭제하시겠습니까?')) return;

        fetch('<c:url value="/removeCommonCode.do"/>', {
            method: 'POST',
            headers: {'Content-Type':'application/x-www-form-urlencoded'},
            body: 'codeId=' + encodeURIComponent(codeId)
        }).then(function(r){ return r.json(); }).then(function(data) {
            alert(data.message);
            if (data.success) {
                hideForm(depth);
                if (depth === 1) {
                    sel[1] = null; sel[2] = null;
                    loadList(1);
                    clearPanel(2); clearPanel(3);
                } else if (depth === 2) {
                    sel[2] = null;
                    loadList(2, sel[1]);
                    clearPanel(3);
                } else {
                    loadList(3, sel[2]);
                }
            }
        });
    };

    // ── 검색 필터 ──
    window.filterList = function(depth) {
        var q = document.getElementById('search' + depth).value.trim().toLowerCase();
        var items = document.querySelectorAll('#list' + depth + ' li');
        items.forEach(function(li) {
            var text = li.textContent.toLowerCase();
            li.style.display = (!q || text.indexOf(q) >= 0) ? '' : 'none';
        });
    };

    function escHtml(s) {
        if (!s) return '';
        var d = document.createElement('div');
        d.appendChild(document.createTextNode(s));
        return d.innerHTML;
    }

})();
</script>
</body>
</html>
