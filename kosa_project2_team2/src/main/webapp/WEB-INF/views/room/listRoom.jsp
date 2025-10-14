<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>스터디 리스트</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css"/>
  <style>
    .layout-wrap{ display:grid; grid-template-columns:auto 1fr; gap:0; align-items:flex-start; margin:0; padding:0 }
    main{ background:#fff; border-left:1px solid #e5e7eb; padding:24px 28px; min-height:100vh }
    .container{ max-width:1200px; margin:0 auto; padding:20px }
    header{ text-align:center; margin-bottom:40px; padding:20px 0 }
    header h1{ font-size:32px; font-weight:700; color:#333 }
    .search-section{ margin-bottom:40px }
    .search-bar{ position:relative; max-width:600px; margin:0 auto 20px }
    .search-bar input{ width:100%; padding:15px 50px 15px 20px; border:1px solid #ddd; border-radius:8px; font-size:16px; outline:none }
    .search-bar input:focus{ border-color:#ff6b6b }
    .search-btn{ position:absolute; right:10px; top:50%; transform:translateY(-50%); background:none; border:none; cursor:pointer; color:#666; padding:5px }
    .search-btn:hover{ color:#ff6b6b }
    .filter-section{ display:flex; gap:15px; justify-content:space-between; align-items:center; flex-wrap:wrap }
    .filter-left{ display:flex; gap:15px; flex-wrap:wrap }
    .filter-select{ padding:12px 40px 12px 20px; border:1px solid #ddd; border-radius:8px; font-size:16px; background:#fff; cursor:pointer; outline:none; appearance:none; min-width:150px }
    .create-study-btn{ padding:12px 30px; background:#ff6b6b; color:#fff; border:none; border-radius:8px; font-size:16px; font-weight:600; cursor:pointer; transition:.3s; margin-left:auto }
    .create-study-btn:hover{ background:#ff5252 }
    .study-grid{ display:grid; grid-template-columns:repeat(auto-fill, minmax(280px,1fr)); gap:25px; margin-bottom:60px }
    .study-card{ background:#fff; border-radius:12px; overflow:hidden; box-shadow:0 2px 8px rgba(0,0,0,.1); transition:.3s; cursor:pointer }
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
    @media (max-width:900px){
      .layout-wrap{ grid-template-columns:1fr }
      main{ border-left:none; border-top:1px solid #e5e7eb; padding:16px }
      .study-grid{ grid-template-columns:repeat(auto-fill, minmax(250px,1fr)); gap:20px }
      .filter-section{ flex-direction:column; width:100% }
      .filter-left{ width:100% }
      .filter-select{ width:100% }
      .create-study-btn{ width:100%; margin-left:0 }
    }
    @media (max-width:480px){ .study-grid{ grid-template-columns:1fr } }
  </style>
</head>
<body>
<jsp:include page="/include/nav.jsp" />
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="layout-wrap">
  <jsp:include page="/include/sidebar.jsp">
    <jsp:param name="current" value="home"/>
  </jsp:include>

  <main>
    <div class="container">
      <header><h1>스터디 리스트</h1></header>

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
  // JSP 값을 안전히 주입
  var CTX = '<c:out value="${pageContext.request.contextPath}" />';

  // HTML escape (JS에서 사용)
  function escapeHtml(s){
    return $('<div>').text(s==null?'':String(s)).html();
  }

  $(function(){
    console.log('[ready] CTX=', CTX);

    // 좋아요 토글
    window.toggleLike = function(btn, roomId){
      try{
        btn.classList.toggle('liked');
        var svg=btn.querySelector('svg');
        var countEl=btn.nextElementSibling;
        var cnt=parseInt(countEl.textContent||'0',10);
        if(btn.classList.contains('liked')){
          svg.setAttribute('fill','#ff6b6b'); svg.setAttribute('stroke','#ff6b6b'); cnt++;
        }else{
          svg.setAttribute('fill','none'); svg.setAttribute('stroke','currentColor'); cnt--;
        }
        countEl.textContent=cnt;

        fetch(CTX + '/room/like', {
          method:'POST',
          headers:{'Content-Type':'application/json'},
          body: JSON.stringify({ roomId:roomId, isLiked: btn.classList.contains('liked') })
        }).catch(function(e){ console.error('like error', e); });
      }catch(e){ console.error('toggleLike error', e); }
    };

    // 검색
    window.performSearch = function(){
      var keyword=$('#searchInput').val();
      var region1=$('#region1').val();
      var region2=$('#region2').val();
      console.log('[search]', keyword, region1, region2);

      $.ajax({
        url: CTX + '/searchroomlist.roomajax',
        dataType: 'json',
        data: { keyword:keyword, region1:region1, region2:region2 },
        success: function(res){
          console.log('[search] ok', res);
          updateStudyGrid((res && res.data) ? res.data : []);
          updatePagination(res);
        },
        error: function(xhr){ console.error('[search] error', xhr.status, xhr.responseText); }
      });
    };

    // 목록 렌더 (백틱/달러-중괄호 표기 없이 작성)
    window.updateStudyGrid = function(list){
      var $grid=$('.study-grid').empty();
      var userId='<c:out value="${sessionScope.LOGIN_USER.user_id}" />';
      if(!list || !list.length){
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
          +       '<img src="' + thumb + '" alt="' + escapeHtml(r.title||'') + '"/>'
          +       '<span class="study-status">' + escapeHtml(r.roomStatus||'') + '</span>'
          +     '</div>'
          +     '<div class="study-info">'
          +       '<h3 class="study-title">' + escapeHtml(r.title) + '</h3>'
          +       '<h4>' + escapeHtml(r.certName||'') + ' 자격증 스터디</h4>'
          +       '<p class="study-description">' + escapeHtml((r.parentRegion||'') + ' ' + (r.childRegion||'')) + '</p>'
          +       '<p class="study-date">' + escapeHtml(r.updatedAt||'') + '</p>'
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

    window.updatePagination = function(p){ /* 필요 시 구현 */ };
    window.goToPage = function(p){ location.href='?page='+p; };

    // 시(광역) 선택 → 구/군 목록 불러오기
    $(document).on('change', '#region1', function(){
      var parentId=$(this).val();
      var $r2=$('#region2').html('<option value="">구/군 선택</option>');
      console.log('[region1 change] parentId=', parentId);
      if(!parentId) return;

      $.ajax({
        url: CTX + '/getsubregion.roomajax',
        dataType: 'json',
        data: { parentId: parentId },
        success: function(list){
          console.log('[subregion] ok', list);
          $.each(list || [], function(_, item){
            $r2.append('<option value="' + item.subRegionId + '">' + item.subRegion + '</option>');
          });
        },
        error: function(xhr){ console.error('[subregion] error', xhr.status, xhr.responseText); }
      });
    });

    // 엔터로 검색
    $('#searchInput').on('keypress', function(e){
      if(e.key==='Enter') performSearch();
    });
  });
</script>

</body>
</html>
