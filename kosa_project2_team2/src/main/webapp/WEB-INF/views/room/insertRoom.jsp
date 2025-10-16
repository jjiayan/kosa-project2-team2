<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>모임방 생성</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css"/>
  <style>
    main { background:#f5f5f5; padding:40px 20px; min-height:100vh; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif }
    .form-container{ max-width:800px; margin:0 auto; background:#fff; padding:40px; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,.1) }
    h1{ text-align:center; font-size:24px; font-weight:600; margin-bottom:40px; color:#333 }
    .form-section{ margin-bottom:30px }
    .thumbnail-upload{ border:2px dashed #ddd; border-radius:8px; padding:30px 20px; text-align:center; cursor:pointer; transition:.3s; background:#fafafa; min-height:150px; max-width:500px; margin:0 auto; display:flex; align-items:center; justify-content:center; position:relative }
    .thumbnail-upload:hover{ border-color:#ff6b6b; background:#fff }
    .thumbnail-upload.has-image{ padding:0; min-height:auto }
    .thumbnail-preview{ width:100%; height:auto; max-width:500px; max-height:300px; object-fit:contain; border-radius:8px; display:block; margin:0 auto }
    #thumbnailText{ font-size:14px; color:#999 }
    .form-control,.form-select{ border:1px solid #ddd; border-radius:8px; padding:12px 16px; font-size:14px }
    .form-control:focus,.form-select:focus{ border-color:#ff6b6b; box-shadow:0 0 0 3px rgba(255,107,107,.1) }
    .select-row{ display:grid; grid-template-columns:1fr 1fr; gap:12px; margin-bottom:12px }
    .section-title{ font-size:14px; font-weight:600; color:#333; margin-bottom:15px }
    .btn-delete{ padding:10px 24px; background:#fff; color:#ff6b6b; border:1px solid #ff6b6b; border-radius:8px; font-size:14px; font-weight:500; cursor:pointer; margin-bottom:15px; display:inline-block }
    .btn-delete:hover{ background:#ff6b6b; color:#fff }
    .note-editor{ border:1px solid #ddd; border-radius:8px }
    .bottom-buttons{ display:flex; gap:12px; justify-content:center; margin-top:40px }
    .btn-cancel{ padding:14px 40px; background:#e9ecef; color:#666; border:none; border-radius:8px; font-size:16px; font-weight:500; cursor:pointer }
    .btn-submit{ padding:14px 40px; background:#ff6b6b; color:#fff; border:none; border-radius:8px; font-size:16px; font-weight:500; cursor:pointer }
    .btn-cancel:hover{ background:#dee2e6 }
    .btn-submit:hover{ background:#ff5252 }
    
    /* 자격증 검색 관련 스타일 */
    .search-container { position: relative; }
    .search-container .form-control:focus { border-color: #ff6b6b; box-shadow: 0 0 0 3px rgba(255,107,107,.1); }
    .certificate-item:hover { background-color: #f8f9fa !important; }
    .certificate-item:last-child { border-bottom: none !important; }
    #certificateDropdown { box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
    .search-icon { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); color: #999; }
  </style>
</head>
<body>
<jsp:include page="/include/nav.jsp" />
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<main>
  <div class="form-container">
    <h1>모임방 생성</h1>

    <form action="${ctx}/insert.room" method="post" id="postForm">
      <input type="hidden" name="userId" id="userId" value="${sessionScope.LOGIN_USER.user_id}"/>

      <!-- 지역/자격증 -->
      <div class="form-section">
        <div class="select-row">
          <div>
            <select class="form-select" name="region1" id="region1">
              <option value="">지역</option>
              <c:forEach var="region" items="${mainRegionList}">
                <option value="${region.mainRegionId}">${region.mainRegion}</option>
              </c:forEach>
            </select>
          </div>
          <div>
            <select class="form-select" name="region2" id="region2">
              <option value="">구/군 선택</option>
            </select>
          </div>
        </div>

        <div class="select-row">
  <div>
    <select class="form-select" name="examType" id="examType">
      <option value="">구분</option>
      <option value="필기">필기</option>
      <option value="실기">실기</option>
    </select>
  </div>
  <div>
    <div class="search-container">
      <input type="text" 
             class="form-control" 
             id="certificateSearch" 
             placeholder="자격증을 검색하세요" 
             autocomplete="off"
             style="padding-right: 40px;">
      <span class="search-icon">🔍</span>
      
      <!-- 검색 결과 드롭다운 -->
      <div id="certificateDropdown" 
           style="position: absolute; top: 100%; left: 0; right: 0; 
                  background: white; border: 1px solid #ddd; border-top: none; 
                  border-radius: 0 0 8px 8px; max-height: 200px; overflow-y: auto; 
                  z-index: 1000; display: none;">
      </div>
      
      <!-- 선택된 값을 저장할 hidden input -->
      <input type="hidden" name="jmcd" id="certificateCode">
      <input type="hidden" name="year" id="certificateYear">
      <input type="hidden" name="implseq" id="certificateImplseq">
    </div>
  </div>
</div>

        <div class="select-row">
          <div>
            <select class="form-select" name="maxParticipant">
              <option value="">최대 인원</option>
              <option value="10">10명</option>
              <option value="20">20명</option>
              <option value="30">30명</option>
              <option value="40">40명</option>
              <option value="50">50명</option>
            </select>
          </div>
          <div></div>
        </div>

        <input type="text" class="form-control" placeholder="모임방 제목을 입력하세요" name="title" required/>
      </div>

      <!-- 썸네일 -->
      <div class="form-section">
        <div class="section-title">
          스터디 썸네일
          <button type="button" class="btn-delete" onclick="document.getElementById('thumbnailInput').click()" style="float:right;margin-top:-5px">
            📎 파일 선택
          </button>
        </div>

        <div class="thumbnail-upload" id="thumbnailArea" onclick="document.getElementById('thumbnailInput').click()">
          <div id="thumbnailText">
            📷 클릭하거나 이미지를 드래그하세요<br/>
            <small style="color:#ccc;font-size:12px">권장 크기: 800x400 (2:1 비율)</small>
          </div>
          <img id="thumbnailPreview" class="thumbnail-preview" style="display:none"/>
        </div>
        <input type="file" id="thumbnailInput" name="thumbnail" accept="image/*" style="display:none"/>
      </div>

      <!-- 소개 -->
      <div class="form-section">
        <div class="section-title">소개</div>
        <textarea id="summernote" name="content"></textarea>
      </div>

      <div class="bottom-buttons">
        <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
        <button type="submit" class="btn-submit">생성하기</button>
      </div>
    </form>
  </div>
</main>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>
<script>
  const ctx='${ctx}';

  $(function(){
    // 드래그&드롭/파일 선택
    $('#thumbnailInput').on('change', e => {
      if (e.target.files && e.target.files[0]) handleThumbnail(e.target.files[0]);
    });
    $('.thumbnail-upload').on('dragover', e => { e.preventDefault(); e.stopPropagation(); $(e.currentTarget).css('border-color','#ff6b6b') });
    $('.thumbnail-upload').on('dragleave', e => { e.preventDefault(); e.stopPropagation(); $(e.currentTarget).css('border-color','#ddd') });
    $('.thumbnail-upload').on('drop', e => {
      e.preventDefault(); e.stopPropagation(); $(e.currentTarget).css('border-color','#ddd');
      let files=e.originalEvent.dataTransfer.files;
      if(files.length>0 && files[0].type.startsWith('image/')) handleThumbnail(files[0]);
    });

    $('#summernote').summernote({
      height:300, lang:'ko-KR', placeholder:'내용을 입력하세요...',
      toolbar:[
        ['style',['style']],['font',['bold','italic','underline','clear']],
        ['color',['color']],['para',['ul','ol','paragraph']],
        ['table',['table']],['insert',['link','picture']],['view',['codeview','help']]
      ],
      callbacks:{
        onInit:function(){ $('.note-editable').attr({'data-gramm':'false','data-gramm_editor':'false','data-enable-grammarly':'false'}) },
        onImageUpload:function(files){ if(files && files[0]) uploadEditorImage(files[0]) }
      }
    });

    // 지역 하위 조회
    $('#region1').on('change', function(){
      const parentId=$(this).val();
      const $r2=$('#region2').html('<option value="">구/군 선택</option>');
      if(!parentId) return;
      $.ajax({
        url: ctx + '/getsubregion.roomajax',
        data: { parentId },
        success: function(list){
          $.each(list, function(_,item){
            $r2.append('<option value="'+item.subRegionId+'">'+item.subRegion+'</option>')
          });
        }
      });
    });

 // 자격증 검색 기능
    let certificateTimeout;
    
    $('#certificateSearch').on('input', function() {
      const keyword = $(this).val().trim();
      const examType = $('#examType').val();
      
      clearTimeout(certificateTimeout);
      
      if (keyword.length < 2) {
        $('#certificateDropdown').hide();
        return;
      }
      
      certificateTimeout = setTimeout(() => {
        searchCertificates(keyword, examType);
      }, 300); // 300ms 딜레이
    });
    
    // 엔터키로 검색
    $('#certificateSearch').on('keypress', function(e) {
      if (e.which === 13) { // 엔터키
        e.preventDefault();
        const keyword = $(this).val().trim();
        const examType = $('#examType').val();
        
        if (keyword.length >= 2) {
          clearTimeout(certificateTimeout);
          searchCertificates(keyword, examType);
        }
      }
    });
    
    // 필기/실기 변경 시 검색어 초기화
    $('#examType').on('change', function() {
      $('#certificateSearch').val('');
      $('#certificateDropdown').hide();
      $('#certificateCode').val('');
      $('#certificateYear').val('');
      $('#certificateImplseq').val('');
    });
    
    // 검색창 외부 클릭 시 드롭다운 숨기기
    $(document).on('click', function(e) {
      if (!$(e.target).closest('.search-container').length) {
        $('#certificateDropdown').hide();
      }
    });
  });

  function handleThumbnail(file){
    if(!file || !file.type.startsWith('image/')) { alert('이미지 파일만 업로드 가능합니다.'); return; }
    const fd=new FormData(); fd.append('file', file);
    $('#thumbnailText').html('⏳ 업로드 중...'); $('#thumbnailPreview').hide();

    $.ajax({
      url: ctx + '/imageupload.imageajax', method:'POST', data:fd, processData:false, contentType:false,
      success:function(response){
        const saved=response.trim();              // "/files/yyyy-MM-dd/uuid.ext"
        const imageUrl=ctx + saved;

        $('#thumbnailPreview').attr('src', imageUrl).show();
        $('#thumbnailText').hide();
        $('#thumbnailArea').addClass('has-image');

        // DB 저장용 hidden: "/files/..." 그대로 저장
        let $h=$('#thumbnailUrl');
        if($h.length===0) {
          $('<input>',{type:'hidden',id:'thumbnailUrl',name:'thumbnailUrl',value:saved}).appendTo('#postForm');
        } else {
          $h.val(saved);
        }
      },
      error:function(){
        alert('썸네일 업로드 실패! 로컬 미리보기로 대체합니다.');
        const fr=new FileReader();
        fr.onload=e=>{ $('#thumbnailPreview').attr('src', e.target.result).show(); $('#thumbnailText').hide(); $('#thumbnailArea').addClass('has-image'); };
        fr.readAsDataURL(file);
      }
    });
  }

  function uploadEditorImage(file){
    const fd=new FormData(); fd.append('file', file);
    $.ajax({
      url: ctx + '/imageupload.imageajax', method:'POST', data:fd, processData:false, contentType:false,
      success: function(response){
        const saved=response.trim();           // "/files/..."
        $('#summernote').summernote('insertImage', ctx + saved);
      },
      error: function(){
        const fr=new FileReader();
        fr.onload=e=>{ $('#summernote').summernote('insertImage', e.target.result); alert('이미지 업로드 실패! 임시로 삽입했습니다.'); };
        fr.readAsDataURL(file);
      }
    });
  }

  function searchCertificates(keyword, examType) {
    $.ajax({
      url: ctx + '/searchcertificate.roomajax',
      method: 'GET',
      data: { 
    	  keyword: keyword,
    	  examType: examType
    	  
    	  },
      success: function(response) {
    	  console.log(response);
        displayCertificateResults(response);
      },
      error: function() {
        $('#certificateDropdown').html('<div style="padding: 10px; color: #999;">검색 중 오류가 발생했습니다.</div>').show();
      }
    });
  }

  function displayCertificateResults(certificates) {
	  const $dropdown = $('#certificateDropdown');
	  
	  if (!certificates || certificates.length === 0) {
	    $dropdown.html('<div style="padding: 10px; color: #999;">검색 결과가 없습니다.</div>').show();
	    return;
	  }
	  
	  let html = '';
	  certificates.forEach(cert => {
	    html += '<div class="certificate-item" ' +
	            'style="padding: 10px; cursor: pointer; border-bottom: 1px solid #f0f0f0;" ' +
	            'data-code="' + cert.jmcd + '" ' +
	            'data-name="' + cert.totalJmName + '" ' +
	            'data-year="' + cert.year + '" ' +
	            'data-implseq="' + cert.implseq + '" ' +
	            'onmouseover="this.style.backgroundColor=\'#f8f9fa\'" ' +
	            'onmouseout="this.style.backgroundColor=\'white\'" ' +
	            'onclick="selectCertificate(\'' + cert.jmcd + '\', \'' + cert.totalJmName + '\', \'' + cert.year + '\', \'' + cert.implseq + '\')">' +
	            '<div style="font-weight: 500;">' + cert.totalJmName + '</div>' +
	            '<div style="font-size: 12px; color: #666;">' + cert.year + '년 ' + cert.implseq + '회</div>' +
	            '</div>';
	  });
	  
	  $dropdown.html(html).show();
	}

  function selectCertificate(code, name, year, implseq) {
    $('#certificateSearch').val(name);
    $('#certificateCode').val(code);
    $('#certificateYear').val(year);
    $('#certificateImplseq').val(implseq);
    $('#certificateDropdown').hide();
  }
</script>
</body>
</html>