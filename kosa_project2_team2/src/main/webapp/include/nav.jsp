<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Header</title>

<!-- Font Awesome (아이콘용) -->
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

  /* ===== 로고 영역 ===== */
  .logo {
    display: inline-flex;
    flex-direction: column;
    align-items: flex-start;
    row-gap: 4px;
    white-space: nowrap;
    letter-spacing: 2px;
    font-size: 14px;
    position: relative;
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

  /* ===== 중앙 메뉴 ===== */
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

  /* ===== 오른쪽 ===== */
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

  .login i { font-size: 17px; }

  .hamburger {
    display: none;
    cursor: pointer;
    font-size: 22px;
    background: none;
    border: 0;
  }

  /* ===== 모바일 메뉴 ===== */
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
  }
</style>
</head>
<body>

<header>
  <!-- 왼쪽 로고: 클릭 시 index.jsp로 이동 -->
  <a href="${pageContext.request.contextPath}/index.user" class="left logo" id="logoArea">
    <img class="barcode" src="${pageContext.request.contextPath}/images/barcode.jpg" alt="바코드">
    <div class="wordmark">Cer : <span id="bibleText">BIBLE</span></div>
  </a>

  <!-- 중앙 메뉴 -->
  <div class="center">
    <nav class="menu" aria-label="주요 메뉴">
      <a href="${pageContext.request.contextPath}/study.do"><i class="fa-regular fa-comments"></i>스터디</a>
      <a href="${pageContext.request.contextPath}/license.do"><i class="fa-regular fa-calendar"></i>자격증</a>
      <a href="${pageContext.request.contextPath}/notice.do"><i class="fa-solid fa-bullhorn"></i>공지</a>
    </nav>
  </div>

  <!-- 오른쪽 -->
  <div class="right">
    <div class="login">
      <a href="${pageContext.request.contextPath}/login.user">
        <span>로그인</span>
        <i class="fa-regular fa-user"></i>
      </a>
    </div>
    <button class="hamburger" aria-label="모바일 메뉴 열기/닫기" onclick="toggleMenu()">
      <i class="fa-solid fa-bars"></i>
    </button>
  </div>

  <!-- 모바일 메뉴 -->
  <nav id="mobileMenu" class="mobile-menu" aria-hidden="true">
    <a href="${pageContext.request.contextPath}/study.do"><i class="fa-regular fa-comments"></i>스터디</a>
    <a href="${pageContext.request.contextPath}/license.do"><i class="fa-regular fa-calendar"></i>자격증</a>
    <a href="${pageContext.request.contextPath}/notice.do"><i class="fa-solid fa-bullhorn"></i>공지</a>
    <a href="${pageContext.request.contextPath}/login.user"><i class="fa-regular fa-user"></i>로그인</a>
  </nav>
</header>

<script>
  // ✅ 바코드 폭 = left.logo 폭에 맞추기
  function syncBarcodeToLogo() {
    const logo = document.getElementById('logoArea');
    const barcode = document.querySelector('.barcode');
    if (!logo || !barcode) return;
    barcode.style.width = logo.offsetWidth + 'px';
  }

  window.addEventListener('load', syncBarcodeToLogo);
  window.addEventListener('resize', () => {
    clearTimeout(window.__resizeTimer);
    window.__resizeTimer = setTimeout(syncBarcodeToLogo, 100);
  });

  // 모바일 메뉴 토글
  function toggleMenu() {
    const m = document.getElementById('mobileMenu');
    const opened = m.style.display === 'flex';
    m.style.display = opened ? 'none' : 'flex';
    m.setAttribute('aria-hidden', opened ? 'true' : 'false');
  }

  // 화면 확장 시 모바일 메뉴 닫기
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
