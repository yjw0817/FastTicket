<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
  /**
  * @Class Name : memberList.jsp
  * @Description : 회원 목록 화면
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>회원 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=4"/>
    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        /* 회원 수정 화면 function */
        function fn_egov_select(id) {
            document.listForm.selectedId.value = id;
            document.listForm.action = "<c:url value='/updateMemberView.do'/>";
            document.listForm.submit();
        }

        /* 회원 등록 화면 function */
        function fn_egov_addView() {
            document.listForm.action = "<c:url value='/addMember.do'/>";
            document.listForm.submit();
        }

        /* 회원 목록 화면 function */
        function fn_egov_selectList() {
            document.listForm.action = "<c:url value='/memberList.do'/>";
            document.listForm.submit();
        }

        /* pagination 페이지 링크 function */
        function fn_egov_link_page(pageNo) {
            document.listForm.pageIndex.value = pageNo;
            document.listForm.action = "<c:url value='/memberList.do'/>";
            document.listForm.submit();
        }

        //-->
    </script>
</head>

<body>
<jsp:include page="/WEB-INF/jsp/egovframework/example/cmmn/header.jsp" />
    <form:form commandName="searchVO" id="listForm" name="listForm" method="post">
        <input type="hidden" name="selectedId" />
        <div id="content_pop">
            <!-- 타이틀 -->
            <div id="title">
                <ul>
                    <li><img src="<c:url value='/images/egovframework/example/title_dot.gif'/>" alt=""/>회원 목록</li>
                </ul>
            </div>
            <!-- // 타이틀 -->
            <div id="search">
                <div class="row g-2 align-items-center justify-content-end mb-3">
                    <div class="col-auto">
                        <label for="searchCondition" class="visually-hidden">검색조건</label>
                        <form:select path="searchCondition" cssClass="form-select form-select-sm">
                            <form:option value="1" label="이름" />
                            <form:option value="0" label="회원ID" />
                        </form:select>
                    </div>
                    <div class="col-auto">
                        <label for="searchKeyword" class="visually-hidden">검색어</label>
                        <form:input path="searchKeyword" cssClass="form-control form-control-sm"/>
                    </div>
                    <div class="col-auto">
                        <a class="btn btn-primary btn-sm" href="javascript:fn_egov_selectList();">검색</a>
                    </div>
                </div>
            </div>
            <!-- List -->
            <div id="table" class="table-responsive">
                <table class="table table-hover table-striped" summary="회원ID, 이름, 전화번호, 이메일, 사용여부를 표시하는 테이블">
                    <caption style="visibility:hidden">회원ID, 이름, 전화번호, 이메일, 사용여부를 표시하는 테이블</caption>
                    <colgroup>
                        <col width="40"/>
                        <col width="120"/>
                        <col width="120"/>
                        <col width="120"/>
                        <col width="180"/>
                        <col width="70"/>
                    </colgroup>
                    <tr>
                        <th align="center">No</th>
                        <th align="center">회원ID</th>
                        <th align="center">이름</th>
                        <th align="center">전화번호</th>
                        <th align="center">이메일</th>
                        <th align="center">사용여부</th>
                    </tr>
                    <c:forEach var="result" items="${resultList}" varStatus="status">
                        <tr>
                            <td align="center" class="listtd"><c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/></td>
                            <td align="center" class="listtd"><a href="javascript:fn_egov_select('<c:out value="${result.member_id}"/>')"><c:out value="${result.member_id}"/></a></td>
                            <td align="left"   class="listtd"><c:out value="${result.member_nm}"/>&nbsp;</td>
                            <td align="center" class="listtd"><c:out value="${result.tel}"/>&nbsp;</td>
                            <td align="left"   class="listtd"><c:out value="${result.email}"/>&nbsp;</td>
                            <td align="center" class="listtd"><c:out value="${result.use_yn}"/>&nbsp;</td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
            <!-- /List -->
            <div id="paging">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
                <form:hidden path="pageIndex" />
            </div>
            <div id="sysbtn">
                <a class="btn btn-primary btn-sm" href="javascript:fn_egov_addView();">등록</a>
            </div>
        </div>
    </form:form>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
