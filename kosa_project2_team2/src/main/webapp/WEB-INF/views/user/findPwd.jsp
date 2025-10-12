<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>비밀번호 찾기</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<style>
  :root{ --ink:#111; --muted:#6b7280; --ring:#111; --sub:#9ca3af; --danger:#ef4444; --accent:#ff6b6b; --accent-hover:#ff5a5a; --bg:#fff; --disabled:#e9eaec; }
  *{box-sizing:border-box}
  html,body{margin:0;padding:0;background:#f9fafb;font-family:"Noto Sans KR","Pretendard",sans-serif;color:var(--ink)}
  .page-wrap{min-height:calc(100vh - 80px); display:flex; align-items:center; justify-content:center; padding:32px 16px;}
  .card{width:100%; max-width:520px; background:var(--bg); border:2px solid #111; border-radius:24px; padding:40px 32px; box-shadow:0 8px 24px rgba(0,0,0,.06);}
  .card h1{margin:0 0 28px; text-align:center; font-size:34px; font-weight:800; color:#555;}
  .field{margin-bottom:16px;}
  .input-wrap{position:relative; border:2px solid #111; border-radius:999px; background:#fff; padding:12px 16px;}
  .input-wrap input{width:100%; border:0; outline:none; background:transparent; font-size:15px;}
  .hint{margin:8px 6px 0; font-size:12px; color:#9aa0a6}
  .errors{margin:14px 0 6px; text-align:center; line-height:1.4;}
  .errors .msg{font-size:12px; color:var(--danger);}
  .actions{ display:flex; gap:12px; margin-top:10px; }
  .btn{ flex:1; height:46px; border-radius:12px; border:0; cursor:pointer; font-weight:600; }
  .btn-primary{ background:var(--accent); color:#fff; box-shadow:0 6px 16px rgba(255,107,107,.35); }
  .btn-primary:hover{ background:var(--accent-hover); }
  .btn-ghost{ background:var(--disabled); color:#777; }
  .links{margin-top:18px; text-align:center; font-size:14px; color:#4b5563}
  .links a{color:#4b5563; text-decoration:none}
  .links a:hover{color:#111; text-decoration:underline}
  .links .sep{margin:0 10px; color:#c7c7c7}
  .result-box{margin-top:8px; padding:18px; border:2px solid #111; border-radius:12px; background:#fff; text-align:center;}
  .result-msg{font-size:16px; margin:0 0 8px; color:#374151;}
  @media (max-width:520px){ .card{padding:32px 22px} .card h1{font-size:28px} }
</style>
</head>
<body>

<jsp:include page="/include/nav.jsp" />

<div class="page-wrap">
  <div class="card">
    <h1>비밀번호 찾기</h1>

    <!-- 3단계: 재설정 완료 -->
    <c:if test="${resetSuccess}">
      <div class="result-box">
        <p class="result-msg">비밀번호가 성공적으로 변경되었습니다.</p>
        <div class="actions" style="margin-top:6px;">
          <button type="button" class="btn btn-primary" onclick="location.href='<c:url value="/login.user"/>'">로그인하기</button>
          <button type="button" class="btn btn-ghost" onclick="location.href='<c:url value="/index.user"/>'">메인으로</button>
        </div>
      </div>
    </c:if>

    <!-- 2단계: 본인확인 성공 → 새 비번 입력 폼 -->
    <c:if test="${verified and not resetSuccess}">
      <form action="${pageContext.request.contextPath}/resetPwdOk.user" method="post" autocomplete="off">
        <div class="field">
          <div class="input-wrap">
            <input type="password" name="newPw" placeholder="새 비밀번호 (8자 이상)" required />
          </div>
        </div>
        <div class="field">
          <div class="input-wrap">
            <input type="password" name="confirmPw" placeholder="새 비밀번호 확인" required />
          </div>
        </div>

        <c:if test="${not empty pwError}">
          <div class="errors" role="alert"><div class="msg">${pwError}</div></div>
        </c:if>
        <c:if test="${not empty errorMsg}">
          <div class="errors" role="alert"><div class="msg">${errorMsg}</div></div>
        </c:if>

        <div class="actions">
          <button type="submit" class="btn btn-primary">비밀번호 변경</button>
          <button type="button" class="btn btn-ghost" onclick="onCancel()">취소</button>
        </div>
      </form>
    </c:if>

    <!-- 1단계: 최초/실패 → 본인확인 폼 -->
    <c:if test="${not verified and not resetSuccess}">
      <form action="${pageContext.request.contextPath}/findPwdOk.user" method="post" autocomplete="on">
        <div class="field">
          <div class="input-wrap">
            <input type="text" name="phone" id="phone" placeholder="휴대폰번호" inputmode="numeric" maxlength="13" required />
          </div>
          <div class="hint">예) 010-1234-5678</div>
        </div>
        <div class="field">
          <div class="input-wrap">
            <input type="text" name="userId" id="userId" placeholder="아이디" required/>
          </div>
        </div>

        <c:if test="${not empty phoneError or not empty idError or not empty errorMsg}">
          <div class="errors" role="alert">
            <c:if test="${not empty phoneError}"><div class="msg">${phoneError}</div></c:if>
            <c:if test="${not empty idError}"><div class="msg">${idError}</div></c:if>
            <c:if test="${not empty errorMsg}"><div class="msg">${errorMsg}</div></c:if>
          </div>
        </c:if>

        <div class="actions">
          <button type="submit" class="btn btn-primary">
            <i class="fa-regular fa-circle-question" style="margin-right:6px;"></i> 비밀번호찾기
          </button>
          <button type="button" class="btn btn-ghost" onclick="onCancel()">취소</button>
        </div>

        <jsp:include page="/include/login-links.jsp" />
      </form>
    </c:if>

  </div>
</div>

<script>
  function onCancel(){ location.href = "${pageContext.request.contextPath}/login.user"; }
  const phone = document.getElementById('phone');
  if (phone){
    phone.addEventListener('input', e => {
      let v = e.target.value.replace(/[^0-9]/g,'').slice(0,11);
      if (v.length > 7) v = v.replace(/(\d{3})(\d{4})(\d{1,4})/, '$1-$2-$3');
      else if (v.length > 3) v = v.replace(/(\d{3})(\d{1,4})/, '$1-$2');
      e.target.value = v;
    });
  }
</script>

</body>
</html>
