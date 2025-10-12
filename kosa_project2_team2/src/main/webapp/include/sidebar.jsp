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
      <a href="<c:url value='/index.user'/>" class="snav-link" aria-label="홈">
        <i class="fa-regular fa-calendar"></i>
        <span class="label">홈</span>
      </a>
    </li>

    <li class="snav-item ${current eq 'posts' ? 'is-active' : ''}">
      <a href="<c:url value='/board/list.do'/>" class="snav-link" aria-label="게시글">
        <i class="fa-regular fa-rectangle-list"></i>
        <span class="label">게시글</span>
        <span class="count">24</span>
      </a>
    </li>

    <li class="snav-item ${current eq 'calendar' ? 'is-active' : ''}">
      <a href="<c:url value='/calendar/list.do'/>" class="snav-link" aria-label="캘린더">
        <i class="fa-regular fa-calendar-days"></i>
        <span class="label">캘린더</span>
      </a>
    </li>

    <li class="snav-item ${current eq 'notice' ? 'is-active' : ''}">
      <a href="<c:url value='/notice/list.do'/>" class="snav-link" aria-label="공지사항">
        <i class="fa-regular fa-bell"></i>
        <span class="label">공지사항</span>
      </a>
    </li>

    <li class="snav-item ${current eq 'admin' ? 'is-active' : ''}">
      <a href="<c:url value='/admin/index.do'/>" class="snav-link" aria-label="관리">
        <i class="fa-regular fa-user"></i>
        <span class="label">관리</span>
      </a>
    </li>
  </ul>
</nav>
