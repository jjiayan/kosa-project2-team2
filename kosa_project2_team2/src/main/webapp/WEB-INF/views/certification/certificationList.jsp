<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<%-- 컨텍스트 경로를 한 번만 안전 주입 --%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>자격증 정보</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:'Noto Sans KR',sans-serif;background:#fff;padding:60px 20px;color:#333;}
.container{max-width:1200px;margin:0 auto;text-align:center;}
h1{font-size:36px;font-weight:700;margin-bottom:24px;color:#333;}
/* 필터 */
.filter-container{display:flex;justify-content:space-between;align-items:center;gap:12px;background:#fff;border-radius:14px;padding:16px 20px;margin:16px 0 28px;box-shadow:0 2px 12px rgba(0,0,0,0.06);}
.filter-left{display:flex;gap:10px;align-items:center;flex-wrap:wrap;}
.filter-right{display:flex;gap:10px;align-items:center;flex-wrap:wrap;}
.filter-container select,.filter-container input{padding:8px 12px;border-radius:10px;border:1px solid #e6e6e6;font-size:14px;outline:none;}
#searchBtn{padding:10px 16px;background:#FF7272;color:#fff;border:none;border-radius:10px;cursor:pointer;font-weight:600;box-shadow:0 4px 12px rgba(255,114,114,0.28);transition:.15s;}
#searchBtn:hover{background:#ff5151;transform:translateY(-1px);}
/* 테이블 */
.table-container{background:#fff;border-radius:16px;padding:20px;box-shadow:0 4px 20px rgba(0,0,0,0.06);overflow-x:auto;margin-bottom:36px;}
table{width:100%;border-collapse:collapse;min-width:900px;}
thead{background:linear-gradient(135deg,#FF7272 0%,#FFA07A 100%);}
thead th{color:#fff;padding:14px 10px;font-weight:700;font-size:13px;letter-spacing:.2px;}
tbody tr{border-bottom:1px solid #f1f1f1;transition:.2s;}
tbody tr:hover{background:#fff8f8;}
tbody td{padding:14px 10px;font-size:13px;color:#333;text-align:center;white-space:nowrap;}
tbody td:first-child{color:#FF7272;font-weight:700;}
/* 통계 카드 */
.stats-title{font-size:24px;font-weight:800;margin:6px 0 14px;text-align:left;}
.stats-container{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:16px;margin-bottom:26px;}
.stat-card{background:#fff;border-radius:16px;padding:20px;box-shadow:0 2px 12px rgba(0,0,0,0.06);border-left:5px solid #FF7272;text-align:left;}
.stat-label{font-size:14px;color:#777;margin-bottom:6px;font-weight:600;}
.stat-value{font-size:32px;font-weight:800;color:#FF7272;}
.stat-suffix{font-size:18px;margin-left:4px;color:#FF7272}
/* 그래프 레이아웃 */
.graphs{display:flex;justify-content:center;align-items:flex-start;flex-wrap:wrap;gap:20px;}
.graph-box{flex:1;min-width:420px;max-width:520px;height:340px;border-radius:16px;box-shadow:0 2px 12px rgba(0,0,0,0.06);padding:16px;background:#fff;}
.graph-title{font-weight:700;font-size:15px;color:#555;margin-bottom:8px;text-align:left;}
@media(max-width:768px){body{padding:26px 12px;}h1{font-size:28px;}.graph-box{min-width:100%;height:300px;}table{min-width:100%;}}
</style>
</head>

<body>
<div class="container">
  <h1>자격증 정보</h1>

  <!-- 필터 영역 -->
  <div class="filter-container">
    <div class="filter-left">
      <select id="gradeFilter">
        <option value="">등급전체</option>
        <option value="기사">기사</option>
        <option value="산업기사">산업기사</option>
        <option value="기능사">기능사</option>
        <option value="전문자격">전문자격</option>
        <option value="마스터">마스터</option>
        <option value="기타">기타</option>
      </select>

      <select id="fieldFilter">
        <option value="">분야전체</option>
        <option value="IT">IT</option>
        <option value="전기전자">전기전자</option>
        <option value="건설기계">건설기계</option>
        <option value="안전소방">안전소방</option>
        <option value="데이터AI">데이터AI</option>
        <option value="보안네트워크">보안네트워크</option>
        <option value="사무회계">사무회계</option>
        <option value="전문직">전문직</option>
        <option value="의료보건">의료보건</option>
        <option value="기타">기타</option>
      </select>
    </div>

    <div class="filter-right">
      <input type="text" id="keyword" placeholder="자격증명 검색">
      <button id="searchBtn" type="button">검색</button>
    </div>
  </div>

  <!-- 테이블 -->
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
            <td><c:out value="${cert.jmName}" /></td>
            <td><c:out value="${cert.grade}" /></td>
            <td><c:out value="${cert.field}" /></td>
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
            <td><c:out value="${cert.docApplicants}" /></td>
            <td><c:out value="${cert.pracApplicants}" /></td>
            <td>
              <c:choose>
                <c:when test="${cert.examFee != null}">
                  <fmt:formatNumber value="${cert.examFee}" type="currency"/>
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
            <td><c:out value="${cert.organName}" /></td>
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
</div><!-- /.container -->

<!-- ===== JS는 문서 끝에서 DOMContentLoaded로 안전 실행 ===== -->
<script>
document.addEventListener("DOMContentLoaded", function () {
    // 컨텍스트 경로 (EL은 여기서만 사용, 나머진 JS에서 가공)
    const contextPath = '<c:out value="${ctx}"/>';

    // JSP 초기 데이터 -> 안전한 JS 객체로 변환 (문자열은 c:out로 이스케이프)
    const certData = [
        <c:forEach var="c" items="${certList}" varStatus="i">
        {
            jmName: "<c:out value='${c.jmName}'/>",
            grade: "<c:out value='${c.grade}'/>",
            field: "<c:out value='${c.field}'/>",
            docPassRate: ${c.docPassRate != null ? c.docPassRate : 0},
            pracPassRate: ${c.pracPassRate != null ? c.pracPassRate : 0},
            docApplicants: ${c.docApplicants != null ? c.docApplicants : 0},
            pracApplicants: ${c.pracApplicants != null ? c.pracApplicants : 0},
            examFee: ${c.examFee != null ? c.examFee : 0},
            organName: "<c:out value='${c.organName}'/>"
        }<c:if test="${!i.last}">,</c:if>
        </c:forEach>
    ];

    // 전역 차트 변수
    let gradePieChart = null;
    let categoryBarChart = null;

    // 필터 요소
    const gradeFilter  = document.getElementById("gradeFilter");
    const fieldFilter  = document.getElementById("fieldFilter");
    const keywordInput = document.getElementById("keyword");
    const searchBtn    = document.getElementById("searchBtn");

    // AJAX 로드 (EL/JS 충돌 없는 순수 JS 문자열 결합 사용)
    function loadFilteredData() {
        const grade   = gradeFilter.value || "";
        const field   = fieldFilter.value || "";
        const keyword = keywordInput.value || "";

        var url = contextPath + "/certificationFilter.sync"
                + "?grade="   + encodeURIComponent(grade)
                + "&field="   + encodeURIComponent(field)
                + "&keyword=" + encodeURIComponent(keyword);

        console.log("[AJAX] GET", url);

        fetch(url, { headers: { "Accept": "application/json" }})
            .then(function(res){
                if (!res.ok) throw new Error("HTTP " + res.status);
                return res.json();
            })
            .then(function(data){
                renderTable(data);
                renderCharts(data);
            })
            .catch(function(err){
                console.error("데이터 로드 오류:", err);
                renderTable([]);
                renderCharts([]);
            });
    }

    // 이벤트 + 디버그 로그
    searchBtn.addEventListener("click", function(){
        console.log("[EVENT] search click");
        loadFilteredData();
    });
    gradeFilter.addEventListener("change", function(){
        console.log("[EVENT] grade change:", gradeFilter.value);
        loadFilteredData();
    });
    fieldFilter.addEventListener("change", function(){
        console.log("[EVENT] field change:", fieldFilter.value);
        loadFilteredData();
    });
    keywordInput.addEventListener("keydown", function(e){
        if (e.key === "Enter") {
            console.log("[EVENT] keyword enter:", keywordInput.value);
            loadFilteredData();
        }
    });

    // 테이블 렌더링 (escapeHtml는 JS에서만 사용)
    function renderTable(data) {
        const tbody = document.querySelector("table tbody");
        tbody.innerHTML = "";

        if (!data || data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="9">데이터가 없습니다.</td></tr>';
            return;
        }

        data.forEach(function(cert){
            const row = document.createElement("tr");
            row.innerHTML =
                '<td>' + escapeHtml(cert.jmName) + '</td>' +
                '<td>' + escapeHtml(cert.grade) + '</td>' +
                '<td>' + escapeHtml(cert.field) + '</td>' +
                '<td>' + toRate(cert.docPassRate) + '</td>' +
                '<td>' + toRate(cert.pracPassRate) + '</td>' +
                '<td>' + toNum(cert.docApplicants) + '</td>' +
                '<td>' + toNum(cert.pracApplicants) + '</td>' +
                '<td>' + toCurrency(cert.examFee) + '</td>' +
                '<td>' + escapeHtml(cert.organName || "-") + '</td>';
            tbody.appendChild(row);
        });
    }

    // 차트 렌더링
    function renderCharts(data) {
        const safe = Array.isArray(data) ? data : [];
        const total = safe.length;
        const avgRate = safe.reduce(function(sum, c){
            return sum + avg((+c.docPassRate)||0, (+c.pracPassRate)||0);
        }, 0) / (total || 1);
        const totalApplicants = safe.reduce(function(sum, c){
            return sum + ((+c.docApplicants)||0) + ((+c.pracApplicants)||0);
        }, 0);

        document.getElementById("totalCount").textContent = total;
        document.getElementById("avgRate").innerHTML = (avgRate || 0).toFixed(1) + '<span class="stat-suffix">%</span>';
        document.getElementById("totalApplicants").textContent = (totalApplicants||0).toLocaleString();

        if (gradePieChart) gradePieChart.destroy();
        if (categoryBarChart) categoryBarChart.destroy();

        // 등급 분포
        const gradeCounts = {};
        safe.forEach(function(c){
            const g = c.grade || "기타";
            gradeCounts[g] = (gradeCounts[g] || 0) + 1;
        });
        const grades = Object.keys(gradeCounts);
        const gradeValues = Object.values(gradeCounts);
        const gradeColors = ["#FFD66B","#FF9F68","#FF7272","#B28DFF","#AEE8D7","#8EC5FF"];

        const pieCtx = document.getElementById("gradePie");
        if (pieCtx) {
            gradePieChart = new Chart(pieCtx, {
                type: "doughnut",
                data: { labels: grades, datasets: [{ data: gradeValues, backgroundColor: gradeColors, borderWidth: 1 }]},
                options: {
                    plugins: {
                        legend: { position: "right" },
                        tooltip: { callbacks: { label: function(ctx){ return ctx.label + ': ' + ctx.parsed + ' 종목'; } } }
                    },
                    cutout: "60%"
                }
            });
        }

        // 분야 평균 합격률
        const fieldMap = {};
        safe.forEach(function(c){
            const key = c.field || "기타";
            if (!fieldMap[key]) fieldMap[key] = [];
            fieldMap[key].push(avg((+c.docPassRate)||0, (+c.pracPassRate)||0));
        });
        const fields = Object.keys(fieldMap);
        const fieldAvg = fields.map(function(f){
            const arr = fieldMap[f];
            return (arr.reduce(function(a,b){return a+b;},0) / arr.length) || 0;
        });

        const barCtx = document.getElementById("categoryBar");
        if (barCtx) {
            categoryBarChart = new Chart(barCtx, {
                type: "bar",
                data: { labels: fields, datasets: [{ label: "평균 합격률(%)", data: fieldAvg, backgroundColor:"rgba(255,114,114,0.85)", borderRadius:8 }]},
                options: {
                    plugins: { legend: { display: false }},
                    scales: { y: { beginAtZero: true, max: 100 }, x: { ticks: { font: { size: 12 } } } }
                }
            });
        }
    }

    // 유틸 (JS 전용)
    function avg(a,b){ return (a+b)/2; }
    function toRate(v){ var n = +v; return n ? n.toFixed(1) + '%' : '-'; }
    function toNum(v){ var n = +v; return n ? n.toLocaleString() : '0'; }
    function toCurrency(v){ var n = +v; return n ? n.toLocaleString() + '원' : '-'; }
    function escapeHtml(s){ return String(s||'').replace(/[&<>"']/g, function(m){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]); }); }

    // 초기 렌더 (서버에서 내려준 JSP 데이터)
    renderTable(certData);
    renderCharts(certData);
});
</script>
</body>
</html>
