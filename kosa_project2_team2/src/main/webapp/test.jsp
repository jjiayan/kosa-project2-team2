<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>DB Test Page</title>
</head>
<body>
    <jsp:include page="/include/nav.jsp" />

    <main style="padding:20px">
        <h2>hello</h2>

        <!-- UserController 호출 (GET 방식) -->
        <a href="test.user">DB 연결 테스트</a>

        <!-- 혹은 POST로 호출 -->
        <form action="test.user" method="post">
            <button type="submit">DB 연결 테스트 (POST)</button>
        </form>
    </main>

</body>
</html>
