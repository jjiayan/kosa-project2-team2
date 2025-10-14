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

.like-container { 
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
    background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
    border: none;
    padding: 20px 25px;
    margin: 20px auto;
    border-radius: 15px;
    text-align: center;
    max-width: 800px;
    box-shadow: 0 10px 25px rgba(255, 107, 107, 0.3);
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
    flex-wrap: wrap;
}

.test-input-group label {
    font-weight: 600;
    color: white;
}

.test-input-group input, .test-input-group select {
    padding: 8px 12px;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-radius: 8px;
    text-align: center;
    background: rgba(255, 255, 255, 0.9);
    font-weight: 600;
}

.test-input-group input {
    width: 100px;
}

.test-input-group select {
    width: 150px;
}

.test-input-group input:focus, .test-input-group select:focus {
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

/* 좋아요 표시 영역 */
.like-display {
    padding: 40px;
    text-align: center;
    background: white;
}

.like-icon {
    font-size: 80px;
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
    font-size: 32px;
    font-weight: 700;
    color: #333;
    margin-top: 20px;
}

.like-status {
    font-size: 16px;
    color: #666;
    margin-top: 10px;
}

/* 좋아요 상세 모달 */
.like-detail-section {
    padding: 30px;
    background: #fafafa;
    border-top: 2px solid #f0f0f0;
}

.detail-header {
    font-size: 18px;
    font-weight: 700;
    margin-bottom: 20px;
    color: #333;
}

.like-user-list {
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.like-user-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px;
    background: white;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.user-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: #ff6b6b;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-weight: 700;
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
    font-size: 14px;
}

.like-time {
    font-size: 12px;
    color: #999;
}

.empty-state {
    text-align: center;
    padding: 60px 20px;
    color: #aaa;
    font-size: 14px;
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
        <h3>🧪 좋아요 시스템 완전 테스트</h3>
        <p>
            <strong>활성화된 기능:</strong> 
            <span class="status-badge enabled">COUNT</span>
            <span class="status-badge enabled">ACTION</span>
            <span class="status-badge enabled">DETAIL</span>
        </p>
        <div class="test-input-group">
            <label>📌 대상 타입:</label>
            <select id="testTargetType">
                <option value="ROOM">모임방</option>
                <option value="ROOM_BOARD" selected>게시글</option>
                <option value="REPLY">댓글</option>
            </select>
            <label>🎯 대상 ID:</label>
            <input type="number" id="testTargetId" value="1">
            <label>👤 사용자 ID:</label>
            <input type="number" id="testUserId" value="70" placeholder="필수!">
        </div>
        <p style="color: rgba(255,255,255,0.9); font-size: 13px; margin: 10px 0 0 0;">
            ✅ 현재: 게시글 1, 사용자 70 (김가네)
        </p>
        <div class="test-buttons">
            <button class="test-btn primary" onclick="testReloadAll()">🔄 새로고침</button>
            <button class="test-btn secondary" onclick="testCountOnly()">📊 개수 조회</button>
            <button class="test-btn success" onclick="testToggleLike()">❤️ 토글</button>
            <button class="test-btn info" onclick="testDetailLoad()">📋 상세 보기</button>
            <button class="test-btn warning" onclick="clearTestLog()">🧹 로그 초기화</button>
        </div>
    </div>

    <!-- 테스트 로그 -->
    <div class="test-log" id="testLog">
        <div class="log-entry">✅ 테스트 로그 준비 완료...</div>
    </div>

    <!-- 좋아요 표시 영역 -->
    <div class="like-container">
        <div class="like-display">
            <div class="like-icon" id="likeIcon" onclick="testToggleLike()">
                🤍
            </div>
            <div class="like-count-display">
                좋아요 <strong id="likeCount">0</strong>개
            </div>
            <div class="like-status" id="likeStatus">
                상태: 확인 중...
            </div>
        </div>

        <!-- 좋아요 상세 (게시글만) -->
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
            currentTargetType = jQuery('#testTargetType').val();
            currentTargetId = parseInt(jQuery('#testTargetId').val());
            currentUserId = parseInt(jQuery('#testUserId').val());
            
            addTestLog('✅ 테스트 시스템 초기화 완료', 'success');
            addTestLog('📌 대상: ' + currentTargetType + ' ID: ' + currentTargetId);
            addTestLog('👤 사용자 ID: ' + currentUserId, 'info');
            addTestLog('🎯 전체 기능: COUNT, ACTION, DETAIL', 'info');
            
            testReloadAll();
            
            // 입력 값 변경 감지
            jQuery('#testTargetType, #testTargetId, #testUserId').on('change', function() {
                currentTargetType = jQuery('#testTargetType').val();
                currentTargetId = parseInt(jQuery('#testTargetId').val());
                currentUserId = parseInt(jQuery('#testUserId').val());
                
                addTestLog('🔄 설정 변경: ' + currentTargetType + ' ' + currentTargetId, 'warning');
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
            testCountOnly();
            
            // 게시글인 경우 상세 정보도 로드
            if (currentTargetType === 'ROOM_BOARD') {
                setTimeout(function() {
                    testDetailLoad();
                }, 500);
            } else {
                jQuery('#likeDetailSection').hide();
            }
        }

        /**
         * ✅ 좋아요 개수 조회 테스트
         */
        function testCountOnly() {
            addTestLog('=== 📊 좋아요 개수 조회 테스트 ===', 'warning');
            
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
                    addTestLog('📤 targetType: ' + currentTargetType + ', targetId: ' + currentTargetId);
                    jQuery('#likeStatus').text('상태: 조회 중...');
                },
                success: function(response) {
                    addTestLog('✅ 조회 성공!', 'success');
                    
                    if (response.success) {
                        var count = response.likeCount;
                        var isLiked = response.isLiked;
                        
                        jQuery('#likeCount').text(count);
                        jQuery('#likeStatus').text('상태: ' + (isLiked ? '좋아요 누름 ❤️' : '좋아요 안 누름 🤍'));
                        
                        // 아이콘 업데이트
                        if (isLiked) {
                            jQuery('#likeIcon').text('❤️').addClass('active');
                        } else {
                            jQuery('#likeIcon').text('🤍').removeClass('active');
                        }
                        
                        addTestLog('📊 좋아요 개수: ' + count + '개', 'success');
                        addTestLog('💖 내 좋아요 상태: ' + (isLiked ? '누름' : '안 누름'), 'info');
                    } else {
                        addTestLog('❌ ' + response.message, 'error');
                        jQuery('#likeStatus').text('상태: 오류 발생');
                    }
                },
                error: function(xhr, status, error) {
                    addTestLog('❌ Ajax 에러!', 'error');
                    addTestLog('에러 내용: ' + error, 'error');
                    jQuery('#likeStatus').text('상태: 서버 오류');
                }
            });
        }

        /**
         * ✅ 좋아요 토글 테스트
         */
        function testToggleLike() {
            addTestLog('=== ❤️ 좋아요 토글 시작 ===', 'warning');
            
            jQuery.ajax({
                url: '${pageContext.request.contextPath}/like/action.ajax',
                type: 'POST',
                dataType: 'json',
                data: {
                    targetType: currentTargetType,
                    targetId: currentTargetId
                },
                beforeSend: function() {
                    addTestLog('📡 URL: /like/action.ajax');
                    addTestLog('📤 targetType: ' + currentTargetType + ', targetId: ' + currentTargetId);
                },
                success: function(response) {
                    addTestLog('✅ 토글 완료!', 'success');
                    
                    if (response.success) {
                        var action = response.action;
                        var count = response.likeCount;
                        var isLiked = response.isLiked;
                        
                        jQuery('#likeCount').text(count);
                        jQuery('#likeStatus').text('상태: ' + (isLiked ? '좋아요 누름 ❤️' : '좋아요 안 누름 🤍'));
                        
                        // 아이콘 애니메이션
                        if (isLiked) {
                            jQuery('#likeIcon').text('❤️').addClass('active');
                            addTestLog('💖 좋아요 추가됨!', 'success');
                        } else {
                            jQuery('#likeIcon').text('🤍').removeClass('active');
                            addTestLog('💔 좋아요 취소됨', 'info');
                        }
                        
                        addTestLog('📊 현재 좋아요: ' + count + '개', 'success');
                        
                        // 게시글인 경우 상세 정보도 새로고침
                        if (currentTargetType === 'ROOM_BOARD') {
                            setTimeout(function() {
                                testDetailLoad();
                            }, 300);
                        }
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

        /**
         * ✅ 게시글 좋아요 상세 정보 조회
         */
        function testDetailLoad() {
            if (currentTargetType !== 'ROOM_BOARD') {
                addTestLog('ℹ️ 상세 정보는 게시글만 지원', 'info');
                jQuery('#likeDetailSection').hide();
                return;
            }
            
            addTestLog('=== 📋 좋아요 상세 조회 시작 ===', 'warning');
            
            jQuery.ajax({
                url: '${pageContext.request.contextPath}/like/detail.ajax',
                type: 'GET',
                dataType: 'json',
                data: {
                    roomBoardId: currentTargetId
                },
                beforeSend: function() {
                    addTestLog('📡 URL: /like/detail.ajax');
                    addTestLog('📤 roomBoardId: ' + currentTargetId);
                },
                success: function(response) {
                    addTestLog('✅ 상세 조회 성공!', 'success');
                    
                    if (response.success) {
                        var totalCount = response.totalCount;
                        var likeUsers = response.likeUsers;
                        
                        jQuery('#detailTotalCount').text(totalCount);
                        jQuery('#likeDetailSection').show();
                        
                        displayLikeUsers(likeUsers);
                        
                        addTestLog('📋 좋아요 사용자: ' + totalCount + '명', 'success');
                    } else {
                        addTestLog('❌ ' + response.message, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    addTestLog('❌ Ajax 에러!', 'error');
                }
            });
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
                    '<img src="' + contextPath + user.userPhoto + '" alt="프로필">' :
                    user.userNickname.charAt(0);
                
                var timeText = formatDateTime(user.likeCreatedAt);
                
                var userHtml = '<div class="like-user-item">' +
                    '<div class="user-avatar">' + avatarHtml + '</div>' +
                    '<div class="user-info">' +
                    '<div class="user-nickname">' + escapeHtml(user.userNickname) + '</div>' +
                    '<div class="like-time">' + timeText + '</div>' +
                    '</div></div>';
                
                listContainer.append(userHtml);
            }
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