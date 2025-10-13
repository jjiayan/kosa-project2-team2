<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Header</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css">

<style>
  :root {
    --ink: #111;
    --muted: #555;
    --ring: #ddd;
    --bg: #fff;
    --ring-dark: #555;
  }

  * { box-sizing: border-box; }
  html, body {
    margin: 0; padding: 0;
    overflow-x: hidden;
    background: var(--bg);
    color: var(--ink);
    font-family: "Noto Sans KR","Pretendard",sans-serif;
  }

  header {
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12px 24px;
    border-bottom: 1px solid var(--ring);
    position: relative;
  }

  .left, .center, .right { min-width: 0; }

  /* 로고 영역 */
  .logo {
    display: inline-flex;
    flex-direction: column;
    align-items: flex-start;
    row-gap: 4px;
    letter-spacing: 2px;
    font-size: 14px;
    text-decoration: none;
    color: var(--ink);
  }
  .logo:hover { color: var(--muted); }
  .logo .barcode {
    width: 100%;
    height: 24px;
    object-fit: cover;
    display: block;
  }
  .logo .wordmark { font-weight: 400; }
  .logo .wordmark span { font-weight: 600; font-size: 20px; }

  /* 중앙 메뉴 */
  .center {
    flex: 1;
    display: flex;
    justify-content: center;
    padding: 0 8px;
  }
  .menu {
    display: flex;
    align-items: center;
    gap: 10px;
    border: 1.5px solid var(--ring-dark);
    border-radius: 999px;
    padding: 4px 18px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.08);
    background: var(--bg);
    max-width: 60vw;
    overflow-x: auto;
    -ms-overflow-style: none;
    scrollbar-width: none;
  }
  .menu::-webkit-scrollbar { display: none; }
  .menu a, .mobile-menu a {
    padding: 6px 12px;
    font-size: 15px;
    display: flex;
    align-items: center;
    gap: 6px;
    color: var(--ink);
    white-space: nowrap;
    text-decoration: none;
    transition: color .15s ease, transform .15s ease;
  }
  .menu a:hover, .mobile-menu a:hover {
    transform: translateY(-1px);
    color: var(--muted);
  }

  /* 오른쪽 */
  .right {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-shrink: 0;
  }

  .login a {
    display: flex;
    align-items: center;
    gap: 6px;
    color: var(--ink);
    text-decoration: none;
    font-size: 15px;
  }
  .login a:hover { color: var(--muted); }

  .userbox {
    display: flex;
    align-items: center;
    gap: 10px;
    border: 1px solid var(--ring);
    border-radius: 999px;
    padding: 6px 10px;
    background: #fff;
  }
  .avatar {
    width: 26px; height: 26px; border-radius: 50%;
    object-fit: cover;
    background: #f3f4f6;
  }
  .hello {
    font-size: 14px;
    max-width: 180px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .logout {
    margin-left: 6px;
    font-size: 13px;
    color: #444;
    text-decoration: none;
    border: 1px solid var(--ring);
    border-radius: 999px;
    padding: 4px 8px;
  }
  .logout:hover { background: #f7f7f7; }

  .hamburger {
    display: none;
    cursor: pointer;
    font-size: 22px;
    background: none;
    border: 0;
  }

  /* 모바일 메뉴 */
  .mobile-menu {
    display: none;
    flex-direction: column;
    position: absolute;
    left: 0; top: 100%;
    width: 100%;
    background: var(--bg);
    border-top: 1px solid var(--ring);
    padding: 8px 12px;
    z-index: 10;
    animation: fadeIn .25s ease;
  }
  .mobile-menu a {
    width: 100%;
    padding: 12px;
    border-radius: 10px;
  }
  .mobile-menu a:hover { background: #f7f7f7; }

  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(-6px); }
    to { opacity: 1; transform: translateY(0); }
  }

  @media (max-width: 900px) {
    .menu { max-width: 70vw; }
  }
  @media (max-width: 768px) {
    .center { display: none; }
    .hamburger { display: block; }
    header { padding: 12px 16px; }
    .hello { max-width: 120px; }
  }
</style>
</head>
<body>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<header>
  <a href="${ctx}/index.user" class="left logo" id="logoArea">
    <img class="barcode" src="${ctx}/images/barcode.jpg" alt="바코드">
    <div class="wordmark">Cer : <span id="bibleText">BIBLE</span></div>
  </a>

  <div class="center">
    <nav class="menu">
      <a href="${ctx}/study.do"><i class="fa-regular fa-comments"></i>스터디</a>
      <a href="${ctx}/license.do"><i class="fa-regular fa-calendar"></i>자격증</a>
      <a href="${ctx}/notice.do"><i class="fa-solid fa-bullhorn"></i>공지</a>
    </nav>
  </div>

  <div class="right">
    <c:choose>
      <c:when test="${not empty sessionScope.LOGIN_USER}">
        <c:set var="displayName"
               value="${empty sessionScope.LOGIN_USER.user_nickname ? sessionScope.LOGIN_USER.user_login_id : sessionScope.LOGIN_USER.user_nickname}" />
        <div class="userbox">
          <c:choose>
            <c:when test="${not empty sessionScope.LOGIN_USER.user_photo}">
              <img class="avatar"
                   src="<c:url value='${sessionScope.LOGIN_USER.user_photo}'/>"
                   alt="avatar"
                   onerror="this.style.display='none'; this.nextElementSibling.style.display='inline-block';">
            </c:when>
            <c:otherwise>
              <i class="fa-regular fa-user" style="font-size:18px;"></i>
            </c:otherwise>
          </c:choose>

          <span class="hello"><b>${displayName}</b> 님</span>
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
    <a href="${ctx}/study.do"><i class="fa-regular fa-comments"></i>스터디</a>
    <a href="${ctx}/license.do"><i class="fa-regular fa-calendar"></i>자격증</a>
    <a href="${ctx}/notice.do"><i class="fa-solid fa-bullhorn"></i>공지</a>
    <c:choose>
      <c:when test="${not empty sessionScope.LOGIN_USER}">
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
