<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
  /**
  * @Class Name : userRoleList.jsp
  * @Description : 사용자-권한 매핑 목록 화면
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>사용자-권한 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=5"/>
    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        /* 권한 부여 화면 function */
        function fn_egov_addView() {
            location.href = "<c:url value='/addUserRoleView.do'/>";
        }

        /* 목록 조회 function */
        function fn_egov_selectList() {
            document.listForm.action = "<c:url value='/userRoleList.do'/>";
            document.listForm.submit();
        }

        /* 권한 삭제 function */
        function fn_egov_delete(memberId, roleId) {
            if (confirm('해당 권한을 삭제하시겠습니까?')) {
                document.listForm.memberId.value = memberId;
                document.listForm.roleId.value = roleId;
                document.listForm.action = "<c:url value='/deleteUserRole.do'/>";
                document.listForm.submit();
            }
        }

        /* pagination 페이지 링크 function */
        function fn_egov_link_page(pageNo) {
            document.listForm.pageIndex.value = pageNo;
            document.listForm.action = "<c:url value='/userRoleList.do'/>";
            document.listForm.submit();
        }

        //-->
    </script>
</head>

<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />
    <form:form modelAttribute="searchVO" id="listForm" name="listForm" method="post">
        <input type="hidden" name="memberId" />
        <input type="hidden" name="roleId" />
        <div id="content_pop">
            <div id="search">
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <a class="btn btn-primary btn-sm" href="javascript:fn_egov_addView();">권한 부여</a>
                    <div class="d-flex align-items-center gap-2 ms-auto">
                        <form:select path="searchCondition" cssClass="form-select form-select-sm">
                            <form:option value="1" label="회원명" />
                            <form:option value="0" label="회원ID" />
                        </form:select>
                        <form:input path="searchKeyword" cssClass="form-control form-control-sm"/>
                        <a class="btn btn-outline-secondary btn-sm" href="javascript:fn_egov_selectList();">검색</a>
                    </div>
                </div>
            </div>
            <!-- List -->
            <div id="table" class="table-responsive">
                <table class="table table-hover table-striped" summary="No, 회원ID, 회원명, 권한ID, 권한명, 등록일, 삭제를 표시하는 테이블">
                    <caption style="visibility:hidden">No, 회원ID, 회원명, 권한ID, 권한명, 등록일, 삭제를 표시하는 테이블</caption>
                    <colgroup>
                        <col width="40"/>
                        <col width="120"/>
                        <col width="120"/>
                        <col width="120"/>
                        <col width="120"/>
                        <col width="120"/>
                        <col width="70"/>
                    </colgroup>
                    <tr>
                        <th align="center">No</th>
                        <th align="center">회원ID</th>
                        <th align="center">회원명</th>
                        <th align="center">권한ID</th>
                        <th align="center">권한명</th>
                        <th align="center">등록일</th>
                        <th align="center">삭제</th>
                    </tr>
                    <c:forEach var="result" items="${resultList}" varStatus="status">
                        <tr>
                            <td align="center" class="listtd"><c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/></td>
                            <td align="center" class="listtd"><c:out value="${result.memberId}"/></td>
                            <td align="center" class="listtd"><c:out value="${result.memberNm}"/></td>
                            <td align="center" class="listtd"><c:out value="${result.roleId}"/></td>
                            <td align="center" class="listtd"><c:out value="${result.roleNm}"/></td>
                            <td align="center" class="listtd"><c:out value="${result.regDt}"/></td>
                            <td align="center" class="listtd">
                                <a class="btn btn-danger btn-sm" href="javascript:fn_egov_delete('<c:out value="${result.memberId}"/>', '<c:out value="${result.roleId}"/>');">삭제</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty resultList}">
                        <tr><td colspan="7" class="listtd">
                            <div class="empty-state">
                                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4-4v2"/><circle cx="8.5" cy="7" r="4"/><line x1="20" y1="8" x2="20" y2="14"/><line x1="23" y1="11" x2="17" y2="11"/></svg>
                                <p>등록된 사용자-권한 매핑이 없습니다.</p>
                                <a class="btn btn-primary btn-sm" href="javascript:fn_egov_addView();">권한 부여하기</a>
                            </div>
                        </td></tr>
                    </c:if>
                </table>
            </div>
            <!-- /List -->
            <div id="paging">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
                <form:hidden path="pageIndex" />
            </div>
            <div id="sysbtn"></div>
        </div>
    </form:form>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
