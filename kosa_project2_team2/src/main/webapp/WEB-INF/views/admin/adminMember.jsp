<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 회원관리</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/style/default.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: #fffdfd;
	color: #333;
}

.member-container {
	max-width: 1100px;
	margin: 80px auto;
}

h2 {
	font-weight: 700;
	margin-bottom: 40px;
	text-align: center;
	color: #444;
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

.search-box input::placeholder {
	color: #d88c8c;
}

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
}

.member-info img {
  width: 45px;                /* 👈 기존보다 살짝 작게 */
  height: 45px;
  border-radius: 50%;
  margin-right: 15px;
  border: 2px solid #FFBDBD;
  object-fit: cover;          /* 👈 이미지 비율 유지하면서 꽉 차게 */
  object-position: center;    /* 👈 이미지 중앙 정렬 */
  display: block; 
  padding: 3px;               /* 👈 프레임 안쪽 여백 줘서 '작게' 보이게 */
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

@media ( max-width : 900px) {
	.member-grid {
		grid-template-columns: repeat(2, 1fr);
	}
}

@media ( max-width : 600px) {
	.member-grid {
		grid-template-columns: 1fr;
	}
}
</style>
</head>

<body>
	<jsp:include page="/include/nav.jsp" />

	<div class="member-container">
		<h2>회원관리</h2>

		<!-- 검색창 -->
		<div class="search-box">
			<input type="text" placeholder="닉네임을 입력해주세요."> <i
				class="fa fa-search"></i>
		</div>

		<!-- 회원 목록 영역 -->
		<div id="memberListArea">
			<div class="member-grid"></div>
			<div class="pagination"></div>
		</div>
	</div>

	<script>
	const contextPath = "${pageContext.request.contextPath}";
	let currentPage = 1; 
	//  회원 목록 불러오기 
	function fetchPage(page) {
	  $.ajax({
	    url: contextPath + "/AdminMemberAjax",
	    type: "GET",
	    data: { page },
	    dataType: "json",
	    success: function (res) {
	      currentPage = res.currentPage;  
	      console.log("✅ Ajax:", res);
	      renderList(res);
	    },
	    error: function (xhr, s, e) {
	      console.error("❌ Ajax 실패:", e);
	    }
	  });
	}
	 
	function renderList(res) {
	  const users = Array.isArray(res.data) ? res.data : [];
	  let cards = "";
	
	  // 회원 목록
	  users.forEach(u => {
	    let photo = u.user_photo;
	    if (!photo || photo.trim() === "" || photo.includes("default_profile")) {
	      photo = contextPath + "/images/default-avatar.png";
	    } else if (!photo.startsWith("http") && !photo.startsWith(contextPath)) {
	      photo = contextPath + "/" + photo;
	    }
	
	    cards += `
	      <div class="member-card">
	        <div class="member-info">
	          <img src="\${photo}" alt="프로필">
	          <div>
	            <div class="name">\${u.user_nickname ?? ""}</div>
	            <div class="date">ID: \${u.user_login_id ?? ""}</div>
	          </div>
	        </div>
	        <button class="btn-delete" type="button" data-user-id="\${u.user_id}">탈퇴</button>
	      </div>`;
	  });
	
	  $("#memberListArea .member-grid").html(cards);
	
	  // 페이지네이션 생성
	  const pageBlock = 5;
	  const totalPages = res.totalPages;
	  const startPage = Math.floor((currentPage - 1) / pageBlock) * pageBlock + 1;
	  let endPage = startPage + pageBlock - 1;
	  if (endPage > totalPages) endPage = totalPages;
	
	  let p = "";
	  if (startPage > 1)
	    p += `<button class="page-arrow" type="button" data-page="\${startPage - 1}">&laquo;</button>`;
	  for (let i = startPage; i <= endPage; i++) {
	    p += `<button class="page-num \${i === currentPage ? 'active' : ''}" type="button" data-page="\${i}">\${i}</button>`;
	  }
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
	      if (remaining === 1 && currentPage > 1) {
	        currentPage--;
	      }
	      fetchPage(currentPage); 
	    },
	    error: function (xhr, s, e) {
	      console.error("❌ 탈퇴 요청 실패:", e);
	      alert("탈퇴 처리 중 오류가 발생했습니다.");
	    }
	  });
	});
	
	// ✅ 초기 진입 시 1페이지 로드
	$(function() {
	  fetchPage(1);
	});
	</script>

</body>
</html>
