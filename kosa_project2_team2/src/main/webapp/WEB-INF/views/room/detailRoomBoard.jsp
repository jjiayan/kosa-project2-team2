<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스터디 게시글</title>
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

/* 게시글 상세 스타일 - 입체적인 효과 */
.post-detail-container {
    max-width: 800px;
    margin: 0 auto;
    background: #fff;
    border-radius: 20px;
    padding: 30px;
    box-shadow: 
        0 10px 30px rgba(0, 0, 0, 0.1),
        0 1px 8px rgba(0, 0, 0, 0.06),
        inset 0 1px 0 rgba(255, 255, 255, 0.8);
    border: 1px solid rgba(0, 0, 0, 0.05);
    position: relative;
    background: linear-gradient(145deg, #ffffff, #f8f9fa);
    transition: all 0.3s ease;
}

.post-detail-container:hover {
    transform: translateY(-2px);
    box-shadow: 
        0 15px 40px rgba(0, 0, 0, 0.12),
        0 5px 15px rgba(0, 0, 0, 0.08);
}

.post-title {
    font-size: 24px;
    font-weight: bold;
    text-align: center;
    margin-bottom: 30px;
    color: #333;
}

.post-subtitle {
    font-size: 18px;
    text-align: center;
    margin-bottom: 20px;
    color: #666;
}

.post-info {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 15px;
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 1px solid #e5e7eb;
}

.author-profile {
    display: flex;
    align-items: center;
    gap: 8px;
}

.author-avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background: #fbbf24;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    overflow: hidden; /* 이미지가 원형으로 잘리도록 */
}

.profile-img {
    width: 100%;
    height: 100%;
    object-fit: cover; /* 이미지 비율 유지하며 원형에 맞춤 */
    border-radius: 50%;
}

.author-name {
    font-weight: 500;
    color: #333;
}

.post-meta {
    color: #666;
    font-size: 14px;
}

.view-count {
    color: #666;
    font-size: 14px;
}

/* 좋아요 섹션 - 게시글용 */
.like-section {
    display: flex;
    align-items: center;
    gap: 8px;
}

.like-btn {
    background: none;
    border: none;
    cursor: pointer;
    padding: 2px;
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
    color: #ef4444;
    font-size: 14px;
    font-weight: 500;
}

.action-buttons {
    display: flex;
    gap: 10px;
    margin-left: auto;
}

.btn {
    padding: 8px 16px;
    border: none;
    border-radius: 6px;
    font-size: 12px;
    cursor: pointer;
    transition: all 0.2s;
}

.btn-edit {
    background: #f3f4f6;
    color: #374151;
}

.btn-edit:hover {
    background: #e5e7eb;
}

.btn-delete {
    background: #fef2f2;
    color: #dc2626;
}

.btn-delete:hover {
    background: #fee2e2;
}

.post-content {
    line-height: 1.8;
    font-size: 16px;
    color: #333;
    margin-bottom: 30px;
    min-height: 300px;
    word-break: break-word;
    white-space: pre-wrap; /* 줄바꿈 보존 */
}

/* ===== 반응형 ===== */
@media (max-width: 900px) {
    .layout-wrap {
        grid-template-columns: 1fr;
    }
    main {
        border-left: none;
        border-top: 1px solid #e5e7eb;
        padding: 16px;
    }
    
    .post-detail-container {
        padding: 20px;
        margin: 0 10px;
    }
    
    .post-info {
        flex-direction: column;
        gap: 10px;
    }
    
    .action-buttons {
        margin-left: 0;
        justify-content: center;
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
        <c:choose>
		    <c:when test="${roomBoardType == 'NOTICE'}">
		        <jsp:include page="/include/sidebar.jsp">
		            <jsp:param name="current" value="notice"/>
		        </jsp:include>
		    </c:when>
		    <c:otherwise>
		        <jsp:include page="/include/sidebar.jsp">
		            <jsp:param name="current" value="posts"/>
		        </jsp:include>
		    </c:otherwise>
		</c:choose>
        
        <!-- 우측 본문 -->
        <main>
            <div class="post-detail-container">
                    <input type="hidden" id="roomId" name="roomId" value="${sessionScope.currentRoomId}">
                    <input type="hidden" name="userId" value="${sessionScope.LOGIN_USER.user_id}">
                    <input type="hidden" id="roomBoardType" name="roomBoardType" value="${roomBoardType}">
                  <h1>
				    <c:choose>
				        <c:when test="${roomBoardType == 'NOTICE'}">스터디 공지</c:when>
				        <c:otherwise>스터디 게시글</c:otherwise>
				    </c:choose>
				</h1>
                
                <div class="post-subtitle">${roomBoardDetail.roomBoardTitle}</div>
                
                
                <div class="post-info">
                    <div class="author-profile">
                        <div class="author-avatar">
                            <c:choose>
                                <c:when test="${not empty roomBoardDetail.userPhoto}">
                                    <img src="${roomBoardDetail.userPhoto}" alt="프로필 사진" class="profile-img">
                                </c:when>
                                <c:otherwise>
                                    🐴 <!-- 기본 아바타 -->
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <span class="author-name">${roomBoardDetail.userNickname}</span>
                    </div>
                    
                    <div class="post-meta">
                        <fmt:formatDate value="${roomBoardDetail.updatedAt}" pattern="yyyy.MM.dd. HH:mm"/>
                    </div>
                    
                    <div class="view-count">조회수 ${roomBoardDetail.roomBoardViewCnt}</div>
                    
                    <div class="like-section">
                        <button class="like-btn ${roomBoardDetail.likeStatus ? 'liked' : ''}" onclick="toggleLike(this, ${roomBoardDetail.roomBoardId})">
                            <svg width="16" height="16" viewBox="0 0 24 24" 
                                 fill="${roomBoardDetail.likeStatus ? '#ff6b6b' : 'none'}" stroke="currentColor" stroke-width="2">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 
                                         5.5 0 0 0-7.78 7.78l1.06 1.06L12 
                                         21.23l7.78-7.78 1.06-1.06a5.5 
                                         5.5 0 0 0 0-7.78z"></path>
                            </svg>
                        </button>
                        <span class="like-count">${roomBoardDetail.likeCount}</span>
                    </div>
                    
                    <div class="action-buttons">
                        <c:if test="${roomBoardDetail.isMyPost()}">
                            <button class="btn btn-edit" onclick="location.href='/roomboardupdateform.room?roomBoardId=${roomBoardDetail.roomBoardId}&roomBoardtype=NOTICE'">수정</button>
                            <button class="btn btn-delete" onclick="deletePost(${roomBoardDetail.roomBoardId})">삭제</button>
                        </c:if>
                    </div>
                </div>
                
                <div class="post-content">
                    ${roomBoardDetail.roomBoardContent}
                </div>
                
                <!-- 댓글 살포시 추가해보겠슴 -->
                <jsp:include page="/WEB-INF/views/reply/replies.jsp">
                    <jsp:param name="roomBoardId" value="${roomBoardDetail.roomBoardId}" />
                </jsp:include>
                
            </div>
        </main>
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        function toggleLike(button, roomBoardId) {
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
            fetch('/roomboard/like', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    roomBoardId: roomBoardId,
                    isLiked: button.classList.contains('liked')
                })
            }).catch(error => {
                console.error('좋아요 처리 중 오류:', error);
            });
        }
        
        function deletePost(roomBoardId) {
            if(confirm('정말 삭제하시겠습니까?')) {
            	 let roomId = $('#roomId').val();
                 let roomBoardType = $('#roomBoardType').val();
                 let userId = $('input[name="userId"]').val();
                $.ajax({
                	url: "/roomboarddelete.roomajax",
                	
                })
            }
        }
    </script>
</body>
</html>