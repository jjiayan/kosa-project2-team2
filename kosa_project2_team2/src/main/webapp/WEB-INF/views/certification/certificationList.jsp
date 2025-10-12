<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>자격증 목록</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/style/default.css">
</head>
<body>
    <div class="container">
        <h1>📚 자격증 목록</h1>
        <table border="1" width="100%">
            <thead>
                <tr>
                    <th>코드</th>
                    <th>이름</th>
                    <th>시행기관</th>
                    <th>년도</th>
                    <th>회차</th>
                </tr>
            </thead>
            <tbody id="certTableBody">
                <!-- ✅ 서버 사이드 JSTL로 기본 목록 출력 -->
                <c:choose>
                    <c:when test="${not empty certificationList}">
                        <c:forEach var="cert" items="${certificationList}">
                            <tr>
                                <td>${cert.jmcd}</td>
                                <td>${cert.jmName}</td>
                                <td>${cert.organName}</td>
                                <td>${cert.year}</td>
                                <td>${cert.implSeq}</td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" align="center">데이터가 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

<script>
// ✅ 필요 시 AJAX로 최신 데이터 다시 불러오기
function loadData() {
    $.ajax({
        url: "<%=request.getContextPath()%>/certificationAjax.cert",
        type: "GET",
        dataType: "json",
        success: function(data){
            let rows = "";
            data.forEach(function(cert){
                rows += `
                    <tr>
                        <td>${cert.jmcd}</td>
                        <td>${cert.jmName}</td>
                        <td>${cert.organName}</td>
                        <td>${cert.year}</td>
                        <td>${cert.implSeq}</td>
                    </tr>`;
            });
            $("#certTableBody").html(rows);
        },
        error: function(){
            $("#certTableBody").html(
                '<tr><td colspan="5" align="center">데이터를 불러오지 못했습니다.</td></tr>'
            );
        }
    });
}

// ✅ 페이지 로드 시 자동 Ajax 로딩도 가능 → 원하면 아래 한 줄을 주석 해제!
$(document).ready(function(){
    // loadData();
});
</script>
</body>
</html>
