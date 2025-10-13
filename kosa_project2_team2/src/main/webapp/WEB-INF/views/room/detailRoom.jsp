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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css">
    <style>
        /* ===== 전체 레이아웃 ===== */
        .layout-wrap {
            display: grid;
            grid-template-columns: auto 1fr; /* 왼쪽: 사이드바 / 오른쪽: 메인 */
            gap: 0; /* 간격 제거 */
            align-items: flex-start;
            margin: 0;
            padding: 0;
        }

        main {
            background: #fff; /* 흰색으로 변경 */
            border-left: 1px solid #e5e7eb;
            padding: 24px 28px;
            min-height: 100vh;
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
            margin: 5px 0; /* 8px에서 5px로 더 줄임 */
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
            margin: 5px 0; /* 8px에서 5px로 더 줄임 */
        }
        
        /* 좋아요 섹션 */
        .like-section {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            gap: 8px;
            margin: 5px 0; /* 8px에서 5px로 더 줄임 */
            padding: 0; /* 패딩 제거해서 완전히 왼쪽으로 */
            background: #fff; /* 흰색으로 변경 */
            border-radius: 8px;
        }
        
        .like-btn {
            background: none;
            border: none;
            cursor: pointer;
            padding: 0; /* 패딩 제거 */
            display: flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.2s;
        }
        
        .like-btn:hover {
            transform: scale(1.1);
        }
        
        .like-btn.liked svg {
            fill: #ff6b6b;
            stroke: #ff6b6b;
        }
        
        .like-count {
            font-size: 14px;
            color: #666;
            font-weight: 500;
        }
        
        /* 별점주기 버튼 */
        .rating-btn {
            padding: 8px 12px; /* 작은 사이즈 */
            border: none;
            border-radius: 8px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            background: linear-gradient(45deg, #ffa726, #ff9800);
            color: white;
            transition: all 0.3s ease;
            margin-left: auto; /* 오른쪽 끝으로 정렬 */
        }
        
        .rating-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 3px 8px rgba(255, 167, 38, 0.3);
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
        
        /* ===== 반응형 ===== */
        @media (max-width: 900px) {
            .layout-wrap {
                grid-template-columns: 1fr;
            }
            main {
                border-left: none;
                border-top: 1px solid #e5e7eb;
            }
        }
    </style>
</head>
<body>
    <!-- 공통 네비게이션 -->
    <jsp:include page="/include/nav.jsp" />
    
    <!-- 사이드바 + 메인 레이아웃 -->
    <div class="layout-wrap">
        
        <!-- 좌측 사이드바 -->
        <jsp:include page="/include/sidebar.jsp">
            <jsp:param name="current" value="home"/>
        </jsp:include>
        
        <!-- 우측 본문 -->
        <main>
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
                                <i class="fas fa-star star"></i>
                            </div>
                            <div class="star-rating">
                                <span class="rating-number">${roomDetail.roomScore}</span>
                                <span class="rating-count">점</span>
                            </div>
                            <!-- 참여했을 때만 별점주기 버튼 표시 -->
                           <c:if test="${roomDetail.joinUserStatus == 'LEADER' || roomDetail.joinUserStatus == 'MEMBER'}">
							    <button class="rating-btn" onclick="openRatingModal()">별점주기</button>
							</c:if>
                        </div>
                        
                        <div class="like-section">
                            <button class="like-btn ${roomDetail.isLiked() ? 'liked' : ''}" onclick="toggleLike(this, ${roomDetail.roomId})">
                                <svg width="20" height="20" viewBox="0 0 24 24" 
                                     fill="${roomDetail.isLiked() ? '#ff6b6b' : 'none'}" stroke="currentColor" stroke-width="2">
                                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 
                                             5.5 0 0 0-7.78 7.78l1.06 1.06L12 
                                             21.23l7.78-7.78 1.06-1.06a5.5 
                                             5.5 0 0 0 0-7.78z"></path>
                                </svg>
                            </button>
                            <span class="like-count">${roomDetail.likeCount}</span>
                        </div>
                        
                        <div class="created-date">
                            생성일: <fmt:formatDate value="${roomDetail.updatedAt}" pattern="yyyy.MM.dd"/>
                        </div>
                        
                        <!-- 참여 버튼 -->
                        <c:choose>
						    <c:when test="${roomDetail.joinUserStatus == 'LEADER' || roomDetail.joinUserStatus == 'MEMBER'}">
						        <button class="join-status-btn joined-btn" disabled>참여중</button>
						    </c:when>
						    <c:when test="${roomDetail.joinUserStatus == 'PENDING'}">
						        <button class="join-status-btn pending-btn" disabled>참가 대기중</button>
						    </c:when>
						    <c:otherwise>
						        <button class="join-status-btn join-btn" id="joinroom" onclick="joinRoom()">참가하기</button>
						    </c:otherwise>
						</c:choose>
                    </div>
                </div>
            </div>
        </main>
    </div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        function toggleLike(button, roomId) {
            button.classList.toggle('liked');
            const svg = button.querySelector('svg');
            const likeCount = button.nextElementSibling;
            const currentCount = parseInt(likeCount.textContent);
            
            if (button.classList.contains('liked')) {
                svg.setAttribute('fill', '#ff6b6b');
                svg.setAttribute('stroke', '#ff6b6b');
                likeCount.textContent = currentCount + 1;
            } else {
                svg.setAttribute('fill', 'none');
                svg.setAttribute('stroke', 'currentColor');
                likeCount.textContent = currentCount - 1;
            }
            
            // 서버에 좋아요 상태 전송
            fetch('/room/like', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    roomId: roomId,
                    isLiked: button.classList.contains('liked')
                })
            }).catch(error => {
                console.error('좋아요 처리 중 오류:', error);
            });
        }
        
        function openRatingModal() {
            // 별점주기 모달이나 페이지 열기
            alert('별점주기 기능을 구현해주세요!');
        }
        
        
        
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