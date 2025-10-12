<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>메인</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css">

  <style>
    /* ===== 전체 레이아웃 ===== */
    .layout-wrap {
      display: grid;
      grid-template-columns: auto 1fr; /* 왼쪽: 사이드바 / 오른쪽: 메인 */
      gap: 0;                           /* ✅ 간격 제거 (왼쪽 딱 붙임) */
      align-items: flex-start;
      margin: 0;
      padding: 0;                       /* ✅ 좌우 여백 제거 */
    }

    main {
      background: #fff;
      border-left: 1px solid #e5e7eb;   /* 사이드바 구분선 느낌 */
      padding: 24px 28px;
      min-height: 100vh;
    }

    .btn-test {
      padding: 10px 20px;
      background: #007bff;
      color: #fff;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 14px;
    }
    .btn-test:hover {
      background: #006ae0;
    }

    /* ===== 반응형 ===== */
    @media (max-width: 900px) {
      .layout-wrap {
        grid-template-columns: 1fr; /* 세로로 정렬 */
      }
      main {
        border-left: none;
        border-top: 1px solid #e5e7eb;
      }
    }
  </style>
</head>
<body>

  <!-- 공통 네비게이션 -->
  <jsp:include page="/include/nav.jsp" />

  <!-- 사이드바 + 메인 레이아웃 -->
  <div class="layout-wrap">

    <!-- 좌측 사이드바 -->
    <jsp:include page="/include/sidebar.jsp">
      <jsp:param name="current" value="home"/>
    </jsp:include>

    <!-- 우측 본문 -->
    <main>
      <h2>메인 페이지입니다.</h2>
      <p>아래 버튼을 눌러 test 유저의 프로필 사진이 잘 표시되는지 확인하세요.</p>

      <button type="button"
              class="btn-test"
              onclick="location.href='<c:url value="/photoTest.user"/>'">
        🧪 테스트 유저 사진 보기
      </button>
    </main>

  </div>

</body>
</html>
