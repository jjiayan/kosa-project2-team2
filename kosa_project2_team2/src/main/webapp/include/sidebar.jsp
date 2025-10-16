<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="current" value="${param.current}" />

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<style>
  :root{
    --snav-width: 240px;   /* 기본 폭 (줄임) */
    --ink: #222;
    --pill-bg: #fde4e4;    /* 활성 분홍색 */
    --hover-bg: #f4f5f7;
  }

  .app-sidenav{
    width: var(--snav-width);
    padding: 20px 0;       /* 왼쪽 패딩 0 유지 */
    box-sizing: border-box;
    background: #fff;
  }

  .snav-list{
    list-style: none;
    margin: 0;
    padding: 0 8px;        /* 좌우 살짝 여백 */
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

  .snav-item.is-active .snav-link{ background: var(--pill-bg); }
  .snav-item.is-active .snav-link i,
  .snav-item.is-active .snav-link .label,
  .snav-item.is-active .snav-link .count{ color: var(--ink); }
  /* 서브메뉴 스타일 */
.has-submenu {
    position: relative;
}

.submenu-arrow {
    margin-left: auto;
    font-size: 12px;
    transition: transform 0.3s ease;
}

.has-submenu.active .submenu-arrow {
    transform: rotate(180deg);
}

.submenu {
    display: none;
    position: absolute;
    left: 100%;
    top: 0;
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    min-width: 200px;
    z-index: 1000;
}

.submenu.show {
    display: block;
}

.submenu li {
    list-style: none;
}

.submenu-link {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 12px 16px;
    color: #666;
    text-decoration: none;
    transition: all 0.2s;
    border-bottom: 1px solid #f3f4f6;
}

.submenu-link:hover {
    background: #f8f9fa;
    color: #333;
}

.submenu-link.active {
    background: #ff6b6b;
    color: white;
}

.submenu li:last-child .submenu-link {
    border-bottom: none;
}

  /* ====== 반응형 ====== */
  /* 1200px 이하면 살짝 더 좁게 */
  @media (max-width: 1200px){
    .app-sidenav{ --snav-width: 220px; }
  }

  /* 900px 이하면 컴팩트 모드 (아이콘만) */
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
      display: none;       /* 아이콘만 표시 */
    }
  }
</style>

<nav class="app-sidenav" aria-label="사이드바">
  <ul class="snav-list">
    <li class="snav-item ${current eq 'home' ? 'is-active' : ''}">
      <a href="<c:url value='/roomdetail.room'>
            <c:param name='roomId' value='${sessionScope.currentRoomId}'/>
            <c:param name='userId' value='${sessionScope.LOGIN_USER.user_id}'/>
         </c:url>" class="snav-link" aria-label="홈">
        <i class="fa-regular fa-calendar"></i>
        <span class="label">홈</span>
      </a>
    </li>

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

    <li class="snav-item ${current eq 'calendar' ? 'is-active' : ''}">
      <a href="<c:url value='/roomcalender.room'>
	            <c:param name='roomId' value='${sessionScope.currentRoomId}'/>
	        </c:url>" class="snav-link" aria-label="캘린">
        <i class="fa-regular fa-calendar-days"></i>
        <span class="label">캘린더</span>
      </a>
    </li>
    
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

   <c:if test="${sessionScope.leaderCheck}">
		<li class="snav-item ${current eq 'admin' ? 'is-active' : ''} has-submenu">
		     <a href="<c:url value='/roomboardadmin.room'>
	            <c:param name='roomId' value='${sessionScope.currentRoomId}'/>
	        	</c:url>" class="snav-link" aria-label="관리">
		        <i class="fa-regular fa-user"></i>
		        <span class="label">관리</span>
		        <i class="fa-solid fa-chevron-down submenu-arrow"></i>
		    </a>
		</li>
		
		<!-- 서브메뉴들을 별도 li로 분리 -->
		<li class="submenu-item ${current eq 'admin' ? 'show' : ''}" data-parent="admin">
		    <a href="<c:url value='/roommembermanageform.room'>
		        <c:param name='roomId' value='${sessionScope.currentRoomId}'/>
		    </c:url>" class="snav-link submenu-link ${current eq 'members' ? 'is-active' : ''}">
		        <i class="fa-solid fa-users"></i>
		        <span class="label">회원관리</span>
		    </a>
		</li>
		
		<li class="submenu-item ${current eq 'admin' ? 'show' : ''}" data-parent="admin">
		    <a href="<c:url value='/roomupdateform.room'>
		        <c:param name='roomId' value='${sessionScope.currentRoomId}'/>
		    </c:url>" class="snav-link submenu-link ${current eq 'room-edit' ? 'is-active' : ''}">
		        <i class="fa-solid fa-edit"></i>
		        <span class="label">방정보 수정</span>
		    </a>
		</li>
		
		<li class="submenu-item ${current eq 'admin' ? 'show' : ''}" data-parent="admin">
		    <a href="#" class="snav-link submenu-link" onclick="deleteRoom(${sessionScope.currentRoomId}, ${sessionScope.LOGIN_USER.user_id})">
		        <i class="fa-solid fa-trash"></i>
		        <span class="label">방 삭제</span>
		    </a>
		</li>
	</c:if>
  </ul>
</nav>
