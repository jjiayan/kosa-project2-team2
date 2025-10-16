<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!-- ★ 서버 매핑('/mypage/mycomments.sync') 과 일치시킴 -->
<c:url var="repliesApi" value="/mypage/mycomments.sync"/>

<%-- 세션/파라미터에서 userId 확보 (우선순위: 세션 → 요청 파라미터)
     프로젝트에서 세션 키가 LOGIN_USER(UserDto) 이므로 이에 맞춤 --%>
<c:set var="uid" value="${sessionScope.LOGIN_USER != null ? sessionScope.LOGIN_USER.user_id : param.userId}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>마이페이지 · 내가 작성한 댓글</title>
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

/* 고정 레이아웃 + 말줄임 */
.table{ width:100%; border-collapse:separate; border-spacing:0; table-layout:fixed; }
.table thead th{ text-align:left; font-weight:800; font-size:15px; color:#374151; padding:18px 22px; background:#fafafa; overflow:hidden; white-space:nowrap; text-overflow:ellipsis; }
.table tbody td{
  padding:18px 22px; border-top:1px solid var(--ring); font-size:14px; color:#111;
  overflow:hidden !important; white-space:nowrap !important; text-overflow:ellipsis !important; word-break:keep-all !important;
}
.table tbody td.meta{ color:var(--muted); }

/* 링크(제목/모임명) */
.table a.link{
  display:block; max-width:100%; overflow:hidden; white-space:nowrap; text-overflow:ellipsis;
  color:#111; text-decoration:none;
}
.table a.link:hover{ color:#ff6b6b; text-decoration:underline; }

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
      <jsp:param name="current" value="comment"/>
    </jsp:include>

    <main>
      <div class="page">
        <div class="toolbar">
          <div class="search">
            <input id="q" type="text" placeholder="제목·모임명·내용 검색"/>
            <button id="btnSearch" aria-label="search"><i class="fa-solid fa-magnifying-glass"></i></button>
          </div>
          <div class="select">
            <select id="sort">
              <option value="recent" selected>최신순</option>
              <option value="old">오래된순</option>
            </select>
          </div>
        </div>

        <div class="sheet">
          <table class="table" aria-live="polite">
            <colgroup>
              <col style="width:40%">
              <col style="width:35%">
              <col style="width:15%">
              <col style="width:10%">
            </colgroup>
            <thead>
              <tr>
                <th>제목</th>
                <th>내용</th>
                <th>모임명</th>
                <th>작성일자</th>
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
  var REPLIES_API='${repliesApi}';
  var state = { q:'', sort:'recent', size:10, page:1 };

  // JSP(EL) fallback userId (세션/파라미터) → 인코딩
  var GLOBAL_UID_RAW = '<c:out value="${uid}"/>';
  var GLOBAL_UID = GLOBAL_UID_RAW ? encodeURIComponent(GLOBAL_UID_RAW) : '';

  function fetchReplies(){
    return $.ajax({
      url: REPLIES_API, method:'GET', dataType:'json',
      data:{ q:state.q, sort:state.sort, size:state.size, page:state.page }
    });
  }

  function esc(s){
    return String(s==null?'':s).replace(/[&<>"']/g,function(m){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'})[m];
    });
  }

  function renderRows(items){
    var $tb = $('#tbody').empty();
    if(!items || !items.length){
      $tb.append('<tr><td colspan="4" class="meta" style="text-align:center;padding:40px">표시할 댓글이 없습니다.</td></tr>');
      return;
    }

    items.forEach(function(x){
      var boardId = encodeURIComponent(x.boardId);
      var roomId  = encodeURIComponent(x.roomId);
      var uid = x.userId != null ? encodeURIComponent(x.userId) : GLOBAL_UID;

      var postUrl = '${ctx}/roomboarddetail.room?roomBoardId=' + boardId + (uid ? '&userId=' + uid : '');
      var roomUrl = '${ctx}/roomdetail.room?roomId=' + roomId + (uid ? '&userId=' + uid : '');

      var tr = ''
       + '<tr>'
       +   '<td><a class="link" href="'+postUrl+'" title="'+esc(x.boardTitle)+'">'+esc(x.boardTitle)+'</a></td>'
       +   '<td class="meta" title="'+esc(x.content)+'">'+esc(x.content)+'</td>'
       +   '<td><a class="link" href="'+roomUrl+'" title="'+esc(x.roomTitle)+'">'+esc(x.roomTitle)+'</a></td>'
       +   '<td class="meta">'+esc(x.createdAt||'')+'</td>'
       + '</tr>';
      $tb.append(tr);
    });
  }

  function renderPagination(total){
    var $p = $('#pagination').empty();
    var totalPages = Math.max(1, Math.ceil(total / state.size));
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
    fetchReplies().done(function(res){
      renderRows(res.items||[]);
      renderPagination(res.total||0);
    }).fail(function(xhr){
      console.error('load replies failed', xhr && xhr.responseText);
      $('#tbody').html('<tr><td colspan="4" class="meta" style="text-align:center;padding:40px">목록을 불러오지 못했습니다.</td></tr>');
      $('#pagination').empty();
    });
  }

  // events
  $('#btnSearch').on('click', function(){ state.q=$('#q').val().trim(); state.page=1; load(); });
  $('#q').on('keyup', function(e){ if(e.key==='Enter') $('#btnSearch').click(); });
  $('#sort').on('change', function(){ state.sort=$(this).val(); state.page=1; load(); });

  load();
})(jQuery);
</script>
</body>
</html>
