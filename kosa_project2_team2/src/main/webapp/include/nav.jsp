<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Header</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css">

<style>
  :root { --ink:#111; --muted:#555; --ring:#ddd; --bg:#fff; --ring-dark:#555; }
  *{ box-sizing:border-box; }
  html,body{ margin:0; padding:0; overflow-x:hidden; background:var(--bg); color:var(--ink); font-family:"Noto Sans KR","Pretendard",sans-serif; }

  /* ====== 여기부터 nav 전용 네임스페이스 ====== */
  .nav-root{ width:100%; display:flex; align-items:center; justify-content:space-between; padding:12px 24px; border-bottom:1px solid var(--ring); position:relative; }
  .nav-root .left,.nav-root .center,.nav-root .right{ min-width:0; }

  .nav-root .logo{ display:inline-flex; flex-direction:column; align-items:flex-start; row-gap:4px; letter-spacing:2px; font-size:14px; text-decoration:none; color:var(--ink); }
  .nav-root .logo:hover{ color:var(--muted); }
  .nav-root .logo .barcode{ width:100%; height:24px; object-fit:cover; display:block; }
  .nav-root .logo .wordmark{ font-weight:400; }
  .nav-root .logo .wordmark span{ font-weight:600; font-size:20px; }

  .nav-root .center{ flex:1; display:flex; justify-content:center; padding:0 8px; }
  .nav-root .menu{ display:flex; align-items:center; gap:10px; border:1.5px solid var(--ring-dark); border-radius:999px; padding:4px 18px; box-shadow:0 2px 5px rgba(0,0,0,.08); background:var(--bg); max-width:60vw; overflow-x:auto; -ms-overflow-style:none; scrollbar-width:none; }
  .nav-root .menu::-webkit-scrollbar{ display:none; }
  .nav-root .menu a,.nav-root .mobile-menu a{ padding:6px 12px; font-size:15px; display:flex; align-items:center; gap:6px; color:var(--ink); white-space:nowrap; text-decoration:none; transition:color .15s, transform .15s; }
  .nav-root .menu a:hover,.nav-root .mobile-menu a:hover{ transform:translateY(-1px); color:var(--muted); }

  .nav-root .right{ display:flex; align-items:center; gap:10px; flex-shrink:0; }
  .nav-root .login a{ display:flex; align-items:center; gap:6px; color:var(--ink); text-decoration:none; font-size:15px; }
  .nav-root .login a:hover{ color:var(--muted); }

  .nav-root .userbox{ display:flex; align-items:center; gap:10px; border:1px solid var(--ring); border-radius:999px; padding:6px 10px; background:#fff; }
  .nav-root .avatar{ width:26px; height:26px; border-radius:50%; object-fit:cover; background:#f3f4f6; }
  .nav-root .hello{ font-size:14px; max-width:180px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  .nav-root .logout{ margin-left:6px; font-size:13px; color:#444; text-decoration:none; border:1px solid var(--ring); border-radius:999px; padding:4px 8px; }
  .nav-root .logout:hover{ background:#f7f7f7; }

  .nav-root .hamburger{ display:none; cursor:pointer; font-size:22px; background:none; border:0; }

  .nav-root .mobile-menu{ display:none; flex-direction:column; position:absolute; left:0; top:100%; width:100%; background:var(--bg); border-top:1px solid var(--ring); padding:8px 12px; z-index:10; animation:fadeIn .25s ease; }
  .nav-root .mobile-menu a{ width:100%; padding:12px; border-radius:10px; }
  .nav-root .mobile-menu a:hover{ background:#f7f7f7; }

  @keyframes fadeIn{ from{opacity:0; transform:translateY(-6px);} to{opacity:1; transform:translateY(0);} }

  @media (max-width:900px){ .nav-root .menu{ max-width:70vw; } }
  @media (max-width:768px){
    .nav-root .center{ display:none; }
    .nav-root{ padding:12px 16px; }
    .nav-root .hamburger{ display:block; }
    .nav-root .hello{ max-width:120px; }
  }
  /* ====== nav 네임스페이스 끝 ====== */
</style>
</head>
<body>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%-- 안전한 유저 아바타 URL 생성 --%>
<c:set var="rawPhoto" value="${sessionScope.LOGIN_USER.user_photo}" />
<c:choose>
  <c:when test="${empty rawPhoto}"><c:set var="navPhotoUrl" value="${ctx}/images/default-avatar.png"/></c:when>
  <c:when test="${fn:startsWith(rawPhoto,'http://') or fn:startsWith(rawPhoto,'https://')}"><c:set var="navPhotoUrl" value="${rawPhoto}"/></c:when>
  <c:when test="${fn:startsWith(rawPhoto,'/files/')}"><c:set var="navPhotoUrl" value="${ctx}${rawPhoto}"/></c:when>
  <c:otherwise><c:set var="navPhotoUrl" value="${ctx}/${rawPhoto}"/></c:otherwise>
</c:choose>

<header class="nav-root">
  <a href="${ctx}/index.user" class="left logo" id="logoArea">
    <img class="barcode" src="${ctx}/images/barcode.jpg" alt="바코드">
    <div class="wordmark">Cer : <span id="bibleText">BIBLE</span></div>
  </a>

  <div class="center">
    <nav class="menu">
      <a href="${ctx}/roomlist.room"><i class="fa-regular fa-comments"></i>스터디</a>
      <a href="${ctx}/certificationList.cert"><i class="fa-regular fa-calendar"></i>자격증</a>
      <a href="${ctx}/adminNotice.admin"><i class="fa-solid fa-bullhorn"></i>공지</a>
    </nav>
  </div>

  <div class="right">
    <c:choose>
      <c:when test="${not empty sessionScope.LOGIN_USER}">
        <c:set var="displayName" value="${empty sessionScope.LOGIN_USER.user_nickname ? sessionScope.LOGIN_USER.user_login_id : sessionScope.LOGIN_USER.user_nickname}" />
        <div class="userbox">
          <c:choose>
            <c:when test="${sessionScope.LOGIN_USER.user_status eq 'ADMIN'}">
              <a href="${ctx}/adminMember.admin" style="display:flex;align-items:center;gap:10px;text-decoration:none;color:inherit;">
                <img class="avatar" src="${navPhotoUrl}" alt="avatar" onerror="this.onerror=null; this.src='${ctx}/images/default-avatar.png';">
                <span class="hello"><b>${displayName}</b> 님</span>
              </a>
            </c:when>
            <c:otherwise>
              <a href="${ctx}/mypage/edit.user" style="display:flex;align-items:center;gap:10px;text-decoration:none;color:inherit;">
                <img class="avatar" src="${navPhotoUrl}" alt="avatar" onerror="this.onerror=null; this.src='${ctx}/images/default-avatar.png';">
                <span class="hello"><b>${displayName}</b> 님</span>
              </a>
            </c:otherwise>
          </c:choose>
          <a class="logout" href="${ctx}/logout.user">로그아웃</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="login">
          <a href="${ctx}/login.user">
            <span>로그인</span>
            <i class="fa-regular fa-user"></i>
          </a>
        </div>
      </c:otherwise>
    </c:choose>

    <button class="hamburger" onclick="toggleMenu()">
      <i class="fa-solid fa-bars"></i>
    </button>
  </div>

  <nav id="mobileMenu" class="mobile-menu" aria-hidden="true">
    <a href="${ctx}/roomlist.room"><i class="fa-regular fa-comments"></i>스터디</a>
    <a href="${ctx}/certificationList.cert"><i class="fa-regular fa-calendar"></i>자격증</a>
    <a href="${ctx}/adminNotice.admin"><i class="fa-solid fa-bullhorn"></i>공지</a>

    <c:choose>
      <c:when test="${not empty sessionScope.LOGIN_USER}">
        <a href="${ctx}/mypage/edit.user"><i class="fa-regular fa-user"></i>마이페이지</a>
        <a href="${ctx}/logout.user"><i class="fa-solid fa-right-from-bracket"></i>로그아웃</a>
      </c:when>
      <c:otherwise>
        <a href="${ctx}/login.user"><i class="fa-regular fa-user"></i>로그인</a>
      </c:otherwise>
    </c:choose>
  </nav>
</header>

<script>
  function syncBarcodeToLogo() {
    const logo = document.getElementById('logoArea');
    const barcode = document.querySelector('.barcode');
    if (logo && barcode) barcode.style.width = logo.offsetWidth + 'px';
  }
  window.addEventListener('load', syncBarcodeToLogo);
  window.addEventListener('resize', () => {
    clearTimeout(window.__resizeTimer);
    window.__resizeTimer = setTimeout(syncBarcodeToLogo, 100);
  });

  function toggleMenu() {
    const m = document.getElementById('mobileMenu');
    const opened = m.style.display === 'flex';
    m.style.display = opened ? 'none' : 'flex';
    m.setAttribute('aria-hidden', opened ? 'true' : 'false');
  }
  const mq = window.matchMedia('(min-width: 769px)');
  mq.addEventListener('change', e => {
    if (e.matches) {
      const m = document.getElementById('mobileMenu');
      if (m) m.style.display = 'none';
    }
  });
</script>

</body>
</html>
