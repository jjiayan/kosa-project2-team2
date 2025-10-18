<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<%-- 컨텍스트 경로 1회 주입 --%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>자격증 정보</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css"/>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:'Noto Sans KR',sans-serif;background:#fff;padding:40px 20px;color:#333;}
.container{max-width:1400px;margin:0 auto;padding: 60px 24px 0;}

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
.search-icon{position:absolute;right:12px;top:50%;transform:translateY(-50%);width:24px;height:24px;cursor:pointer;transition:.2s;display:flex;align-items:center;justify-content:center;}
.search-icon svg{width:20px;height:20px;}
.search-icon:hover svg path{stroke:#FF7272;}

/* 드롭다운 */
.custom-select{position:relative;}
.custom-select select{appearance:none;padding:10px 36px 10px 16px;border:1px solid #ddd;border-radius:8px;font-size:14px;background:#fff;cursor:pointer;outline:none;min-width:130px;transition:.2s;}
.custom-select select:hover{border-color:#FF7272;}
.custom-select::after{content:'▼';position:absolute;right:12px;top:50%;transform:translateY(-50%);font-size:10px;color:#666;pointer-events:none;}

/* 테이블 */
.table-container{
  background:#fff;border-radius:12px;padding:0;
  box-shadow:0 1px 3px rgba(0,0,0,0.08);overflow:hidden;margin-bottom:32px;
  min-height:520px; /* ✅ 10행 기준 고정 높이로 페이지네이션 흔들림 방지 */
}
table{width:100%;border-collapse:collapse;table-layout:fixed;} /* ✅ 고정 레이아웃 */
thead{background:linear-gradient(135deg,#FF7272 0%,#FFA07A 100%);}
thead th{color:#fff;padding:16px 12px;font-weight:600;font-size:13px;text-align:center;letter-spacing:.3px;}
tbody tr{border-bottom:1px solid #f1f1f1;transition:.15s;}
tbody tr:hover{background:#fff8f8;}
tbody td{
  padding:0 12px;
  height:52px; line-height:52px;
  font-size:13px;color:#555;text-align:center;white-space:nowrap;
  overflow:hidden;text-overflow:ellipsis;
}
tbody td:first-child{color:#FF7272;font-weight:700;text-align:left;padding-left:16px;}

/* 통계 카드 */
.stats-title{font-size:22px;font-weight:700;margin:0 0 16px 0;color:#333;}
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

/* 페이지네이션 */
.pagination{display:flex;justify-content:center;align-items:center;gap:16px;margin:40px 0 40px; width:100%;}
.page-btn{background:none;border:none;font-size:16px;color:#888;cursor:pointer;transition:all .2s;padding:4px 8px;}
.page-btn.number{font-size:18px;font-weight:500;}
.page-btn.number:hover{color:#FF7272;}
.page-btn.active{background-color:#FF7272;color:#fff !important;width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:bold;}
.page-btn.svg-btn{display:flex;align-items:center;justify-content:center;padding:4px;}
.page-btn.svg-btn svg{width:20px;height:20px;}
.page-btn.svg-btn svg path{stroke:#888;transition:stroke .2s;}
.page-btn.svg-btn:hover svg path{stroke:#FF7272;}
.page-btn:disabled{opacity:.3;cursor:not-allowed;}
.page-btn:disabled svg path{stroke:#ccc;}

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
<jsp:include page="/include/nav.jsp" />
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

      <!-- 오른쪽: 드롭다운 필터 (동적 옵션) -->
      <div class="filter-right">
        <div class="custom-select">
          <select id="gradeFilter">
            <option value="">등급전체</option>
          </select>
        </div>

        <div class="custom-select">
          <select id="fieldFilter">
            <option value="">분야전체</option>
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

  <!-- 페이지네이션 (동적 생성) -->
  <div class="pagination" id="pagination"></div>

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
// 서버 데이터를 JS 배열로 변환 (초기 렌더용)
var certData = [];
<c:forEach var="c" items="${certList}">
certData.push({
  jmcd: "<c:out value='${c.jmcd}'/>",
  jmName: "<c:out value='${c.jmName}'/>",
  grade: "<c:out value='${c.grade}'/>",
  field: "<c:out value='${c.field}'/>",
  year: ${c.year},
  implSeq: ${c.implSeq},
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

  // 옵션 동적 로드
  loadCategories(contextPath);

  // 페이지네이션 변수
  var currentData = certData.slice();
  var currentPage = 1;
  var itemsPerPage = 10;
  var totalPages = Math.max(1, Math.ceil(currentData.length / itemsPerPage));

  var gradeFilter  = document.getElementById("gradeFilter");
  var fieldFilter  = document.getElementById("fieldFilter");
  var keywordInput = document.getElementById("keyword");
  var searchBtn = document.getElementById("searchBtn");

  // 필터 데이터 로드 (AJAX)
  function loadFilteredData() {
    var grade   = gradeFilter.value || "";
    var field   = fieldFilter.value || "";
    var keyword = keywordInput.value || "";

    var url = contextPath + "/certificationFilter.sync"
            + "?grade="   + encodeURIComponent(grade)
            + "&field="   + encodeURIComponent(field)
            + "&keyword=" + encodeURIComponent(keyword);

    fetch(url, { headers: { "Accept": "application/json" }})
      .then(function(res){ if(!res.ok) throw new Error("HTTP " + res.status); return res.json(); })
      .then(function(data){
        currentData = Array.isArray(data) ? data : [];
        currentPage = 1;
        totalPages = Math.max(1, Math.ceil(currentData.length / itemsPerPage));
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

  // 이벤트 바인딩
  searchBtn.addEventListener("click", loadFilteredData);
  gradeFilter.addEventListener("change", loadFilteredData);
  fieldFilter.addEventListener("change", loadFilteredData);
  keywordInput.addEventListener("keyup", function(e){ if(e.key === "Enter") loadFilteredData(); });

  // 테이블 렌더링
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

      // 클릭 -> 상세
      row.addEventListener("click", function () {
        var url = contextPath + "/certificationDetail.cert"
                + "?jmcd=" + encodeURIComponent(cert.jmcd)
                + "&year=" + encodeURIComponent(cert.year)
                + "&implSeq=" + encodeURIComponent(cert.implSeq);
        window.location.href = url;
      });
      tbody.appendChild(row);
    });
  }

  // 페이지 변경
  function changePage(page) {
    if (page < 1 || page > totalPages) return;
    currentPage = page;
    renderTable();
    renderPagination();
  }

  // 페이지네이션 (슬라이딩 윈도우)
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

    // 이전 버튼 SVG
    var prevBtn = document.createElement("button");
    prevBtn.className = "page-btn svg-btn";
    prevBtn.innerHTML = `
      <svg width="16" height="28" viewBox="0 0 16 28" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M14 26L2 14L14 2" stroke="#FF7272" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>`;
    prevBtn.disabled = (currentPage === 1);
    prevBtn.onclick = function(){ changePage(currentPage - 1); };
    pagination.appendChild(prevBtn);

    // 숫자 버튼
    for (var i = startPage; i <= endPage; i++) {
      var btn = document.createElement("button");
      btn.className = "page-btn number" + (i === currentPage ? " active" : "");
      btn.textContent = i;
      (function(page){ btn.onclick = function(){ changePage(page); }; })(i);
      pagination.appendChild(btn);
    }

    // 다음 버튼 SVG
    var nextBtn = document.createElement("button");
    nextBtn.className = "page-btn svg-btn";
    nextBtn.innerHTML = `
      <svg width="16" height="28" viewBox="0 0 16 28" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M2 2L14 14L2 26" stroke="#FF7272" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>`;
    nextBtn.disabled = (currentPage === totalPages);
    nextBtn.onclick = function(){ changePage(currentPage + 1); };
    pagination.appendChild(nextBtn);
  }

  function renderCharts(data) {
    var safe = Array.isArray(data) ? data : [];

    // 통계 카드
    var total = safe.length;
    var avgRate = total > 0 ? safe.reduce((sum, c) => sum + ((+c.docPassRate||0 + +c.pracPassRate||0)/2), 0) / total : 0;
    var totalApplicants = safe.reduce((sum, c) => sum + ((+c.docApplicants||0) + (+c.pracApplicants||0)), 0);

    document.getElementById("totalCount").textContent = total;
    document.getElementById("avgRate").innerHTML = (avgRate || 0).toFixed(1) + '<span class="stat-suffix">%</span>';
    document.getElementById("totalApplicants").textContent = totalApplicants.toLocaleString();

    // 기존 차트 제거
    if (gradePieChart) gradePieChart.destroy();
    if (categoryBarChart) categoryBarChart.destroy();

    // 등급 파이
    var gradeCounts = {};
    safe.forEach(c => { var g = c.grade || "기타"; gradeCounts[g] = (gradeCounts[g]||0)+1; });
    var grades = Object.keys(gradeCounts);
    var gradeValues = Object.values(gradeCounts);
    var gradeColors = ["#FFD66B","#FF9F68","#FF7272","#B28DFF","#AEE8D7","#8EC5FF"];

    var pieCtx = document.getElementById("gradePie");
    if (pieCtx && grades.length > 0) {
      gradePieChart = new Chart(pieCtx, {
        type: "doughnut",
        data: { labels: grades, datasets:[{ data: gradeValues, backgroundColor: gradeColors, borderWidth:2, borderColor:'#fff' }]},
        options: { plugins: { legend: { position:"right", labels:{padding:15, font:{size:13}} } }, cutout: "65%" }
      });
    }

    // 분야별 평균 합격률 Bar
    var officialFields = ["IT","전기전자","건설기계","안전소방","데이터AI","보안네트워크","사무회계","전문직","의료보건","기타"];
    var fieldMap = {};
    officialFields.forEach(f => fieldMap[f] = []);

    safe.forEach(c => {
      var key = (c.field || "기타").trim();
      if (!fieldMap[key]) fieldMap[key] = [];
      fieldMap[key].push(((+c.docPassRate||0 + +c.pracPassRate||0)/2));
    });

    var fieldAvg = officialFields.map(f => {
      var arr = fieldMap[f];
      return arr.length > 0 ? arr.reduce((a,b)=>a+b,0)/arr.length : 0;
    });

    var barCtx = document.getElementById("categoryBar");
    if (barCtx && officialFields.length > 0) {
      categoryBarChart = new Chart(barCtx, {
        type: "bar",
        data: { labels: officialFields, datasets:[{ label: "평균 합격률(%)", data: fieldAvg, backgroundColor:"rgba(255,114,114,0.85)", borderRadius: 8, borderWidth: 0 }]},
        options: { plugins: { legend:{ display:false } }, scales: { y: { beginAtZero:true, max:100, grid:{color:'#f0f0f0'} }, x: { ticks:{ font:{ size:12 } }, grid:{ display:false } } } }
      });
    }
  }

  // 유틸
  function toRate(v){ var n = +v; return n ? n.toFixed(1) + '%' : '-'; }
  function toNum(v){ var n = +v; return n ? n.toLocaleString() : '0'; }
  function toCurrency(v){ var n = +v; return n ? n.toLocaleString() + '원' : '-'; }
  function escapeHtml(s){
    return String(s||'').replace(/[&<>"']/g,function(m){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m];});
  }

  // 초기 렌더
  renderTable();
  renderPagination();
  renderCharts(currentData);
});

// === 카테고리 옵션 한 번에 동적 로딩 ===
// GET /certificationCategories.sync → { "grades":[...], "fields":[...] }
function loadCategories(ctx){
  var gradeSel = document.getElementById("gradeFilter");
  var fieldSel = document.getElementById("fieldFilter");

  // '전체' 제외 초기화(중복 방지)
  gradeSel.length = 1;
  fieldSel.length = 1;

  fetch(ctx + "/certificationCategories.sync", { headers: { "Accept": "application/json" }})
    .then(function(res){ if(!res.ok) throw new Error("HTTP " + res.status); return res.json(); })
    .then(function(data){
      var grades = (data && Array.isArray(data.grades)) ? data.grades : [];
      var fields = (data && Array.isArray(data.fields)) ? data.fields : [];

      grades.forEach(function(g){
        var opt = document.createElement("option");
        opt.value = g; opt.textContent = g;
        gradeSel.appendChild(opt);
      });

      fields.forEach(function(f){
        var opt = document.createElement("option");
        opt.value = f; opt.textContent = f;
        fieldSel.appendChild(opt);
      });
    })
    .catch(function(err){ console.error("카테고리 로드 실패:", err); });
}
</script>
</body>
</html>
