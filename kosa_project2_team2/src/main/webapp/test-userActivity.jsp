<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>사용자 활동 - 테스트</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  
  <style>
    :root {
      --ink: #222;
      --muted: #888;
      --line: #eee;
      --bg: #fafafa;
      --card: #fff;
      --shadow: 0 10px 28px rgba(0,0,0,.08);
      --accent: #ff6b6b;
    }
    
    * { box-sizing: border-box; }
    
    html, body {
      margin: 0;
      padding: 0;
      background: var(--bg);
      color: var(--ink);
      font-family: "Noto Sans KR", system-ui, -apple-system, sans-serif;
    }
    
    .page {
      min-height: 100vh;
      padding: 20px;
    }
    
    .heading-wrap {
      text-align: center;
      padding: 28px 20px 0;
    }
    
    .heading {
      font-size: 42px;
      font-weight: 900;
      color: #777;
      margin: 24px 0 18px;
    }
    
    .container {
      max-width: 1180px;
      margin: 0 auto;
      padding: 0 20px 28px;
    }
    
    .layout {
      display: grid;
      grid-template-columns: 1fr;
      gap: 18px;
    }
    
    .card {
      background: var(--card);
      border-radius: 16px;
      box-shadow: var(--shadow);
    }
    
    /* 프로필 카드 스타일 */
    .profile-card {
      padding: 0;
      overflow: hidden;
    }
    
    .profile-title {
      padding: 12px 18px;
      font-size: 15px;
      font-weight: 700;
      color: #333;
      border-bottom: 1px solid #dadada;
      background: #fff;
    }
    
    .profile-body {
      position: relative;
      padding: 20px 22px 18px 34px;
      background: #fff;
    }
    
    .profile-main {
      display: flex;
      gap: 22px;
      align-items: center;
      justify-content: center;
      margin: 16px 0;
    }
    
    .user-avatar-box {
      flex: 0 0 auto;
      width: 140px;
      height: 140px;
      border: 4px solid #f1f1f1;
      border-radius: 50%;
      overflow: hidden;
      background: #f7f7f7;
    }
    
    .user-avatar {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
    }
    
    .user-name {
      font-size: 36px;
      font-weight: 900;
      line-height: 1.2;
      margin: 0;
      text-align: center;
    }
    
    /* 탭 스타일 */
    .tab-container {
      background: var(--card);
      border-radius: 16px;
      box-shadow: var(--shadow);
      overflow: hidden;
      margin-top: 16px;
    }
    
    .tab-header {
      display: flex;
      background: #fafafa;
      border-bottom: 1px solid var(--line);
    }
    
    .tab-btn {
      flex: 1;
      padding: 16px 20px;
      border: none;
      background: transparent;
      color: var(--muted);
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      border-bottom: 3px solid transparent;
    }
    
    .tab-btn:hover {
      color: var(--ink);
      background: rgba(255, 107, 107, 0.1);
    }
    
    .tab-btn.active {
      color: var(--accent);
      background: #fff;
      border-bottom-color: var(--accent);
    }
    
    /* 테이블 스타일 */
    .table-container {
      background: #fff;
      border-radius: 0 0 16px 16px;
      overflow: hidden;
    }
    
    .table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
      table-layout: fixed;
    }
    
    .table thead th {
      text-align: left;
      font-weight: 800;
      font-size: 15px;
      color: #374151;
      padding: 18px 22px;
      background: #fafafa;
      overflow: hidden;
      white-space: nowrap;
      text-overflow: ellipsis;
    }
    
    .table tbody td {
      padding: 18px 22px;
      border-top: 1px solid var(--line);
      font-size: 14px;
      color: #111;
      overflow: hidden;
      white-space: nowrap;
      text-overflow: ellipsis;
      word-break: keep-all;
    }
    
    .table tbody td.meta {
      color: var(--muted);
    }
    
    .table a.link {
      display: block;
      max-width: 100%;
      overflow: hidden;
      white-space: nowrap;
      text-overflow: ellipsis;
      color: #111;
      text-decoration: none;
    }
    
    .table a.link:hover {
      color: var(--accent);
      text-decoration: underline;
    }
    
    /* 페이지네이션 */
    .pagination {
      display: flex;
      gap: 12px;
      align-items: center;
      justify-content: center;
      margin-top: 18px;
      padding: 20px;
    }
    
    .page-btn {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      border: 1px solid var(--line);
      background: #fff;
      color: #374151;
      cursor: pointer;
      font-size: 14px;
      font-weight: 500;
    }
    
    .page-btn:hover {
      background: #f3f4f6;
    }
    
    .page-btn.active {
      background: var(--accent);
      color: #fff;
      font-weight: 700;
      border-color: var(--accent);
    }
    
    .page-btn:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }
    
    .empty-state {
      text-align: center;
      padding: 60px 20px;
      color: var(--muted);
      font-size: 14px;
    }
    
    .loading {
      text-align: center;
      padding: 40px 20px;
      color: var(--muted);
    }
    
    /* 반응형 */
    @media (max-width: 768px) {
      .tab-header {
        flex-wrap: wrap;
      }
      
      .tab-btn {
        min-width: 50%;
        border-bottom: 1px solid var(--line);
        border-right: 1px solid var(--line);
      }
      
      .tab-btn:nth-child(2n) {
        border-right: none;
      }
      
      .tab-btn:last-child {
        border-bottom: none;
      }
      
      .table thead th,
      .table tbody td {
        padding: 12px 16px;
        font-size: 13px;
      }
      
      .profile-main {
        flex-direction: column;
        text-align: center;
      }
      
      .user-avatar-box {
        width: 120px;
        height: 120px;
      }
      
      .user-name {
        font-size: 28px;
      }
    }
    
    @media (max-width: 480px) {
      .heading {
        font-size: 28px;
      }
      
      .container {
        padding: 0 10px 20px;
      }
      
      .profile-body {
        padding: 16px 20px;
      }
      
      .user-avatar-box {
        width: 100px;
        height: 100px;
      }
      
      .user-name {
        font-size: 24px;
      }
      
      .tab-btn {
        padding: 12px 16px;
        font-size: 13px;
      }
      
      .table thead th,
      .table tbody td {
        padding: 10px 12px;
        font-size: 12px;
      }
    }
  </style>
</head>

<body>
  <div class="page">
    <div class="heading-wrap">
      <h1 class="heading">사용자 활동</h1>
    </div>
    
    <div class="container">
      <div class="layout">
        <!-- 프로필 카드 -->
        <section class="card profile-card">
          <div class="profile-title">사용자 정보</div>
          <div class="profile-body">
            <div class="profile-main">
              <div class="user-avatar-box">
                <img class="user-avatar" src="https://via.placeholder.com/140x140/4CAF50/ffffff?text=U" alt="프로필">
              </div>
              <div>
                <h2 class="user-name">건재이</h2>
              </div>
            </div>
          </div>
        </section>
        
        <!-- 활동 탭 -->
        <section class="tab-container">
          <div class="tab-header">
            <button class="tab-btn active" data-tab="posts">작성한 글</button>
            <button class="tab-btn" data-tab="comments">작성한 댓글</button>
            <button class="tab-btn" data-tab="commented">댓글단 글</button>
            <button class="tab-btn" data-tab="likes">좋아요한 글</button>
          </div>
          
          <div class="table-container">
            <table class="table">
              <colgroup>
                <col style="width: 10%">
                <col style="width: 50%">
                <col style="width: 20%">
                <col style="width: 20%">
              </colgroup>
              <thead>
                <tr>
                  <th>번호</th>
                  <th>제목</th>
                  <th>작성일</th>
                  <th>조회수</th>
                </tr>
              </thead>
              <tbody id="activityTableBody">
                <!-- 동적으로 생성됨 -->
              </tbody>
            </table>
          </div>
          
          <nav id="pagination" class="pagination">
            <!-- 동적으로 생성됨 -->
          </nav>
        </section>
      </div>
    </div>
  </div>
  
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    $(document).ready(function() {
      // 테스트용 모의 데이터
      const mockData = {
        posts: [
          { id: 1, title: "자바 스터디 1주차 정리", date: "2024-10-15", views: 45 },
          { id: 2, title: "알고리즘 문제 풀이 공유", date: "2024-10-14", views: 32 },
          { id: 3, title: "스프링 부트 환경설정 방법", date: "2024-10-13", views: 78 },
          { id: 4, title: "데이터베이스 설계 원칙", date: "2024-10-12", views: 56 },
          { id: 5, title: "Git 사용법 정리", date: "2024-10-11", views: 23 },
          { id: 6, title: "REST API 설계 가이드", date: "2024-10-10", views: 67 },
          { id: 7, title: "JPA 연관관계 매핑", date: "2024-10-09", views: 89 },
          { id: 8, title: "테스트 코드 작성법", date: "2024-10-08", views: 34 }
        ],
        comments: [
          { id: 1, title: "자바 기초 문법 질문", date: "2024-10-15", views: 12 },
          { id: 2, title: "스프링 MVC 패턴 이해", date: "2024-10-14", views: 28 },
          { id: 3, title: "MySQL 성능 최적화", date: "2024-10-13", views: 45 },
          { id: 4, title: "리액트 상태 관리", date: "2024-10-12", views: 33 },
          { id: 5, title: "Node.js 비동기 처리", date: "2024-10-11", views: 67 }
        ],
        commented: [
          { id: 1, title: "프론트엔드 개발 트렌드", date: "2024-10-15", views: 89 },
          { id: 2, title: "백엔드 API 설계", date: "2024-10-14", views: 45 },
          { id: 3, title: "데이터베이스 최적화", date: "2024-10-13", views: 67 },
          { id: 4, title: "클라우드 서비스 비교", date: "2024-10-12", views: 78 },
          { id: 5, title: "보안 취약점 분석", date: "2024-10-11", views: 34 },
          { id: 6, title: "성능 모니터링 도구", date: "2024-10-10", views: 56 }
        ],
        likes: [
          { id: 1, title: "효율적인 코딩 습관", date: "2024-10-15", views: 123 },
          { id: 2, title: "개발자 커리어 가이드", date: "2024-10-14", views: 98 },
          { id: 3, title: "오픈소스 기여 방법", date: "2024-10-13", views: 87 },
          { id: 4, title: "소프트웨어 아키텍처", date: "2024-10-12", views: 76 },
          { id: 5, title: "클린 코드 원칙", date: "2024-10-11", views: 145 },
          { id: 6, title: "애자일 개발 방법론", date: "2024-10-10", views: 65 },
          { id: 7, title: "DevOps 도구 활용", date: "2024-10-09", views: 54 },
          { id: 8, title: "마이크로서비스 패턴", date: "2024-10-08", views: 89 },
          { id: 9, title: "컨테이너 기술 이해", date: "2024-10-07", views: 43 }
        ]
      };
      
      let currentTab = 'posts';
      let currentPage = 1;
      const pageSize = 5;
      
      // 테이블 렌더링
      function renderTable(data) {
        const $tbody = $('#activityTableBody');
        $tbody.empty();
        
        if (!data || data.length === 0) {
          $tbody.html('<tr><td colspan="4" class="empty-state">표시할 데이터가 없습니다.</td></tr>');
          return;
        }
        
        const startIndex = (currentPage - 1) * pageSize;
        const endIndex = startIndex + pageSize;
        const pageData = data.slice(startIndex, endIndex);
        
        pageData.forEach(function(item, index) {
          const rowNumber = startIndex + index + 1;
          const row = `
            <tr>
              <td class="meta">${rowNumber}</td>
              <td><a class="link" href="#" title="${escapeHtml(item.title)}">${escapeHtml(item.title)}</a></td>
              <td class="meta">${item.date}</td>
              <td class="meta">${item.views}</td>
            </tr>
          `;
          $tbody.append(row);
        });
      }
      
      // 페이지네이션 렌더링
      function renderPagination(totalItems) {
        const $pagination = $('#pagination');
        $pagination.empty();
        
        const totalPages = Math.ceil(totalItems / pageSize);
        
        if (totalPages <= 1) return;
        
        // 이전 버튼
        const prevBtn = $('<button class="page-btn">‹</button>');
        if (currentPage <= 1) {
          prevBtn.prop('disabled', true);
        } else {
          prevBtn.on('click', function() {
            currentPage--;
            loadCurrentTab();
          });
        }
        $pagination.append(prevBtn);
        
        // 페이지 번호들
        const startPage = Math.max(1, currentPage - 2);
        const endPage = Math.min(totalPages, startPage + 4);
        
        for (let i = startPage; i <= endPage; i++) {
          const pageBtn = $('<button class="page-btn">' + i + '</button>');
          if (i === currentPage) {
            pageBtn.addClass('active');
          } else {
            pageBtn.on('click', function() {
              currentPage = i;
              loadCurrentTab();
            });
          }
          $pagination.append(pageBtn);
        }
        
        // 다음 버튼
        const nextBtn = $('<button class="page-btn">›</button>');
        if (currentPage >= totalPages) {
          nextBtn.prop('disabled', true);
        } else {
          nextBtn.on('click', function() {
            currentPage++;
            loadCurrentTab();
          });
        }
        $pagination.append(nextBtn);
      }
      
      // 현재 탭 데이터 로드
      function loadCurrentTab() {
        const data = mockData[currentTab] || [];
        renderTable(data);
        renderPagination(data.length);
      }
      
      // 탭 클릭 이벤트
      $('.tab-btn').on('click', function() {
        const tab = $(this).data('tab');
        if (tab === currentTab) return;
        
        $('.tab-btn').removeClass('active');
        $(this).addClass('active');
        
        currentTab = tab;
        currentPage = 1;
        loadCurrentTab();
      });
      
      // HTML 이스케이프
      function escapeHtml(text) {
        if (!text) return '';
        return String(text)
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;')
          .replace(/'/g, '&#39;');
      }
      
      // 초기 로드
      loadCurrentTab();
    });
  </script>
</body>
</html>