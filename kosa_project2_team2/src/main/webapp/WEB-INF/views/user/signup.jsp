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

  .title{margin:12px 0 16px; text-align:center; font-size:44px; font-weight:900; color:#555;}

  .avatar-area{display:flex; flex-direction:column; align-items:center; gap:10px; margin-bottom:16px;}
  /* ▼ 회원가입 전용 아바타 (nav.jsp의 .avatar와 충돌 방지) */
  .signup-avatar{
    width:140px; height:140px; border-radius:999px; overflow:hidden; border:2px solid #111; background:#fff;
    display:flex; align-items:center; justify-content:center;
  }
  .signup-avatar img{width:100%; height:100%; object-fit:cover; display:block;}
  .avatar-actions{display:flex; gap:8px;}
  .chip{
    font-size:12px; padding:6px 10px; border-radius:10px; border:1.5px solid #111; background:#fff; cursor:pointer;
  }

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

  .notes{margin:16px 10px; color:#ef4444; font-size:13px;}
  .notes li{margin:6px 0;}

  .actions{display:flex; gap:14px; margin-top:18px;}
  .btn{
    flex:1; height:52px; border-radius:12px; border:0; font-weight:800; cursor:pointer;
  }
  .btn-primary{background:var(--accent); color:#fff; box-shadow:0 8px 20px rgba(255,107,107,.35);}
  .btn-primary:hover{background:var(--accent-hover)}
  .btn-ghost{background:var(--disabled); color:#777;}

  @media (max-width:640px){
    .title{font-size:34px}
    .signup-avatar{width:120px; height:120px}
  }
  .badge.ok{ background:#16a34a; }
</style>
</head>
<body>

<jsp:include page="/include/nav.jsp" />

<div class="wrap">
  <div class="container">
    <h1 class="title">회원가입</h1>

    <!-- ✅ form 시작 -->
    <form class="card" action="${pageContext.request.contextPath}/signupOk.user"
          method="post" enctype="multipart/form-data" autocomplete="on">

      <!-- ✅ 아바타 -->
      <div class="avatar-area">
        <div class="signup-avatar">
          <img id="avatarImg" src="${pageContext.request.contextPath}/images/default-avatar.png" alt="프로필 이미지" />
        </div>
        <div class="avatar-actions">
          <button type="button" class="chip" onclick="setDefaultAvatar()">기본 이미지</button>
          <button type="button" class="chip" onclick="document.getElementById('avatarFile').click()">이미지 추가</button>
          <!-- ✅ form 내부로 이동 -->
          <input type="file" id="avatarFile" name="avatarFile" accept="image/*" style="display:none" />
        </div>
      </div>

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
        <div class="label">비밀번호 <span id="pwBadge" class="badge"><i class="fa-solid fa-circle-exclamation"></i> 사용불가</span></div>
        <div class="input-row">
          <input type="password" name="password" id="password" placeholder="비밀번호" required />
          <button type="button" class="btn-eye" onclick="togglePw('password','eye1')"><i id="eye1" class="fa-regular fa-eye"></i></button>
        </div>
      </div>

      <!-- 비밀번호 확인 -->
      <div class="field">
        <div class="label">비밀번호 확인 
          <span id="pwMatchBadge" class="badge">
            <i class="fa-solid fa-circle-exclamation"></i> 불일치
          </span>
        </div>
        <div class="input-row">
          <input type="password" name="password2" id="password2" placeholder="비밀번호 확인" required />
          <button type="button" class="btn-eye" onclick="togglePw('password2','eye2')"><i id="eye2" class="fa-regular fa-eye"></i></button>
        </div>
      </div>

      <!-- 휴대전화번호 -->
      <div class="field">
        <div class="label">휴대전화번호</div>
        <div class="input-row">
          <input type="text" name="phone" id="phone" placeholder="010-1234-5678" inputmode="numeric" maxlength="13" required  />
          <button type="button" class="btn-mini" onclick="checkPhone()">확인</button>
        </div>
      </div>

      <!-- 닉네임 -->
      <div class="field">
        <div class="label">닉네임</div>
        <div class="input-row">
          <input type="text" name="nickname" id="nickname" placeholder="닉네임"  required />
          <button type="button" class="btn-mini" onclick="checkNickname()">확인</button>
        </div>
      </div>

      <!-- 자기소개 -->
      <div class="field">
        <div class="label">자기소개</div>
        <div class="input-row" style="border-bottom:none; padding:0;">
          <textarea name="bio" id="bio" placeholder="간단한 자기소개를 입력해 주세요." required ></textarea>
        </div>
      </div>

      <ul class="notes">
        <li>비밀번호: 8~16자의 영문 대/소문자, 숫자, 특수문자를 사용해 주세요.</li>
      </ul>

      <div class="actions">
        <button type="submit" class="btn btn-primary">회원가입</button>
        <button type="button" class="btn btn-ghost" onclick="location.href='${pageContext.request.contextPath}/login.user'">취소</button>
      </div>
    </form>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
  // ===== 상태 플래그 & 마지막 검증값 =====
  let isIdOk=false, isNickOk=false, isPhoneOk=false, isPwOk=false, isPwMatch=false;
  const lastChecked={id:"",nick:"",phone:""};

  // ===== 유틸 =====
  const nz = v => (v||"").trim();
  const normalizePhone = v => (v||"").replace(/[^0-9]/g,"");
  function isValidPhoneRawDigits(d){ return /^010\d{8}$/.test(d); }
  function isValidPhoneDisplay(s){ return /^010-\d{4}-\d{4}$/.test(s); }

  // ===== 아바타 미리보기 & 기본 =====
  function setDefaultAvatar(){
    $("#avatarImg").attr("src","${pageContext.request.contextPath}/images/default-avatar.png");
    $("#avatarFile").val("");
  }
  $("#avatarFile").on("change", function(e){
    const file = e.target.files && e.target.files[0];
    if(!file) return;
    const r=new FileReader();
    r.onload = ev => $("#avatarImg").attr("src", ev.target.result);
    r.readAsDataURL(file);
  });

  // ===== 비밀번호 토글 =====
  function togglePw(inputId, eyeId){
    const $i=$("#"+inputId), $e=$("#"+eyeId);
    const toText = $i.attr("type")==="password";
    $i.attr("type", toText?"text":"password");
    $e.attr("class", toText?"fa-regular fa-eye-slash":"fa-regular fa-eye");
  }

  // ===== 휴대폰 입력 포맷 + IME 보호 =====
  let isComposingPhone = false;
  $("#phone")
    .on("compositionstart", ()=> isComposingPhone=true)
    .on("compositionend", function(){ isComposingPhone=false; formatPhoneAndInvalidate.call(this); })
    .on("input", function(){ if(!isComposingPhone) formatPhoneAndInvalidate.call(this); });

  function formatPhoneAndInvalidate(){
    let digits = normalizePhone($(this).val()).slice(0, 11);
    let display = digits;
    if (digits.length > 3 && digits.length <= 7) {
      display = digits.replace(/(\d{3})(\d{1,4})/, "$1-$2");
    } else if (digits.length > 7) {
      display = digits.replace(/(\d{3})(\d{4})(\d{1,4}).*/, "$1-$2-$3");
    }
    $(this).val(display);

    const curDigits = normalizePhone(display);
    if (curDigits !== lastChecked.phone) isPhoneOk=false;
  }

  // ===== 아이디/닉네임 입력 변경 시 플래그 무효화 =====
  $("#userId").on("input", function(){ if(nz(this.value)!==lastChecked.id) isIdOk=false; });
  $("#nickname").on("input", function(){ if(nz(this.value)!==lastChecked.nick) isNickOk=false; });

  // ===== 비밀번호 규칙/일치 =====
  const rule=/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,16}$/;
  function updatePwStrength(){
    isPwOk = rule.test($("#password").val());
    $("#pwBadge")
      .toggleClass("ok", isPwOk)
      .html(isPwOk?'<i class="fa-solid fa-circle-check"></i> 사용가능'
                  :'<i class="fa-solid fa-circle-exclamation"></i> 사용불가');
  }
  function updatePwMatch(){
    const v1=$("#password").val(), v2=$("#password2").val();
    isPwMatch = (v1.length>0 && v1===v2);
    $("#pwMatchBadge")
      .toggleClass("ok", isPwMatch)
      .html(isPwMatch?'<i class="fa-solid fa-circle-check"></i> 일치'
                     :'<i class="fa-solid fa-circle-exclamation"></i> 불일치');
  }
  $("#password, #password2").on("input", ()=>{ updatePwStrength(); updatePwMatch(); });

  // ===== 중복검사 AJAX =====
  function checkId(){
    const userId = nz($("#userId").val());
    if(!userId) return alert("아이디를 입력하세요.");
    $.getJSON("${pageContext.request.contextPath}/userIdDuplicatedCheck",{userId})
      .done(d=>{
        if(d.status==="ok"){ alert("사용 가능한 아이디입니다."); isIdOk=true; lastChecked.id=userId; }
        else { alert(d.msg||"이미 사용 중인 아이디입니다."); isIdOk=false; lastChecked.id=""; }
      })
      .fail(()=>alert("서버 통신 오류가 발생했습니다."));
  }

  function checkNickname(){
    const nickname = nz($("#nickname").val());
    if(!nickname) return alert("닉네임을 입력하세요.");
    $.getJSON("${pageContext.request.contextPath}/UserNicknameDuplicatedCheck",{nickname})
      .done(d=>{
        if(d.status==="ok"){ alert("사용 가능한 닉네임입니다."); isNickOk=true; lastChecked.nick=nickname; }
        else { alert(d.msg||"이미 사용 중인 닉네임입니다."); isNickOk=false; lastChecked.nick=""; }
      })
      .fail(()=>alert("서버 통신 오류가 발생했습니다."));
  }

  function checkPhone(){
    const display = $("#phone").val().trim();
    const raw = normalizePhone(display);
    if (!isValidPhoneRawDigits(raw)) {
      alert("휴대전화번호는 010-1234-5678 형식(총 11자리)으로 입력하세요.");
      isPhoneOk=false;
      return;
    }
    if (!isValidPhoneDisplay(display)) {
      $("#phone").val(raw.replace(/^(\d{3})(\d{4})(\d{4})$/, "$1-$2-$3"));
    }
    $.getJSON("${pageContext.request.contextPath}/UserPhoneNumberDuplicatedCheck",{ phone: raw })
      .done(d=>{
        if(d.status==="ok"){
          alert("사용 가능한 휴대전화번호입니다.");
          isPhoneOk=true; lastChecked.phone=raw;
        } else {
          alert(d.msg||"이미 사용 중인 휴대전화번호입니다.");
          isPhoneOk=false; lastChecked.phone="";
        }
      })
      .fail(()=>alert("서버 통신 오류가 발생했습니다."));
  }

  // export
  window.checkId=checkId; window.checkNickname=checkNickname; window.checkPhone=checkPhone;
  window.setDefaultAvatar=setDefaultAvatar; window.togglePw=togglePw;

  // 제출 가드
  $("form.card").on("submit", function(e){
    if(!(isIdOk && isNickOk && isPhoneOk && isPwOk && isPwMatch)){
      e.preventDefault();
      alert("중복 확인 및 비밀번호 검증을 완료하세요.");
    }
  });

  $(function(){ updatePwStrength(); updatePwMatch(); });
</script>

</body>
</html>
