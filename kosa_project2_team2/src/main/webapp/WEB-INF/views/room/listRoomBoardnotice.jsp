<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스터디 공지</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css">
<style>
/* ===== 전체 레이아웃 ===== */
.layout-wrap {
    display: grid;
    grid-template-columns: auto 1fr;
    gap: 0;
    align-items: flex-start;
    margin: 0;
    padding: 0;
}
main {
    background: #fff;
    border-left: 1px solid #e5e7eb;
    padding: 24px 28px;
    min-height: 100vh;
}
.posts-container { max-width: 1000px; margin: 0 auto; }
.page-title { font-size: 28px; font-weight: bold; text-align: center; margin-bottom: 40px; color: #333; }
.post-header {
    display: grid; grid-template-columns: 1fr 120px 120px 100px;
    gap: 20px; padding: 15px 20px; border-bottom: 2px solid #333;
    margin-bottom: 5px; font-weight: bold; color: #333; font-size: 15px;
}
.post-item {
    display: grid; grid-template-columns: 1fr 120px 120px 100px;
    gap: 20px; padding: 15px 20px; border-bottom: 1px solid #f0f0f0;
    cursor: pointer; transition: background-color 0.2s; align-items: center;
}
.post-item:hover { background-color: #f8f9fa; border-radius: 8px; }
.post-title-cell { font-size: 16px; color: #333; font-weight: 500; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.post-author-cell, .post-date-cell, .post-views-cell { color: #666; font-size: 14px; text-align: center; }
.reply-count { color: #ff6b9d; font-size: 0.9em; margin-left: 5px; }
.search-write-section { display: flex; justify-content: space-between; align-items: center; margin: 30px 0; gap: 20px; }
.search-container { position: relative; flex: 1; max-width: 400px; margin: 0 auto; }
.search-input { width: 100%; padding: 12px 20px; border: 2px solid #e9ecef; border-radius: 25px; font-size: 14px; outline: none; }
.search-input:focus { border-color: #ff6b9d; }
.search-btn { position: absolute; right: 5px; top: 50%; transform: translateY(-50%); background: linear-gradient(45deg, #ff6b9d, #ff8a80); color: white; border: none; border-radius: 50%; width: 35px; height: 35px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 14px; }
.write-btn { background: linear-gradient(45deg, #ff6b9d, #ff8a80); color: white; border: none; border-radius: 12px; padding: 12px 20px; font-size: 14px; font-weight: bold; cursor: pointer; box-shadow: 0 4px 12px rgba(255, 107, 157, 0.3); }
.pagination { display: flex; justify-content: center; align-items: center; gap: 10px; margin-top: 40px; }
.page-btn { width: 40px; height: 40px; border: none; background: #f8f9fa; color: #666; border-radius: 8px; cursor: pointer; font-size: 14px; }
.page-btn.active { background: linear-gradient(45deg, #ff6b9d, #ff8a80); color: white; }
@media (max-width: 900px) {
    .layout-wrap { grid-template-columns: 1fr; }
    main { border-left: none; border-top: 1px solid #e5e7eb; }
    .post-header, .post-item { grid-template-columns: 1fr 80px 80px; gap: 10px; }
    .header-views, .post-views-cell { display: none; }
}
</style>
</head>
<body>
    <jsp:include page="/include/nav.jsp" />
    
    <div class="layout-wrap">
        <jsp:include page="/include/sidebar.jsp">
            <jsp:param name="current" value="notice"/>
        </jsp:include>
        
        <main>
            <div class="posts-container">
                <h1 class="page-title">스터디 공지</h1>
                
                <!-- 게시글 목록 -->
                <div class="post-list">
                    <div class="post-header">
                        <div class="header-title">제목</div>
                        <div class="header-author">작성자</div>
                        <div class="header-date">작성일</div>
                        <div class="header-views">조회수</div>
                    </div>
                    
                    <!-- ✅ pageResult.data 사용 -->
                    <c:forEach var="roomBoardNotice" items="${pageResult.data}">
                    
                    <div class="post-item" 
       					onclick="handlePostClick('${sessionScope.roomTier}', '${ctx}', '${roomBoardNotice.roomBoardId}', '${sessionScope.LOGIN_USER.user_id}')">
                            <div class="post-title-cell">
                                ${roomBoardNotice.roomBoardTitle}
                                <c:if test="${roomBoardNotice.replyCount > 0}">
                                    <span class="reply-count">[${roomBoardNotice.replyCount}]</span>
                                </c:if>
                            </div>
                            <div class="post-author-cell">${roomBoardNotice.userNickname}</div>
                            <div class="post-date-cell">
                                <fmt:formatDate value="${roomBoardNotice.updatedAt}" pattern="yyyy-MM-dd"/>
                            </div>
                            <div class="post-views-cell">${roomBoardNotice.roomBoardViewCnt}</div>
                        </div>
                    </c:forEach>
                </div>
                
                <!-- 검색 + 공지쓰기 -->
                <div class="search-write-section">
                    <div></div>
                    <div class="search-container">
                        <input 
						  type="text" 
						  class="search-input" 
						  placeholder="제목으로 검색..." 
						  id="searchInput"
						  <c:if test="${not empty pageResult.keyword}">
						      value="${pageResult.keyword}"
						  </c:if>
						>
                        <button class="search-btn" onclick="searchPosts(${sessionScope.currentRoomId})">🔍</button>
                    </div>
                    <c:if test="${sessionScope.leaderCheck}">
	                    <button class="write-btn" onclick="location.href='${pageContext.request.contextPath}/roomboardinsertform.room?roomId=${roomId}&userId=${sessionScope.LOGIN_USER.user_id}&roomBoardType=NOTICE'">
	                        공지 쓰기
	                    </button>
                    </c:if>
                </div>
                
                <!-- ✅ pageResult 기반 페이지네이션 -->
                <div class="pagination">
				    <c:if test="${pageResult.currentPage > 1}">
				        <button class="page-btn" onclick="goToPage(${pageResult.currentPage - 1}, ${sessionScope.currentRoomId})">‹</button>
				    </c:if>
				
				    <c:forEach begin="1" end="${pageResult.totalPages}" var="i">
				        <button class="page-btn ${i == pageResult.currentPage ? 'active' : ''}" 
				                onclick="goToPage(${i}, ${sessionScope.currentRoomId})">${i}</button>
				    </c:forEach>
				
				    <c:if test="${pageResult.currentPage < pageResult.totalPages}">
				        <button class="page-btn" onclick="goToPage(${pageResult.currentPage + 1}, ${sessionScope.currentRoomId})">›</button>
				    </c:if>
				</div>
                
            </div>
        </main>
    </div>
    
    <script>
        function searchPosts(roomId) {
            const searchTerm = document.getElementById('searchInput').value;
            if (searchTerm.trim()) {
                location.href = '${pageContext.request.contextPath}/roomboardnotice.room?keyword=' + encodeURIComponent(searchTerm)+"&roomId="+roomId;
            }
        }
        
        function goToPage(p, roomId) {
            const q = document.getElementById('searchInput').value.trim();
            let url = '${pageContext.request.contextPath}/roomboardnotice.room?page=' + p+  "&roomId="+roomId;
            if (q) url += '&keyword=' + encodeURIComponent(q);
            location.href = url;
        }

        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchPosts();
            }
        });
        
        function handlePostClick(roomTier, ctx, roomBoardId, userId) {
            if (roomTier !== 'MEMBER' && roomTier !== 'LEADER') {
              alert("모임에 가입해주세요.");
              return;
            }
            location.href = ctx + "/roomboarddetail.room?roomBoardId=" + roomBoardId + "&userId=" + userId + "&roomBoardType=NOTICE";
          }
        
    </script>
</body>
</html>
