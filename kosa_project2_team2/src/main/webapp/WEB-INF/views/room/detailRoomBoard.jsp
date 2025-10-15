<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>스터디 게시글</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css"/>
  <style>
    .layout-wrap{ display:grid; grid-template-columns:auto 1fr; gap:0; align-items:flex-start; margin:0; padding:0 }
    main{ background:#fff; border-left:1px solid #e5e7eb; padding:24px 28px; min-height:100vh }
    .post-detail-container{ max-width:800px; margin:0 auto; background:#fff; border-radius:20px; padding:30px; box-shadow:0 10px 30px rgba(0,0,0,.1), 0 1px 8px rgba(0,0,0,.06); border:1px solid rgba(0,0,0,.05) }
    .post-title{ font-size:24px; font-weight:bold; text-align:center; margin-bottom:30px; color:#333 }
    .post-subtitle{ font-size:18px; text-align:center; margin-bottom:20px; color:#666 }
    .post-info{ display:flex; align-items:center; justify-content:center; gap:15px; margin-bottom:30px; padding-bottom:20px; border-bottom:1px solid #e5e7eb }
    .author-profile{ display:flex; align-items:center; gap:8px }
    .author-avatar{ width:32px; height:32px; border-radius:50%; background:#fbbf24; display:flex; align-items:center; justify-content:center; font-size:18px; overflow:hidden }
    .profile-img{ width:100%; height:100%; object-fit:cover; border-radius:50% }
    .author-name{ font-weight:500; color:#333 }
    .post-meta,.view-count{ color:#666; font-size:14px }
    .like-section{ display:flex; align-items:center; gap:8px }
    .like-btn{ background:none; border:none; cursor:pointer; padding:2px; display:flex; align-items:center; justify-content:center; transition:.2s }
    .like-btn:hover{ transform:scale(1.1) }
    .like-btn.liked svg{ fill:#ff6b6b; stroke:#ff6b6b }
    .like-count{ color:#ef4444; font-size:14px; font-weight:500 }
    .action-buttons{ display:flex; gap:10px; margin-left:auto }
    .btn{ padding:8px 16px; border:none; border-radius:6px; font-size:12px; cursor:pointer }
    .btn-edit{ background:#f3f4f6; color:#374151 }
    .btn-delete{ background:#fef2f2; color:#dc2626 }
    .post-content{ line-height:1.8; font-size:16px; color:#333; margin-bottom:30px; min-height:300px; word-break:break-word; white-space:pre-wrap }
    @media (max-width:900px){
      .layout-wrap{ grid-template-columns:1fr }
      main{ border-left:none; border-top:1px solid #e5e7eb; padding:16px }
      .post-detail-container{ padding:20px; margin:0 10px }
      .post-info{ flex-direction:column; gap:10px }
      .action-buttons{ margin-left:0; justify-content:center }
    }
  </style>
</head>
<body>
<jsp:include page="/include/nav.jsp" />
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="layout-wrap">
  <jsp:include page="/include/sidebar.jsp">
    <jsp:param name="current" value="posts"/>
  </jsp:include>

  <main>
	<input type="hidden" id="roomBoardId" name="roomBoardId" value="${roomBoardDetail.roomBoardId}">
    <input type="hidden" id="roomId" name="roomId" value="${sessionScope.currentRoomId}">
    <input type="hidden" id="userId" name="userId" value="${sessionScope.LOGIN_USER.user_id}">
    <input type="hidden" id="roomBoardType" name="roomBoardType" value="${roomBoardType}">
    <div class="post-detail-container">
      <h1>
        <c:choose>
          <c:when test="${roomBoardType == 'NOTICE'}">스터디 공지</c:when>
          <c:otherwise>스터디 게시글</c:otherwise>
        </c:choose>
      </h1>

      <div class="post-subtitle">${roomBoardDetail.roomBoardTitle}</div>

      <div class="post-info">
        <div class="author-profile">
          <div class="author-avatar">
            <c:choose>
              <c:when test="${not empty roomBoardDetail.userPhoto}">
                <img src="${ctx}${roomBoardDetail.userPhoto}" alt="프로필 사진" class="profile-img"/>
              </c:when>
              <c:otherwise>🐴</c:otherwise>
            </c:choose>
          </div>
          <span class="author-name">${roomBoardDetail.userNickname}</span>
        </div>

        <div class="post-meta"><fmt:formatDate value="${roomBoardDetail.updatedAt}" pattern="yyyy.MM.dd. HH:mm"/></div>
        <div class="view-count">조회수 ${roomBoardDetail.roomBoardViewCnt}</div>

        <div class="like-section">
          <button class="like-btn ${roomBoardDetail.likeStatus ? 'liked' : ''}" onclick="toggleLike(this, ${roomBoardDetail.roomBoardId})">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="${roomBoardDetail.likeStatus ? '#ff6b6b' : 'none'}" stroke="currentColor" stroke-width="2">
              <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 
                       5.5 0 0 0-7.78 7.78l1.06 1.06L12 
                       21.23l7.78-7.78 1.06-1.06a5.5 
                       5.5 0 0 0 0-7.78z"></path>
            </svg>
          </button>
          <span class="like-count">${roomBoardDetail.likeCount}</span>
        </div>

        <div class="action-buttons">
          <c:if test="${roomBoardDetail.isMyPost()}">
            <button class="btn btn-edit" onclick="location.href='/roomboardupdateform.room?roomBoardId=${roomBoardDetail.roomBoardId}&roomBoardtype=${roomBoardType}'">수정</button>
            <button class="btn btn-delete" onclick="deletePost(${roomBoardDetail.roomBoardId})">삭제</button>
          </c:if>
        </div>
      </div>

      <div class="post-content">${roomBoardDetail.roomBoardContent}</div>

      <!-- 댓글 -->
      <jsp:include page="/WEB-INF/views/reply/replies.jsp">
        <jsp:param name="roomBoardId" value="${roomBoardDetail.roomBoardId}" />
      </jsp:include>
    </div>
  </main>
</div>

<script>
  const ctx='${ctx}';
  function toggleLike(button, roomBoardId){
    button.classList.toggle('liked');
    const svg=button.querySelector('svg');
    const cntEl=button.nextElementSibling;
    let cnt=parseInt(cntEl.textContent||'0',10);
    if(button.classList.contains('liked')){ svg.setAttribute('fill','#ff6b6b'); svg.setAttribute('stroke','#ff6b6b'); cnt++; }
    else { svg.setAttribute('fill','none'); svg.setAttribute('stroke','currentColor'); cnt--; }
    cntEl.textContent=cnt;

    fetch(ctx + '/roomboard/like', {
      method:'POST', headers:{'Content-Type':'application/json'},
      body: JSON.stringify({ roomBoardId, isLiked: button.classList.contains('liked') })
    }).catch(()=>{});
  }
  
  
  function deletePost(roomBoardId) {
      if(confirm('정말 삭제하시겠습니까?')) {
      	 	let roomId = $('#roomId').val();
           	let roomBoardType = $('#roomBoardType').val();
           	let userId = $('#userId').val();
           	
          $.ajax({
          	url: "/roomboarddelete.roomajax",
          	data:{
                roomBoardId: roomBoardId,
                roomBoardType: roomBoardType,
                roomId: roomId,
                userId: userId
            },
            success: function(response) {
            	if(roomBoardType === "GENERAL"){
            		alert('게시글이 삭제되었습니다.');
            		window.location.href = '/roomboardlist.room?roomId=' + roomId;
            	}else{
            		alert('공지글이 삭제되었습니다.');
            		window.location.href = '/roomboardnotice.room?roomId=' + roomId;
            	}
                
                
            }
          })
      }
  }
</script>
</body>
</html>
