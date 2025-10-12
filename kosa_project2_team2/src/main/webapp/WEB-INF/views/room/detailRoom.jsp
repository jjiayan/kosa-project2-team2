<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${roomDetail.title}</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        }
        
        .page-title {
            font-size: 28px;
            font-weight: bold;
            color: #333;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .main-container {
            display: flex;
            gap: 30px;
            max-width: 1400px;
            margin: 0 auto;
            position: relative;
        }
        
        /* 가운데 컨텐츠 영역 */
        .content-section {
            flex: 1;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        .content-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }
        
        .content-description {
            font-size: 16px;
            line-height: 1.6;
            color: #666;
            max-width: 500px;
        }
        
        /* 오른쪽 정보 영역 */
        .info-section {
            flex: 0 0 300px;
            position: relative;
            padding-left: 30px;
        }
        
        /* 방장 정보 박스 */
        .leader-info-box {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-top: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border: 1px solid #e0e0e0;
            width: 100%;
        }
        
        .leader-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .leader-icon {
            width: 35px;
            height: 35px;
            background: linear-gradient(45deg, #ffa726, #ff9800);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            font-size: 16px;
        }
        
        .leader-title {
            font-size: 14px;
            font-weight: bold;
            color: #333;
        }
        
        .stats-container {
            display: flex;
            align-items: center;
            gap: 15px;
            margin: 12px 0;
            font-size: 14px;
        }
        
        .star-rating {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .star {
            color: #ffa726;
            font-size: 16px;
        }
        
        .rating-number {
            font-weight: bold;
            color: #333;
        }
        
        .rating-count {
            background: #ff5252;
            color: white;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 11px;
            font-weight: bold;
        }
        
        .created-date {
            color: #666;
            font-size: 13px;
            margin: 12px 0;
        }
        
        /* 참여 버튼 */
        .join-status-btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: bold;
            margin-top: 15px;
            cursor: pointer;
        }
        
        .joined-btn {
            background: #6c757d;
            color: white;
        }
        
        .join-btn {
            background: linear-gradient(45deg, #ff6b9d, #ff8a80);
            color: white;
            transition: all 0.3s ease;
        }
        
        .join-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(255, 107, 157, 0.3);
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- 가운데: 컨텐츠 영역 -->
        <div class="content-section">
            <div class="content-title">${roomDetail.title}</div>
            
            <div class="content-description">
                <c:choose>
                    <c:when test="${not empty roomDetail.content}">
                        ${roomDetail.content}
                    </c:when>
                    <c:otherwise>
                        모임에 대한 상세한 설명이 여기에 들어갑니다. 자격증 취득을 위한 스터디 모임으로 함께 공부하고 정보를 나누며 성장할 수 있는 공간입니다.
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- 오른쪽: 정보 영역 -->
        <div class="info-section">
            <!-- 방장 정보 박스 -->
            <div class="leader-info-box">
                <div class="leader-header">
                    <div class="leader-icon">🐾</div>
                    <div class="leader-title">방장 닉네임: ${roomDetail.userNickName}</div>
                </div>
                
                <div class="stats-container">
                    <div class="star-rating">
                        <span class="star">⭐</span>
                        <span class="rating-number">${roomDetail.likeCount}</span>
                    </div>
                    <div class="star-rating">
                        <span class="rating-number">${roomDetail.roomScore}</span>
                        <span class="rating-count">점</span>
                    </div>
                </div>
                
                <div class="created-date">
                    생성일: <fmt:formatDate value="${roomDetail.updatedAt}" pattern="yyyy.MM.dd"/>
                </div>
                
                <!-- 참여 버튼 -->
                <c:choose>
                    <c:when test="${roomDetail.joinUserCheck}">
                        <button class="join-status-btn joined-btn" disabled>참여중</button>
                    </c:when>
                    <c:otherwise>
                        <button class="join-status-btn join-btn" onclick="joinRoom()">참가하기</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        function joinRoom() {
            if(confirm('이 모임에 참가하시겠습니까?')) {
                fetch('/room/join', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        roomId: ${roomDetail.roomId}
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if(data.success) {
                        alert('모임에 참가되었습니다!');
                        location.reload();
                    } else {
                        alert('참가 중 오류가 발생했습니다.');
                    }
                });
            }
        }
    </script>
</body>
</html>