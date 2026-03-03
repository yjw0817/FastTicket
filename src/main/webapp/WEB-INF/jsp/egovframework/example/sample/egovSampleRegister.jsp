<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<%
  /**
  * @Class Name : egovSampleRegister.jsp
  * @Description : Sample Register 화면
  * @Modification Information
  *
  *   수정일         수정자                   수정내용
  *  -------    --------    ---------------------------
  *  2009.02.01            최초 생성
  *
  * author 실행환경 개발팀
  * since 2009.02.01
  *
  * Copyright (C) 2009 by MOPAS  All right reserved.
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <c:set var="registerFlag" value="${empty sampleVO.id ? 'create' : 'modify'}"/>
    <title>Sample <c:if test="${registerFlag == 'create'}"><spring:message code="button.create" /></c:if>
                  <c:if test="${registerFlag == 'modify'}"><spring:message code="button.modify" /></c:if>
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>?v=4"/>
    
    <!--For Commons Validator Client Side-->
    <script type="text/javascript" src="<c:url value='/cmmn/validator.do'/>"></script>
    <validator:javascript formName="sampleVO" staticJavascript="false" xhtml="true" cdata="false"/>
    
    <script type="text/javaScript" language="javascript" defer="defer">
        <!--
        /* 글 목록 화면 function */
        function fn_egov_selectList() {
           	document.detailForm.action = "<c:url value='/egovSampleList.do'/>";
           	document.detailForm.submit();
        }
        
        /* 글 삭제 function */
        function fn_egov_delete() {
           	document.detailForm.action = "<c:url value='/deleteSample.do'/>";
           	document.detailForm.submit();
        }
        
        /* 글 등록 function */
        function fn_egov_save() {
        	frm = document.detailForm;
        	if(!validateSampleVO(frm)){
                return;
            }else{
            	frm.action = "<c:url value="${registerFlag == 'create' ? '/addSample.do' : '/updateSample.do'}"/>";
                frm.submit();
            }
        }
        
        -->
    </script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/egovframework/example/cmmn/header.jsp" />

<form:form commandName="sampleVO" id="detailForm" name="detailForm">
    <div id="content_pop">
    	<!-- 타이틀 -->
    	<div id="title">
    		<ul>
    			<li><img src="<c:url value='/images/egovframework/example/title_dot.gif'/>" alt=""/>
                    <c:if test="${registerFlag == 'create'}"><spring:message code="button.create" /></c:if>
                    <c:if test="${registerFlag == 'modify'}"><spring:message code="button.modify" /></c:if>
                </li>
    		</ul>
    	</div>
    	<!-- // 타이틀 -->
    	<div id="table" class="table-responsive">
    	<table class="table" style="border-top:2px solid #C2D0DB; border-collapse:collapse;">
    		<colgroup>
    			<col width="150"/>
    			<col width="?"/>
    		</colgroup>
    		<c:if test="${registerFlag == 'modify'}">
        		<tr>
        			<td class="tbtd_caption"><label for="id"><spring:message code="title.sample.id" /></label></td>
        			<td class="tbtd_content">
        				<form:input path="id" cssClass="essentiality" maxlength="10" readonly="true" />
        			</td>
        		</tr>
    		</c:if>
    		<tr>
    			<td class="tbtd_caption"><label for="name"><spring:message code="title.sample.name" /></label></td>
    			<td class="tbtd_content">
    				<form:input path="name" maxlength="30" cssClass="txt"/>
    				&nbsp;<form:errors path="name" />
    			</td>
    		</tr>
    		<tr>
    			<td class="tbtd_caption"><label for="useYn"><spring:message code="title.sample.useYn" /></label></td>
    			<td class="tbtd_content">
    				<form:select path="useYn" cssClass="use">
    					<form:option value="Y" label="Yes" />
    					<form:option value="N" label="No" />
    				</form:select>
    			</td>
    		</tr>
    		<tr>
    			<td class="tbtd_caption"><label for="description"><spring:message code="title.sample.description" /></label></td>
    			<td class="tbtd_content">
    				<form:textarea path="description" rows="5" cols="58" />&nbsp;<form:errors path="description" />
                </td>
    		</tr>
    		<tr>
    			<td class="tbtd_caption"><label for="regUser"><spring:message code="title.sample.regUser" /></label></td>
    			<td class="tbtd_content">
                    <c:if test="${registerFlag == 'modify'}">
        				<form:input path="regUser" maxlength="10" cssClass="essentiality" readonly="true" />
        				&nbsp;<form:errors path="regUser" /></td>
                    </c:if>
                    <c:if test="${registerFlag != 'modify'}">
        				<form:input path="regUser" maxlength="10" cssClass="txt"  />
        				&nbsp;<form:errors path="regUser" /></td>
                    </c:if>
    		</tr>
    	</table>
      </div>
    	<div id="sysbtn">
    		<a class="btn btn-outline-secondary btn-sm" href="javascript:fn_egov_selectList();"><spring:message code="button.list" /></a>
    		<a class="btn btn-primary btn-sm" href="javascript:fn_egov_save();">
    		    <c:if test="${registerFlag == 'create'}"><spring:message code="button.create" /></c:if>
    		    <c:if test="${registerFlag == 'modify'}"><spring:message code="button.modify" /></c:if>
    		</a>
    		<c:if test="${registerFlag == 'modify'}">
    		    <a class="btn btn-danger btn-sm" href="javascript:fn_egov_delete();"><spring:message code="button.delete" /></a>
    		</c:if>
    		<a class="btn btn-outline-secondary btn-sm" href="javascript:document.detailForm.reset();"><spring:message code="button.reset" /></a>
    	</div>
    </div>
    <!-- 검색조건 유지 -->
    <input type="hidden" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
    <input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
    <input type="hidden" name="pageIndex" value="<c:out value='${searchVO.pageIndex}'/>"/>
</form:form>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>