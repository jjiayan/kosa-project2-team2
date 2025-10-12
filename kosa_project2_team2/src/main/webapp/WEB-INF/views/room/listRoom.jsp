<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스터디 리스트</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica', 'Arial', sans-serif;
            background-color: #f5f5f5;
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        header {
            text-align: center;
            margin-bottom: 40px;
            padding: 20px 0;
        }
        header h1 {
            font-size: 32px;
            font-weight: 700;
            color: #333;
        }
        .search-section {
            margin-bottom: 40px;
        }
        .search-bar {
            position: relative;
            max-width: 600px;
            margin: 0 auto 20px;
        }
        .search-bar input {
            width: 100%;
            padding: 15px 50px 15px 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s;
        }
        .search-bar input:focus {
            border-color: #ff6b6b;
        }
        .search-btn {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            color: #666;
            padding: 5px;
        }
        .search-btn:hover {
            color: #ff6b6b;
        }
        .filter-section {
            display: flex;
            gap: 15px;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }
        .filter-left {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .filter-select {
            padding: 12px 40px 12px 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            background-color: white;
            cursor: pointer;
            outline: none;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23333' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            min-width: 150px;
        }
        .filter-select:hover {
            border-color: #ff6b6b;
        }
        .create-study-btn {
            padding: 12px 30px;
            background-color: #ff6b6b;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-left: auto;
        }
        .create-study-btn:hover {
            background-color: #ff5252;
        }
        .study-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 60px;
        }
        .study-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
        }
        .study-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
        }
        .study-image {
            position: relative;
            width: 100%;
            height: 180px;
            overflow: hidden;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .study-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .study-status {
            position: absolute;
            top: 12px;
            left: 12px;
            background-color: rgba(255, 255, 255, 0.95);
            color: #333;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        .study-info {
            padding: 20px;
        }
        .study-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 8px;
            color: #333;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 1;
            -webkit-box-orient: vertical;
        }
        .study-description {
            font-size: 14px;
            color: #666;
            margin-bottom: 8px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            min-height: 40px;
        }
        .study-date {
            font-size: 13px;
            color: #999;
            margin-bottom: 15px;
        }
        .study-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #f0f0f0;
        }
        .member-count {
            font-size: 14px;
            color: #666;
        }
        .like-section {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .like-btn {
            background: none;
            border: none;
            cursor: pointer;
            padding: 5px;
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
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 40px;
            margin-bottom: 40px;
        }
        .page-arrow,
        .page-num {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            text-decoration: none;
            color: #666;
            font-size: 16px;
            transition: all 0.3s;
            cursor: pointer;
            border: none;
            background: white;
        }
        .page-arrow:hover,
        .page-num:hover {
            background-color: #f0f0f0;
        }
        .page-num.active {
            background-color: #ff6b6b;
            color: white;
            font-weight: 600;
        }
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            header h1 {
                font-size: 24px;
            }
            .study-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 20px;
            }
            .filter-section {
                flex-direction: column;
                width: 100%;
            }
            .filter-left {
                width: 100%;
            }
            .filter-select {
                width: 100%;
            }
            .create-study-btn {
                width: 100%;
                margin-left: 0;
            }
        }
        @media (max-width: 480px) {
            .study-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>스터디 리스트</h1>
        </header>
        <div class="search-section">
            <div class="search-bar">
                <input type="text" placeholder="모임방 제목으로 검색해주세요." id="searchInput">
                <button type="button" class="search-btn" onclick="performSearch()">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <circle cx="11" cy="11" r="8"></circle>
                        <path d="m21 21-4.35-4.35"></path>
                    </svg>
                </button>
            </div>
            <div class="filter-section">
                <div class="filter-left">
                    <select class="filter-select" name="region1" id="region1">
                        <option value="">지역</option>
                        <c:forEach var="region" items="${pageResult.mainRegionList}">
                            <option value="${region.mainRegionId}">${region.mainRegion}</option>
                        </c:forEach>
                    </select>
                    <select class="filter-select" name="region2" id="region2">
                        <option value="">구/군 선택</option>
                    </select>
                </div>
                <button type="button" class="create-study-btn" onclick="location.href='${pageContext.request.contextPath}/insertForm.room'">
			스터디 생성
			</button>
            </div>
        </div>
        <div class="study-grid">
            <!-- PageResult를 사용한 실제 데이터 렌더링 -->
            <c:forEach var="room" items="${pageResult.data}">
            <a href="${pageContext.request.contextPath}/roomdetail.room?roomId=${room.roomId}" class="study-info" style="text-decoration:none; color:inherit;">
                <div class="study-card">
                    <div class="study-image">
                        <img src="${room.thumbnailUrl != null && room.thumbnailUrl != '' ? room.thumbnailUrl : '/upload/thumbnail/default-thumbnail.jpg'}" alt="${room.title}">
                        <span class="study-status">${room.roomStatus}</span>
                    </div>
                    <div class="study-info">
                        
					    <h3 class="study-title">${room.title}</h3>
					    <h4>${room.certName} 자격증 스터디</h4>
					    <p class="study-description">${room.parentRegion} ${room.childRegion}</p>
					    <p class="study-date">${room.updatedAt}</p>
					    <div class="study-footer">
					        <span class="member-count">member: ${room.participantCount} / ${room.maxParticipant}</span>
					        <div class="like-section">
					            <button class="like-btn" onclick="event.stopPropagation(); toggleLike(this)">
					                <svg width="20" height="20" viewBox="0 0 24 24" 
					                     fill="${room.isLiked() ? '#ff6b6b' : 'none'}" stroke="currentColor" stroke-width="2">
					                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 
					                             5.5 0 0 0-7.78 7.78l1.06 1.06L12 
					                             21.23l7.78-7.78 1.06-1.06a5.5 
					                             5.5 0 0 0 0-7.78z"></path>
					                </svg>
					            </button>
					            <span class="like-count">${room.likeCount}</span>
					        </div>
					    </div>
					
                    </div>
                </div>
                </a>
            </c:forEach>
        </div>
        <div class="pagination">
            <c:if test="${pageResult.currentPage > 1}">
                <button class="page-arrow" onclick="goToPage(${pageResult.currentPage - 1})">&lt;</button>
            </c:if>
            
            <c:forEach begin="1" end="${pageResult.totalPages}" var="i">
                <button class="page-num ${pageResult.currentPage == i ? 'active' : ''}" onclick="goToPage(${i})">${i}</button>
            </c:forEach>
            
            <c:if test="${pageResult.currentPage < pageResult.totalPages}">
                <button class="page-arrow" onclick="goToPage(${pageResult.currentPage + 1})">&gt;</button>
            </c:if>
        </div>
    </div>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        function toggleLike(button) {
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
        }
        function performSearch() {
            const searchInput = document.getElementById('searchInput');
            alert('검색어: ' + searchInput.value);
        }
        
        function goToPage(page) {
            location.href = '?page=' + page;
        }
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                performSearch();
            }
        });
        
        $('#region1').on('change',function(){
        	const parentId = $(this).val();
        	const region2Select = $('#region2');
        	// 초기화
            region2Select.html('<option value="">구/군 선택</option>');
            
            if (!parentId) {
                region2Select.html('<option value="">먼저 시/도를 선택하세요</option>');
                return;
            }
            
            $.ajax({
            	url: '/kosa_project2_team2/getsubregion.roomajax',
            	data: {parentId: parentId},
            	success: function(response){
            		$.each(response, function(index, item) {
                        region2Select.append(
                            '<option value="' + item.subRegionId + '">' + item.subRegion + '</option>'
                        );
                    })
            	}
            })
        	
        })
    </script>
</body>
</html>