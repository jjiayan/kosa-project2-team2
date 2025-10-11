<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>메인</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css">
</head>
<body>

  <!-- 공통 네비게이션 -->
  <jsp:include page="/include/nav.jsp" />

  <!-- 본문 -->
  <main>
    <h2>메인 페이지입니다.</h2>
    <p>아래 버튼을 눌러 test 유저의 프로필 사진이 잘 표시되는지 확인하세요.</p>

    <!-- /photoTest.user 로 이동하는 버튼 -->
    <button type="button"
            onclick="location.href='<c:url value="/photoTest.user"/>'"
            style="padding:10px 20px; background:#007bff; color:white; border:none; border-radius:6px; cursor:pointer;">
      🧪 테스트 유저 사진 보기
    </button>
  </main>

</body>
</html>
