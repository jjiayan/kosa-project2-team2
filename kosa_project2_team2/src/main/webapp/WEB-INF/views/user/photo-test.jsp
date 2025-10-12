<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Photo Test</title>
  <style>
    body { font-family: system-ui, Arial, sans-serif; padding: 24px; }
    .avatar { width: 200px; height: 200px; border-radius: 50%; object-fit: cover; }
    .info { margin-top: 16px; color: #555; }
  </style>
</head>
<body>

<h2>닉네임 "test" 사용자 사진 테스트</h2>

<c:choose>
  <c:when test="${empty user}">
    <p>닉네임이 <b>test</b>인 사용자가 없습니다.</p>
  </c:when>

  <c:otherwise>
    <p><b>닉네임:</b> ${user.user_nickname}</p>
    <p><b>저장된 경로:</b> ${user.user_photo}</p>
    <img class="avatar"
         src="<c:url value='${user.user_photo}'/>"
         alt="avatar"
         onerror="this.onerror=null; this.src='<c:url value="/images/default-avatar.png"/>';">
    <p class="info">
      위 이미지가 안 보이면
      <a href="<c:url value='${user.user_photo}'/>" target="_blank">원본 링크</a>로 확인하세요.<br>
      404면 /files 서블릿 매핑, C:\upload 경로, 권한을 확인하세요.
    </p>
    
    
  </c:otherwise>
</c:choose>

</body>
</html>
