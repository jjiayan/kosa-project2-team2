<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>${certification.jmName} 상세정보</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css">
<style>
body {
  font-family: 'Noto Sans KR', sans-serif;
  background: #f9f9fb;
  color: #333;
  padding: 40px;
}
.container {
  max-width: 900px;
  margin: 0 auto;
  background: white;
  border-radius: 16px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  padding: 40px 60px;
}
h1 {
  font-size: 28px;
  color: #222;
  margin-bottom: 10px;
}
.subtitle {
  color: #888;
  font-size: 15px;
  margin-bottom: 25px;
}
table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
}
th, td {
  padding: 12px 16px;
  border-bottom: 1px solid #eee;
}
th {
  text-align: left;
  background-color: #f5f6fa;
  width: 30%;
  color: #444;
}
td {
  color: #333;
}
.back-btn {
  display: inline-block;
  margin-top: 30px;
  padding: 10px 20px;
  border-radius: 8px;
  text-decoration: none;
  color: white;
  background-color: #4b7bec;
  transition: 0.2s;
}
.back-btn:hover {
  background-color: #3867d6;
}
</style>
</head>
<body>
  <div class="container">
    <h1>${certification.jmName}</h1>
    <p class="subtitle">${certification.grade} · ${certification.field}</p>

    <table>
      <tr>
        <th>시행년도</th>
        <td>${certification.year}</td>
      </tr>
      <tr>
        <th>회차</th>
        <td>${certification.implSeq}회차</td>
      </tr>
      <tr>
        <th>시행기관</th>
        <td>${certification.organName}</td>
      </tr>
      <tr>
        <th>필기 합격률</th>
        <td>
          <c:choose>
            <c:when test="${not empty certification.docPassRate}">
              ${certification.docPassRate}% (${certification.docApplicants}명 응시)
            </c:when>
            <c:otherwise>데이터 없음</c:otherwise>
          </c:choose>
        </td>
      </tr>
      <tr>
        <th>실기 합격률</th>
        <td>
          <c:choose>
            <c:when test="${not empty certification.pracPassRate}">
              ${certification.pracPassRate}% (${certification.pracApplicants}명 응시)
            </c:when>
            <c:otherwise>데이터 없음</c:otherwise>
          </c:choose>
        </td>
      </tr>
      <tr>
        <th>응시료</th>
        <td>
          <c:choose>
            <c:when test="${not empty certification.examFee}">
              <fmt:formatNumber value="${certification.examFee}" pattern="#,###"/> 원
            </c:when>
            <c:otherwise>미정</c:otherwise>
          </c:choose>
        </td>
      </tr>
    </table>

    <a href="${pageContext.request.contextPath}/certificationList.cert" class="back-btn">← 목록으로 돌아가기</a>
  </div>
</body>
</html>
