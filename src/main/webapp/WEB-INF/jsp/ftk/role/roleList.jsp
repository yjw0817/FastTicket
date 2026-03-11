<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
  /**
  * @Class Name : roleList.jsp
  * @Description : 권한 목록 화면
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>권한 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=5"/>
    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        /* 권한 수정 화면 function */
        function fn_egov_select(id) {
            document.listForm.selectedId.value = id;
            document.listForm.action = "<c:url value='/updateRoleView.do'/>";
            document.listForm.submit();
        }

        /* 권한 등록 화면 function */
        function fn_egov_addView() {
            location.href = "<c:url value='/addRole.do'/>";
        }

        /* 권한 목록 화면 function */
        function fn_egov_selectList() {
            document.listForm.action = "<c:url value='/roleList.do'/>";
            document.listForm.submit();
        }

        /* pagination 페이지 링크 function */
        function fn_egov_link_page(pageNo) {
            document.listForm.pageIndex.value = pageNo;
            document.listForm.action = "<c:url value='/roleList.do'/>";
            document.listForm.submit();
        }

        //-->
    </script>
</head>

<body>
<jsp:include page="/WEB-INF/jsp/ftk/cmmn/header.jsp" />
    <form:form modelAttribute="searchVO" id="listForm" name="listForm" method="post">
        <input type="hidden" name="selectedId" />
        <div id="content_pop">
            <div id="search">
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <a class="btn btn-primary btn-sm" href="javascript:fn_egov_addView();">등록</a>
                    <div class="d-flex align-items-center gap-2 ms-auto">
                        <form:select path="searchCondition" cssClass="form-select form-select-sm">
                            <form:option value="1" label="권한명" />
                            <form:option value="0" label="권한ID" />
                        </form:select>
                        <form:input path="searchKeyword" cssClass="form-control form-control-sm"/>
                        <a class="btn btn-outline-secondary btn-sm" href="javascript:fn_egov_selectList();">검색</a>
                    </div>
                </div>
            </div>
            <!-- List -->
            <div id="table" class="table-responsive">
                <table class="table table-hover table-striped" summary="권한ID, 권한명, 설명, 사용여부를 표시하는 테이블">
                    <caption style="visibility:hidden">권한ID, 권한명, 설명, 사용여부를 표시하는 테이블</caption>
                    <colgroup>
                        <col width="40"/>
                        <col width="120"/>
                        <col width="150"/>
                        <col width="250"/>
                        <col width="70"/>
                    </colgroup>
                    <tr>
                        <th align="center">No</th>
                        <th align="center">권한ID</th>
                        <th align="center">권한명</th>
                        <th align="center">설명</th>
                        <th align="center">사용여부</th>
                    </tr>
                    <c:forEach var="result" items="${resultList}" varStatus="status">
                        <tr>
                            <td align="center" class="listtd"><c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/></td>
                            <td align="center" class="listtd"><a href="javascript:fn_egov_select('<c:out value="${result.roleId}"/>')"><c:out value="${result.roleId}"/></a></td>
                            <td align="left"   class="listtd"><c:out value="${result.roleNm}"/>&nbsp;</td>
                            <td align="left"   class="listtd"><c:out value="${result.description}"/>&nbsp;</td>
                            <td align="center" class="listtd">
                                <c:choose>
                                    <c:when test="${result.useYn == 'Y'}"><span class="badge-active">Y</span></c:when>
                                    <c:otherwise><span class="badge-inactive">N</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty resultList}">
                        <tr><td colspan="5" class="listtd">
                            <div class="empty-state">
                                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                                <p>등록된 권한이 없습니다.</p>
                                <a class="btn btn-primary btn-sm" href="javascript:fn_egov_addView();">등록하기</a>
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
