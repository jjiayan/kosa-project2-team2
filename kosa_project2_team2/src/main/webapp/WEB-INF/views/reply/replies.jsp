<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<style>
/* ===== 댓글 영역 스타일 ===== */
.reply-container { 
    max-width: 800px;
    margin: 40px auto 0;
    padding: 0;
    background: white; 
    border-radius: 20px;
    box-shadow: 
        0 10px 30px rgba(0, 0, 0, 0.1),
        0 1px 8px rgba(0, 0, 0, 0.06);
    overflow: hidden;
}

.reply-header { 
    display: flex; 
    justify-content: space-between; 
    align-items: center;
    padding: 20px 24px 16px; 
    border-bottom: 1px solid #f0f0f0;
}

.reply-stats {
    display: flex;
    gap: 20px;
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
    font-size: 16px;
}

.reply-sort { 
    display: flex;
    align-items: center;
    gap: 4px;
}

.sort-btn { 
    padding: 6px 14px; 
    border: none; 
    background: white; 
    cursor: pointer; 
    font-size: 13px;
    color: #999;
    font-weight: 500;
    border-radius: 4px;
    transition: all 0.2s;
}

.sort-btn:hover {
    background: #f8f8f8;
}

.sort-btn.active { 
    background: white; 
    color: #333;
    font-weight: 700;
}

#replyList {
    padding: 0;
    background: white;
}

/* 댓글 작성 폼 */
.reply-write-form { 
    padding: 20px 24px;
    background: white;
    border-top: 1px solid #f0f0f0;
}

.write-form-header {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 12px;
}

.write-form-header .profile-img {
    width: 28px;
    height: 28px;
}

.write-form-header .author-name {
    font-weight: 700;
    font-size: 13px;
    color: #333;
}

.attached-images {
    display: none;
    gap: 8px;
    margin-bottom: 12px;
    flex-wrap: wrap;
}

.attached-image {
    position: relative;
    width: 70px;
    height: 70px;
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
    width: 18px;
    height: 18px;
    cursor: pointer;
    font-size: 11px;
    line-height: 1;
    padding: 0;
}

#replyContent, .reply-textarea { 
    width: 100%; 
    min-height: 48px; 
    padding: 12px 16px; 
    border: 1px solid #e8e8e8; 
    border-radius: 8px; 
    resize: none; 
    font-size: 14px;
    line-height: 1.5;
    font-family: inherit;
    background: #fafafa;
}

#replyContent:focus, .reply-textarea:focus {
    outline: none;
    border-color: #d0d0d0;
    background: white;
}

#replyContent::placeholder {
    color: #bbb;
}

.reply-write-actions { 
    display: flex; 
    justify-content: space-between; 
    align-items: center;
    margin-top: 12px; 
}

.write-tools {
    display: flex;
    gap: 8px;
    align-items: center;
}

.tool-btn {
    background: none;
    border: none;
    cursor: pointer;
    font-size: 20px;
    color: #bbb;
    padding: 4px;
    transition: color 0.2s;
}

.tool-btn:hover {
    color: #888;
}

.image-input {
    display: none;
}

.char-count { 
    color: #bbb; 
    font-size: 11px;
    margin-left: auto;
    margin-right: 12px;
}

.btn-submit { 
    padding: 8px 20px; 
    background: #ff5a5f; 
    color: white; 
    border: none; 
    border-radius: 6px; 
    cursor: pointer; 
    font-size: 13px;
    font-weight: 600;
    transition: background 0.2s;
}

.btn-submit:hover {
    background: #ff3d42;
}

.btn-submit:disabled {
    background: #e0e0e0;
    cursor: not-allowed;
}

.btn-cancel { 
    padding: 8px 16px; 
    background: #f0f0f0; 
    color: #666; 
    border: none; 
    border-radius: 6px; 
    cursor: pointer; 
    margin-right: 6px; 
    font-size: 13px;
    font-weight: 500;
    transition: background 0.2s;
}

.btn-cancel:hover {
    background: #e0e0e0;
}

/* 댓글 아이템 */
.reply-item { 
    background: white; 
    padding: 10px 24px 0px 20px;
    border-bottom: 1px solid #f5f5f5;
    transition: background 0.2s;
    position: relative;
}

.reply-item:hover {
    background: #fafafa;
}

.reply-item.child-reply { 
    margin-left: 52px; 
    background: #ffffff; 
    padding-left: 20px;
}

.reply-item-header { 
    display: flex; 
    justify-content: space-between; 
    align-items: flex-start;
    margin-bottom: 10px; 
    position: relative;
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
    flex-shrink: 0;
}

.reply-main-content {
    flex: 1;
    min-width: 0;
}

.author-info {
    display: flex;
    align-items: center;
    gap: 6px;
    margin-bottom: 6px;
}

.author-name { 
    font-weight: 700; 
    font-size: 14px; 
    color: #333;
}

.reply-content { 
    margin: 0px 0 0px; 
    line-height: 1.5; 
    white-space: pre-wrap; 
    word-break: break-word;
    color: #333;
    font-size: 14px;
}

.reply-time { 
    font-size: 12px; 
    color: #aaa; 
    margin-right: 12px;
}

.btn-reply-write { 
    font-size: 12px; 
    color: #aaa; 
    background: none; 
    border: none; 
    cursor: pointer; 
    font-weight: 500;
    padding: 0;
    margin-right: 8px;
    transition: color 0.2s;
}

.btn-reply-write:hover {
    color: #666;
}

/* .btn-like {
    background: none;
    border: none;
    cursor: pointer;
    font-size: 13px;
    color: #ccc;
    padding: 0;
    transition: all 0.2s;
    display: inline-flex;
    align-items: center;
} */

.btn-like {
    background: none;
    border: none;
    cursor: pointer;
    font-size: 13px;
    color: #ccc;
    padding: 0;
    transition: all 0.2s;
    display: inline-flex;
    align-items: center;
}

.btn-like:hover {
    color: #ff5a5f;
}

.btn-like svg {
    transition: all 0.2s;
}

/* 좋아요 카운트 스타일 추가 */
.btn-like .like-count {
    font-size: 12px;
    margin-left: 4px;
    font-weight: 500;
}

.btn-like.liked svg {
    fill: #ff5a5f;
    stroke: #ff5a5f;
}


/* 더보기 메뉴 */
.reply-more-menu {
    position: absolute;
    right: 0;
    top: 0;
}

.btn-more {
    background: none;
    border: none;
    cursor: pointer;
    padding: 4px 8px;
    color: #d0d0d0;
    font-size: 20px;
    line-height: 1;
    border-radius: 4px;
    transition: all 0.2s;
}

.btn-more:hover {
    color: #999;
    background: #f5f5f5;
}

.dropdown-menu {
    display: none;
    position: absolute;
    right: 0;
    top: 100%;
    background: white;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    box-shadow: 0 4px 16px rgba(0,0,0,0.12);
    min-width: 100px;
    z-index: 1000;
    margin-top: 4px;
}

.dropdown-menu.show {
    display: block;
}

.dropdown-item {
    padding: 10px 16px;
    cursor: pointer;
    border: none;
    background: none;
    width: 100%;
    text-align: left;
    font-size: 13px;
    color: #333;
    transition: background 0.2s;
}

.dropdown-item:hover {
    background: #f8f8f8;
}

.dropdown-item:first-child {
    border-radius: 8px 8px 0 0;
}

.dropdown-item:last-child {
    border-radius: 0 0 8px 8px;
}

.dropdown-item.danger {
    color: #ff5a5f;
}

.dropdown-item.danger:hover {
    background: #fff5f5;
}

/* 대댓글 폼 */
.child-reply-form { 
    margin-top: 12px; 
    margin-left: 52px;     /* ✅ 추가: 프로필 이미지 너비만큼 왼쪽 여백 */
    margin-right: 0;       /* ✅ 추가: 오른쪽 여백 제거 */
    padding: 12px; 
    background: #f9f9f9;   /* ✅ 수정: 배경색 살짝 변경 */
    border-radius: 8px; 
    border: 1px solid #e8e8e8;
}

.loading, .empty-state { 
    text-align: center; 
    padding: 60px 20px; 
    color: #aaa; 
    font-size: 13px;
    background: white;
}

.empty-state {
    border-radius: 0;
}
</style>

<!-- 댓글 영역 -->
<div class="reply-container">
    <!-- 댓글 통계 -->
    <div class="reply-header">
        <div class="reply-stats">
            <div class="stat-item">
                <span class="stat-icon">💬</span>
                <span>댓글 <strong id="replyTotalCount">0</strong></span>
            </div>
        </div>
        
        <div class="reply-sort">
            <button class="sort-btn active" data-order="ASC">등록순</button>
            <button class="sort-btn" data-order="DESC">최신순</button>
        </div>
    </div>
    
    <!-- 댓글 목록 -->
    <div id="replyList">
        <div class="loading">댓글을 불러오는 중...</div>
    </div>
    
    <!-- 댓글 작성 폼 -->
    <div class="reply-write-form">
        <div class="write-form-header">
            <c:choose>
                <c:when test="${not empty sessionScope.LOGIN_USER.user_photo}">
                    <img src="${pageContext.request.contextPath}${sessionScope.LOGIN_USER.user_photo}" 
                         alt="프로필" class="profile-img">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/images/default-avatar.png" 
                         alt="프로필" class="profile-img">
                </c:otherwise>
            </c:choose>
            <span class="author-name">
                ${not empty sessionScope.LOGIN_USER ? sessionScope.LOGIN_USER.user_nickname : '방문자'}
            </span>
        </div>
        <div id="attachedImages" class="attached-images"></div>
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
// 게시글 ID (JSP에서 전달받음)
var ROOM_BOARD_ID = ${param.roomBoardId};
var currentOrder = 'ASC';

jQuery(document).ready(function() {
    console.log('댓글 시스템 로드, ROOM_BOARD_ID:', ROOM_BOARD_ID);
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
 * ✅ 댓글 목록 불러오기 - /reply/list.ajax
 */
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
                displayReplyList(response.replies);
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

/**
 * 댓글 목록 표시
 */
function displayReplyList(replies) {
    var replyList = jQuery('#replyList');
    replyList.empty();
    
    if (replies.length === 0) {
        replyList.html('<div class="empty-state">첫 댓글을 작성해보세요!</div>');
        return;
    }
    
    // 재귀 함수로 모든 깊이의 답글 처리
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
    
    var profileImgSrc = reply.userPhoto ? 
        contextPath + reply.userPhoto : 
        contextPath + '/images/default-avatar.png';
    var defaultImgSrc = contextPath + '/images/default-avatar.png';
    var profileImg = '<img src="' + profileImgSrc + '" alt="프로필" class="profile-img" ' +
        'onerror="this.onerror=null; this.src=\'' + defaultImgSrc + '\';">';
    
    // 삭제된 댓글 처리
    if (reply.status === 'DELETED' && reply.parentReplyId == null) {
        return '<div class="reply-item ' + childClass + '" data-reply-id="' + reply.replyId + '">' +
            '<div class="reply-item-header">' +
            '<div class="reply-author">' +
            '<div class="reply-main-content">' +
            '<div class="reply-content" style="color: #999; font-style: italic;">삭제된 댓글입니다.</div>' +
            '</div></div></div></div>';
    } else if (reply.status === 'DELETED' && reply.parentReplyId != null){
        return '';
    } 
    
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
        
    return '<div class="reply-item ' + childClass + '" data-reply-id="' + reply.replyId + '">' +
        '<div class="reply-item-header">' +
        '<div class="reply-author">' +
        profileImg +
        '<div class="reply-main-content">' +
        '<div class="author-info"><span class="author-name">' + escapeHtml(reply.userNickname) + '</span></div>' +
        '<div class="reply-content" data-original="' + escapeHtml(reply.replyContent) + '">' +
        escapeHtml(reply.replyContent) + '</div>' +
        '<span class="reply-time">' + timeText + '</span>' + replyButton + likeButton +
	    '</div></div>' +
	    actionButtons +
	    '</div>' +
	    childForm +
	    '</div>';  
}

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

/**
 * ✅ 댓글 좋아요 토글
 */
 function toggleReplyLike(replyId) {
	    jQuery.ajax({
	        url: '${pageContext.request.contextPath}/like/action.ajax',
	        type: 'POST',
	        dataType: 'json',
	        data: {
	            targetType: 'REPLY',
	            targetId: replyId
	        },
	        success: function(response) {
	            console.log('좋아요 응답:', response);
	            if (response.success) {
	                var likeBtn = jQuery('.btn-like[data-reply-id="' + replyId + '"]');
	                var svg = likeBtn.find('svg');
	                var likeCountSpan = likeBtn.find('.like-count');
	                
	                // 좋아요 상태에 따라 UI 업데이트
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
	                
	                console.log('좋아요 ' + response.action + '! 총 ' + response.likeCount + '개');
	            } else {
	                alert(response.message || '좋아요 처리에 실패했습니다.');
	            }
	        },
	        error: function(xhr, status, error) {
	            console.error('좋아요 처리 중 오류:', error);
	            console.error('응답:', xhr.responseText);
	            alert('좋아요 처리에 실패했습니다.');
	        }
	    });
	}

/**
 * ✅ 댓글 작성 - /reply/write.ajax
 */
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

/**
 * ✅ 대댓글 작성 - /reply/write.ajax
 */
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
 * ✅ 댓글 수정 모드 활성화
 */
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
        '<button class="btn-cancel" onclick="loadReplyList()">취소</button>' +
        '<button class="btn-submit" onclick="updateReply(' + replyId + ')">수정</button></div>'
    );
    jQuery('#editContent' + replyId).on('input', function() {
        jQuery('#editLength' + replyId).text(jQuery(this).val().length);
    });
}

/**
 * ✅ 댓글 수정 - /reply/update.ajax
 */
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
 * ✅ 댓글 삭제 - /reply/delete.ajax
 */
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
</script>