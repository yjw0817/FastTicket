<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>권한메뉴</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=5"/>
    <style>
    .rm-wrap { display:flex; gap:20px; min-height:0; }
    .rm-left { flex:1; min-width:0; }
    .rm-right { flex:1; min-width:0; }
    .rm-panel {
        background:#fff; border:1px solid #e2e8f0; border-radius:10px;
        overflow:hidden;
    }
    .rm-panel-head {
        padding:14px 18px; font-weight:700; font-size:14px; color:#1a202c;
        border-bottom:1px solid #e2e8f0; background:#f8fafc;
    }
    .rm-panel-body { padding:0; }

    /* -- 권한 목록 -- */
    .role-list { list-style:none; margin:0; padding:6px 0; }
    .role-list li {
        padding:10px 18px; cursor:pointer; font-size:13.5px; color:#4a5568;
        border-left:3px solid transparent; transition:all .15s;
    }
    .role-list li:hover { background:#f1f5f9; color:#1a202c; }
    .role-list li.active {
        background:#ebf5ff; color:#2563eb; border-left-color:#2563eb; font-weight:600;
    }
    .role-list li .role-desc {
        font-size:11px; color:#94a3b8; font-weight:400; margin-top:1px;
    }
    .role-list li.active .role-desc { color:#60a5fa; }

    /* -- 메뉴 체크 트리 -- */
    .menu-tree { padding:12px 18px; }
    .menu-group { margin-bottom:6px; }
    .menu-children { padding-left:24px; border-left:2px solid #e2e8f0; margin-left:20px; margin-top:2px; }
    .menu-item {
        display:flex; align-items:center; gap:10px;
        padding:7px 8px 7px 12px; border-radius:6px; transition:background .12s;
    }
    .menu-item:hover { background:#f8fafc; }
    .menu-item input[type="checkbox"] {
        width:16px; height:16px; accent-color:#2563eb; cursor:pointer; flex-shrink:0;
    }
    .menu-item label {
        cursor:pointer; font-size:13.5px; color:#334155; flex:1;
        display:flex; align-items:center; gap:8px;
    }
    .menu-item label svg { width:16px; height:16px; stroke:#64748b; flex-shrink:0; }
    .menu-item label .menu-url {
        font-size:11px; color:#94a3b8; margin-left:auto;
    }

    /* -- 하단 저장 바 -- */
    .rm-save-bar {
        padding:14px 18px; border-top:1px solid #e2e8f0; background:#f8fafc;
        display:flex; align-items:center; justify-content:space-between;
    }
    .rm-save-bar .cnt { font-size:12.5px; color:#64748b; }
    .rm-save-bar .cnt strong { color:#2563eb; font-weight:700; }

    /* -- 빈 상태 -- */
    .rm-empty {
        text-align:center; padding:60px 20px; color:#94a3b8;
    }
    .rm-empty svg { margin-bottom:12px; }
    .rm-empty p { font-size:14px; }

    /* 전체선택 */
    .menu-check-all {
        display:flex; align-items:center; gap:8px;
        padding:10px 18px; border-bottom:1px solid #e2e8f0; background:#fafbfc;
    }
    .menu-check-all input[type="checkbox"] {
        width:16px; height:16px; accent-color:#2563eb; cursor:pointer;
    }
    .menu-check-all label {
        font-size:13px; font-weight:600; color:#475569; cursor:pointer;
    }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />

<div id="content_pop">

    <div class="rm-wrap">
        <!-- 좌: 권한 목록 -->
        <div class="rm-left">
            <div class="rm-panel">
                <div class="rm-panel-head">권한</div>
                <div class="rm-panel-body">
                    <ul class="role-list" id="roleList">
                        <c:forEach var="role" items="${roleList}">
                            <li data-role-id="${role.roleId}">
                                <c:out value="${role.roleNm}"/>
                                <div class="role-desc"><c:out value="${role.roleId}"/></div>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>

        <!-- 우: 메뉴 체크 트리 -->
        <div class="rm-right">
            <div class="rm-panel">
                <div class="rm-panel-head">메뉴 접근 권한</div>

                <!-- 권한 미선택 시 -->
                <div id="menuEmpty" class="rm-empty">
                    <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                    </svg>
                    <p>좌측에서 권한을 선택하세요.</p>
                </div>

                <!-- 메뉴 트리 (AJAX 로드) -->
                <div id="menuPanel" style="display:none;">
                    <div class="menu-check-all">
                        <input type="checkbox" id="checkAll"/>
                        <label for="checkAll">전체 선택</label>
                    </div>
                    <div class="menu-tree" id="menuTree"></div>
                    <div class="rm-save-bar">
                        <span class="cnt">선택: <strong id="checkedCnt">0</strong> / <span id="totalCnt">0</span></span>
                        <button type="button" class="btn btn-primary btn-sm" id="btnSave" style="min-width:80px;">저장</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function() {
    var allMenus = [
        <c:forEach var="m" items="${allMenuList}" varStatus="st">
        {menuId:'${m.menuId}', menuNm:'<c:out value="${m.menuNm}"/>',
         menuUrl:'${m.menuUrl}', icon:'${m.icon}',
         parentId:'${m.parentId}', sortOrder:${m.sortOrder}, useYn:'${m.useYn}'}<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    var currentRoleId = null;
    var checkedMenuIds = [];

    // ── 권한 클릭 ──
    document.getElementById('roleList').addEventListener('click', function(e) {
        var li = e.target.closest('li[data-role-id]');
        if (!li) return;
        document.querySelectorAll('#roleList li').forEach(function(el){ el.classList.remove('active'); });
        li.classList.add('active');
        currentRoleId = li.getAttribute('data-role-id');
        loadRoleMenus(currentRoleId);
    });

    function loadRoleMenus(roleId) {
        fetch('<c:url value="/roleMenuData.do"/>?roleId=' + encodeURIComponent(roleId))
            .then(function(r){ return r.json(); })
            .then(function(menuIds) {
                checkedMenuIds = menuIds;
                renderMenuTree();
                document.getElementById('menuEmpty').style.display = 'none';
                document.getElementById('menuPanel').style.display = '';
            });
    }

    // ── 메뉴 트리 렌더링 ──
    function renderMenuTree() {
        var container = document.getElementById('menuTree');
        var html = '';

        // 최상위 메뉴: parentId 없는 것
        var roots = allMenus.filter(function(m){ return !m.parentId; });

        roots.forEach(function(root) {
            html += '<div class="menu-group">';
            html += menuItemHtml(root);
            // 하위메뉴가 있으면 들여쓰기로 표시
            var children = allMenus.filter(function(m){ return m.parentId === root.menuId; });
            if (children.length > 0) {
                html += '<div class="menu-children">';
                children.forEach(function(child) {
                    html += menuItemHtml(child);
                });
                html += '</div>';
            }
            html += '</div>';
        });

        container.innerHTML = html;
        updateCounts();
    }

    function menuItemHtml(m) {
        var checked = checkedMenuIds.indexOf(m.menuId) >= 0 ? ' checked' : '';
        var iconSvg = m.icon && feather.icons[m.icon]
            ? feather.icons[m.icon].toSvg({width:16, height:16}) : '';
        return '<div class="menu-item">'
            + '<input type="checkbox" id="chk_' + m.menuId + '" value="' + m.menuId + '"' + checked + ' onchange="window._rmUpdate()"/>'
            + '<label for="chk_' + m.menuId + '">' + iconSvg + escHtml(m.menuNm) + '</label>'
            + '</div>';
    }

    function escHtml(s) {
        var d = document.createElement('div');
        d.appendChild(document.createTextNode(s));
        return d.innerHTML;
    }

    // ── 카운트 업데이트 ──
    window._rmUpdate = function() {
        updateCounts();
    };

    function updateCounts() {
        var boxes = document.querySelectorAll('#menuTree input[type="checkbox"]');
        var total = boxes.length;
        var cnt = 0;
        boxes.forEach(function(cb){ if (cb.checked) cnt++; });
        document.getElementById('checkedCnt').textContent = cnt;
        document.getElementById('totalCnt').textContent = total;
        document.getElementById('checkAll').checked = (total > 0 && cnt === total);
    }

    // ── 전체선택 ──
    document.getElementById('checkAll').addEventListener('change', function() {
        var checked = this.checked;
        document.querySelectorAll('#menuTree input[type="checkbox"]').forEach(function(cb){
            cb.checked = checked;
        });
        updateCounts();
    });

    // ── 저장 ──
    document.getElementById('btnSave').addEventListener('click', function() {
        if (!currentRoleId) return;
        var ids = [];
        document.querySelectorAll('#menuTree input[type="checkbox"]:checked').forEach(function(cb){
            ids.push(cb.value);
        });

        // 섹션 부모도 자동 포함 (하위메뉴 선택 시 부모 메뉴도 포함)
        allMenus.forEach(function(m) {
            if (!m.menuUrl && !m.parentId) {
                // 이 부모의 하위메뉴 중 하나라도 선택되었으면 부모도 포함
                var children = allMenus.filter(function(c){ return c.parentId === m.menuId; });
                var hasChild = children.some(function(c){ return ids.indexOf(c.menuId) >= 0; });
                if (hasChild && ids.indexOf(m.menuId) < 0) {
                    ids.push(m.menuId);
                }
            }
        });

        fetch('<c:url value="/saveRoleMenus.do"/>', {
            method: 'POST',
            headers: {'Content-Type':'application/x-www-form-urlencoded'},
            body: 'roleId=' + encodeURIComponent(currentRoleId) + '&menuIds=' + encodeURIComponent(ids.join(','))
        })
        .then(function(r){ return r.json(); })
        .then(function(data) {
            if (data.success) {
                alert(data.message);
                loadRoleMenus(currentRoleId);
            }
        });
    });

})();
</script>
</body>
</html>
