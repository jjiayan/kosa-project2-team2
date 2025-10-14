<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스터디 리스트</title>
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
        
        /* 스터디 리스트 스타일 */
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
            position: relative; /* 좋아요 오버레이를 위해 추가 */
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
        
        /* 좋아요 자리 placeholder (레이아웃 유지용) */
        .like-placeholder {
            width: 60px; /* 좋아요 섹션과 비슷한 너비 */
            height: 24px;
        }
        
        /* 좋아요 섹션을 원래 위치에 오버레이 */
        .like-section-overlay {
            position: absolute;
            bottom: 20px;
            right: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
            z-index: 10; /* 클릭 가능하도록 위에 배치 */
        }
        
        .like-section-overlay .like-btn {
            background: none;
            border: none;
            cursor: pointer;
            padding: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.2s;
        }
        
        .like-section-overlay .like-btn:hover {
            transform: scale(1.1);
        }
        
        .like-section-overlay .like-btn.liked svg {
            fill: #ff6b6b;
            stroke: #ff6b6b;
        }
        
        .like-section-overlay .like-count {
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
                        <c:if test="${not empty sessionScope.LOGIN_USER.user_id}">
                            <button type="button" class="create-study-btn" onclick="location.href='${pageContext.request.contextPath}/insertForm.room'">
                                스터디 생성
                            </button>
                        </c:if>
                    </div>
                </div>
                
                <div class="study-grid">
                    <!-- PageResult를 사용한 실제 데이터 렌더링 -->
                    <c:forEach var="room" items="${pageResult.data}">
                        <div class="study-card">
                            <!-- 카드 내용 (좋아요 섹션 제외한 나머지) -->
                            <a href="${pageContext.request.contextPath}/roomdetail.room?roomId=${room.roomId}&userId=${sessionScope.LOGIN_USER.user_id}" 
                               class="study-link" style="text-decoration:none; color:inherit;">
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
                                        <!-- 좋아요 자리는 빈 공간으로 유지 -->
                                        <div class="like-placeholder"></div>
                                    </div>
                                </div>
                            </a>
                            
                            <!-- 좋아요 섹션을 원래 위치에 absolute로 배치 -->
                            <div class="like-section-overlay">
                                <button class="like-btn ${room.isLiked() ? 'liked' : ''}" 
                                        onclick="toggleLike(this, ${room.roomId})">
                                    <svg width="20" height="20" viewBox="0 0 24 24" 
                                         fill="${room.isLiked() ? '#ff6b6b' : 'none'}" 
                                         stroke="currentColor" stroke-width="2">
                                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 
                                                 5.5 0 0 0-7.78 7.78l1.06 1.06L12 
                                                 21.23l7.78-7.78 1.06-1.06a5.5 
                                                 5.5 0 0 0 0-7.78z"></path>
                                    </svg>
                                </button>
                                <span class="like-count">${room.likeCount}</span>
                            </div>
                        </div>
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
        </main>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        // 좋아요 토글 함수 수정 - 실제 서버 통신 추가
        function toggleLike(button, roomId) {
            // 로그인 체크
            const userId = '${sessionScope.LOGIN_USER != null ? sessionScope.LOGIN_USER.user_id : ""}';
            if (!userId) {
                alert('로그인이 필요합니다.');
                return;
            }
            
            // 서버에 좋아요 요청
            $.ajax({
                url: '/togglelike.roomajax',
                type: 'POST',
                data: {
                    roomId: roomId,
                    userId: userId
                },
                success: function(response) {
                    // 서버 응답에 따라 UI 업데이트
                    const svg = button.querySelector('svg');
                    const likeCount = button.nextElementSibling;
                    
                    if (response.isLiked) {
                        button.classList.add('liked');
                        svg.setAttribute('fill', '#ff6b6b');
                        svg.setAttribute('stroke', '#ff6b6b');
                    } else {
                        button.classList.remove('liked');
                        svg.setAttribute('fill', 'none');
                        svg.setAttribute('stroke', 'currentColor');
                    }
                    
                    likeCount.textContent = response.likeCount;
                },
                error: function() {
                    alert('좋아요 처리 중 오류가 발생했습니다.');
                }
            });
        }
        
        // 검색
        function performSearch() {
            let keyword = $('#searchInput').val();
            let region1 = $('#region1').val();
            let region2 = $('#region2').val();

            $.ajax({
                url: '/searchroomlist.roomajax',
                data: {
                    keyword: keyword,
                    region1: region1,
                    region2: region2
                },
                success: function(response) {
                    console.log(response);
                    
                    // 1. 검색어 입력창에 값 유지
                    $('#searchInput').val(response.keyword);
                    
                    // 2. 지역 선택 상태 유지
                    $('#region1').val(response.si);
                    if(response.siGun) {
                        loadSubRegions(response.si, response.siGun);
                    }
                    
                    // 3. 스터디 목록 업데이트
                    updateStudyGrid(response.data);
                    
                    // 4. 페이지네이션 업데이트
                    updatePagination(response);
                }
            });
        }

        // 스터디 목록 업데이트 함수 수정
        function updateStudyGrid(studyList) {
            let studyGrid = $('.study-grid');
            studyGrid.empty();
            
            if(studyList.length === 0) {
                studyGrid.append('<p style="text-align:center; padding:50px;">검색 결과가 없습니다.</p>');
                return;
            }
            
            let userId = '${sessionScope.LOGIN_USER != null ? sessionScope.LOGIN_USER.user_id : ""}';
            
            studyList.forEach(function(room, index) {
                let thumbnailUrl = (room.thumbnailUrl != null && room.thumbnailUrl != '') ? room.thumbnailUrl : '/upload/thumbnail/default-thumbnail.jpg';
                let fillColor = room.isLiked ? '#ff6b6b' : 'none';
                let likedClass = room.isLiked ? 'liked' : '';
                
                let studyCard = 
                    '<div class="study-card">' +
                        '<a href="${pageContext.request.contextPath}/roomdetail.room?roomId=' + room.roomId + '&userId=' + userId + '" class="study-link" style="text-decoration:none; color:inherit;">' +
                            '<div class="study-image">' +
                                '<img src="' + thumbnailUrl + '" alt="' + room.title + '">' +
                                '<span class="study-status">' + room.roomStatus + '</span>' +
                            '</div>' +
                            '<div class="study-info">' +
                                '<h3 class="study-title">' + room.title + '</h3>' +
                                '<h4>' + room.certName + ' 자격증 스터디</h4>' +
                                '<p class="study-description">' + room.parentRegion + ' ' + room.childRegion + '</p>' +
                                '<p class="study-date">' + room.updatedAt + '</p>' +
                                '<div class="study-footer">' +
                                    '<span class="member-count">member: ' + room.participantCount + ' / ' + room.maxParticipant + '</span>' +
                                    '<div class="like-placeholder"></div>' +
                                '</div>' +
                            '</div>' +
                        '</a>' +
                        '<div class="like-section-overlay">' +
                            '<button class="like-btn ' + likedClass + '" onclick="toggleLike(this, ' + room.roomId + ')">' +
                                '<svg width="20" height="20" viewBox="0 0 24 24" ' +
                                     'fill="' + fillColor + '" stroke="currentColor" stroke-width="2">' +
                                    '<path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 ' +
                                             '5.5 0 0 0-7.78 7.78l1.06 1.06L12 ' +
                                             '21.23l7.78-7.78 1.06-1.06a5.5 ' +
                                             '5.5 0 0 0 0-7.78z"></path>' +
                                '</svg>' +
                            '</button>' +
                            '<span class="like-count">' + room.likeCount + '</span>' +
                        '</div>' +
                    '</div>';
                
                studyGrid.append(studyCard);
            });
        }

        function loadSubRegions(parentId, selectedSubId) {
            if (!parentId) return;
            
            const region2Select = $('#region2');
            
            $.ajax({
                url: '/getsubregion.roomajax',
                data: {parentId: parentId},
                success: function(response) {
                    region2Select.html('<option value="">구/군 선택</option>');
                    
                    $.each(response, function(index, item) {
                        const selected = (selectedSubId && selectedSubId == item.subRegionId) ? 'selected' : '';
                        region2Select.append(
                            '<option value="' + item.subRegionId + '" ' + selected + '>' + item.subRegion + '</option>'
                        );
                    });
                }
            });
        }

        // 페이지네이션 업데이트 함수
        function updatePagination(pageResult) {
            let pagination = $('.pagination');
            pagination.empty();
            
            // 이전 버튼
            if(pageResult.currentPage > 1) {
                pagination.append(`<button class="page-arrow" onclick="goToPage(${pageResult.currentPage - 1})">&lt;</button>`);
            }
            
            // 페이지 번호들
            for(let i = 1; i <= pageResult.totalPages; i++) {
                let activeClass = pageResult.currentPage == i ? 'active' : '';
                pagination.append(`<button class="page-num ${activeClass}" onclick="goToPage(${i})">${i}</button>`);
            }
            
            // 다음 버튼
            if(pageResult.currentPage < pageResult.totalPages) {
                pagination.append(`<button class="page-arrow" onclick="goToPage(${pageResult.currentPage + 1})">&gt;</button>`);
            }
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
                url: '/getsubregion.roomajax',
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