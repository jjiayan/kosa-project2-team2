<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"  %>
<fmt:setLocale value="ko_KR"/>

<%
  String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>${cert.jmName} 상세</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<style>
:root{
  --ink:#222; --ink2:#6b7280;
  --brand:#3b82f6; --line:#e6e9ef;
  --bg:#fafafa; --soft:#ffffff;
  --card:#ffffff;
  --radius:18px; --shadow:0 2px 8px rgba(0,0,0,.04);
  --shadow-soft:0 1px 3px rgba(0,0,0,.06);
}
*{box-sizing:border-box}
html,body{margin:0;padding:0}
body{
  font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",sans-serif;
  color:var(--ink); background:var(--soft);
}
.container{max-width:1040px;margin:40px auto 90px;padding:0 24px}

/* Title */
.page-title{text-align:center;margin:6px 0 22px}
.page-title h1{margin:0 0 12px;font-size:32px;font-weight:700;letter-spacing:-.2px;color:#2f343b}
.badges{display:flex;gap:8px;justify-content:center}

/* BADGES */
.badge{
  display:inline-flex;align-items:center;gap:6px;
  padding:6px 12px;border-radius:999px;font-size:12px;font-weight:600;
}
.badge.grade{ background:#F0F6FA; color:#0090F9; }
.badge.field{ background:#FFD8D8; color:#F9005B; }

/* Tabs / year */
.topline{display:flex;align-items:center;justify-content:space-between;margin:24px 0 30px;gap:12px} 
.tabs{display:flex;gap:22px;flex-wrap:wrap}
.tab{position:relative;text-decoration:none;color:#797f8a;font-size:18px;font-weight:600;padding:6px 2px}
.tab:hover{color:#4a70ff}
.tab.active{color:#4a70ff}
.tab.active::after{content:"";position:absolute;left:0;right:0;bottom:-8px;height:3px;background:#4a70ff;border-radius:2px}
.year-filter{display:flex;justify-content:flex-end}
.filter-select{
  appearance:none;-webkit-appearance:none;-moz-appearance:none;
  background:#fff;border:1px solid #F0F0F0;border-radius:12px;
  padding:8px 36px 8px 12px;font-size:14px;font-weight:500;color:#333;cursor:pointer;
  background-image:url("data:image/svg+xml,%3Csvg width='12' height='8' viewBox='0 0 12 8' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%236b7280' stroke-width='2' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
  background-repeat:no-repeat;background-position:right 10px center;
}
.filter-select:focus{border-color:#ff4d4f;outline:none}

/* Section (필기/실기 섹션을 회색 박스로) */
.section{
  background:#F0F0F0;       /* 회색 박스 */
  border:none;              /* 경계선 없음 */
  border-radius:16px;
  padding:32px;             /* 넉넉한 패딩 */
  box-shadow:none;          /* 그림자 없음 */
}
.section + .section{margin-top:20px} /* 섹션 간격 넓게 */
.section-header{display:flex;align-items:center;gap:12px;margin-bottom:18px}
.section-header .icon{
  width:36px;height:36px;border-radius:10px;display:grid;place-items:center;background:#f0f0f0;
}
.section-header .icon svg{display:block;width:24px;height:24px}
.section-title{font-size:17px;font-weight:700;color:#394150}

/* Row of info cards */
.rows{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
@media (max-width:900px){ .rows{grid-template-columns:1fr} }
.info{
  background:var(--card);
  border:1px solid #f0f0f0;
  border-radius:12px;
  padding:18px;min-height:72px;
  display:flex;flex-direction:column;gap:6px;
}
.label{font-size:13px;color:var(--ink2);font-weight:500;letter-spacing:0}
.value{font-size:15px;color:#2f3540;font-weight:600}
.muted{color:#9aa3b2;font-weight:500}

/* Hidden rounds for JS */
.rounds-data{display:none}

/* --- 통계 섹션 --- */
.stats-section { background: var(--soft); border-radius: 16px; padding: 24px; margin-top: 24px; box-shadow: var(--shadow); }
.stats-header { font-size: 20px; font-weight: 700; color: #2f343b; margin-bottom: 24px; }
.stats-rows { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
@media (max-width:700px){ .stats-rows{grid-template-columns:repeat(1, 1fr)} }
.stat-card { background: var(--soft); border: 1px solid #f0f0f0; border-radius: 12px; padding: 20px; display: flex; flex-direction: column; align-items: flex-start; justify-content: center; min-height: 90px; }
.stat-label { font-size: 14px; color: var(--ink2); font-weight: 500; margin-bottom: 8px; }
.stat-value { font-size: 32px; font-weight: 700; color: #ff3b5f; letter-spacing: -.5px; }
.stat-value.percent { color: #ff3b5f; }
.chart-box { background: var(--soft); border: 1px solid #f0f0f0; border-radius: 16px; padding: 24px; height: 350px;}
.chart-title { font-size: 18px; font-weight: 600; color: #2f343b; margin-bottom: 20px; text-align: left; }
</style>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1"></script>
</head>
<body>
<jsp:include page="/include/nav.jsp" />
<div class="container">

  <!-- 제목/배지 -->
  <div class="page-title">
    <h1>${cert.jmName}</h1>
    <div class="badges">
      <span class="badge grade">${cert.grade}</span>
      <span class="badge field">${cert.field}</span>
    </div>
  </div>

  <!-- 탭 / 연도 -->
  <div class="topline">
    <div class="tabs">
      <c:set var="currentYear" value="${cert.year}"/>
      <c:set var="currentImpl" value="${cert.implSeq}"/>
      <c:forEach var="r" items="${cert.rounds}">
        <c:if test="${r.year == currentYear}">
          <a class="tab ${r.implSeq == currentImpl ? 'active' : ''}"
             href="<%=ctx%>/certificationDetail.cert?jmcd=${cert.jmcd}&year=${r.year}&implSeq=${r.implSeq}">
            ${r.implSeq}회차
          </a>
        </c:if>
      </c:forEach>
    </div>

    <div class="year-filter">
      <select id="yearSelect" class="filter-select">
        <c:set var="prevYear" value="-1"/>
        <c:forEach var="r" items="${cert.rounds}">
          <c:if test="${r.year ne prevYear}">
            <option value="${r.year}" ${r.year == cert.year ? 'selected' : ''}>${r.year}년</option>
            <c:set var="prevYear" value="${r.year}"/>
          </c:if>
        </c:forEach>
      </select>
    </div>
  </div> <!-- ⬅ .topline 닫기 -->

  <!-- 필기 -->
  <div class="section">
    <div class="section-header">
      <div class="icon">
        <svg viewBox="0 0 49 49" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
          <path d="M31.6455 10.2083C34.513 10.2083 35.9467 10.2083 36.9766 10.8964C37.4224 11.1943 37.8053 11.5771 38.1032 12.023C38.7913 13.0529 38.7913 14.4866 38.7913 17.3541V36.7499C38.7913 40.5997 38.7913 42.5246 37.5954 43.7206C36.3994 44.9166 34.4745 44.9166 30.6247 44.9166H18.3747C14.5249 44.9166 12.6 44.9166 11.404 43.7206C10.208 42.5246 10.208 40.5997 10.208 36.7499V17.3541C10.208 14.4866 10.208 13.0529 10.8962 12.023C11.1941 11.5771 11.5769 11.1943 12.0228 10.8964C13.0527 10.2083 14.4864 10.2083 17.3538 10.2083" stroke="#8C8C8C" stroke-width="3"/>
          <path d="M18.375 10.2083C18.375 7.95317 20.2032 6.125 22.4583 6.125H26.5417C28.7968 6.125 30.625 7.95317 30.625 10.2083C30.625 12.4635 28.7968 14.2917 26.5417 14.2917H22.4583C20.2032 14.2917 18.375 12.4635 18.375 10.2083Z" stroke="#8C8C8C" stroke-width="3"/>
          <path d="M18.375 24.5L30.625 24.5" stroke="#8C8C8C" stroke-width="3" stroke-linecap="round"/>
          <path d="M18.375 32.6667L26.5417 32.6667" stroke="#8C8C8C" stroke-width="3" stroke-linecap="round"/>
        </svg>
      </div>
      <div class="section-title">필기시험</div>
    </div>

    <div class="rows">
      <div class="info">
        <div class="label">원서접수</div>
        <div class="value">
          <c:choose>
            <c:when test="${not empty cert.docRegStartDt}"><fmt:formatDate value="${cert.docRegStartDt}" pattern="yyyy.MM.dd (E)"/> ~ <fmt:formatDate value="${cert.docRegEndDt}" pattern="yyyy.MM.dd (E)"/></c:when>
            <c:otherwise><span class="muted">정보 없음</span></c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="info">
        <div class="label">시험일</div>
        <div class="value">
          <c:choose>
            <c:when test="${not empty cert.docExamStartDt && not empty cert.docExamEndDt}">
              <fmt:formatDate value="${cert.docExamStartDt}" pattern="yyyy.MM.dd (E)"/> ~
              <fmt:formatDate value="${cert.docExamEndDt}" pattern="yyyy.MM.dd (E)"/>
            </c:when>
            <c:when test="${not empty cert.docExamDt}">
              <fmt:formatDate value="${cert.docExamDt}" pattern="yyyy.MM.dd (E)"/>
            </c:when>
            <c:otherwise><span class="muted">정보 없음</span></c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="info">
        <div class="label">합격발표</div>
        <div class="value">
          <c:choose>
            <c:when test="${not empty cert.docPassDt}">
              <fmt:formatDate value="${cert.docPassDt}" pattern="yyyy.MM.dd (E)"/>
            </c:when>
            <c:otherwise><span class="muted">정보 없음</span></c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </div>

  <!-- 실기 -->
  <div class="section">
    <div class="section-header">
      <div class="icon">
        <svg viewBox="0 0 55 45" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
          <path d="M8.01772 5.20656C8.39525 3.34109 10.035 2 11.9382 2H45.0618C46.965 2 48.6047 3.3411 48.9823 5.20656L53.2724 26.4049C53.6485 28.2632 52.228 30 50.332 30H6.66796C4.77202 30 3.3515 28.2632 3.72758 26.4049L8.01772 5.20656Z" stroke="#8C8C8C" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
          <path d="M9 39L49 39" stroke="#8C8C8C" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
          <rect x="26" y="11" width="5" height="5" rx="0.15" fill="#8C8C8C"/>
          <rect x="20" y="16" width="6" height="6" rx="0.15" fill="#8C8C8C"/>
          <rect x="31" y="16" width="6" height="6" rx="0.15" fill="#8C8C8C"/>
          <rect x="37" y="11" width="6" height="5" rx="0.15" fill="#8C8C8C"/>
          <rect x="14" y="11" width="6" height="5" rx="0.15" fill="#8C8C8C"/>
        </svg>
      </div>
      <div class="section-title">실기시험</div>
    </div>

    <div class="rows">
      <div class="info">
        <div class="label">원서접수</div>
        <div class="value">
          <c:choose>
            <c:when test="${not empty cert.pracRegStartDt}"><fmt:formatDate value="${cert.pracRegStartDt}" pattern="yyyy.MM.dd (E)"/> ~ <fmt:formatDate value="${cert.pracRegEndDt}" pattern="yyyy.MM.dd (E)"/></c:when>
            <c:otherwise><span class="muted">정보 없음</span></c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="info">
        <div class="label">시험일</div>
        <div class="value">
          <c:choose>
            <c:when test="${not empty cert.pracExamStartDt && not empty cert.pracExamEndDt}">
              <fmt:formatDate value="${cert.pracExamStartDt}" pattern="yyyy.MM.dd (E)"/> ~
              <fmt:formatDate value="${cert.pracExamEndDt}" pattern="yyyy.MM.dd (E)"/>
            </c:when>
            <c:otherwise><span class="muted">정보 없음</span></c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="info">
        <div class="label">합격발표</div>
        <div class="value">
          <c:choose>
            <c:when test="${not empty cert.pracPassDt}">
              <fmt:formatDate value="${cert.pracPassDt}" pattern="yyyy.MM.dd (E)"/>
            </c:when>
            <c:otherwise><span class="muted">정보 없음</span></c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </div>

  <!-- 통계 섹션 (chartList가 있을 때만 표시) -->
  <c:if test="${not empty cert.chartList}">
    <div class="stats-section">
      <div class="stats-header">통계 정보</div>

      <div class="stats-rows">
        <div class="stat-card">
          <div class="stat-label">평균 필기 합격률 (최근 2년)</div>
          <div class="stat-value percent">
            <c:choose>
              <c:when test="${not empty cert.avgDocRate}">
                <fmt:formatNumber value="${cert.avgDocRate}" pattern="0.0"/>%
              </c:when>
              <c:otherwise>—</c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-label">평균 실기 합격률 (최근 2년)</div>
          <div class="stat-value percent">
            <c:choose>
              <c:when test="${not empty cert.avgPracRate}">
                <fmt:formatNumber value="${cert.avgPracRate}" pattern="0.0"/>%
              </c:when>
              <c:otherwise>—</c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-label">총 응시자 수 (최근 2년)</div>
          <div class="stat-value">
            <c:choose>
              <c:when test="${not empty cert.totalApplicants}">
                <fmt:formatNumber value="${cert.totalApplicants}" type="number" groupingUsed="true"/>
              </c:when>
              <c:otherwise>—</c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <div class="chart-box" style="margin-top: 16px;">
        <div class="chart-title">연도별 · 회차별 합격률</div>
        <canvas id="statsChart" height="300"></canvas>
      </div>
    </div>
  </c:if>

  <!-- roundsData (연도별 최신 회차 계산용) -->
  <ul id="roundsData" class="rounds-data">
    <c:forEach var="r" items="${cert.rounds}">
      <li data-year="${r.year}" data-impl="${r.implSeq}"></li>
    </c:forEach>
  </ul>
</div>

<script>
(function(){
  // ===== 연도 변경 시 해당 연도의 최신 회차로 이동 =====
  const sel = document.getElementById('yearSelect'); if(!sel) return;
  const map = {};
  document.querySelectorAll('#roundsData li').forEach(li=>{
    const y = +li.dataset.year, i = +li.dataset.impl;
    if(!map[y] || i > map[y]) map[y] = i;
  });
  sel.addEventListener('change', function(){
    const y = +this.value, impl = map[y] || 1, jmcd = '${cert.jmcd}';
    location.href = '<%=ctx%>/certificationDetail.cert?jmcd='+jmcd+'&year='+y+'&implSeq='+impl;
  });

  // ===== Chart.js 통계 그래프 =====
  const chartData = [
    <c:forEach var="s" items="${cert.chartList}" varStatus="st">
      {
        year: ${s.year},
        implSeq: ${s.implSeq},
        docRate: ${empty s.docRate ? 'null' : s.docRate},
        pracRate: ${empty s.pracRate ? 'null' : s.pracRate},
        docApplicants: ${empty s.docApplicants ? 'null' : s.docApplicants},
        pracApplicants: ${empty s.pracApplicants ? 'null' : s.pracApplicants}
      }<c:if test="${!st.last}">,</c:if>
    </c:forEach>
  ];

  if (!Array.isArray(chartData) || chartData.length === 0) return;

  // 오래된 연도 -> 최신 연도, 회차 오름차순
  const filtered = chartData
    .filter(Boolean)
    .sort((a, b) => a.year === b.year ? a.implSeq - b.implSeq : a.year - b.year);

  if (filtered.length === 0) return;

  // 라벨 & 데이터
  const labels = filtered.map(it => it.year + ' ' + it.implSeq + '회');
  const docRates = filtered.map(it => (typeof it.docRate === 'number' ? it.docRate : null));
  const pracRates = filtered.map(it => (typeof it.pracRate === 'number' ? it.pracRate : null));

  const ctx = document.getElementById('statsChart');
  if (!ctx) return;

  const DOC_COLOR  = '#3b82f6';  // 필기(파란색 유지)
  const PRAC_COLOR = '#FF7272';  // 실기(요청 색상)

  new Chart(ctx, {
    type: 'bar',
    data: {
      labels,
      datasets: [
        { label: '필기(%)', data: docRates,  backgroundColor: DOC_COLOR,  borderRadius: 6, barPercentage: 0.9, categoryPercentage: 0.6 },
        { label: '실기(%)', data: pracRates, backgroundColor: PRAC_COLOR, borderRadius: 6, barPercentage: 0.9, categoryPercentage: 0.6 }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        x: {
          ticks: {
            maxRotation: 0, minRotation: 0, autoSkip: false, overflow: 'visible',
            callback: function(value, index){ return labels[index]; },
            font: ctx => ({ size: Math.max(10, Math.min(12, ctx.chart.width / 90)) })
          },
          grid: { display: false }
        },
        y: {
          beginAtZero: true, suggestedMax: 100, max: 100,
          ticks: { callback: v => v + '%' },
          grid: { color: 'rgba(0,0,0,0.06)', borderDash: [4,4] }
        }
      },
      plugins: {
        legend: { position: 'top', labels: { usePointStyle: true, pointStyle: 'rectRounded' } },
        tooltip: {
          callbacks: {
            title: items => items[0].label,
            label: item => {
              const val = item.raw;
              return `${item.dataset.label}: ${val == null ? '정보 없음' : val.toFixed(1) + '%'}`;
            }
          }
        }
      }
    }
  });

  // ===== 요약 카드 프런트 보정 (백엔드 미세팅 대비) =====
  const checkEmpty = sel => {
    const el = document.querySelector(sel);
    return el && (el.textContent === '—' || el.textContent.trim() === '');
  };
  const setText = (sel, text) => { const el = document.querySelector(sel); if (el) el.textContent = text; };
  const sum = arr => arr.reduce((a,b)=>a + (Number.isFinite(b) ? b : 0), 0);
  const avg = arr => { const n = arr.filter(v => typeof v === 'number'); return n.length ? n.reduce((a,b)=>a+b,0)/n.length : null; };

  const yearsAsc = [...new Set(filtered.map(it => it.year))].sort((a,b)=>a-b);
  const recent2 = yearsAsc.slice(-2);
  const summaryData = filtered.filter(it => recent2.includes(it.year));
  const avgDoc = avg(summaryData.map(it => it.docRate ?? null));
  const avgPrac = avg(summaryData.map(it => it.pracRate ?? null));
  const totalApplicants = sum(summaryData.map(it => it.docApplicants || 0)) + sum(summaryData.map(it => it.pracApplicants || 0));

  if (checkEmpty('.stats-rows .stat-card:nth-child(1) .stat-value') && avgDoc != null) {
    setText('.stats-rows .stat-card:nth-child(1) .stat-value', avgDoc.toFixed(1) + '%');
  }
  if (checkEmpty('.stats-rows .stat-card:nth-child(2) .stat-value') && avgPrac != null) {
    setText('.stats-rows .stat-card:nth-child(2) .stat-value', avgPrac.toFixed(1) + '%');
  }
  if (checkEmpty('.stats-rows .stat-card:nth-child(3) .stat-value') && totalApplicants > 0) {
    setText('.stats-rows .stat-card:nth-child(3) .stat-value', totalApplicants.toLocaleString());
  }
})();
</script>

</body>
</html>
