<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>공지사항 상세보기</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/style/default.css">
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
/* ===== 제목 ===== */
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

/* 본문 카드 */
.notice-container {
	max-width: 900px;
	margin: 0 auto 80px;
	background: #fff;
	border-radius: 16px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
	padding: 50px 60px;
}

/* 공지 제목 */
.notice-title {
	text-align: center;
	font-weight: 600;
	font-size: 20px;
	margin-bottom: 50px;
}



/* 작성자/날짜/조회수 영역 */
.notice-meta {
	display: flex;
    justify-content: space-between;
	align-items: center;
	font-size: 14px;
	color: #777;
	border-bottom: 1px solid #ddd;
	padding-bottom: 6px;
	margin-bottom: 30px;
}

.notice-meta span {
	margin-right: 12px;
}

.notice-meta .writer {
	font-weight: 600;
	color: #000;
}


/* 목록 버튼 */
.btn-back-top {
    background: none;
    border: none;
    color: #999;
    font-size: 14px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 6px;
    transition: color 0.3s;
}

.btn-back-top:hover {
    color: #555;
}

/* 아이콘 크기 살짝 조정 */
.btn-back-top i {
    font-size: 16px;
}


/* 본문 */
.notice-content {
	font-size: 16px;
	line-height: 1.7;
	color: #333;
	min-height: 200px;
}

/* 버튼 */
.bottom-buttons {
	display: flex;
	justify-content: center;
	gap: 12px;
	margin-top: 50px;
}

.btn-edit, .btn-delete {
	border: none;
	border-radius: 8px;
	padding: 10px 35px;
	font-size: 15px;
	font-weight: 500;
	transition: 0.3s;
}

.btn-edit {
	background-color: #FF9B9B;
	color: #fff;
}

.btn-delete {
	background-color: #FF7272;
	color: #fff;
}

.btn-edit:hover {
	background-color: #ff8c8c;
}

.btn-delete:hover {
	background-color: #E85A5A;
}

.btn-disabled {
	background-color: #e9ecef;
	color: #999;
	cursor: not-allowed;
}



/* ===== 전체 레이아웃 ===== */
.layout-wrap {
    display: grid;
    grid-template-columns: auto 1fr; /* 왼쪽: 사이드바 / 오른쪽: 메인 */
    gap: 0; /* 간격 제거 */
    align-items: flex-start;
    margin: 0;
    padding: 0;
}
/* === admin이 아닐 때 중앙 정렬용 === */
.center-layout {
	display: flex;
	justify-content: center;
}

.center-layout main {
	max-width: 1000px;   /* 공지사항 컨테이너 크기와 맞춤 */
	width: 100%;
	border-left: none;   /* 사이드바 구분선 제거 */
	padding: 40px 50px;
}
main {
    background: #fff; /* 흰색으로 변경 */
    border-left: 1px solid #e5e7eb;
    padding: 24px 28px;
    min-height: 100vh;
}

</style>
</head>

<body>
	<jsp:include page="/include/nav.jsp" />

	 <div class="layout-wrap ${empty sessionScope.LOGIN_USER or sessionScope.LOGIN_USER.user_status ne 'ADMIN' ? 'center-layout' : ''}">
		<!-- 사이드바 -->
		<jsp:include page="/include/adminSidebar.jsp">
			<jsp:param name="current" value="adminNotice" />
		</jsp:include>

		<!-- 본문 -->
		<main> 
<header class="page-header">
		        <h1>공지사항</h1>
		     </header>
			<div class="notice-container">
				<!-- 공지 제목 -->
				<div class="notice-title">${notice.adminNoticeTitle}</div>

				<!-- 작성자 / 날짜 / 조회수 -->
				<div class="notice-meta">
					<div>
						<span class="writer">${notice.userNickname}</span>
						<span>${notice.createdAt}</span>
						<span>조회수 ${notice.adminNoticeViewCnt}</span>
					</div>
					    <button class="btn-back-top"
					            onclick="location.href='${pageContext.request.contextPath}/adminNotice.admin'">
					        목록 <i class="fa-solid fa-ellipsis-vertical"></i>
					    </button>
				</div>

				<!-- 내용 -->
				<div class="notice-content">${notice.adminNoticeContent}</div>
			</div>
			
				<!-- 수정 / 삭제 버튼 -->
				<div class="bottom-buttons">
					<c:choose>
						<c:when
							test="${not empty sessionScope.LOGIN_USER and sessionScope.LOGIN_USER.user_status eq 'ADMIN'}">
							<button class="btn-delete" id="btnDelete"
								data-id="${notice.adminNoticeId}">삭제</button>
							<button class="btn-edit"
							onclick="location.href='${pageContext.request.contextPath}/adminNoticeUpdate.admin?noticeId=${notice.adminNoticeId}'">수정</button>

						</c:when>
						<c:otherwise>
							<c:if
								test="${not empty sessionScope.LOGIN_USER and sessionScope.LOGIN_USER.user_status eq 'ADMIN'}">
								<button class="btn-delete" id="btnDelete"
									data-id="${notice.adminNoticeId}">삭제</button>
								<button class="btn-edit">수정</button>
							</c:if>
						</c:otherwise>
					</c:choose>
				</div>
		</main>
	</div>

	<script>
		const contextPath = "${pageContext.request.contextPath}";
		
		$(document).on("click", "#btnDelete", function() {
		    const noticeId = $(this).data("id");
		    if (!confirm("정말 삭제하시겠습니까?")) return;
		
		    $.ajax({
		        url: contextPath + "/AdminNoticeDelete",
		        type: "POST",
		        data: { noticeId: noticeId },
		        success: function(res) {
		            if (res.status === "success") {
		                alert("공지사항이 삭제되었습니다.");
		                location.href = contextPath + "/adminNotice.admin";
		            } else {
		                alert("삭제에 실패했습니다.");
		            }
		        },
		        error: function(xhr) {
		            if (xhr.status === 403) {
		                alert("관리자만 삭제할 수 있습니다.");
		            } else {
		                alert("삭제 중 오류가 발생했습니다.");
		            }
		        }
		    });
		});
	</script>

</body>
</html>
