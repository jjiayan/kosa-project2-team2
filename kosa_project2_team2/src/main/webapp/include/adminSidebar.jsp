<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="current" value="${param.current}" />

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<style>
  :root {
    --snav-width: 240px;
    --ink: #222;
    --pill-bg: #fde4e4;
    --hover-bg: #f4f5f7;
  }

  .app-sidenav {
    width: var(--snav-width);
    background: #fff;
    border-right: 1px solid #eee;
    padding: 20px 0;
    box-sizing: border-box;
  }

  .snav-list {
    list-style: none;
    margin: 0;
    padding: 0 8px;
    display: grid;
    gap: 8px;
  }

  .snav-link {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 16px;
    border-radius: 999px;
    color: var(--ink);
    text-decoration: none;
    transition: background 0.15s ease, color 0.15s ease;
    font-size: 14px;
  }

  .snav-link:hover { background: var(--hover-bg); }

  .snav-link i {
    width: 22px;
    font-size: 16px;
    text-align: center;
  }

  .snav-link .label { flex: 1; }

  .snav-item.is-active .snav-link {
    background: var(--pill-bg);
    font-weight: 600;
  }

  /* ===== 반응형 ===== */
  @media (max-width: 900px) {
    .app-sidenav {
      --snav-width: 72px;
    }
    .snav-list {
      padding: 0 6px;
    }
    .snav-link {
      justify-content: center;
      gap: 0;
      padding: 10px 12px;
    }
    .snav-link .label {
      display: none; /* 아이콘만 남김 */
    }
  }
</style>

<c:if test="${not empty sessionScope.LOGIN_USER and sessionScope.LOGIN_USER.user_status eq 'ADMIN'}">
<nav class="app-sidenav" aria-label="관리자 메뉴">
  <ul class="snav-list">
    <!-- 회원관리 -->
    <li class="snav-item ${current eq 'adminMember' ? 'is-active' : ''}">
      <a href="<c:url value='/adminMember.admin'/>" class="snav-link" aria-label="회원관리">
        <i class="fa-solid fa-users"></i>
        <span class="label">회원관리</span>
      </a>
    </li>

    <!-- 통계보드 -->
    <li class="snav-item ${current eq 'adminStat' ? 'is-active' : ''}">
      <a href="<c:url value='/adminStat.admin'/>" class="snav-link" aria-label="통계보드">
        <i class="fa-solid fa-chart-column"></i>
        <span class="label">통계보드</span>
      </a>
    </li>

    <!-- 공지사항 -->
    <li class="snav-item ${current eq 'adminNotice' ? 'is-active' : ''}">
      <a href="<c:url value='/adminNotice.admin'/>" class="snav-link" aria-label="공지사항">
        <i class="fa-regular fa-bell"></i>
        <span class="label">공지사항</span>
      </a>
    </li>
  </ul>
</nav>
</c:if>
