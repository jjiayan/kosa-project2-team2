<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>내정보 수정</title>

  <style>
  :root{
    --ink:#111; --muted:#666; --line:#eee; --bg:#fafafa; --card:#fff;
    --brand:#ff6b6b; --brand-weak:#fff0f0; --brand-line:#f5b5b5; --radius:20px;
    --label:110px; --gap:12px; --field-width:420px; --photo:160px; --between:56px;
  }
  *{box-sizing:border-box}
  html,body{margin:0;padding:0;font-family:"Noto Sans KR",system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue","Apple SD Gothic Neo","Malgun Gothic",sans-serif;color:var(--ink);background:var(--bg)}
  .mypage-container{display:flex;min-height:100vh;background:var(--bg)}
  .mypage-content{flex:1;padding:32px 48px}
  @media (max-width:960px){.mypage-content{padding:24px}}

  .profile-edit-card{background:var(--card); border-radius:var(--radius); box-shadow:0 10px 30px rgba(0,0,0,.06); padding:28px; max-width:980px; margin:0 auto;}
  .title-row{display:flex;align-items:center;gap:10px;margin-bottom:14px}
  .title-row h2{font-size:20px;margin:0}
  .hr{height:1px;background:var(--line);margin:14px 0}

  .profile-top-inner{display:flex; align-items:flex-start; justify-content:center; gap:56px; width:100%; max-width:880px; margin:0 auto; padding:0 48px;}
  @media (max-width:1100px){.profile-top-inner{flex-direction:column;align-items:center;gap:24px;padding:0 16px;max-width:720px}}

  .profile-image-box{position:relative; width:var(--photo); flex:0 0 var(--photo); display:flex; flex-direction:column; align-items:center;}
  #preview.avatar{width:100%; aspect-ratio:1/1; height:auto; max-height:180px; object-fit:cover; border-radius:50%; border:4px solid #eee; background:#fff; display:block; margin:0 0 8px 0;}
  .img-actions{display:flex; gap:6px; white-space:nowrap;}
  .img-btn{display:inline-block; padding:5px 8px; font-size:12px; border-radius:6px; border:1px solid #ddd; background:#f9f9f9; cursor:pointer; transition:background .15s,border .15s;}
  .img-btn:hover{border-color:var(--brand);background:#ffe8e8}

  .form-side{flex:1 1 auto; display:flex; flex-direction:column; max-width:560px}
  .form-stack{display:flex; flex-direction:column; gap:12px}
  .form-grid{display:grid; grid-template-columns:var(--label) 1fr; align-items:center; gap:8px var(--gap); margin:0}
  .form-grid label{font-size:14px;color:#333}

  .field-wrap{position:relative; width:var(--field-width);}
  .input{width:100%; padding:10px 88px 10px 12px; border-radius:10px; border:1px solid var(--brand-line); background:var(--brand-weak); outline:none; transition:.15s; font-size:15px;}
  .input:focus{box-shadow:0 0 0 3px rgba(255,107,107,.18); background:#fff; border-color:#ffc3c3}
  .inline-edit-btn{position:absolute; right:8px; top:50%; transform:translateY(-50%); height:30px; padding:0 10px; border:1px solid #ddd; border-radius:8px; background:#fff; font-size:12px; cursor:pointer;}
  .inline-edit-btn:hover{border-color:#bbb}

  .below-inner{width:100%; max-width:880px; margin:0 auto; padding:0 48px;}
  @media (max-width:1100px){ .below-inner{padding:0 16px; max-width:720px} }
  .bio-block{margin-top:12px; width: calc(var(--photo) + var(--between) + var(--label) + var(--gap) + var(--field-width));}
  .bio-block label{display:block;margin-bottom:6px;font-size:14px;color:#333}
  .textarea{width:100%; max-width:none; min-height:140px; resize:vertical; padding:10px 12px; border-radius:10px; border:1px solid var(--brand-line); background:var(--brand-weak); outline:none; transition:.15s; font-size:15px;}
  .textarea:focus{box-shadow:0 0 0 3px rgba(255,107,107,.18); background:#fff; border-color:#ffc3c3}

  .btn-row{display:flex; justify-content:flex-end; gap:10px; margin-top:12px; width: var(--field-width); margin-left: calc(var(--photo) + var(--between) + var(--label) + var(--gap));}
  .btn{padding:10px 16px; border:none; border-radius:10px; font-size:15px; cursor:pointer}
  .btn.secondary{background:#eee}
  .btn.primary{background:#ff6b6b; color:#fff}
  .btn.primary:hover{filter:brightness(.96)}

  .with-sidebar .mypage-content{padding-left:24px}

  @media (max-width:720px){
    .form-side{max-width:none}
    .field-wrap{width:100%}
    .input{padding-right:88px}
    .bio-block{width:100%}
    .btn-row{width:100%; margin-left:0}
  }
  </style>
</head>
<body>

  <jsp:include page="/include/nav.jsp" />

  <div class="mypage-container with-sidebar">
    <jsp:include page="/include/mypageSidebar.jsp">
      <jsp:param name="current" value="edit"/>
    </jsp:include>

    <main class="mypage-content">
      <section class="profile-edit-card" aria-labelledby="mypage-title">
        <div class="title-row">
          <h2 id="mypage-title">내정보 수정</h2>
        </div>
        <div class="hr"></div>

        <c:set var="user" value="${sessionScope.LOGIN_USER}" />
        <c:set var="ctx" value="${pageContext.request.contextPath}" />

        <%-- 안전한 초기 프로필 이미지 URL 생성 --%>
        <c:set var="rawPhoto" value="${user.user_photo}" />
        <c:choose>
          <c:when test="${empty rawPhoto}">
            <c:set var="editPhotoUrl" value="${ctx}/images/default-avatar.png"/>
          </c:when>
          <c:when test="${fn:startsWith(rawPhoto,'http://') or fn:startsWith(rawPhoto,'https://')}">
            <c:set var="editPhotoUrl" value="${rawPhoto}"/>
          </c:when>
          <c:when test="${fn:startsWith(rawPhoto,'/files/')}">
            <c:set var="editPhotoUrl" value="${ctx}${rawPhoto}"/>
          </c:when>
          <c:otherwise>
            <c:set var="editPhotoUrl" value="${ctx}/${rawPhoto}"/>
          </c:otherwise>
        </c:choose>

        <form id="profileForm" action="${ctx}/mypage/editOk.user"
              method="post" enctype="multipart/form-data" novalidate>

          <input type="hidden" name="resetPhoto" id="resetPhoto" value="0"/>

          <div class="profile-top">
            <div class="profile-top-inner">
              <div class="profile-image-box">
                <img id="preview" class="avatar"
                     src="${editPhotoUrl}"
                     alt="프로필 이미지"
                     onerror="this.onerror=null; this.src='${ctx}/images/default-avatar.png';" />
                <div class="img-actions">
                  <button type="button" class="img-btn" id="defaultImgBtn">기본 이미지</button>
                  <button type="button" class="img-btn" id="addImgBtn">이미지 추가</button>
                </div>
                <input type="file" id="imgInput" name="profileImage" accept="image/*" hidden />
              </div>

              <div class="form-side">
                <div class="form-stack">
                  <div class="form-grid">
                    <label for="nickname">닉네임</label>
                    <div class="field-wrap">
                      <input id="nickname" name="nickname" class="input" type="text"
                             placeholder="닉네임을 입력하세요" value="${user.user_nickname}" required />
                      <button type="button" class="inline-edit-btn" id="editNickBtn">수정</button>
                    </div>
                  </div>

                  <div class="form-grid">
                    <label for="phone">연락처</label>
                    <div class="field-wrap">
                      <input id="phone" name="phone" class="input" type="tel" inputmode="numeric"
                             placeholder="010-0000-0000" value="${user.user_phonenumber}" />
                      <button type="button" class="inline-edit-btn" id="editPhoneBtn">수정</button>
                    </div>
                  </div>

                  <!-- ✅ 연령대 선택 -->
                  <div class="form-grid">
                    <label for="ageGroup">연령대</label>
                    <div class="field-wrap">
                      <select id="ageGroup" name="ageGroup" class="input" required>
                        <option value="0" ${user.age_group == 0 ? "selected" : ""} disabled>선택</option>
                        <option value="10" ${user.age_group == 10 ? "selected" : ""}>10대</option>
                        <option value="20" ${user.age_group == 20 ? "selected" : ""}>20대</option>
                        <option value="30" ${user.age_group == 30 ? "selected" : ""}>30대</option>
                        <option value="40" ${user.age_group == 40 ? "selected" : ""}>40대</option>
                        <option value="50" ${user.age_group == 50 ? "selected" : ""}>50대</option>
                      </select>
                    </div>
                  </div>
                  <!-- /연령대 -->

                  <div class="form-grid">
                    <label for="newPassword">새 비밀번호(선택)</label>
                    <div class="field-wrap">
                      <input id="newPassword" name="newPassword" class="input" type="password" placeholder="새 비밀번호" />
                    </div>
                  </div>

                  <div class="form-grid">
                    <label for="confirmPassword">비밀번호 확인</label>
                    <div class="field-wrap">
                      <input id="confirmPassword" name="confirmPassword" class="input" type="password" placeholder="비밀번호 확인" />
                    </div>
                  </div>
                </div>
              </div>

            </div>
          </div>

          <div class="hr"></div>

          <div class="below-inner">
            <div class="bio-block">
              <label for="bio">자기소개</label>
              <textarea id="bio" name="bio" class="textarea"
                        placeholder="간단한 소개를 적어주세요.">${user.user_bio}</textarea>
            </div>

            <div class="btn-row">
              <button type="button" class="btn secondary" id="cancelBtn">취소</button>
              <button type="submit" class="btn primary" id="saveBtn">저장하기</button>
            </div>
          </div>
        </form>
      </section>
    </main>
  </div>

  <script>
(function(){
  const ctx = "${pageContext.request.contextPath}";
  const imgInput = document.getElementById("imgInput");
  const preview = document.getElementById("preview");
  const addImgBtn = document.getElementById("addImgBtn");
  const defaultImgBtn = document.getElementById("defaultImgBtn");
  const resetPhoto = document.getElementById("resetPhoto");
  const form = document.getElementById("profileForm");
  const cancelBtn = document.getElementById("cancelBtn");

  const editNickBtn  = document.getElementById("editNickBtn");
  const editPhoneBtn = document.getElementById("editPhoneBtn");
  const nicknameEl   = document.getElementById("nickname");
  const phoneEl      = document.getElementById("phone");

  // 이미지 선택/미리보기
  addImgBtn.addEventListener("click", () => imgInput.click());
  imgInput.addEventListener("change", (e) => {
    const file = e.target.files && e.target.files[0];
    if(!file) return;
    const reader = new FileReader();
    reader.onload = (ev) => (preview.src = ev.target.result);
    reader.readAsDataURL(file);
    resetPhoto.value = "0";
  });

  // 기본 이미지로 변경
  defaultImgBtn.addEventListener("click", () => {
    preview.src = ctx + "/images/default-avatar.png";
    imgInput.value = "";
    resetPhoto.value = "1";
  });

  // 취소
  cancelBtn.addEventListener("click", () => {
    if (document.referrer) history.back();
    else location.href = ctx + "/index.user";
  });

  // 비밀번호 규칙 체크
  form.addEventListener("submit", (e) => {
    const pw  = document.getElementById("newPassword").value.trim();
    const pw2 = document.getElementById("confirmPassword").value.trim();
    if (pw || pw2){
      const rule = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,16}$/;
      if (!rule.test(pw)){
        e.preventDefault(); alert("비밀번호는 8~16자의 영문 대/소문자, 숫자, 특수문자를 모두 포함해야 합니다."); return;
      }
      if (pw !== pw2){
        e.preventDefault(); alert("비밀번호 확인이 일치하지 않습니다."); return;
      }
    }
  });

  // 연락처 포맷 (010 입력 즉시 하이픈)
  function formatPhone(v){
    let d = (v||"").replace(/\D/g,"").slice(0,11);
    if (d.startsWith("010")){
      if (d.length <= 3) return d;
      if (d.length <= 7) return d.replace(/(\d{3})(\d{1,4})/, "$1-$2");
      return d.replace(/(\d{3})(\d{4})(\d{1,4})/, "$1-$2-$3");
    }else{
      if (d.length <= 7) return d;
      return d.replace(/(\d{3,4})(\d{1,4})/, "$1-$2");
    }
  }
  phoneEl.value = formatPhone(phoneEl.value);
  phoneEl.addEventListener("input", () => {
    const caretEnd = phoneEl.selectionEnd;
    const before = phoneEl.value;
    phoneEl.value = formatPhone(phoneEl.value);
    const delta = phoneEl.value.length - before.length;
    phoneEl.setSelectionRange(caretEnd + delta, caretEnd + delta);
  });

  // 닉네임 인라인 수정 → 중복검사 후 저장
  editNickBtn.addEventListener("click", async () => {
    const nickname = (nicknameEl.value || "").trim();
    if (!nickname) { alert("닉네임을 입력하세요."); nicknameEl.focus(); return; }
    try{
      const url = ctx + "/UserNicknameDuplicatedCheck?nickname=" + encodeURIComponent(nickname);
      const res = await fetch(url);
      const data = await res.json();
      if (data.status === "ok") {
        form.submit();
      } else if (data.status === "duplicate") {
        alert(data.msg || "이미 사용 중인 닉네임입니다.");
        nicknameEl.focus();
      } else {
        alert(data.msg || "닉네임 확인 중 오류가 발생했습니다.");
      }
    }catch(err){
      console.error(err);
      alert("서버 통신 오류가 발생했습니다.");
    }
  });

  // 연락처 인라인 수정 → 형식/중복검사 후 저장
  editPhoneBtn.addEventListener("click", async () => {
    const display = phoneEl.value.trim();
    const raw = display.replace(/\D/g,"");
    if (!/^010\d{8}$/.test(raw)){
      alert("휴대전화번호는 010-1234-5678 형식(총 11자리)으로 입력하세요.");
      phoneEl.focus(); return;
    }
    try{
      const url = ctx + "/UserPhoneNumberDuplicatedCheck?phone=" + encodeURIComponent(raw);
      const res = await fetch(url);
      const data = await res.json();
      if (data.status === "ok") {
        form.submit();
      } else if (data.status === "duplicate") {
        alert(data.msg || "이미 사용 중인 전화번호입니다.");
        phoneEl.focus();
      } else {
        alert(data.msg || "전화번호 확인 중 오류가 발생했습니다.");
      }
    }catch(err){
      console.error(err);
      alert("서버 통신 오류가 발생했습니다.");
    }
  });

})();
  </script>
</body>
</html>
