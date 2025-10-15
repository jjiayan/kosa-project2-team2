<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>여기 룸보드 인설트 화면 here</title>
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

/* ===== 모임방 회원 관리 스타일 ===== */
.manage-header {
    text-align: center;
    margin-bottom: 40px;
}

.manage-header h1 {
    font-size: 24px;
    font-weight: 600;
    color: #333;
    margin-bottom: 20px;
}

.search-bar {
    position: relative;
    max-width: 400px;
    margin: 0 auto;
}

.search-bar input {
    width: 100%;
    padding: 12px 40px 12px 16px;
    border: 1px solid #ddd;
    border-radius: 25px;
    font-size: 14px;
    outline: none;
}

.search-bar button {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    border: none;
    cursor: pointer;
    color: #666;
}

/* ===== 회원 목록 그리드 ===== */
.member-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin-bottom: 40px;
}

.member-card {
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 20px;
    display: flex;
    align-items: center;
    gap: 15px;
    background: #fff;
}

.member-avatar {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #f0f0f0;
}

.member-info {
    flex: 1;
}

.member-name {
    font-size: 16px;
    font-weight: 500;
    color: #333;
    margin-bottom: 4px;
}

.member-tier {
    font-size: 12px;
    color: #666;
}

.action-btn {
    padding: 8px 16px;
    border: none;
    border-radius: 4px;
    font-size: 14px;
    cursor: pointer;
    min-width: 60px;
}
.btn-leader {
    background: #6b7280;
    color: white;
}

.btn-pending {
    background: #ff6b6b;
    color: white;
}

.btn-approve {
    background: #10b981;
    color: white;
    margin-right: 5px;
}

.btn-reject {
    background: #ef4444;
    color: white;
}

.btn-kick {
    background: #ef4444;
    color: white;
}

.btn-promote {
    background: #6b7280;
    color: white;
}

/* 버튼 그룹 스타일 */
.btn-group {
    display: flex;
    gap: 5px;
}

/* ===== 페이지네이션 ===== */
.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
    margin-top: 40px;
}

.pagination a, .pagination span {
    padding: 8px 12px;
    border: none;
    background: #f8f9fa;
    color: #666;
    border-radius: 4px;
    cursor: pointer;
    text-decoration: none;
    display: inline-block;
}

.pagination a:hover {
    background: #e9ecef;
}

.pagination .active {
    background: #ff6b6b;
    color: white;
}

.pagination .prev,
.pagination .next {
    font-size: 18px;
}

.pagination .disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

/* ===== 반응형 ===== */
@media (max-width: 1200px) {
    .member-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 900px) {
    .layout-wrap {
        grid-template-columns: 1fr;
    }
    main {
        border-left: none;
        border-top: 1px solid #e5e7eb;
        padding: 16px;
    }
    .member-grid {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 600px) {
    .member-card {
        padding: 15px;
        gap: 10px;
    }
    
    .member-avatar {
        width: 40px;
        height: 40px;
    }
    
    .action-btn {
        padding: 6px 12px;
        font-size: 12px;
        min-width: 50px;
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
    <jsp:param name="current" value="admin"/>
</jsp:include>

<!-- 우측 본문 -->
<main>
    <div class="manage-header">
        <h1>모임방 회원 관리</h1>
        
        <form action="${pageContext.request.contextPath}/room/manage" method="get">
            <input type="hidden" name="roomId" value="${param.roomId}">
            <input type="hidden" name="page" value="1">
            
            <div class="search-bar">
                <input type="text" name="keyword" placeholder="닉네임 입력해주세요" 
                       value="${param.keyword}" id="searchInput">
                <button type="submit">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"></circle>
                        <path d="m21 21-4.35-4.35"></path>
                    </svg>
                </button>
            </div>
        </form>
    </div>

    <!-- 회원 목록 -->
    <div class="member-grid">
        <c:forEach var="member" items="${pageResult.data}" varStatus="status">
            <div class="member-card">
                <img src="${pageContext.request.contextPath}/upload/user/${member.userPhoto}" 
                     alt="${member.userNickname}" 
                     class="member-avatar"
                     onerror="this.src='${pageContext.request.contextPath}/images/default-avatar.png'">
                
                <div class="member-info">
                    <div class="member-name">${member.userNickname}</div>
                </div>
                
				 <c:choose>
				    <c:when test="${member.roomTier eq 'LEADER'}">
				        <button class="action-btn btn-leader">방장</button>
				    </c:when>
				    <c:when test="${member.roomTier eq 'PENDING'}">
				        <div class="btn-group">
				            <button class="action-btn btn-approve" onclick="approveMember(${member.userId}, ${member.roomId})">승인</button>
				            <button class="action-btn btn-reject" onclick="rejectMember(${member.userId}, ${member.roomId})">거절</button>
				        </div>
				    </c:when>
				    <c:when test="${member.roomTier eq 'MEMBER'}">
				        <button class="action-btn btn-kick" onclick="kickMember(${member.userId}, ${member.roomId})">추방</button>
				    </c:when>
				    <c:otherwise>
				        <button class="action-btn btn-promote">추방</button>
				    </c:otherwise>
				</c:choose>            
			</div>
        </c:forEach>
    </div>

    <!-- 페이지네이션 (조건 수정) -->
	<c:if test="${pageResult.totalPages >= 1}">
	    <div class="pagination">
	        <!-- 이전 페이지 -->
	        <c:choose>
	            <c:when test="${pageResult.currentPage > 1}">
	                <a href="?roomId=${param.roomId}&page=${pageResult.currentPage - 1}&keyword=${param.keyword}" class="prev">‹</a>
	            </c:when>
	            <c:otherwise>
	                <span class="prev disabled">‹</span>
	            </c:otherwise>
	        </c:choose>
	
	        <!-- 페이지 번호 -->
	        <c:set var="startPage" value="${pageResult.currentPage - 2 > 0 ? pageResult.currentPage - 2 : 1}" />
	        <c:set var="endPage" value="${startPage + 4 > pageResult.totalPages ? pageResult.totalPages : startPage + 4}" />
	        
	        <!-- 시작 페이지 조정 (끝에서 5개가 안 되는 경우) -->
	        <c:if test="${endPage - startPage < 4}">
	            <c:set var="startPage" value="${endPage - 4 > 0 ? endPage - 4 : 1}" />
	        </c:if>
	
	        <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
	            <c:choose>
	                <c:when test="${pageNum eq pageResult.currentPage}">
	                    <span class="active">${pageNum}</span>
	                </c:when>
	                <c:otherwise>
	                    <a href="?roomId=${param.roomId}&page=${pageNum}&keyword=${param.keyword}">${pageNum}</a>
	                </c:otherwise>
	            </c:choose>
	        </c:forEach>
	
	        <!-- 다음 페이지 -->
	        <c:choose>
	            <c:when test="${pageResult.currentPage < pageResult.totalPages}">
	                <a href="?roomId=${param.roomId}&page=${pageResult.currentPage + 1}&keyword=${param.keyword}" class="next">›</a>
	            </c:when>
	            <c:otherwise>
	                <span class="next disabled">›</span>
	            </c:otherwise>
	        </c:choose>
	    </div>
	</c:if>

    <!-- 검색 결과 정보 -->
    <c:if test="${not empty param.keyword}">
        <div style="text-align: center; margin-top: 20px; color: #666;">
            '<strong>${param.keyword}</strong>' 검색 결과: ${pageResult.totalCount}건
        </div>
    </c:if>
</main>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
// 엔터키 검색
document.getElementById('searchInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        this.closest('form').submit();
    }
});

function approveMember(userId, roomId){ // 승인
    if(confirm('이 회원을 승인하시겠습니까?')) {
        joinMemberManage(userId, roomId, "approve");
    }
}

function kickMember(userId, roomId){ // 추방
    if(confirm('이 회원을 추방하시겠습니까?')) {
        joinMemberManage(userId, roomId, "kick");
    }
}

function joinMemberManage(userId, roomId, type){
    $.ajax({
        url: "/joinroomusermanage.roomajax",
        data:{
            userId: userId,
            roomId: roomId,
            type: type
        },
        success: function(response) {
            alert('처리가 완료되었습니다.');
            
        },
        error: function() {
            alert('오류가 발생했습니다. 다시 시도해주세요.');
        }
    });
}


</script>
</body>
</html>