<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>자격증 정보</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{
  font-family:'Noto Sans KR',sans-serif;
  background:#fff;
  padding:60px 20px;
  color:#333;
}
.container{max-width:1200px;margin:0 auto;text-align:center;}
h1{font-size:36px;font-weight:700;margin-bottom:40px;color:#333;}

/* 테이블 */
.table-container{
  background:#fff;border-radius:20px;padding:32px;
  box-shadow:0 4px 20px rgba(255,114,114,0.08);
  overflow-x:auto;margin-bottom:60px;
}
table{width:100%;border-collapse:collapse;}
thead{background:linear-gradient(135deg,#FF7272 0%,#FFA07A 100%);}
thead th{color:#fff;padding:16px 12px;font-weight:600;font-size:14px;}
tbody tr{border-bottom:1px solid #f5f5f5;transition:.2s;}
tbody tr:hover{background:#fef9f9;}
tbody td{padding:16px 12px;font-size:13px;color:#333;text-align:center;}
tbody td:first-child{color:#FF7272;font-weight:600;}

/* 통계 */
.stats-title{font-size:28px;font-weight:700;margin:60px 0 30px;}
.stats-container{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:24px;margin-bottom:60px;}
.stat-card{background:#fff;border-radius:16px;padding:28px;box-shadow:0 2px 12px rgba(0,0,0,0.08);border-left:5px solid #FF7272;}
.stat-label{font-size:16px;color:#666;margin-bottom:8px;font-weight:500;}
.stat-value{font-size:40px;font-weight:700;color:#FF7272;}
.stat-suffix{font-size:20px;margin-left:4px;}

/* 그래프 레이아웃 */
.graphs{
  display:flex;
  justify-content:center;
  align-items:flex-start;
  flex-wrap:wrap;
  gap:40px;
}
.graph-box{
  flex:1;
  min-width:420px;
  max-width:500px;
  height:340px;
  border-radius:16px;
  box-shadow:0 2px 12px rgba(0,0,0,0.05);
  padding:20px;
  background:#fff;
}
.graph-title {
  font-weight:600;
  font-size:16px;
  color:#555;
  margin-bottom:10px;
  text-align:center;
}
@media(max-width:768px){
  h1{font-size:28px;}
  .stat-value{font-size:32px;}
  .graphs{flex-direction:column;align-items:center;}
  .graph-box{width:100%;height:300px;}
}
</style>
</head>
<body>
<div class="container">
  <h1>자격증 정보</h1>

  <!-- ✅ 테이블 -->
  <div class="table-container">
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
            <tr><td colspan="9">데이터가 없습니다.</td></tr>
        </c:if>
        <c:forEach var="cert" items="${certList}">
          <tr>
            <td>${cert.jmName}</td>
            <td>${cert.grade}</td>
            <td>${cert.field}</td>
            <td>
              <c:choose>
                <c:when test="${cert.docPassRate != null}">
                  <fmt:formatNumber value="${cert.docPassRate}" maxFractionDigits="1"/>%
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
            <td>
              <c:choose>
                <c:when test="${cert.pracPassRate != null}">
                  <fmt:formatNumber value="${cert.pracPassRate}" maxFractionDigits="1"/>%
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
            <td>${cert.docApplicants}</td>
            <td>${cert.pracApplicants}</td>
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
  </div>

  <!-- 통계 카드 -->
<h2 class="stats-title">통계 정보</h2>
<div class="stats-container">
    <div class="stat-card">
        <div class="stat-label">전체 종목 수</div>
        <div id="totalCount" class="stat-value">-</div>
    </div>
    <div class="stat-card">
        <div class="stat-label">평균 합격률</div>
        <div id="avgRate" class="stat-value">-<span class="stat-suffix">%</span></div>
    </div>
    <div class="stat-card">
        <div class="stat-label">총 응시자</div>
        <div id="totalApplicants" class="stat-value">-</div>
    </div>
</div>

<!-- 그래프 영역 -->
<div class="graphs">
    <div class="graph-box">
        <div class="graph-title">등급별 비율</div>
        <canvas id="gradePie"></canvas>
    </div>
    <div class="graph-box">
        <div class="graph-title">분야별 평균 합격률</div>
        <canvas id="categoryBar"></canvas>
    </div>
</div>

<!-- JSP 데이터를 JS로 변환하여 통계 계산 및 차트 그리기 -->
<script>
    // certList 데이터를 JS 배열로 변환
    const certData = [
        <c:forEach var="c" items="${certList}" varStatus="i">
            {
                grade: "${c.grade}",
                field: "${c.field}",
                docPassRate: ${c.docPassRate != null ? c.docPassRate : 0},
                pracPassRate: ${c.pracPassRate != null ? c.pracPassRate : 0},
                docApplicants: ${c.docApplicants != null ? c.docApplicants : 0},
                pracApplicants: ${c.pracApplicants != null ? c.pracApplicants : 0}
            }<c:if test="${!i.last}">,</c:if>
        </c:forEach>
    ];

    // 통계 계산
    const total = certData.length;
    const avgRate = certData.reduce((sum, c) => sum + ((c.docPassRate + c.pracPassRate) / 2), 0) / total;
    const totalApplicants = certData.reduce((sum, c) => sum + c.docApplicants + c.pracApplicants, 0);

    // 통계 카드 표시
    document.getElementById("totalCount").textContent = total;
    document.getElementById("avgRate").innerHTML = avgRate.toFixed(1) + '<span class="stat-suffix">%</span>';
    document.getElementById("totalApplicants").textContent = totalApplicants.toLocaleString();

    // 등급별 비율 원형 그래프
    const gradeCounts = {};
    certData.forEach(c => {
        const g = c.grade || "기타";
        gradeCounts[g] = (gradeCounts[g] || 0) + 1;
    });

    const grades = Object.keys(gradeCounts);
    const gradeValues = Object.values(gradeCounts);
    const gradeColors = [
    	  "#FFD66B",  // 기사
    	  "#FF9F68",  // 산업기사
    	  "#FF7272",  // 기능사
    	  "#B28DFF",  // 전문자격 
    	  "#AEE8D7",  // 마스터
    	  "#8EC5FF"   // 기타 (새로운 색 추가)
    	];

    new Chart(document.getElementById("gradePie"), {
        type: "doughnut",
        data: {
            labels: grades,
            datasets: [{
                data: gradeValues,
                backgroundColor: gradeColors,
                borderWidth: 1
            }]
        },
        options: {
            plugins: {
                legend: { position: "right" },
                tooltip: {
                    callbacks: {
                        label: ctx => `${ctx.label}: ${ctx.parsed} 종목`
                    }
                }
            },
            cutout: "60%"
        }
    });

    // 분야별 평균 합격률 막대그래프
    const fieldMap = {};
    certData.forEach(c => {
        if (!fieldMap[c.field]) fieldMap[c.field] = [];
        // 필기 & 실기 평균값 사용
        fieldMap[c.field].push((c.docPassRate + c.pracPassRate) / 2);
    });

    const fields = Object.keys(fieldMap);
    const fieldAvg = fields.map(f => 
        fieldMap[f].reduce((a, b) => a + b, 0) / fieldMap[f].length
    );

    new Chart(document.getElementById("categoryBar"), {
        type: "bar",
        data: {
            labels: fields,
            datasets: [{
                label: "평균 합격률(%)",
                data: fieldAvg,
                backgroundColor: "rgba(255,114,114,0.8)",
                borderRadius: 8
            }]
        },
        options: {
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, max: 100 },
                x: { ticks: { font: { size: 12 } } }
            }
        }
    });
</script>