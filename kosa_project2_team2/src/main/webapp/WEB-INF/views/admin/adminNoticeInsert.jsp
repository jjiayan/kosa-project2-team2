<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>공지사항 글쓰기</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/style/default.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css"
	rel="stylesheet">

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>

<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: #fffdfd;
	color: #333;
}

/* ===== 공통 레이아웃 ===== */
.layout-wrap {
	display: grid;
	grid-template-columns: auto 1fr;
	gap: 0;
	align-items: flex-start;
	margin: 0;
	padding: 0;
}

main {
	background: #fff;
	border-left: 1px solid #e5e7eb;
	padding: 24px 28px;
	min-height: 100vh;
}

/* ===== 제목 ===== */
h2 {
	text-align: center;
	font-weight: 700;
	color: #444;
	margin-top: 80px;
	margin-bottom: 40px;
}

/* ===== 폼 컨테이너 ===== */
.notice-container {
	max-width: 900px;
	margin: 0 auto 80px;
	background: #fff;
	border-radius: 16px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
	padding: 40px 50px;
}

.form-control {
	border: 1px solid #ddd;
	border-radius: 8px;
	padding: 14px;
	font-size: 15px;
}

.form-control:focus {
	border-color: #FF7272;
	box-shadow: 0 0 0 3px rgba(255, 114, 114, 0.1);
}

/* ===== 버튼 ===== */
.bottom-buttons {
	display: flex;
	justify-content: center;
	gap: 12px;
	margin-top: 40px;
}

.btn-cancel, .btn-submit {
	border: none;
	border-radius: 8px;
	font-size: 15px;
	font-weight: 500;
	padding: 12px 40px;
	cursor: pointer;
	transition: 0.3s;
}

.btn-cancel {
	background-color: #e9ecef;
	color: #555;
}

.btn-cancel:hover {
	background-color: #dee2e6;
}

.btn-submit {
	background-color: #FF7272;
	color: #fff;
}

.btn-submit:hover {
	background-color: #E85A5A;
	box-shadow: 0 3px 8px rgba(255, 114, 114, 0.25);
}

/* ===== 반응형 ===== */
@media ( max-width : 900px) {
	.layout-wrap {
		grid-template-columns: 1fr;
	}
	main {
		border-left: none;
		border-top: 1px solid #e5e7eb;
		padding: 16px;
	}
	.notice-container {
		padding: 20px;
	}
	.bottom-buttons {
		flex-direction: column;
		gap: 10px;
	}
	.btn-cancel, .btn-submit {
		width: 100%;
	}
}
</style>
</head>

<body>
	<jsp:include page="/include/nav.jsp" />

	<div class="layout-wrap">
		<!-- 좌측 사이드바 -->
		<jsp:include page="/include/adminSidebar.jsp">
			<jsp:param name="current" value="adminNotice" />
		</jsp:include>

		<!-- 우측 본문 -->
		<main>
			<h2>공지사항 글쓰기</h2>

			<div class="notice-container">
				<form id="noticeForm" method="post"
				    action="${pageContext.request.contextPath}/adminNoticeWrite.admin">
					<!-- 제목 -->
					<div class="mb-4">
						<input type="text" name="title" class="form-control"
							placeholder="공지사항 제목을 입력하세요." required maxlength="100">
					</div>

					<!-- 내용 -->
					<div class="mb-4">
						<textarea id="summernote" name="content"></textarea>
					</div>

					<!-- 버튼 -->
					<div class="bottom-buttons">
						<button type="button" class="btn-cancel" onclick="goBack()">취소</button>
						<button type="submit" class="btn-submit">작성하기</button>
					</div>
				</form>
			</div>
		</main>
	</div>

	<script>
		$(document).ready(function() {
		    $('#summernote').summernote({
		        height: 350,
		        lang: 'ko-KR',
		        placeholder: '내용을 입력하세요...',
		        toolbar: [
		            ['style', ['bold', 'italic', 'underline', 'clear']],
		            ['font', ['fontsize', 'color']],
		            ['para', ['ul', 'ol', 'paragraph']],
		            ['insert', ['link', 'picture']],
		            ['view', ['fullscreen', 'codeview', 'help']]
		        ]
		    });
		});
		
		function goBack() {
		    if (confirm("작성 중인 내용이 사라집니다. 돌아가시겠습니까?")) {
		        history.back();
		    }
		}
		
		// 간단한 폼 검증
		$('#noticeForm').on('submit', function(e) {
		    const title = $('input[name="title"]').val().trim();
		    const content = $('#summernote').summernote('code').trim();
		
		    if (!title) {
		        alert("제목을 입력해주세요.");
		        e.preventDefault();
		        return;
		    }
		
		    if (!content || content === '<p><br></p>') {
		        alert("내용을 입력해주세요.");
		        e.preventDefault();
		        return;
		    }
		});
		
		
</script>

</body>
</html>
