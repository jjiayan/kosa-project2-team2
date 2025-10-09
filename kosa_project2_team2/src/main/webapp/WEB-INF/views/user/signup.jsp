<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>회원가입</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css">

<style>
  :root{
    --ink:#111; --muted:#6b7280; --ring:#111; --sub:#9ca3af;
    --danger:#ef4444; --accent:#ff6b6b; --accent-hover:#ff5a5a; --bg:#fff;
    --disabled:#e9eaec;
  }
  *{box-sizing:border-box}
  html,body{margin:0;padding:0;background:#f9fafb;font-family:"Noto Sans KR","Pretendard",sans-serif;color:var(--ink)}

  .wrap{min-height:calc(100vh - 80px); padding:32px 16px 64px; display:flex; justify-content:center;}
  .container{width:100%; max-width:760px;}

  /* 제목 */
  .title{margin:12px 0 16px; text-align:center; font-size:44px; font-weight:900; color:#555;}

  /* 아바타 */
  .avatar-area{display:flex; flex-direction:column; align-items:center; gap:10px; margin-bottom:16px;}
  .avatar{
    width:140px; height:140px; border-radius:999px; overflow:hidden; border:2px solid #111; background:#fff;
    display:flex; align-items:center; justify-content:center;
  }
  .avatar img{width:100%; height:100%; object-fit:cover; display:block;}
  .avatar-actions{display:flex; gap:8px;}
  .chip{
    font-size:12px; padding:6px 10px; border-radius:10px; border:1.5px solid #111; background:#fff; cursor:pointer;
  }

  /* 카드 폼 */
  .card{
    background:#fff; border:2px solid #111; border-radius:20px; padding:24px 20px; box-shadow:0 8px 24px rgba(0,0,0,.06);
  }

  .field{margin:16px 8px;}
  .label{font-size:14px; color:#444; margin-bottom:6px;}
  .input-row{
    display:flex; align-items:center; gap:8px; border-bottom:2px solid #111; padding:10px 4px;
  }
  .input-row input, .input-row textarea{
    flex:1; border:0; outline:none; font-size:15px; background:transparent; padding:6px 4px;
  }
  .input-row textarea{
    border:2px solid #111; border-radius:10px; min-height:120px; padding:12px;
  }
  .btn-mini{
    border:1.5px solid #111; background:#fff; border-radius:8px; padding:6px 10px; cursor:pointer; font-size:13px;
  }
  .btn-eye{
    border:0; background:transparent; cursor:pointer; width:34px; height:34px; display:flex; align-items:center; justify-content:center; color:#666;
  }

  .badge{
    margin-left:6px; font-size:11px; color:#fff; background:#ff6b6b; border-radius:999px; padding:3px 8px; display:inline-flex; align-items:center; gap:4px;
  }

  /* 안내 */
  .notes{margin:16px 10px; color:#ef4444; font-size:13px;}
  .notes li{margin:6px 0;}

  /* 하단 버튼 */
  .actions{display:flex; gap:14px; margin-top:18px;}
  .btn{
    flex:1; height:52px; border-radius:12px; border:0; font-weight:800; cursor:pointer;
  }
  .btn-primary{background:var(--accent); color:#fff; box-shadow:0 8px 20px rgba(255,107,107,.35);}
  .btn-primary:hover{background:var(--accent-hover)}
  .btn-ghost{background:var(--disabled); color:#777;}

  /* responsive */
  @media (max-width:640px){
    .title{font-size:34px}
    .avatar{width:120px; height:120px}
  }
</style>
</head>
<body>

<!-- NAV -->
<jsp:include page="/include/nav.jsp" />

<div class="wrap">
  <div class="container">
    <h1 class="title">회원가입</h1>

    <!-- 아바타 -->
    <div class="avatar-area">
      <div class="avatar">
        <img id="avatarImg" src="${pageContext.request.contextPath}/images/default-avatar.png" alt="프로필 이미지" />
      </div>
      <div class="avatar-actions">
        <button type="button" class="chip" onclick="setDefaultAvatar()">기본 이미지</button>
        <button type="button" class="chip" onclick="document.getElementById('avatarFile').click()">이미지 추가</button>
        <input type="file" id="avatarFile" name="avatarFile" accept="image/*" style="display:none" />
      </div>
    </div>

    <!-- 폼 -->
    <form class="card" action="${pageContext.request.contextPath}/signup.do" method="post" enctype="multipart/form-data" autocomplete="on">
      <!-- 아이디 -->
      <div class="field">
        <div class="label">아이디</div>
        <div class="input-row">
          <input type="text" name="userId" id="userId" placeholder="아이디" required />
          <button type="button" class="btn-mini" onclick="checkId()">확인</button>
        </div>
      </div>

      <!-- 비밀번호 -->
      <div class="field">
        <div class="label">비밀번호 <span class="badge"><i class="fa-solid fa-circle-exclamation"></i> 사용불가</span></div>
        <div class="input-row">
          <input type="password" name="password" id="password" placeholder="비밀번호" required />
          <button type="button" class="btn-eye" onclick="togglePw('password','eye1')"><i id="eye1" class="fa-regular fa-eye"></i></button>
        </div>
      </div>

      <!-- 비밀번호 확인 -->
      <div class="field">
        <div class="label">비밀번호 확인</div>
        <div class="input-row">
          <input type="password" name="password2" id="password2" placeholder="비밀번호 확인" required />
          <button type="button" class="btn-eye" onclick="togglePw('password2','eye2')"><i id="eye2" class="fa-regular fa-eye"></i></button>
        </div>
      </div>

      <!-- 휴대전화번호 -->
      <div class="field">
        <div class="label">휴대전화번호</div>
        <div class="input-row">
          <input type="text" name="phone" id="phone" placeholder="010-1234-5678" inputmode="numeric" maxlength="13" />
          <button type="button" class="btn-mini" onclick="checkPhone()">확인</button>
        </div>
      </div>

      <!-- 닉네임 -->
      <div class="field">
        <div class="label">닉네임</div>
        <div class="input-row">
          <input type="text" name="nickname" id="nickname" placeholder="닉네임" />
          <button type="button" class="btn-mini" onclick="checkNickname()">확인</button>
        </div>
      </div>

      <!-- 자기소개 -->
      <div class="field">
        <div class="label">자기소개</div>
        <div class="input-row" style="border-bottom:none; padding:0;">
          <textarea name="bio" id="bio" placeholder="간단한 자기소개를 입력해 주세요."></textarea>
        </div>
      </div>

      <!-- 서버 에러 있을 때만 표시 -->
      <c:if test="${not empty errorMsg}">
        <div style="color:#ef4444; font-size:13px; margin:8px 10px;">${errorMsg}</div>
      </c:if>

      <!-- 안내 -->
      <ul class="notes">
        <li>아이디: 필수 정보입니다.</li>
        <li>비밀번호: 8~16자의 영문 대/소문자, 숫자, 특수문자를 사용해 주세요.</li>
      </ul>

      <!-- 하단 버튼 -->
      <div class="actions">
        <button type="submit" class="btn btn-primary">회원가입</button>
        <button type="button" class="btn btn-ghost" onclick="location.href='${pageContext.request.contextPath}/login.user'">취소</button>
      </div>
    </form>
  </div>
</div>

<script>
  // 기본 아바타로 되돌리기
  function setDefaultAvatar(){
    document.getElementById('avatarImg').src = "${pageContext.request.contextPath}/images/default-avatar.png";
    const f = document.getElementById('avatarFile'); if (f) f.value = "";
  }
  // 업로드 미리보기
  (function(){
    const f = document.getElementById('avatarFile');
    const img = document.getElementById('avatarImg');
    if (!f || !img) return;
    f.addEventListener('change', e=>{
      const file = e.target.files && e.target.files[0];
      if (!file) return;
      const reader = new FileReader();
      reader.onload = ev => img.src = ev.target.result;
      reader.readAsDataURL(file);
    });
  })();

  // 비밀번호 눈 토글
  function togglePw(inputId, eyeId){
    const input = document.getElementById(inputId);
    const eye = document.getElementById(eyeId);
    const isText = input.type === 'text';
    input.type = isText ? 'password' : 'text';
    eye.className = isText ? 'fa-regular fa-eye' : 'fa-regular fa-eye-slash';
  }

  // 휴대폰 자동 하이픈
  (function(){
    const phone = document.getElementById('phone');
    if (!phone) return;
    phone.addEventListener('input', e=>{
      let v = e.target.value.replace(/[^0-9]/g,'').slice(0,11);
      if (v.length > 7) v = v.replace(/(\d{3})(\d{4})(\d{1,4})/,'$1-$2-$3');
      else if (v.length > 3) v = v.replace(/(\d{3})(\d{1,4})/,'$1-$2');
      e.target.value = v;
    });
  })();

  // 중복/형식 확인 (더미: 필요 시 AJAX로 교체)
  function checkId(){ alert('아이디 중복 확인 로직 연결해 주세요.'); }
  function checkPhone(){ alert('휴대폰 인증/중복 확인 로직 연결해 주세요.'); }
  function checkNickname(){ alert('닉네임 중복 확인 로직 연결해 주세요.'); }
</script>

</body>
</html>
