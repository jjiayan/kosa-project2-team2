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

/* 게시글 목록 스타일 */
.posts-container {
    max-width: 1000px;
    margin: 0 auto;
}

.page-title {
    font-size: 28px;
    font-weight: bold;
    text-align: center;
    margin-bottom: 40px;
    color: #333;
}

/* 게시글 목록 헤더 */
.post-header {
    display: grid;
    grid-template-columns: 1fr 120px 120px 100px;
    gap: 20px;
    padding: 15px 20px;
    border-bottom: 2px solid #333;
    margin-bottom: 5px;
    font-weight: bold;
    color: #333;
    font-size: 15px;
}

.header-title {
    text-align: left;
}

.header-author,
.header-date,
.header-views {
    text-align: center;
}

/* 게시글 아이템 */
.post-item {
    display: grid;
    grid-template-columns: 1fr 120px 120px 100px;
    gap: 20px;
    padding: 15px 20px;
    border-bottom: 1px solid #f0f0f0;
    cursor: pointer;
    transition: background-color 0.2s;
    align-items: center;
}

.post-item:hover {
    background-color: #f8f9fa;
    border-radius: 8px;
}

.post-title-cell {
    font-size: 16px;
    color: #333;
    font-weight: 500;
    text-align: left;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.post-author-cell,
.post-date-cell,
.post-views-cell {
    color: #666;
    font-size: 14px;
    text-align: center;
}

/* 댓글 수 스타일 */
.reply-count {
    color: #ff6b9d;
    font-size: 0.9em;
    margin-left: 5px;
}

/* 검색바와 글쓰기 버튼 */
.search-write-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin: 30px 0;
    gap: 20px;
}

.search-container {
    position: relative;
    flex: 1;
    max-width: 400px;
    margin: 0 auto;
}

.search-input {
    width: 100%;
    padding: 12px 20px;
    border: 2px solid #e9ecef;
    border-radius: 25px;
    font-size: 14px;
    outline: none;
    transition: border-color 0.3s;
}

.search-input:focus {
    border-color: #ff6b9d;
}

.search-btn {
    position: absolute;
    right: 5px;
    top: 50%;
    transform: translateY(-50%);
    background: linear-gradient(45deg, #ff6b9d, #ff8a80);
    color: white;
    border: none;
    border-radius: 50%;
    width: 35px;
    height: 35px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
}

.write-btn {
    background: linear-gradient(45deg, #ff6b9d, #ff8a80);
    color: white;
    border: none;
    border-radius: 12px;
    padding: 12px 20px;
    font-size: 14px;
    font-weight: bold;
    cursor: pointer;
    box-shadow: 0 4px 12px rgba(255, 107, 157, 0.3);
    transition: all 0.3s ease;
    flex-shrink: 0;
}

.write-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(255, 107, 157, 0.4);
}

/* 페이지네이션 */
.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
    margin-top: 40px;
}

.page-btn {
    width: 40px;
    height: 40px;
    border: none;
    background: #f8f9fa;
    color: #666;
    border-radius: 8px;
    cursor: pointer;
    font-size: 14px;
    transition: all 0.2s;
}

.page-btn:hover {
    background: #e9ecef;
}

.page-btn.active {
    background: linear-gradient(45deg, #ff6b9d, #ff8a80);
    color: white;
}

.page-btn.nav {
    font-size: 16px;
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
    
    .search-write-section {
        flex-direction: column;
        gap: 15px;
    }
    
    .search-container {
        width: 100%;
        max-width: 300px;
    }
    
    /* 모바일에서 간소화 */
    .post-header,
    .post-item {
        grid-template-columns: 1fr 80px 80px;
        gap: 10px;
    }
    
    .header-views,
    .post-views-cell {
        display: none;
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
            <jsp:param name="current" value="posts"/>
        </jsp:include>
        
        <!-- 우측 본문 -->
        <main>
            <div class="posts-container">
                <h1 class="page-title">스터디 게시글</h1>
                
                <!-- 게시글 목록 -->
                <div class="post-list">
                    <!-- 목록 헤더 -->
                    <div class="post-header">
                        <div class="header-title">제목</div>
                        <div class="header-author">작성자</div>
                        <div class="header-date">작성일</div>
                        <div class="header-views">조회수</div>
                    </div>
                    
                    <!-- 게시글 아이템들 -->
                    <c:forEach var="roomBoard" items="${roomBoardList}">
                        <div class="post-item" onclick="location.href='/roomboarddetail.room?roomBoardId=${roomBoard.roomBoardId}'">
                            <div class="post-title-cell">${roomBoard.roomBoardTitle}
                                <c:if test="${roomBoard.replyCount > 0}">
                                    <span class="reply-count">[${roomBoard.replyCount}]</span>
                                </c:if>
                            </div>
                            <div class="post-author-cell">${roomBoard.userNickname}</div>
                            <div class="post-date-cell">
                                <fmt:formatDate value="${roomBoard.updatedAt}" pattern="yyyy-MM-dd"/>
                            </div>
                            <div class="post-views-cell">${roomBoard.roomBoardViewCnt}</div>
                        </div>
                    </c:forEach>
                </div>
                
                <!-- 검색바와 글쓰기 버튼 -->
                <div class="search-write-section">
                    <div></div> <!-- 왼쪽 공간 -->
                    <div class="search-container">
                        <input type="text" class="search-input" placeholder="제목으로 검색..." id="searchInput">
                        <button class="search-btn" onclick="searchPosts()">🔍</button>
                    </div>
                    <button class="write-btn" onclick="location.href='/post/write'">
                        게시글 쓰기
                    </button>
                </div>
                
                <!-- 페이지네이션 -->
                <div class="pagination">
                    <button class="page-btn nav">‹</button>
                    <button class="page-btn active">1</button>
                    <button class="page-btn">2</button>
                    <button class="page-btn">3</button>
                    <button class="page-btn">4</button>
                    <button class="page-btn">5</button>
                    <button class="page-btn nav">›</button>
                </div>
            </div>
        </main>
    </div>
    
    <script>
        function searchPosts() {
            const searchTerm = document.getElementById('searchInput').value;
            if (searchTerm.trim()) {
                // 검색 기능 구현
                console.log('검색어:', searchTerm);
                // location.href = '/posts/search?keyword=' + encodeURIComponent(searchTerm);
            }
        }
        
        // 엔터키로 검색
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchPosts();
            }
        });
    </script>
</body>
</html>