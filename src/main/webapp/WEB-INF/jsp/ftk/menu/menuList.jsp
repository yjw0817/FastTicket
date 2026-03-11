<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>메뉴 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=6"/>
    <style>
    /* ── 레이아웃 ── */
    .menu-manage { display:flex; gap:16px; min-height:520px; }
    .tree-panel {
        width:320px; min-width:280px; flex-shrink:0;
        background:var(--card); border:1px solid var(--line); border-radius:var(--radius);
        display:flex; flex-direction:column; overflow:hidden;
    }
    .tree-header {
        padding:12px 16px; border-bottom:1px solid var(--line);
        display:flex; align-items:center; justify-content:space-between;
        background:var(--card-dim);
    }
    .tree-header h3 { margin:0; font-size:13px; font-weight:600; color:var(--ink); }
    .tree-body { padding:8px 0; overflow-y:auto; flex:1; }

    .detail-panel {
        flex:1;
        background:var(--card); border:1px solid var(--line); border-radius:var(--radius);
        display:flex; flex-direction:column; overflow:hidden;
    }
    .detail-header {
        padding:12px 16px; border-bottom:1px solid var(--line);
        display:flex; align-items:center; justify-content:space-between;
        background:var(--card-dim);
    }
    .detail-header h3 { margin:0; font-size:13px; font-weight:600; color:var(--ink); }
    .detail-body { padding:20px; flex:1; overflow-y:auto; }

    /* ── 트리 ── */
    .tree-node { user-select:none; }
    .tree-row {
        display:flex; align-items:center; gap:4px;
        padding:5px 12px 5px calc(12px + var(--depth, 0) * 22px);
        cursor:pointer; border-radius:0; transition: background .1s;
        font-size:13px; color:var(--ink);
    }
    .tree-row:hover { background:var(--card-dim); }
    .tree-row.selected { background:var(--blue-bg, rgba(59,130,246,.08)); color:var(--blue, #3b82f6); font-weight:600; }
    .tree-toggle {
        width:18px; height:18px; display:flex; align-items:center; justify-content:center;
        flex-shrink:0; border-radius:3px; transition: transform .15s;
    }
    .tree-toggle svg { width:14px; height:14px; stroke:var(--ink-3); }
    .tree-toggle.collapsed svg { transform: rotate(-90deg); }
    .tree-toggle.empty { visibility:hidden; }
    .tree-icon { flex-shrink:0; width:16px; height:16px; opacity:.5; }
    .tree-label { flex:1; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .tree-badge {
        font-size:10px; padding:1px 5px; border-radius:3px;
        background:var(--line); color:var(--ink-3); flex-shrink:0;
    }
    .tree-badge.inactive { background:#fee2e2; color:#dc2626; }
    .tree-children { overflow:hidden; }
    .tree-children.collapsed { display:none; }

    /* ── 폼 ── */
    .detail-form .form-label { font-size:12px; font-weight:600; color:var(--ink-2); margin-bottom:4px; }
    .detail-form .form-control, .detail-form .form-select {
        font-size:13px; border-radius:var(--radius-sm);
    }
    .detail-form .row { margin-bottom:12px; }
    .detail-actions { padding:16px; border-top:1px solid var(--line); display:flex; gap:6px; flex-wrap:wrap; }
    .detail-empty {
        display:flex; flex-direction:column; align-items:center; justify-content:center;
        height:100%; color:var(--ink-3); gap:12px;
    }
    .detail-empty svg { opacity:.3; }
    .detail-empty p { margin:0; font-size:13px; }

    /* ── 아이콘 피커 ── */
    .icon-picker-btn {
        display:flex; align-items:center; gap:8px; padding:6px 12px;
        border:1px solid var(--line); border-radius:var(--radius-sm);
        background:var(--card); cursor:pointer; font-size:13px; color:var(--ink);
        min-height:38px; transition: border-color .15s;
    }
    .icon-picker-btn:hover { border-color:var(--blue, #3b82f6); }
    .icon-picker-btn svg { width:18px; height:18px; stroke:var(--ink); }
    .icon-picker-btn .icon-placeholder { color:var(--ink-3); }
    .icon-picker-modal .modal-body { padding:12px; }
    .icon-search { margin-bottom:10px; }
    .icon-grid {
        display:grid; grid-template-columns:repeat(auto-fill, minmax(48px, 1fr));
        gap:4px; max-height:360px; overflow-y:auto; padding:4px;
    }
    .icon-cell {
        display:flex; align-items:center; justify-content:center;
        width:100%; aspect-ratio:1; border-radius:6px; cursor:pointer;
        font-size:20px; color:var(--ink-2); transition: all .1s;
        border:2px solid transparent;
    }
    .icon-cell:hover { background:var(--blue-bg, rgba(59,130,246,.08)); }
    .icon-cell:hover svg { stroke:var(--blue, #3b82f6); }
    .icon-cell.selected { border-color:var(--blue, #3b82f6); background:var(--blue-bg, rgba(59,130,246,.08)); }
    .icon-cell.selected svg { stroke:var(--blue, #3b82f6); }
    .icon-cell svg { width:20px; height:20px; stroke:var(--ink-2); stroke-width:2; fill:none; }

    /* 트리 Feather 아이콘 */
    .tree-feather { flex-shrink:0; width:16px; height:16px; opacity:.55; stroke-width:2; fill:none; }

    /* ── 반응형 ── */
    @media (max-width: 768px) {
        .menu-manage { flex-direction:column; }
        .tree-panel { width:100%; min-height:250px; }
    }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />

<div id="content_pop">

    <div class="menu-manage">
        <!-- 트리 패널 -->
        <div class="tree-panel">
            <div class="tree-header">
                <h3>메뉴 트리</h3>
            </div>
            <div class="tree-body" id="treeBody"></div>
        </div>

        <!-- 상세/등록 패널 -->
        <div class="detail-panel">
            <div class="detail-header">
                <h3 id="detailTitle">메뉴 상세</h3>
            </div>
            <div class="detail-body" id="detailBody">
                <div class="detail-empty" id="detailEmpty">
                    <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
                    <p>왼쪽 트리에서 메뉴를 선택하세요.</p>
                </div>
                <div class="detail-form" id="detailForm" style="display:none;">
                    <input type="hidden" id="fm_mode" value=""/>
                    <div class="row">
                        <div class="col-sm-6">
                            <label class="form-label">메뉴ID</label>
                            <input type="text" class="form-control" id="fm_menuId" readonly/>
                        </div>
                        <div class="col-sm-6">
                            <label class="form-label">상위메뉴</label>
                            <select class="form-select" id="fm_parentId"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-6">
                            <label class="form-label">메뉴명 <span style="color:#dc2626">*</span></label>
                            <input type="text" class="form-control" id="fm_menuNm" maxlength="50" placeholder="메뉴명을 입력하세요"/>
                        </div>
                        <div class="col-sm-6">
                            <label class="form-label">URL</label>
                            <input type="text" class="form-control" id="fm_menuUrl" maxlength="200" placeholder="/xxxList.do"/>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <label class="form-label">아이콘</label>
                            <input type="hidden" id="fm_icon" value=""/>
                            <div class="icon-picker-btn" onclick="openIconPicker()">
                                <span id="fm_icon_preview" class="icon-placeholder">아이콘을 선택하세요</span>
                                <span style="margin-left:auto;font-size:11px;color:var(--ink-3);">선택</span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4">
                            <label class="form-label">정렬순서</label>
                            <input type="number" class="form-control" id="fm_sortOrder" value="0" min="0"/>
                        </div>
                        <div class="col-sm-4">
                            <label class="form-label">사용여부</label>
                            <select class="form-select" id="fm_useYn">
                                <option value="Y">사용</option>
                                <option value="N">미사용</option>
                            </select>
                        </div>
                        <div class="col-sm-4">
                            <label class="form-label">등록일</label>
                            <input type="text" class="form-control" id="fm_regDt" readonly/>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <label class="form-label">설명</label>
                            <textarea class="form-control" id="fm_description" rows="3" maxlength="200"></textarea>
                        </div>
                    </div>
                </div>
            </div>
            <div class="detail-actions" id="detailActions">
                <button class="btn btn-outline-primary btn-sm" id="btnNew" onclick="addNewMenu()">신규</button>
                <button class="btn btn-primary btn-sm" id="btnEdit" onclick="enterEditMode()" style="display:none;">수정</button>
                <button class="btn btn-primary btn-sm" id="btnSave" onclick="saveMenu()" style="display:none;">저장</button>
                <button class="btn btn-danger btn-sm" id="btnDelete" onclick="deleteMenu()" style="display:none;">삭제</button>
                <button class="btn btn-outline-secondary btn-sm" id="btnCancel" onclick="cancelEdit()" style="display:none;">취소</button>
            </div>
        </div>
    </div>
</div>

<!-- 아이콘 피커 모달 -->
<div class="modal fade icon-picker-modal" id="iconPickerModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header py-2">
                <h6 class="modal-title" style="font-size:14px;font-weight:600;">아이콘 선택</h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="text" class="form-control form-control-sm icon-search" id="iconSearch" placeholder="아이콘 검색..." oninput="filterIcons()"/>
                <div class="icon-grid" id="iconGrid"></div>
            </div>
            <div class="modal-footer py-2">
                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="clearIcon()">아이콘 제거</button>
                <button type="button" class="btn btn-primary btn-sm" onclick="confirmIcon()">선택</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
var CTX = '<c:url value="/"/>';
var menuData = [
<c:forEach var="m" items="${allMenuList}" varStatus="s">
{menuId:'<c:out value="${m.menuId}"/>',menuNm:'<c:out value="${m.menuNm}"/>',menuUrl:'<c:out value="${m.menuUrl}"/>',icon:'<c:out value="${m.icon}"/>',parentId:'<c:out value="${m.parentId}"/>',sortOrder:${m.sortOrder},useYn:'<c:out value="${m.useYn}"/>',regDt:'<c:out value="${m.regDt}"/>',description:'<c:out value="${m.description}"/>'}${!s.last?',':''}
</c:forEach>
];
var selectedMenuId = null;
var expandedNodes = {};

// ── 트리 빌드 ──
function buildTree(data) {
    var map = {}, roots = [];
    data.forEach(function(m) { map[m.menuId] = { data:m, children:[] }; });
    data.forEach(function(m) {
        if (m.parentId && map[m.parentId]) {
            map[m.parentId].children.push(map[m.menuId]);
        } else {
            roots.push(map[m.menuId]);
        }
    });
    return roots;
}

function renderTree() {
    var tree = buildTree(menuData);
    var html = '';
    function renderNode(node, depth) {
        var d = node.data, hasChildren = node.children.length > 0;
        var isExpanded = expandedNodes[d.menuId] !== false;
        var sel = selectedMenuId === d.menuId ? ' selected' : '';
        html += '<div class="tree-node" data-id="'+d.menuId+'">';
        html += '<div class="tree-row'+sel+'" style="--depth:'+depth+'" onclick="selectNode(\''+d.menuId+'\')">';
        // toggle
        if (hasChildren) {
            html += '<span class="tree-toggle'+(isExpanded?'':' collapsed')+'" onclick="event.stopPropagation();toggleNode(\''+d.menuId+'\')">';
            html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>';
            html += '</span>';
        } else {
            html += '<span class="tree-toggle empty"></span>';
        }
        // icon
        if (d.icon && feather.icons[d.icon]) {
            html += feather.icons[d.icon].toSvg({class:'tree-feather'});
        } else {
            html += '<svg class="tree-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">';
            if (hasChildren) {
                html += '<path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/>';
            } else {
                html += '<path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/><polyline points="13 2 13 9 20 9"/>';
            }
            html += '</svg>';
        }
        html += '<span class="tree-label">'+d.menuNm+'</span>';
        if (d.useYn === 'N') html += '<span class="tree-badge inactive">미사용</span>';
        html += '</div>';
        if (hasChildren) {
            html += '<div class="tree-children'+(isExpanded?'':' collapsed')+'">';
            node.children.forEach(function(c) { renderNode(c, depth+1); });
            html += '</div>';
        }
        html += '</div>';
    }
    tree.forEach(function(n) { renderNode(n, 0); });
    if (!html) html = '<div style="padding:20px;text-align:center;color:var(--ink-3);font-size:13px;">등록된 메뉴가 없습니다.</div>';
    document.getElementById('treeBody').innerHTML = html;
}

function toggleNode(id) {
    expandedNodes[id] = expandedNodes[id] === false ? true : false;
    renderTree();
}

function selectNode(id) {
    selectedMenuId = id;
    renderTree();
    showDetail(id);
}

// ── 상세 패널 ──
function setFormReadonly(readonly) {
    var fields = ['fm_menuNm','fm_menuUrl','fm_sortOrder','fm_useYn','fm_description','fm_parentId'];
    fields.forEach(function(id) {
        var el = document.getElementById(id);
        if (el.tagName === 'SELECT') { el.disabled = readonly; }
        else { el.readOnly = readonly; }
    });
    var iconBtn = document.querySelector('.icon-picker-btn');
    if (iconBtn) {
        iconBtn.style.pointerEvents = readonly ? 'none' : '';
        iconBtn.style.opacity = readonly ? '.6' : '';
    }
}

function showDetail(menuId) {
    var m = menuData.find(function(x){ return x.menuId === menuId; });
    if (!m) return;
    document.getElementById('detailEmpty').style.display = 'none';
    document.getElementById('detailForm').style.display = '';
    document.getElementById('detailActions').style.display = '';
    document.getElementById('detailTitle').textContent = '메뉴 상세';
    document.getElementById('fm_mode').value = 'view';
    document.getElementById('fm_menuId').value = m.menuId;
    document.getElementById('fm_menuNm').value = m.menuNm;
    document.getElementById('fm_menuUrl').value = m.menuUrl || '';
    document.getElementById('fm_sortOrder').value = m.sortOrder;
    document.getElementById('fm_useYn').value = m.useYn;
    document.getElementById('fm_regDt').value = m.regDt || '';
    document.getElementById('fm_description').value = m.description || '';
    setIconPreview(m.icon || '');
    buildParentSelect(m.menuId, m.parentId);
    setFormReadonly(true);

    document.getElementById('btnNew').style.display = '';
    document.getElementById('btnEdit').style.display = '';
    document.getElementById('btnSave').style.display = 'none';
    document.getElementById('btnDelete').style.display = '';
    document.getElementById('btnCancel').style.display = 'none';
}

function enterEditMode() {
    document.getElementById('fm_mode').value = 'modify';
    document.getElementById('detailTitle').textContent = '메뉴 수정';
    setFormReadonly(false);
    document.getElementById('btnNew').style.display = 'none';
    document.getElementById('btnEdit').style.display = 'none';
    document.getElementById('btnSave').style.display = '';
    document.getElementById('btnSave').textContent = '저장';
    document.getElementById('btnDelete').style.display = 'none';
    document.getElementById('btnCancel').style.display = '';
    document.getElementById('fm_menuNm').focus();
}

function showCreateForm(parentId) {
    document.getElementById('detailEmpty').style.display = 'none';
    document.getElementById('detailForm').style.display = '';
    document.getElementById('detailActions').style.display = '';
    document.getElementById('detailTitle').textContent = '메뉴 등록';
    document.getElementById('fm_mode').value = 'create';
    document.getElementById('fm_menuId').value = '(자동생성)';
    document.getElementById('fm_menuNm').value = '';
    document.getElementById('fm_menuUrl').value = '';
    document.getElementById('fm_sortOrder').value = 0;
    document.getElementById('fm_useYn').value = 'Y';
    document.getElementById('fm_regDt').value = '';
    document.getElementById('fm_description').value = '';
    setIconPreview('');
    buildParentSelect(null, parentId || '');
    setFormReadonly(false);

    document.getElementById('btnNew').style.display = 'none';
    document.getElementById('btnEdit').style.display = 'none';
    document.getElementById('btnSave').style.display = '';
    document.getElementById('btnSave').textContent = '등록';
    document.getElementById('btnDelete').style.display = 'none';
    document.getElementById('btnCancel').style.display = '';
    document.getElementById('fm_menuNm').focus();
}

function buildParentSelect(excludeId, selectedParentId) {
    var sel = document.getElementById('fm_parentId');
    var html = '<option value="">-- 없음 (최상위) --</option>';
    menuData.forEach(function(m) {
        if (m.menuId !== excludeId) {
            var s = m.menuId === selectedParentId ? ' selected' : '';
            html += '<option value="'+m.menuId+'"'+s+'>'+m.menuNm+' ('+m.menuId+')</option>';
        }
    });
    sel.innerHTML = html;
}

// ── 액션 ──
function addNewMenu() {
    selectedMenuId = null;
    renderTree();
    showCreateForm('');
}

function cancelEdit() {
    var mode = document.getElementById('fm_mode').value;
    // 수정모드에서 취소 → 조회모드로 복귀
    if (mode === 'modify' && selectedMenuId) {
        showDetail(selectedMenuId);
        return;
    }
    // 등록모드에서 취소 → 빈 화면
    document.getElementById('detailEmpty').style.display = '';
    document.getElementById('detailForm').style.display = 'none';
    document.getElementById('detailTitle').textContent = '메뉴 상세';
    document.getElementById('btnNew').style.display = '';
    document.getElementById('btnEdit').style.display = 'none';
    document.getElementById('btnSave').style.display = 'none';
    document.getElementById('btnDelete').style.display = 'none';
    document.getElementById('btnCancel').style.display = 'none';
    selectedMenuId = null;
    renderTree();
}

function saveMenu() {
    var mode = document.getElementById('fm_mode').value;
    var menuNm = document.getElementById('fm_menuNm').value.trim();
    if (!menuNm) { alert('메뉴명을 입력하세요.'); document.getElementById('fm_menuNm').focus(); return; }

    var params = new URLSearchParams();
    params.append('menuNm', menuNm);
    params.append('menuUrl', document.getElementById('fm_menuUrl').value.trim());
    params.append('icon', document.getElementById('fm_icon').value);
    params.append('parentId', document.getElementById('fm_parentId').value);
    params.append('sortOrder', document.getElementById('fm_sortOrder').value);
    params.append('useYn', document.getElementById('fm_useYn').value);
    params.append('description', document.getElementById('fm_description').value.trim());

    var url;
    if (mode === 'create') {
        url = CTX + 'saveMenu.do';
    } else {
        url = CTX + 'modifyMenu.do';
        params.append('menuId', document.getElementById('fm_menuId').value);
    }

    fetch(url, { method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body:params.toString() })
    .then(function(r){ return r.json(); })
    .then(function(data){
        if (data.success) {
            alert(data.message);
            location.reload(); // 사이드바 반영을 위해 페이지 새로고침
        } else {
            alert('오류가 발생했습니다.');
        }
    })
    .catch(function(e){ alert('서버 오류: '+e.message); });
}

function deleteMenu() {
    var menuId = document.getElementById('fm_menuId').value;
    var hasChildren = menuData.some(function(m){ return m.parentId === menuId; });
    if (hasChildren) { alert('하위 메뉴가 있는 메뉴는 삭제할 수 없습니다.\n하위 메뉴를 먼저 삭제하세요.'); return; }
    if (!confirm('이 메뉴를 삭제하시겠습니까?')) return;

    var params = new URLSearchParams();
    params.append('menuId', menuId);

    fetch(CTX + 'removeMenu.do', { method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body:params.toString() })
    .then(function(r){ return r.json(); })
    .then(function(data){
        if (data.success) {
            alert(data.message);
            location.reload(); // 사이드바 반영을 위해 페이지 새로고침
        }
    })
    .catch(function(e){ alert('서버 오류: '+e.message); });
}

function refreshTree(selectId) {
    fetch(CTX + 'menuTreeData.do')
    .then(function(r){ return r.json(); })
    .then(function(data){
        menuData = data;
        selectedMenuId = selectId;
        renderTree();
        if (selectId) { showDetail(selectId); }
        else { cancelEdit(); }
    });
}

// ── 아이콘 피커 (Feather Icons) ──
var ICON_LIST = [
    // 일반/UI
    {name:'home',tags:'집 홈 공연장 house'},
    {name:'monitor',tags:'모니터 TV 화면 screen'},
    {name:'tv',tags:'TV 텔레비전'},
    {name:'smartphone',tags:'스마트폰 모바일 phone'},
    {name:'tablet',tags:'태블릿'},
    // 미디어/공연
    {name:'film',tags:'영화 필름 movie 공연'},
    {name:'camera',tags:'카메라 촬영'},
    {name:'video',tags:'비디오 영상'},
    {name:'music',tags:'음악 노트 music 공연'},
    {name:'mic',tags:'마이크 공연 music'},
    {name:'headphones',tags:'헤드폰 음악'},
    {name:'speaker',tags:'스피커 음향'},
    {name:'volume-2',tags:'볼륨 소리 sound'},
    {name:'radio',tags:'라디오 방송'},
    {name:'cast',tags:'캐스트 방송'},
    // 일정/캘린더
    {name:'calendar',tags:'달력 일정 calendar'},
    {name:'clock',tags:'시간 시계 clock time'},
    {name:'watch',tags:'시계 watch'},
    // 금융/결제
    {name:'dollar-sign',tags:'달러 돈 결제 가격 price'},
    {name:'credit-card',tags:'카드 결제 신용'},
    {name:'tag',tags:'태그 가격 price'},
    {name:'shopping-bag',tags:'쇼핑백 가방 구매'},
    {name:'shopping-cart',tags:'장바구니 cart 구매'},
    // 좌석/그리드
    {name:'grid',tags:'그리드 격자 좌석'},
    {name:'layout',tags:'레이아웃 배치'},
    {name:'columns',tags:'열 컬럼 배치'},
    {name:'sidebar',tags:'사이드바'},
    // 사람/사용자
    {name:'user',tags:'사람 사용자 회원'},
    {name:'users',tags:'사람들 그룹 group 회원'},
    {name:'user-plus',tags:'사람 추가 회원등록'},
    {name:'user-minus',tags:'사람 제거'},
    {name:'user-check',tags:'사람 확인 인증'},
    {name:'user-x',tags:'사람 삭제'},
    // 설정/관리
    {name:'settings',tags:'설정 톱니 gear 관리'},
    {name:'sliders',tags:'설정 슬라이더 필터'},
    {name:'tool',tags:'도구 공구 tools'},
    {name:'toggle-left',tags:'토글 스위치'},
    {name:'toggle-right',tags:'토글 스위치 on'},
    // 보안/권한
    {name:'shield',tags:'보안 방패 security 권한'},
    {name:'shield-off',tags:'보안해제'},
    {name:'lock',tags:'잠금 보안 lock'},
    {name:'unlock',tags:'잠금해제'},
    {name:'key',tags:'열쇠 키 인증'},
    // 파일/문서
    {name:'file',tags:'파일 문서'},
    {name:'file-text',tags:'파일 문서 텍스트'},
    {name:'file-plus',tags:'파일 추가'},
    {name:'file-minus',tags:'파일 제거'},
    {name:'folder',tags:'폴더 디렉토리'},
    {name:'folder-plus',tags:'폴더 추가'},
    {name:'archive',tags:'보관 archive'},
    {name:'clipboard',tags:'클립보드'},
    {name:'book',tags:'책 도서 book'},
    {name:'book-open',tags:'책 열기'},
    // 통신/알림
    {name:'bell',tags:'알림 벨 notification'},
    {name:'bell-off',tags:'알림끄기'},
    {name:'mail',tags:'메일 이메일 편지'},
    {name:'message-circle',tags:'채팅 메시지 chat'},
    {name:'message-square',tags:'메시지 댓글'},
    {name:'send',tags:'전송 보내기'},
    {name:'phone',tags:'전화 phone'},
    {name:'phone-call',tags:'전화 통화'},
    // 방향/이동
    {name:'navigation',tags:'네비게이션 방향'},
    {name:'map-pin',tags:'위치 핀 location 지도'},
    {name:'map',tags:'지도 map'},
    {name:'compass',tags:'나침반 방향'},
    {name:'globe',tags:'지구 글로벌 world'},
    // 차트/통계
    {name:'bar-chart-2',tags:'차트 통계 chart'},
    {name:'trending-up',tags:'그래프 증가 상승'},
    {name:'trending-down',tags:'그래프 감소 하락'},
    {name:'pie-chart',tags:'파이차트'},
    {name:'activity',tags:'활동 맥박 activity'},
    // 체크/상태
    {name:'check-circle',tags:'확인 체크 완료 예매'},
    {name:'check-square',tags:'체크박스 완료'},
    {name:'x-circle',tags:'취소 닫기 close'},
    {name:'x-square',tags:'취소 닫기'},
    {name:'alert-triangle',tags:'경고 주의 warning'},
    {name:'alert-circle',tags:'경고 주의'},
    {name:'info',tags:'정보 info'},
    {name:'help-circle',tags:'질문 도움말 help'},
    {name:'plus-circle',tags:'추가 플러스 add'},
    {name:'minus-circle',tags:'제거 마이너스'},
    // 액션
    {name:'search',tags:'검색 search 찾기'},
    {name:'filter',tags:'필터 깔때기'},
    {name:'list',tags:'목록 리스트 list 메뉴'},
    {name:'menu',tags:'메뉴 햄버거'},
    {name:'more-horizontal',tags:'더보기 옵션'},
    {name:'more-vertical',tags:'더보기 옵션'},
    {name:'refresh-cw',tags:'새로고침 반복 refresh'},
    {name:'download',tags:'다운로드'},
    {name:'upload',tags:'업로드'},
    {name:'printer',tags:'프린터 인쇄 print'},
    {name:'eye',tags:'보기 뷰 view'},
    {name:'eye-off',tags:'숨기기 비표시'},
    {name:'edit',tags:'수정 편집 edit 연필'},
    {name:'edit-2',tags:'수정 편집 연필'},
    {name:'edit-3',tags:'수정 편집 연필'},
    {name:'trash-2',tags:'삭제 휴지통 delete'},
    {name:'copy',tags:'복사 copy'},
    {name:'scissors',tags:'가위 잘라내기 cut'},
    {name:'link',tags:'링크 연결'},
    {name:'external-link',tags:'외부링크'},
    // 기타
    {name:'star',tags:'별 즐겨찾기 favorite'},
    {name:'heart',tags:'하트 좋아요 like'},
    {name:'bookmark',tags:'북마크 즐겨찾기'},
    {name:'flag',tags:'깃발 플래그 신고'},
    {name:'award',tags:'트로피 상 수상'},
    {name:'gift',tags:'선물 gift'},
    {name:'box',tags:'박스 패키지 box'},
    {name:'package',tags:'패키지 택배 배송'},
    {name:'truck',tags:'배송 트럭 delivery'},
    {name:'image',tags:'이미지 사진 그림'},
    {name:'layers',tags:'레이어 겹침'},
    {name:'hash',tags:'해시 번호'},
    {name:'at-sign',tags:'골뱅이 이메일'},
    {name:'percent',tags:'퍼센트 할인'},
    {name:'database',tags:'데이터베이스 DB'},
    {name:'server',tags:'서버 시스템'},
    {name:'terminal',tags:'터미널 명령어'},
    {name:'code',tags:'코드 개발'},
    {name:'zap',tags:'번개 빠른 전기'},
    {name:'power',tags:'전원 파워'},
    {name:'log-in',tags:'로그인'},
    {name:'log-out',tags:'로그아웃'}
];

var pickerSelectedIcon = '';
var iconPickerModal = null;

function openIconPicker() {
    if (!iconPickerModal) iconPickerModal = new bootstrap.Modal(document.getElementById('iconPickerModal'));
    pickerSelectedIcon = document.getElementById('fm_icon').value;
    document.getElementById('iconSearch').value = '';
    renderIconGrid(ICON_LIST);
    iconPickerModal.show();
}

function renderIconGrid(icons) {
    var html = '';
    icons.forEach(function(ic) {
        if (!feather.icons[ic.name]) return;
        var sel = pickerSelectedIcon === ic.name ? ' selected' : '';
        html += '<div class="icon-cell'+sel+'" data-icon="'+ic.name+'" onclick="pickIcon(\''+ic.name+'\')" title="'+ic.name+'">';
        html += feather.icons[ic.name].toSvg();
        html += '</div>';
    });
    if (!html) html = '<div style="padding:20px;text-align:center;color:var(--ink-3);font-size:13px;">검색 결과 없음</div>';
    document.getElementById('iconGrid').innerHTML = html;
}

function pickIcon(name) {
    pickerSelectedIcon = name;
    document.querySelectorAll('.icon-cell').forEach(function(el) {
        el.classList.toggle('selected', el.getAttribute('data-icon') === name);
    });
}

function filterIcons() {
    var q = document.getElementById('iconSearch').value.trim().toLowerCase();
    if (!q) { renderIconGrid(ICON_LIST); return; }
    var filtered = ICON_LIST.filter(function(ic) {
        return ic.name.indexOf(q) >= 0 || ic.tags.indexOf(q) >= 0;
    });
    renderIconGrid(filtered);
}

function confirmIcon() {
    setIconPreview(pickerSelectedIcon);
    iconPickerModal.hide();
}

function clearIcon() {
    pickerSelectedIcon = '';
    setIconPreview('');
    iconPickerModal.hide();
}

function setIconPreview(iconName) {
    document.getElementById('fm_icon').value = iconName || '';
    var preview = document.getElementById('fm_icon_preview');
    if (iconName && feather.icons[iconName]) {
        preview.className = '';
        preview.innerHTML = feather.icons[iconName].toSvg({width:18,height:18}) + ' <span style="font-size:12px;color:var(--ink-2);">'+iconName+'</span>';
    } else {
        preview.className = 'icon-placeholder';
        preview.innerHTML = '아이콘을 선택하세요';
    }
}

// ── 초기화 ──
renderTree();
</script>
</body>
</html>
