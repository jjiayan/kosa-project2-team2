<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:url var="roomsApi" value="/mypage/rooms.sync" />
<c:url var="likeApi"  value="/room/like" />
<c:url var="placeholderImg" value="/images/room-placeholder.jpg" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>마이페이지 · 내가 참여한 모임</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="${ctx}/style/default.css"/>

<style>
  :root{
    --ink:#111; --muted:#6b7280; --ring:#e5e7eb; --bg:#fff;
    --primary:#ff6b6b; --primary-weak:#ffe3e3;
  }
  *{ box-sizing:border-box; }
  html,body{ margin:0; padding:0; background:#fafafa; color:var(--ink); font-family:"Noto Sans KR","Pretendard",system-ui,sans-serif; }

  .wrap{ display:grid; grid-template-columns:auto 1fr; gap:0; align-items:flex-start; }
  main{ min-height:100vh; background:#fff; border-left:1px solid var(--ring); padding:28px; }
  .page{ max-width:1160px; margin:0 auto; }

  /* 상단바(검색/정렬/탭) */
  .toolbar{
    display:flex; align-items:center; justify-content:space-between; gap:12px;
    padding:12px; border:1px solid var(--ring); border-radius:14px; background:#fff;
  }
  .toolbar-left{ display:flex; align-items:center; gap:12px; flex:1; min-width:0; }
  .search{ position:relative; width:360px; max-width:60vw; }
  .search input{
    width:100%; height:42px; padding:0 42px 0 14px; border:1px solid var(--ring); border-radius:999px; outline:none; font-size:14px; background:#fff;
  }
  .search input:focus{ border-color:var(--primary); }
  .search button{
    position:absolute; right:8px; top:50%; transform:translateY(-50%); width:28px; height:28px;
    border:0; background:transparent; color:#9ca3af; cursor:pointer;
  }
  .tabs{ display:flex; gap:8px; flex-wrap:wrap; }
  .tab{ border:0; height:38px; padding:0 14px; border-radius:999px; cursor:pointer; background:#f3f4f6; color:#374151; font-size:14px; }
  .tab.active{ background:var(--primary); color:#fff; box-shadow:0 4px 14px rgba(255,107,107,.25); }

  .toolbar-right{ display:flex; align-items:center; gap:10px; }
  .select{ position:relative; }
  .select select{ appearance:none; height:42px; padding:0 36px 0 14px; border:1px solid var(--ring); border-radius:999px; background:#fff; font-size:14px; }
  .select:after{ content:"▾"; position:absolute; right:12px; top:50%; transform:translateY(-50%); color:#888; font-size:12px; pointer-events:none; }

  .page-title{ font-size:22px; font-weight:800; margin:24px 6px 12px; color:#111; }

  /* 카드 그리드 */
  .grid{ display:grid; grid-template-columns: repeat(4, 1fr); gap:18px; align-content:start; }
  .card{ background:#fff; border:1px solid var(--ring); border-radius:12px; overflow:hidden; box-shadow:0 2px 6px rgba(0,0,0,.04); transition:transform .15s, box-shadow .15s; }
  .card:hover{ transform:translateY(-3px); box-shadow:0 6px 18px rgba(0,0,0,.08); }
  .thumb{ position:relative; height:120px; background:#eee; overflow:hidden; }
  .thumb img{ width:100%; height:100%; object-fit:cover; display:block; }
  .badge-top{ position:absolute; left:10px; top:10px; background:rgba(0,0,0,.55); color:#fff; border-radius:8px; padding:3px 7px; font-size:12px; }
  .body{ padding:10px 12px 8px; }
  .title-one{ font-size:14px; font-weight:700; color:#111; margin:2px 0 6px; overflow:hidden; white-space:nowrap; text-overflow:ellipsis; }
  .meta{ font-size:11.5px; color:#6b7280; line-height:1.5; }
  .foot{ display:flex; align-items:center; justify-content:space-between; gap:10px; padding:8px 12px 12px; font-size:12px; color:#6b7280; }
  .like{ display:flex; align-items:center; gap:6px; cursor:pointer; }
  .like.liked svg{ fill:var(--primary); stroke:var(--primary); }

  /* 페이지네이션 */
  .pagination{ display:flex; align-items:center; justify-content:center; gap:18px; margin-top:26px; }
  .page-btn{ width:36px; height:36px; border-radius:50%; display:flex; align-items:center; justify-content:center; border:0; background:#fff; color:#374151; cursor:pointer; }
  .page-btn:hover{ background:#f3f4f6; }
  .page-btn.active{ background:var(--primary); color:#fff; font-weight:700; }
  .page-btn.arrow{ font-size:18px; }

  /* 빈/로딩 상태 */
  .empty{ grid-column:1/-1; padding:40px; text-align:center; color:#6b7280 }
  .skeleton{ background:#f3f4f6; border:1px solid var(--ring); border-radius:12px; height:210px; animation: pulse 1.2s ease-in-out infinite; }
  @keyframes pulse { 0%{opacity:.9} 50%{opacity:.5} 100%{opacity:.9} }

  @media (max-width:1280px){ .grid{ grid-template-columns: repeat(3, 1fr); } }
  @media (max-width:900px){
    .wrap{ grid-template-columns: 1fr; }
    main{ border-left:none; border-top:1px solid var(--ring); padding:20px; }
    .grid{ grid-template-columns: repeat(2, 1fr); }
    .search{ width:100%; max-width:none; }
  }
  @media (max-width:560px){ .grid{ grid-template-columns: 1fr; } }
</style>
</head>
<body>
  <jsp:include page="/include/nav.jsp" />

  <div class="wrap">
    <!-- 사이드바 -->
    <jsp:include page="/include/mypageSidebar.jsp">
      <jsp:param name="current" value="group"/>
    </jsp:include>

    <main>
      <div class="page">
        <!-- 상단 툴바 -->
        <div class="toolbar">
          <div class="toolbar-left">
            <div class="search">
              <input id="q" type="text" placeholder="제목 검색" value="<c:out value='${param.q}'/>"/>
              <button id="btnSearch" aria-label="search"><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>
            <div class="tabs">
              <button class="tab ${empty param.tab or param.tab eq 'joined' ? 'active':''}" id="tab-joined" data-tab="joined">참여중</button>
              <button class="tab ${param.tab eq 'hosted' ? 'active':''}" id="tab-hosted" data-tab="hosted">내가 개설한 방</button>
            </div>
          </div>
          <div class="toolbar-right">
            <!-- 개수 선택 제거; 정렬만 유지 -->
            <div class="select">
              <select id="sort">
                <option value="recent" ${empty param.sort or param.sort eq 'recent' ? 'selected':''}>최신순</option>
                <option value="popular" ${param.sort eq 'popular' ? 'selected':''}>인기순</option>
                <option value="old" ${param.sort eq 'old' ? 'selected':''}>오래된순</option>
              </select>
            </div>
          </div>
        </div>

        <div class="page-title" id="pageTitle">
          <c:out value="${empty param.tab or param.tab eq 'joined' ? '참여한 모임' : '내가 개설한 모임'}"/>
        </div>

        <!-- 카드 그리드 / 페이지네이션 -->
        <section id="grid" class="grid" aria-live="polite"></section>
        <nav id="pagination" class="pagination" aria-label="페이지 이동"></nav>
      </div>
    </main>
  </div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
(function($){
  // JSP에서 주입된 값
  var CTX         = '${ctx}';
  var ROOMS_API   = '${roomsApi}';
  var LIKE_API    = '${likeApi}';
  var PLACEHOLDER = '${placeholderImg}';

  // 고정 페이지 크기(그리드 맞춤)
  var PAGE_SIZE = 12;

  // 상태
  var state = {
    tab  : ('${empty param.tab ? "joined" : param.tab}'),
    q    : $('#q').val().trim(),
    sort : $('#sort').val(),
    size : PAGE_SIZE,
    page : parseInt(('<c:out value="${empty param.page ? 1 : param.page}"/>'), 10) || 1
  };

  var $grid       = $('#grid');
  var $pagination = $('#pagination');
  var $title      = $('#pageTitle');

  // XSS 방지
  function escapeHtml(s){
    return String(s == null ? '' : s).replace(/[&<>"']/g, function(m){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'})[m];
    });
  }

  // 로딩 스켈레톤
  function renderSkeleton(){
    $grid.empty();
    for (var i=0;i<state.size;i++){
      $grid.append('<div class="skeleton"></div>');
    }
    $pagination.empty();
  }

  // ========= AJAX =========
  function fetchRooms(){
    return $.ajax({
      url: ROOMS_API,
      method: 'GET',
      dataType: 'json',
      data: {
        tab : state.tab,
        q   : state.q,
        sort: state.sort,
        size: state.size,
        page: state.page
      }
    });
  }

  function postLike(roomId, isLiked){
    return $.ajax({
      url: LIKE_API,
      method: 'POST',
      contentType: 'application/json; charset=UTF-8',
      data: JSON.stringify({ roomId: roomId, isLiked: isLiked })
    });
  }

  // ========= 렌더 =========
  function renderGrid(items){
    $grid.empty();

    if(!items || !items.length){
      $grid.html('<div class="empty">표시할 모임이 없습니다.</div>');
      return;
    }

    items.forEach(function(r){
      var thumb = r.thumbnailUrl
        ? (r.thumbnailUrl.charAt(0)==='/' ? (CTX + r.thumbnailUrl) : r.thumbnailUrl)
        : PLACEHOLDER;

      var href = CTX + '/roomdetail.room?roomId=' + r.roomId;

      var cardHtml = ''
        + '<div class="card">'
        +   '<a href="' + href + '" style="text-decoration:none;color:inherit">'
        +     '<div class="thumb">'
        +       '<img src="' + thumb + '" alt="">'
        +       '<div class="badge-top">' + escapeHtml(r.status || '진행중') + '</div>'
        +     '</div>'
        +     '<div class="body">'
        +       '<div class="title-one"></div>'
        +       '<div class="meta"></div>'
        +     '</div>'
        +   '</a>'
        +   '<div class="foot">'
        +     '<div>member: ' + (r.participantCount||0) + ' / ' + (r.maxParticipant||0) + '</div>'
        +     '<div class="like ' + (r.liked ? 'liked' : '') + '" data-id="' + r.roomId + '">'
        +       '<svg width="18" height="18" viewBox="0 0 24 24" fill="' + (r.liked ? '#ff6b6b' : 'none') + '" stroke="currentColor" stroke-width="2">'
        +         '<path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>'
        +       '</svg>'
        +       '<span>' + (r.likeCount||0) + '</span>'
        +     '</div>'
        +   '</div>'
        + '</div>';

      var $card = $(cardHtml);

      $card.find('.title-one').text(r.title || '');
      $card.find('.meta').html(
        escapeHtml(r.parentRegion || '') + '&nbsp;' +
        escapeHtml(r.childRegion  || '') + '<br>' +
        escapeHtml(r.certName     || '') + '<br>' +
        escapeHtml(r.updatedAt    || '')
      );

      $grid.append($card);
    });

    // 좋아요
    $grid.find('.like').off('click').on('click', function(e){
      e.preventDefault();
      e.stopPropagation();
      var $el = $(this);
      var roomId = parseInt($el.data('id'), 10);
      var willLike = !$el.hasClass('liked');

      $el.toggleClass('liked', willLike);
      $el.find('svg').attr('fill', willLike ? '#ff6b6b' : 'none');
      var $cnt = $el.find('span');
      $cnt.text((parseInt($cnt.text()||'0',10) + (willLike?1:-1)));

      postLike(roomId, willLike).fail(function(xhr){
        // 롤백
        $el.toggleClass('liked', !willLike);
        $el.find('svg').attr('fill', !willLike ? '#ff6b6b' : 'none');
        var $cnt2 = $el.find('span');
        $cnt2.text((parseInt($cnt2.text()||'0',10) + (willLike?-1:1)));
        if (xhr && xhr.status === 401) { alert('로그인이 필요합니다.'); }
      });
    });
  }

  function renderPagination(total){
    $pagination.empty();
    var totalPages = Math.max(1, Math.ceil(total / state.size));
    var cur = state.page;

    function add(label, page, cls){
      var disabled = (page < 1 || page > totalPages || page === cur);
      var klass = (cls || 'page-btn') + (page === cur ? ' active' : '');
      var $b = $('<button type="button"/>').addClass(klass).text(label);
      if (disabled) $b.prop('disabled', page === cur);
      $b.on('click', function(){ state.page = page; load(); });
      $pagination.append($b);
    }

    add('‹', cur-1, 'page-btn arrow');

    var windowSize = 5;
    var start = Math.max(1, cur - Math.floor(windowSize/2));
    var end   = Math.min(totalPages, start + windowSize - 1);
    start     = Math.max(1, end - windowSize + 1);

    for (var p = start; p <= end; p++) add(String(p), p, 'page-btn');

    add('›', cur+1, 'page-btn arrow');
  }

  // ========= 이벤트 =========
  $('#btnSearch').on('click', function(){
    state.q = $('#q').val().trim();
    state.page = 1;
    load();
  });
  $('#q').on('keyup', function(e){
    if(e.key === 'Enter'){ $('#btnSearch').click(); }
  });
  $('#sort').on('change', function(){
    state.sort = $(this).val();
    state.page = 1;
    load();
  });

  $('#tab-joined').on('click', function(){
    if (state.tab === 'joined') return;
    state.tab  = 'joined';
    state.page = 1;
    $title.text('참여한 모임');
    $('.tab').removeClass('active');
    $(this).addClass('active');
    load();
  });

  $('#tab-hosted').on('click', function(){
    if (state.tab === 'hosted') return;
    state.tab  = 'hosted';
    state.page = 1;
    $title.text('내가 개설한 모임');
    $('.tab').removeClass('active');
    $(this).addClass('active');
    load();
  });

  // ========= 로드 =========
  function load(){
    renderSkeleton();
    fetchRooms()
      .done(function(res){
        var total = (res && res.total) ? res.total : 0;
        var items = (res && res.items) ? res.items : [];
        renderGrid(items);
        renderPagination(total);

        var sp = new URLSearchParams({
          tab : state.tab,
          q   : state.q,
          sort: state.sort,
          page: String(state.page)
        });
        history.replaceState(null, '', '?' + sp.toString());
      })
      .fail(function(){
        $grid.html('<div class="empty">목록을 불러오지 못했습니다.</div>');
        $pagination.empty();
      });
  }

  load();
})(jQuery);
</script>
</body>
</html>
