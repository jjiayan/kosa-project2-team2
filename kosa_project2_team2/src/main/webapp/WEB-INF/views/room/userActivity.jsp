<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>[<c:out value="${roomTitle}"/>]내 <c:out value="${userInfo.user_nickname}"/>님의 활동</title>
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
  padding: 16px;
}

.heading-wrap {
  text-align: center;
  padding: 20px 16px 0;
}

.heading {
  font-size: clamp(20px, 4vw, 28px);
  font-weight: 900;
  color: #333;
  margin: 16px 0;
  line-height: 1.2;
}

.container {
  max-width: 1180px;
  margin: 0 auto;
  padding: 0 16px 20px;
}

.layout {
  display: grid;
  grid-template-columns: 1fr;
  gap: 16px;
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
  padding: 16px 20px;
  font-size: 15px;
  font-weight: 700;
  color: #333;
  border-bottom: 1px solid #dadada;
  background: #fff;
}

.profile-body {
  padding: 20px;
  background: #fff;
}

.profile-main {
  display: flex;
  gap: 16px;
  align-items: flex-start;
}

.user-avatar-box {
  flex: 0 0 auto;
  width: clamp(80px, 15vw, 100px);
  height: clamp(80px, 15vw, 100px);
  border: 3px solid #f1f1f1;
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

.user-info {
  flex: 1;
  padding-top: 8px;
  min-width: 0;
}

.user-name {
  font-size: clamp(18px, 4vw, 24px);
  font-weight: 900;
  line-height: 1.2;
  margin: 0 0 8px 0;
  color: #333;
  word-break: break-word;
}

.user-details {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  align-items: center;
  color: #666;
  font-size: 14px;
}

.age-group {
  background: #f0f0f0;
  padding: 6px 10px;
  border-radius: 12px;
  font-weight: 500;
  white-space: nowrap;
}

.user-role {
  background: #ff6b6b;
  color: white;
  padding: 6px 10px;
  border-radius: 12px;
  font-weight: 600;
  font-size: 12px;
  white-space: nowrap;
}

.user-role.member {
  background: #4CAF50;
}

.user-role.pending {
  background: #FF9800;
}

.user-role.visitor {
  background: #666;
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
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  background: #fafafa;
  border-bottom: 1px solid var(--line);
}

.tab-btn {
  padding: 16px 12px;
  border: none;
  background: transparent;
  color: var(--muted);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  border-bottom: 3px solid transparent;
  text-align: center;
  min-height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
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

/* 테이블 컨테이너 */
.table-container {
  background: #fff;
  border-radius: 0 0 16px 16px;
  overflow: hidden;
}

/* 데스크톱 테이블 스타일 */
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
  padding: 18px 20px;
  background: #fafafa;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}

.table tbody td {
  padding: 16px 20px;
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

/* 모바일 카드 스타일 */
.mobile-card-list {
  display: none;
}

.mobile-card-item {
  background: #fff;
  border: 1px solid var(--line);
  border-radius: 12px;
  margin-bottom: 12px;
  padding: 16px;
  position: relative;
}

.mobile-card-header {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  margin-bottom: 12px;
}

.mobile-card-checkbox {
  margin-top: 2px;
}

.mobile-card-content {
  flex: 1;
  min-width: 0;
}

.mobile-card-title {
  font-weight: 600;
  font-size: 15px;
  color: #333;
  margin-bottom: 8px;
  line-height: 1.4;
  word-break: break-word;
}

.mobile-card-title a {
  color: inherit;
  text-decoration: none;
}

.mobile-card-title a:hover {
  color: var(--accent);
}

.mobile-card-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  font-size: 13px;
  color: var(--muted);
}

.mobile-card-meta-item {
  display: flex;
  align-items: center;
  gap: 4px;
}

/* 체크박스 관련 스타일 */
.checkbox-column {
  width: 50px;
  text-align: center;
}

.checkbox-column input[type="checkbox"],
.mobile-card-checkbox input[type="checkbox"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
  accent-color: var(--accent);
}

/* 일괄 삭제 버튼 영역 */
.bulk-actions {
  display: none;
  padding: 20px;
  background: #fff;
  border-top: 1px solid var(--line);
  position: sticky;
  bottom: 0;
  z-index: 100;
}

.bulk-actions.show {
  display: block;
}

.bulk-actions-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.selection-info {
  font-size: 14px;
  color: var(--muted);
  font-weight: 500;
}

.bulk-delete-btn {
  background: #dc3545;
  color: white;
  border: none;
  padding: 12px 20px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
  min-height: 44px;
  white-space: nowrap;
}

.bulk-delete-btn:hover {
  background: #c82333;
}

.bulk-delete-btn:disabled {
  background: #6c757d;
  cursor: not-allowed;
}

/* 페이지네이션 */
.pagination {
  display: flex;
  gap: 8px;
  align-items: center;
  justify-content: center;
  margin-top: 16px;
  padding: 20px;
  flex-wrap: wrap;
}

.page-btn {
  min-width: 36px;
  height: 36px;
  border-radius: 50%;
  border: 1px solid var(--line);
  background: #fff;
  color: #374151;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: center;
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

.empty-state, .loading {
  text-align: center;
  padding: 40px 20px;
  color: var(--muted);
  font-size: 14px;
}

/* 댓글 내용 표시 */
.comment-content {
  max-width: 300px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* 반응형 미디어 쿼리 */
@media (max-width: 768px) {
  .page {
    padding: 12px;
  }
  
  .container {
    padding: 0 12px 16px;
  }
  
  .heading-wrap {
    padding: 16px 12px 0;
  }
  
  .profile-main {
    flex-direction: column;
    text-align: center;
    align-items: center;
    gap: 12px;
  }
  
  .user-info {
    text-align: center;
    padding-top: 0;
  }
  
  .user-details {
    justify-content: center;
  }
  
  .tab-header {
    grid-template-columns: 1fr 1fr;
  }
  
  .tab-btn {
    padding: 14px 8px;
    font-size: 13px;
    min-height: 50px;
  }
  
  /* 테이블을 모바일 카드로 전환 */
  .table {
    display: none;
  }
  
  .mobile-card-list {
    display: block;
  }
  
  .bulk-actions-content {
    flex-direction: column;
    align-items: stretch;
    gap: 12px;
  }
  
  .selection-info {
    text-align: center;
  }
  
  .bulk-delete-btn {
    width: 100%;
    padding: 14px 20px;
  }
  
  .pagination {
    gap: 6px;
    padding: 16px;
  }
  
  .page-btn {
    min-width: 32px;
    height: 32px;
    font-size: 13px;
  }
}
  </style>
</head>

<body>
  <jsp:include page="/include/nav.jsp" />
  
  <c:set var="ctx" value="${pageContext.request.contextPath}" />
  
  <div class="page">
    <div class="heading-wrap">
      <h1 class="heading">[<c:out value="${roomTitle}"/>] 내 <c:out value="${userInfo.user_nickname}"/>님의 활동</h1>
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
      <img class="user-avatar" 
           src="${ctx}${userInfo.user_photo}" 
           alt="프로필"
           onerror="this.onerror=null; this.src='${ctx}/images/default-avatar.png';">
    </c:when>
    <c:otherwise>
      <img class="user-avatar" src="${ctx}/images/default-avatar.png" alt="프로필">
    </c:otherwise>
  </c:choose>
</div>
              <div class="user-info">
                <h2 class="user-name"><c:out value="${userInfo.user_nickname}"/></h2>
                <div class="user-details">
				  <span class="age-group"><c:out value="${ageGroup}"/></span>
				  <c:choose>
				    <c:when test="${userRole eq 'LEADER'}">
				      <span class="user-role">방장</span>
				    </c:when>
				    <c:when test="${userRole eq 'MEMBER'}">
				      <span class="user-role member"><c:out value="${userTier}"/></span>
				    </c:when>
				    <c:otherwise>
				      <span class="user-role visitor">방문자</span>
				    </c:otherwise>
				  </c:choose>
				</div>
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
			  <!-- 데스크톱 테이블 -->
			  <table class="table" id="activityTable">
			    <thead>
			      <tr id="tableHeader">
			        <th>제목</th>
			        <th>작성일</th>
			        <th>조회수</th>
			      </tr>
			    </thead>
			    <tbody id="activityTableBody">
			      <tr>
			        <td colspan="3" class="loading">로딩 중...</td>
			      </tr>
			    </tbody>
			  </table>
			  
			  <!-- 모바일 카드 리스트 (JavaScript에서 동적 생성) -->
			</div>
			
			<!-- 일괄 삭제 버튼 영역 수정 -->
			<div id="bulkActions" class="bulk-actions">
			  <div class="bulk-actions-content">
			    <span id="selectionInfo" class="selection-info">0개 선택됨</span>
			    <button id="bulkDeleteBtn" class="bulk-delete-btn" disabled>
			      <span id="bulkActionText">삭제</span>
			    </button>
			  </div>
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
	  var currentUserId = ${currentUserId};
	  var isMyActivity = ${isMyActivity};
	  
	  var currentTab = 'posts';
	  var currentPage = 1;
	  var pageSize = 10;
	  
	  // 선택된 항목들을 추적하는 변수
	  var selectedItems = new Set();
	  var allItems = []; // 현재 페이지의 모든 항목
	  
	  // 화면 크기 감지
	  var isMobile = window.innerWidth <= 768;
	  
	  // 리사이즈 이벤트 처리
	  $(window).on('resize', function() {
	    var newIsMobile = window.innerWidth <= 768;
	    if (newIsMobile !== isMobile) {
	      isMobile = newIsMobile;
	      // 화면 크기가 변경되면 테이블 다시 렌더링
	      if (allItems.length > 0) {
	        renderActivityData(allItems);
	      }
	    }
	  });
	  
	  // 탭별 테이블 헤더 설정 (체크박스 포함)
	  var tableHeaders = {
	    posts: ['제목', '작성일', '조회수'],
	    comments: ['✓', '댓글 내용', '작성일'],
	    commented: ['제목', '작성자', '내 댓글 수', '조회수'],
	    likes: ['✓', '제목', '작성자', '작성일']
	  };
	  
	  // 탭별 액션 텍스트
	  var actionTexts = {
	    comments: '댓글 삭제',
	    likes: '좋아요 취소'
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
	  
	  // 체크박스 관련 함수들
	  function updateSelectionInfo() {
	    var count = selectedItems.size;
	    $('#selectionInfo').text(count + '개 선택됨');
	    
	    if (count > 0) {
	      $('#bulkActions').addClass('show');
	      $('#bulkDeleteBtn').prop('disabled', false);
	    } else {
	      $('#bulkActions').removeClass('show');
	      $('#bulkDeleteBtn').prop('disabled', true);
	    }
	    
	    // 전체 선택 체크박스 상태 업데이트
	    updateSelectAllCheckbox();
	  }
	  
	  function updateSelectAllCheckbox() {
	    var $selectAllCheckbox = $('#selectAllCheckbox');
	    if ($selectAllCheckbox.length > 0) {
	      var count = selectedItems.size;
	      if (count === 0) {
	        $selectAllCheckbox.prop('indeterminate', false);
	        $selectAllCheckbox.prop('checked', false);
	      } else if (count === allItems.length) {
	        $selectAllCheckbox.prop('indeterminate', false);
	        $selectAllCheckbox.prop('checked', true);
	      } else {
	        $selectAllCheckbox.prop('indeterminate', true);
	        $selectAllCheckbox.prop('checked', false);
	      }
	    }
	  }
	  
	  function handleItemCheckboxChange() {
	    selectedItems.clear();
	    $('.item-checkbox:checked').each(function() {
	      selectedItems.add($(this).val());
	    });
	    updateSelectionInfo();
	  }
	  
	  function handleSelectAllChange() {
	    var isChecked = $('#selectAllCheckbox').prop('checked');
	    $('.item-checkbox').prop('checked', isChecked);
	    
	    selectedItems.clear();
	    if (isChecked) {
	      allItems.forEach(function(item) {
	        selectedItems.add(getItemId(item));
	      });
	    }
	    updateSelectionInfo();
	  }
	  
	  function getItemId(item) {
	    if (currentTab === 'comments') {
	      return item.replyId.toString();
	    } else if (currentTab === 'likes') {
	      return item.roomBoardId.toString();
	    }
	    return '';
	  }
	  
	  // 활동 데이터 로드
	  function loadActivityData() {
	    showLoading();
	    
	    // 선택 상태 초기화
	    selectedItems.clear();
	    allItems = [];
	    updateSelectionInfo();
	    
	    $.ajax({
	      url: ctx + '/room/ajax/useractivity.useractivityajax',
	      data: {
	        userId: targetUserId,
	        roomId: roomId,
	        tab: currentTab,
	        page: currentPage,
	        size: pageSize
	      },
	      success: function(response) {
	        if (response.success) {
	          allItems = response.data || [];
	          updateTableHeader();
	          renderActivityData(response.data);
	          renderPagination(response.totalPages, response.currentPage);
	        } else {
	          showEmptyState(response.message || '데이터를 불러올 수 없습니다.');
	        }
	      },
	      error: function() {
	        showEmptyState('데이터를 불러오는 중 오류가 발생했습니다.');
	      }
	    });
	  }
	  
	  function showLoading() {
	    var colspan = tableHeaders[currentTab].length;
	    $('#activityTableBody').html('<tr><td colspan="' + colspan + '" class="loading">로딩 중...</td></tr>');
	    $('#mobileCardList').html('<div class="loading">로딩 중...</div>');
	  }
	  
	  function showEmptyState(message) {
	    var colspan = tableHeaders[currentTab].length;
	    $('#activityTableBody').html('<tr><td colspan="' + colspan + '" class="empty-state">' + message + '</td></tr>');
	    $('#mobileCardList').html('<div class="empty-state">' + message + '</div>');
	  }
	  
	  // 테이블 헤더 업데이트
	  function updateTableHeader() {
	    var headers = tableHeaders[currentTab];
	    var $header = $('#tableHeader');
	    $header.empty();
	    
	    headers.forEach(function(header, index) {
	      if (header === '✓' && isMyActivity && (currentTab === 'comments' || currentTab === 'likes')) {
	        // 체크박스 헤더 (전체 선택)
	        $header.append('<th class="checkbox-column"><input type="checkbox" id="selectAllCheckbox"></th>');
	      } else {
	        $header.append('<th>' + header + '</th>');
	      }
	    });
	    
	    // 전체 선택 체크박스 이벤트 바인딩
	    $('#selectAllCheckbox').off('change').on('change', handleSelectAllChange);
	    
	    // 일괄 삭제 버튼 텍스트 업데이트
	    if (actionTexts[currentTab]) {
	      $('#bulkActionText').text(actionTexts[currentTab]);
	    }
	  }
	  
	  // 활동 데이터 렌더링 (데스크톱/모바일 분기)
	  function renderActivityData(items) {
	    if (isMobile) {
	      renderMobileCards(items);
	    } else {
	      renderDesktopTable(items);
	    }
	  }
	  
	  // 데스크톱 테이블 렌더링
	  function renderDesktopTable(items) {
	    var $tbody = $('#activityTableBody');
	    $tbody.empty();
	    
	    if (!items || items.length === 0) {
	      showEmptyState('표시할 데이터가 없습니다.');
	      return;
	    }
	    
	    items.forEach(function(item) {
	      var row = createTableRow(item);
	      $tbody.append(row);
	    });
	    
	    // 체크박스 이벤트 바인딩
	    $('.item-checkbox').off('change').on('change', handleItemCheckboxChange);
	  }
	  
	  // 모바일 카드 렌더링
	  function renderMobileCards(items) {
	    var $container = $('#mobileCardList');
	    if (!$container.length) {
	      // 모바일 카드 컨테이너가 없으면 생성
	      $('.table-container').append('<div id="mobileCardList" class="mobile-card-list"></div>');
	      $container = $('#mobileCardList');
	    }
	    
	    $container.empty();
	    
	    if (!items || items.length === 0) {
	      $container.html('<div class="empty-state">표시할 데이터가 없습니다.</div>');
	      return;
	    }
	    
	    items.forEach(function(item) {
	      var card = createMobileCard(item);
	      $container.append(card);
	    });
	    
	    // 체크박스 이벤트 바인딩
	    $('.item-checkbox').off('change').on('change', handleItemCheckboxChange);
	  }
	  
	  // 모바일 카드 생성
	  function createMobileCard(item) {
	    var createdAt = item.createdAt ? new Date(item.createdAt).toLocaleDateString('ko-KR') : '';
	    var cardHtml = '';
	    
	    switch (currentTab) {
	      case 'posts':
	        var postUrl = ctx + '/roomboarddetail.room?roomBoardId=' + item.roomBoardId + '&userId=' + targetUserId;
	        cardHtml = '<div class="mobile-card-item">' +
	          '<div class="mobile-card-content">' +
	          '<div class="mobile-card-title"><a href="' + postUrl + '">' + escapeHtml(item.title) + '</a></div>' +
	          '<div class="mobile-card-meta">' +
	          '<span class="mobile-card-meta-item">📅 ' + createdAt + '</span>' +
	          '<span class="mobile-card-meta-item">👁 ' + (item.viewCount || 0) + '</span>' +
	          '</div></div></div>';
	        break;
	        
	      case 'comments':
	        var commentPostUrl = ctx + '/roomboarddetail.room?roomBoardId=' + item.roomBoardId + '&userId=' + targetUserId + '#reply-' + item.replyId;
	        cardHtml = '<div class="mobile-card-item">' +
	          '<div class="mobile-card-header">';
	        
	        if (isMyActivity) {
	          cardHtml += '<div class="mobile-card-checkbox"><input type="checkbox" class="item-checkbox" value="' + item.replyId + '"></div>';
	        }
	        
	        cardHtml += '<div class="mobile-card-content">' +
	          '<div class="mobile-card-title"><a href="' + commentPostUrl + '">' + escapeHtml(item.content) + '</a></div>' +
	          '<div class="mobile-card-meta">' +
	          '<span class="mobile-card-meta-item">📅 ' + createdAt + '</span>' +
	          '</div></div></div></div>';
	        break;
	        
	      case 'commented':
	        var commentedPostUrl = ctx + '/roomboarddetail.room?roomBoardId=' + item.roomBoardId + '&userId=' + targetUserId;
	        cardHtml = '<div class="mobile-card-item">' +
	          '<div class="mobile-card-content">' +
	          '<div class="mobile-card-title"><a href="' + commentedPostUrl + '">' + escapeHtml(item.title) + '</a></div>' +
	          '<div class="mobile-card-meta">' +
	          '<span class="mobile-card-meta-item">✍ ' + escapeHtml(item.authorNickname || '') + '</span>' +
	          '<span class="mobile-card-meta-item">💬 ' + (item.replyCount || 0) + '개</span>' +
	          '<span class="mobile-card-meta-item">👁 ' + (item.viewCount || 0) + '</span>' +
	          '</div></div></div>';
	        break;
	        
	      case 'likes':
	        var likedPostUrl = ctx + '/roomboarddetail.room?roomBoardId=' + item.roomBoardId + '&userId=' + targetUserId;
	        cardHtml = '<div class="mobile-card-item">' +
	          '<div class="mobile-card-header">';
	        
	        if (isMyActivity) {
	          cardHtml += '<div class="mobile-card-checkbox"><input type="checkbox" class="item-checkbox" value="' + item.roomBoardId + '"></div>';
	        }
	        
	        cardHtml += '<div class="mobile-card-content">' +
	          '<div class="mobile-card-title"><a href="' + likedPostUrl + '">' + escapeHtml(item.title) + '</a></div>' +
	          '<div class="mobile-card-meta">' +
	          '<span class="mobile-card-meta-item">✍ ' + escapeHtml(item.authorNickname || '') + '</span>' +
	          '<span class="mobile-card-meta-item">📅 ' + createdAt + '</span>' +
	          '</div></div></div></div>';
	        break;
	        
	      default:
	        cardHtml = '';
	    }
	    
	    return cardHtml;
	  }
	  
	  // 기존 테이블 행 생성 함수 (데스크톱용)
	  function createTableRow(item) {
	    var createdAt = item.createdAt ? new Date(item.createdAt).toLocaleDateString('ko-KR') : '';
	    var rowHtml = '';
	    
	    switch (currentTab) {
	      case 'posts':
	        var postUrl = ctx + '/roomboarddetail.room?roomBoardId=' + item.roomBoardId + '&userId=' + targetUserId;
	        rowHtml = '<tr>' +
	          '<td><a class="link" href="' + postUrl + '" title="' + escapeHtml(item.title) + '">' + escapeHtml(item.title) + '</a></td>' +
	          '<td class="meta">' + createdAt + '</td>' +
	          '<td class="meta">' + (item.viewCount || 0) + '</td>' +
	          '</tr>';
	        break;
	        
	      case 'comments':
	        var commentPostUrl = ctx + '/roomboarddetail.room?roomBoardId=' + item.roomBoardId + '&userId=' + targetUserId + '#reply-' + item.replyId;
	        if (isMyActivity) {
	          rowHtml = '<tr>' +
	            '<td class="checkbox-column"><input type="checkbox" class="item-checkbox" value="' + item.replyId + '"></td>' +
	            '<td class="comment-content"><a class="link" href="' + commentPostUrl + '" title="' + escapeHtml(item.content) + '">' + escapeHtml(item.content) + '</a></td>' +
	            '<td class="meta">' + createdAt + '</td>' +
	            '</tr>';
	        } else {
	          rowHtml = '<tr>' +
	            '<td class="comment-content"><a class="link" href="' + commentPostUrl + '" title="' + escapeHtml(item.content) + '">' + escapeHtml(item.content) + '</a></td>' +
	            '<td class="meta">' + createdAt + '</td>' +
	            '</tr>';
	        }
	        break;
	        
	      case 'commented':
	        var commentedPostUrl = ctx + '/roomboarddetail.room?roomBoardId=' + item.roomBoardId + '&userId=' + targetUserId;
	        rowHtml = '<tr>' +
	          '<td><a class="link" href="' + commentedPostUrl + '" title="' + escapeHtml(item.title) + '">' + escapeHtml(item.title) + '</a></td>' +
	          '<td class="meta">' + escapeHtml(item.authorNickname || '') + '</td>' +
	          '<td class="meta">' + (item.replyCount || 0) + '개</td>' +
	          '<td class="meta">' + (item.viewCount || 0) + '</td>' +
	          '</tr>';
	        break;
	        
	      case 'likes':
	        var likedPostUrl = ctx + '/roomboarddetail.room?roomBoardId=' + item.roomBoardId + '&userId=' + targetUserId;
	        if (isMyActivity) {
	          rowHtml = '<tr>' +
	            '<td class="checkbox-column"><input type="checkbox" class="item-checkbox" value="' + item.roomBoardId + '"></td>' +
	            '<td><a class="link" href="' + likedPostUrl + '" title="' + escapeHtml(item.title) + '">' + escapeHtml(item.title) + '</a></td>' +
	            '<td class="meta">' + escapeHtml(item.authorNickname || '') + '</td>' +
	            '<td class="meta">' + createdAt + '</td>' +
	            '</tr>';
	        } else {
	          rowHtml = '<tr>' +
	            '<td><a class="link" href="' + likedPostUrl + '" title="' + escapeHtml(item.title) + '">' + escapeHtml(item.title) + '</a></td>' +
	            '<td class="meta">' + escapeHtml(item.authorNickname || '') + '</td>' +
	            '<td class="meta">' + createdAt + '</td>' +
	            '</tr>';
	        }
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
	  
	  // 일괄 삭제 실행
	  function performBulkAction() {
	    if (selectedItems.size === 0) {
	      alert('삭제할 항목을 선택해주세요.');
	      return;
	    }
	    
	    var actionType = currentTab === 'comments' ? 'delete-replies' : 'cancel-likes';
	    var actionName = actionTexts[currentTab];
	    var isSelectAll = selectedItems.size === allItems.length;
	    
	    var confirmMessage = isSelectAll ? 
	      '이 방에서의 모든 ' + (currentTab === 'comments' ? '댓글을 삭제' : '좋아요를 취소') + '하시겠습니까?' :
	      '선택한 ' + selectedItems.size + '개 항목을 ' + (currentTab === 'comments' ? '삭제' : '취소') + '하시겠습니까?';
	    
	    if (!confirm(confirmMessage)) {
	      return;
	    }
	    
	    var requestData = {
	      actionType: actionType,
	      targetUserId: targetUserId,
	      roomId: roomId
	    };
	    
	    if (isSelectAll) {
	      requestData.selectAll = 'true';
	    } else {
	      requestData.selectedIds = Array.from(selectedItems);
	    }
	    
	    $('#bulkDeleteBtn').prop('disabled', true).text('처리 중...');
	    
	    $.ajax({
	      url: ctx + '/useractivity/bulk-action.ajax',
	      type: 'POST',
	      data: requestData,
	      success: function(response) {
	        if (response.success) {
	          alert(response.message);
	          // 데이터 새로고침
	          loadActivityData();
	        } else {
	          alert(response.message || '처리 중 오류가 발생했습니다.');
	        }
	      },
	      error: function() {
	        alert('서버 오류가 발생했습니다.');
	      },
	      complete: function() {
	        $('#bulkDeleteBtn').prop('disabled', false).find('#bulkActionText').text(actionTexts[currentTab] || '삭제');
	      }
	    });
	  }
	  
	  // 탭 클릭 이벤트
	  $('.tab-btn').on('click', function() {
	    var tab = $(this).data('tab');
	    if (tab === currentTab) return;
	    
	    $('.tab-btn').removeClass('active');
	    $(this).addClass('active');
	    
	    currentTab = tab;
	    currentPage = 1;
	    selectedItems.clear();
	    allItems = [];
	    updateSelectionInfo();
	    loadActivityData();
	  });
	  
	  // 일괄 삭제 버튼 클릭 이벤트
	  $('#bulkDeleteBtn').on('click', performBulkAction);
	  
	  // 초기 로드
	  loadActivityData();
	});
  </script>
</body>
</html>