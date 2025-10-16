<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>${roomDetail.title}</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css"/>
  <style>
    .layout-wrap{ display:grid; grid-template-columns:auto 1fr; gap:0; align-items:flex-start; margin:0; padding:0 }
    main{ background:#fff; border-left:1px solid #e5e7eb; padding:24px 28px; min-height:100vh }
    .main-container{ display:flex; gap:30px; max-width:1400px; margin:0 auto; position:relative }
    .content-section{ flex:1; text-align:center; display:flex; flex-direction:column; align-items:center }
    .content-title{ font-size:24px; font-weight:bold; margin-bottom:20px; color:#333 }
    .content-description{ font-size:16px; line-height:1.6; color:#666; max-width:500px }
    .info-section{ flex:0 0 300px; position:relative; padding-left:30px }
    .leader-info-box{ background:#fff; border-radius:12px; padding:20px; margin-top:20px; box-shadow:0 2px 8px rgba(0,0,0,.1); border:1px solid #e0e0e0; width:100% }
    .leader-header{ display:flex; align-items:center; margin-bottom:15px }
    .leader-icon{ width:35px; height:35px; background:linear-gradient(45deg,#ffa726,#ff9800); border-radius:50%; display:flex; align-items:center; justify-content:center; margin-right:10px; font-size:16px }
    .leader-title{ font-size:14px; font-weight:bold; color:#333 }
    .stats-container{ display:flex; align-items:center; gap:15px; margin:5px 0; font-size:14px }
    .star{ color:#ffa726; font-size:16px }
    .rating-number{ font-weight:bold; color:#333 }
    .rating-count{ background:#ff5252; color:#fff; padding:2px 6px; border-radius:10px; font-size:11px; font-weight:bold }
    .created-date{ color:#666; font-size:13px; margin:5px 0 }
    .like-section{ display:flex; align-items:center; gap:8px; margin:5px 0 }
    .like-btn{ background:none; border:none; cursor:pointer; font-size: 5px; padding:0; color:#ccc; display:inline-flex; align-items:center; justify-content:center; transition:.2s }
    .like-btn:hover{ color: #ff5a5f; }
    .like-btn.liked svg{ fill:#ff6b6b; stroke:#ff6b6b }
    .like-count{ font-size:14px; color:#666; font-weight:500 }
    .rating-btn{ padding:8px 12px; border:none; border-radius:8px; font-size:12px; font-weight:bold; cursor:pointer; background:linear-gradient(45deg,#ffa726,#ff9800); color:#fff; margin-left:auto }
    .rating-btn:hover{ transform:translateY(-1px); box-shadow:0 3px 8px rgba(255,167,38,.3) }
    .join-status-btn{ width:100%; padding:12px; border:none; border-radius:10px; font-size:14px; font-weight:bold; margin-top:15px; cursor:pointer }
    .joined-btn{ background:#6c757d; color:#fff }
    .join-btn{ background:linear-gradient(45deg,#ff6b9d,#ff8a80); color:#fff }
    .join-btn:hover{ transform:translateY(-1px); box-shadow:0 4px 12px rgba(255,107,157,.3) }
    @media (max-width:900px){ .layout-wrap{ grid-template-columns:1fr } main{ border-left:none; border-top:1px solid #e5e7eb } }
  </style>
</head>
<body>
<jsp:include page="/include/nav.jsp" />
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="layout-wrap">
  <jsp:include page="/include/sidebar.jsp">
    <jsp:param name="current" value="home"/>
  </jsp:include>

  <main>
  	<input type="hidden" id="roomId" name="roomId" value="${sessionScope.currentRoomId}">
    <input type="hidden" id="userId" name="userId" value="${sessionScope.LOGIN_USER.user_id}">
    <div class="main-container">
      <div class="content-section">
        <div class="content-title">${roomDetail.title}</div>
        <div class="content-description">
          <c:choose>
            <c:when test="${not empty roomDetail.content}">${roomDetail.content}</c:when>
            <c:otherwise>모임에 대한 상세한 설명이 여기에 들어갑니다.</c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="info-section">
        <div class="leader-info-box">
          <div class="leader-header">
            <div class="leader-icon">🐾</div>
            <div class="leader-title">방장 닉네임: ${roomDetail.userNickName}</div>
          </div>

          <div class="stats-container">
            <i class="fas fa-star star"></i>
            <span class="rating-number">${roomDetail.roomScore}</span><span class="rating-count">점</span>
            <c:if test="${roomDetail.joinUserStatus == 'LEADER' || roomDetail.joinUserStatus == 'MEMBER'}">
              <button class="rating-btn" onclick="openRatingModal()">별점주기</button>
            </c:if>
          </div>

          <div class="like-section">
            <button type="button" id="roomLikeBtn" class="like-btn" aria-pressed="false" title="좋아요">
			    <svg id="roomLikeIcon" xmlns="http://www.w3.org/2000/svg" width="20" height="20"
			         viewBox="0 0 24 24" fill="none" stroke="currentColor">
			      <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
			    </svg>
			    <span class="sr-only">좋아요</span>
			  </button>
			  <span id="roomLikeCount" class="like-count">0</span>
          </div>

          <div class="created-date">
            생성일: <fmt:formatDate value="${roomDetail.updatedAt}" pattern="yyyy.MM.dd"/>
          </div>

          <c:choose>
          	<c:when test="${empty sessionScope.LOGIN_USER or empty sessionScope.LOGIN_USER.user_id}">
              <button class="join-status-btn joined-btn" disabled>로그인을 해주세요.</button>
            </c:when>
            <c:when test="${roomDetail.joinUserStatus == 'LEADER' || roomDetail.joinUserStatus == 'MEMBER'}">
              <button class="join-status-btn joined-btn" disabled>참여중</button>
            </c:when>
            <c:when test="${roomDetail.joinUserStatus == 'PENDING'}">
              <button class="join-status-btn joined-btn" disabled>참가 대기중</button>
            </c:when>
            <c:otherwise>
              <button class="join-status-btn join-btn" id="joinroom" onclick="joinRoom()">참가하기</button>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </main>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
  const ctx='${ctx}';

  function toggleLike(button, roomId){
    button.classList.toggle('liked');
    const svg=button.querySelector('svg');
    const likeCount=button.nextElementSibling;
    const cur= parseInt(likeCount.textContent||'0',10);
    if(button.classList.contains('liked')){ svg.setAttribute('fill','#ff6b6b'); svg.setAttribute('stroke','#ff6b6b'); likeCount.textContent=cur+1; }
    else { svg.setAttribute('fill','none'); svg.setAttribute('stroke','currentColor'); likeCount.textContent=cur-1; }
    fetch(ctx + '/room/like', {
      method:'POST', headers:{'Content-Type':'application/json'},
      body: JSON.stringify({ roomId, isLiked: button.classList.contains('liked') })
    }).catch(()=>{});
  }

  function openRatingModal(){ alert('별점주기 기능을 구현해주세요!'); }
	
  function joinRoom(){
    if(!confirm('이 모임에 참가하시겠습니까?')) return;
    let roomId = $('#roomId').val();
   	let userId = $('#userId').val();
   	console.log("userId => " ,userId)
   	console.log("roomId => " ,roomId)
    $.ajax({
    	url: "/roomjoin.roomajax",
    	data: {
    		userId: userId,
    		roomId: roomId
    	},
    	success: function(res){
            console.log(res);
            // 성공시 버튼 상태 변경
            $('#joinroom')
                .removeClass('join-btn')
                .addClass('joined-btn')
                .text('참가 대기중')
                .prop('disabled', true);
            
            alert('참가 신청이 완료되었습니다.');
        },
        error: function(){
            alert('참가 신청 중 오류가 발생했습니다.');
        }
    	
    })
  }

 
  
  //===== 스터디 좋아요 =====
  //===== 좋아요 UI 헬퍼 =====
  function setRoomLikeVisual(isLiked){
    const $b=$('#roomLikeBtn'),$i=$('#roomLikeIcon');
    $b.toggleClass('liked',!!isLiked).attr('aria-pressed',!!isLiked);
    $i.attr('fill',isLiked?'#ff6b6b':'none').attr('stroke',isLiked?'#ff6b6b':'currentColor');
  }
  function setRoomLikeCount(n){$('#roomLikeCount').text(String(n||0));}

  // ===== 현재 상태/개수 조회 =====
  function loadRoomLike(){
    const id=$('#roomId').val(); if(!id) return;
    $.ajax({
      url:ctx+'/like/count.ajax',type:'GET',dataType:'json',
      data:{targetType:'ROOM',targetId:id},
      success:r=>{
        if(r&&r.success){setRoomLikeVisual(!!r.isLiked);setRoomLikeCount(r.likeCount||0);}
        else{setRoomLikeVisual(false);setRoomLikeCount(0);}
      },
      error:()=>{setRoomLikeVisual(false);setRoomLikeCount(0);}
    });
  }

  // ===== 토글 (좋아요 추가/취소) =====
  function likeRoom(){
    const id=$('#roomId').val(); if(!id) return;
    const $b=$('#roomLikeBtn'); $b.prop('disabled',true);
    $.ajax({
      url:ctx+'/like/action.ajax',type:'POST',dataType:'json',
      data:$.param({targetType:'ROOM',targetId:id}),
      success:r=>{
        if(r&&r.success){setRoomLikeVisual(!!r.isLiked);setRoomLikeCount(r.likeCount||0);}
        else{alert(r&&r.message?r.message:'좋아요 처리에 실패했습니다.');loadRoomLike();}
      },
      error:()=>{alert('네트워크 오류로 좋아요 처리에 실패했습니다.');loadRoomLike();},
      complete:()=>$b.prop('disabled',false)
    });
  }

  // ===== 초기 바인딩 =====
  $(function(){loadRoomLike();$('#roomLikeBtn').on('click',likeRoom);});

</script>
</body>
</html>
