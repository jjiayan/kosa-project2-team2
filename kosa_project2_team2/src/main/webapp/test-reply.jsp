<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>댓글 시스템 완전 테스트 (LIST+COUNT+WRITE+UPDATE+DELETE)</title>
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
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    padding: 20px 25px;
    margin: 20px auto;
    border-radius: 15px;
    text-align: center;
    max-width: 800px;
    box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
}

.test-info h3 {
    margin: 0 0 15px 0;
    color: white;
    font-size: 22px;
    font-weight: 700;
    text-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

.test-info p {
    margin: 10px 0;
    color: rgba(255, 255, 255, 0.95);
    font-size: 14px;
}

.test-input-group {
    display: flex;
    gap: 15px;
    justify-content: center;
    align-items: center;
    margin: 20px 0 15px;
    background: rgba(255, 255, 255, 0.15);
    padding: 15px;
    border-radius: 10px;
}

.test-input-group label {
    font-weight: 600;
    color: white;
}

.test-input-group input {
    width: 100px;
    padding: 8px 12px;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-radius: 8px;
    text-align: center;
    background: rgba(255, 255, 255, 0.9);
    font-weight: 600;
}

.test-input-group input:focus {
    outline: none;
    border-color: white;
    background: white;
}

.test-buttons {
    display: flex;
    gap: 10px;
    justify-content: center;
    margin-top: 15px;
    flex-wrap: wrap;
}

.test-btn {
    padding: 10px 18px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
    transition: all 0.3s ease;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

.test-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 12px rgba(0,0,0,0.15);
}

.test-btn:active {
    transform: translateY(0);
}

.test-btn.primary {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
}

.test-btn.success {
    background: linear-gradient(135deg, #56ab2f 0%, #a8e063 100%);
    color: white;
}

.test-btn.info {
    background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
    color: white;
}

.test-btn.danger {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    color: white;
}

.test-btn.secondary {
    background: linear-gradient(135deg, #868f96 0%, #596164 100%);
    color: white;
}

.test-btn.warning {
    background: linear-gradient(135deg, #FFD89B 0%, #FF9A56 100%);
    color: white;
}

/* 테스트 로그 */
.test-log {
    background: #1e1e1e;
    border: 2px solid #333;
    padding: 15px;
    margin: 20px auto;
    border-radius: 10px;
    max-height: 300px;
    overflow-y: auto;
    font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
    font-size: 12px;
    max-width: 800px;
    box-shadow: inset 0 2px 10px rgba(0,0,0,0.3);
}

.test-log .log-entry {
    padding: 6px 8px;
    margin: 3px 0;
    border-left: 3px solid #4facfe;
    padding-left: 12px;
    color: #e0e0e0;
    line-height: 1.4;
}

.test-log .log-success {
    border-left-color: #56ab2f;
    color: #a8e063;
    background: rgba(86, 171, 47, 0.1);
}

.test-log .log-error {
    border-left-color: #f5576c;
    color: #ff8a9b;
    background: rgba(245, 87, 108, 0.1);
}

.test-log .log-warning {
    border-left-color: #FFD89B;
    color: #FFE4B3;
    background: rgba(255, 216, 155, 0.1);
}

.test-log .log-info {
    border-left-color: #4facfe;
    color: #8dd0ff;
    background: rgba(79, 172, 254, 0.1);
}

/* 댓글 헤더 */
.reply-header { 
    display: flex; 
    justify-content: space-between; 
    align-items: center;
    padding: 20px 24px 16px; 
    border-bottom: 2px solid #f0f0f0;
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
    padding: 8px 16px; 
    border: none; 
    background: white; 
    cursor: pointer; 
    font-size: 13px;
    color: #999;
    font-weight: 500;
    border-radius: 6px;
    transition: all 0.2s;
}

.sort-btn:hover {
    background: #f8f8f8;
}

.sort-btn.active { 
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    font-weight: 700;
}

/* 댓글 목록 */
#replyList {
    padding: 0;
    background: white;
}

.reply-item { 
    background: white; 
    padding: 15px 24px;
    border-bottom: 1px solid #f5f5f5;
    transition: background 0.2s;
    position: relative;
}

.reply-item:hover {
    background: #fafafa;
}

.reply-item.child-reply { 
    margin-left: 52px; 
    background: #fafbfc; 
    padding-left: 20px;
    border-left: 3px solid #e0e0e0;
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
    width: 42px;
    height: 42px;
    border-radius: 50%;
    object-fit: cover;
    flex-shrink: 0;
    border: 2px solid #e0e0e0;
}

.reply-main-content {
    flex: 1;
    min-width: 0;
}

.author-info {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 8px;
}

.author-name { 
    font-weight: 700; 
    font-size: 14px; 
    color: #333;
}

.reply-content { 
    margin: 0;
    line-height: 1.6; 
    white-space: pre-wrap; 
    word-break: break-word;
    color: #444;
    font-size: 14px;
}

.reply-time { 
    font-size: 12px; 
    color: #999; 
    margin-right: 8px;
}

/* 더보기 메뉴 */
.reply-more-menu {
    position: absolute;
    right: 10px;
    top: 10px;
}

.btn-more {
    background: none;
    border: none;
    cursor: pointer;
    padding: 6px 10px;
    color: #d0d0d0;
    font-size: 22px;
    line-height: 1;
    border-radius: 6px;
    transition: all 0.2s;
}

.btn-more:hover {
    color: #666;
    background: #f0f0f0;
}

.dropdown-menu {
    display: none;
    position: absolute;
    right: 0;
    top: 100%;
    background: white;
    border: 1px solid #e0e0e0;
    border-radius: 10px;
    box-shadow: 0 8px 20px rgba(0,0,0,0.15);
    min-width: 120px;
    z-index: 1000;
    margin-top: 6px;
    overflow: hidden;
}

.dropdown-menu.show {
    display: block;
    animation: dropdownFadeIn 0.2s ease;
}

@keyframes dropdownFadeIn {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.dropdown-item {
    padding: 12px 18px;
    cursor: pointer;
    border: none;
    background: none;
    width: 100%;
    text-align: left;
    font-size: 13px;
    color: #333;
    transition: background 0.2s;
    font-weight: 500;
}

.dropdown-item:hover {
    background: #f8f8f8;
}

.dropdown-item.danger {
    color: #f5576c;
}

.dropdown-item.danger:hover {
    background: #fff0f2;
}

/* 수정 모드 */
.reply-edit-form {
    margin-top: 10px;
}

.reply-textarea {
    width: 100%;
    min-height: 80px;
    padding: 12px;
    border: 2px solid #4facfe;
    border-radius: 8px;
    font-size: 14px;
    font-family: inherit;
    resize: vertical;
}

.reply-textarea:focus {
    outline: none;
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(79, 172, 254, 0.1);
}

.edit-actions {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
    margin-top: 10px;
}

.btn-cancel-edit {
    padding: 8px 16px;
    background: #868f96;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
}

.btn-cancel-edit:hover {
    background: #6c757d;
}

.btn-save-edit {
    padding: 8px 16px;
    background: #4facfe;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
}

.btn-save-edit:hover {
    background: #667eea;
}

.loading, .empty-state { 
    text-align: center; 
    padding: 80px 20px; 
    color: #aaa; 
    font-size: 14px;
    background: white;
}

/* 댓글 작성 폼 */
.reply-write-form { 
    padding: 24px;
    background: #fafbfc;
    border-top: 2px solid #f0f0f0;
}

.write-form-header {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 14px;
}

.write-form-header .profile-img {
    width: 32px;
    height: 32px;
}

.write-form-header .author-name {
    font-weight: 700;
    font-size: 14px;
    color: #333;
}

#replyContent { 
    width: 100%; 
    min-height: 90px; 
    padding: 14px 16px; 
    border: 2px solid #e8e8e8; 
    border-radius: 10px; 
    resize: vertical; 
    font-size: 14px;
    line-height: 1.6;
    font-family: inherit;
    background: white;
}

#replyContent:focus {
    outline: none;
    border-color: #56ab2f;
    box-shadow: 0 0 0 3px rgba(86, 171, 47, 0.1);
}

#replyContent::placeholder {
    color: #bbb;
}

.reply-write-actions { 
    display: flex; 
    justify-content: space-between; 
    align-items: center;
    margin-top: 14px; 
}

.char-count { 
    color: #999; 
    font-size: 12px;
    margin-left: auto;
    margin-right: 14px;
    font-weight: 500;
}

.btn-submit { 
    padding: 12px 28px; 
    background: linear-gradient(135deg, #56ab2f 0%, #a8e063 100%);
    color: white; 
    border: none; 
    border-radius: 8px; 
    cursor: pointer; 
    font-size: 14px;
    font-weight: 700;
    transition: all 0.3s;
    box-shadow: 0 4px 10px rgba(86, 171, 47, 0.3);
}

.btn-submit:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 15px rgba(86, 171, 47, 0.4);
}

.btn-submit:disabled {
    background: #e0e0e0;
    cursor: not-allowed;
    transform: none;
    box-shadow: none;
}

/* 상태 표시 */
.status-badge {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 12px;
    font-size: 11px;
    font-weight: 700;
    margin-left: 6px;
}

.status-badge.enabled {
    background: linear-gradient(135deg, #56ab2f 0%, #a8e063 100%);
    color: white;
}

.status-badge.disabled {
    background: #e0e0e0;
    color: #999;
}
</style>
</head>
<body>
    <!-- 테스트 정보 패널 -->
    <div class="test-info">
        <h3>🧪 댓글 시스템 완전 테스트</h3>
        <p>
            <strong>활성화된 기능:</strong> 
            <span class="status-badge enabled">LIST</span>
            <span class="status-badge enabled">COUNT</span>
            <span class="status-badge enabled">WRITE</span>
            <span class="status-badge enabled">UPDATE</span>
            <span class="status-badge enabled">DELETE</span>
        </p>
        <div class="test-input-group">
            <label>📌 게시글 ID:</label>
            <input type="number" id="testRoomBoardId" value="1">
            <label>👤 사용자 ID:</label>
            <input type="number" id="testUserId" value="70" placeholder="필수!">
        </div>
        <p style="color: rgba(255,255,255,0.9); font-size: 13px; margin: 10px 0 0 0;">
            ✅ 현재: 게시글 1, 사용자 70 (김가네)
        </p>
        <div class="test-buttons">
            <button class="test-btn primary" onclick="testReloadAll()">🔄 새로고침</button>
            <button class="test-btn secondary" onclick="testCountOnly()">📊 카운트</button>
            <button class="test-btn success" onclick="testQuickWrite()">✏️ 빠른 작성</button>
            <button class="test-btn info" onclick="testEditMode()">🔧 수정 안내</button>
            <button class="test-btn danger" onclick="testDeleteMode()">🗑️ 삭제 안내</button>
            <button class="test-btn warning" onclick="clearTestLog()">🧹 로그 초기화</button>
        </div>
    </div>

    <!-- 테스트 로그 -->
    <div class="test-log" id="testLog">
        <div class="log-entry">✅ 테스트 로그 준비 완료...</div>
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
                    ${not empty sessionScope.LOGIN_USER ? sessionScope.LOGIN_USER.user_nickname : '김가네 (테스트)'}
                </span>
            </div>
            <textarea id="replyContent" placeholder="댓글을 입력하세요..." maxlength="3000"></textarea>
            <div class="reply-write-actions">
                <span class="char-count"><span id="currentLength">0</span> / 3000</span>
                <button class="btn-submit" onclick="writeReply()">✅ 댓글 작성</button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        var ROOM_BOARD_ID = 11;
        var currentOrder = 'ASC';

        jQuery(document).ready(function() {
            ROOM_BOARD_ID = parseInt(jQuery('#testRoomBoardId').val());
            
            addTestLog('✅ 테스트 시스템 초기화 완료', 'success');
            addTestLog('📍 게시글 ID: ' + ROOM_BOARD_ID);
            addTestLog('👤 사용자 ID: ' + jQuery('#testUserId').val(), 'info');
            addTestLog('🎯 전체 기능: LIST, COUNT, WRITE, UPDATE, DELETE', 'info');
            
            loadReplyList();
            
            jQuery('#replyContent').on('input', function() {
                jQuery('#currentLength').text(jQuery(this).val().length);
            });
            
            jQuery('.sort-btn').on('click', function() {
                jQuery('.sort-btn').removeClass('active');
                jQuery(this).addClass('active');
                currentOrder = jQuery(this).data('order');
                addTestLog('🔄 정렬 변경: ' + currentOrder, 'info');
                loadReplyList();
            });
            
            jQuery('#testRoomBoardId').on('change', function() {
                ROOM_BOARD_ID = parseInt(jQuery(this).val());
                addTestLog('📌 게시글 ID 변경: ' + ROOM_BOARD_ID, 'warning');
                testReloadAll();
            });
            
            // ✅ 사용자 ID 변경 감지
            jQuery('#testUserId').on('change', function() {
                var userId = jQuery(this).val();
                addTestLog('👤 사용자 ID 변경: ' + userId, 'warning');
                testReloadAll();
            });
        });

        function addTestLog(message, type) {
            var logClass = type === 'success' ? 'log-success' : 
                          (type === 'error' ? 'log-error' : 
                          (type === 'warning' ? 'log-warning' : 
                          (type === 'info' ? 'log-info' : '')));
            var timestamp = new Date().toLocaleTimeString();
            var logEntry = '<div class="log-entry ' + logClass + '">[' + timestamp + '] ' + message + '</div>';
            jQuery('#testLog').append(logEntry);
            
            var logDiv = document.getElementById('testLog');
            logDiv.scrollTop = logDiv.scrollHeight;
        }

        function clearTestLog() {
            jQuery('#testLog').html('<div class="log-entry">🧹 로그 초기화됨</div>');
            addTestLog('테스트 로그가 초기화되었습니다');
        }

        function testReloadAll() {
            addTestLog('=== 🔄 전체 새로고침 시작 ===', 'warning');
            loadReplyList();
        }

        function testCountOnly() {
            addTestLog('=== 📊 댓글 수 조회 테스트 ===', 'warning');
            
            jQuery.ajax({
                url: '${pageContext.request.contextPath}/reply/count.ajax',
                type: 'GET',
                dataType: 'json',
                data: {
                    roomBoardId: ROOM_BOARD_ID
                },
                beforeSend: function() {
                    addTestLog('📡 URL: /reply/count.ajax');
                    addTestLog('📤 roomBoardId: ' + ROOM_BOARD_ID);
                },
                success: function(response) {
                    addTestLog('✅ 조회 성공!', 'success');
                    
                    if (response.success) {
                        jQuery('#replyTotalCount').text(response.count);
                        addTestLog('📊 댓글 수: ' + response.count + '개', 'success');
                    } else {
                        addTestLog('❌ ' + response.message, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    addTestLog('❌ Ajax 에러!', 'error');
                }
            });
        }

        function testQuickWrite() {
            var testTexts = [
                '테스트 댓글입니다.',
                '댓글 작성 테스트 중!',
                'LIST+COUNT+WRITE+UPDATE+DELETE 완전 테스트 ✅',
                '자동 생성 테스트 댓글',
                '모든 기능 정상 작동 확인'
            ];
            
            var randomText = testTexts[Math.floor(Math.random() * testTexts.length)];
            var timestamp = new Date().toLocaleTimeString();
            var fullText = randomText + ' (' + timestamp + ')';
            
            jQuery('#replyContent').val(fullText);
            jQuery('#currentLength').text(fullText.length);
            
            addTestLog('⚡ 빠른 작성: ' + fullText, 'warning');
            
            setTimeout(function() {
                writeReply();
            }, 500);
        }

        function testEditMode() {
            alert('✅ 수정 모드 사용법\n\n1. 내 댓글의 "⋮" 버튼 클릭\n2. "수정" 선택\n3. 내용 변경 후 "수정 완료"');
        }

        function testDeleteMode() {
            alert('✅ 삭제 모드 사용법\n\n1. 내 댓글의 "⋮" 버튼 클릭\n2. "삭제" 선택\n3. 확인 버튼 클릭');
        }

        /**
         * ✅ 댓글 목록 조회 (userId 파라미터 포함)
         */
        function loadReplyList() {
            addTestLog('--- 📋 댓글 목록 조회 ---');
            
            var testUserId = jQuery('#testUserId').val();
            
            jQuery.ajax({
                url: '${pageContext.request.contextPath}/reply/list.ajax',
                type: 'GET',
                dataType: 'json',
                data: {
                    roomBoardId: ROOM_BOARD_ID,
                    orderBy: currentOrder,
                    userId: testUserId  // ✅ 추가
                },
                beforeSend: function() {
                    addTestLog('📡 URL: /reply/list.ajax');
                    addTestLog('📤 roomBoardId=' + ROOM_BOARD_ID + ', orderBy=' + currentOrder);
                    if (testUserId) {
                        addTestLog('👤 testUserId=' + testUserId);
                    }
                    jQuery('#replyList').html('<div class="loading">댓글을 불러오는 중...</div>');
                },
                success: function(response) {
                    addTestLog('✅ 목록 조회 성공!', 'success');
                    
                    if (response.success) {
                        addTestLog('📊 총 ' + response.totalCount + '개 댓글', 'success');
                        
                        // ✅ 클라이언트 측에서 owner 재계산
                        if (testUserId) {
                            var uid = parseInt(testUserId);
                            recalculateOwnership(response.replies, uid);
                        }
                        
                        displayReplyList(response.replies);
                        jQuery('#replyTotalCount').text(response.totalCount);
                    } else {
                        addTestLog('❌ ' + response.message, 'error');
                        jQuery('#replyList').html('<div class="empty-state">' + response.message + '</div>');
                    }
                },
                error: function(xhr, status, error) {
                    addTestLog('❌ Ajax 에러!', 'error');
                    jQuery('#replyList').html('<div class="empty-state">서버 오류: ' + error + '</div>');
                }
            });
        }

        /**
         * ✅ 클라이언트 측에서 owner 재계산
         */
        function recalculateOwnership(replies, testUserId) {
            if (!replies || replies.length === 0) return;
            
            var ownerCount = 0;
            
            for (var i = 0; i < replies.length; i++) {
                var reply = replies[i];
                
                // owner 재계산
                if (reply.userId === testUserId) {
                    reply.owner = true;
                    ownerCount++;
                } else {
                    reply.owner = false;
                }
                
                // 대댓글도 재귀적으로 처리
                if (reply.replies && reply.replies.length > 0) {
                    recalculateOwnership(reply.replies, testUserId);
                }
            }
            
            if (ownerCount > 0) {
                addTestLog('✓ 내 댓글 ' + ownerCount + '개 인식됨', 'success');
            }
        }

        function writeReply() {
            var content = jQuery('#replyContent').val().trim();
            
            if (!content) {
                alert('댓글 내용을 입력해주세요.');
                return;
            }
            
            var testUserId = jQuery('#testUserId').val();
            
            if (!testUserId || testUserId.trim() === '') {
                alert('⚠️ 사용자 ID를 입력해주세요!');
                return;
            }
            
            addTestLog('=== ✏️ 댓글 작성 시작 ===', 'warning');
            
            jQuery.ajax({
                url: '${pageContext.request.contextPath}/reply/write.ajax',
                type: 'POST',
                dataType: 'json',
                data: {
                    roomBoardId: ROOM_BOARD_ID,
                    replyContent: content,
                    userId: testUserId
                },
                beforeSend: function() {
                    addTestLog('📡 URL: /reply/write.ajax');
                    addTestLog('👤 userId: ' + testUserId);
                    
                    jQuery('.btn-submit').prop('disabled', true).text('작성 중...');
                },
                success: function(response) {
                    addTestLog('✅ 작성 완료!', 'success');
                    
                    if (response.success) {
                        addTestLog('✅ ' + response.message, 'success');
                        
                        jQuery('#replyContent').val('');
                        jQuery('#currentLength').text('0');
                        
                        loadReplyList();
                        alert('✅ ' + response.message);
                    } else {
                        addTestLog('❌ ' + response.message, 'error');
                        alert('❌ ' + response.message);
                    }
                },
                error: function(xhr, status, error) {
                    addTestLog('❌ Ajax 에러!', 'error');
                    alert('서버 오류: ' + error);
                },
                complete: function() {
                    jQuery('.btn-submit').prop('disabled', false).text('✅ 댓글 작성');
                }
            });
        }

        function editReply(replyId, originalContent) {
            addTestLog('=== 🔧 수정 모드 활성화 ===', 'info');
            addTestLog('📌 댓글 ID: ' + replyId, 'info');
            
            var contentDiv = jQuery('.reply-item[data-reply-id="' + replyId + '"] .reply-content');
            
            var editForm = '<div class="reply-edit-form">' +
                '<textarea class="reply-textarea" id="editContent' + replyId + '">' + escapeHtml(originalContent) + '</textarea>' +
                '<div class="edit-actions">' +
                '<button class="btn-cancel-edit" onclick="cancelEdit()">취소</button>' +
                '<button class="btn-save-edit" onclick="updateReply(' + replyId + ')">수정 완료</button>' +
                '</div></div>';
            
            contentDiv.html(editForm);
            jQuery('#editContent' + replyId).focus();
            jQuery('.dropdown-menu').removeClass('show');
            
            addTestLog('✅ 수정 폼 표시', 'info');
        }

        function cancelEdit() {
            addTestLog('❌ 수정 취소', 'warning');
            loadReplyList();
        }

        function updateReply(replyId) {
            var content = jQuery('#editContent' + replyId).val().trim();
            
            if (!content) {
                alert('댓글 내용을 입력해주세요.');
                return;
            }
            
            var testUserId = jQuery('#testUserId').val();
            
            if (!testUserId || testUserId.trim() === '') {
                alert('⚠️ 사용자 ID를 입력해주세요!');
                return;
            }
            
            addTestLog('=== 🔧 댓글 수정 시작 ===', 'info');
            
            jQuery.ajax({
                url: '${pageContext.request.contextPath}/reply/update.ajax',
                type: 'POST',
                dataType: 'json',
                data: {
                    replyId: replyId,
                    replyContent: content,
                    userId: testUserId
                },
                beforeSend: function() {
                    addTestLog('📡 URL: /reply/update.ajax');
                    addTestLog('👤 userId: ' + testUserId);
                    
                    jQuery('.btn-save-edit').prop('disabled', true).text('처리 중...');
                },
                success: function(response) {
                    addTestLog('✅ 수정 완료!', 'success');
                    
                    if (response.success) {
                        addTestLog('✅ ' + response.message, 'success');
                        loadReplyList();
                        alert('✅ ' + response.message);
                    } else {
                        addTestLog('❌ ' + response.message, 'error');
                        alert('❌ ' + response.message);
                        jQuery('.btn-save-edit').prop('disabled', false).text('수정 완료');
                    }
                },
                error: function(xhr, status, error) {
                    addTestLog('❌ Ajax 에러!', 'error');
                    alert('서버 오류: ' + error);
                    jQuery('.btn-save-edit').prop('disabled', false).text('수정 완료');
                }
            });
        }

        function deleteReply(replyId) {
            jQuery('.dropdown-menu').removeClass('show');
            
            var testUserId = jQuery('#testUserId').val();
            
            if (!testUserId || testUserId.trim() === '') {
                alert('⚠️ 사용자 ID를 입력해주세요!');
                return;
            }
            
            if (!confirm('댓글을 삭제하시겠습니까?')) {
                return;
            }
            
            addTestLog('=== 🗑️ 댓글 삭제 시작 ===', 'warning');
            
            jQuery.ajax({
                url: '${pageContext.request.contextPath}/reply/delete.ajax',
                type: 'POST',
                dataType: 'json',
                data: {
                    replyId: replyId,
                    userId: testUserId
                },
                beforeSend: function() {
                    addTestLog('📡 URL: /reply/delete.ajax');
                    addTestLog('👤 userId: ' + testUserId);
                },
                success: function(response) {
                    addTestLog('✅ 삭제 완료!', 'success');
                    
                    if (response.success) {
                        addTestLog('✅ ' + response.message, 'success');
                        loadReplyList();
                        alert('✅ ' + response.message);
                    } else {
                        addTestLog('❌ ' + response.message, 'error');
                        alert('❌ ' + response.message);
                    }
                },
                error: function(xhr, status, error) {
                    addTestLog('❌ Ajax 에러!', 'error');
                    alert('서버 오류: ' + error);
                }
            });
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

        function displayReplyList(replies) {
            var replyList = jQuery('#replyList');
            replyList.empty();
            
            if (replies.length === 0) {
                replyList.html('<div class="empty-state">첫 댓글을 작성해보세요! 📝</div>');
                return;
            }
            
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

        function createReplyHtml(reply, isChild) {
            var childClass = isChild ? 'child-reply' : '';
            var contextPath = '${pageContext.request.contextPath}';
            
            var profileImgSrc = reply.userPhoto ? 
                contextPath + reply.userPhoto : 
                contextPath + '/images/default-avatar.png';
            var defaultImgSrc = contextPath + '/images/default-avatar.png';
            var profileImg = '<img src="' + profileImgSrc + '" alt="프로필" class="profile-img" ' +
                'onerror="this.onerror=null; this.src=\'' + defaultImgSrc + '\';">';
            
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
            
            var actionButtons = '';
            if (reply.owner) {
                actionButtons = '<div class="reply-more-menu">' +
                    '<button class="btn-more" onclick="toggleDropdown(event, ' + reply.replyId + ')">⋮</button>' +
                    '<div class="dropdown-menu" id="dropdown' + reply.replyId + '">' +
                    '<button class="dropdown-item" onclick="editReply(' + reply.replyId + ', \'' + 
                    escapeHtml(reply.replyContent).replace(/'/g, "\\'").replace(/\n/g, "\\n") + '\')">수정</button>' +
                    '<button class="dropdown-item danger" onclick="deleteReply(' + reply.replyId + ')">삭제</button>' +
                    '</div></div>';
            } else {
                actionButtons = '<div class="reply-more-menu">' +
                    '<button class="btn-more" onclick="toggleDropdown(event, ' + reply.replyId + ')">⋮</button>' +
                    '<div class="dropdown-menu" id="dropdown' + reply.replyId + '">' +
                    '<button class="dropdown-item danger" onclick="reportReply(' + reply.replyId + ')">신고하기</button>' +
                    '</div></div>';
            }
            
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
                '</div></div>' +
                actionButtons +
                '</div></div>';
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

        jQuery(document).on('click', function(e) {
            if (!jQuery(e.target).closest('.reply-more-menu').length) {
                jQuery('.dropdown-menu').removeClass('show');
            }
        });
    </script>
</body>
</html>