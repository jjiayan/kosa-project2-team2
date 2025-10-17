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
    
    /* 별점 모달 스타일 */
    .rating-modal {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.5);
      z-index: 1000;
      justify-content: center;
      align-items: center;
    }
    
    .rating-modal.show {
      display: flex;
    }
    
    .rating-modal-content {
      background: white;
      border-radius: 12px;
      padding: 30px;
      width: 400px;
      max-width: 90%;
      text-align: center;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
    }
    
    .rating-modal-title {
      font-size: 20px;
      font-weight: bold;
      margin-bottom: 20px;
      color: #333;
    }
    
    .star-rating {
      display: flex;
      justify-content: center;
      gap: 10px;
      margin: 20px 0;
    }
    
    .star-item {
      font-size: 40px;
      cursor: pointer;
      color: #ddd;
      transition: color 0.2s, transform 0.2s;
    }
    
    .star-item:hover {
      transform: scale(1.1);
    }
    
    .star-item.active {
      color: #ffa726;
    }
    
    .rating-text {
      margin: 20px 0;
      font-size: 16px;
      color: #666;
      min-height: 24px;
    }
    
    .rating-modal-buttons {
      display: flex;
      gap: 10px;
      justify-content: center;
      margin-top: 20px;
    }
    
    .modal-btn {
      padding: 10px 20px;
      border: none;
      border-radius: 8px;
      font-size: 14px;
      font-weight: bold;
      cursor: pointer;
      transition: all 0.3s;
    }
    
    .submit-btn {
      background: linear-gradient(45deg, #ffa726, #ff9800);
      color: white;
    }
    
    .submit-btn:hover {
      transform: translateY(-1px);
      box-shadow: 0 3px 8px rgba(255, 167, 38, 0.3);
    }
    
    .submit-btn:disabled {
      background: #ccc;
      cursor: not-allowed;
      transform: none;
      box-shadow: none;
    }
    
    .cancel-btn {
      background: #6c757d;
      color: white;
    }
    
    .cancel-btn:hover {
      background: #5a6268;
    }
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
            <c:if test="${(roomDetail.joinUserStatus == 'LEADER' || roomDetail.joinUserStatus == 'MEMBER') && roomDetail.isScore()}">
			    <button class="rating-btn" onclick="openRatingModal()">별점주기</button>
			</c:if>
			
			<!-- 별점을 이미 준 상태 -->
			<c:if test="${(roomDetail.joinUserStatus == 'LEADER' || roomDetail.joinUserStatus == 'MEMBER') && !roomDetail.isScore()}">
			    <button class="rating-btn rated" onclick="editRatingModal()">별점완료</button>
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

<!-- 별점 모달 -->
<div class="rating-modal" id="ratingModal">
  <div class="rating-modal-content">
    <h3 class="rating-modal-title">스터디 별점 주기</h3>
    <p>이 스터디는 어떠셨나요?</p>
    
    <div class="star-rating" id="starRating">
      <span class="star-item" data-rating="1">★</span>
      <span class="star-item" data-rating="2">★</span>
      <span class="star-item" data-rating="3">★</span>
      <span class="star-item" data-rating="4">★</span>
      <span class="star-item" data-rating="5">★</span>
    </div>
    
    <div class="rating-text" id="ratingText">별점을 선택해주세요</div>
    
    <div class="rating-modal-buttons">
      <button class="modal-btn cancel-btn" onclick="closeRatingModal()">취소</button>
      <button class="modal-btn submit-btn" id="submitRating" onclick="submitRating()" disabled>별점 주기</button>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
  const ctx='${ctx}';
  let selectedRating = 0; // 선택된 별점 저장

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

  // 별점 모달 열기
  function openRatingModal() {
    document.getElementById('ratingModal').classList.add('show');
    resetRating(); // 모달 열 때마다 초기화
  }

  // 별점 모달 닫기
  function closeRatingModal() {
    document.getElementById('ratingModal').classList.remove('show');
    resetRating();
  }

  // 별점 초기화
  function resetRating() {
    selectedRating = 0;
    document.querySelectorAll('.star-item').forEach(star => {
      star.classList.remove('active');
    });
    document.getElementById('ratingText').textContent = '별점을 선택해주세요';
    document.getElementById('submitRating').disabled = true;
  }

  // 별점 텍스트 매핑
  const ratingTexts = {
    1: '⭐ 아쉬워요',
    2: '⭐⭐ 그저 그래요',
    3: '⭐⭐⭐ 보통이에요',
    4: '⭐⭐⭐⭐ 좋아요',
    5: '⭐⭐⭐⭐⭐ 최고예요!'
  };

  // 별점 선택 이벤트
  document.querySelectorAll('.star-item').forEach((star, index) => {
    star.addEventListener('click', function() {
      const rating = parseInt(this.dataset.rating);
      selectedRating = rating;
     
      // 선택된 별까지 active 클래스 추가
      document.querySelectorAll('.star-item').forEach((item, i) => {
        if (i < rating) {
          item.classList.add('active');
        } else {
          item.classList.remove('active');
        }
      });
      
      // 별점 텍스트 업데이트
      document.getElementById('ratingText').textContent = ratingTexts[rating];
      
      // 제출 버튼 활성화
      document.getElementById('submitRating').disabled = false;
    });
    
    // 호버 효과
    star.addEventListener('mouseenter', function() {
      const rating = parseInt(this.dataset.rating);
      document.querySelectorAll('.star-item').forEach((item, i) => {
        if (i < rating) {
          item.style.color = '#ffa726';
        } else {
          item.style.color = '#ddd';
        }
      });
    });
  });

  // 마우스가 별점 영역을 벗어날 때 원래 상태로 복원
  document.getElementById('starRating').addEventListener('mouseleave', function() {
    document.querySelectorAll('.star-item').forEach((item, i) => {
      if (i < selectedRating) {
        item.style.color = '#ffa726';
      } else {
        item.style.color = '#ddd';
      }
    });
  });

  // 별점 제출
  function submitRating() {
    if (selectedRating === 0) {
      alert('별점을 선택해주세요.');
      return;
    }

    const roomId = $('#roomId').val();
    const userId = $('#userId').val();

    $.ajax({
      url: '/submitrating.roomajax', // 실제 서블릿 URL로 변경
      type: 'POST',
      data: {
        roomId: roomId,
        userId: userId,
        rating: selectedRating
      },
      success: function(response) {
        alert(`${selectedRating}점 별점이 등록되었습니다!`);
        closeRatingModal();
        document.querySelectorAll('.rating-number')[0].textContent = response.star;
        // 또는 특정 ID를 지정해서 안전하게
        document.getElementById('ratingNumber').textContent = response.star;
      },
      error: function() {
        alert('별점 등록 중 오류가 발생했습니다.');
      }
    });
  }

  // 모달 외부 클릭시 닫기
  document.getElementById('ratingModal').addEventListener('click', function(e) {
    if (e.target === this) {
      closeRatingModal();
    }
  });

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