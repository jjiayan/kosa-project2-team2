<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모임방 생성</title>
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
    
    <style>
        body {
            background: #f5f5f5;
            padding: 40px 20px;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        h1 {
            text-align: center;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 40px;
            color: #333;
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .thumbnail-upload {
            border: 2px dashed #ddd;
            border-radius: 8px;
            padding: 30px 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            background: #fafafa;
            min-height: 150px;
            max-width: 500px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }
        
        .thumbnail-upload:hover {
            border-color: #ff6b6b;
            background: #fff;
        }
        
        .thumbnail-upload.has-image {
            padding: 0;
            min-height: auto;
        }
        
        .thumbnail-preview {
            width: 100%;
            height: auto;
            max-width: 500px;
            max-height: 300px;
            object-fit: contain;
            border-radius: 8px;
            display: block;
            margin: 0 auto;
        }
        
        #thumbnailText {
            font-size: 14px;
            color: #999;
        }
        
        .form-control, .form-select {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 14px;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #ff6b6b;
            box-shadow: 0 0 0 3px rgba(255,107,107,0.1);
        }
        
        .select-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 12px;
        }
        
        .section-title {
            font-size: 14px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
        }
        
        .btn-delete {
            width: auto;
            padding: 10px 24px;
            background: white;
            color: #ff6b6b;
            border: 1px solid #ff6b6b;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            margin-bottom: 15px;
            display: inline-block;
        }
        
        .btn-delete:hover {
            background: #ff6b6b;
            color: white;
        }
        
        .note-editor {
            border: 1px solid #ddd;
            border-radius: 8px;
        }
        
        .bottom-buttons {
            display: flex;
            gap: 12px;
            justify-content: center;
            margin-top: 40px;
        }
        
        .btn-cancel {
            padding: 14px 40px;
            background: #e9ecef;
            color: #666;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
        }
        
        .btn-submit {
            padding: 14px 40px;
            background: #ff6b6b;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
        }
        
        .btn-cancel:hover {
            background: #dee2e6;
        }
        
        .btn-submit:hover {
            background: #ff5252;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>모임방 생성</h1>
        
        <form action="insert.room" method="post" id="postForm">
            
            <!-- 지역 및 자격증 선택 -->
            <div class="form-section">
                <div class="select-row">
                    <div>
                        <select class="form-select" name="region1" id="region1">
                            <option selected>지역</option> 
                            <c:forEach var="region" items="${mainRegionList}" >
                            	<option value="${region.mainRegionId}">${region.mainRegion}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <select class="form-select" name="region2" id="region2">
                            <option selected>구/군 선택</option>
                            <option value="강남구">강남구</option>
                            <option value="서초구">서초구</option>
                            <option value="송파구">송파구</option>
                        </select>
                    </div>
                </div>
                
                <div class="select-row">
                    <div>
                        <select class="form-select" name="certificate1">
                            <option selected>자격증</option>
                            <option value="기사">기사</option>
                            <option value="산업기사">산업기사</option>
                        </select>
                    </div>
                    <div>
                        <select class="form-select" name="certificate2">
                            <option selected>자격증 상세</option>
                            <option value="정보처리기사">정보처리기사</option>
                            <option value="전기기사">전기기사</option>
                        </select>
                    </div>
                </div>
                
                <!-- 최대인원 선택 추가 -->
                <div class="select-row">
                    <div>
                        <select class="form-select" name="maxParticipant">
                            <option selected>최대 인원</option>
                            <option value="10">10명</option>
                            <option value="20">20명</option>
                            <option value="30">30명</option>
                            <option value="40">40명</option>
                            <option value="50">50명</option>
                        </select>
                    </div>
                    <div></div>
                </div>
                
                <input type="text" class="form-control" placeholder="모임방 제목을 입력하세요" name="title">
            </div>
            
            <!-- 스터디 썸네일 -->
            <div class="form-section">
                <div class="section-title">
                    스터디 썸네일
                    <button type="button" class="btn-delete" onclick="deleteThumbnail()" style="float: right; margin-top: -5px;">
                        📎 파일 선택
                    </button>
                </div>
                
                <div class="thumbnail-upload" id="thumbnailArea" onclick="document.getElementById('thumbnailInput').click()">
                    <div id="thumbnailText">
                        📷 클릭하거나 이미지를 드래그하세요<br>
                        <small style="color: #ccc; font-size: 12px;">권장 크기: 800x400 (2:1 비율)</small>
                    </div>
                    <img id="thumbnailPreview" class="thumbnail-preview" style="display:none;">
                </div>
                <input type="file" id="thumbnailInput" name="thumbnail" accept="image/*" style="display:none;">
            </div>
            
            <!-- 소개 -->
            <div class="form-section">
                <div class="section-title">소개</div>
                <textarea id="summernote" name="content"></textarea>
            </div>
            
            <!-- 하단 버튼 -->
            <div class="bottom-buttons">
                <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                <button type="submit" class="btn-submit">생성하기</button>
            </div>
            
        </form>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>
    
    <script>
        $(document).ready(function() {
            $('#thumbnailInput').on('change', function(e) {
                if (e.target.files && e.target.files[0]) {
                    handleThumbnail(e.target.files[0]);
                }
            });
            
            $('.thumbnail-upload').on('dragover', function(e) {
                e.preventDefault();
                e.stopPropagation();
                $(this).css('border-color', '#ff6b6b');
            });
            
            $('.thumbnail-upload').on('dragleave', function(e) {
                e.preventDefault();
                e.stopPropagation();
                $(this).css('border-color', '#ddd');
            });
            
            $('.thumbnail-upload').on('drop', function(e) {
                e.preventDefault();
                e.stopPropagation();
                $(this).css('border-color', '#ddd');
                
                let files = e.originalEvent.dataTransfer.files;
                if (files.length > 0 && files[0].type.startsWith('image/')) {
                    handleThumbnail(files[0]);
                }
            });
            
            $('#summernote').summernote({
			    height: 300,
			    lang: 'ko-KR',
			    placeholder: '내용을 입력하세요...',
			    disableDragAndDrop: false,
			    toolbar: [
			        ['style', ['style']],
			        ['font', ['bold', 'italic', 'underline', 'clear']],
			        ['color', ['color']],
			        ['para', ['ul', 'ol', 'paragraph']],
			        ['table', ['table']],
			        ['insert', ['link', 'picture']],
			        ['view', ['codeview', 'help']]
			    ],
			    callbacks: {
			        onInit: function() {
			            $('.note-editable').attr('data-gramm', 'false');
			            $('.note-editable').attr('data-gramm_editor', 'false');
			            $('.note-editable').attr('data-enable-grammarly', 'false');
			        },
			        onImageUpload: function(files) {
			            uploadImageToServer(files[0]);
			        }
			    }
			});
        });
        
        function handleThumbnail(file) {
            if (!file) {
                console.error('파일이 선택되지 않았습니다.');
                return;
            }
            
            if (!file.type.startsWith('image/')) {
                alert('이미지 파일만 업로드 가능합니다.');
                return;
            }
            
            uploadThumbnailToServer(file);
        }
        
        function uploadThumbnailToServer(file) {
            let data = new FormData();
            data.append("file", file);
            
            $('#thumbnailText').html('⏳ 업로드 중...');
            $('#thumbnailPreview').hide();
            
            $.ajax({
                url: '/kosa_project2_team2/imageupload.imageajax',
                method: 'POST',
                data: data,
                processData: false,
                contentType: false,
                success: function(response) {
                    let fileName = response.trim();
                    let imageUrl = '/upload/thumbnail/' + fileName;
                    
                    $('#thumbnailPreview').attr('src', imageUrl).show();
                    $('#thumbnailText').hide();
                    $('#thumbnailArea').addClass('has-image');
                    
                    if ($('#thumbnailUrl').length === 0) {
                        $('<input>').attr({
                            type: 'hidden',
                            id: 'thumbnailUrl',
                            name: 'thumbnailUrl',
                            value: imageUrl
                        }).appendTo('#postForm');
                    } else {
                        $('#thumbnailUrl').val(fileName);
                    }
                },
                error: function(xhr, status, error) {
                    alert('썸네일 업로드 실패!');
                    console.error('Upload error:', error);
                    
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        $('#thumbnailPreview').attr('src', e.target.result).show();
                        $('#thumbnailText').hide();
                        $('#thumbnailArea').addClass('has-image');
                    };
                    reader.readAsDataURL(file);
                }
            });
        }
        
        function deleteThumbnail() {
            document.getElementById('thumbnailInput').click();
        }
        
        function uploadImageToServer(file) {
            var data = new FormData();
            data.append("file", file);
            
            $.ajax({
                url: '/kosa_project2_team2/imageupload.imageajax',
                method: 'POST',
                data: data,
                processData: false,
                contentType: false,
                success: function(response) {
                    let fileName = response.trim();
                    let imageUrl = '/upload/thumbnail/' + fileName;
                    $('#summernote').summernote('insertImage', imageUrl);
                },
                error: function() {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        $('#summernote').summernote('insertImage', e.target.result);
                        alert('이미지 업로드 실패! 임시로 삽입되었습니다.');
                    };
                    reader.readAsDataURL(file);
                }
            });
        }
        
        $('#region1').on('change',function(){
        	const parentId = $(this).val();
        	const region2Select = $('#region2');
        	// 초기화
            region2Select.html('<option value="">구/군 선택</option>');
            
            if (!parentId) {
                region2Select.html('<option value="">먼저 시/도를 선택하세요</option>');
                return;
            }
            
            $.ajax({
            	url: '/kosa_project2_team2/getsubregion.roomajax',
            	data: {parentId: parentId},
            	success: function(response){
            		$.each(response, function(index, item) {
                        region2Select.append(
                            '<option value="' + item.subRegionId + '">' + item.subRegion + '</option>'
                        );
                    })
            	}
            })
        	
        })
                 
    </script>
</body>
</html>