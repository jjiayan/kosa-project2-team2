<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<style>

/* ===== 댓글 전체 영역 컨테이너 및 헤더 ===== */
.reply-container { max-width: 800px; margin: 40px auto 0; padding: 0; background: white; border-radius: 20px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 1px 8px rgba(0, 0, 0, 0.06);overflow: hidden; }
.reply-header { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px 16px; border-bottom: 1px solid #f0f0f0; }
.reply-stats { display: flex; gap: 10px; align-items: center; }
.stat-item { display: flex; align-items: center; gap: 6px; color: #666; font-size: 14px; }
.stat-icon { font-size: 16px; }
/* ===== 탭 버튼 (좋아요 / 댓글 전환용) ===== */
.stat-item.tab-button { cursor: pointer; padding: 8px 16px; border-radius: 8px; transition: all 0.2s; user-select: none; }
.stat-item.tab-button:hover { background: #f5f5f5; }
.stat-item.tab-button.active { background: #fff5f5; color: #ff5a5f; font-weight: 600; }
.stat-item.tab-button.active svg {stroke: #ff5a5f; }
.stat-item .like-text-btn strong#likeTotalCount { display: inline-block; width: 0.8ch; text-align: right; font-variant-numeric: tabular-nums; }
.stat-item.tab-button[data-tab="reply"] strong#replyTotalCount { display: inline-block; width: 0.8ch; text-align: right; font-variant-numeric: tabular-nums; }
.stat-item.tab-button[data-tab="reply"] > span { white-space: nowrap; }
/* ===== 댓글 정렬 ===== */
.reply-sort { display: flex; align-items: center; gap: 4px; }
.reply-sort.hidden { display: none; }
.sort-btn { padding: 6px 14px; border: none; background: white; cursor: pointer; font-size: 13px; color: #999; font-weight: 500; border-radius: 4px; transition: all 0.2s; }
.sort-btn:hover { background: #f8f8f8; }
.sort-btn.active { background: white; color: #333; font-weight: 700; }
#replyList { padding: 0; background: white; }
#replySortButtons.hidden { display: none; }
/* ===== 댓글 작성 폼 (입력창, 버튼, 툴) ===== */
.reply-write-form { padding: 20px 24px; background: white; border-top: 1px solid #f0f0f0; }
.write-form-header { display: flex; align-items: center; gap: 8px; margin-bottom: 12px; }
.write-form-header .profile-img { width: 28px; height: 28px; }
.write-form-header .author-name { font-weight: 700; font-size: 13px; color: #333; }
.attached-images { display: none; gap: 8px; margin-bottom: 12px; flex-wrap: wrap; }
.attached-image { position: relative; width: 70px; height: 70px; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0; }
.attached-image img { width: 100%; height: 100%; object-fit: cover; }
.remove-image { position: absolute; top: 4px; right: 4px; background: rgba(0,0,0,0.6); color: white; border: none; border-radius: 50%; width: 18px; height: 18px; cursor: pointer; font-size: 11px; line-height: 1; padding: 0; }
#replyContent, .reply-textarea { width: 100%; min-height: 48px; padding: 12px 16px; border: 1px solid #e8e8e8; border-radius: 8px; resize: none; font-size: 14px; line-height: 1.5; font-family: inherit; background: #fafafa; }
#replyContent:focus, .reply-textarea:focus { outline: none; border-color: #d0d0d0; background: white; }
#replyContent::placeholder { color: #bbb; }
.reply-write-actions { display: flex; justify-content: space-between; align-items: center; margin-top: 12px; }
.write-tools { display: flex; gap: 8px; align-items: center; }
.tool-btn { background: none; border: none; cursor: pointer; font-size: 20px; color: #bbb; padding: 4px; transition: color 0.2s; }
.tool-btn:hover { color: #888; }
.image-input { display: none; }
.char-count { color: #bbb; font-size: 11px; margin-left: auto; margin-right: 12px; }
.btn-submit { padding: 8px 20px; background: #ff5a5f; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: 600; transition: background 0.2s; }
.btn-submit:hover { background: #ff3d42; }
.btn-submit:disabled { background: #e0e0e0; cursor: not-allowed; }
.btn-cancel { padding: 8px 16px; background: #f0f0f0; color: #666; border: none; border-radius: 6px; cursor: pointer; margin-right: 6px; font-size: 13px; font-weight: 500; transition: background 0.2s; }
.btn-cancel:hover { background: #e0e0e0; }
/* ===== 대댓글 입력폼 ===== */
.child-reply-form { margin-top: 12px; margin-left: 52px; margin-right: 0; padding: 12px; background: #f9f9f9; border-radius: 8px; border: 1px solid #e8e8e8; }
/* ===== 로딩/빈 상태 표시 ===== */
.loading, .empty-state { text-align: center; padding: 60px 20px; color: #aaa; font-size: 13px; background: white; }
.empty-state { border-radius: 0; }
/* ===== 댓글 목록 (원댓글, 대댓글 포함) ===== */
.reply-item { background: white; padding: 10px 24px 0px 20px; border-bottom: 1px solid #f5f5f5; transition: background 0.2s; position: relative; }
.reply-item:hover { background: #fafafa; }
.reply-item.child-reply { margin-left: 52px; background: #ffffff; padding-left: 20px; }
.reply-item-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 10px; position: relative; }
.reply-author { display: flex; align-items: flex-start; gap: 12px; flex: 1; }
.profile-img { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; flex-shrink: 0; cursor: pointer; transition: transform 0.2s; }
.profile-img:hover { transform: scale(1.05); }
.reply-main-content { flex: 1; min-width: 0; }
.author-info { display: flex; align-items: center; gap: 6px; margin-bottom: 0px; margin-top: 2px; }
.author-name { font-weight: 700;  font-size: 14px; color: #333; cursor: pointer; text-decoration: none; transition: color 0.2s; }
.author-name:hover { color: #ff5a5f; }
.my-comment-badge { background: #ff5a5f; color: white; font-size: 10px; padding: 2px 6px; border-radius: 10px; font-weight: 600; margin-left: 4px; }
.reply-target { color: #ff5a5f; font-weight: 700; margin-right: 4px; }
.reply-content { margin: 0px 0 0px; line-height: 1.5; white-space: pre-wrap; word-break: break-word; color: #333; font-size: 14px; }
.reply-time { font-size: 12px; color: #aaa; margin-right: 12px; }
.btn-reply-write { font-size: 12px; color: #aaa; background: none; border: none; cursor: pointer; font-weight: 500; padding: 0; margin-right: 8px; transition: color 0.2s; }
.btn-reply-write:hover { color: #666; }
/* ===== 댓글 좋아요 버튼 ===== */
.btn-like { background: none; border: none; cursor: pointer; font-size: 13px; color: #ccc; padding: 0; transition: all 0.2s; display: inline-flex; align-items: center; }
.btn-like:hover { color: #ff5a5f; }
.btn-like svg { transition: all 0.2s; }
.btn-like .like-count { font-size: 12px; margin-left: 4px; font-weight: 500; }
.btn-like.liked svg { fill: #ff5a5f; stroke: #ff5a5f; }
/* ===== 더보기 메뉴 (수정/삭제/신고) ===== */
.reply-more-menu { position: absolute; right: 0; top: 0; }
.btn-more { background: none; border: none; cursor: pointer; padding: 4px 8px; color: #d0d0d0; font-size: 20px; line-height: 1; border-radius: 4px; transition: all 0.2s; }
.btn-more:hover { color: #999; background: #f5f5f5; }
.dropdown-menu { display: none; position: absolute; right: 0; top: 100%; background: white; border: 1px solid #e0e0e0; border-radius: 8px; box-shadow: 0 4px 16px rgba(0,0,0,0.12); min-width: 100px; z-index: 1000; margin-top: 4px; }
.dropdown-menu.show { display: block; }
.dropdown-item { padding: 10px 16px; cursor: pointer; border: none; background: none; width: 100%; text-align: left; font-size: 13px; color: #333; transition: background 0.2s; }
.dropdown-item:hover { background: #f8f8f8; }
.dropdown-item:first-child { border-radius: 8px 8px 0 0; }
.dropdown-item:last-child { border-radius: 0 0 8px 8px; }
.dropdown-item.danger { color: #ff5a5f; }
.dropdown-item.danger:hover { background: #fff5f5; }
/* ===== 게시글 좋아요한 사용자 리스트 ===== */
.like-list-container { padding: 20px 24px; background: white; }
.like-users-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
.like-user-item { display: flex; align-items: center; gap: 12px; padding: 0; transition: all 0.2s; cursor: pointer; }
.like-user-item:hover { transform: translateY(-2px); }
.like-user-avatar { width: 48px; height: 48px; border-radius: 50%; object-fit: cover; flex-shrink: 0; border: 2px solid #f0f0f0; }
.like-user-info { flex: 1; min-width: 0; }
.like-user-name { font-weight: 700; font-size: 14px; color: #333; margin-bottom: 4px; display: flex; align-items: center; gap: 4px; }
.me-badge { background: #4CAF50; color: white; font-size: 10px; padding: 2px 6px; border-radius: 10px; font-weight: 600; }
.like-user-date { font-size: 12px; color: #999; }
/* ===== 좋아요한 사용자 목록 페이지네이션 ===== */
.pagination-container { display: flex; justify-content: center; align-items: center; padding: 15px 0; background: white; border-top: 1px solid #f0f0f0; }
.pagination-btn { background: white; border: 1px solid #e0e0e0; padding: 6px 8px; cursor: pointer; border-radius: 6px; transition: all 0.2s; display: flex; align-items: center; justify-content: center; margin: 0 2px; min-width: 32px; height: 32px; }
.pagination-btn:hover:not(:disabled) { background: #f5f5f5;border-color: #FF7272; }
.pagination-btn:hover:not(:disabled) svg path { stroke: #FF7272; }
.pagination-btn:disabled { opacity: 0.3; cursor: not-allowed; background: #f9f9f9; }
.pagination-number { background: white; border: 1px solid #e0e0e0; padding: 6px 8px; cursor: pointer; border-radius: 6px; transition: all 0.2s; min-width: 32px; height: 32px; font-size: 13px; font-weight: 500; margin: 0 2px; display: flex; align-items: center; justify-content: center; }
.pagination-number:hover { background: #f5f5f5; border-color: #FF7272; color: #FF7272; }
.pagination-number.active { background: #FF7272; color: white; border-color: #FF7272; }
.pagination-svg-active { margin: 0 2px; cursor: default; }
.pagination-svg-active svg { filter: drop-shadow(0 1px 2px rgba(255, 114, 114, 0.3)); }
/* ===== 게시글 좋아요 버튼 ===== */
.post-like-btn { background: none; border: none; cursor: pointer; color: #ccc; padding: 0; transition: all 0.2s; display: inline-flex; align-items: center; justify-content: center; }
.post-like-btn:hover { color: #ff5a5f; }
.post-like-btn svg { transition: all 0.2s; }
.post-like-btn.liked svg { fill: #ff5a5f; stroke: #ff5a5f; }
.like-text-btn { cursor: pointer; transition: all 0.2s; font-variant-numeric: tabular-nums; display: inline-block; text-align: right; }
.like-text-btn:hover { background: #f5f5f5; }
/* ===== 댓글 더보기 버튼 ===== */
.load-more-container { text-align: center; padding: 20px 24px; background: white; border-bottom: 1px solid #f5f5f5; }
.btn-load-more { background: #f8f9fa; border: 1px solid #e9ecef; color: #6c757d; padding: 12px 24px; border-radius: 20px; cursor: pointer; font-size: 14px; font-weight: 500; transition: all 0.2s ease; display: inline-flex; align-items: center; gap: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
.btn-load-more:hover { background: #e9ecef; border-color: #adb5bd; color: #495057; transform: translateY(-1px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
.btn-load-more:active { transform: translateY(0); box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
.load-more-text { font-weight: 600; }
.load-more-count { font-size: 12px; opacity: 0.7; }

</style>

<!-- 댓글 및 좋아요 영역 html -->
<div class="reply-container">
    <!-- 댓글 헤더 (통계 + 정렬) -->
    <div class="reply-header">
    	<!-- 댓글 통계 / 탭 전환  -->
        <div class="reply-stats">
	        <!-- 게시글 좋아요 svg 버튼, 좋아요 탭 버튼, 좋아요수 -->
			<div class="stat-item tab-button" data-tab="like" style="padding-left: 10px;">
			    <button class="post-like-btn" id="postLikeBtn" onclick="togglePostLike()" title="좋아요">
    	            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
    	                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
    	            </svg>
    	        </button>
			    <span class="like-text-btn" onclick="switchTab('like')" 
			          style="margin-left: 0px; padding: 4px 0px; border-radius: 4px;">
			        좋아요 <strong id="likeTotalCount">0</strong>
			    </span>
			</div>
			<!-- 댓글 탭 버튼 + 댓글수 -->
	        <div class="stat-item tab-button active" data-tab="reply" onclick="switchTab('reply')" style="padding-left: 10px; padding-right: 20px;">
	            <span class="stat-icon">💬</span>
	            <span>댓글 <strong id="replyTotalCount">0</strong></span>
	        </div>
	    </div>
        <!-- 댓글 정렬 버튼 (등록순/최신순) -->
        <div class="reply-sort" id="replySortButtons">
		    <button class="sort-btn active" data-order="ASC">등록순</button>
		    <button class="sort-btn" data-order="DESC">최신순</button>
		</div>
    </div>
    <!-- 댓글 목록 -->
    <div id="replyList">
        <div class="loading">댓글을 불러오는 중...</div>
    </div>
    <!-- 좋아요 목록 -->
	<div id="likeList" class="like-list-container" style="display:none;">
	    <div class="loading">좋아요 목록을 불러오는 중...</div>
	</div>
	<!-- 페이지네이션 (게시글 좋아요한 사용자 목록용) -->
	<div id="likePagination" class="pagination-container" style="display:none;">
	    <!-- 동적으로 생성됨 -->
	</div>
    <!-- 댓글 작성 폼 -->
    <div class="reply-write-form">
    	<!-- 작성자 정보 (프로필 이미지 + 닉네임) -->
        <div class="write-form-header">
            <c:choose>
                <c:when test="${not empty sessionScope.LOGIN_USER.user_photo}">
                    <img src="${pageContext.request.contextPath}${sessionScope.LOGIN_USER.user_photo}" alt="프로필" class="profile-img">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/images/default-avatar.png" alt="프로필" class="profile-img">
                </c:otherwise>
            </c:choose>
            <span class="author-name">
                ${not empty sessionScope.LOGIN_USER ? sessionScope.LOGIN_USER.user_nickname : '방문자'}
            </span>
        </div>
        <!-- 첨부 이미지 미리보기 영역 -->
        <div id="attachedImages" class="attached-images"></div>
        <!-- 댓글 입력창 -->
        <textarea id="replyContent" placeholder="댓글을 남겨보세요" maxlength="3000"></textarea>
        <div class="reply-write-actions">
            <div class="write-tools">
                <input type="file" id="imageInput" class="image-input" accept="image/*" multiple onchange="handleImageSelect(event)">
                <button class="tool-btn" title="이미지 첨부" onclick="document.getElementById('imageInput').click()">📷</button>
                <button class="tool-btn" title="이모티콘">😊</button>
            </div>
            <span class="char-count"><span id="currentLength">0</span>/1000</span>
            <button class="btn-submit" onclick="writeReply()">등록</button>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
/* ==== 전역 변수 정의 ==== */
// 게시글 ID (JSP에서 전달받음)
var ROOM_BOARD_ID = ${param.roomBoardId};
//좋아요 요청 상태 관리 객체 (중복 방지용)
var likeRequestTracker = {
    pending: new Set(),
    lastRequestTime: new Map(),
    cooldownMs: 300, // 300ms 쿨다운
    isProcessing: function(key) {
        return this.pending.has(key);
    },
    canRequest: function(key) {
        var lastTime = this.lastRequestTime.get(key);
        if (!lastTime) return true;
        return (Date.now() - lastTime) >= this.cooldownMs;
    },
    startProcessing: function(key) {
        this.pending.add(key);
        this.lastRequestTime.set(key, Date.now());
    },
    endProcessing: function(key) {
        this.pending.delete(key);
    }
};
var currentOrder = 'ASC';
var currentTab = 'reply';
// 현재 로그인한 사용자 ID (JSP에서 전달받음)
var CURRENT_USER_ID = ${not empty sessionScope.LOGIN_USER ? sessionScope.LOGIN_USER.user_id : 'null'};
// 현재 방 ID (JSP에서 전달받음)  
/* var CURRENT_ROOM_ID = ${param.roomId != null ? param.roomId : (sessionScope.currentRoomId != null ? sessionScope.currentRoomId : 'null')}; */
// 현재 방 ID 설정 - 더 안전하게 처리
var CURRENT_ROOM_ID = null;

// JSP에서 전달받은 roomId 파라미터 사용
<c:if test="${not empty param.roomId}">
    CURRENT_ROOM_ID = ${param.roomId};
    console.log('param.roomId에서 CURRENT_ROOM_ID 설정:', CURRENT_ROOM_ID);
</c:if>

// 세션의 currentRoomId 사용 (파라미터가 없을 때)
<c:if test="${empty param.roomId and not empty sessionScope.currentRoomId}">
    CURRENT_ROOM_ID = ${sessionScope.currentRoomId};
    console.log('sessionScope.currentRoomId에서 CURRENT_ROOM_ID 설정:', CURRENT_ROOM_ID);
</c:if>

// 여전히 null이면 URL에서 추출 시도
if (CURRENT_ROOM_ID === null) {
    var urlParams = new URLSearchParams(window.location.search);
    var roomIdFromUrl = urlParams.get('roomId');
    if (roomIdFromUrl) {
        CURRENT_ROOM_ID = parseInt(roomIdFromUrl);
        console.log('URL에서 CURRENT_ROOM_ID 설정:', CURRENT_ROOM_ID);
    }
}

console.log('최종 CURRENT_ROOM_ID:', CURRENT_ROOM_ID);

// 게시글 좋아요 상태 전역 변수
var isPostLiked = false;
// 좋아요 페이지네이션 변수들
var likeCurrentPage = 1;
var likeTotalPages = 1;
// 댓글 더보기 기능용 변수들
var allReplies = []; // 서버에서 받은 원본 트리 구조 댓글
var flatReplies = []; // 평면화된 댓글 배열 (표시용)
var displayedCount = 0; // 현재 표시된 댓글 수
var initialLoadCount = 30; // 처음 로드할 댓글 수
var loadMoreCount = 10; // 더보기 시 추가할 댓글 수
// 댓글 정보를 ID로 빠르게 찾기 위한 맵
var replyMap = {};

/* ==== 초기화 (DOM Ready): 최초 데이터 로드 및 이벤트 바인딩 ==== */
jQuery(document).ready(function() {
    console.log('댓글 시스템 로드, ROOM_BOARD_ID:', ROOM_BOARD_ID);
    console.log('현재 사용자 ID:', CURRENT_USER_ID);
    console.log('현재 방 ID:', CURRENT_ROOM_ID);
    loadReplyList();
    loadInitialLikeCount();
    loadPostLikeStatus();
    // 글자 수 카운터
    jQuery('#replyContent').on('input', function() {
        jQuery('#currentLength').text(jQuery(this).val().length);
    });
    // 정렬 버튼 클릭
    jQuery('.sort-btn').on('click', function() {
        jQuery('.sort-btn').removeClass('active');
        jQuery(this).addClass('active');
        currentOrder = jQuery(this).data('order');
        // 정렬 변경 시 표시 카운트 초기화
        resetDisplayState();
        loadReplyList();
    });
});

/* ==== 화면/상태 유틸리티(리스트, 맵, 표시 카운트 등) ==== */
// 화면 상태 초기화 함수 
function resetDisplayState() {
    displayedCount = 0;
    allReplies = [];
    flatReplies = [];
    replyMap = {};
}
// 댓글 맵 생성 (ID로 빠른 검색을 위해)
function buildReplyMap(replies) {
    function addToMap(reply) {
        replyMap[reply.replyId] = reply;
        if (reply.replies && reply.replies.length > 0) {
            for (var i = 0; i < reply.replies.length; i++) {
                addToMap(reply.replies[i]);
            }
        }
    }
    for (var i = 0; i < replies.length; i++) {
        addToMap(replies[i]);
    }
}
// 트리 구조의 댓글을 표시 순서대로 평면화(삭제된 답글은 제외하고, 삭제된 원댓글은 포함)
function flattenReplyTree(replies) {
    var flattened = [];
    function processReply(reply, isChild, parentReply) {
        // 삭제된 답글은 평면화에서 제외 (표시하지 않으므로)
        if (isChild && reply.status === 'DELETED') {
            console.log('삭제된 답글 제외:', reply.replyId);
            return;
        }
        // 현재 댓글 추가 (isChild 정보와 부모 댓글 정보 포함)
        var flatReply = Object.assign({}, reply);
        flatReply.isChild = isChild || false;
        flatReply.parentReplyInfo = parentReply || null;
        flattened.push(flatReply);
        console.log('평면화 추가:', flatReply.replyId, '(삭제여부:', flatReply.status, ', 답글여부:', flatReply.isChild, ')');
        // 자식 댓글들이 있으면 재귀적으로 처리
        if (reply.replies && reply.replies.length > 0) {
            for (var i = 0; i < reply.replies.length; i++) {
                processReply(reply.replies[i], true, reply);
            }
        }
    }
    // 모든 최상위 댓글들을 처리
    for (var i = 0; i < replies.length; i++) {
        processReply(replies[i], false, null);
    }
    console.log('평면화 완료. 총 댓글 수:', flattened.length);
    return flattened;
}
/* ==== 댓글 목록 로드 & 렌더링 (비동기 로드, 더보기, html 빌드) ==== */
// 댓글 목록 불러오기 (서버에서 전체 댓글 가져오기)
function loadReplyList() {
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/reply/list.ajax',
        type: 'GET',
        dataType: 'json',
        data: {
            roomBoardId: ROOM_BOARD_ID,
            orderBy: currentOrder
        },
        success: function(response) {
            console.log('댓글 목록 응답:', response);
            if (response.success) {
                // 서버에서 받은 트리 구조 댓글 저장
                allReplies = response.replies || [];
                // 댓글 맵 생성 (ID로 빠른 검색용)
                buildReplyMap(allReplies);
                // 트리 구조를 평면화하여 순서대로 배열 생성
                flatReplies = flattenReplyTree(allReplies);
                console.log('전체 댓글 수:', flatReplies.length);
                console.log('평면화된 댓글:', flatReplies);
                // 댓글 표시 (처음 30개부터)
                displayReplies();
                // 총 댓글 수 업데이트
                jQuery('#replyTotalCount').text(response.totalCount);
            } else {
                alert(response.message);
            }
        },
        error: function(xhr, status, error) {
            console.error('댓글 목록 로드 에러:', error);
            alert('서버 오류가 발생했습니다: ' + error);
        }
    });
}
// 댓글 표시 함수 (30개씩 초기 로드, 10개씩 추가 로드)
function displayReplies() {
    var replyList = jQuery('#replyList');
    // 처음 호출인 경우에만 리스트 초기화
    if (displayedCount === 0) {
        replyList.empty();
        // 댓글이 없는 경우
        if (flatReplies.length === 0) {
            replyList.html('<div class="empty-state">첫 댓글을 작성해보세요!</div>');
            return;
        }
        console.log('첫 댓글 로드 시작. 전체 댓글 수:', flatReplies.length);
    }
    // 이번에 표시할 댓글 범위 계산
    var startIndex = displayedCount;
    var endIndex;
    if (displayedCount === 0) {
        // 처음 로드: 30개까지 표시 (전체 댓글이 30개 미만이면 전체 표시)
        endIndex = Math.min(initialLoadCount, flatReplies.length);
        console.log('첫 로드: 0부터', endIndex, '개 표시');
    } else {
        // 더보기: 현재 + 10개까지 추가 (남은 댓글이 10개 미만이면 나머지 전체)
        endIndex = Math.min(displayedCount + loadMoreCount, flatReplies.length);
        console.log('더보기: ', startIndex, '부터', endIndex, '까지 추가 표시');
    }
    // 새로 추가할 댓글들만 렌더링
    var addedCount = 0;
    for (var i = startIndex; i < endIndex; i++) {
        var reply = flatReplies[i];
        var replyHtml = createReplyHtml(reply, reply.isChild);
        // HTML이 비어있지 않으면 추가 (삭제된 답글은 빈 문자열 반환)
        if (replyHtml.trim() !== '') {
            replyList.append(replyHtml);
            addedCount++;
        }
    }
    // 표시된 댓글 수 업데이트
    displayedCount = endIndex;
    console.log('실제 추가된 댓글 수:', addedCount, '/ 처리된 인덱스:', startIndex, '~', endIndex-1);
    console.log('누적 표시된 댓글 수:', displayedCount, '/ 전체:', flatReplies.length);
    // 기존 더보기 버튼 제거
    jQuery('#loadMoreBtn').remove();
    // 더 표시할 댓글이 있으면 더보기 버튼 추가
    if (displayedCount < flatReplies.length) {
        var remainingCount = flatReplies.length - displayedCount;
        var nextLoadCount = Math.min(loadMoreCount, remainingCount);
        var loadMoreBtn = '<div id="loadMoreBtn" class="load-more-container">' +
            '<button class="btn-load-more" onclick="loadMoreReplies()">' +
            '<span class="load-more-text">댓글 ' + nextLoadCount + '개 더보기</span>' +
            '<span class="load-more-count">(' + remainingCount + '개 남음)</span>' +
            '</button>' +
            '</div>';
        replyList.append(loadMoreBtn);
        console.log('더보기 버튼 추가 - 다음 로드:', nextLoadCount, '개, 남은 총 댓글:', remainingCount, '개');
    } else {
        console.log('모든 댓글 표시 완료');
    }
}
// 더보기 버튼 클릭 시 추가 댓글 로드
function loadMoreReplies() {
    console.log('더보기 클릭 - 현재 표시된 댓글:', displayedCount, '/', flatReplies.length);
    displayReplies();
}
// 댓글 HTML 생성
function createReplyHtml(reply, isChild) {
    var childClass = isChild ? 'child-reply' : '';
    var contextPath = '${pageContext.request.contextPath}';
    var profileImgSrc = reply.userPhoto ? 
        contextPath + reply.userPhoto : 
        contextPath + '/images/default-avatar.png';
    var defaultImgSrc = contextPath + '/images/default-avatar.png';
    
    // ★ 사용자 활동 페이지 URL 생성
    var userActivityUrl = contextPath + '/room/useractivity.room?userId=' + reply.userId + '&roomId=' + CURRENT_ROOM_ID;
    
    var profileImg = '<img src="' + profileImgSrc + '" alt="프로필" class="profile-img" ' +
        'onclick="goToUserActivity(' + reply.userId + ')" ' +
        'onerror="this.onerror=null; this.src=\'' + defaultImgSrc + '\';">';
    
    // 삭제된 원댓글만 "삭제된 댓글입니다" 표시
    if (reply.status === 'DELETED' && !isChild) {
        return '<div class="reply-item ' + childClass + '" data-reply-id="' + reply.replyId + '">' +
            '<div class="reply-item-header">' +
            '<div class="reply-author">' +
            '<div class="reply-main-content">' +
            '<div class="reply-content" style="color: #999; font-style: italic;">삭제된 댓글입니다.</div>' +
            '</div></div></div></div>';
    }
    // 삭제된 답글은 이미 평면화에서 제외되므로 여기서는 처리하지 않음
    // 더보기 메뉴 버튼
    var actionButtons = '';
    if (reply.owner) {
        actionButtons = '<div class="reply-more-menu">' +
            '<button class="btn-more" onclick="toggleDropdown(event, ' + reply.replyId + ')">⋮</button>' +
            '<div class="dropdown-menu" id="dropdown' + reply.replyId + '">' +
            '<button class="dropdown-item" onclick="editReply(' + reply.replyId + ')">수정</button>' +
            '<button class="dropdown-item danger" onclick="deleteReply(' + reply.replyId + ')">삭제</button>' +
            '</div></div>';
    } else {
        actionButtons = '<div class="reply-more-menu">' +
            '<button class="btn-more" onclick="toggleDropdown(event, ' + reply.replyId + ')">⋮</button>' +
            '<div class="dropdown-menu" id="dropdown' + reply.replyId + '">' +
            '<button class="dropdown-item danger" onclick="reportReply(' + reply.replyId + ')">신고하기</button>' +
            '</div></div>';
    }
    var replyButton = '<button class="btn-reply-write" onclick="toggleChildReplyForm(' + reply.replyId + ')">답글쓰기</button>';
    // 좋아요 버튼 (isLiked 상태 반영)
    var isLikedClass = reply.isLiked ? 'liked' : '';
    var fillColor = reply.isLiked ? '#ff5a5f' : 'none';
    var strokeColor = reply.isLiked ? '#ff5a5f' : 'currentColor';
    var likeButton = '<button class="btn-like ' + isLikedClass + '" data-reply-id="' + reply.replyId + '" onclick="toggleReplyLike(' + reply.replyId + ')">' +
       '<svg width="14" height="14" viewBox="0 0 24 24" fill="' + fillColor + '" stroke="' + strokeColor + '" stroke-width="2">' +
       '<path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>' +
       '</svg>' +
       (reply.likeCount > 0 ? ' <span class="like-count">' + reply.likeCount + '</span>' : '') +
       '</button>';
    var childForm = '<div class="child-reply-form" id="childForm' + reply.replyId + '" style="display:none;">' +
        '<textarea class="reply-textarea" id="childContent' + reply.replyId + '" ' +
        'placeholder="답글을 입력하세요..." maxlength="3000"></textarea>' +
        '<div class="reply-write-actions">' +
        '<div class="write-tools"></div>' +
        '<span class="char-count"><span id="childLength' + reply.replyId + '">0</span>/3000</span>' +
        '<button class="btn-cancel" onclick="toggleChildReplyForm(' + reply.replyId + ')">취소</button>' +
        '<button class="btn-submit" onclick="writeChildReply(' + reply.replyId + ')">등록</button>' +
        '</div></div>';
    var timeText = '';
    if (reply.replyUpdatedAt && reply.replyUpdatedAt !== reply.replyCreatedAt) {
        timeText = '(수정됨) ' + formatDateTime(reply.replyUpdatedAt);
    } else {
        timeText = formatDateTime(reply.replyCreatedAt);
    }
    // 내댓글 표시
    var myCommentBadge = '';
    if (CURRENT_USER_ID && reply.userId === CURRENT_USER_ID) {
        myCommentBadge = '<span class="my-comment-badge">내댓글</span>';
    }
    // 답글 대상 닉네임 표시 (답글이면서 부모가 원댓글이 아닌 경우만)
    var replyTargetNickname = '';
    if (isChild && reply.parentReplyInfo && reply.parentReplyInfo.parentReplyId != null) {
        replyTargetNickname = '<span class="reply-target">@' + escapeHtml(reply.parentReplyInfo.userNickname) + '</span>';
    }
    
    // ★ 사용자 이름에 클릭 이벤트 추가
    var authorName = '<a href="' + userActivityUrl + '" class="author-name">' + escapeHtml(reply.userNickname) + '</a>';
    
    return '<div class="reply-item ' + childClass + '" data-reply-id="' + reply.replyId + '">' +
        '<div class="reply-item-header">' +
        '<div class="reply-author">' +
        profileImg +
        '<div class="reply-main-content">' +
        '<div class="author-info">' +
        authorName +
        myCommentBadge +
        '</div>' +
        '<div class="reply-content" data-original="' + escapeHtml(reply.replyContent) + '">' +
        replyTargetNickname + escapeHtml(reply.replyContent) + '</div>' +
        '<span class="reply-time">' + timeText + '</span>' + replyButton + likeButton +
	    '</div></div>' +
	    actionButtons +
	    '</div>' +
	    childForm +
	    '</div>';  
}

//사용자 활동 페이지로 이동하는 함수 수정
function goToUserActivity(userId) {
    console.log('goToUserActivity 호출 - userId:', userId, 'roomId:', CURRENT_ROOM_ID);
    
    if (!userId || !CURRENT_ROOM_ID || userId <= 0 || CURRENT_ROOM_ID <= 0) {
        console.error('유효하지 않은 파라미터 - userId:', userId, 'roomId:', CURRENT_ROOM_ID);
        alert('사용자 정보를 불러올 수 없습니다.');
        return;
    }
    
    var url = '${pageContext.request.contextPath}/room/useractivity.room?userId=' + userId + '&roomId=' + CURRENT_ROOM_ID;
    console.log('이동할 URL:', url);
    window.location.href = url;
}

/* ==== 공통 포맷 ==== */
function escapeHtml(text) {
    if (!text) return '';
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
function formatDateTime(dateStr) {
    if (!dateStr) return '';
    var date = new Date(dateStr);
    var year = date.getFullYear();
    var month = String(date.getMonth() + 1).padStart(2, '0');
    var day = String(date.getDate()).padStart(2, '0');
    var hours = String(date.getHours()).padStart(2, '0');
    var minutes = String(date.getMinutes()).padStart(2, '0');
    return year + '.' + month + '.' + day + ' ' + hours + ':' + minutes;
}
/* ==== 첨부 이미지 처리 ====(추후) */
var selectedImages = [];
function handleImageSelect(event) {
    var files = event.target.files;
    for (var i = 0; i < files.length; i++) {
        if (selectedImages.length >= 5) {
            alert('이미지는 최대 5개까지 첨부할 수 있습니다.');
            break;
        }
        if (!files[i].type.startsWith('image/')) {
            alert('이미지 파일만 첨부할 수 있습니다.');
            continue;
        }
        selectedImages.push(files[i]);
    }
    displayAttachedImages();
    event.target.value = '';
}

function displayAttachedImages() {
    var container = jQuery('#attachedImages');
    container.empty();
    if (selectedImages.length === 0) {
        container.hide();
        return;
    }
    container.css('display', 'flex');
    for (var i = 0; i < selectedImages.length; i++) {
        (function(index) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var imageHtml = '<div class="attached-image">' +
                    '<img src="' + e.target.result + '" alt="첨부 이미지">' +
                    '<button class="remove-image" onclick="removeImage(' + index + ')">×</button></div>';
                container.append(imageHtml);
            };
            reader.readAsDataURL(selectedImages[index]);
        })(i);
    }
}

function removeImage(index) {
    selectedImages.splice(index, 1);
    displayAttachedImages();
}

/* ==== 댓글 CRUD + 댓글 좋아요 ==== */
// 댓글 좋아요 토글
function toggleReplyLike(replyId) {
    var targetKey = 'reply_' + replyId;
    // 중복 요청 체크
    if (likeRequestTracker.isProcessing(targetKey)) {
        console.log('댓글 좋아요 처리 중입니다...');
        return;
    }
    // 쿨다운 체크
    if (!likeRequestTracker.canRequest(targetKey)) {
        console.log('잠시 후 다시 시도해주세요...');
        return;
    }
    // 요청 시작 표시
    likeRequestTracker.startProcessing(targetKey);
    // 현재 상태 저장 (롤백용)
    var likeBtn = jQuery('.btn-like[data-reply-id="' + replyId + '"]');
    var currentLiked = likeBtn.hasClass('liked');
    var likeCountSpan = likeBtn.find('.like-count');
    var currentCount = likeCountSpan.length > 0 ? parseInt(likeCountSpan.text()) || 0 : 0;
    // 미리 UI 변경 (낙관적 업데이트)
    var svg = likeBtn.find('svg');
    if (currentLiked) {
        // 좋아요 취소 예상
        likeBtn.removeClass('liked');
        svg.attr('fill', 'none');
        svg.attr('stroke', 'currentColor');
        if (currentCount > 1) {
            likeCountSpan.text(currentCount - 1);
        } else {
            likeCountSpan.remove();
        }
    } else {
        // 좋아요 추가 예상
        likeBtn.addClass('liked');
        svg.attr('fill', '#ff5a5f');
        svg.attr('stroke', '#ff5a5f');
        if (likeCountSpan.length > 0) {
            likeCountSpan.text(currentCount + 1);
        } else {
            likeBtn.append(' <span class="like-count">' + (currentCount + 1) + '</span>');
        }
    }
    // 버튼 비활성화
    likeBtn.prop('disabled', true).css('opacity', '0.7');
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/like/action.ajax',
        type: 'POST',
        dataType: 'json',
        data: {
            targetType: 'REPLY',
            targetId: replyId
        },
        success: function(response) {
            console.log('댓글 좋아요 응답:', response);
            if (response.success) {
                // 서버 응답에 따라 UI 재조정
                var svg = likeBtn.find('svg');
                var likeCountSpan = likeBtn.find('.like-count');
                if (response.isLiked) {
                    likeBtn.addClass('liked');
                    svg.attr('fill', '#ff5a5f');
                    svg.attr('stroke', '#ff5a5f');
                } else {
                    likeBtn.removeClass('liked');
                    svg.attr('fill', 'none');
                    svg.attr('stroke', 'currentColor');
                }
                // 좋아요 개수 업데이트
                if (response.likeCount > 0) {
                    if (likeCountSpan.length > 0) {
                        likeCountSpan.text(response.likeCount);
                    } else {
                        likeBtn.append(' <span class="like-count">' + response.likeCount + '</span>');
                    }
                } else {
                    likeCountSpan.remove();
                }
                console.log('댓글 좋아요 ' + response.action + '! 총 ' + response.likeCount + '개');
            } else {
                // 실패 시 UI 되돌리기
                rollbackReplyLikeUI(likeBtn, currentLiked, currentCount);
                alert(response.message || '좋아요 처리에 실패했습니다.');
            }
        },
        error: function(xhr, status, error) {
            console.error('댓글 좋아요 처리 중 오류:', error);
            console.error('응답:', xhr.responseText);
            // 에러 시 UI 되돌리기
            rollbackReplyLikeUI(likeBtn, currentLiked, currentCount);
            alert('좋아요 처리에 실패했습니다.');
        },
        complete: function() {
            // 요청 완료 - 상태 복원
            likeRequestTracker.endProcessing(targetKey);
            likeBtn.prop('disabled', false).css('opacity', '1');
        }
    });
}

// 댓글 좋아요 UI 롤백 헬퍼 함수
function rollbackReplyLikeUI(likeBtn, wasLiked, originalCount) {
    var svg = likeBtn.find('svg');
    var likeCountSpan = likeBtn.find('.like-count');
    if (wasLiked) {
        likeBtn.addClass('liked');
        svg.attr('fill', '#ff5a5f');
        svg.attr('stroke', '#ff5a5f');
    } else {
        likeBtn.removeClass('liked');
        svg.attr('fill', 'none');
        svg.attr('stroke', 'currentColor');
    }
    // 원래 카운트 복원
    likeCountSpan.remove();
    if (originalCount > 0) {
        likeBtn.append(' <span class="like-count">' + originalCount + '</span>');
    }
}

// 댓글 작성 - /reply/write.ajax
function writeReply() {
    var content = jQuery('#replyContent').val().trim();
    if (!content) {
        alert('댓글 내용을 입력해주세요.');
        return;
    }
    if (selectedImages.length > 0) {
        alert('이미지 첨부 기능은 준비 중입니다.\n텍스트 댓글만 등록됩니다.');
    }
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/reply/write.ajax',
        type: 'POST',
        dataType: 'json',
        data: {
            roomBoardId: ROOM_BOARD_ID,
            replyContent: content
        },
        success: function(response) {
            if (response.success) {
                jQuery('#replyContent').val('');
                jQuery('#currentLength').text('0');
                selectedImages = [];
                displayAttachedImages();
                // 댓글 작성 후 목록 새로고침 (표시 카운트 초기화)
                resetDisplayState();
                loadReplyList();
                alert(response.message);
            } else {
                alert(response.message);
            }
        },
        error: function(xhr, status, error) {
            console.error('댓글 작성 에러:', error);
            alert('서버 오류가 발생했습니다: ' + error);
        }
    });
}

function toggleChildReplyForm(parentReplyId) {
    var form = jQuery('#childForm' + parentReplyId);
    form.toggle();
    if (form.is(':visible')) {
        jQuery('#childContent' + parentReplyId).off('input').on('input', function() {
            jQuery('#childLength' + parentReplyId).text(jQuery(this).val().length);
        });
    }
}

// 대댓글 작성 - /reply/write.ajax
function writeChildReply(parentReplyId) {
    var content = jQuery('#childContent' + parentReplyId).val().trim();
    if (!content) {
        alert('답글 내용을 입력해주세요.');
        return;
    }
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/reply/write.ajax',
        type: 'POST',
        dataType: 'json',
        data: {
            roomBoardId: ROOM_BOARD_ID,
            replyContent: content,
            parentReplyId: parentReplyId
        },
        success: function(response) {
            if (response.success) {
                jQuery('#childContent' + parentReplyId).val('');
                toggleChildReplyForm(parentReplyId);
                // 답글 작성 후 목록 새로고침 (표시 카운트 초기화)
                resetDisplayState();
                loadReplyList();
                alert(response.message);
            } else {
                alert(response.message);
            }
        },
        error: function(xhr, status, error) {
            console.error('답글 작성 에러:', error);
            alert('서버 오류가 발생했습니다: ' + error);
        }
    });
}

// 댓글 수정 모드 활성화
function editReply(replyId) {
    jQuery('.dropdown-menu').removeClass('show');
    var replyItem = jQuery('.reply-item[data-reply-id="' + replyId + '"]');
    var contentDiv = replyItem.find('.reply-content');
    var originalContent = contentDiv.data('original');
    contentDiv.html(
        '<textarea class="reply-textarea" id="editContent' + replyId + '" style="margin-top:8px;">' + escapeHtml(originalContent) + '</textarea>' +
        '<div class="reply-write-actions" style="margin-top:12px;">' +
        '<div class="write-tools"></div>' +
        '<span class="char-count"><span id="editLength' + replyId + '">' + originalContent.length + '</span>/3000</span>' +
        '<button class="btn-cancel" onclick="cancelEditReply()">취소</button>' +
        '<button class="btn-submit" onclick="updateReply(' + replyId + ')">수정</button></div>'
    );
    jQuery('#editContent' + replyId).on('input', function() {
        jQuery('#editLength' + replyId).text(jQuery(this).val().length);
    });
}

// 댓글 수정 취소
function cancelEditReply() {
    // 현재 표시 상태 저장
    var currentDisplayed = displayedCount;
    // 목록 새로고침
    resetDisplayState();
    loadReplyList();
    // 로드 완료 후 이전 표시 상태 복원
    setTimeout(function() {
        if (currentDisplayed > initialLoadCount) {
            displayedCount = initialLoadCount;
            for (var i = 0; i < Math.ceil((currentDisplayed - initialLoadCount) / loadMoreCount); i++) {
                displayReplies();
            }
        }
    }, 100);
}

// 댓글 수정 - /reply/update.ajax
function updateReply(replyId) {
    var content = jQuery('#editContent' + replyId).val().trim();
    if (!content) {
        alert('댓글 내용을 입력해주세요.');
        return;
    }
    if (confirm('댓글을 수정하시겠습니까?')) {
        jQuery.ajax({
            url: '${pageContext.request.contextPath}/reply/update.ajax',
            type: 'POST',
            dataType: 'json',
            data: {
                replyId: replyId,
                replyContent: content
            },
            success: function(response) {
                if (response.success) {
                    // 수정 후에는 현재 표시된 댓글 수 유지
                    var currentDisplayed = displayedCount;
                    resetDisplayState();
                    loadReplyList();
                    // 로드 완료 후 이전 표시 상태 복원
                    setTimeout(function() {
                        if (currentDisplayed > initialLoadCount) {
                            displayedCount = initialLoadCount;
                            for (var i = 0; i < Math.ceil((currentDisplayed - initialLoadCount) / loadMoreCount); i++) {
                                displayReplies();
                            }
                        }
                    }, 100);
                    alert(response.message);
                } else {
                    alert(response.message);
                }
            },
            error: function(xhr, status, error) {
                console.error('댓글 수정 에러:', error);
                alert('서버 오류가 발생했습니다: ' + error);
            }
        });
    }
}

// 댓글 삭제 - /reply/delete.ajax
function deleteReply(replyId) {
    jQuery('.dropdown-menu').removeClass('show');
    if (confirm('댓글을 삭제하시겠습니까?')) {
        jQuery.ajax({
            url: '${pageContext.request.contextPath}/reply/delete.ajax',
            type: 'POST',
            dataType: 'json',
            data: {
                replyId: replyId
            },
            success: function(response) {
                if (response.success) {
                    // 삭제 후 목록 새로고침 (표시 카운트 초기화)
                    resetDisplayState();
                    loadReplyList();
                    alert(response.message);
                } else {
                    alert(response.message);
                }
            },
            error: function(xhr, status, error) {
                console.error('댓글 삭제 에러:', error);
                alert('서버 오류가 발생했습니다: ' + error);
            }
        });
    }
}

/* ==== 더보기/신고/다롭다운 ==== */
function toggleDropdown(event, replyId) {
    event.stopPropagation();
    var dropdown = jQuery('#dropdown' + replyId);
    var isVisible = dropdown.hasClass('show');
    jQuery('.dropdown-menu').removeClass('show');
    if (!isVisible) {
        dropdown.addClass('show');
    }
}

function reportReply(replyId) {
    jQuery('.dropdown-menu').removeClass('show');
    if (confirm('이 댓글을 신고하시겠습니까?')) {
        alert('신고 기능은 준비 중입니다.');
    }
}

jQuery(document).on('click', function(e) {
    if (!jQuery(e.target).closest('.reply-more-menu').length) {
        jQuery('.dropdown-menu').removeClass('show');
    }
});

/* ==== 탭 전환(댓글/좋아요) ==== */
// 탭 전환 
function switchTab(tabName) {
    if (currentTab === tabName) return;
    currentTab = tabName;
    updateTabActiveState(tabName);
    if (tabName === 'reply') {
    	// 댓글 탭
        jQuery('#replyList').show();
        jQuery('#likeList').hide();
        jQuery('#likePagination').hide();
        jQuery('#replySortButtons').removeClass('hidden');
        jQuery('.reply-write-form').show();
        // 댓글 탭 전환 시 표시 카운트 초기화
        resetDisplayState();
        loadReplyList();
    } else {
    	// 좋아요 탭
        jQuery('#replyList').hide();
        jQuery('#likeList').show();
        jQuery('#likePagination').show();
        jQuery('#replySortButtons').addClass('hidden');
        jQuery('.reply-write-form').hide();
        loadLikeList();
    }
}

// 탭 선택에 따른 UI 업데이트
function updateTabActiveState(tabName) {
	// 컨테이너(.stat-item.tab-button)를 기준으로 활성화 표시
    jQuery('.stat-item.tab-button').removeClass('active');
    jQuery('.stat-item.tab-button[data-tab="' + tabName + '"]').addClass('active');
}

/* ==== 좋아요 탭 목록/페이지네이션 ==== */
// 좋아요 목록 불러오기 
function loadLikeList(page) {
    if (page) {
        likeCurrentPage = page;
    }
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/like/detail.ajax',
        type: 'GET',
        dataType: 'json',
        data: {
            roomBoardId: ROOM_BOARD_ID,
            page: likeCurrentPage
        },
        success: function(response) {
            console.log('좋아요 목록 응답:', response);
            if (response.success) {
                displayLikeList(response.likeUsers);
                jQuery('#likeTotalCount').text(response.totalCount);
                
                // 페이지네이션 정보 업데이트
                likeTotalPages = response.totalPages || 1;
                updateLikePagination();
            } else {
                alert(response.message);
            }
        },
        error: function(xhr, status, error) {
            console.error('좋아요 목록 로드 에러:', error);
            alert('서버 오류가 발생했습니다: ' + error);
        }
    });
}

// 좋아요 목록 표시
function displayLikeList(likeUsers) {
    var likeList = jQuery('#likeList');
    likeList.empty();
    if (likeUsers.length === 0) {
        likeList.html('<div class="empty-state">아직 좋아요가 없습니다.</div>');
        jQuery('#likePagination').hide();
        return;
    }
    var contextPath = '${pageContext.request.contextPath}'; 
    // 그리드 컨테이너 생성
    var gridContainer = jQuery('<div class="like-users-grid"></div>');
    for (var i = 0; i < likeUsers.length; i++) {
        var user = likeUsers[i];
        var profileImgSrc = user.userPhoto ? 
            contextPath + user.userPhoto : 
            contextPath + '/images/default-avatar.png';
        var likeDate = formatDateTime(user.likeCreatedAt);
        // 본인인지 확인하여 "나" 표시 추가
        var meBadge = '';
        if (CURRENT_USER_ID && user.userId === CURRENT_USER_ID) {
            meBadge = '<span class="me-badge">나</span>';
        }
        
        // ★ 사용자 정보에 클릭 이벤트 추가
        var userHtml = '<div class="like-user-item" onclick="goToUserActivity(' + user.userId + ')">' +
            '<img src="' + profileImgSrc + '" alt="프로필" class="like-user-avatar" ' +
            'onerror="this.src=\'' + contextPath + '/images/default-avatar.png\';">' +
            '<div class="like-user-info">' +
            '<div class="like-user-name">' + escapeHtml(user.userNickname) + meBadge + '</div>' +
            '<div class="like-user-date">' + likeDate + '</div>' +
            '</div></div>';
        gridContainer.append(userHtml);
    }
    likeList.append(gridContainer);
    // 페이지네이션 표시 (좋아요가 있을 때만)
    if (likeUsers.length > 0) {
        jQuery('#likePagination').show();
    }
}

// 좋아요 페이지네이션 UI 업데이트
function updateLikePagination() {
    var container = jQuery('#likePagination');
    
    container.show();
    container.html(createPaginationHTML(likeCurrentPage, likeTotalPages, 'like'));
}

// 페이지네이션 HTML 생성 (좋아요용만)
function createPaginationHTML(currentPage, totalPages, type) {
    if (totalPages <= 0) totalPages = 1;
    var html = '<div style="display: flex; align-items: center; justify-content: center; gap: 4px;">';
    // 이전 버튼 SVG
    var prevDisabled = currentPage <= 1;
    html += '<button class="pagination-btn" onclick="goToLikePage(' + (currentPage - 1) + ')" ' +
           (prevDisabled ? 'disabled style="opacity: 0.3;"' : '') + '>' +
           '<svg width="20" height="16" viewBox="0 0 31 24" fill="none" xmlns="http://www.w3.org/2000/svg">' +
           '<path d="M19 18L13 12L19 6" stroke="' + (prevDisabled ? '#ccc' : '#FF7272') + '" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>' +
           '</svg></button>';
    // 페이지 번호들 (최대 5개 표시)
    var startPage = Math.max(1, currentPage - 2);
    var endPage = Math.min(totalPages, startPage + 4);
    if (endPage - startPage < 4) {
        startPage = Math.max(1, endPage - 4);
    }
    for (var i = startPage; i <= endPage; i++) {
        var isActive = i === currentPage;
        if (isActive) {
            // 활성 페이지는 원형 SVG로 표시
            html += '<div style="position: relative; display: flex; align-items: center; justify-content: center; margin: 0 2px;">' +
                   '<svg width="36" height="36" viewBox="0 0 52 52" fill="none" xmlns="http://www.w3.org/2000/svg">' +
                   '<circle cx="26" cy="26" r="16" fill="#FF7272" stroke="#FF7272" stroke-width="2"/>' +
                   '<text x="26" y="31" text-anchor="middle" fill="white" font-size="13" font-weight="600">' + i + '</text>' +
                   '</svg></div>';
        } else {
            html += '<button class="pagination-number" onclick="goToLikePage(' + i + ')">' + i + '</button>';
        }
    }
    // 다음 버튼 SVG
    var nextDisabled = currentPage >= totalPages;
    html += '<button class="pagination-btn" onclick="goToLikePage(' + (currentPage + 1) + ')" ' +
           (nextDisabled ? 'disabled style="opacity: 0.3;"' : '') + '>' +
           '<svg width="20" height="16" viewBox="0 0 31 24" fill="none" xmlns="http://www.w3.org/2000/svg">' +
           '<path d="M12 6L18 12L12 18" stroke="' + (nextDisabled ? '#ccc' : '#FF7272') + '" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>' +
           '</svg></button>';
    html += '</div>';
    return html;
}

// 좋아요 페이지 이동
function goToLikePage(page) {
    if (page < 1 || page > likeTotalPages || page === likeCurrentPage) return;
    loadLikeList(page);
}

/* ==== 게시글 좋아요 기능 ==== */
// 게시글 좋아요 토글
function togglePostLike() {
    var targetKey = 'post_' + ROOM_BOARD_ID;
    // 중복 요청 체크
    if (likeRequestTracker.isProcessing(targetKey)) {
        console.log('좋아요 처리 중입니다...');
        return;
    }
    // 쿨다운 체크
    if (!likeRequestTracker.canRequest(targetKey)) {
        console.log('잠시 후 다시 시도해주세요...');
        return;
    }
    // 요청 시작 표시
    likeRequestTracker.startProcessing(targetKey);
    // UI 즉시 업데이트 (낙관적 업데이트)
    var postLikeBtn = jQuery('#postLikeBtn');
    var currentLiked = isPostLiked;
    var currentCount = parseInt(jQuery('#likeTotalCount').text()) || 0;
    // 미리 UI 변경
    isPostLiked = !currentLiked;
    updatePostLikeUI();
    jQuery('#likeTotalCount').text(currentCount + (isPostLiked ? 1 : -1));
    // 버튼 비활성화
    postLikeBtn.prop('disabled', true).css('opacity', '0.7');
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/like/action.ajax',
        type: 'POST',
        dataType: 'json',
        data: {
            targetType: 'ROOM_BOARD',
            targetId: ROOM_BOARD_ID
        },
        success: function(response) {
            console.log('게시글 좋아요 응답:', response);
            if (response.success) {
                // 서버 응답에 따라 UI 재조정
                isPostLiked = response.isLiked;
                updatePostLikeUI();
                jQuery('#likeTotalCount').text(response.likeCount);
                // 게시글 상세 페이지의 좋아요 개수도 업데이트
                if (typeof window.updatePostLikeCount === 'function') {
                    window.updatePostLikeCount(response.likeCount, response.isLiked);
                }
                // 좋아요 탭이 활성화되어 있으면 목록도 새로고침
                if (currentTab === 'like') {
                    loadLikeList();
                }
                console.log('게시글 좋아요 ' + response.action + '! 총 ' + response.likeCount + '개');
            } else {
                // 실패 시 UI 되돌리기
                isPostLiked = currentLiked;
                updatePostLikeUI();
                jQuery('#likeTotalCount').text(currentCount);
                alert(response.message || '좋아요 처리에 실패했습니다.');
            }
        },
        error: function(xhr, status, error) {
            console.error('게시글 좋아요 처리 중 오류:', error);
            console.error('응답:', xhr.responseText);
            // 에러 시 UI 되돌리기
            isPostLiked = currentLiked;
            updatePostLikeUI();
            jQuery('#likeTotalCount').text(currentCount);
            alert('좋아요 처리에 실패했습니다.');
        },
        complete: function() {
            // 요청 완료 - 상태 복원
            likeRequestTracker.endProcessing(targetKey);
            postLikeBtn.prop('disabled', false).css('opacity', '1');
        }
    });
}


//초기 좋아요 개수 로드
function loadInitialLikeCount() {
 jQuery.ajax({
     url: '${pageContext.request.contextPath}/like/count.ajax',
     type: 'GET',
     dataType: 'json',
     data: {
         targetType: 'ROOM_BOARD',
         targetId: ROOM_BOARD_ID
     },
     success: function(response) {
         if (response.success) {
             jQuery('#likeTotalCount').text(response.likeCount);
         }
     },
     error: function(xhr, status, error) {
         console.error('좋아요 개수 로드 에러:', error);
     }
 });
}

// 게시글 좋아요 개수 업데이트 함수 (detailRoomBoard.jsp에서 호출)
window.updateReplyLikeCount = function(likeCount) {
    jQuery('#likeTotalCount').text(likeCount);
    // 좋아요 탭이 활성화되어 있으면 목록도 새로고침
    if (currentTab === 'like') {
        loadLikeList();
    }
};

// 게시글 좋아요 상태 로드
function loadPostLikeStatus() {
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/like/count.ajax',
        type: 'GET',
        dataType: 'json',
        data: {
            targetType: 'ROOM_BOARD',
            targetId: ROOM_BOARD_ID
        },
        success: function(response) {
            console.log('게시글 좋아요 상태 응답:', response);
            if (response.success) {
                isPostLiked = response.isLiked;
                updatePostLikeUI();
            }
        },
        error: function(xhr, status, error) {
            console.error('게시글 좋아요 상태 로드 에러:', error);
        }
    });
}

// 게시글 좋아요 UI 업데이트
function updatePostLikeUI() {
    var postLikeBtn = jQuery('#postLikeBtn');
    var svg = postLikeBtn.find('svg');
    
    if (isPostLiked) {
        postLikeBtn.addClass('liked');
        svg.attr('fill', '#ff5a5f');
        svg.attr('stroke', '#ff5a5f');
    } else {
        postLikeBtn.removeClass('liked');
        svg.attr('fill', 'none');
        svg.attr('stroke', 'currentColor');
    }
}

</script>