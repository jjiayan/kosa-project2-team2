<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"  %>

<%
    // 컨텍스트 경로
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>${cert.jmName} 상세</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />

<style>
:root{
  --brand:#4F7DFF;          /* 탭 강조 (이미지의 파란 톤) */
  --accent:#FF7272;         /* 포인트 컬러 */
  --ink:#2b2b2b;
  --ink2:#666;
  --line:#e9eef6;
  --bg:#f7f9fc;
  --card:#ffffff;
  --soft:#f2f5fb;
  --radius:14px;
  --shadow:0 6px 18px rgba(30,60,90,.08);
}

*{box-sizing:border-box}
html,body{margin:0;padding:0}
body{
  font-family: 'Noto Sans KR', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
  color:var(--ink);
  background:var(--bg);
}

.container{
  max-width:1080px;
  margin:40px auto 80px;
  padding:0 20px;
}

/* 헤더 타이틀 */
.page-title{ text-align:center; margin:10px 0 28px;}
.page-title h1{ font-size:30px; font-weight:800; margin:0 0 10px;}
.badges{ display:flex; gap:8px; justify-content:center; }
.badge{
  display:inline-flex; align-items:center; gap:6px;
  font-size:12px; font-weight:700; color:#6b89ff;
  background:#eef3ff; padding:6px 10px; border-radius:999px;
}
.badge.pink{ color:#ff6e8a; background:#ffeef3; }

/* 상단 탭/연도 라인 */
.topline{
  display:flex; align-items:center; justify-content:space-between;
  margin:24px 0 16px;
}
.tabs{ display:flex; gap:18px; align-items:center; }
.tab{
  position:relative; font-size:18px; color:var(--ink2);
  padding:6px 4px; cursor:pointer; text-decoration:none;
}
.tab.active{ color:var(--brand); font-weight:800; }
.tab.active::after{
  content:''; position:absolute; left:0; right:0; bottom:-8px; height:3px;
  background:var(--brand); border-radius:2px;
}

/* 연도 드롭다운 */
.year-select{ display:flex; align-items:center; gap:10px; color:var(--ink2); }
.year-select select{
  appearance:none; -webkit-appearance:none; -moz-appearance:none;
  border:1px solid var(--line); background:#fff;
  padding:8px 36px 8px 12px; border-radius:10px; font-weight:600;
  box-shadow: var(--shadow);
  background-image: url("data:image/svg+xml,%3Csvg width='12' height='8' viewBox='0 0 12 8' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%23666' stroke-width='2' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
  background-repeat:no-repeat; background-position:right 10px center;
}

/* 섹션 카드 */
.section{ background:var(--card); border-radius:var(--radius); padding:18px; box-shadow:var(--shadow); }
.section + .section{ margin-top:18px; }

/* 섹션 헤더 */
.section-header{ display:flex; align-items:center; gap:10px; color:#8aa; margin-bottom:14px; }
.section-header .icon{
  width:28px; height:28px; display:inline-grid; place-items:center;
  background:#edf3ff; color:var(--brand); border-radius:8px; font-weight:800;
}

/* 라인 카드 (원서접수/시험/발표) */
.rows{ display:grid; grid-template-columns: repeat(3,1fr); gap:14px; }
@media (max-width:900px){ .rows{ grid-template-columns:1fr; } }

.info{
  background:#fff; border:1px solid var(--line); border-radius:12px;
  padding:14px 16px; min-height:60px; display:flex; flex-direction:column; gap:6px;
}
.info .label{ font-size:12px; color:#8a94a6; font-weight:700; letter-spacing:.2px; }
.info .value{ font-size:14px; color:#394150; font-weight:700; }

/* 도움말/빈값 */
.muted{ color:#95a0b2; font-weight:600; }

/* 숨김 데이터(연도맵 계산용) */
.rounds-data{ display:none; }
</style>
</head>
<body>
<div class="container">

 <!-- 타이틀 -->
 <div class="page-title">
   <h1>${cert.jmName}</h1>
   <div class="badges">
     <span class="badge">국가기술자격</span>
     <span class="badge pink">${cert.grade}</span>
   </div>
 </div>

 <!-- 탭 & 연도 -->
<div class="topline">
  <!-- 회차 탭: 현재 연도에 해당하는 회차만 출력 -->
  <div class="tabs">
    <c:set var="currentYear" value="${cert.year}" />
    <c:set var="currentImpl" value="${cert.implSeq}" />

    <c:forEach var="r" items="${cert.rounds}">
      <c:if test="${r.year == currentYear}">
        <a class="tab ${r.implSeq == currentImpl ? 'active' : ''}"
           href="<%=ctx%>/certificationDetail.cert?jmcd=${cert.jmcd}&year=${r.year}&implSeq=${r.implSeq}">
          ${r.implSeq}회차
        </a>
      </c:if>
    </c:forEach>
  </div>

  <!-- 연도 선택 -->
  <div class="year-select">
    <span>시험 연도:</span>
    <select id="yearSelect">
      <c:set var="prevYear" value="-1"/>

      <c:forEach var="r" items="${cert.rounds}">
        <c:if test="${r.year ne prevYear}">
          <option value="${r.year}" ${r.year == cert.year ? 'selected' : ''}>
            ${r.year}년
          </option>
          <c:set var="prevYear" value="${r.year}"/>
        </c:if>
      </c:forEach>
    </select>
  </div>
</div>


  <!-- 필기시험 -->
  <div class="section">
    <div class="section-header">
      <div class="icon">📝</div>
      <strong>필기시험</strong>
    </div>
    <div class="rows">
      <div class="info">
        <div class="label">원서접수</div>
        <div class="value">
          <c:choose>
            <c:when test="${not empty cert.docRegStartDt}">
              <fmt:formatDate value="${cert.docRegStartDt}" pattern="yyyy.MM.dd (E)"/> ~
              <fmt:formatDate value="${cert.docRegEndDt}"   pattern="yyyy.MM.dd (E)"/>
            </c:when>
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
              <fmt:formatDate value="${cert.docExamEndDt}"   pattern="yyyy.MM.dd (E)"/>
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

  <!-- 실기시험 -->
  <div class="section" style="background:var(--soft);">
    <div class="section-header">
      <div class="icon" style="background:#f0f3f7; color:#6c7c93;">🛠</div>
      <strong>실기시험</strong>
    </div>
    <div class="rows">
      <div class="info">
        <div class="label">원서접수</div>
        <div class="value">
          <c:choose>
            <c:when test="${not empty cert.pracRegStartDt}">
              <fmt:formatDate value="${cert.pracRegStartDt}" pattern="yyyy.MM.dd (E)"/> ~
              <fmt:formatDate value="${cert.pracRegEndDt}"   pattern="yyyy.MM.dd (E)"/>
            </c:when>
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
              <fmt:formatDate value="${cert.pracExamEndDt}"   pattern="yyyy.MM.dd (E)"/>
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

  <!-- rounds 원시데이터(연도 → 최신 회차 계산용) -->
  <ul id="roundsData" class="rounds-data">
    <c:forEach var="r" items="${cert.rounds}">
      <c:if test="${r.year == cert.year}">
    </c:if>
    </c:forEach>
  </ul>
</div>

<script>
(function(){
  // 연도 변경 시 해당 연도의 "가장 최신 회차(implSeq 최대)"로 이동
  const yearSel = document.getElementById('yearSelect');
  if(!yearSel) return;

  // roundsData로 연도->최대 implSeq 맵 구성
  const nodes = document.querySelectorAll('#roundsData li');
  const latestMap = {};
  nodes.forEach(n=>{
    const y = Number(n.dataset.year), i = Number(n.dataset.impl);
    if(!latestMap[y] || i > latestMap[y]) latestMap[y] = i;
  });

  yearSel.addEventListener('change', function(){
    const y = Number(this.value);
    const latestImpl = latestMap[y] || 1;
    const params = new URLSearchParams(window.location.search);
    const jmcd = params.get('jmcd') || '${cert.jmcd}';
    const url = '<%=ctx%>/certificationDetail.cert?jmcd=' + jmcd + '&year=' + y + '&implSeq=' + latestImpl;
    window.location.href = url;
  });
})();
</script>

</body>
</html>
