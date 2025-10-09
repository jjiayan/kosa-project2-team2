<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>아이디 찾기</title>

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
  .field{margin-bottom:22px;}
  .input-wrap{
    position:relative; border:2px solid #111; border-radius:999px; background:#fff;
    padding:12px 16px;
  }
  .input-wrap input{
    width:100%; border:0; outline:none; background:transparent; font-size:15px;
  }
  .hint{margin:8px 6px 0; font-size:12px; color:#9aa0a6}

  /* 에러 */
  .error{
    margin:18px 0 8px; text-align:center; font-size:12px; color:var(--danger);
  }

  /* 버튼 영역 */
  .actions{
    display:flex; gap:12px; margin-top:8px;
  }
  .btn{
    flex:1; height:46px; border-radius:12px; border:0; cursor:pointer; font-weight:600;
  }
  .btn-primary{
    background:var(--accent); color:#fff; box-shadow:0 6px 16px rgba(255,107,107,.35);
  }
  .btn-primary:hover{ background:var(--accent-hover); }
  .btn-ghost{
    background:var(--disabled); color:#777;
  }

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
  <form class="card" action="${pageContext.request.contextPath}/findId.do" method="post" autocomplete="on">
    <h1>아이디 찾기</h1>

    <!-- 휴대폰번호 입력 -->
    <div class="field">
      <div class="input-wrap">
        <input type="text" name="phone" id="phone" placeholder="휴대폰번호" inputmode="numeric" maxlength="13" />
      </div>
      <div class="hint">예) 010-1234-5678</div>
    </div>

    <!-- 에러 메시지 (있을 때만 렌더링) -->
    <c:if test="${not empty errorMsg}">
      <div class="error">${errorMsg}</div>
    </c:if>

    <!-- 버튼 -->
    <div class="actions">
      <button type="submit" class="btn btn-primary">아이디찾기</button>
      <button type="button" class="btn btn-ghost" onclick="onCancel()">취소</button>
    </div>

    <!-- 하단 링크 -->
    <jsp:include page="/include/login-links.jsp" />
  </form>
</div>

<script>
  // 취소 → 메인으로
  function onCancel(){
    location.href = "${pageContext.request.contextPath}/index.user";
  }

  // (선택) 휴대폰 번호 자동 하이픈
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
