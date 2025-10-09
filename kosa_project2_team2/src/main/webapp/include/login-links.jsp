<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
  .links {
    margin-top: 18px;
    text-align: center;
    font-size: 14px;
    color: #4b5563;
  }
  .links a {
    color: #4b5563;
    text-decoration: none;
  }
  .links a:hover {
    color: #111;
    text-decoration: underline;
  }
  .links .sep {
    margin: 0 10px;
    color: #c7c7c7;
  }
</style>

<div class="links">
  <a href="${pageContext.request.contextPath}/findId.user">아이디찾기</a>
  <span class="sep">|</span>
  <a href="${pageContext.request.contextPath}/findPwd.user">비밀번호찾기</a>
  <span class="sep">|</span>
  <a href="${pageContext.request.contextPath}/signup.user">회원가입</a>
</div>
