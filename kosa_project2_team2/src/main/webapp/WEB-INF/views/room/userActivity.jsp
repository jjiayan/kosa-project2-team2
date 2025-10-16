<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title><c:out value="${userInfo.user_nickname}"/>님의 활동</title>
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
    
    /* 댓글 내용 표시 */
    .comment-content {
      max-width: 200px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
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
  </style>
</head>

<body>
  <jsp:include page="/include/nav.jsp" />
  
  <c:set var="ctx" value="${pageContext.request.contextPath}" />
  
  <div class="page">
    <div class="heading-wrap">
      <h1 class="heading"><c:out value="${userInfo.user_nickname}"/>님의 활동</h1>
    </div>
    
    <div class="container">
      <div class="layout">
        <!-- 프로필 카드 -->
        <section class="card profile-card">
          <div class="profile-title">사용자 정보</div>
          <div class="profile-body">
            <div class="profile-main">
              <div class="user-avatar-box">
                <c:choose>
                  <c:when test="${not empty userInfo.user_photo}">
                    <img class="user-avatar" src="${ctx}${userInfo.user_photo}" alt="프로필">
                  </c:when>
                  <c:otherwise>
                    <img class="user-avatar" src="${ctx}/images/default-avatar.png" alt="프로필">
                  </c:otherwise>
                </c:choose>
              </div>
              <div>
                <h2 class="user-name"><c:out value="${userInfo.user_nickname}"/></h2>
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
            <table class="table" id="activityTable">
              <colgroup id="tableColgroup">
                <col style="width: 10%">
                <col style="width: 50%">
                <col style="width: 20%">
                <col style="width: 20%">
              </colgroup>
              <thead>
                <tr id="tableHeader">
                  <th>번호</th>
                  <th>제목</th>
                  <th>작성일</th>
                  <th>조회수</th>
                </tr>
              </thead>
              <tbody id="activityTableBody">
                <tr>
                  <td colspan="4" class="loading">로딩 중...</td>
                </tr>
              </tbody>
            </table>
          </div>
          
          <nav id="pagination" class="pagination"></nav>
        </section>
      </div>
    </div>
  </div>
  
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    $(document).ready(function() {
      var ctx = '${ctx}';
      var targetUserId = ${targetUserId};
      var roomId = ${roomId};
      
      var currentTab = 'posts';
      var currentPage = 1;
      var pageSize = 10;
      
      // 탭별 테이블 헤더 설정
      var tableHeaders = {
        posts: ['번호', '제목', '작성일', '조회수'],
        comments: ['번호', '게시글 제목', '댓글 내용', '작성일'],
        commented: ['번호', '제목', '내 댓글 수', '작성일'],
        likes: ['번호', '제목', '좋아요 일시', '조회수']
      };
      
      // HTML 이스케이프 함수
      function escapeHtml(text) {
        if (!text) return '';
        return String(text)
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;')
          .replace(/'/g, '&#39;');
      }
      
      // 활동 데이터 로드
      function loadActivityData() {
        var $tbody = $('#activityTableBody');
        $tbody.html('<tr><td colspan="4" class="loading">로딩 중...</td></tr>');
        
        $.ajax({
          url: ctx + '/room/ajax/useractivity.ajax',
          data: {
            userId: targetUserId,
            roomId: roomId,
            tab: currentTab,
            page: currentPage,
            size: pageSize
          },
          success: function(response) {
            if (response.success) {
              updateTableHeader();
              renderActivityTable(response.data);
              renderPagination(response.totalPages, response.currentPage);
            } else {
              $tbody.html('<tr><td colspan="4" class="empty-state">' + (response.message || '데이터를 불러올 수 없습니다.') + '</td></tr>');
            }
          },
          error: function() {
            $tbody.html('<tr><td colspan="4" class="empty-state">데이터를 불러오는 중 오류가 발생했습니다.</td></tr>');
          }
        });
      }
      
      // 테이블 헤더 업데이트
      function updateTableHeader() {
        var headers = tableHeaders[currentTab];
        var $header = $('#tableHeader');
        $header.empty();
        
        headers.forEach(function(header) {
          $header.append('<th>' + header + '</th>');
        });
      }
      
      // 테이블 렌더링
      function renderActivityTable(items) {
        var $tbody = $('#activityTableBody');
        $tbody.empty();
        
        if (!items || items.length === 0) {
          $tbody.html('<tr><td colspan="4" class="empty-state">표시할 데이터가 없습니다.</td></tr>');
          return;
        }
        
        items.forEach(function(item, index) {
          var rowNumber = (currentPage - 1) * pageSize + index + 1;
          var row = createTableRow(item, rowNumber);
          $tbody.append(row);
        });
      }
      
      // 테이블 행 생성
      function createTableRow(item, rowNumber) {
        var createdAt = item.createdAt ? new Date(item.createdAt).toLocaleDateString('ko-KR') : '';
        var rowHtml = '';
        
        switch (currentTab) {
          case 'posts':
            var postUrl = ctx + '/roomboarddetail.room?roomBoardId=' + item.roomBoardId + '&userId=' + targetUserId;
            rowHtml = '<tr>' +
              '<td class="meta">' + rowNumber + '</td>' +
              '<td><a class="link" href="' + postUrl + '" title="' + escapeHtml(item.title) + '">' + escapeHtml(item.title) + '</a></td>' +
              '<td class="meta">' + createdAt + '</td>' +
              '<td class="meta">' + (item.viewCount || 0) + '</td>' +
              '</tr>';
            break;
            
          case 'comments':
            var commentPostUrl = ctx + '/roomboarddetail.room?roomBoardId=' + item.roomBoardId + '&userId=' + targetUserId + '#reply-' + item.replyId;
            rowHtml = '<tr>' +
              '<td class="meta">' + rowNumber + '</td>' +
              '<td><a class="link" href="' + commentPostUrl + '" title="' + escapeHtml(item.title) + '">' + escapeHtml(item.title) + '</a></td>' +
              '<td class="meta comment-content" title="' + escapeHtml(item.content) + '">' + escapeHtml(item.content) + '</td>' +
              '<td class="meta">' + createdAt + '</td>' +
              '</tr>';
            break;
            
          case 'commented':
            var commentedPostUrl = ctx + '/roomboarddetail.room?roomBoardId=' + item.roomBoardId + '&userId=' + targetUserId;
            rowHtml = '<tr>' +
              '<td class="meta">' + rowNumber + '</td>' +
              '<td><a class="link" href="' + commentedPostUrl + '" title="' + escapeHtml(item.title) + '">' + escapeHtml(item.title) + '</a></td>' +
              '<td class="meta">' + (item.replyCount || 0) + '개</td>' +
              '<td class="meta">' + createdAt + '</td>' +
              '</tr>';
            break;
            
          case 'likes':
            var likedPostUrl = ctx + '/roomboarddetail.room?roomBoardId=' + item.roomBoardId + '&userId=' + targetUserId;
            rowHtml = '<tr>' +
              '<td class="meta">' + rowNumber + '</td>' +
              '<td><a class="link" href="' + likedPostUrl + '" title="' + escapeHtml(item.title) + '">' + escapeHtml(item.title) + '</a></td>' +
              '<td class="meta">' + createdAt + '</td>' +
              '<td class="meta">' + (item.viewCount || 0) + '</td>' +
              '</tr>';
            break;
            
          default:
            rowHtml = '';
        }
        
        return rowHtml;
      }
      
      // 페이지네이션 렌더링
      function renderPagination(totalPages, page) {
        var $pagination = $('#pagination');
        $pagination.empty();
        
        if (totalPages <= 1) return;
        
        // 이전 버튼
        var prevBtn = $('<button class="page-btn">‹</button>');
        if (page <= 1) {
          prevBtn.prop('disabled', true);
        } else {
          prevBtn.on('click', function() {
            currentPage = page - 1;
            loadActivityData();
          });
        }
        $pagination.append(prevBtn);
        
        // 페이지 번호들
        var startPage = Math.max(1, page - 2);
        var endPage = Math.min(totalPages, startPage + 4);
        
        for (var i = startPage; i <= endPage; i++) {
          var pageBtn = $('<button class="page-btn">' + i + '</button>');
          if (i === page) {
            pageBtn.addClass('active');
          } else {
            (function(pageNum) {
              pageBtn.on('click', function() {
                currentPage = pageNum;
                loadActivityData();
              });
            })(i);
          }
          $pagination.append(pageBtn);
        }
        
        // 다음 버튼
        var nextBtn = $('<button class="page-btn">›</button>');
        if (page >= totalPages) {
          nextBtn.prop('disabled', true);
        } else {
          nextBtn.on('click', function() {
            currentPage = page + 1;
            loadActivityData();
          });
        }
        $pagination.append(nextBtn);
      }
      
      // 탭 클릭 이벤트
      $('.tab-btn').on('click', function() {
        var tab = $(this).data('tab');
        if (tab === currentTab) return;
        
        $('.tab-btn').removeClass('active');
        $(this).addClass('active');
        
        currentTab = tab;
        currentPage = 1;
        loadActivityData();
      });
      
      // 초기 로드
      loadActivityData();
    });
  </script>
</body>
</html>