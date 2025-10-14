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
body{font-family:'Noto Sans KR',sans-serif;background:#fff;padding:40px 20px;color:#333;}
.container{max-width:1400px;margin:0 auto;}

/* 상단 헤더 영역 */
.header-section{margin-bottom:32px;}
h1{font-size:32px;font-weight:700;color:#333;margin-bottom:20px;text-align:center;}

/* 필터 영역 */
.filter-area{display:flex;gap:10px;align-items:center;justify-content:space-between;flex-wrap:wrap;}
.filter-left{display:flex;gap:10px;align-items:center;}
.filter-right{display:flex;gap:10px;align-items:center;}

/* 검색창 */
.search-box{position:relative;min-width:300px;}
.search-box input{width:100%;padding:10px 40px 10px 16px;border:1px solid #ddd;border-radius:8px;font-size:14px;outline:none;transition:.2s;}
.search-box input:focus{border-color:#FF7272;}

/* 검색 아이콘 버튼 */
.search-icon{position:absolute;right:12px;top:50%;transform:translateY(-50%);width:24px;height:24px;cursor:pointer;transition:.2s;display:flex;align-items:center;justify-content:center;}
.search-icon svg{width:20px;height:20px;}
.search-icon:hover svg path{stroke:#FF7272;}

/* 드롭다운 */
.custom-select{position:relative;}
.custom-select select{appearance:none;padding:10px 36px 10px 16px;border:1px solid #ddd;border-radius:8px;font-size:14px;background:#fff;cursor:pointer;outline:none;min-width:130px;transition:.2s;}
.custom-select select:hover{border-color:#FF7272;}
.custom-select::after{content:'▼';position:absolute;right:12px;top:50%;transform:translateY(-50%);font-size:10px;color:#666;pointer-events:none;}

/* 테이블 */
.table-container {
    background:#fff;
    border-radius:12px;
    padding:0;
    box-shadow:0 1px 3px rgba(0,0,0,0.08);
    overflow:hidden;
    margin-bottom:32px;
    min-height:520px;          /* ✅ 테이블 높이 고정 */
}

table {
    width:100%;
    border-collapse:collapse;
    table-layout: fixed;       /* ✅ 칼럼 고정 너비 */
}

thead {
    background:linear-gradient(135deg,#FF7272 0%,#FFA07A 100%);
}

thead th {
    color:#fff;
    padding:16px 12px;
    font-weight:600;
    font-size:13px;
    text-align:center;
    letter-spacing:.3px;
}

tbody tr {
    border-bottom:1px solid #f1f1f1;
    transition:.15s;
}

tbody tr:hover {
    background:#fff8f8;
}

tbody td {
    padding:0 12px;            /* ✅ 위아래 패딩 제거 */
    height:52px;               /* ✅ 행 높이 고정 */
    line-height:52px;          /* ✅ 텍스트 중앙 정렬 */
    font-size:13px;
    color:#555;
    text-align:center;
    white-space:nowrap;
    overflow:hidden;           /* ✅ 넘치는 글자 숨기기 */
    text-overflow:ellipsis;    /* ✅ … 처리 */
}

tbody td:first-child {
    color:#FF7272;
    font-weight:700;
    text-align:left;
    padding-left:16px;
}

/* 통계 카드 */
.stats-title{font-size:22px;font-weight:700;magin-top:60px;margin:0 0 16px 0;color:#333;}
.stats-container{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:16px;margin-bottom:32px;}
.stat-card{background:#fff;border-radius:12px;padding:24px;box-shadow:0 1px 3px rgba(0,0,0,0.08);border-left:4px solid #FF7272;text-align:left;transition:.2s;}
.stat-card:hover{box-shadow:0 2px 8px rgba(0,0,0,0.12);transform:translateY(-2px);}
.stat-label{font-size:13px;color:#888;margin-bottom:8px;font-weight:500;}
.stat-value{font-size:32px;font-weight:800;color:#FF7272;}
.stat-suffix{font-size:18px;margin-left:4px;color:#FF7272}

/* 그래프 레이아웃 */
.graphs{display:grid;grid-template-columns:repeat(auto-fit,minmax(480px,1fr));gap:20px;}
.graph-box{height:360px;border-radius:12px;box-shadow:0 1px 3px rgba(0,0,0,0.08);padding:20px;background:#fff;transition:.2s;}
.graph-box:hover{box-shadow:0 2px 8px rgba(0,0,0,0.12);}
.graph-title{font-weight:700;font-size:15px;color:#555;margin-bottom:12px;}

/* 페이지네이션 전체 영역 */
.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 16px;
    margin-top: 40px;
    margin-bottom: 40px;
    width: 100%;
}

/* 공통 버튼 스타일 */
.page-btn {
    background: none;
    border: none;
    font-size: 16px;
    color: #888;
    cursor: pointer;
    transition: all 0.2s;
    padding: 4px 8px;
}

/* 숫자 버튼 */
.page-btn.number {
    font-size: 18px;
    font-weight: 500;
}

/* 숫자 hover */
.page-btn.number:hover {
    color: #FF7272;
}

/* 현재 페이지 */
.page-btn.active {
    background-color: #FF7272;
    color: #fff !important;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
}

/* SVG 버튼 */
.page-btn.svg-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 4px;
}

.page-btn.svg-btn svg {
    width: 20px;
    height: 20px;
}

/* SVG 기본 색상 */
.page-btn.svg-btn svg path {
    stroke: #888;
    transition: stroke 0.2s;
}

/* SVG hover */
.page-btn.svg-btn:hover svg path {
    stroke: #FF7272;
}

/* 비활성 */
.page-btn:disabled {
    opacity: 0.3;
    cursor: not-allowed;
}

.page-btn:disabled svg path {
    stroke: #ccc;
}



@media(max-width:768px){
  body{padding:20px 12px;}
  h1{font-size:24px;margin-bottom:16px;}
  .filter-area{flex-direction:column;align-items:stretch;}
  .filter-left,.filter-right{width:100%;}
  .search-box{min-width:100%;}
  .custom-select{width:100%;}
  .custom-select select{width:100%;}
  .graphs{grid-template-columns:1fr;}
  .graph-box{height:320px;}
  table{font-size:12px;}
  tbody td:first-child{font-size:12px;}
}
</style>
</head>

<body>
<div class="container">
  <!-- 헤더 + 필터 영역 -->
  <div class="header-section">
    <h1>자격증 정보</h1>
    
    <div class="filter-area">
      <!-- 왼쪽: 검색창 -->
      <div class="filter-left">
        <div class="search-box">
          <input type="text" id="keyword" placeholder="자격증명 검색">
          <span class="search-icon" id="searchBtn">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M11 19C15.4183 19 19 15.4183 19 11C19 6.58172 15.4183 3 11 3C6.58172 3 3 6.58172 3 11C3 15.4183 6.58172 19 11 19Z" stroke="#9C9C9C" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M21.0004 21L16.6504 16.65" stroke="#9C9C9C" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </span>
        </div>
      </div>
      
      <!-- 오른쪽: 드롭다운 필터 -->
      <div class="filter-right">
        <div class="custom-select">
          <select id="gradeFilter">
            <option value="">등급전체</option>
            <option value="기사">기사</option>
            <option value="산업기사">산업기사</option>
            <option value="기능사">기능사</option>
            <option value="전문자격">전문자격</option>
            <option value="마스터">마스터</option>
            <option value="기타">기타</option>
          </select>
        </div>

        <div class="custom-select">
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
      </div>
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
      <tbody id="certTableBody">
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

  <!-- 페이지네이션 -->
  <div class="pagination" id="pagination">
    <button class="page-btn svg-btn" id="prevBtn">
        <!-- 왼쪽 SVG -->
        <svg width="16" height="28" viewBox="0 0 16 28" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M14 26L2 14L14 2" stroke="#FF7272" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
    </button>

    <button class="page-btn number">1</button>
    <button class="page-btn number">2</button>
    <button class="page-btn number">3</button>

    <button class="page-btn svg-btn" id="nextBtn">
        <!-- 오른쪽 SVG -->
        <svg width="16" height="28" viewBox="0 0 16 28" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M2 2L14 14L2 26" stroke="#FF7272" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
    </button>
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

<script>
// JSP에서 서버 데이터를 JavaScript 배열로 변환
var certData = [];
<c:forEach var="c" items="${certList}">
certData.push({
    jmName: "<c:out value='${c.jmName}'/>",
    grade: "<c:out value='${c.grade}'/>",
    field: "<c:out value='${c.field}'/>",
    docPassRate: ${c.docPassRate != null ? c.docPassRate : 0},
    pracPassRate: ${c.pracPassRate != null ? c.pracPassRate : 0},
    docApplicants: ${c.docApplicants != null ? c.docApplicants : 0},
    pracApplicants: ${c.pracApplicants != null ? c.pracApplicants : 0},
    examFee: ${c.examFee != null ? c.examFee : 0},
    organName: "<c:out value='${c.organName}'/>"
});
</c:forEach>

var contextPath = "<c:out value='${ctx}'/>";

document.addEventListener("DOMContentLoaded", function () {
    var gradePieChart = null;
    var categoryBarChart = null;

    // 페이지네이션 변수
    var currentData = certData;  // 필터된 데이터
    var currentPage = 1;         // 현재 페이지
    var itemsPerPage = 10;       // 한 페이지당 항목 수
    var totalPages = Math.ceil(currentData.length / itemsPerPage);

    var gradeFilter  = document.getElementById("gradeFilter");
    var fieldFilter  = document.getElementById("fieldFilter");
    var keywordInput = document.getElementById("keyword");
    var searchBtn = document.getElementById("searchBtn");

    // 필터 후 데이터 로드
    function loadFilteredData() {
        var grade   = gradeFilter.value || "";
        var field   = fieldFilter.value || "";
        var keyword = keywordInput.value || "";

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
                console.log("데이터 수신:", data.length, "건");
                currentData = data;
                currentPage = 1;
                totalPages = Math.ceil(currentData.length / itemsPerPage);

                renderTable();
                renderPagination();
                renderCharts(currentData);
            })
            .catch(function(err){
                console.error("데이터 로드 오류:", err);
                currentData = [];
                currentPage = 1;
                totalPages = 1;
                renderTable();
                renderPagination();
                renderCharts([]);
            });
    }

    searchBtn.addEventListener("click", function(){
        console.log("🔍 검색 버튼 클릭");
        loadFilteredData();
    });
    gradeFilter.addEventListener("change", function(){
        console.log("📝 등급 필터:", gradeFilter.value);
        loadFilteredData();
    });
    fieldFilter.addEventListener("change", function(){
        console.log("📁 분야 필터:", fieldFilter.value);
        loadFilteredData();
    });
    keywordInput.addEventListener("keyup", function(e){
        if (e.key === "Enter") {
            console.log("⌨️ Enter 키:", keywordInput.value);
            loadFilteredData();
        }
    });

    // 현재 페이지 기준 테이블 렌더링
    function renderTable() {
        var tbody = document.getElementById("certTableBody");
        tbody.innerHTML = "";
        
        var startIdx = (currentPage - 1) * itemsPerPage;
        var endIdx = startIdx + itemsPerPage;
        var pageItems = currentData.slice(startIdx, endIdx);

        if (!pageItems || pageItems.length === 0) {
            tbody.innerHTML = '<tr><td colspan="9">데이터가 없습니다.</td></tr>';
            return;
        }

        pageItems.forEach(function(cert){
            var row = document.createElement("tr");
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
    
    // 페이지 변경 함수
    function changePage(page) {
        if (page < 1 || page > totalPages) return;
        currentPage = page;
        renderTable();
        renderPagination();
    }
    
    // 페이지네이션 렌더링
    function renderPagination() {
    var pagination = document.getElementById("pagination");
    pagination.innerHTML = "";

    var maxPagesToShow = 5;
    var startPage = Math.max(1, currentPage - Math.floor(maxPagesToShow / 2));
    var endPage = startPage + maxPagesToShow - 1;

    if (endPage > totalPages) {
        endPage = totalPages;
        startPage = Math.max(1, endPage - maxPagesToShow + 1);
    }

    // 이전 버튼 (SVG 그대로)
    var prevBtn = document.createElement("button");
    prevBtn.className = "page-btn svg-btn";
    prevBtn.innerHTML = `
        <svg width="16" height="28" viewBox="0 0 16 28" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M14 26L2 14L14 2" stroke="#FF7272" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
    `;
    prevBtn.disabled = (currentPage === 1);
    prevBtn.onclick = function () { changePage(currentPage - 1); };
    pagination.appendChild(prevBtn);

    // 숫자 버튼
    for (var i = startPage; i <= endPage; i++) {
        var btn = document.createElement("button");
        btn.className = "page-btn number" + (i === currentPage ? " active" : "");
        btn.textContent = i;
        btn.onclick = (function(page) {
            return function () { changePage(page); };
        })(i);
        pagination.appendChild(btn);
    }

    // 다음 버튼 (SVG 그대로)
    var nextBtn = document.createElement("button");
    nextBtn.className = "page-btn svg-btn";
    nextBtn.innerHTML = `
        <svg width="16" height="28" viewBox="0 0 16 28" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M2 2L14 14L2 26" stroke="#FF7272" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
    `;
    nextBtn.disabled = (currentPage === totalPages);
    nextBtn.onclick = function () { changePage(currentPage + 1); };
    pagination.appendChild(nextBtn);
	}
    
    
 	// 각 행에 jmcd 넣기
    <c:forEach var="item" items="${certList}">
    <tr ondblclick="goDetail('${item.jmcd}')">
        <td>${item.jmcd}</td>
        <td>${item.jmName}</td>
        <td>${item.organName}</td>
    </tr>
    </c:forEach>
    
    function goDetail(jmcd, year, implSeq) {
        location.href = '${ctx}/certificationDetail.cert?jmcd=' + jmcd 
                      + '&year=' + year 
                      + '&implSeq=' + implSeq;
    }

    
    // 차트 통계
    function renderCharts(data) {
        var safe = Array.isArray(data) ? data : [];
        var total = safe.length;
        var avgRate = total > 0 ? safe.reduce(function(sum, c){
            return sum + avg((+c.docPassRate)||0, (+c.pracPassRate)||0);
        }, 0) / total : 0;
        var totalApplicants = safe.reduce(function(sum, c){
            return sum + ((+c.docApplicants)||0) + ((+c.pracApplicants)||0);
        }, 0);

        document.getElementById("totalCount").textContent = total;
        document.getElementById("avgRate").innerHTML = (avgRate || 0).toFixed(1) + '<span class="stat-suffix">%</span>';
        document.getElementById("totalApplicants").textContent = (totalApplicants||0).toLocaleString();

        if (gradePieChart) gradePieChart.destroy();
        if (categoryBarChart) categoryBarChart.destroy();

        var gradeCounts = {};
        safe.forEach(function(c){
            var g = c.grade || "기타";
            gradeCounts[g] = (gradeCounts[g] || 0) + 1;
        });
        var grades = Object.keys(gradeCounts);
        var gradeValues = Object.values(gradeCounts);
        var gradeColors = ["#FFD66B","#FF9F68","#FF7272","#B28DFF","#AEE8D7","#8EC5FF"];

        var pieCtx = document.getElementById("gradePie");
        if (pieCtx && grades.length > 0) {
            gradePieChart = new Chart(pieCtx, {
                type: "doughnut",
                data: { labels: grades, datasets: [{ data: gradeValues, backgroundColor: gradeColors, borderWidth: 2, borderColor: '#fff' }]},
                options: {
                    plugins: {
                        legend: { position: "right", labels: { padding: 15, font: { size: 13 } } },
                        tooltip: { callbacks: { label: function(ctx){ return ctx.label + ': ' + ctx.parsed + ' 종목'; } } }
                    },
                    cutout: "65%"
                }
            });
        }

        var fieldMap = {};
        safe.forEach(function(c){
            var key = c.field || "기타";
            if (!fieldMap[key]) fieldMap[key] = [];
            fieldMap[key].push(avg((+c.docPassRate)||0, (+c.pracPassRate)||0));
        });
        var fields = Object.keys(fieldMap);
        var fieldAvg = fields.map(function(f){
            var arr = fieldMap[f];
            return (arr.reduce(function(a,b){return a+b;},0) / arr.length) || 0;
        });

        var barCtx = document.getElementById("categoryBar");
        if (barCtx && fields.length > 0) {
            categoryBarChart = new Chart(barCtx, {
                type: "bar",
                data: { 
                    labels: fields, 
                    datasets: [{ 
                        label: "평균 합격률(%)", 
                        data: fieldAvg, 
                        backgroundColor:"rgba(255,114,114,0.85)",
                        borderRadius: 8,
                        borderWidth: 0
                    }]
                },
                options: {
                    plugins: { legend: { display: false }},
                    scales: { 
                        y: { beginAtZero: true, max: 100, grid: { color: '#f0f0f0' } }, 
                        x: { ticks: { font: { size: 12 } }, grid: { display: false } }
                    }
                }
            });
        }
    }

    // 유틸 함수
    function avg(a,b){ return (a+b)/2; }
    function toRate(v){ var n = +v; return n ? n.toFixed(1) + '%' : '-'; }
    function toNum(v){ var n = +v; return n ? n.toLocaleString() : '0'; }
    function toCurrency(v){ var n = +v; return n ? n.toLocaleString() + '원' : '-'; }
    function escapeHtml(s){ 
        return String(s||'').replace(/[&<>"']/g, function(m){ 
            return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]; 
        }); 
    }

    // 초기 렌더링
    renderTable();
    renderPagination();
    renderCharts(currentData);
});
</script>
</body>
</html>