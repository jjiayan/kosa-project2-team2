<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>관리자 회원관리</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css">
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

	<style>
		body {
			font-family: 'Noto Sans KR', sans-serif;
			background-color: #fffdfd;
			color: #333;
		}
		header.nav-root * {
		  line-height: normal;
		  padding: 0;
		  margin: 0;
		}
		.member-container {
			max-width: 1100px; 
		}
		.page-header{
	      display:flex;
	      justify-content:center;
	      align-items:center;
	      flex-direction:column;
	      text-align:center;
	      margin-top: 20px; 
	      margin-bottom:40px;
	      padding:20px 0;
	    }
	    .page-header h1{
	      font-size:32px;
	      font-weight:700;
	      color:#333;
	      text-align:center;
	      margin:0;
	    }
		/* 검색창 */
		.search-box {
			position: relative;
			display: flex;
			justify-content: flex-end;
			margin-bottom: 40px;
			margin-right: 5px;
		}
		.search-box input {
			background-color: #fffafa;
			border: none;
			border-radius: 25px;
			padding: 10px 40px 10px 18px;
			width: 260px;
			font-size: 14px;
			transition: all 0.25s ease-in-out;
			box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
		}
		.search-box input::placeholder { color: #d88c8c; }
		.search-box input:focus {
			outline: none;
			background-color: #fff5f5;
			box-shadow: 0 0 8px rgba(255, 114, 114, 0.3);
		}
		.search-box i {
			position: absolute;
			right: 16px;
			top: 50%;
			transform: translateY(-50%);
			color: #FF7272;
			font-size: 16px;
			pointer-events: none;
		}
		/* 회원 카드 목록 */
		.member-grid {
			display: grid;
			grid-template-columns: repeat(3, 1fr);
			gap: 25px;
			justify-items: center;
		}
		.member-card {
			width: 90%;
			display: flex;
			align-items: center;
			justify-content: space-between;
			border: 1px solid #f0eaea;
			border-radius: 12px;
			padding: 18px 22px;
			background-color: #fff;
			box-shadow: 0 3px 8px rgba(0, 0, 0, 0.04);
			transition: 0.3s ease-in-out;
		}
		.member-card:hover {
			transform: translateY(-4px);
			box-shadow: 0 6px 14px rgba(255, 114, 114, 0.15);
		}
		.member-info {
			display: flex;
			align-items: center;
			cursor: pointer;
		}
		.member-info img {
			width: 45px;
			height: 45px;
			border-radius: 50%;
			margin-right: 15px;
			border: 2px solid #FFBDBD;
			object-fit: cover;
			object-position: center;
			display: block;
			padding: 3px;
		}
		.member-info .name {
			font-weight: 600;
			font-size: 16px;
			margin-bottom: 2px;
		}
		.member-info .date {
			color: #999;
			font-size: 13px;
		}
		.btn-delete {
			background-color: #FF7272;
			color: #fff;
			border: none;
			border-radius: 8px;
			padding: 8px 20px;
			font-weight: 500;
			box-shadow: 0 3px 6px rgba(255, 114, 114, 0.25);
			transition: all 0.3s ease;
		}
		.btn-delete:hover {
			background-color: #E85A5A;
			box-shadow: 0 4px 10px rgba(232, 90, 90, 0.3);
			transform: translateY(-1px);
		}
		/* 페이지네이션 */
		.pagination {
			display: flex;
			justify-content: center;
			align-items: center;
			gap: 10px;
			margin-top: 45px;
			margin-bottom: 40px;
		}
		.page-arrow, .page-num {
			display: flex;
			align-items: center;
			justify-content: center;
			width: 40px;
			height: 40px;
			border-radius: 50%;
			text-decoration: none;
			color: #FF7272;
			font-size: 16px;
			transition: all 0.3s;
			cursor: pointer;
			border: 1px solid #FFBDBD;
			background: #fffafa;
		}
		.page-arrow:hover, .page-num:hover {
			background-color: #FFDADA;
			color: #fff;
		}
		.page-num.active {
			background-color: #FF7272;
			color: #fff;
			font-weight: 600;
			box-shadow: 0 3px 6px rgba(255, 114, 114, 0.3);
		}
		/* 모달 디자인 */
		#userDetailModal .modal-dialog { max-width: 420px; }
		#userDetailModal .modal-content {
			border: none;
			border-radius: 20px;
			overflow: hidden;
			box-shadow: 0 18px 45px rgba(0,0,0,0.15);
		}
		#userDetailModal .modal-header {
			border: none;
			padding: 30px;
		}
		.profile-photo-wrap {
			position: relative;
			width: 110px; height: 110px;
			display: grid; place-items: center;
		}
		.profile-photo-ring {
			position: absolute;
			width: 100%; height: 100%;
			border-radius: 50%;
			background: conic-gradient(from 180deg, #FF7272, #FFB2C1, #FF7272);
			filter: blur(8px);
			opacity: 0.4;
		}
		.profile-photo {
			width: 110px; height: 110px;
			border-radius: 50%;
			object-fit: cover;
			object-position: center;
			display: block;
			padding: 10px;
			border: 3px solid #fff;
			box-shadow: 0 3px 8px rgba(255,114,114,0.25);
			background: #fff;
			z-index: 2;
		}
		.chip {
			font-size: 15px;
			padding: 6px 12px;
		}
		@media (max-width: 900px) { .member-grid { grid-template-columns: repeat(2, 1fr); } }
		@media (max-width: 600px) { .member-grid { grid-template-columns: 1fr; } }
		
		/* ===== sideBar 전체 레이아웃 ===== */
		.layout-wrap {
		    display: grid;
		    grid-template-columns: auto 1fr; /* 왼쪽: 사이드바 / 오른쪽: 메인 */
		    gap: 0; /* 간격 제거 */
		    align-items: flex-start;
		    margin: 0;
		    padding: 0;
		}
		
		main {
		    background: #fff; /* 흰색으로 변경 */
		    border-left: 1px solid #e5e7eb;
		    padding: 24px 28px;
		    min-height: 100vh;
		}
		
		/* ===== 반응형 ===== */
		@media (max-width: 900px) {
		    .layout-wrap {
		        grid-template-columns: 1fr;
		    }
		    main {
		        border-left: none;
		        border-top: 1px solid #e5e7eb;
		        padding: 16px;
		    }
		}
	</style>
</head>

<body>
	<jsp:include page="/include/nav.jsp" />
	
    
    <!-- 사이드바 + 메인 레이아웃 -->
    <div class="layout-wrap">
        
        <!-- 좌측 사이드바 -->
        <jsp:include page="/include/adminSidebar.jsp">
            <jsp:param name="current" value="adminMember"/>
   		</jsp:include>
        
        <!-- 우측 본문 -->
        <main>
        	 <header class="page-header">
		        <h1>회원관리</h1>
		     </header>
            <div class="member-container">

		
				<!-- 검색창 -->
				<div class="search-box">
					<input type="text" placeholder="닉네임을 입력해주세요.">
					<i class="fa fa-search"></i>
				</div>
		
				<!-- 회원 목록 영역 -->
				<div id="memberListArea">
					<div class="member-grid"></div>
					<div class="pagination"></div>
				</div>
			</div>
		
			<!-- 회원 상세 모달 -->
			<div class="modal fade" id="userDetailModal" tabindex="-1" aria-hidden="true">
			  <div class="modal-dialog modal-dialog-centered">
			    <div class="modal-content">
			      <div class="modal-header justify-content-center">
			        <h5 class="modal-title text-center fw-bold">
			          회원 상세 정보
			        </h5>
			        <button type="button" class="btn-close position-absolute end-0 me-3" data-bs-dismiss="modal" aria-label="닫기"></button>
			      </div>
		
			      <div class="modal-body text-center">
			        <div class="profile-photo-wrap mx-auto mb-3">
			          <div class="profile-photo-ring"></div>
			          <img id="detail-photo" class="profile-photo" src="" alt="회원 사진">
			        </div>
		
			        <h5 id="detail-nickname" class="fw-bold mb-1"></h5>
			        <p class="text-muted small mb-4" id="detail-login-id"></p>
		
			        <div class="d-flex flex-column align-items-center gap-2">
			          <div class="chip w-auto">
			            <i class="fa-solid fa-phone me-1"></i><span id="detail-phonenumber">-</span>
			          </div>
			          <div class="chip w-auto">
			            <i class="fa-regular fa-calendar me-1"></i><span id="detail-createdAt">-</span>
			          </div>
			        </div>
		
			        <div class="mt-4 p-3 rounded-4" style="background:#fff6f6; border:1px solid #ffd6da;">
			          <p id="detail-bio" class="mb-0 text-secondary" style="white-space: pre-line;"></p>
			        </div>
			      </div>
			    </div>
			  </div>
			</div>
            
        </main>
    </div>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

	<script>
	const contextPath = "${pageContext.request.contextPath}";
	let currentPage = 1;
	let resData = [];

	function fetchPage(page) {
	  const nickname = $(".search-box input").val().trim();
	  $.ajax({
	    url: contextPath + "/AdminMemberAjax",
	    type: "GET",
	    data: { page, nickname },
	    dataType: "json",
	    success: function (res) {
	      currentPage = res.currentPage;
	      resData = res.data || [];
	      renderList(res);
	    },
	    error: function (xhr, s, e) {
	      console.error("❌ Ajax 실패:", e);
	    }
	  });
	}

	function renderList(res) {
	  const users = Array.isArray(res.data) ? res.data : [];
	  resData = users;
	  let cards = "";

	  if (users.length === 0) {
	    $("#memberListArea .member-grid").html(`
	      <div class="text-center py-5 text-muted" style="grid-column: 1 / -1;">
	        <i class="fa-regular fa-face-frown fa-2x mb-3" style="color:#FF7272;"></i>
	        <div>검색 결과가 없습니다</div>
	      </div>
	    `);
	    $("#memberListArea .pagination").empty();
	    return;
	  }
	  users.forEach(u => {
	    let photo = u.user_photo;
	    if (!photo || photo.trim() === "" || photo.includes("default_profile")) {
	      photo = contextPath + "/images/default-avatar.png";
	    } else if (!photo.startsWith("http") && !photo.startsWith(contextPath)) {
	      photo = contextPath + "/" + photo;
	    }
	    cards += `
	      <div class="member-card">
	        <div class="member-info" data-user-id="\${u.user_id}">
	          <img src="\${photo}" alt="프로필">
	          <div>
	            <div class="name">\${u.user_nickname ?? ""}</div>
	            <div class="date">가입일: \${u.createdAt}</div>
	          </div>
	        </div>
	        <button class="btn-delete" type="button" data-user-id="\${u.user_id}">탈퇴</button>
	      </div>`;
	  });
	  $("#memberListArea .member-grid").html(cards);

	  const pageBlock = 5;
	  const totalPages = res.totalPages;
	  const startPage = Math.floor((currentPage - 1) / pageBlock) * pageBlock + 1;
	  let endPage = startPage + pageBlock - 1;
	  if (endPage > totalPages) endPage = totalPages;

	  let p = "";
	  if (startPage > 1)
	    p += `<button class="page-arrow" type="button" data-page="\${startPage - 1}">&laquo;</button>`;
	  for (let i = startPage; i <= endPage; i++)
	    p += `<button class="page-num \${i === currentPage ? 'active' : ''}" type="button" data-page="\${i}">\${i}</button>`;
	  if (endPage < totalPages)
	    p += `<button class="page-arrow" type="button" data-page="\${endPage + 1}">&raquo;</button>`;

	  $("#memberListArea .pagination").html(p);
	}

	$(document).on("click", "#memberListArea .pagination button", function () {
	  const page = parseInt($(this).data("page"), 10);
	  if (!isNaN(page)) fetchPage(page);
	});

	$(document).on("click", ".btn-delete", function () {
	  const userId = $(this).data("user-id");
	  if (!confirm("정말 이 회원을 탈퇴시키겠습니까?")) return;
	  $.ajax({
	    url: contextPath + "/AdminMemberDeleteAjax",
	    type: "POST",
	    data: { user_id: userId },
	    success: function () {
	      alert("회원이 성공적으로 탈퇴되었습니다.");
	      const remaining = $(".member-card").length;
	      if (remaining === 1 && currentPage > 1) currentPage--;
	      fetchPage(currentPage);
	    },
	    error: function (xhr) {
	    	  if (xhr.status === 403) {
	    	    alert("관리자만 회원 탈퇴를 수행할 수 있습니다.");
	    	  } else {
	    	    alert("탈퇴 처리 중 오류가 발생했습니다.");
	    	  }
	    	}
	  });
	});

	$(document).on("click", ".member-info img", function() {
	  const userId = $(this).closest(".member-info").data("user-id");
	  const user = resData.find(u => u.user_id === userId);
	  if (!user) return;

	  let photo = user.user_photo;
	  if (!photo || photo.trim() === "" || photo.includes("default_profile")) {
	    photo = contextPath + "/images/default-avatar.png";
	  } else if (!photo.startsWith("http") && !photo.startsWith(contextPath)) {
	    photo = contextPath + "/" + photo;
	  }

	  $("#detail-photo").attr("src", photo);
	  $("#detail-login-id").text(user.user_login_id || "-");
	  $("#detail-nickname").text(user.user_nickname || "-");
	  
	  let formattedPhone = user.user_phonenumber || "-";
	  if (formattedPhone && formattedPhone !== "-") {
	    formattedPhone = formattedPhone.replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, "$1-$2-$3");
	  }
	  $("#detail-phonenumber").text(formattedPhone);
	  
	  $("#detail-createdAt").text(user.createdAt || "-");
	  $("#detail-bio").text(user.user_bio && user.user_bio.trim() !== "" ? user.user_bio : "소개글이 없습니다.");

	  const modal = new bootstrap.Modal(document.getElementById('userDetailModal'));
	  modal.show();
	});

	// 실시간 검색 (입력 시마다 즉시 검색)
	$(document).on("keyup", ".search-box input", function(e) {
	  const keyword = $(this).val().trim();
	  if (keyword === "") {
	    // 입력이 없으면 전체 목록
	    fetchPage(1);
	  } else {
	    // 검색어 있으면 필터 적용
	    fetchPage(1);
	  }
	});


	$(function() { fetchPage(1); });
	</script>
</body>
</html>
