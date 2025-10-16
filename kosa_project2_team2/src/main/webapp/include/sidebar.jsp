<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="current" value="${param.current}" />

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<style>
  :root{
    --snav-width: 240px;
    --ink: #222;
    --pill-bg: #fde4e4;  /* ✅ 기존 연분홍색 유지 */
    --hover-bg: #f4f5f7;
  }

  .app-sidenav{
    width: var(--snav-width);
    padding: 20px 0;
    box-sizing: border-box;
    background: #fff;
  }

  .snav-list{
    list-style: none;
    margin: 0;
    padding: 0 8px;
    display: grid;
    gap: 8px;
  }

  .snav-link{
    position: relative;
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 16px;
    border-radius: 999px;
    color: var(--ink);
    text-decoration: none;
    transition: background 0.15s ease, padding 0.15s ease;
    font-size: 14px;
  }
  .snav-link:hover{ background: var(--hover-bg); }

  .snav-link i{
    width: 22px;
    font-size: 16px;
    text-align: center;
  }

  .snav-link .label{ flex: 1; }
  .snav-link .count{ font-weight: 700; font-size: 13px; }

  /* ✅ 메인 메뉴 활성화: 기존 연한 분홍 유지 */
  .snav-item.is-active .snav-link{
    background: var(--pill-bg);
    color: var(--ink);
  }
  .snav-item.is-active .snav-link i,
  .snav-item.is-active .snav-link .label,
  .snav-item.is-active .snav-link .count{
    color: var(--ink);
  }

  /* ====== 서브메뉴 ====== */
  .has-submenu {
      position: relative;
      cursor: pointer;
  }

  .submenu-arrow {
      margin-left: auto;
      font-size: 12px;
      transition: transform 0.3s ease;
  }

  .has-submenu.active .submenu-arrow {
      transform: rotate(180deg);
  }

  .submenu-item {
      display: none;
      margin-left: 20px;
  }
  .submenu-item.show {
      display: block;
  }

  /* ✅ 서브메뉴도 메인 색상에 맞춰 통일 */
  .submenu-link {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 12px 16px;
      color: #666;
      text-decoration: none;
      transition: all 0.2s;
      border-bottom: 1px solid #f3f4f6;
      border-radius: 8px;
  }

  .submenu-link:hover {
      background: #f8f9fa;
      color: #333;
  }

  .submenu-link.active {
      background: var(--pill-bg);
      color: var(--ink);
      font-weight: bold;
  }

  /* ====== 반응형 ====== */
  @media (max-width: 1200px){
    .app-sidenav{ --snav-width: 220px; }
  }

  @media (max-width: 900px){
    .app-sidenav{ --snav-width: 72px; }
    .snav-list{ padding: 0 6px; }
    .snav-link{
      justify-content: center;
      gap: 0;
      padding: 10px 12px;
    }
    .snav-link .label,
    .snav-link .count{
      display: none;
    }
  }
</style>

<nav class="app-sidenav" aria-label="사이드바">
  <ul class="snav-list">
    <!-- 홈 -->
    <li class="snav-item ${current eq 'home' ? 'is-active' : ''}">
      <a href="<c:url value='/roomdetail.room'>
            <c:param name='roomId' value='${sessionScope.currentRoomId}'/>
            <c:param name='userId' value='${sessionScope.LOGIN_USER.user_id}'/>
         </c:url>" class="snav-link" aria-label="홈">
        <i class="fa-regular fa-calendar"></i>
        <span class="label">홈</span>
      </a>
    </li>

    <!-- 게시글 -->
    <c:if test="${not empty sessionScope.currentRoomId and not empty sessionScope.LOGIN_USER.user_id}">
      <li class="snav-item ${current eq 'posts' ? 'is-active' : ''}">
        <a href="<c:url value='/roomboardlist.room'>
            <c:param name='roomId' value='${sessionScope.currentRoomId}'/>
        </c:url>" class="snav-link" aria-label="게시글">
            <i class="fa-regular fa-rectangle-list"></i>
            <span class="label">게시글</span>
        </a>
      </li>
    </c:if>

    <!-- 캘린더 -->
    <li class="snav-item ${current eq 'calendar' ? 'is-active' : ''}">
      <a href="<c:url value='/roomcalender.room'>
            <c:param name='roomId' value='${sessionScope.currentRoomId}'/>
        </c:url>" class="snav-link" aria-label="캘린더">
        <i class="fa-regular fa-calendar-days"></i>
        <span class="label">캘린더</span>
      </a>
    </li>
    
    <!-- 공지사항 -->
    <c:if test="${not empty sessionScope.currentRoomId}">
      <li class="snav-item ${current eq 'notice' ? 'is-active' : ''}">
        <a href="<c:url value='/roomboardnotice.room'>
            <c:param name='roomId' value='${sessionScope.currentRoomId}'/>
        </c:url>" class="snav-link" aria-label="공지">
            <i class="fa-regular fa-bell"></i>
            <span class="label">공지사항</span>
        </a>
      </li>
    </c:if>

    <!-- 관리 -->
    <c:if test="${sessionScope.leaderCheck}">
      <li class="snav-item has-submenu ${(current eq 'admin' || current eq 'members' || current eq 'room-edit') ? 'is-active active' : ''}" id="adminMenu">
        <a href="#" class="snav-link" aria-label="관리" onclick="toggleSubmenu(event)">
          <i class="fa-regular fa-user"></i>
          <span class="label">관리</span>
          <i class="fa-solid fa-chevron-down submenu-arrow"></i>
        </a>
      </li>

      <!-- ✅ 서브메뉴: current 값이 admin/members/room-edit이면 항상 show -->
      <li class="submenu-item ${(current eq 'admin' || current eq 'members' || current eq 'room-edit') ? 'show' : ''}" data-parent="admin">
        <a href="<c:url value='/roommembermanageform.room'>
            <c:param name='roomId' value='${sessionScope.currentRoomId}'/>
        </c:url>" class="snav-link submenu-link ${current eq 'members' ? 'active' : ''}">
          <i class="fa-solid fa-users"></i>
          <span class="label">회원관리</span>
        </a>
      </li>

      <li class="submenu-item ${(current eq 'admin' || current eq 'members' || current eq 'room-edit') ? 'show' : ''}" data-parent="admin">
        <a href="<c:url value='/roomupdateform.room'>
            <c:param name='roomId' value='${sessionScope.currentRoomId}'/>
        </c:url>" class="snav-link submenu-link ${current eq 'room-edit' ? 'active' : ''}">
          <i class="fa-solid fa-edit"></i>
          <span class="label">방정보 수정</span>
        </a>
      </li>

      <li class="submenu-item ${(current eq 'admin' || current eq 'members' || current eq 'room-edit') ? 'show' : ''}" data-parent="admin">
        <a href="#" class="snav-link submenu-link" 
		   onclick="deleteRoom('${sessionScope.currentRoomId}', '${sessionScope.LOGIN_USER.user_id}'); return false;">
		  <i class="fa-solid fa-trash"></i>
		  <span class="label">방 삭제</span>
		</a>

      </li>
    </c:if>
  </ul>
</nav>

<script>
  // ✅ 메뉴 토글 기능 (클릭 시 접었다 펼침)
  function toggleSubmenu(e) {
    e.preventDefault();
    document.querySelectorAll('.submenu-item').forEach(item => {
      item.classList.toggle('show');
    });
    document.getElementById('adminMenu').classList.toggle('active');
  }
  
  function deleteRoom(roomId, userId){
	  if(!confirm('이 모임에 삭제하시겠습니까?')) return;
	  $.ajax({
	    	url: "/roomdelete.roomajax",
	    	data: {
	    		userId: userId,
	    		roomId: roomId
	    	},
	    	success: function(res){
	            console.log(res);
	            alert('모입방 삭제가 완료되었습니다.');
	            window.location.href = "/roomlist.room";
	        },
	        error: function(e){
	        	console.log(e)
	            alert('모임방 삭제 중 오류가 발생했습니다.');
	        }
	    	
	    })
  }
</script>
