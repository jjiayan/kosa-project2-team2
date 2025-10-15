<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>좋아요 시스템 완전 테스트 (COUNT+ACTION+DETAIL)</title>
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

.container {
    max-width: 1200px;
    margin: 0 auto;
}

/* 테스트 정보 패널 */
.test-info {
    background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
    border: none;
    padding: 25px;
    margin: 20px 0;
    border-radius: 15px;
    text-align: center;
    box-shadow: 0 10px 25px rgba(255, 107, 107, 0.3);
}

.test-info h3 {
    margin: 0 0 15px 0;
    color: white;
    font-size: 24px;
    font-weight: 700;
    text-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

.test-input-group {
    display: flex;
    gap: 15px;
    justify-content: center;
    align-items: center;
    margin: 20px 0 15px;
    background: rgba(255, 255, 255, 0.15);
    padding: 20px;
    border-radius: 10px;
    flex-wrap: wrap;
}

.test-input-group label {
    font-weight: 600;
    color: white;
}

.test-input-group input, .test-input-group select {
    padding: 10px 15px;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-radius: 8px;
    text-align: center;
    background: rgba(255, 255, 255, 0.9);
    font-weight: 600;
    font-size: 14px;
}

.test-input-group input {
    width: 120px;
}

.test-input-group select {
    width: 150px;
}

.test-buttons {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 10px;
    margin-top: 20px;
}

.test-btn {
    padding: 12px 20px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-size: 14px;
    font-weight: 600;
    transition: all 0.3s ease;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

.test-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 12px rgba(0,0,0,0.15);
}

.test-btn.primary {
    background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
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

.test-btn.warning {
    background: linear-gradient(135deg, #FFD89B 0%, #FF9A56 100%);
    color: white;
}

/* 컨트롤러 상태 카드 */
.controller-status {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 15px;
    margin: 20px 0;
}

.status-card {
    background: white;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.status-card h4 {
    margin: 0 0 15px 0;
    font-size: 16px;
    color: #333;
    display: flex;
    align-items: center;
    gap: 8px;
}

.status-indicator {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    background: #ddd;
}

.status-indicator.active {
    background: #56ab2f;
    box-shadow: 0 0 8px rgba(86, 171, 47, 0.5);
}

.status-card .info-row {
    display: flex;
    justify-content: space-between;
    padding: 8px 0;
    border-bottom: 1px solid #f0f0f0;
    font-size: 13px;
}

.status-card .info-row:last-child {
    border-bottom: none;
}

.info-label {
    color: #666;
}

.info-value {
    font-weight: 700;
    color: #333;
}

/* 테스트 로그 */
.test-log {
    background: #1e1e1e;
    border: 2px solid #333;
    padding: 15px;
    margin: 20px 0;
    border-radius: 10px;
    max-height: 400px;
    overflow-y: auto;
    font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
    font-size: 12px;
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

/* 좋아요 표시 */
.like-display {
    background: white;
    border-radius: 15px;
    padding: 40px;
    text-align: center;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    margin: 20px 0;
}

.like-icon {
    font-size: 100px;
    cursor: pointer;
    transition: all 0.3s;
    display: inline-block;
}

.like-icon.active {
    color: #ff6b6b;
    animation: heartBeat 0.5s;
}

.like-icon:hover {
    transform: scale(1.1);
}

@keyframes heartBeat {
    0%, 100% { transform: scale(1); }
    25% { transform: scale(1.3); }
    50% { transform: scale(1.1); }
    75% { transform: scale(1.25); }
}

.like-count-display {
    font-size: 36px;
    font-weight: 700;
    color: #333;
    margin-top: 20px;
}

.like-status {
    font-size: 18px;
    color: #666;
    margin-top: 10px;
}

/* 좋아요 상세 */
.like-detail-section {
    background: white;
    border-radius: 15px;
    padding: 30px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    margin: 20px 0;
}

.detail-header {
    font-size: 20px;
    font-weight: 700;
    margin-bottom: 20px;
    color: #333;
}

.like-user-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.like-user-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 15px;
    background: #f9f9f9;
    border-radius: 10px;
    transition: background 0.2s;
}

.like-user-item:hover {
    background: #f0f0f0;
}

.user-avatar {
    width: 45px;
    height: 45px;
    border-radius: 50%;
    background: #ff6b6b;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-weight: 700;
    font-size: 18px;
    overflow: hidden;
}

.user-avatar img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.user-info {
    flex: 1;
}

.user-nickname {
    font-weight: 700;
    color: #333;
    font-size: 15px;
}

.like-time {
    font-size: 13px;
    color: #999;
    margin-top: 2px;
}

.empty-state {
    text-align: center;
    padding: 60px 20px;
    color: #aaa;
    font-size: 14px;
}
</style>
</head>
<body>
    <div class="container">
        <!-- 테스트 정보 패널 -->
        <div class="test-info">
            <h3>🧪 좋아요 시스템 완전 테스트</h3>
            <div class="test-input-group">
                <label>📌 대상 타입:</label>
                <select id="testTargetType">
                    <option value="ROOM">모임방 (ROOM)</option>
                    <option value="ROOM_BOARD" selected>게시글 (ROOM_BOARD)</option>
                    <option value="REPLY">댓글 (REPLY)</option>
                </select>
                <label>🎯 대상 ID:</label>
                <input type="number" id="testTargetId" value="1">
                <label>👤 사용자 ID:</label>
                <input type="number" id="testUserId" value="70">
            </div>
            <div class="test-buttons">
                <button class="test-btn primary" onclick="testAllControllers()">🔄 전체 테스트</button>
                <button class="test-btn success" onclick="testCountController()">📊 COUNT 테스트</button>
                <button class="test-btn info" onclick="testActionController()">❤️ ACTION 테스트</button>
                <button class="test-btn warning" onclick="testDetailController()">📋 DETAIL 테스트</button>
            </div>
        </div>

        <!-- 컨트롤러 상태 -->
        <div class="controller-status">
            <div class="status-card">
                <h4>
                    <span class="status-indicator" id="countStatus"></span>
                    LikeCountController
                </h4>
                <div class="info-row">
                    <span class="info-label">URL</span>
                    <span class="info-value">/like/count.ajax</span>
                </div>
                <div class="info-row">
                    <span class="info-label">마지막 호출</span>
                    <span class="info-value" id="countLastCall">-</span>
                </div>
                <div class="info-row">
                    <span class="info-label">상태</span>
                    <span class="info-value" id="countResult">대기 중</span>
                </div>
            </div>

            <div class="status-card">
                <h4>
                    <span class="status-indicator" id="actionStatus"></span>
                    LikeActionController
                </h4>
                <div class="info-row">
                    <span class="info-label">URL</span>
                    <span class="info-value">/like/action.ajax</span>
                </div>
                <div class="info-row">
                    <span class="info-label">마지막 호출</span>
                    <span class="info-value" id="actionLastCall">-</span>
                </div>
                <div class="info-row">
                    <span class="info-label">상태</span>
                    <span class="info-value" id="actionResult">대기 중</span>
                </div>
            </div>

            <div class="status-card">
                <h4>
                    <span class="status-indicator" id="detailStatus"></span>
                    LikeDetailController
                </h4>
                <div class="info-row">
                    <span class="info-label">URL</span>
                    <span class="info-value">/like/detail.ajax</span>
                </div>
                <div class="info-row">
                    <span class="info-label">마지막 호출</span>
                    <span class="info-value" id="detailLastCall">-</span>
                </div>
                <div class="info-row">
                    <span class="info-label">상태</span>
                    <span class="info-value" id="detailResult">대기 중</span>
                </div>
            </div>
        </div>

        <!-- 테스트 로그 -->
        <div class="test-log" id="testLog">
            <div class="log-entry">✅ 테스트 로그 준비 완료...</div>
        </div>

        <!-- 좋아요 표시 -->
        <div class="like-display">
            <div class="like-icon" id="likeIcon" onclick="testActionController()">
                🤍
            </div>
            <div class="like-count-display">
                좋아요 <strong id="likeCount">0</strong>개
            </div>
            <div class="like-status" id="likeStatus">
                상태: 확인 중...
            </div>
        </div>

        <!-- 좋아요 상세 -->
        <div class="like-detail-section" id="likeDetailSection" style="display: none;">
            <div class="detail-header">
                💖 좋아요를 누른 사용자 (<span id="detailTotalCount">0</span>명)
            </div>
            <div class="like-user-list" id="likeUserList">
                <div class="empty-state">좋아요를 누른 사용자가 없습니다.</div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        var currentTargetType = 'ROOM_BOARD';
        var currentTargetId = 1;
        var currentUserId = 70;

        jQuery(document).ready(function() {
            initTest();
            
            // 입력 값 변경 감지
            jQuery('#testTargetType, #testTargetId, #testUserId').on('change', function() {
                currentTargetType = jQuery('#testTargetType').val();
                currentTargetId = parseInt(jQuery('#testTargetId').val());
                currentUserId = parseInt(jQuery('#testUserId').val());
                
                addTestLog('🔄 설정 변경: ' + currentTargetType + ' ID=' + currentTargetId, 'warning');
            });
        });

        function initTest() {
            currentTargetType = jQuery('#testTargetType').val();
            currentTargetId = parseInt(jQuery('#testTargetId').val());
            currentUserId = parseInt(jQuery('#testUserId').val());
            
            addTestLog('✅ 테스트 시스템 초기화 완료', 'success');
            addTestLog('📌 대상: ' + currentTargetType + ' ID: ' + currentTargetId);
            addTestLog('👤 사용자 ID: ' + currentUserId, 'info');
            addTestLog('🎯 3개 Controller 테스트 준비', 'info');
        }

        /**
         * ✅ 전체 테스트 실행
         */
        function testAllControllers() {
            addTestLog('=== 🔄 전체 Controller 테스트 시작 ===', 'warning');
            testCountController();
            setTimeout(function() {
                if (currentTargetType === 'ROOM_BOARD') {
                    testDetailController();
                }
            }, 1000);
        }

        /**
         * ✅ LikeCountController 테스트
         */
        function testCountController() {
            addTestLog('=== 📊 LikeCountController 테스트 ===', 'warning');
            updateControllerStatus('count', 'testing');
            
            jQuery.ajax({
                url: '${pageContext.request.contextPath}/like/count.ajax',
                type: 'GET',
                dataType: 'json',
                data: {
                    targetType: currentTargetType,
                    targetId: currentTargetId
                },
                beforeSend: function() {
                    addTestLog('📡 URL: /like/count.ajax');
                    addTestLog('📤 Request: targetType=' + currentTargetType + ', targetId=' + currentTargetId);
                },
                success: function(response) {
                    addTestLog('✅ Response 받음', 'success');
                    addTestLog('📦 Data: ' + JSON.stringify(response), 'info');
                    
                    if (response.success) {
                        var count = response.likeCount;
                        var isLiked = response.isLiked;
                        
                        jQuery('#likeCount').text(count);
                        jQuery('#likeStatus').text('상태: ' + (isLiked ? '좋아요 누름 ❤️' : '좋아요 안 누름 🤍'));
                        
                        if (isLiked) {
                            jQuery('#likeIcon').text('❤️').addClass('active');
                        } else {
                            jQuery('#likeIcon').text('🤍').removeClass('active');
                        }
                        
                        addTestLog('📊 좋아요: ' + count + '개, 내 상태: ' + (isLiked ? '누름' : '안누름'), 'success');
                        updateControllerStatus('count', 'success', count + '개 / ' + (isLiked ? '누름' : '안누름'));
                    } else {
                        addTestLog('❌ Error: ' + response.message, 'error');
                        updateControllerStatus('count', 'error', response.message);
                    }
                },
                error: function(xhr, status, error) {
                    addTestLog('❌ Ajax 에러: ' + error, 'error');
                    addTestLog('❌ Status: ' + xhr.status, 'error');
                    updateControllerStatus('count', 'error', 'Ajax 에러');
                }
            });
        }

        /**
         * ✅ LikeActionController 테스트
         */
        function testActionController() {
            addTestLog('=== ❤️ LikeActionController 테스트 ===', 'warning');
            updateControllerStatus('action', 'testing');
            
         	// ✅ 테스트용 userId 추가
            var testUserId = jQuery('#testUserId').val();
            
            if (!testUserId || testUserId.trim() === '') {
                addTestLog('⚠️ 사용자 ID를 입력해주세요!', 'error');
                updateControllerStatus('action', 'error', '사용자 ID 없음');
                alert('⚠️ 사용자 ID를 입력해주세요!');
                return;
            }
            
            jQuery.ajax({
                url: '${pageContext.request.contextPath}/like/action.ajax',
                type: 'POST',
                dataType: 'json',
                data: {
                    targetType: currentTargetType,
                    targetId: currentTargetId,
                    userId: testUserId  // ✅ 추가
                },
                beforeSend: function() {
                    addTestLog('📡 URL: /like/action.ajax');
                    addTestLog('📤 Request: targetType=' + currentTargetType + ', targetId=' + currentTargetId);
                },
                success: function(response) {
                    addTestLog('✅ Response 받음', 'success');
                    addTestLog('📦 Data: ' + JSON.stringify(response), 'info');
                    
                    if (response.success) {
                        var action = response.action;
                        var count = response.likeCount;
                        var isLiked = response.isLiked;
                        
                        jQuery('#likeCount').text(count);
                        jQuery('#likeStatus').text('상태: ' + (isLiked ? '좋아요 누름 ❤️' : '좋아요 안 누름 🤍'));
                        
                        if (isLiked) {
                            jQuery('#likeIcon').text('❤️').addClass('active');
                            addTestLog('💖 좋아요 추가! 현재: ' + count + '개', 'success');
                        } else {
                            jQuery('#likeIcon').text('🤍').removeClass('active');
                            addTestLog('💔 좋아요 취소! 현재: ' + count + '개', 'info');
                        }
                        
                        updateControllerStatus('action', 'success', action + ' → ' + count + '개');
                        
                        // 게시글인 경우 상세도 업데이트
                        if (currentTargetType === 'ROOM_BOARD') {
                            setTimeout(testDetailController, 300);
                        }
                    } else {
                        addTestLog('❌ Error: ' + response.message, 'error');
                        updateControllerStatus('action', 'error', response.message);
                        alert('❌ ' + response.message);
                    }
                },
                error: function(xhr, status, error) {
                    addTestLog('❌ Ajax 에러: ' + error, 'error');
                    addTestLog('❌ Status: ' + xhr.status, 'error');
                    updateControllerStatus('action', 'error', 'Ajax 에러');
                }
            });
        }

        /**
         * ✅ LikeDetailController 테스트
         */
        function testDetailController() {
            if (currentTargetType !== 'ROOM_BOARD') {
                addTestLog('ℹ️ DETAIL은 게시글(ROOM_BOARD)만 지원', 'info');
                jQuery('#likeDetailSection').hide();
                updateControllerStatus('detail', 'skip', '게시글 아님');
                return;
            }
            
            addTestLog('=== 📋 LikeDetailController 테스트 ===', 'warning');
            updateControllerStatus('detail', 'testing');
            
            jQuery.ajax({
                url: '${pageContext.request.contextPath}/like/detail.ajax',
                type: 'GET',
                dataType: 'json',
                data: {
                    roomBoardId: currentTargetId
                },
                beforeSend: function() {
                    addTestLog('📡 URL: /like/detail.ajax');
                    addTestLog('📤 Request: roomBoardId=' + currentTargetId);
                },
                success: function(response) {
                    addTestLog('✅ Response 받음', 'success');
                    addTestLog('📦 Data: totalCount=' + (response.totalCount || 0) + ', users=' + (response.likeUsers ? response.likeUsers.length : 0), 'info');
                    
                    if (response.success) {
                        var totalCount = response.totalCount;
                        var likeUsers = response.likeUsers;
                        
                        jQuery('#detailTotalCount').text(totalCount);
                        jQuery('#likeDetailSection').show();
                        
                        displayLikeUsers(likeUsers);
                        
                        addTestLog('📋 사용자 목록: ' + totalCount + '명', 'success');
                        updateControllerStatus('detail', 'success', totalCount + '명');
                    } else {
                        addTestLog('❌ Error: ' + response.message, 'error');
                        updateControllerStatus('detail', 'error', response.message);
                    }
                },
                error: function(xhr, status, error) {
                    addTestLog('❌ Ajax 에러: ' + error, 'error');
                    addTestLog('❌ Status: ' + xhr.status, 'error');
                    updateControllerStatus('detail', 'error', 'Ajax 에러');
                }
            });
        }

        /**
         * Controller 상태 업데이트
         */
        function updateControllerStatus(controller, status, result) {
            var statusIndicator = jQuery('#' + controller + 'Status');
            var lastCallElement = jQuery('#' + controller + 'LastCall');
            var resultElement = jQuery('#' + controller + 'Result');
            
            var timestamp = new Date().toLocaleTimeString();
            lastCallElement.text(timestamp);
            
            statusIndicator.removeClass('active');
            
            if (status === 'success') {
                statusIndicator.addClass('active');
                resultElement.text('✅ ' + result).css('color', '#56ab2f');
            } else if (status === 'error') {
                resultElement.text('❌ ' + result).css('color', '#f5576c');
            } else if (status === 'testing') {
                resultElement.text('⏳ 테스트 중...').css('color', '#4facfe');
            } else if (status === 'skip') {
                resultElement.text('⏭️ ' + result).css('color', '#999');
            }
        }

        /**
         * 좋아요 사용자 목록 표시
         */
        function displayLikeUsers(users) {
            var listContainer = jQuery('#likeUserList');
            listContainer.empty();
            
            if (!users || users.length === 0) {
                listContainer.html('<div class="empty-state">좋아요를 누른 사용자가 없습니다.</div>');
                return;
            }
            
            for (var i = 0; i < users.length; i++) {
                var user = users[i];
                var contextPath = '${pageContext.request.contextPath}';
                
                var avatarHtml = user.userPhoto ? 
                    '<img src="' + contextPath + user.userPhoto + '" alt="프로필" onerror="this.parentElement.innerHTML=\'' + 
                    escapeHtml(user.userNickname).charAt(0) + '\';">' :
                    escapeHtml(user.userNickname).charAt(0);
                
                var timeText = formatDateTime(user.likeCreatedAt);
                
                var userHtml = '<div class="like-user-item">' +
                    '<div class="user-avatar">' + avatarHtml + '</div>' +
                    '<div class="user-info">' +
                    '<div class="user-nickname">' + escapeHtml(user.userNickname) + '</div>' +
                    '<div class="like-time">🕐 ' + timeText + '</div>' +
                    '</div></div>';
                
                listContainer.append(userHtml);
            }
        }

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

        function escapeHtml(text) {
            if (!text) return '';
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function formatDateTime(dateStr) {
            if (!dateStr) return '';
            var date = new Date(dateStr);
            var month = String(date.getMonth() + 1).padStart(2, '0');
            var day = String(date.getDate()).padStart(2, '0');
            var hours = String(date.getHours()).padStart(2, '0');
            var minutes = String(date.getMinutes()).padStart(2, '0');
            return month + '/' + day + ' ' + hours + ':' + minutes;
        }
    </script>
</body>
</html>