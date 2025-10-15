<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>게시글 작성</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css"/>
  <style>
    .layout-wrap{ display:grid; grid-template-columns:auto 1fr; gap:0; align-items:flex-start; margin:0; padding:0 }
    main{ background:#fff; border-left:1px solid #e5e7eb; padding:24px 28px; min-height:100vh }
    .write-container{ max-width:800px; margin:0 auto }
    h1{ text-align:center; font-size:28px; font-weight:600; margin-bottom:40px; color:#333 }
    .form-section{ margin-bottom:30px }
    .section-title{ font-size:16px; font-weight:600; color:#333; margin-bottom:8px }
    .form-control{ border:1px solid #ddd; border-radius:8px; padding:12px 16px; font-size:14px; width:100% }
    .form-control:focus{ border-color:#ff6b6b; box-shadow:0 0 0 3px rgba(255,107,107,.1) }
    .note-editor{ border:1px solid #ddd; border-radius:8px }
    .bottom-buttons{ display:flex; gap:12px; justify-content:center; margin-top:40px }
    .btn-cancel{ padding:14px 40px; background:#e9ecef; color:#666; border:none; border-radius:8px; font-size:16px; font-weight:500; cursor:pointer }
    .btn-submit{ padding:14px 40px; background:#ff6b6b; color:#fff; border:none; border-radius:8px; font-size:16px; font-weight:500; cursor:pointer }
    .btn-cancel:hover{ background:#dee2e6 }
    .btn-submit:hover{ background:#ff5252 }
    @media (max-width:900px){
      .layout-wrap{ grid-template-columns:1fr }
      main{ border-left:none; border-top:1px solid #e5e7eb; padding:16px }
      .write-container{ max-width:100% }
      .bottom-buttons{ flex-direction:column; gap:10px }
    }
  </style>
</head>
<body>
<jsp:include page="/include/nav.jsp" />
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="layout-wrap">
  <jsp:include page="/include/sidebar.jsp">
    <jsp:param name="current" value="${roomBoardType == 'NOTICE' ? 'notice' : 'posts'}"/>
</jsp:include>
  <main>
    <div class="write-container">
      <h1>
        <c:choose>
          <c:when test="${roomBoardType == 'NOTICE'}">공지 작성</c:when>
          <c:otherwise>게시글 작성</c:otherwise>
        </c:choose>
      </h1>

      <form action="${ctx}/roomboardinsert.room" method="post" id="postForm">
        <input type="hidden" name="roomId" value="${param.roomId}"/>
        <input type="hidden" name="userId" value="${sessionScope.LOGIN_USER.user_id}"/>
        <input type="hidden" name="roomBoardType" value="${roomBoardType}"/>

        <div class="form-section">
          <label class="section-title">제목</label>
          <input type="text" name="roomBoardTitle" class="form-control" placeholder="게시글 제목을 입력해주세요" required maxlength="100"/>
        </div>

        <div class="form-section">
          <label class="section-title">내용</label>
          <textarea id="summernote" name="roomBoardContent"></textarea>
        </div>

        <div class="bottom-buttons">
          <button type="button" class="btn-cancel" onclick="goBack()">취소</button>
          <button type="submit" class="btn-submit">작성하기</button>
        </div>
      </form>
    </div>
  </main>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>
<script>
  const ctx='${ctx}';
  $(function(){
    $('#summernote').summernote({
      height:300, lang:'ko-KR', placeholder:'내용을 입력하세요...',
      toolbar:[
        ['style',['style']],['font',['bold','italic','underline','clear']],
        ['color',['color']],['para',['ul','ol','paragraph']],
        ['table',['table']],['insert',['link','picture']],['view',['codeview','help']]
      ],
      callbacks:{
        onInit:function(){ $('.note-editable').attr({'data-gramm':'false','data-gramm_editor':'false','data-enable-grammarly':'false'}) },
        onImageUpload:function(files){ if(files && files[0]) uploadImageToServer(files[0]) }
      }
    });
  });

  function uploadImageToServer(file){
    const fd=new FormData(); fd.append('file', file);
    $.ajax({
      url: ctx + '/imageupload.imageajax', method:'POST', data:fd, processData:false, contentType:false,
      success:function(resp){
        const saved=resp.trim();                       // "/files/..."
        $('#summernote').summernote('insertImage', ctx + saved);
      },
      error:function(){
        const fr=new FileReader();
        fr.onload=e=>{ $('#summernote').summernote('insertImage', e.target.result); alert('이미지 업로드 실패! 임시로 삽입되었습니다.'); };
        fr.readAsDataURL(file);
      }
    });
  }

  function goBack(){ if(confirm('작성 중인 내용이 사라집니다. 취소할까요?')) history.back(); }

  document.getElementById('postForm').addEventListener('submit', function(e){
    const title=$('input[name="roomBoardTitle"]').val().trim();
    const content=$('#summernote').summernote('code').trim();
    if(!title){ alert('제목을 입력해주세요.'); e.preventDefault(); return; }
    if(!content || content === '<p><br></p>'){ alert('내용을 입력해주세요.'); e.preventDefault(); return; }
  });
</script>
</body>
</html>
