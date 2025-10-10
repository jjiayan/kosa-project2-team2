<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                <tr><td colspan="5" align="center">불러오는 중...</td></tr>
            </tbody>
        </table>
    </div>

<script>
$(document).ready(function(){
    $.ajax({
        url: "<%=request.getContextPath()%>/certification/list",
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
            $("#certTableBody").html('<tr><td colspan="5" align="center">데이터를 불러오지 못했습니다.</td></tr>');
        }
    });
});
</script>
</body>
</html>
