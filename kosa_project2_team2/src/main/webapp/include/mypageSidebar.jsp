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
    padding: 20px 0;
    background: #fff;
    box-sizing: border-box;
    border-right: 1px solid #eee;
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
  @media (max-width: 1200px) {
    .app-sidenav { --snav-width: 220px; }
  }

  @media (max-width: 900px) {
    .app-sidenav { --snav-width: 72px; }
    .snav-list { padding: 0 6px; }
    .snav-link {
      justify-content: center;
      gap: 0;
      padding: 10px 12px;
    }
    .snav-link .label { display: none; }
  }
</style>

<nav class="app-sidenav" aria-label="마이페이지 메뉴">
  <ul class="snav-list">

    <!-- 내 정보 -->
    <li class="snav-item ${current eq 'info' ? 'is-active' : ''}">
      <a href="<c:url value='/mypage/info.user?current=info'/>" class="snav-link" aria-label="내정보">
        <i class="fa-regular fa-user"></i>
        <span class="label">내정보</span>
      </a>
    </li>

    <!-- 내 정보 수정 -->
    <li class="snav-item ${current eq 'edit' ? 'is-active' : ''}">
      <a href="<c:url value='/mypage/edit.user?current=edit'/>" class="snav-link" aria-label="내정보 수정">
        <i class="fa-solid fa-pen-to-square"></i>
        <span class="label">내정보 수정</span>
      </a>
    </li>

    <!-- 내가 참여한 모임 -->
    <li class="snav-item ${current eq 'group' ? 'is-active' : ''}">
      <a href="<c:url value='/mypage/myGroups.jsp?current=group'/>" class="snav-link" aria-label="내가 참여한 모임">
        <i class="fa-solid fa-users"></i>
        <span class="label">내가 참여한 모임</span>
      </a>
    </li>

    <!-- 내가 작성한 글 -->
    <li class="snav-item ${current eq 'posts' ? 'is-active' : ''}">
      <a href="<c:url value='/mypage/myPosts.jsp?current=posts'/>" class="snav-link" aria-label="내가 작성한 글">
        <i class="fa-regular fa-rectangle-list"></i>
        <span class="label">내가 작성한 글</span>
      </a>
    </li>

    <!-- 내가 작성한 댓글 -->
    <li class="snav-item ${current eq 'comments' ? 'is-active' : ''}">
      <a href="<c:url value='/mypage/myComments.jsp?current=comments'/>" class="snav-link" aria-label="내가 작성한 댓글">
        <i class="fa-regular fa-comment-dots"></i>
        <span class="label">내가 작성한 댓글</span>
      </a>
    </li>

  </ul>
</nav>
