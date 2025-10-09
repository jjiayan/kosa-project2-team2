<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>로그인</title>

<!-- (선택) 전역 기본 CSS가 있다면 사용: <link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css" /> -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<style>
  :root{
    --ink:#111; --muted:#6b7280; --ring:#111; --sub:#9ca3af;
    --danger:#ef4444; --accent:#ff6b6b; --accent-hover:#ff5a5a; --bg:#fff;
  }
  *{box-sizing:border-box}
  html,body{margin:0;padding:0;background:#f9fafb;font-family:"Noto Sans KR","Pretendard",sans-serif;color:var(--ink)}

  /* 전체 페이지 구조 */
  .page-wrap{min-height:calc(100vh - 80px); display:flex; align-items:center; justify-content:center; padding:32px 16px;}
  
  /* 카드 */
  .card{
    width:100%; max-width:420px; background:var(--bg);
    border:2px solid #111; border-radius:24px; padding:36px 28px;
    box-shadow:0 8px 24px rgba(0,0,0,.06);
  }
  .card h1{margin:0 0 28px; font-size:32px; text-align:center; letter-spacing:.04em}

  /* 입력 필드 */
  .field{margin-bottom:18px;}
  .field label{display:block; font-size:13px; color:#374151; margin:0 0 8px 6px}
  .input-wrap{
    position:relative; border:2px solid #111; border-radius:999px; background:#fff;
    padding:10px 14px;
  }
  .input-wrap input{
    width:100%; border:0; outline:none; font-size:15px; background:transparent; padding-right:36px;
  }
  .input-wrap .toggle{
    position:absolute; right:10px; top:50%; transform:translateY(-50%);
    width:32px; height:32px; border:0; background:transparent; cursor:pointer; color:#6b7280;
  }
  .input-wrap .toggle:hover{color:#111}

  /* 에러 메시지 */
  .error{
    margin-top:6px; font-size:12px; color:var(--danger); line-height:1.45;
  }

  /* 로그인 버튼 */
  .submit-btn{
    width:100%; margin-top:16px; border:0; border-radius:12px; height:44px;
    background:var(--accent); color:#fff; font-weight:600; letter-spacing:.02em; cursor:pointer;
    box-shadow:0 6px 16px rgba(255,107,107,.35);
  }
  .submit-btn:hover{background:var(--accent-hover)}
  .submit-btn:active{transform:translateY(1px)}

  /* 하단 링크 */
  .links{margin-top:18px; text-align:center; font-size:14px; color:#4b5563}
  .links a{color:#4b5563; text-decoration:none}
  .links a:hover{color:#111; text-decoration:underline}
  .links .sep{margin:0 10px; color:#c7c7c7}

  @media (max-width:480px){
    .card{padding:28px 20px}
    .card h1{font-size:28px}
  }
</style>
</head>
<body>

<!-- 상단 네비게이션 -->
<jsp:include page="/include/nav.jsp" />

<!-- 로그인 카드 -->
<div class="page-wrap">
  <form class="card" action="${pageContext.request.contextPath}/login.do" method="post" autocomplete="on">
    <h1>로그인</h1>

    <div class="field">
      <label for="userId">아이디</label>
      <div class="input-wrap">
        <input type="text" id="userId" name="userId" placeholder="아이디" required />
      </div>
    </div>

    <div class="field">
      <label for="userPw">비밀번호</label>
      <div class="input-wrap">
        <input type="password" id="userPw" name="userPw" placeholder="비밀번호" required />
        <button class="toggle" type="button" onclick="togglePw()"><i id="eye" class="fa-regular fa-eye"></i></button>
      </div>
    </div>

    <!-- ✅ 에러는 있을 때만 렌더링 -->
    <c:if test="${not empty errorMsg}">
      <div class="error" id="errorText">${errorMsg}</div>
    </c:if>

    <button type="submit" class="submit-btn">로그인</button>

    <jsp:include page="/include/login-links.jsp" />
  </form>
</div>

<script>
  function togglePw(){
    const input = document.getElementById('userPw');
    const eye = document.getElementById('eye');
    const isText = input.type === 'text';
    input.type = isText ? 'password' : 'text';
    eye.className = isText ? 'fa-regular fa-eye' : 'fa-regular fa-eye-slash';
  }
</script>
</body>
</html>
