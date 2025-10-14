<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>내정보</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <style>
    :root{
      --ink:#222; --muted:#888; --line:#eee; --bg:#fafafa; --card:#fff;
      --shadow:0 10px 28px rgba(0,0,0,.08);
      --aside-w:420px;
      --accent:#2563eb;
    }
    *{box-sizing:border-box}
    html,body{ margin:0; padding:0; background:var(--bg); color:var(--ink);
      font-family:"Noto Sans KR",system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue","Apple SD Gothic Neo","Malgun Gothic",sans-serif; }
    a{color:inherit;text-decoration:none}
    a:hover{text-decoration:underline}

    .page{display:flex; min-height:100vh}
    .content{flex:1}

    /* 헤더/사이드 겹침 방지 */
    .mypage-sidebar{ position:relative; z-index:3; }
    .heading-wrap{ margin-left:0; width:100%; padding:28px 20px 0; text-align:center; position:relative; z-index:1; pointer-events:none;}
    .heading{ display:inline-block; font-size:42px; font-weight:900; color:#777; margin:24px 0 18px; pointer-events:auto; }

    /* 레이아웃 공통 */
    .container{ padding:0 20px 28px; }
    .layout{ display:grid; grid-template-columns:1fr var(--aside-w); gap:18px; align-items:start; max-width:1180px; margin:0 auto; }
    @media (max-width:1100px){ .layout{ grid-template-columns:1fr } }
    .card{background:var(--card); border-radius:16px; box-shadow:var(--shadow)}
    .divider{height:1px; background:#e9e9e9}

    /* 프로필 카드 */
    .profile-card{padding:0; overflow:hidden}
    .profile-title{padding:12px 18px; font-size:15px; font-weight:700; color:#333; border-bottom:1px solid #dadada; background:#fff}
    .profile-body{position:relative; padding:20px 22px 18px 34px; background:#fff}
    .profile-main{display:flex; gap:22px; align-items:flex-start; margin:16px 0}
    .myp-avatar-box{flex:0 0 auto; width:140px; height:140px; border:4px solid #f1f1f1; border-radius:9999px; overflow:hidden; background:#f7f7f7}
    .myp-avatar{width:100% !important; height:100% !important; object-fit:cover; display:block}
    .name-big{font-size:36px; font-weight:900; line-height:1.2; margin:0 0 12px}
    .mini-rows{display:grid; grid-template-columns:auto 1fr; gap:2px 4px; font-size:16px; line-height:1.55; color:#333}
    .mini-rows .k{width:60px; color:#444; font-weight:800}
    .edit-link{position:absolute; right:28px; bottom:12px; font-size:12px; color:#666}
    .edit-link:hover{color:#333}

    /* 내가 참여한 방 (compact) */
    .rooms-card .head{padding:14px 18px; font-weight:800}
    .rooms-card.compact .divider{ margin-bottom:10px; }

    .rooms-card.compact{
      --title: clamp(14px, 2.0vw, 18px);
      --lg:    clamp(12px, 1.6vw, 14px);
      --md:    clamp(11px, 1.4vw, 13px);
      --sm:    clamp(10px, 1.2vw, 12px);
    }
    .rooms-card.compact .rooms-grid{
      display:grid; grid-template-columns: repeat(3, minmax(0,1fr));
      gap:8px; padding:0 10px 4px;
    }
    @media (max-width:1024px){ .rooms-card.compact .rooms-grid{ grid-template-columns: repeat(2, minmax(0,1fr)); } }
    @media (max-width:640px){  .rooms-card.compact .rooms-grid{ grid-template-columns: 1fr; } }
    .rooms-card.compact .room{ border-radius:10px; border:1px solid #eee; background:#fff; box-shadow:0 1px 8px rgba(0,0,0,.045); overflow:hidden; }
    .rooms-card.compact .room .thumb-wrap{ position:relative; width:100%; background:#f6f6f6 }
    .rooms-card.compact .room .thumb{ width:100%; aspect-ratio: 2 / 1; object-fit:cover; display:block }
    .rooms-card.compact .room .title-overlay{
      position:absolute; left:8px; bottom:8px; font-size:var(--title); font-weight:800; color:#fff;
      max-width:86%; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; text-shadow:0 1px 2px rgba(0,0,0,.45);
    }
    .rooms-card.compact .room .meta{ padding:6px 8px 6px; }
    .rooms-card.compact .room .meta .region{ font-size:var(--lg);  margin-bottom:3px; color:#222 }
    .rooms-card.compact .room .meta .cert{   font-size:var(--lg);  margin-bottom:5px; color:#222 }
    .rooms-card.compact .room .meta .date{   font-size:var(--md);  margin-bottom:5px; color:#555 }
    .rooms-card.compact .room .meta .member{ font-size:var(--lg);  margin-bottom:5px; color:#222 }
    .rooms-card.compact .room .like-row{ font-size:var(--md); gap:6px; display:flex; align-items:center; color:#e24343; }
    .rooms-card.compact .room .like-icon{ display:inline-flex; align-items:center; justify-content:center; width:16px; height:16px; line-height:0; }
    .rooms-card.compact .room .like-icon svg{ stroke: currentColor; stroke-width: 2; stroke-linecap:round; stroke-linejoin:round; }
    .rooms-card .more-wrap{ display:flex; justify-content:flex-end; padding:6px 10px 10px; }
    .rooms-card .more-link{ font-size:12px; color:#666; }
    .rooms-card .more-link:hover{ color:#222; text-decoration:underline; }

    /* 오른쪽: 내가 쓴 글 (AJAX) */
    .side-card .head{padding:14px 18px; border-bottom:1px solid var(--line); font-weight:800}
    .post-list{padding:6px 0}
    .post{padding:10px 18px; border-top:1px solid var(--line)}
    .post:first-child{border-top:0}
    .post .p-title{ display:block; font-weight:800; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .post .p-room{
      display:inline-flex; align-items:center; gap:6px;
      font-size:12px; color:var(--accent); background:#eef2ff; border-radius:999px; padding:2px 8px; margin-top:6px;
      max-width:100%; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
    }
    .post .p-room svg{ width:14px; height:14px; stroke:currentColor; fill:none; stroke-width:2; }
    .post .p-meta{ display:flex; gap:12px; color:#888; font-size:12px; margin-top:6px; }
    .post .p-meta .i{ display:inline-flex; align-items:center; gap:6px; }
    .post .p-meta svg{ width:14px; height:14px; stroke:currentColor; fill:none; stroke-width:2; }

    .side-more{ display:flex; justify-content:flex-end; padding:6px 10px 10px; }
    .side-more a{ font-size:12px; color:#666; }
    .side-more a:hover{ color:#222; text-decoration:underline; }

    .empty{padding:30px 18px; color:#aaa; text-align:center}
  </style>

  <script src="https://code.jquery.com/jquery-3.7.1.min.js"
          integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
          crossorigin="anonymous"></script>
</head>
<body>

<jsp:include page="/include/nav.jsp" />

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="me"  value="${sessionScope.LOGIN_USER}" />

<div class="page with-sidebar">
  <div class="mypage-sidebar">
    <jsp:include page="/include/mypageSidebar.jsp">
      <jsp:param name="current" value="info"/>
    </jsp:include>
  </div>

  <div class="content">
    <div class="heading-wrap">
      <h1 class="heading">내정보</h1>
    </div>

    <div class="container">
      <div class="layout">
        <!-- 좌측: 프로필 + 내가 참여한 방 -->
        <div>
          <section class="card profile-card" aria-labelledby="profile-title">
            <div class="profile-title" id="profile-title">프로필</div>
            <div class="profile-body">
              <div class="profile-main">
                <div class="myp-avatar-box" id="mypAvatarBox">
                  <c:choose>
                    <c:when test="${empty me.user_photo}">
                      <img class="myp-avatar" src="${ctx}/images/default-avatar.png" alt="프로필"
                           onerror="this.onerror=null; this.src='${ctx}/images/default-avatar.png';" />
                    </c:when>
                    <c:otherwise>
                      <img class="myp-avatar" src="<c:url value='${me.user_photo}'/>" alt="프로필"
                           onerror="this.onerror=null; this.src='${ctx}/images/default-avatar.png';" />
                    </c:otherwise>
                  </c:choose>
                </div>

                <div id="mypTextBlock">
                  <div class="name-big">
                    <c:out value="${empty me.user_nickname ? me.user_login_id : me.user_nickname}" />
                  </div>
                  <div class="mini-rows">
                    <div class="k">연락처</div>
                    <div id="phoneDisplay"><c:out value="${empty me.user_phonenumber ? '-' : me.user_phonenumber}" /></div>
                    <div class="k">가입일</div>
                    <div>
                      <fmt:formatDate value="${me.createdAt}" pattern="yyyy-MM-dd" timeZone="Asia/Seoul"/>
                    </div>
                  </div>
                </div>
              </div>

              <a class="edit-link" href="${ctx}/mypage/edit.user">내 정보 수정</a>
            </div>
          </section>

          <!-- 내가 참여한 방 (AJAX) -->
          <section class="card rooms-card compact" style="margin-top:16px" aria-labelledby="rooms-title">
            <div class="head" id="rooms-title">내가 참여한 방</div>
            <div class="divider"></div>
            <div id="roomsArea"><div class="empty">로딩 중...</div></div>
            <div class="more-wrap">
              <a class="more-link" href="${ctx}/rooms/mine">더보기 »</a>
            </div>
          </section>
        </div>

        <!-- 우측: 내가 쓴 글 (AJAX) -->
        <aside class="card side-card" aria-labelledby="posts-title">
          <div class="head" id="posts-title">내가 쓴 글</div>
          <div id="myPostsArea"><div class="empty">로딩 중...</div></div>
          <div class="side-more"><a href="${ctx}/boards/mine">내가 쓴 글 보러가기 »</a></div>
        </aside>
      </div>
    </div>
  </div>
</div>

<script>
  // 아바타 정사각
  (function(){
    var box  = document.getElementById('mypAvatarBox');
    var text = document.getElementById('mypTextBlock');
    function syncAvatar(){
      if(!box || !text) return;
      var h = Math.max(100, Math.round(text.getBoundingClientRect().height));
      box.style.height = h + 'px';
      box.style.width  = h + 'px';
    }
    window.addEventListener('load', syncAvatar);
    window.addEventListener('resize', function(){
      clearTimeout(window.__avtRaf); window.__avtRaf = setTimeout(syncAvatar, 80);
    });
    var mo = new MutationObserver(syncAvatar);
    if (text) mo.observe(text, {childList:true, subtree:true, characterData:true});
    setTimeout(syncAvatar, 150);
  })();

  // 연락처 포맷
  (function(){
    var el = document.getElementById('phoneDisplay');
    if(!el) return;
    var raw = (el.textContent || '').replace(/[^0-9]/g,'');
    if(raw.length >= 9){
      var fmt = (raw.length === 10)
        ? raw.replace(/(\d{3})(\d{3,4})(\d{4})/, '$1-$2-$3')
        : raw.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
      el.textContent = fmt;
    }
  })();

  // 내가 참여한 방: AJAX
  (function($){
    var ctx = '${pageContext.request.contextPath}';
    var $area = $('#roomsArea');

    function esc(s){ return $('<div>').text(s == null ? '' : String(s)).html(); }

    function buildRoomCard(r){
      var thumb = r.thumbUrl ? (ctx + r.thumbUrl) : (ctx + '/images/room-placeholder.jpg');
      var url   = ctx + '/room/detail?roomId=' + (r.roomId || '');
      var title = esc(r.title);
      var regionLine = esc((r.parentRegion || '') + (r.childRegion ? ' ' + r.childRegion : ''));
      var certLine = esc((r.certName || '') + ' 공부방');
      var dateStr = esc(r.date || '');
      var members = (r.memberCount != null) ? r.memberCount : 0;
      var likes   = (r.likeCount != null) ? r.likeCount : 0;

      return ''+
      '<article class="room">'+
        '<a href="'+url+'">'+
          '<div class="thumb-wrap">'+
            '<img class="thumb" src="'+thumb+'" alt="thumbnail" onerror="this.onerror=null; this.src=\''+ctx+'/images/room-placeholder.jpg\';" />'+
            '<div class="title-overlay">'+ title +'</div>'+
          '</div>'+
        '</a>'+
        '<div class="meta">'+
          '<div class="region">'+ regionLine +'</div>'+
          '<div class="cert">'+ certLine +'</div>'+
          '<div class="date">'+ dateStr +'</div>'+
          '<div class="member">member: '+ members +'</div>'+
          '<div class="like-row">'+
            '<span class="like-icon" aria-hidden="true">'+
              '<svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor" stroke="none">'+
                '<path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>'+
              '</svg>'+
            '</span>'+
            '<span>'+ likes +'</span>'+
          '</div>'+
        '</div>'+
      '</article>';
    }

    function renderRooms(payload){
      var items = [];
      if ($.isArray(payload)) items = payload;
      else if (payload && $.isArray(payload.items)) items = payload.items;
      if (!items.length){ $('#roomsArea').html('<div class="empty">참여한 방이 없습니다.</div>'); return; }
      var cards = '';
      for (var i=0;i<items.length;i++) cards += buildRoomCard(items[i]);
      $area.html('<div class="rooms-grid">'+ cards +'</div>');
    }

    $.ajax({
      url: ctx + '/api/mypage/rooms',
      method: 'GET',
      data: { limit: 6, offset: 0 },
      success: renderRooms,
      error: function(){ $area.html('<div class="empty">불러오기에 실패했습니다.</div>'); }
    });
  })(window.jQuery);

  // 내가 쓴 글: AJAX (Gson JSON, 방 뱃지/링크 표시)
  (function($){
    var ctx = '${pageContext.request.contextPath}';
    var $area = $('#myPostsArea');

    function esc(t){ return $('<div>').text(t == null ? '' : String(t)).html(); }

    function postItem(p){
      var title = esc(p.title);
      var url   = ctx + (p.url || '#');
      var date  = esc(p.date || '');
      var replies = (p.replyCount != null ? p.replyCount : 0);
      var views   = (p.viewCount  != null ? p.viewCount  : 0);

      // 방 표시
      var roomTitle = esc(p.roomTitle || '');
      var roomUrl   = ctx + (p.roomUrl || '#');

      return '' +
      '<div class="post">' +
        '<a class="p-title" href="'+ url +'">'+ title +'</a>' +
        (roomTitle ? (
          '<a class="p-room" href="'+ roomUrl +'">' +
            '<svg viewBox="0 0 24 24"><path d="M3 9l9-6 9 6v9a3 3 0 0 1-3 3H6a3 3 0 0 1-3-3z"></path><path d="M9 22V12h6v10"></path></svg>' +
            roomTitle +
          '</a>'
        ) : '') +
        '<div class="p-meta">' +
          '<span class="i">' +
            '<svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>' +
            date +
          '</span>' +
          '<span class="i">' +
            '<svg viewBox="0 0 24 24"><path d="M21 15a4 4 0 0 1-4 4H7l-4 3V7a4 4 0 0 1 4-4h10a4 4 0 0 1 4 4z"></path></svg>' +
            replies +
          '</span>' +
          '<span class="i">' +
            '<svg viewBox="0 0 24 24"><path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7z"></path><circle cx="12" cy="12" r="3"></circle></svg>' +
            views +
          '</span>' +
        '</div>' +
      '</div>';
    }

    function render(list){
      if (!list || !list.length){ $area.html('<div class="empty">작성한 글이 없습니다.</div>'); return; }
      var html = '<div class="post-list">';
      for (var i=0;i<list.length;i++) html += postItem(list[i]);
      html += '</div>';
      $area.html(html);
    }

    $.ajax({
      url: ctx + '/api/mypage/posts',
      method: 'GET',
      dataType: 'json',
      data: { limit: 10 },
      success: render,
      error: function(){ $area.html('<div class="empty">불러오기에 실패했습니다.</div>'); }
    });
  })(window.jQuery);
</script>

</body>
</html>
