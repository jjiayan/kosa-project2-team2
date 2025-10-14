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
  --aside-w:420px;              /* 우측 ‘내가 쓴 글’ 폭 */
  /* mypageSidebar.jsp에서 전역으로 --snav-width가 240px(모바일 72px)로 설정됨 */
}

*{box-sizing:border-box}
html,body{
  margin:0; padding:0; background:var(--bg); color:var(--ink);
  font-family:"Noto Sans KR",system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue","Apple SD Gothic Neo","Malgun Gothic",sans-serif;
}
a{color:inherit;text-decoration:none}
a:hover{text-decoration:underline}

.page{display:flex; min-height:100vh}
.content{flex:1}

/* ====== 제목을 '화면 전체(사이드바 포함)' 기준 중앙 정렬 ====== */
.heading-wrap{
  margin-left: calc(var(--snav-width, 240px) * -1);
  width: calc(100% + var(--snav-width, 240px));
  padding: 28px 20px 0;
  text-align: center;
}
.heading{
  display:inline-block;
  font-size:42px; font-weight:900; color:#777;
  margin:24px 0 18px;
}

/* 화면이 좁아질 때 제목 래퍼 오버플로 방지 */
@media (max-width: 900px){
  .heading-wrap{
    margin-left: 0;
    width: 100%;
  }
}

/* ====== 본문 컨테이너 ====== */
.container{ padding: 0 20px 28px; }   /* 상단 패딩은 heading-wrap이 담당 */

.layout{
  display:grid;
  grid-template-columns: 1fr var(--aside-w);
  gap:18px; align-items:start;
  max-width: 1180px;
  margin: 0 auto;                    /* 본문 가운데 정렬 */
}
@media (max-width:1100px){
  .layout{ grid-template-columns: 1fr; }
}

/* ====== 카드 공통 ====== */
.card{background:var(--card); border-radius:16px; box-shadow:var(--shadow)}
.divider{height:1px; background:#e9e9e9}

/* ====== 프로필 카드 ====== */
.profile-card{padding:0; overflow:hidden}
.profile-title{
  padding:12px 18px; font-size:15px; font-weight:700; color:#333;
  border-bottom:1px solid #dadada; background:#fff;
}
/* 프로필 전체를 살짝 오른쪽으로 밀기 → left padding +12px */
.profile-body{
  position:relative;
  padding:20px 22px 18px 34px; /* T R B L (기존 L:22px → 34px) */
  background:#fff;
}

.profile-main{
  display:flex; gap:22px; align-items:flex-start;
  margin:16px 0;                 /* ← 요청: 위/아래 여백 추가 */
}

/* 전역 .avatar 규칙을 피하기 위한 전용 박스 */
.myp-avatar-box{
  flex:0 0 auto;
  width:140px; height:140px;           /* 초기값(아래 스크립트가 텍스트 높이에 맞춰 정사각형 재조정) */
  border:4px solid #f1f1f1; border-radius:9999px; overflow:hidden;
  background:#f7f7f7;
}
.myp-avatar{width:100% !important; height:100% !important; object-fit:cover; display:block}

/* 텍스트 블록 */
.name-big{font-size:36px; font-weight:900; line-height:1.2; margin:0 0 12px}

/* 라벨-값 간격 더 축소(요청) */
.mini-rows{
  display:grid;
  grid-template-columns:auto 1fr;
  gap: 2px 4px;                 /* 행 2px / 열 4px (더 빡빡하게) */
  font-size:16px;
  line-height:1.55;
  color:#333;
}
.mini-rows .k{
  width:60px;                   /* 라벨 폭도 소폭 축소 */
  color:#444;
  font-weight:800;
}

/* ‘내 정보 수정’ 버튼을 살짝 왼쪽으로(오른쪽 여백 확대) */
.edit-link{
  position:absolute; right:28px; bottom:12px;  /* 기존 right:14px → 28px */
  font-size:12px; color:#666;
}
.edit-link:hover{color:#333}

/* ====== 내가 참여한 방 ====== */
.rooms-card .head{padding:14px 18px; font-weight:800}
.rooms-grid{
  display:grid; grid-template-columns:repeat(2,minmax(0,1fr));
  gap:14px; padding:0 18px 18px;
}
@media (max-width:900px){ .rooms-grid{grid-template-columns:1fr 1fr} }
@media (max-width:720px){ .rooms-grid{grid-template-columns:1fr} }

.room{border:1px solid #f0f0f0; border-radius:14px; overflow:hidden; background:#fff}
.room .thumb{width:100%; aspect-ratio:16/9; object-fit:cover; background:#f7f7f7}
.room .meta{padding:10px 12px}
.room .title{font-weight:700; margin-bottom:6px; display:block; white-space:nowrap; overflow:hidden; text-overflow:ellipsis}
.room .sub{display:flex; gap:10px; color:#999; font-size:12px}

/* ====== 우측: 내가 쓴 글 ====== */
.side-card .head{padding:14px 18px; border-bottom:1px solid var(--line); font-weight:800}
.post-list{padding:6px 0}
.post{padding:10px 18px; border-top:1px solid var(--line)}
.post:first-child{border-top:0}
.empty{padding:30px 18px; color:#aaa; text-align:center}

  </style>
</head>
<body>

<jsp:include page="/include/nav.jsp" />

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="me"  value="${sessionScope.LOGIN_USER}" />

<div class="page with-sidebar">
  <!-- 좌측 사이드바는 그대로 -->
  <jsp:include page="/include/mypageSidebar.jsp">
    <jsp:param name="current" value="info"/>
  </jsp:include>

  <!-- 우측 컨텐츠 -->
  <div class="content">
    <!-- 제목: 사이드바 폭만큼 왼쪽으로 당겨서 화면 전체 기준 중앙 -->
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

          <!-- 내가 참여한 방 -->
          <section class="card rooms-card" style="margin-top:16px" aria-labelledby="rooms-title">
            <div class="head" id="rooms-title">내가 참여한 방</div>
            <div class="divider"></div>

            <c:choose>
              <c:when test="${empty myRooms}">
                <div class="empty">참여한 방이 없습니다.</div>
              </c:when>
              <c:otherwise>
                <div class="rooms-grid">
                  <c:forEach var="r" items="${myRooms}">
                    <article class="room">
                      <c:choose>
                        <c:when test="${empty r.thumbUrl}">
                          <img class="thumb" src="${ctx}/images/room-placeholder.jpg" alt="thumbnail"
                               onerror="this.onerror=null; this.src='${ctx}/images/room-placeholder.jpg';" />
                        </c:when>
                        <c:otherwise>
                          <img class="thumb" src="<c:url value='${r.thumbUrl}'/>" alt="thumbnail"
                               onerror="this.onerror=null; this.src='${ctx}/images/room-placeholder.jpg';" />
                        </c:otherwise>
                      </c:choose>
                      <div class="meta">
                        <a class="title" href="${ctx}${r.url}"><c:out value="${r.title}" /></a>
                        <div class="sub">
                          <span>member: <c:out value="${r.memberCount}" /></span>
                          <span>♥ <c:out value="${r.likeCount}" /></span>
                          <span><c:out value="${r.date}" /></span>
                        </div>
                      </div>
                    </article>
                  </c:forEach>
                </div>
              </c:otherwise>
            </c:choose>
          </section>
        </div>

        <!-- 우측: 내가 쓴 글 -->
        <aside class="card side-card" aria-labelledby="posts-title">
          <div class="head" id="posts-title">내가 쓴 글</div>
          <c:choose>
            <c:when test="${empty myPosts}">
              <div class="empty">작성한 글이 없습니다.</div>
            </c:when>
            <c:otherwise>
              <div class="post-list">
                <c:forEach var="p" items="${myPosts}">
                  <div class="post">
                    <a href="${ctx}${p.url}"><c:out value="${p.title}" /></a>
                  </div>
                </c:forEach>
              </div>
            </c:otherwise>
          </c:choose>
        </aside>
      </div>
    </div>
  </div>
</div>

<script>
  // 아바타 박스를 텍스트 블록의 총 높이에 맞춰 정사각형으로 조정
  (function(){
    const box  = document.getElementById('mypAvatarBox');
    const text = document.getElementById('mypTextBlock');

    function syncAvatar(){
      if(!box || !text) return;
      const h = Math.max(100, Math.round(text.getBoundingClientRect().height));
      box.style.height = h + 'px';
      box.style.width  = h + 'px';
    }
    window.addEventListener('load', syncAvatar);
    window.addEventListener('resize', () => {
      clearTimeout(window.__avtRaf); window.__avtRaf = setTimeout(syncAvatar, 80);
    });
    const mo = new MutationObserver(syncAvatar);
    mo.observe(text, {childList:true, subtree:true, characterData:true});
    setTimeout(syncAvatar, 150);
  })();

  // 연락처 표기: 숫자만 들어온 경우 010-1234-5678 같은 형식으로 표시
  (function(){
    const el = document.getElementById('phoneDisplay');
    if(!el) return;
    const raw = (el.textContent || '').replace(/[^0-9]/g,'');
    if(raw.length >= 9){
      // 02/지역번호 케이스는 프로젝트 룰에 맞춰 단순 3-4-4 패턴으로 처리
      const fmt =
        raw.length === 10
          ? raw.replace(/(\d{3})(\d{3,4})(\d{4})/, '$1-$2-$3')
          : raw.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
      el.textContent = fmt;
    }
  })();
</script>

</body>
</html>
