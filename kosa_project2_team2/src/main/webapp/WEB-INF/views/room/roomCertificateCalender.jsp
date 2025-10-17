<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.or.kosa.dto.SearchCertificateDto" %>
<%@ page import="kr.or.kosa.dto.CertificateDateDto" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자격증 일정 캘린더</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css">
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.css' rel='stylesheet' />
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/locales/ko.global.min.js'></script>
<style>
/* ===== 전체 레이아웃 ===== */
.layout-wrap {
    display: grid;
    grid-template-columns: auto 1fr;
    gap: 0;
    align-items: flex-start;
    margin: 0;
    padding: 0;
}

main {
    background: #fff;
    border-left: 1px solid #e5e7eb;
    padding: 24px 28px;
    min-height: 100vh;
}

/* ===== 캘린더 스타일 ===== */
.calendar-container {
    max-width: 1200px;
    margin: 0 auto;
}

.calendar-header {
    text-align: center;
    margin-bottom: 30px;
}

.calendar-header h1 {
    color: #333;
    font-size: 2em;
    margin-bottom: 10px;
}

.calendar-header .subtitle {
    color: #666;
    font-size: 1em;
}

/* ===== 필터 버튼 ===== */
.filter-section {
    background: #f8f9fa;
    padding: 20px;
    border-radius: 10px;
    margin-bottom: 30px;
    display: flex;
    gap: 15px;
    flex-wrap: wrap;
    align-items: center;
}

.filter-section label {
    font-weight: 600;
    color: #555;
}

.btn-group {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.filter-btn {
    padding: 10px 20px;
    border: 2px solid #FF7272;
    background: white;
    color: #FF7272;
    border-radius: 25px;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.3s ease;
}

.filter-btn:hover {
    background: #FF7272;
    color: white;
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(255, 114, 114, 0.3);
}

.filter-btn.active {
    background: #FF7272;
    color: white;
}

/* ===== 캘린더 박스 ===== */
#calendar {
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.fc-event {
    cursor: pointer;
    border: none !important;
    padding: 2px 5px;
}

.event-reg {
    background-color: #4CAF50 !important;
}

.event-exam {
    background-color: #2196F3 !important;
}

.event-prac {
    background-color: #FF9800 !important;
}

/* ===== 범례 ===== */
.legend {
    display: flex;
    gap: 20px;
    justify-content: center;
    margin-top: 20px;
    flex-wrap: wrap;
}

.legend-item {
    display: flex;
    align-items: center;
    gap: 8px;
}

.legend-color {
    width: 20px;
    height: 20px;
    border-radius: 4px;
}

/* ===== 모달 ===== */
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.5);
}

.modal-content {
    background-color: white;
    margin: 10% auto;
    padding: 30px;
    border-radius: 15px;
    width: 90%;
    max-width: 500px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.3);
}

.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
    line-height: 20px;
}

.close:hover {
    color: #000;
}

.modal-header {
    margin-bottom: 20px;
    border-bottom: 2px solid #667eea;
    padding-bottom: 10px;
}

.modal-header h2 {
    color: #333;
    margin: 0;
}

.modal-body {
    line-height: 1.8;
}

.modal-body p {
    margin: 10px 0;
    color: #555;
}

.modal-body strong {
    color: #333;
}

/* ===== 캘린더 헤더 커스터마이징 ===== */
.fc-header-toolbar {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 12px;
  margin-bottom: 20px;
  position: relative;
}

.fc-toolbar-title {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  font-size: 1.8rem;
  font-weight: 700;
  color: #333;
}

/* ===== 이전 / 다음 버튼 (최종 깔끔 스타일) ===== */
.fc-prev-button,
.fc-next-button {
  background: transparent !important;
  border: none !important;
  box-shadow: none !important;
  width: 40px !important;
  height: 40px !important;
  padding: 0 !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  transition: transform 0.2s ease, opacity 0.2s ease;
}

/* 기본 아이콘 숨기기 */
.fc-prev-button .fc-icon,
.fc-next-button .fc-icon {
  display: none !important;
}

/* 얇고 고급스러운 기호 */
.fc-prev-button::after,
.fc-next-button::after {
  font-family: "Arial", sans-serif;
  font-weight: 400;
  font-size: 2rem;
  color: #FF7272;
  transition: color 0.2s ease, transform 0.2s ease;
}

.fc-prev-button::after {
  content: "‹";
}

.fc-next-button::after {
  content: "›";
}

/* hover / active 효과 */
.fc-prev-button:hover::after,
.fc-next-button:hover::after {
  color: #ff4d4d;
  transform: translateY(-1px);
}

.fc-prev-button:active::after,
.fc-next-button:active::after {
  transform: scale(0.95);
}

/* ===== Today 버튼 ===== */
.fc-today-button {
  background: #fff !important;
  color: #FF7272 !important;
  border: 2px solid #FF7272 !important;
  border-radius: 20px !important;
  padding: 6px 16px !important;
  font-weight: 600 !important;
  transition: all 0.25s ease-in-out;
}

.fc-today-button:hover {
  background: #FF7272 !important;
  color: #fff !important;
  transform: translateY(-2px);
}

/* ===== 반응형 ===== */
@media (max-width: 900px) {
    .layout-wrap {
        grid-template-columns: 1fr;
    }
    main {
        border-left: none;
        border-top: 1px solid #e5e7eb;
        padding: 16px;
    }
    .calendar-header h1 {
        font-size: 1.5em;
    }
}



</style>
</head>
<body>
    <!-- 공통 네비게이션 -->
    <jsp:include page="/include/nav.jsp" />
    
    <!-- 사이드바 + 메인 레이아웃 -->
    <div class="layout-wrap">
        
        <!-- 좌측 사이드바 -->
        <jsp:include page="/include/sidebar.jsp">
            <jsp:param name="current" value="calendar"/>
        </jsp:include>
        
        <!-- 우측 본문 -->
        <main>
            <div class="calendar-container">
                <div class="calendar-header">
                    <h1>📅 자격증 일정 캘린더</h1>
                    <p class="subtitle">원하는 일정 유형을 선택하여 확인하세요</p>
                </div>
                
                <div class="filter-section">
                    <label>일정 필터:</label>
                    <div class="btn-group">
                        <button class="filter-btn active" data-filter="all">전체</button>
                        <button class="filter-btn" data-filter="reg">원서접수</button>
                        <button class="filter-btn" data-filter="exam">필기시험</button>
                        <button class="filter-btn" data-filter="prac">실기시험</button>
                    </div>
                </div>
                
                <div id="calendar"></div>
                
                <div class="legend">
                    <div class="legend-item">
                        <div class="legend-color event-reg"></div>
                        <span>원서접수</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color event-exam"></div>
                        <span>필기시험</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color event-prac"></div>
                        <span>실기시험</span>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- 모달 -->
    <div id="eventModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <div class="modal-header">
                <h2 id="modalTitle"></h2>
            </div>
            <div class="modal-body" id="modalBody"></div>
        </div>
    </div>

<script>
<%
SearchCertificateDto certificateData = (SearchCertificateDto) request.getAttribute("info");
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

String certName = "";
CertificateDateDto reg = null;
CertificateDateDto exam = null;
CertificateDateDto prac = null;

if(certificateData != null) {
    Map<String, CertificateDateDto> info = certificateData.getInfo();
    certName = certificateData.getTotalJmName();
    reg = info.get("원서");
    exam = info.get("필기");
    prac = info.get("실기");
}
%>

document.addEventListener('DOMContentLoaded', function() {
    const calendarEl = document.getElementById('calendar');
    const allEvents = [];
    
    const certName = '<%= certName %>';
    
    // 원서접수 기간
    <% if(reg != null && reg.getDocRegStartDt() != null && reg.getDocRegEndDt() != null) { %>
    allEvents.push({
        title: '📝 원서접수',
        start: '<%= sdf.format(reg.getDocRegStartDt()) %>',
        end: '<%= sdf.format(reg.getDocRegEndDt()) %>',
        className: 'event-reg',
        extendedProps: {
            type: 'reg',
            certName: certName,
            description: '원서접수 기간입니다.'
        }
    });
    <% } %>
    
    // 필기시험 접수 기간
    <% if(exam != null && exam.getDocExamStartDt() != null && exam.getDocExamEndDt() != null) { %>
    allEvents.push({
        title: '✏️ 필기시험 접수',
        start: '<%= sdf.format(exam.getDocExamStartDt()) %>',
        end: '<%= sdf.format(exam.getDocExamEndDt()) %>',
        className: 'event-exam',
        extendedProps: {
            type: 'exam',
            certName: certName,
            description: '필기시험 접수 기간입니다.'
        }
    });
    <% } %>
    
    // 필기시험일
    <% if(exam != null && exam.getDocExamDt() != null) { %>
    allEvents.push({
        title: '📖 필기시험일',
        start: '<%= sdf.format(exam.getDocExamDt()) %>',
        className: 'event-exam',
        extendedProps: {
            type: 'exam',
            certName: certName,
            description: '필기시험이 진행됩니다.'
        }
    });
    <% } %>
    
    // 필기 합격발표
    <% if(exam != null && exam.getDocPassDt() != null) { %>
    allEvents.push({
        title: '🎉 필기 합격발표',
        start: '<%= sdf.format(exam.getDocPassDt()) %>',
        className: 'event-exam',
        extendedProps: {
            type: 'exam',
            certName: certName,
            description: '필기시험 합격자가 발표됩니다.'
        }
    });
    <% } %>
    
    // 실기접수 기간
    <% if(prac != null && prac.getPracRegStartDt() != null && prac.getPracRegEndDt() != null) { %>
    allEvents.push({
        title: '🔧 실기접수',
        start: '<%= sdf.format(prac.getPracRegStartDt()) %>',
        end: '<%= sdf.format(prac.getPracRegEndDt()) %>',
        className: 'event-prac',
        extendedProps: {
            type: 'prac',
            certName: certName,
            description: '실기시험 접수 기간입니다.'
        }
    });
    <% } %>
    
    // 실기시험 기간
    <% if(prac != null && prac.getPracExamStartDt() != null && prac.getPracExamEndDt() != null) { %>
    allEvents.push({
        title: '⚙️ 실기시험',
        start: '<%= sdf.format(prac.getPracExamStartDt()) %>',
        end: '<%= sdf.format(prac.getPracExamEndDt()) %>',
        className: 'event-prac',
        extendedProps: {
            type: 'prac',
            certName: certName,
            description: '실기시험 기간입니다.'
        }
    });
    <% } %>
    
    // 최종 합격발표
    <% if(prac != null && prac.getPracPassDt() != null) { %>
    allEvents.push({
        title: '🎊 최종 합격발표',
        start: '<%= sdf.format(prac.getPracPassDt()) %>',
        className: 'event-prac',
        extendedProps: {
            type: 'prac',
            certName: certName,
            description: '최종 합격자가 발표됩니다.'
        }
    });
    <% } %>
    
    const calendar = new FullCalendar.Calendar(calendarEl, {
        locale: 'ko',
        initialView: 'dayGridMonth',
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: ''
        },
        events: allEvents,
        eventClick: function(info) {
            const modal = document.getElementById('eventModal');
            const modalTitle = document.getElementById('modalTitle');
            const modalBody = document.getElementById('modalBody');
            
            modalTitle.textContent = info.event.title;
            modalBody.innerHTML = 
                '<p><strong>자격증:</strong> ' + info.event.extendedProps.certName + '</p>' +
                '<p><strong>날짜:</strong> ' + info.event.start.toLocaleDateString('ko-KR') + '</p>' +
                '<p><strong>내용:</strong> ' + info.event.extendedProps.description + '</p>';
            
            modal.style.display = 'block';
        },
        height: 'auto'
    });
    
    calendar.render();
    
    // 필터 버튼 기능
    const filterBtns = document.querySelectorAll('.filter-btn[data-filter]');
    filterBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            filterBtns.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            
            const filter = this.getAttribute('data-filter');
            const filteredEvents = filter === 'all' ? allEvents : 
                allEvents.filter(e => e.extendedProps.type === filter);
            
            calendar.removeAllEvents();
            calendar.addEventSource(filteredEvents);
            
            // 가장 가까운 날짜로 이동
            if (filter !== 'all' && filteredEvents.length > 0) {
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                
                let closestEvent = null;
                let minDiff = Infinity;
                
                filteredEvents.forEach(function(event) {
                    const eventDate = new Date(event.start);
                    eventDate.setHours(0, 0, 0, 0);
                    const diff = eventDate - today;
                    
                    if (diff >= 0 && diff < minDiff) {
                        minDiff = diff;
                        closestEvent = event;
                    }
                });
                
                if (!closestEvent) {
                    filteredEvents.forEach(function(event) {
                        const eventDate = new Date(event.start);
                        eventDate.setHours(0, 0, 0, 0);
                        const diff = Math.abs(eventDate - today);
                        
                        if (diff < minDiff) {
                            minDiff = diff;
                            closestEvent = event;
                        }
                    });
                }
                
                if (closestEvent) {
                    calendar.gotoDate(closestEvent.start);
                }
            }
        });
    });
    
    // 모달 닫기
    const modal = document.getElementById('eventModal');
    const span = document.getElementsByClassName('close')[0];
    
    span.onclick = function() {
        modal.style.display = 'none';
    }
    
    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = 'none';
        }
    }
});
</script>
</body>
</html>