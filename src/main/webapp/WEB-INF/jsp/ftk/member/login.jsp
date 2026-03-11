<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  /**
  * @Class Name : login.jsp
  * @Description : 로그인 화면
  */
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>FastTicket - 로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet"/>
    <style>
        * { font-family: 'DM Sans', 'Noto Sans KR', sans-serif; }
        body {
            background: #f0f2f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            width: 100%;
            max-width: 400px;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0,0,0,.08);
            padding: 40px 36px 32px;
        }
        .login-logo {
            text-align: center;
            margin-bottom: 32px;
            font-size: 22px;
            font-weight: 700;
            color: #222;
            letter-spacing: -.3px;
        }
        .login-logo span { color: #5AC8FA; }
        .form-label {
            font-size: 13px;
            font-weight: 500;
            color: #555;
            margin-bottom: 4px;
        }
        .form-control {
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 14px;
            border: 1px solid #ddd;
        }
        .form-control:focus {
            border-color: #5AC8FA;
            box-shadow: 0 0 0 3px rgba(90,200,250,.15);
        }
        .btn-login {
            width: 100%;
            padding: 11px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            background: #5AC8FA;
            border: none;
            color: #fff;
            margin-top: 8px;
        }
        .btn-login:hover { background: #4ab8e8; color: #fff; }
        .error-msg {
            color: #e74c3c;
            font-size: 13px;
            text-align: center;
            margin-bottom: 12px;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="login-logo"><span>Fast</span>&nbsp;Ticket</div>

    <c:if test="${not empty errorMsg}">
        <div class="error-msg">${errorMsg}</div>
    </c:if>

    <form action="<c:url value='/login.do'/>" method="post">
        <div class="mb-3">
            <label for="memberId" class="form-label">회원 ID</label>
            <input type="text" class="form-control" id="memberId" name="memberId" placeholder="아이디를 입력하세요" required autofocus/>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">비밀번호</label>
            <input type="password" class="form-control" id="password" name="password" placeholder="비밀번호를 입력하세요" required/>
        </div>
        <button type="submit" class="btn btn-login">로그인</button>
    </form>
</div>

</body>
</html>
