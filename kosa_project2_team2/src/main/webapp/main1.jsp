<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>메인 | Certification Bible</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css">

  <style>
    body {
      margin: 0;
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #fffdfd;
      color: #333;
    }

    /* hero section */
    .hero {
      background: linear-gradient(to bottom, rgba(255, 114, 114, 0.3), #fff5f5);
      height: 100vh;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      text-align: center;
      gap: 16px;
      position: relative;
    }
    .hero small {
      font-size: 16px;
      color: #666;
      letter-spacing: 1px;
      margin-bottom: 12px;
    }
    
    .hero h1 {
      font-family: 'Playfair Display', serif;
      font-size: 76px;
      color: #ff7a7a;
      letter-spacing: 6px;
      font-weight: 400;
      margin: 0;
      line-height: 1.3;
    }
    /* ===== nav.jsp 오버라이드 ===== */
 header.nav-root {
      position: absolute !important;
      top: 0;
      left: 0;
      width: 100%;
      background: transparent !important;
      border: none !important;
      box-shadow: none !important;
      z-index: 100;
    }

    header.nav-root * {
      color: #fff !important;
      border-color: rgba(255, 255, 255, 0.7) !important;
    }

    header.nav-root .menu {
      background: transparent !important;
      border: 1.5px solid rgba(255, 255, 255, 0.7) !important;
      box-shadow: none !important;
    }

    header.nav-root .menu a:hover,
    header.nav-root .login a:hover {
      color: #ffeaea !important;
    }

    header.nav-root i {
      color: #fff !important;
    }

   
    header.nav-root .barcode {
    content: url("${pageContext.request.contextPath}/images/barcode-trans.png") !important;
      filter: brightness(0) invert(1);
    }  
  </style>
</head>

<body>
  <!-- 공통 네비게이션 -->
  <jsp:include page="/include/nav.jsp" />

  <main>
    <section class="hero">
      <small>═══ 자격증의 바이블 ═══</small>
      <h1>THE CERTIFICATION<br>BIBLE</h1>
    </section>
    
    
  </main>
</body>
</html>
