<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:url var="postsApi" value="/mypage/myposts.sync"/>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>마이페이지 · 내가 작성한 글</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<style>
:root{ --ink:#111; --muted:#6b7280; --ring:#e5e7eb; --primary:#ff6b6b; }
html,body{ margin:0; background:#fafafa; color:var(--ink); font-family:"Noto Sans KR","Pretendard",system-ui,sans-serif; }
.wrap{ display:grid; grid-template-columns:auto 1fr; }
main{ min-height:100vh; background:#fff; border-left:1px solid var(--ring); padding:28px; }
.page{ max-width:1160px; margin:0 auto; }

.toolbar{ display:flex; gap:12px; align-items:center; justify-content:flex-end; margin-bottom:14px; }
.search{ position:relative; margin-right:auto; width:360px; max-width:60vw; }
.search input{ width:100%; height:42px; padding:0 42px 0 14px; border:1px solid var(--ring); border-radius:999px; }
.search button{ position:absolute; right:8px; top:50%; transform:translateY(-50%); border:0; background:transparent; color:#9ca3af; }
.select select{ height:42px; padding:0 36px 0 14px; border:1px solid var(--ring); border-radius:999px; background:#fff; }

.sheet{ background:#fff; border:1px solid var(--ring); border-radius:18px; box-shadow:0 10px 30px rgba(0,0,0,.06); overflow:hidden; }

.table{ width:100%; border-collapse:separate; border-spacing:0; table-layout:fixed; }
.table thead th{ text-align:left; font-weight:800; font-size:15px; color:#374151; padding:18px 22px; background:#fafafa; overflow:hidden; white-space:nowrap; text-overflow:ellipsis; }
.table thead th.center{ text-align:center; }              /* 헤더 가운데 정렬 */
.table tbody td{
  padding:18px 22px; border-top:1px solid var(--ring); font-size:14px; color:#111;
  overflow:hidden !important; white-space:nowrap !important; text-overflow:ellipsis !important; word-break:keep-all !important;
}
.table tbody td.meta{ color:var(--muted); }
.table tbody td.center{ text-align:center; }              /* 바디 가운데 정렬 */

.table a.link{
  display:block; max-width:100%; overflow:hidden; white-space:nowrap; text-overflow:ellipsis;
  color:#111; text-decoration:none;
}
.table a.link:hover{ color:#ff6b6b; text-decoration:underline; }

.meta-bar{ display:flex; gap:14px; align-items:center; justify-content:space-between; margin:8px 2px 16px; color:var(--muted); font-size:13px; }
.meta-bar .count strong{ color:#111; }

.pagination{ display:flex; gap:12px; align-items:center; justify-content:center; margin-top:18px; }
.page-btn{ width:36px; height:36px; border-radius:50%; border:0; background:#fff; color:#374151; cursor:pointer; }
.page-btn:hover{ background:#f3f4f6; }
.page-btn.active{ background:#ff6b6b; color:#fff; font-weight:700; }
.page-btn.arrow{ font-size:18px; }
</style>
</head>
<body>
  <jsp:include page="/include/nav.jsp"/>
  <div class="wrap">
    <jsp:include page="/include/mypageSidebar.jsp">
      <jsp:param name="current" value="post"/>
    </jsp:include>

    <main>
      <div class="page">
        <div class="toolbar">
          <div class="search">
            <!-- 제목만 검색 -->
            <input id="q" type="text" placeholder="제목 검색"/>
            <button id="btnSearch" aria-label="search"><i class="fa-solid fa-magnifying-glass"></i></button>
          </div>

          <div class="select">
            <select id="size" title="페이지당 개수">
              <option value="10" selected>10개</option>
              <option value="20">20개</option>
              <option value="30">30개</option>
              <option value="50">50개</option>
            </select>
          </div>

          <div class="select">
            <select id="sort">
              <option value="recent" selected>최신순</option>
              <option value="old">오래된순</option>
            </select>
          </div>
        </div>

        <div class="meta-bar">
          <div class="count">총 <strong id="totalCnt">0</strong>건</div>
          <!-- 도움말 수정: 제목만 검색 -->
          <div class="help">※ 이 페이지 검색은 <strong>제목</strong>만 대상으로 합니다.</div>
        </div>

        <div class="sheet">
          <table class="table" aria-live="polite">
            <colgroup>
              <col style="width:45%">
              <col style="width:20%">
              <col style="width:10%">
              <col style="width:10%">
              <col style="width:15%">
            </colgroup>
            <thead>
              <tr>
                <th>제목</th>
                <th class="center">종목명</th>
                <th class="center">좋아요</th>
                <th class="center">조회수</th>
                <th class="center">생성일자</th>
              </tr>
            </thead>
            <tbody id="tbody"></tbody>
          </table>
        </div>

        <nav id="pagination" class="pagination" aria-label="페이지 이동"></nav>
      </div>
    </main>
  </div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
(function($){
  var POSTS_API='${postsApi}';
  var state = { q:'', sort:'recent', size:10, page:1 };

  // 세션 user_id를 링크에 사용할 수 있도록 안전하게 주입
  var UID_RAW = "<c:out value='${sessionScope.LOGIN_USER != null ? sessionScope.LOGIN_USER.user_id : ""}'/>";
  var UID = UID_RAW ? encodeURIComponent(UID_RAW) : '';

  function fetchPosts(){
    // (백엔드는 그대로 q를 사용) — 프론트는 제목 검색만 한다는 안내/UI만 제공
    return $.ajax({
      url: POSTS_API, method:'GET', dataType:'json',
      data:{ q:state.q, sort:state.sort, size:state.size, page:state.page }
    });
  }

  function esc(s){
    return String(s==null?'':s).replace(/[&<>"']/g,function(m){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'})[m];
    });
  }
  function number(v){ v = +v; return isFinite(v)? v : 0; }

  function renderRows(items){
    var $tb = $('#tbody').empty();
    if(!items || !items.length){
      $tb.append('<tr><td colspan="5" class="meta" style="text-align:center;padding:40px">표시할 게시글이 없습니다.</td></tr>');
      return;
    }

    items.forEach(function(x){
      var boardId = encodeURIComponent(x.boardId);
      var postUrl = '${ctx}/roomboarddetail.room?roomBoardId=' + boardId + (UID ? ('&userId=' + UID) : '');

      var tr = ''
       + '<tr>'
       +   '<td><a class="link" href="'+postUrl+'" title="'+esc(x.boardTitle)+'">'+esc(x.boardTitle)+'</a></td>'
       +   '<td class="meta center" title="'+esc(x.category||"")+'">'+esc(x.category||"-")+'</td>'
       +   '<td class="meta center">'+number(x.likeCount)+'</td>'
       +   '<td class="meta center">'+number(x.viewCount)+'</td>'
       +   '<td class="meta center">'+esc(x.createdAt||"")+'</td>'
       + '</tr>';
      $tb.append(tr);
    });
  }

  function renderPagination(total){
    $('#totalCnt').text(total||0);
    var $p = $('#pagination').empty();
    var totalPages = Math.max(1, Math.ceil((total||0) / state.size));
    var cur = state.page;

    function add(label,page,cls){
      var dis = (page<1 || page>totalPages || page===cur);
      var $b = $('<button type="button"/>')
        .addClass((cls||'page-btn')+(page===cur?' active':'' ))
        .text(label);
      if(dis) $b.prop('disabled', page===cur);
      $b.on('click', function(){ state.page=page; load(); });
      $p.append($b);
    }

    add('‹', cur-1, 'page-btn arrow');
    var w=5, s=Math.max(1,cur-Math.floor(w/2)), e=Math.min(totalPages, s+w-1); s=Math.max(1,e-w+1);
    for(var i=s;i<=e;i++) add(String(i), i, 'page-btn');
    add('›', cur+1, 'page-btn arrow');
  }

  function load(){
    fetchPosts().done(function(res){
      renderRows(res.items||[]);
      renderPagination(res.total||0);
    }).fail(function(xhr){
      if(xhr && xhr.status===401){
        location.href='${ctx}/login.user';
        return;
      }
      $('#tbody').html('<tr><td colspan="5" class="meta" style="text-align:center;padding:40px">목록을 불러오지 못했습니다.</td></tr>');
      $('#pagination').empty();
      $('#totalCnt').text(0);
    });
  }

  $('#btnSearch').on('click', function(){ state.q=$('#q').val().trim(); state.page=1; load(); });
  $('#q').on('keyup', function(e){ if(e.key==='Enter') $('#btnSearch').click(); });
  $('#sort').on('change', function(){ state.sort=$(this).val(); state.page=1; load(); });
  $('#size').on('change', function(){
    var v = parseInt($(this).val(),10);
    state.size = (v>0? v : 10);
    state.page = 1;
    load();
  });

  load();
})(jQuery);
</script>
</body>
</html>
