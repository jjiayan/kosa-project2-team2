<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>내정보 수정</title>

  <style>
    :root{
      --ink:#111;
      --muted:#666;
      --line:#eee;
      --bg:#fafafa;
      --card:#fff;
      --brand:#ff6b6b;
      --brand-weak:#fff0f0;
      --brand-line:#f5b5b5;
      --radius:20px;
    }

    *{box-sizing:border-box}
    html,body{
      margin:0;padding:0;
      font-family:"Noto Sans KR",system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue","Apple SD Gothic Neo","Malgun Gothic",sans-serif;
      color:var(--ink);
      background:var(--bg);
    }

    .mypage-container{display:flex;min-height:100vh;background:var(--bg)}
    .mypage-content{flex:1;padding:32px 48px}
    @media (max-width:960px){.mypage-content{padding:24px}}

    .profile-edit-card{
      background:var(--card);
      border-radius:var(--radius);
      box-shadow:0 10px 30px rgba(0,0,0,.06);
      padding:28px;
      max-width:980px;            /* 카드 가로폭 */
      margin:0 auto;
    }

    .title-row{display:flex;align-items:center;gap:10px;margin-bottom:14px}
    .title-row h2{font-size:20px;margin:0}
    .hr{height:1px;background:var(--line);margin:14px 0}

    /* ===== 상단: 사진 + 폼 (가운데 몰고, 양쪽 여백) ===== */
    .profile-top{ }
    .profile-top-inner{
      display:flex;
      align-items:flex-start;         /* 위쪽 기준 */
      justify-content:center;         /* 가운데 정렬 */
      gap:56px;                       /* 사진과 폼 사이 간격 */
      width:100%;
      max-width:880px;                /* 중앙 컨텐츠 최대 폭 */
      margin:0 auto;                  /* 카드 안에서도 중앙 배치 */
      padding:0 48px;                 /* 좌우 거터 */
    }
    @media (max-width:1100px){
      .profile-top-inner{
        flex-direction:column;
        align-items:center;
        gap:24px;
        padding:0 16px;               /* 모바일 거터 */
        max-width:720px;
      }
    }

    /* 왼쪽: 사진 + 버튼(같은 라인) */
    .profile-edit-card .profile-image-box{
      position:relative;
      width:160px;
      flex:0 0 160px;
      display:flex;
      flex-direction:column;
      align-items:center;
    }
    .profile-edit-card #preview.avatar{
      width:100%;
      aspect-ratio:1/1;
      height:auto;
      max-height:180px;
      object-fit:cover;
      border-radius:50%;
      border:4px solid #eee;
      background:#fff;
      display:block;
      margin:0 0 8px 0;
    }
    .profile-edit-card .img-actions{
      display:flex;
      flex-wrap:nowrap;
      gap:6px;
      white-space:nowrap;
    }
    .profile-edit-card .img-btn{
      display:inline-block;
      padding:5px 8px;
      font-size:12px;
      border-radius:6px;
      border:1px solid #ddd;
      background:#f9f9f9;
      cursor:pointer;
      transition:background .15s,border .15s;
    }
    .profile-edit-card .img-btn:hover{border-color:var(--brand);background:#ffe8e8}

    /* 오른쪽: 폼 (폭 살짝 제한해서 입력칸 길이 짧아 보이게) */
    .form-side{
      flex:1 1 auto;
      display:flex;
      flex-direction:column;
      max-width:560px;                /* 폼 전체 폭 상한 */
    }
    .form-stack{
      display:flex;
      flex-direction:column;
      gap:12px;                       /* 닉네임/연락처/새비번/확인 간격 통일 */
    }
    .form-grid{
      display:grid;
      grid-template-columns:110px 1fr; /* 라벨/입력 비율 유지 */
      align-items:center;
      gap:8px 12px;
      margin:0;
    }
    .form-grid label{font-size:14px;color:#333}
    .input{
      width:100%;
      max-width:420px;                /* 개별 입력칸 상한 */
      padding:10px 12px;border-radius:10px;
      border:1px solid var(--brand-line);background:var(--brand-weak);
      outline:none;transition:.15s;font-size:15px;
    }
    .input:focus{
      box-shadow:0 0 0 3px rgba(255,107,107,.18);
      background:#fff;border-color:#ffc3c3;
    }

    /* ===== 자기소개 (손대지 않음) ===== */
    .bio-block{ margin-top:16px }
    .bio-block label{
      display:block;
      margin-bottom:6px;
      font-size:14px;
      color:#333;
    }
    .textarea{
      width:100%;
      min-height:140px;resize:vertical;
      padding:10px 12px;border-radius:10px;
      border:1px solid var(--brand-line);background:var(--brand-weak);
      outline:none;transition:.15s;font-size:15px;
    }
    .textarea:focus{
      box-shadow:0 0 0 3px rgba(255,107,107,.18);
      background:#fff;border-color:#ffc3c3;
    }

    .btn-row{display:flex;justify-content:flex-end;gap:10px;margin-top:20px}
    .btn{padding:10px 16px;border:none;border-radius:10px;font-size:15px;cursor:pointer}
    .btn.secondary{background:#eee}
    .btn.primary{background:#ff6b6b;color:#fff}
    .btn.primary:hover{filter:brightness(.96)}

    .with-sidebar .mypage-content{padding-left:24px}
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

        <form id="profileForm" action="${ctx}/mypage/update.user"
              method="post" enctype="multipart/form-data" novalidate>

          <!-- 상단: 사진 + 폼 (가운데 + 양쪽 여백, 간격 확대) -->
          <div class="profile-top">
            <div class="profile-top-inner">
              <!-- 왼쪽: 사진 + 버튼 -->
              <div class="profile-image-box">
                <!-- ★ null/빈값이면 기본 이미지, 실패시에도 onerror로 기본 이미지 -->
                <img
                  id="preview"
                  class="avatar"
                  src="${empty user.user_photo ? ctx.concat('/images/default-avatar.png') : user.user_photo}"
                  alt="프로필 이미지"
                  onerror="this.onerror=null; this.src='${ctx}/images/default-avatar.png';"
                />

                <div class="img-actions">
                  <button type="button" class="img-btn" id="defaultImgBtn">기본 이미지</button>
                  <button type="button" class="img-btn" id="addImgBtn">이미지 추가</button>
                </div>
                <input type="file" id="imgInput" name="profileImage" accept="image/*" hidden />
              </div>

              <!-- 오른쪽: 폼 (폭 살짝 제한) -->
              <div class="form-side">
                <div class="form-stack">
                  <div class="form-grid">
                    <label for="nickname">닉네임</label>
                    <input id="nickname" name="nickname" class="input" type="text"
                           placeholder="닉네임을 입력하세요" value="${user.user_nickname}" required />
                  </div>

                  <div class="form-grid">
                    <label for="phone">연락처</label>
                    <input id="phone" name="phone" class="input" type="tel" inputmode="numeric"
                           placeholder="010-0000-0000" value="${user.user_phonenumber}" />
                  </div>

                  <div class="form-grid">
                    <label for="newPassword">새 비밀번호(선택)</label>
                    <input id="newPassword" name="newPassword" class="input" type="password" placeholder="새 비밀번호" />
                  </div>

                  <div class="form-grid">
                    <label for="confirmPassword">비밀번호 확인</label>
                    <input id="confirmPassword" name="confirmPassword" class="input" type="password" placeholder="비밀번호 확인" />
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="hr"></div>

          <!-- 자기소개 (그대로) -->
          <div class="bio-block">
            <label for="bio">자기소개</label>
            <textarea id="bio" name="bio" class="textarea"
                      placeholder="간단한 소개를 적어주세요.">${user.user_bio}</textarea>
          </div>

          <div class="btn-row">
            <button type="button" class="btn secondary" id="cancelBtn">취소</button>
            <button type="submit" class="btn primary" id="saveBtn">저장하기</button>
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
      const form = document.getElementById("profileForm");
      const cancelBtn = document.getElementById("cancelBtn");

      // 이미지 선택 → 미리보기
      addImgBtn.addEventListener("click", () => imgInput.click());
      imgInput.addEventListener("change", (e) => {
        const file = e.target.files && e.target.files[0];
        if(!file) return;
        const reader = new FileReader();
        reader.onload = (ev) => (preview.src = ev.target.result);
        reader.readAsDataURL(file);
      });

      // 기본 이미지로 변경
      defaultImgBtn.addEventListener("click", () => {
        preview.src = ctx + "/images/default-avatar.png";
        imgInput.value = "";
      });

      // 취소 → 이전페이지 또는 홈
      cancelBtn.addEventListener("click", () => {
        if (document.referrer) history.back();
        else location.href = ctx + "/index.user";
      });

      // 비밀번호 간단 검증
      form.addEventListener("submit", (e) => {
        const pw = document.getElementById("newPassword").value;
        const pw2 = document.getElementById("confirmPassword").value;

        if (pw || pw2){
          if (pw.length < 8){
            e.preventDefault(); alert("새 비밀번호는 8자 이상으로 설정해주세요."); return;
          }
          if (pw !== pw2){
            e.preventDefault(); alert("비밀번호 확인이 일치하지 않습니다."); return;
          }
        }
      });

      // 연락처 자동 포맷팅
      const phone = document.getElementById("phone");
      phone.addEventListener("input", () => {
        const digits = phone.value.replace(/\D/g,"").slice(0,11);
        let out = digits;
        if (digits.length >= 11) out = digits.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");
        else if (digits.length >= 7) out = digits.replace(/(\d{3})(\d{3,4})/, "$1-$2");
        phone.value = out;
      });
    })();
  </script>
</body>
</html>
