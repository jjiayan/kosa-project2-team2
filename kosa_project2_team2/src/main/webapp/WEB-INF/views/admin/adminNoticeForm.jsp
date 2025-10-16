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
		     <header class="page-header">
		        <h1>공지사항 글쓰기</h1>
		     </header>
			<div class="notice-container">
				<form id="noticeForm" method="post"
				      action="${pageContext.request.contextPath}/${notice != null ? 'adminNoticeUpdate.admin' : 'adminNoticeWrite.admin'}">
				
				    <c:if test="${notice != null}">
				        <input type="hidden" name="noticeId" value="${notice.adminNoticeId}">
				    </c:if>
				
				    <!-- 제목 -->
				    <div class="mb-4">
				        <input type="text" name="title" class="form-control"
				               placeholder="공지사항 제목을 입력하세요."
				               value="${notice != null ? notice.adminNoticeTitle : ''}"
				               required maxlength="100">
				    </div>
				
				    <!-- 내용 -->
				    <div class="mb-4">
				        <textarea id="summernote" name="content">
				            ${notice != null ? notice.adminNoticeContent : ''}
				        </textarea>
				    </div>
				
				    <!-- 버튼 -->
				    <div class="bottom-buttons">
				        <button type="button" class="btn-cancel" onclick="goBack()">취소</button>
				        <button type="button" class="btn-submit" id="btnWrite">
				            ${notice != null ? '수정하기' : '작성하기'}
				        </button>
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
          ['view', ['codeview', 'help']]
      ],
      callbacks: { // 이미지 업로드 시 서버로 전송
          onImageUpload: function(files) {
              if (files && files[0]) uploadImageToServer(files[0]);
          }
      }
  });
});

// room/ajax/ImageAjaxController 사용  
function uploadImageToServer(file) {
    const fd = new FormData();
    fd.append('file', file);

    $.ajax({
        url: '${pageContext.request.contextPath}/imageupload.imageajax',
        method: 'POST',
        data: fd,
        processData: false,
        contentType: false,
        success: function(resp) {
            const saved = resp.trim(); 
            $('#summernote').summernote('insertImage', '${pageContext.request.contextPath}' + saved);
        },
        error: function() {
            const fr = new FileReader();
            fr.onload = e => {
                $('#summernote').summernote('insertImage', e.target.result);
                alert('이미지 업로드 실패! 임시로 삽입되었습니다.');
            };
            fr.readAsDataURL(file);
        }
    });
}

// 뒤로가기 버튼
function goBack() {
  if (confirm("작성 중인 내용이 사라집니다. 돌아가시겠습니까?")) {
      history.back();
  }
}

// 작성하기 버튼 클릭 → Ajax 요청
$(document).on("click", "#btnWrite", function() {
    const title = $('input[name="title"]').val().trim();
    const content = $('#summernote').summernote('code').trim();
    const noticeId = $('input[name="noticeId"]').val(); // ← 수정 시 존재


    if (!title) {
        alert("제목을 입력해주세요.");
        return;
    }
    if (!content || content === '<p><br></p>') {
        alert("내용을 입력해주세요.");
        return;
    }
    
    const url = noticeId
    ? "${pageContext.request.contextPath}/adminNoticeUpdate.admin"
    : "${pageContext.request.contextPath}/adminNoticeWrite.admin";

	const data = noticeId ? { noticeId, title, content } : { title, content };


    $.ajax({
    	url: url,
        type: "POST",
        data: data,
        success: function(res) { 
            try {
                const json = typeof res === "string" ? JSON.parse(res) : res;
                if (json.success) {
                    alert(noticeId ? "공지사항이 수정되었습니다." : "공지사항이 등록되었습니다.");
                    location.href = "${pageContext.request.contextPath}/adminNotice.admin";
                } else {
                    alert(json.message || "등록에 실패했습니다.");
                }
            } catch (e) { 
                alert(noticeId ? "공지사항이 수정되었습니다." : "공지사항이 등록되었습니다.");
                location.href = "${pageContext.request.contextPath}/adminNotice.admin";
            }
        },
        error: function(xhr) {
            if (xhr.status === 403) {
                alert("관리자만 작성/수정할 수 있습니다.");
            } else {
                alert("오류가 발생했습니다. 다시 시도해주세요.");
            }
        }
    });
});
</script>


</body>
</html>
