<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css">
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<style>
/* ===== 전체 레이아웃 ===== */
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

/* 게시글 수정 폼 스타일 */
.write-container {
    max-width: 800px;
    margin: 0 auto;
}

h1 {
    text-align: center;
    font-size: 28px;
    font-weight: 600;
    margin-bottom: 40px;
    color: #333;
}

.form-section {
    margin-bottom: 30px;
}

.section-title {
    font-size: 16px;
    font-weight: 600;
    color: #333;
    margin-bottom: 8px;
}

.form-control {
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 12px 16px;
    font-size: 14px;
    width: 100%;
}

.form-control:focus {
    border-color: #ff6b6b;
    box-shadow: 0 0 0 3px rgba(255,107,107,0.1);
    outline: none;
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
    background: #ff6b6b;  /* #28a745에서 #ff6b6b로 변경 */
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    font-weight: 500;
    cursor: pointer;
}

.btn-submit:hover {
    background: #ff5252;
}

.btn-cancel:hover {
    background: #dee2e6;
}


/* 작성자 및 작성일 정보 표시 */
.post-info {
    background: #f8f9fa;
    padding: 15px;
    border-radius: 8px;
    margin-bottom: 30px;
    border: 1px solid #e9ecef;
}

.post-info-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
}

.post-info-item:last-child {
    margin-bottom: 0;
}

.post-info-label {
    font-weight: 600;
    color: #666;
}

.post-info-value {
    color: #333;
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
    
    .write-container {
        max-width: 100%;
    }
    
    .bottom-buttons {
        flex-direction: column;
        gap: 10px;
    }
    
    .submit-btn,
    .cancel-btn {
        width: 100%;
    }
    
    .post-info-item {
        flex-direction: column;
        align-items: flex-start;
        gap: 4px;
    }
}
</style>
</head>
<body>
    <!-- 공통 네비게이션 -->
    <jsp:include page="/include/nav.jsp" />
    
    <!-- 사이드바 + 메인 레이아웃 -->
    <div class="layout-wrap">
        
        <!-- 좌측 사이드바 -->
        <jsp:include page="/include/sidebar.jsp">
            <jsp:param name="current" value="posts"/>
        </jsp:include>
        
        <!-- 우측 본문 -->
        <main>
            <div class="write-container">
                <h1>
                    <c:choose>
                        <c:when test="${roomBoard.roomBoardType == 'NOTICE'}">공지 수정</c:when>
                        <c:otherwise>게시글 수정</c:otherwise>
                    </c:choose>
                </h1>
                
                
                <form action="${pageContext.request.contextPath}/roomboardupdate.room" method="post" id="postForm">
                    <!-- 숨겨진 필드들 -->
                    <input type="hidden" name="roomBoardId" value="${roomBoard.roomBoardId}">
                    <input type="hidden" name="roomId" value="${sessionScope.currentRoomId}">
                    <input type="hidden" name="userId" value="${sessionScope.LOGIN_USER.user_id}">
                    <input type="hidden" name="roomBoardType" value="${roomBoard.roomBoardType}">
                    
                    <!-- 제목 입력 -->
                    <div class="form-section">
                        <label class="section-title">제목</label>
                        <input type="text" name="roomBoardTitle" class="form-control" 
                               placeholder="게시글 제목을 입력해주세요" 
                               value="${roomBoard.roomBoardTitle}" 
                               required maxlength="100">
                    </div>
                    
                    <!-- 내용 입력 -->
                    <div class="form-section">
                        <label class="section-title">내용</label>
                        <textarea id="summernote" name="roomBoardContent">${roomBoard.roomBoardContent}</textarea>
                    </div>
                    
                    <!-- 하단 버튼 -->
                    <div class="bottom-buttons">
                        <button type="button" class="btn-cancel" onclick="goBack()">취소</button>
                        <button type="submit" class="btn-submit">수정하기</button>
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
        $(document).ready(function() {
            // Summernote 초기화 시 기존 내용 로드
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
                        
                        // 기존 내용이 있으면 설정
                        var existingContent = `${roomBoard.roomBoardContent}`;
                        if (existingContent && existingContent.trim() !== '') {
                            $('#summernote').summernote('code', existingContent);
                        }
                    },
                    onImageUpload: function(files) {
                        uploadImageToServer(files[0]);
                    }
                }
            });
        });
        
        function uploadImageToServer(file) {
            var data = new FormData();
            data.append("file", file);
            
            $.ajax({
                url: '/imageupload.imageajax',
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
        
        function goBack() {
            if (confirm('수정 중인 내용이 사라집니다. 정말 취소하시겠습니까?')) {
                // 게시글 상세 페이지로 돌아가기
                window.location.href = '${pageContext.request.contextPath}/roomboarddetail.room?roomBoardId=${roomBoard.roomBoardId}&roomId=${roomBoard.roomId}';
            }
        }
        
        // 폼 검증
        document.querySelector('form').addEventListener('submit', function(e) {
            const title = document.querySelector('input[name="roomBoardTitle"]').value.trim();
            const content = $('#summernote').summernote('code').trim();
            
            if (!title) {
                alert('제목을 입력해주세요.');
                e.preventDefault();
                return;
            }
            
            if (!content || content === '<p><br></p>') {
                alert('내용을 입력해주세요.');
                e.preventDefault();
                return;
            }
            
            // 수정 확인
            if (!confirm('게시글을 수정하시겠습니까?')) {
                e.preventDefault();
                return;
            }
        });
        
        // 페이지 이탈 방지 (수정 중일 때)
        let isFormChanged = false;
        let originalTitle = document.querySelector('input[name="roomBoardTitle"]').value;
        let originalContent = '';
        
        // Summernote 로드 완료 후 원본 내용 저장
        setTimeout(function() {
            originalContent = $('#summernote').summernote('code');
        }, 1000);
        
        // 폼 변경 감지
        document.querySelector('input[name="roomBoardTitle"]').addEventListener('input', function() {
            if (this.value !== originalTitle) {
                isFormChanged = true;
            }
        });
        
        $('#summernote').on('summernote.change', function() {
            if ($('#summernote').summernote('code') !== originalContent) {
                isFormChanged = true;
            }
        });
        
        // 페이지 이탈 시 경고
        window.addEventListener('beforeunload', function(e) {
            if (isFormChanged) {
                e.preventDefault();
                e.returnValue = '수정 중인 내용이 있습니다. 정말 나가시겠습니까?';
                return e.returnValue;
            }
        });
        
        // 폼 제출 시에는 이탈 방지 해제
        document.querySelector('form').addEventListener('submit', function() {
            isFormChanged = false;
        });
    </script>
</body>
</html>