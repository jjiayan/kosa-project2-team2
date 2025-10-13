<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>댓글 시스템 테스트 (List + Count + Write)</title>
<style>
/* 기본 스타일 */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    background: #f5f5f5;
    padding: 20px;
}

.reply-container { 
    max-width: 800px;
    margin: 40px auto 0;
    padding: 0;
    background: white; 
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 1px 8px rgba(0, 0, 0, 0.06);
    overflow: hidden;
}

/* 테스트 정보 패널 */
.test-info {
    background: #fff3cd;
    border: 2px solid #ffc107;
    padding: 15px 20px;
    margin: 20px auto;
    border-radius: 10px;
    text-align: center;
    max-width: 800px;
}

.test-info h3 {
    margin: 0 0 10px 0;
    color: #856404;
    font-size: 18px;
}

.test-info p {
    margin: 5px 0;
    color: #856404;
    font-size: 14px;
}

.test-input-group {
    display: flex;
    gap: 15px;
    justify-content: center;
    align-items: center;
    margin: 15px 0 10px;
}

.test-input-group label {
    font-weight: 600;
    color: #856404;
}

.test-input-group input {
    width: 100px;
    padding: 5px 10px;
    border: 2px solid #ffc107;
    border-radius: 5px;
    text-align: center;
}

.test-buttons {
    display: flex;
    gap: 10px;
    justify-content: center;
    margin-top: 15px;
    flex-wrap: wrap;
}

.test-btn {
    padding: 8px 16px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
    transition: all 0.2s;
}

.test-btn.primary {
    background: #007bff;
    color: white;
}

.test-btn.primary:hover {
    background: #0056b3;
}

.test-btn.success {
    background: #28a745;
    color: white;
}

.test-btn.success:hover {
    background: #218838;
}

.test-btn.secondary {
    background: #6c757d;
    color: white;
}

.test-btn.secondary:hover {
    background: #545b62;
}

.test-btn.warning {
    background: #ffc107;
    color: #212529;
}

.test-btn.warning:hover {
    background: #e0a800;
}

/* 테스트 로그 */
.test-log {
    background: #f8f9fa;
    border: 2px solid #dee2e6;
    padding: 15px;
    margin: 20px auto;
    border-radius: 8px;
    max-height: 250px;
    overflow-y: auto;
    font-family: 'Courier New', monospace;
    font-size: 12px;
    max-width: 800px;
}

.test-log .log-entry {
    padding: 5px;
    margin: 2px 0;
    border-left: 3px solid #007bff;
    padding-left: 10px;
}

.test-log .log-success {
    border-left-color: #28a745;
    color: #155724;
    background: #d4edda;
}

.test-log .log-error {
    border-left-color: #dc3545;
    color: #721c24;
    background: #f8d7da;
}

.test-log .log-warning {
    border-left-color: #ffc107;
    color: #856404;
    background: #fff3cd;
}

/* 댓글 헤더 */
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

/* 댓글 목록 */
#replyList {
    padding: 0;
    background: white;
}

.reply-item { 
    background: white; 
    padding: 10px 24px;
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
    border-left: 2px solid #e0e0e0;
}

.reply-item-header { 
    display: flex; 
    justify-content: space-between; 
    align-items: flex-start;
    margin-bottom: 10px; 
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
    margin: 0;
    line-height: 1.5; 
    white-space: pre-wrap; 
    word-break: break-word;
    color: #333;
    font-size: 14px;
}

.reply-time { 
    font-size: 12px; 
    color: #aaa; 
}

.loading, .empty-state { 
    text-align: center; 
    padding: 60px 20px; 
    color: #aaa; 
    font-size: 13px;
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

#replyContent { 
    width: 100%; 
    min-height: 80px; 
    padding: 12px 16px; 
    border: 2px solid #e8e8e8; 
    border-radius: 8px; 
    resize: vertical; 
    font-size: 14px;
    line-height: 1.5;
    font-family: inherit;
    background: #fafafa;
}

#replyContent:focus {
    outline: none;
    border-color: #28a745;
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

.char-count { 
    color: #bbb; 
    font-size: 11px;
    margin-left: auto;
    margin-right: 12px;
}

.btn-submit { 
    padding: 10px 24px; 
    background: #28a745; 
    color: white; 
    border: none; 
    border-radius: 6px; 
    cursor: pointer; 
    font-size: 14px;
    font-weight: 600;
    transition: background 0.2s;
}

.btn-submit:hover {
    background: #218838;
}

.btn-submit:disabled {
    background: #e0e0e0;
    cursor: not-allowed;
}

/* 상태 표시 */
.status-badge {
    display: inline-block;
    padding: 2px 8px;
    border-radius: 12px;
    font-size: 11px;
    font-weight: 600;
    margin-left: 5px;
}

.status-badge.enabled {
    background: #d4edda;
    color: #155724;
}

.status-badge.disabled {
    background: #f8d7da;
    color: #721c24;
}
</style>
</head>
<body>
    <!-- 테스트 정보 패널 -->
    <div class="test-info">
        <h3>🧪 댓글 시스템 테스트 페이지</h3>
        <p>
            <strong>테스트 기능:</strong> 
            <span class="status-badge enabled">LIST</span>
            <span class="status-badge enabled">COUNT</span>
            <span class="status-badge enabled">WRITE</span>
        </p>
        <div class="test-input-group">
		    <label>게시글 ID:</label>
		    <input type="number" id="testRoomBoardId" value="1">
		    <label style="color: #dc3545;">⚠️ 사용자 ID (필수):</label>
		    <input type="number" id="testUserId" value="" placeholder="예: 1" 
		           style="border-color: #dc3545;">
		</div>
		<p style="color: #dc3545; font-size: 12px; margin: 5px 0 0 0;">
		    ※ 로그인 안 되어 있으면 DB의 실제 USER_ID를 입력하세요 (예: 1, 2, 11 등)
		</p>
        <div class="test-buttons">
            <button class="test-btn primary" onclick="testReloadAll()">🔄 전체 새로고침</button>
            <button class="test-btn secondary" onclick="testCountOnly()">📊 댓글 수 조회</button>
            <button class="test-btn success" onclick="testQuickWrite()">✏️ 빠른 댓글 작성</button>
            <button class="test-btn warning" onclick="clearTestLog()">🗑️ 로그 초기화</button>
        </div>
    </div>

    <!-- 테스트 로그 -->
    <div class="test-log" id="testLog">
        <div class="log-entry">테스트 로그가 여기에 표시됩니다...</div>
    </div>

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
                    ${not empty sessionScope.LOGIN_USER ? sessionScope.LOGIN_USER.user_nickname : '테스트 사용자'}
                </span>
            </div>
            <textarea id="replyContent" placeholder="댓글을 입력하세요 (테스트용)..." maxlength="3000"></textarea>
            <div class="reply-write-actions">
                <span class="char-count"><span id="currentLength">0</span>/3000</span>
                <button class="btn-submit" onclick="writeReply()">✅ 댓글 작성 테스트</button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // 게시글 ID
        var ROOM_BOARD_ID = 1;
        var currentOrder = 'ASC';

        jQuery(document).ready(function() {
            // 입력 필드에서 게시글 ID 가져오기
            ROOM_BOARD_ID = parseInt(jQuery('#testRoomBoardId').val());
            
            addTestLog('✅ 테스트 페이지 로드 완료', 'success');
            addTestLog('게시글 ID: ' + ROOM_BOARD_ID);
            addTestLog('현재 사용자: ' + jQuery('#testUserId').val());
            
            // 초기 댓글 목록 로드
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
                addTestLog('정렬 변경: ' + currentOrder);
                loadReplyList();
            });
            
            // 게시글 ID 입력 필드 변경 감지
            jQuery('#testRoomBoardId').on('change', function() {
                ROOM_BOARD_ID = parseInt(jQuery(this).val());
                addTestLog('게시글 ID 변경: ' + ROOM_BOARD_ID, 'warning');
                testReloadAll();
            });
        });

        /**
         * 테스트 로그 추가
         */
        function addTestLog(message, type) {
            var logClass = type === 'success' ? 'log-success' : 
                          (type === 'error' ? 'log-error' : 
                          (type === 'warning' ? 'log-warning' : ''));
            var timestamp = new Date().toLocaleTimeString();
            var logEntry = '<div class="log-entry ' + logClass + '">[' + timestamp + '] ' + message + '</div>';
            jQuery('#testLog').append(logEntry);
            
            // 자동 스크롤
            var logDiv = document.getElementById('testLog');
            logDiv.scrollTop = logDiv.scrollHeight;
        }

        /**
         * 테스트 로그 초기화
         */
        function clearTestLog() {
            jQuery('#testLog').html('<div class="log-entry">로그 초기화됨</div>');
            addTestLog('테스트 로그가 초기화되었습니다');
        }

        /**
         * 전체 새로고침 테스트
         */
        function testReloadAll() {
            addTestLog('=== 전체 새로고침 테스트 시작 ===', 'warning');
            loadReplyList();
        }

        /**
         * 댓글 수만 조회 테스트
         */
        function testCountOnly() {
            addTestLog('=== 댓글 수 조회 테스트 시작 ===', 'warning');
            
            jQuery.ajax({
                url: '${pageContext.request.contextPath}/reply/count.ajax',
                type: 'GET',
                dataType: 'json',
                data: {
                    roomBoardId: ROOM_BOARD_ID
                },
                beforeSend: function() {
                    addTestLog('📡 요청 URL: /reply/count.ajax');
                    addTestLog('📤 파라미터: roomBoardId=' + ROOM_BOARD_ID);
                },
                success: function(response) {
                    addTestLog('✅ 댓글 수 조회 성공!', 'success');
                    addTestLog('📥 응답: ' + JSON.stringify(response));
                    
                    if (response.success) {
                        jQuery('#replyTotalCount').text(response.count);
                        addTestLog('📊 댓글 수: ' + response.count, 'success');
                    } else {
                        addTestLog('❌ 실패: ' + response.message, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    addTestLog('❌ Ajax 에러!', 'error');
                    addTestLog('상태: ' + status, 'error');
                    addTestLog('에러: ' + error, 'error');
                }
            });
        }

        /**
         * 빠른 댓글 작성 테스트 (자동 텍스트)
         */
        function testQuickWrite() {
            var testTexts = [
                '테스트 댓글입니다.',
                '댓글 작성 기능 테스트 중입니다!',
                '이것은 자동 생성된 테스트 댓글입니다.',
                'ReplyWriteController 테스트 ✅',
                '정상 작동 확인용 댓글'
            ];
            
            var randomText = testTexts[Math.floor(Math.random() * testTexts.length)];
            var timestamp = new Date().toLocaleTimeString();
            var fullText = randomText + ' (' + timestamp + ')';
            
            jQuery('#replyContent').val(fullText);
            jQuery('#currentLength').text(fullText.length);
            
            addTestLog('⚡ 빠른 작성 모드: 자동 텍스트 입력', 'warning');
            addTestLog('📝 내용: ' + fullText);
            
            // 자동으로 작성
            setTimeout(function() {
                writeReply();
            }, 500);
        }

        /**
         * 댓글 목록 불러오기
         */
        function loadReplyList() {
            addTestLog('--- 댓글 목록 조회 시작 ---');
            
            jQuery.ajax({
                url: '${pageContext.request.contextPath}/reply/list.ajax',
                type: 'GET',
                dataType: 'json',
                data: {
                    roomBoardId: ROOM_BOARD_ID,
                    orderBy: currentOrder
                },
                beforeSend: function() {
                    addTestLog('📡 요청 URL: /reply/list.ajax');
                    addTestLog('📤 파라미터: roomBoardId=' + ROOM_BOARD_ID + ', orderBy=' + currentOrder);
                    jQuery('#replyList').html('<div class="loading">댓글을 불러오는 중...</div>');
                },
                success: function(response) {
                    addTestLog('✅ 댓글 목록 조회 성공!', 'success');
                    
                    if (response.success) {
                        addTestLog('📊 총 댓글: ' + response.totalCount + '개', 'success');
                        addTestLog('📥 반환 댓글: ' + response.replies.length + '개', 'success');
                        
                        displayReplyList(response.replies);
                        jQuery('#replyTotalCount').text(response.totalCount);
                    } else {
                        addTestLog('❌ 실패: ' + response.message, 'error');
                        jQuery('#replyList').html('<div class="empty-state">' + response.message + '</div>');
                    }
                },
                error: function(xhr, status, error) {
                    addTestLog('❌ Ajax 에러!', 'error');
                    addTestLog('에러: ' + error, 'error');
                    jQuery('#replyList').html('<div class="empty-state">서버 오류: ' + error + '</div>');
                }
            });
        }

        /**
         * 댓글 작성
         */
        function writeReply() {
            var content = jQuery('#replyContent').val().trim();
            
            if (!content) {
                alert('댓글 내용을 입력해주세요.');
                addTestLog('⚠️ 댓글 내용 없음', 'warning');
                return;
            }
            
         	// ✅ 테스트용 userId 가져오기
            var testUserId = jQuery('#testUserId').val();
            
            if (!testUserId || testUserId.trim() === '' || testUserId === 'null') {
                alert('⚠️ 사용자 ID를 입력해주세요!\n(로그인이 안 되어 있으면 직접 입력 필요)');
                addTestLog('❌ 사용자 ID 없음', 'error');
                return;
            }
            
            addTestLog('=== 댓글 작성 테스트 시작 ===', 'warning');
            
            jQuery.ajax({
                url: '${pageContext.request.contextPath}/reply/write.ajax',
                type: 'POST',
                dataType: 'json',
                data: {
                    roomBoardId: ROOM_BOARD_ID,
                    replyContent: content,
                    userId: testUserId  // ✅ 테스트용 userId 전달
                },
                beforeSend: function() {
                    addTestLog('📡 요청 URL: /reply/write.ajax');
                    addTestLog('📤 파라미터: roomBoardId=' + ROOM_BOARD_ID);
                    addTestLog('👤 테스트 userId: ' + testUserId);  // ✅ 추가
                    addTestLog('📝 댓글 내용: ' + content.substring(0, 50) + (content.length > 50 ? '...' : ''));
                    
                    // 버튼 비활성화
                    jQuery('.btn-submit').prop('disabled', true).text('작성 중...');
                },
                success: function(response) {
                    addTestLog('✅ 댓글 작성 완료!', 'success');
                    addTestLog('📥 응답: ' + JSON.stringify(response));
                    
                    if (response.success) {
                        addTestLog('✅ ' + response.message, 'success');
                        addTestLog('📊 새 댓글 수: ' + response.totalCount, 'success');
                        
                        // 입력창 초기화
                        jQuery('#replyContent').val('');
                        jQuery('#currentLength').text('0');
                        
                        // 목록 새로고침
                        loadReplyList();
                        
                        alert('✅ ' + response.message);
                    } else {
                        addTestLog('❌ 실패: ' + response.message, 'error');
                        alert('❌ ' + response.message);
                    }
                },
                error: function(xhr, status, error) {
                    addTestLog('❌ Ajax 에러!', 'error');
                    addTestLog('상태: ' + status, 'error');
                    addTestLog('에러: ' + error, 'error');
                    addTestLog('응답: ' + xhr.responseText, 'error');
                    
                    alert('서버 오류가 발생했습니다: ' + error);
                },
                complete: function() {
                    // 버튼 활성화
                    jQuery('.btn-submit').prop('disabled', false).text('✅ 댓글 작성 테스트');
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
                addTestLog('댓글 없음 - 빈 상태 표시');
                return;
            }
            
            addTestLog('댓글 렌더링 시작...');
            
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
            
            addTestLog('✅ 댓글 렌더링 완료', 'success');
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
            if (reply.status === 'DELETED') {
                if (reply.parentReplyId == null) {
                    return '<div class="reply-item ' + childClass + '">' +
                        '<div class="reply-content" style="color: #999; font-style: italic;">삭제된 댓글입니다.</div>' +
                        '</div>';
                }
                return '';
            }
            
            var timeText = formatDateTime(reply.replyCreatedAt);
            if (reply.replyUpdatedAt && reply.replyUpdatedAt !== reply.replyCreatedAt) {
                timeText = '(수정됨) ' + formatDateTime(reply.replyUpdatedAt);
            }
            
            var ownerBadge = reply.owner ? 
                ' <span class="status-badge enabled">내 댓글</span>' : '';
            
            return '<div class="reply-item ' + childClass + '" data-reply-id="' + reply.replyId + '">' +
                '<div class="reply-item-header">' +
                '<div class="reply-author">' +
                profileImg +
                '<div class="reply-main-content">' +
                '<div class="author-info">' +
                '<span class="author-name">' + escapeHtml(reply.userNickname) + '</span>' +
                ownerBadge +
                '</div>' +
                '<div class="reply-content">' + escapeHtml(reply.replyContent) + '</div>' +
                '<span class="reply-time">' + timeText + '</span>' +
                '</div></div></div></div>';
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
    </script>
</body>
</html>