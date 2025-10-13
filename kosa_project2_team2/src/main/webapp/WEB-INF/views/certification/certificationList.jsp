<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>자격증 목록</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        .pass-rate {
            font-weight: bold;
        }
    </style>
</head>
<body>

<h2>자격증 목록 (현재 연도 최신 회차 기준)</h2>

<table>
    <thead>
        <tr>
            <th>자격증명</th>
            <th>등급</th>
            <th>분야</th>
            <th>필기합격률</th>
            <th>실기합격률</th>
            <th>필기응시자수</th>
            <th>실기응시자수</th>
            <th>수험료</th>
            <th>운영기관</th>
        </tr>
    </thead>
    <tbody>
        <c:if test="${empty certList}">
            <tr>
                <td colspan="9">데이터가 없습니다.</td>
            </tr>
        </c:if>

        <c:forEach var="cert" items="${certList}">
            <tr>
                <td>${cert.jmName}</td>
                <td>${cert.grade}</td>
                <td>${cert.field}</td>

                <!-- 필기 합격률 표시 (null이면 -) -->
                <td class="pass-rate">
                    <c:choose>
                        <c:when test="${cert.docPassRate != null}">
                            <fmt:formatNumber value="${cert.docPassRate}" type="number" maxFractionDigits="1"/>%
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </td>

                <!-- 실기 합격률 -->
                <td class="pass-rate">
                    <c:choose>
                        <c:when test="${cert.pracPassRate != null}">
                            <fmt:formatNumber value="${cert.pracPassRate}" type="number" maxFractionDigits="1"/>%
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </td>

                <td>${cert.docApplicants}</td>
                <td>${cert.pracApplicants}</td>

                <!-- 시험비용 (null이면 -) -->
                <td>
                    <c:choose>
                        <c:when test="${cert.examFee != null}">
                            <fmt:formatNumber value="${cert.examFee}" type="currency"/>
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </td>

                <td>${cert.organName}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>

</body>
</html>
