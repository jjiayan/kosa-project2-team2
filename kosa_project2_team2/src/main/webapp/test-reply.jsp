<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 테스트용~ 
    // 게시글 ID 설정 (DB에 실제로 존재하는 ROOM_BOARD_ID)
    Long roomBoardId = 1L;
    
    // 테스트할 사용자 선택 (2: user1, )
    session.setAttribute("userId", 2L);
    
    // 현재 사용자 닉네임 가져오기
    String currentUser = "가연";
    Long userId = (Long) session.getAttribute("userId");
    if (userId != null) {
        switch (userId.intValue()) {
            case 1: currentUser = "재건"; break;
            case 2: currentUser = "가연"; break;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>댓글 시스템 테스트</title>
<style>
    * { 
        box-sizing: border-box; 
        margin: 0;
        padding: 0;
    }
    
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        padding: 20px;
        padding-bottom: 0;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
    }
    
    .main-container {
        max-width: 1000px;
        margin: 0 auto;
        background: white;
        padding: 40px;
        padding-bottom: 0;
        border-radius: 20px;
        box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        margin-bottom: 20px;
    }
    
    .page-header {
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 3px solid #667eea;
    }
    
    .page-header h1 {
        color: #333;
        font-size: 32px;
        margin-bottom: 10px;
    }
    
    .page-header .info {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 15px;
    }
    
    .page-header .info .board-id {
        color: #666;
        font-size: 14px;
    }
    
    .current-user {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 8px 16px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 600;
    }
    
    .current-user::before {
        content: "👤";
        font-size: 16px;
    }
    
    .test-info {
        background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
        border: 2px solid #28a745;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 30px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }
    
    .test-info h3 {
        color: #155724;
        margin-bottom: 15px;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 18px;
    }
    
    .test-info h3::before {
        content: "✅";
    }
    
    /* 댓글 영역 스타일 */
    .reply-container { 
        margin-top: 30px; 
        padding: 0; 
        background: white; 
        border-radius: 0; 
    }
    
    .reply-header { 
        display: flex; 
        justify-content: space-between; 
        align-items: center;
        margin-bottom: 0; 
        padding: 16px 20px; 
        border-bottom: 1px solid #f0f0f0;
        background: white;
    }
    
    .reply-stats {
        display: flex;
        gap: 16px;
        align-items: center;
    }
    
    .stat-item {
        display: flex;
        align-items: center;
        gap: 6px;
        color: #666;
        font-size: 14px;
    }
    
    .stat-icon {
        font-size: 18px;
    }
    
    .reply-sort { 
        display: flex; 
        gap: 0;
        border-bottom: 1px solid #e0e0e0;
    }
    
    .sort-btn { 
        padding: 12px 20px; 
        border: none; 
        background: transparent; 
        cursor: pointer; 
        font-size: 14px;
        color: #999;
        font-weight: 500;
        position: relative;
        transition: all 0.3s;
    }
    
    .sort-btn:hover {
        color: #333;
    }
    
    .sort-btn.active { 
        color: #333; 
        font-weight: 700;
    }
    
    .sort-btn.active::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: #333;
    }
    .reply-write-form { 
        padding: 20px;
        background: white;
        border-top: 8px solid #f5f5f5;
        bottom: 0;
        left: 0;
        right: 0;
        max-width: 1000px;
        margin: 0 auto;
        z-index: 100;
        box-shadow: 0 -2px 10px rgba(0,0,0,0.1);
    }
    
    #replyList {
        padding-bottom: 200px; /* 댓글 입력창 높이만큼 여유 공간 */
    }
    
    .write-form-header {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 12px;
    }
    
    .write-form-header .profile-img {
        width: 32px;
        height: 32px;
    }
    
    .write-form-header .author-name {
        font-weight: 600;
        font-size: 14px;
        color: #333;
    }
    
    #replyContent, .reply-textarea { 
        width: 100%; 
        min-height: 60px; 
        padding: 12px 16px; 
        border: 1px solid #e0e0e0; 
        border-radius: 8px; 
        resize: none; 
        font-size: 14px;
        line-height: 1.5;
        font-family: inherit;
        background: #f9f9f9;
    }
    
    #replyContent:focus, .reply-textarea:focus {
        outline: none;
        border-color: #999;
        background: white;
    }
    
    #replyContent::placeholder {
        color: #ccc;
    }
    
    .reply-write-actions { 
        display: flex; 
        justify-content: space-between; 
        align-items: center;
        margin-top: 12px; 
    }
    
    .write-tools {
        display: flex;
        gap: 12px;
        align-items: center;
    }
    
    .tool-btn {
        background: none;
        border: none;
        cursor: pointer;
        font-size: 20px;
        color: #999;
        padding: 4px;
        transition: color 0.3s;
    }
    
    .tool-btn:hover {
        color: #666;
    }
    
    .image-input {
        display: none;
    }
    
    .attached-images {
        display: none; /* 기본 숨김 */
        gap: 8px;
        margin-top: 12px;
        flex-wrap: wrap;
    }
    
    .attached-image {
        position: relative;
        width: 80px;
        height: 80px;
        border-radius: 8px;
        overflow: hidden;
        border: 1px solid #e0e0e0;
    }
    
    .attached-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    
    .remove-image {
        position: absolute;
        top: 4px;
        right: 4px;
        background: rgba(0,0,0,0.6);
        color: white;
        border: none;
        border-radius: 50%;
        width: 20px;
        height: 20px;
        cursor: pointer;
        font-size: 12px;
        line-height: 1;
        padding: 0;
    }
    
    .char-count { 
        color: #999; 
        font-size: 12px;
        margin-left: auto;
        margin-right: 12px;
    }
    
    .btn-submit { 
        padding: 10px 24px; 
        background: #ff6b6b; 
        color: white; 
        border: none; 
        border-radius: 6px; 
        cursor: pointer; 
        font-size: 14px;
        font-weight: 600;
        transition: background 0.3s;
    }
    
    .btn-submit:hover {
        background: #ff5252;
    }
    
    .btn-submit:disabled {
        background: #ddd;
        cursor: not-allowed;
    }
    
    .btn-cancel { 
        padding: 8px 20px; 
        background: #6c757d; 
        color: white; 
        border: none; 
        border-radius: 4px; 
        cursor: pointer; 
        margin-right: 5px; 
        font-size: 14px;
        font-weight: 500;
        transition: background 0.3s;
    }
    
    .btn-cancel:hover {
        background: #5a6268;
    }
    
    .btn-like {
    background: none;
    border: none;
    cursor: pointer;
    font-size: 13px;
    color: #999;
    padding: 4px 8px;
    transition: all 0.3s;
    display: inline-flex;
    align-items: center;
    gap: 4px;
	}
	
	.btn-like:hover {
	    color: #ff6b6b;
	}
	
	.btn-like.liked {
	    color: #ff6b6b;
	}
	
	.btn-like .heart-icon {
	    font-size: 16px;
	}
    .reply-item { 
        background: white; 
        padding: 20px;
        margin-bottom: 0; 
        border-radius: 0; 
        border: none;
        border-bottom: 1px solid #f0f0f0;
        transition: background 0.3s;
        position: relative;
    }
    
    .reply-item:hover {
        background: #fafafa;
    }
    
    .reply-item.child-reply { 
        margin-left: 60px; 
        background: #fafafa; 
        border-left: 2px solid #e0e0e0;
        padding-left: 20px;
    }
    
    .reply-item-header { 
    display: flex; 
    justify-content: space-between; 
    align-items: flex-start;
    margin-bottom: 8px; 
    position: relative; /* 추가 */
	}
    
    .reply-author { 
        display: flex; 
        align-items: flex-start;
        gap: 12px;
        flex: 1;
    }
    
    .profile-img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
        border: none;
        flex-shrink: 0;
    }
    
    .reply-main-content {
        flex: 1;
        min-width: 0;
    }
    
    .author-info {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 6px;
    }
    
    .author-name { 
        font-weight: 700; 
        font-size: 14px; 
        color: #333;
    }
    
    .reply-time { 
        font-size: 12px; 
        color: #999; 
    }
    
    .reply-actions-menu {
        display: flex;
        gap: 8px;
    }
    
    .btn-more {
    background: none;
    border: none;
    cursor: pointer;
    padding: 4px 8px;
    color: #999;
    font-size: 20px;
    line-height: 1;
    border-radius: 4px;
    transition: all 0.2s;
	}
	
	.btn-more:hover {
	    color: #666;
	    background: #f5f5f5;
	}
    
    .btn-action {
        background: none;
        border: none;
        cursor: pointer;
        padding: 4px 8px;
        color: #666;
        font-size: 13px;
        transition: color 0.3s;
    }
    
    .btn-action:hover {
        color: #333;
        text-decoration: underline;
    }
    
    .reply-content { 
        margin: 12px 0; 
        line-height: 1.6; 
        white-space: pre-wrap; 
        word-break: break-word;
        color: #333;
        font-size: 14px;
    }
    
    /* .reply-footer { 
        margin-top: 10px; 
        padding-top: 10px; 
        border-top: 1px solid #f0f0f0; 
    } */
    
    .btn-reply-write { 
        font-size: 13px; 
        color: #007bff; 
        background: none; 
        border: none; 
        cursor: pointer; 
        font-weight: 500;
        transition: color 0.3s;
    }
    
    .btn-reply-write:hover {
        color: #0056b3;
        text-decoration: underline;
    }
    
    .child-reply-form { 
        margin-top: 15px; 
        padding: 16px; 
        background: white; 
        border-radius: 8px; 
        border: 1px solid #e0e0e0;
    }
    
    .loading, .empty-state { 
        text-align: center; 
        padding: 60px 20px; 
        color: #999; 
        font-size: 14px;
        background: white;
    }
    
    .empty-state {
        border-radius: 0;
        border: none;
        border-bottom: 1px solid #f0f0f0;
    }
    /* 더보기 메뉴 스타일 */
	.reply-more-menu {
	    position: absolute; /* relative에서 absolute로 변경 */
	    right: 0; /* 추가 */
	    top: 10px; /* 추가 */
	    display: inline-block;
	}
	
	.dropdown-menu {
	    display: none;
	    position: absolute;
	    right: 0;
	    top: 100%;
	    background: white;
	    border: 1px solid #e0e0e0;
	    border-radius: 8px;
	    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
	    min-width: 120px;
	    z-index: 1000;
	    margin-top: 4px;
	}
	
	.dropdown-menu.show {
	    display: block;
	}
	
	.dropdown-item {
	    padding: 12px 16px;
	    cursor: pointer;
	    border: none;
	    background: none;
	    width: 100%;
	    text-align: left;
	    font-size: 14px;
	    color: #333;
	    transition: background 0.2s;
	}
	
	.dropdown-item:hover {
	    background: #f5f5f5;
	}
	
	.dropdown-item:first-child {
	    border-radius: 8px 8px 0 0;
	}
	
	.dropdown-item:last-child {
	    border-radius: 0 0 8px 8px;
	}
	
	.dropdown-item.danger {
	    color: #dc3545;
	}
	
	.dropdown-item.danger:hover {
	    background: #fff5f5;
	}
    
</style>
</head>
<body>
    <div class="main-container">
        <div class="page-header">
            <h1>💬 댓글 시스템 테스트</h1>
            <div class="info">
                <div class="board-id">게시글 ID: <%= roomBoardId %></div>
                <div class="current-user">
                    현재 로그인: <%= currentUser %>
                </div>
            </div>
        </div>
        
        <div class="test-info">
            <h3>페이지가 정상적으로 로드되었습니다!</h3>
        </div>
        
        <!-- 댓글 영역 -->
        <div class="reply-container">
            <!-- 좋아요/댓글 통계 -->
            <div class="reply-header">
                <div class="reply-stats">
                    <div class="stat-item">
                        <span class="stat-icon">👍</span>
                        <span>좋아요 <strong>4</strong></span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-icon">💬</span>
                        <span>댓글 <strong id="replyTotalCount">0</strong></span>
                    </div>
                </div>
            </div>
            
            <!-- 정렬 탭 -->
            <div class="reply-sort">
                <button class="sort-btn active" data-order="ASC">등록순</button>
                <button class="sort-btn" data-order="DESC">최신순</button>
            </div>
            
            <!-- 댓글 목록 -->
            <div id="replyList">
                <div class="loading">댓글을 불러오는 중...</div>
            </div>
            
            <!-- 댓글 작성 폼 -->
            <div class="reply-write-form">
                <div class="write-form-header">
                    <img src="${pageContext.request.contextPath}/images/default-avatar.png" alt="프로필" class="profile-img">
                    <span class="author-name"><%= currentUser %></span>
                </div>
                <div id="attachedImages" class="attached-images"></div>
                <textarea id="replyContent" placeholder="댓글을 남겨보세요" maxlength="3000"></textarea>
                <div class="reply-write-actions">
                    <div class="write-tools">
                        <input type="file" id="imageInput" class="image-input" accept="image/*" multiple onchange="handleImageSelect(event)">
                        <button class="tool-btn" title="이미지 첨부" onclick="document.getElementById('imageInput').click()">📷</button>
                        <button class="tool-btn" title="이모티콘">😊</button>
                    </div>
                    <span class="char-count"><span id="currentLength">0</span>/3000</span>
                    <button class="btn-submit" onclick="writeReply()">등록</button>
                </div>
            </div>
        </div>
    </div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
// 게시글 ID
var ROOM_BOARD_ID = <%= roomBoardId %>;
var currentOrder = 'ASC';

jQuery(document).ready(function() {
    console.log('페이지 로드 완료, 댓글 목록 불러오기 시작');
    loadReplyList();
    
    // 글자 수 카운터
    jQuery('#replyContent').on('input', function() {
        jQuery('#currentLength').text(jQuery(this).val().length);
    });
    
    // 정렬 버튼 클릭
    jQuery('.sort-btn').on('click', function() {
        jQuery('.sort-btn').removeClass('active');
        jQuery(this).addClass('active');
        currentOrder = jQuery(this).data('order');
        loadReplyList();
    });
});

/**
 * 댓글 목록 불러오기
 */
function loadReplyList() {
    console.log('loadReplyList 호출됨, ROOM_BOARD_ID:', ROOM_BOARD_ID);
    
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/reply/query',
        type: 'GET',
        dataType: 'json',
        data: {
            action: 'list',
            roomBoardId: ROOM_BOARD_ID,
            orderBy: currentOrder
        },
        success: function(response) {
            console.log('댓글 목록 응답:', response);
            if (response.success) {
                displayReplyList(response.replies);
                jQuery('#replyTotalCount').text(response.totalCount);
            } else {
                alert(response.message);
            }
        },
        error: function(xhr, status, error) {
            console.error('댓글 목록 로드 에러:', error);
            console.error('상태:', status);
            console.error('응답:', xhr.responseText);
            alert('서버 오류가 발생했습니다: ' + error);
        }
    });
}

/**
 * 댓글 목록 표시
 */
/* function displayReplyList(replies) {
    console.log('displayReplyList 호출됨, 댓글 수:', replies.length);
    var replyList = jQuery('#replyList');
    replyList.empty();
    
    if (replies.length === 0) {
        replyList.html('<div class="empty-state">첫 댓글을 작성해보세요!</div>');
        return;
    }
    
    for (var i = 0; i < replies.length; i++) {
        var reply = replies[i];
        replyList.append(createReplyHtml(reply, false));
        
        if (reply.replies && reply.replies.length > 0) {
            for (var j = 0; j < reply.replies.length; j++) {
                replyList.append(createReplyHtml(reply.replies[j], true));
            }
        }
    }
} */
/**
 * 댓글 목록 표시
 */
function displayReplyList(replies) {
    console.log('displayReplyList 호출됨, 댓글 수:', replies.length);
    var replyList = jQuery('#replyList');
    replyList.empty();
    
    if (replies.length === 0) {
        replyList.html('<div class="empty-state">첫 댓글을 작성해보세요!</div>');
        return;
    }
    
    // ✅ 재귀 함수로 모든 깊이의 답글 처리
    function renderReply(reply, isChild) {
        replyList.append(createReplyHtml(reply, isChild));
        
        if (reply.replies && reply.replies.length > 0) {
            for (var j = 0; j < reply.replies.length; j++) {
                renderReply(reply.replies[j], true);
            }
        }
    }
    
    for (var i = 0; i < replies.length; i++) {
        renderReply(replies[i], false);
    }
}
/**
 * 댓글 HTML 생성
 */
function createReplyHtml(reply, isChild) {
    var childClass = isChild ? 'child-reply' : '';
    var contextPath = '${pageContext.request.contextPath}';
    var profileImg = reply.userPhoto ? 
        '<img src="' + contextPath + reply.userPhoto + '" alt="프로필" class="profile-img">' :
        '<img src="' + contextPath + '/images/default-avatar.png" alt="프로필" class="profile-img">';
    
    // 삭제된 댓글 처리
    if (reply.status === 'DELETED' && reply.parentReplyId == null) {
        // 댓글 지워지면 '삭제된 댓글'이라는 메세지 뜸 
    	// var timeText = formatDateTime(reply.replyUpdatedAt || reply.replyCreatedAt);
        
        return '<div class="reply-item ' + childClass + '" data-reply-id="' + reply.replyId + '">' +
            '<div class="reply-item-header">' +
            '<div class="reply-author">' +
            // profileImg +
            '<div class="reply-main-content">' +
            '<div class="author-info">' +
            // '<span class="author-name">' + escapeHtml(reply.userNickname) + '</span>' +
            '</div>' +
            '<div class="reply-content" style="color: #999; font-style: italic;">' +
            '삭제된 댓글입니다.' +
            '</div>' +
            // '<div class="reply-footer">' +
            // '<span class="reply-time">' + timeText + '</span>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
            
    } else if (reply.status === 'DELETED' && reply.parentReplyId != null){
    	// 대댓글 삭제되면 그냥 안보임 
		// var timeText = formatDateTime(reply.replyUpdatedAt || reply.replyCreatedAt);
        
        /* return '<div class="reply-item ' + childClass + '" data-reply-id="' + reply.replyId + '">' +
            '<div class="reply-item-header">' +
            '<div class="reply-author">' +
            profileImg +
            '<div class="reply-main-content">' +
            '<div class="author-info">' +
            '<span class="author-name">' + escapeHtml(reply.userNickname) + '</span>' +
            '</div>' +
            '<div class="reply-content" style="color: #999; font-style: italic;">' +
            '삭제된 댓글입니다.' +
            '</div>' +
            '<div class="reply-footer">' +
            '<span class="reply-time">' + timeText + '</span>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>'; */
		return;
    } 
    
    // 정상 댓글 처리 (기존 코드)
    // 수정/삭제 버튼 (본인 댓글만)
    var actionButtons = '';
    if (reply.owner) {
        // 본인 댓글: 수정/삭제 메뉴
        actionButtons = '<div class="reply-more-menu">' +
            '<button class="btn-more" onclick="toggleDropdown(event, ' + reply.replyId + ')">⋮</button>' +
            '<div class="dropdown-menu" id="dropdown' + reply.replyId + '">' +
            '<button class="dropdown-item" onclick="editReply(' + reply.replyId + ')">수정</button>' +
            '<button class="dropdown-item danger" onclick="deleteReply(' + reply.replyId + ')">삭제</button>' +
            '</div>' +
            '</div>';
    } else {
        // 타인 댓글: 신고하기 메뉴
        actionButtons = '<div class="reply-more-menu">' +
            '<button class="btn-more" onclick="toggleDropdown(event, ' + reply.replyId + ')">⋮</button>' +
            '<div class="dropdown-menu" id="dropdown' + reply.replyId + '">' +
            '<button class="dropdown-item danger" onclick="reportReply(' + reply.replyId + ')">신고하기</button>' +
            '</div>' +
            '</div>';
    }
    
    // 답글쓰기 버튼 (모든 댓글에 표시)
    var replyButton = '<button class="btn-reply-write" onclick="toggleChildReplyForm(' + reply.replyId + ')">답글쓰기</button>';
    
 	// 하트 버튼 - 예쁜 하트 아이콘으로 변경
    var likeButton = '<button class="btn-like" onclick="toggleLike(' + reply.replyId + ')">' +
        '<span class="heart-icon"> ♥ </span>' +
        '</button>';
    
    var childForm = '<div class="child-reply-form" id="childForm' + reply.replyId + '" style="display:none;">' +
        '<textarea class="reply-textarea" id="childContent' + reply.replyId + '" ' +
        'placeholder="답글을 입력하세요..." maxlength="3000"></textarea>' +
        '<div class="reply-write-actions">' +
        '<div class="write-tools"></div>' +
        '<span class="char-count"><span id="childLength' + reply.replyId + '">0</span>/3000</span>' +
        '<button class="btn-cancel" onclick="toggleChildReplyForm(' + reply.replyId + ')">취소</button>' +
        '<button class="btn-submit" onclick="writeChildReply(' + reply.replyId + ')">등록</button>' +
        '</div>' +
        '</div>';
        
    var timeText = '';
    if (reply.replyUpdatedAt && reply.replyUpdatedAt !== reply.replyCreatedAt) {
        timeText = '(수정됨) ' + formatDateTime(reply.replyUpdatedAt);
    } else {
        timeText = formatDateTime(reply.replyCreatedAt);
    }
        
    return '<div class="reply-item ' + childClass + '" data-reply-id="' + reply.replyId + '">' +
	    '<div class="reply-item-header">' +
	    '<div class="reply-author">' +
	    profileImg +
	    '<div class="reply-main-content">' +
	    '<div class="author-info">' +
	    '<span class="author-name">' + escapeHtml(reply.userNickname) + '</span>' +
	    '</div>' +
	    '<div class="reply-content" data-original="' + escapeHtml(reply.replyContent) + '">' +
	    escapeHtml(reply.replyContent) +
	    '</div>' +
	    '<span class="reply-time">' + timeText + '</span>' + '    ' + 
	    replyButton + 
	    likeButton +
	    '</div>' +
	    childForm +
	    '</div>' +
	    '</div>' +
	    actionButtons +  // 여기로 이동 (reply-item-header 내부에서 맨 마지막)
	    '</div>' +
	    '</div>';
	}

/**
 * HTML 이스케이프 처리
 */
function escapeHtml(text) {
    if (!text) return '';
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

/**
 * 날짜 포맷 (2025.10.02 12:30)
 */
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

/**
 * 이미지 선택 처리
 */
var selectedImages = [];

function handleImageSelect(event) {
    var files = event.target.files;
    
    for (var i = 0; i < files.length; i++) {
        if (selectedImages.length >= 5) {
            alert('이미지는 최대 5개까지 첨부할 수 있습니다.');
            break;
        }
        
        var file = files[i];
        if (!file.type.startsWith('image/')) {
            alert('이미지 파일만 첨부할 수 있습니다.');
            continue;
        }
        
        selectedImages.push(file);
    }
    
    displayAttachedImages();
    event.target.value = ''; // input 초기화
}

/**
 * 첨부된 이미지 표시
 */
function displayAttachedImages() {
    var container = jQuery('#attachedImages');
    container.empty();
    
    if (selectedImages.length === 0) {
        container.hide();
        return;
    }
    
    container.css('display', 'flex'); // flex로 표시
    
    for (var i = 0; i < selectedImages.length; i++) {
        (function(index) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var imageHtml = '<div class="attached-image">' +
                    '<img src="' + e.target.result + '" alt="첨부 이미지">' +
                    '<button class="remove-image" onclick="removeImage(' + index + ')">×</button>' +
                    '</div>';
                container.append(imageHtml);
            };
            reader.readAsDataURL(selectedImages[index]);
        })(i);
    }
}

/**
 * 이미지 제거
 */
function removeImage(index) {
    selectedImages.splice(index, 1);
    displayAttachedImages();
}

/**
 * 좋아요 토글
 */
function toggleLike(replyId) {
    console.log('좋아요 토글:', replyId);
    // 좋아요 기능은 추후 구현
    alert('좋아요 기능은 준비 중입니다.');
}

/**
 * 댓글 작성
 */
function writeReply() {
    console.log('writeReply 호출됨');
    var content = jQuery('#replyContent').val().trim();
    
    if (!content) {
        alert('댓글 내용을 입력해주세요.');
        return;
    }
    
    if (selectedImages.length > 0) {
        alert('이미지 첨부 기능은 준비 중입니다.\n텍스트 댓글만 등록됩니다.');
    }
    
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/reply/command',
        type: 'POST',
        dataType: 'json',
        data: {
            action: 'write',
            roomBoardId: ROOM_BOARD_ID,
            replyContent: content
        },
        success: function(response) {
            console.log('댓글 작성 응답:', response);
            if (response.success) {
                jQuery('#replyContent').val('');
                jQuery('#currentLength').text('0');
                selectedImages = [];
                displayAttachedImages();
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

/**
 * 대댓글 폼 토글
 */
function toggleChildReplyForm(parentReplyId) {
    var form = jQuery('#childForm' + parentReplyId);
    form.toggle();
    
    if (form.is(':visible')) {
        // 글자 수 카운터 설정
        jQuery('#childContent' + parentReplyId).off('input').on('input', function() {
            jQuery('#childLength' + parentReplyId).text(jQuery(this).val().length);
        });
    }
}

/**
 * 대댓글 작성
 */
function writeChildReply(parentReplyId) {
    var content = jQuery('#childContent' + parentReplyId).val().trim();
    
    if (!content) {
        alert('답글 내용을 입력해주세요.');
        return;
    }
    
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/reply/command',
        type: 'POST',
        dataType: 'json',
        data: {
            action: 'write',
            roomBoardId: ROOM_BOARD_ID,
            replyContent: content,
            parentReplyId: parentReplyId
        },
        success: function(response) {
            if (response.success) {
                jQuery('#childContent' + parentReplyId).val('');
                toggleChildReplyForm(parentReplyId);
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

/**
 * 댓글 수정
 */
function editReply(replyId) {
	// 드롭다운 닫기
    jQuery('.dropdown-menu').removeClass('show');
	
    var replyItem = jQuery('.reply-item[data-reply-id="' + replyId + '"]');
    var contentDiv = replyItem.find('.reply-content');
    var originalContent = contentDiv.data('original');
    
    contentDiv.html(
        '<textarea class="reply-textarea" id="editContent' + replyId + '" style="margin-top:8px;">' + escapeHtml(originalContent) + '</textarea>' +
        '<div class="reply-write-actions" style="margin-top:12px;">' +
        '<div class="write-tools"></div>' +
        '<span class="char-count"><span id="editLength' + replyId + '">' + originalContent.length + '</span>/3000</span>' +
        '<button class="btn-cancel" onclick="loadReplyList()">취소</button>' +
        '<button class="btn-submit" onclick="updateReply(' + replyId + ')">수정</button>' +
        '</div>'
    );
    
    // 글자 수 카운터
    jQuery('#editContent' + replyId).on('input', function() {
        jQuery('#editLength' + replyId).text(jQuery(this).val().length);
    });
}

/**
 * 댓글 수정 완료
 */
function updateReply(replyId) {
    var content = jQuery('#editContent' + replyId).val().trim();
    
    if (!content) {
        alert('댓글 내용을 입력해주세요.');
        return;
    }
    
    if (confirm('댓글을 수정하시겠습니까?')) {
        jQuery.ajax({
            url: '${pageContext.request.contextPath}/reply/command',
            type: 'POST',
            dataType: 'json',
            data: {
                action: 'update',
                replyId: replyId,
                replyContent: content
            },
            success: function(response) {
                if (response.success) {
                    loadReplyList();
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

/**
 * 댓글 삭제
 */
function deleteReply(replyId) {
	// 드롭다운 닫기
    jQuery('.dropdown-menu').removeClass('show');
	
    if (confirm('댓글을 삭제하시겠습니까?')) {
        jQuery.ajax({
            url: '${pageContext.request.contextPath}/reply/command',
            type: 'POST',
            dataType: 'json',
            data: {
                action: 'delete',
                replyId: replyId
            },
            success: function(response) {
                if (response.success) {
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

/**
 * 드롭다운 메뉴 토글
 */
function toggleDropdown(event, replyId) {
    event.stopPropagation(); // 이벤트 전파 방지
    
    var dropdown = jQuery('#dropdown' + replyId);
    var isVisible = dropdown.hasClass('show');
    
    // 모든 드롭다운 닫기
    jQuery('.dropdown-menu').removeClass('show');
    
    // 클릭한 드롭다운만 토글
    if (!isVisible) {
        dropdown.addClass('show');
    }
}

/**
 * 댓글 신고
 */
function reportReply(replyId) {
    // 드롭다운 닫기
    jQuery('.dropdown-menu').removeClass('show');
    
    if (confirm('이 댓글을 신고하시겠습니까?')) {
        // TODO: 신고 기능 구현
        alert('신고 기능은 준비 중입니다.');
        
        /* 실제 구현 시:
        jQuery.ajax({
            url: '${pageContext.request.contextPath}/reply/report',
            type: 'POST',
            dataType: 'json',
            data: {
                replyId: replyId,
                reason: '신고 사유'
            },
            success: function(response) {
                if (response.success) {
                    alert('신고가 접수되었습니다.');
                } else {
                    alert(response.message);
                }
            },
            error: function(xhr, status, error) {
                console.error('신고 처리 에러:', error);
                alert('서버 오류가 발생했습니다.');
            }
        });
        */
    }
}

// 페이지 어디든 클릭하면 드롭다운 닫기
jQuery(document).on('click', function(e) {
    if (!jQuery(e.target).closest('.reply-more-menu').length) {
        jQuery('.dropdown-menu').removeClass('show');
    }
});

</script>
</body>
</html>