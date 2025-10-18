=<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>스터디 리스트</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css"/>
  <style>
    .layout-wrap{
      display: block; 
      margin:0;
      padding:0;
    }
    main{
      background:#fff;
      padding:24px 28px;
      min-height:100vh;
    }
    .container{ max-width:1200px; margin:0 auto; padding:20px }

    .page-header{
      display:flex;
      justify-content:center;
      align-items:center;
      flex-direction:column;
      text-align:center;
      margin-bottom:40px;
      padding:20px 0;
    }
    .page-header h1{
      font-size:32px;
      font-weight:700;
      color:#333;
      text-align:center;
      margin:0;
    }

    .search-section{ margin-bottom:40px }
    .search-bar{ position:relative; max-width:600px; margin:0 auto 20px }
    .search-bar input{ width:100%; padding:15px 50px 15px 20px; border:1px solid #ddd; border-radius:8px; font-size:16px; outline:none }
    .search-bar input:focus{ border-color:#ff6b6b }
    .search-btn{ position:absolute; right:10px; top:50%; transform:translateY(-50%); background:none; border:none; cursor:pointer; color:#666; padding:5px }
    .search-btn:hover{ color:#ff6b6b }

    .filter-section{ display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; position: relative; }
    .filter-left{ display:flex; gap:15px; flex-wrap:wrap; margin-left:30px; }
    .filter-select{ padding:12px 40px 12px 20px; border:1px solid #ddd; border-radius:8px; font-size:16px; background:#fff; cursor:pointer; outline:none; appearance:none; min-width:150px }
    .create-study-btn{ padding:12px 30px; background:#ff6b6b; color:#fff; border:none; border-radius:8px; font-size:16px; font-weight:600; cursor:pointer; transition:.3s; margin-right:30px; }
    .create-study-btn:hover{ background:#ff5252 }

    .study-grid{
      display:grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 320px));
      gap:25px;
      margin-bottom:60px;
      justify-content:space-around;
    }
    .study-card{
      background:#fff;
      border-radius:12px;
      overflow:hidden;
      box-shadow:0 2px 8px rgba(0,0,0,.1);
      transition:.3s;
      cursor:pointer;
      width:100%;
      max-width:320px;
    }
    .study-card:hover{ transform:translateY(-5px); box-shadow:0 4px 16px rgba(0,0,0,.15) }

    .study-image{ position:relative; width:100%; height:180px; overflow:hidden; background:#ddd; display:flex; align-items:center; justify-content:center }
    .study-image img{ width:100%; height:100%; object-fit:cover }
    .study-status{ position:absolute; top:12px; left:12px; background:rgba(255,255,255,.95); color:#333; padding:6px 14px; border-radius:20px; font-size:14px; font-weight:600 }

    .study-info{ padding:20px }
    .study-title{ font-size:18px; font-weight:700; margin-bottom:8px; color:#333; overflow:hidden; text-overflow:ellipsis; display:-webkit-box; -webkit-line-clamp:1; -webkit-box-orient:vertical }
    .study-description{ font-size:14px; color:#666; margin-bottom:8px; overflow:hidden; text-overflow:ellipsis; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; min-height:40px }
    .study-date{ font-size:13px; color:#999; margin-bottom:15px }

    .study-footer{ display:flex; justify-content:space-between; align-items:center; padding-top:15px; border-top:1px solid #f0f0f0 }
    .member-count{ font-size:14px; color:#666 }

    .like-section-independent{ display:flex; align-items:center; gap:8px; padding:10px 20px 16px }
    .like-btn{ background:none; border:none; cursor:pointer; padding:5px; display:flex; align-items:center; justify-content:center; transition:.2s }
    .like-btn:hover{ transform:scale(1.1) }
    .like-btn.liked svg{ fill:#ff6b6b; stroke:#ff6b6b }
    .like-count{ font-size:14px; color:#666; font-weight:500 }

    .pagination{ display:flex; justify-content:center; align-items:center; gap:10px; margin:40px 0 }
    .page-arrow,.page-num{ display:flex; align-items:center; justify-content:center; width:40px; height:40px; border-radius:50%; color:#666; font-size:16px; border:none; background:#fff; cursor:pointer }
    .page-arrow:hover,.page-num:hover{ background:#f0f0f0 }
    .page-num.active{ background:#ff6b6b; color:#fff; font-weight:600 }
    
    .loading-spinner {
      display: none;
      text-align: center;
      padding: 50px;
    }
    .loading-spinner.show {
      display: block;
    }
  </style>
</head>
<body>
<jsp:include page="/include/nav.jsp" />
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="layout-wrap">
  <main>
    <div class="container">
      <header class="page-header">
        <h1>스터디 리스트</h1>
      </header>

      <input type="hidden" id="userId" name="userId" value="${sessionScope.LOGIN_USER.user_id}">
      
      <div class="search-section">
        <div class="search-bar">
          <input type="text" placeholder="모임방 제목으로 검색해주세요." id="searchInput"/>
          <button type="button" class="search-btn" onclick="performSearch()">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <circle cx="11" cy="11" r="8"></circle><path d="m21 21-4.35-4.35"></path>
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
            <button type="button" class="create-study-btn" onclick="location.href='${ctx}/insertForm.room'">스터디 생성</button>
          </c:if>
        </div>
      </div>

      <div class="loading-spinner" id="loadingSpinner">
        <p>로딩 중...</p>
      </div>

      <div class="study-grid">
        <c:forEach var="room" items="${pageResult.data}">
          <div class="study-card">
            <a href="${ctx}/roomdetail.room?roomId=${room.roomId}&userId=${sessionScope.LOGIN_USER.user_id}" class="study-link" style="text-decoration:none;color:inherit">
              <div class="study-image">
                <c:choose>
                  <c:when test="${not empty room.thumbnailUrl}">
                    <img src="${ctx}${room.thumbnailUrl}" alt="${room.title}"/>
                  </c:when>
                  <c:otherwise>
                    <img src="${ctx}/images/room-placeholder.jpg" alt="${room.title}"/>
                  </c:otherwise>
                </c:choose>
                <span class="study-status">${room.roomStatus}</span>
              </div>
              <div class="study-info">
                <h3 class="study-title">${room.title}</h3>
                <h4>${room.certName} 자격증 스터디</h4>
                <p class="study-description">${room.parentRegion} ${room.childRegion}</p>
                <p class="study-date">${room.updatedAt}</p>
                <div class="study-footer">
                  <span class="member-count">member: ${room.participantCount} / ${room.maxParticipant}</span>
                </div>
              </div>
            </a>
            <div class="like-section-independent">
              <button class="like-btn ${room.isLiked() ? 'liked' : ''}" onclick="toggleLike(this, ${room.roomId})">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="${room.isLiked() ? '#ff6b6b':'none'}" stroke="currentColor" stroke-width="2">
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

      <!-- 페이지네이션 (JavaScript로 렌더링) -->
      <div class="pagination" id="pagination"></div>

    </div>
  </main>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
  var CTX = '<c:out value="${pageContext.request.contextPath}" />';
  var currentPage = ${pageResult.currentPage};

  window.toggleLike = function(btn, roomId){
    btn.classList.toggle('liked');
    var svg=btn.querySelector('svg');
    var countEl=btn.nextElementSibling;
    var cnt=parseInt(countEl.textContent||'0',10);
    if(btn.classList.contains('liked')){
      svg.setAttribute('fill','#ff6b6b'); svg.setAttribute('stroke','#ff6b6b'); cnt++;
    } else {
      svg.setAttribute('fill','none'); svg.setAttribute('stroke','currentColor'); cnt--;
    }
    countEl.textContent=cnt;
    fetch(CTX + '/room/like', {
      method:'POST',
      headers:{'Content-Type':'application/json'},
      body: JSON.stringify({ roomId:roomId, isLiked: btn.classList.contains('liked') })
    }).catch(e=>console.error('like error', e));
  };

  function loadData(page = 1) {
    let keyword = $('#searchInput').val();
    let region1 = $('#region1').val();
    let region2 = $('#region2').val();
    let userId = $('#userId').val();
    
    $('#loadingSpinner').addClass('show');
    $('.study-grid').hide();
    
    $.ajax({
      url: CTX + '/searchroomlist.roomajax',
      dataType: 'json',
      data: { 
        keyword: keyword, 
        region1: region1, 
        region2: region2,
        page: page,
        userId: userId
      },
      success: function(res) {
        console.log("loadData response:", res);
        updateStudyGrid(res.data || []);
        renderPagination(res); // ✅ 페이지네이션 렌더링
        currentPage = res.currentPage || page;
        
        $('#loadingSpinner').removeClass('show');
        $('.study-grid').show();
      },
      error: function(xhr, status, error) {
        console.error('데이터 로드 오류:', error);
        $('#loadingSpinner').removeClass('show');
        $('.study-grid').show();
        alert('데이터를 불러오는 중 오류가 발생했습니다.');
      }
    });
  }

  window.performSearch = function() {
    loadData(1);
  };

  window.updateStudyGrid = function(list){
    var $grid=$('.study-grid').empty();
    var userId='<c:out value="${sessionScope.LOGIN_USER.user_id}" />';
    if(!list.length){
      $grid.append('<p style="text-align:center;padding:50px">검색 결과가 없습니다.</p>');
      return;
    }
    list.forEach(function(r){
      var thumb = r.thumbnailUrl ? (CTX + r.thumbnailUrl) : (CTX + '/images/room-placeholder.jpg');
      var liked = !!r.isLiked;
      var html = ''
        + '<div class="study-card">'
        +   '<a href="' + CTX + '/roomdetail.room?roomId=' + r.roomId + '&userId=' + userId + '" class="study-link" style="text-decoration:none;color:inherit">'
        +     '<div class="study-image">'
        +       '<img src="' + thumb + '" alt="' + (r.title||'') + '"/>'
        +       '<span class="study-status">' + (r.roomStatus||'') + '</span>'
        +     '</div>'
        +     '<div class="study-info">'
        +       '<h3 class="study-title">' + (r.title||'') + '</h3>'
        +       '<h4>' + (r.certName||'') + ' 자격증 스터디</h4>'
        +       '<p class="study-description">' + (r.parentRegion||'') + ' ' + (r.childRegion||'') + '</p>'
        +       '<p class="study-date">' + (r.updatedAt||'') + '</p>'
        +       '<div class="study-footer">'
        +         '<span class="member-count">member: ' + (r.participantCount||0) + ' / ' + (r.maxParticipant||0) + '</span>'
        +       '</div>'
        +     '</div>'
        +   '</a>'
        +   '<div class="like-section-independent">'
        +     '<button class="like-btn ' + (liked?'liked':'') + '" onclick="toggleLike(this,' + r.roomId + ')">'
        +       '<svg width="20" height="20" viewBox="0 0 24 24" fill="' + (liked? '#ff6b6b':'none') + '" stroke="currentColor" stroke-width="2">'
        +         '<path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 '
        +                    '5.5 0 0 0-7.78 7.78l1.06 1.06L12 '
        +                    '21.23l7.78-7.78 1.06-1.06a5.5 '
        +                    '5.5 0 0 0 0-7.78z"></path>'
        +       '</svg>'
        +     '</button>'
        +     '<span class="like-count">' + (r.likeCount||0) + '</span>'
        +   '</div>'
        + '</div>';
      $grid.append(html);
    });
  };

  // ✅ 페이지네이션 렌더링 함수 (5개씩 그룹으로)
  function renderPagination(res) {
    var currentPageNum = res.currentPage || 1;
    var totalPages = res.totalPages || 0;
    var pageGroupSize = 5;
    
    // 그룹 계산 (정수 나눗셈)
    var groupIndex = Math.floor((currentPageNum - 1) / pageGroupSize);
    var startPage = groupIndex * pageGroupSize + 1;
    var endPage = Math.min(startPage + pageGroupSize - 1, totalPages);
    
    var html = '';
    
    // 이전 페이지 버튼 (현재 페이지가 1보다 크면 표시)
    if (currentPageNum > 1) {
      html += '<button class="page-arrow" onclick="goToPage(' + (currentPageNum - 1) + ')">&lt;</button>';
    }
    
    // 페이지 번호 버튼
    for (var i = startPage; i <= endPage; i++) {
      var activeClass = currentPageNum === i ? 'active' : '';
      html += '<button class="page-num ' + activeClass + '" onclick="goToPage(' + i + ')">' + i + '</button>';
    }
    
    // 다음 페이지 버튼 (현재 페이지가 마지막보다 작으면 표시)
    if (currentPageNum < totalPages) {
      html += '<button class="page-arrow" onclick="goToPage(' + (currentPageNum + 1) + ')">&gt;</button>';
    }
    
    $('#pagination').html(html);
  }

  window.goToPage = function(page) {
    loadData(page);
  };

  $(document).on('change', '#region1', function(){
    var parentId=$(this).val();
    var $r2=$('#region2').html('<option value="">구/군 선택</option>');
    if(!parentId) return;
    $.ajax({
      url: CTX + '/getsubregion.roomajax',
      dataType: 'json',
      data: { parentId: parentId },
      success: function(list){
        $.each(list || [], function(_, item){
          $r2.append('<option value="' + item.subRegionId + '">' + item.subRegion + '</option>');
        });
      }
    });
  });

  $(document).on('change', '#region1, #region2', function(){
    loadData(1);
  });

  $('#searchInput').on('keypress', function(e){
    if(e.key==='Enter') performSearch();
  });

  // ✅ 페이지 로드시 초기 페이지네이션 렌더링
  $(document).ready(function(){
    renderPagination({
      currentPage: ${pageResult.currentPage},
      totalPages: ${pageResult.totalPages}
    });
  });
</script>
</body>
</html>