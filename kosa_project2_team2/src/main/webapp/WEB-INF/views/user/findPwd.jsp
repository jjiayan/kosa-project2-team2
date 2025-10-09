<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>비밀번호 찾기</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<style>
  :root{
    --ink:#111; --muted:#6b7280; --ring:#111; --sub:#9ca3af;
    --danger:#ef4444; --accent:#ff6b6b; --accent-hover:#ff5a5a; --bg:#fff;
    --disabled:#e9eaec;
  }
  *{box-sizing:border-box}
  html,body{margin:0;padding:0;background:#f9fafb;font-family:"Noto Sans KR","Pretendard",sans-serif;color:var(--ink)}

  /* 페이지 레이아웃 */
  .page-wrap{
    min-height:calc(100vh - 80px);
    display:flex; align-items:center; justify-content:center;
    padding:32px 16px;
  }

  /* 카드 */
  .card{
    width:100%; max-width:520px; background:var(--bg);
    border:2px solid #111; border-radius:24px; padding:40px 32px;
    box-shadow:0 8px 24px rgba(0,0,0,.06);
  }
  .card h1{
    margin:0 0 28px; text-align:center; font-size:34px; font-weight:800; color:#555;
  }

  /* 필드 */
  .field{margin-bottom:16px;}
  .input-wrap{
    position:relative; border:2px solid #111; border-radius:999px; background:#fff;
    padding:12px 16px;
  }
  .input-wrap input{
    width:100%; border:0; outline:none; background:transparent; font-size:15px;
  }
  .hint{margin:8px 6px 0; font-size:12px; color:#9aa0a6}

  /* 에러 */
  .errors{margin:14px 0 6px; text-align:center; line-height:1.4;}
  .errors .msg{font-size:12px; color:var(--danger);}

  /* 버튼 영역 */
  .actions{ display:flex; gap:12px; margin-top:10px; }
  .btn{ flex:1; height:46px; border-radius:12px; border:0; cursor:pointer; font-weight:600; }
  .btn-primary{
    background:var(--accent); color:#fff; box-shadow:0 6px 16px rgba(255,107,107,.35);
  }
  .btn-primary:hover{ background:var(--accent-hover); }
  .btn-ghost{ background:var(--disabled); color:#777; }

  /* 하단 링크 */
  .links{margin-top:18px; text-align:center; font-size:14px; color:#4b5563}
  .links a{color:#4b5563; text-decoration:none}
  .links a:hover{color:#111; text-decoration:underline}
  .links .sep{margin:0 10px; color:#c7c7c7}

  @media (max-width:520px){
    .card{padding:32px 22px}
    .card h1{font-size:28px}
  }
</style>
</head>
<body>

<!-- 상단 네비게이션 -->
<jsp:include page="/include/nav.jsp" />

<!-- 본문 -->
<div class="page-wrap">
  <form class="card" action="${pageContext.request.contextPath}/findPw.do" method="post" autocomplete="on">
    <h1>비밀번호 찾기</h1>

    <!-- 휴대폰번호 -->
    <div class="field">
      <div class="input-wrap">
        <input type="text" name="phone" id="phone" placeholder="휴대폰번호" inputmode="numeric" maxlength="13" />
      </div>
      <div class="hint">예) 010-1234-5678</div>
    </div>

    <!-- 아이디 -->
    <div class="field">
      <div class="input-wrap">
        <input type="text" name="userId" id="userId" placeholder="아이디" />
      </div>
    </div>

    <!-- 에러 메시지 (있을 때만 렌더링) -->
    <c:if test="${not empty errorMsg or not empty phoneError or not empty idError}">
      <div class="errors" role="alert">
        <c:if test="${not empty phoneError}"><div class="msg">${phoneError}</div></c:if>
        <c:if test="${not empty idError}"><div class="msg">${idError}</div></c:if>
        <c:if test="${not empty errorMsg}"><div class="msg">${errorMsg}</div></c:if>
      </div>
    </c:if>

    <!-- 버튼 -->
    <div class="actions">
      <button type="submit" class="btn btn-primary">
        <i class="fa-regular fa-circle-question" style="margin-right:6px;"></i> 비밀번호찾기
      </button>
      <button type="button" class="btn btn-ghost" onclick="onCancel()">취소</button>
    </div>

    <!-- 하단 링크 -->
    <div class="links">
	  <a href="${pageContext.request.contextPath}/findId.user">아이디찾기</a>
	  <span class="sep">|</span>
	  <a href="${pageContext.request.contextPath}/findPwd.user">비밀번호찾기</a>
	  <span class="sep">|</span>
	  <a href="${pageContext.request.contextPath}/join.user">회원가입</a>
	</div>
  </form>
</div>

<script>
  // 취소 → 메인
  function onCancel(){
    location.href = "${pageContext.request.contextPath}/index.user";
  }

  // 휴대폰 자동 하이픈
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
