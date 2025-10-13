<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>댓글 시스템</title>
</head>
<body>
	
	<!-- 댓글 영역 -->
	<div class="reply-container">
		<div class="reply-header">
			<div class="reply-count">
				댓글 <span id="replyTotalCount">0</span>
			</div>
			<div class="reply-sort">
				<button class="sort-btn active" data-order="ASC">등록순</button>
				<button class="sort-btn" data-order="DESC">최신순</button>
			</div>
		</div>
		
		<!-- 댓글 작성 폼 -->
		<div class="reply-write-form">
			<textarea id="replyContent" placeholder="댓글을 입력하세요..." maxlength="1000"></textarea>
			<div class="reply-write-actions">
				<span class="char-count"><span id="currentLength">0</span> / 1000</span>
				<button class="btn-submit" onclick="writeReply()">댓글 등록</button>
			</div>
		</div>
		
		<!-- 댓글 목록 -->
		<div id="replyList">
			<div class="loading">댓글을 불러오는 중...</div>
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		// 게시글 ID
		const ROOM_BOARD_ID = ${roomBoardId};
		let currentOrder = 'ASC'; // 기본값: 등록순
		
		$(document).ready(function() {
			// 페이지 로드 시 등록순으로 댓글 목록 불러오기
			loadReplyList();
			
			// 글자 수 카운터
			$('#replyContent').on('input', function() {
				$('#currentLength').text($(this).val().length);
			});
			
			// 정렬 버튼 클릭
			$('.sort-btn').on('click', function() {
				$('.sort-btn').removeClass('active');
				$(this).addClass('active');
				currentOrder = $(this).data('order');
				loadReplyList();
			});
		});
		
		/**
		 * 댓글 목록 불러오기
		 */
		function loadReplyList() {
			$.ajax({
				url: '${pageContext.request.contextPath}/reply/query',
				type: 'GET',
				dataType: 'json',
				data: {
					action: 'list',
					roomBoardId: ROOM_BOARD_ID,
					orderBy: currentOrder
				},
				success: function(response) {
					if (response.success) {
						displayReplyList(response.replies);
						$('#replyTotalCount').text(response.totalCount);
					} else {
						alert(response.message);
					}
				},
				error: function(xhr, status, error) {
					console.error('Error:', error);
					alert('서버 오류가 발생했습니다.');
				}
			});
		}
		
		/**
		 * 댓글 목록 표시
		 */
		function displayReplyList(replies) {
			const $replyList = $('#replyList');
			$replyList.empty();
			
			if (replies.length === 0) {
				$replyList.html('<div class="empty-state">첫 댓글을 작성해보세요!</div>');
				return;
			}
			
			replies.forEach(function(reply) {
				$replyList.append(createReplyHtml(reply, false));
				
				if (reply.replies && reply.replies.length > 0) {
					reply.replies.forEach(function(childReply) {
						$replyList.append(createReplyHtml(childReply, true));
					});
				}
			});
		}
		
		/**
		 * 댓글 HTML 생성
		 */
		 /**
		  * 댓글 HTML 생성
		  */
		 function createReplyHtml(reply, isChild) {
		     var childClass = isChild ? 'child-reply' : '';
		     var contextPath = '${pageContext.request.contextPath}';
		     var profileImg = reply.userPhoto ? 
		         '<img src="' + contextPath + reply.userPhoto + '" alt="프로필" class="profile-img">' :
		         '<img src="' + contextPath + '/images/default-avatar.png" alt="프로필" class="profile-img">';
		     
		     // 삭제된 댓글 처리
		     if (reply.status === 'DELETED') {
		         var html = '<div class="reply-item ' + childClass + '" data-reply-id="' + reply.replyId + '">';
		         html += '<div class="reply-item-header">';
		         html += '<div class="reply-author">';
		         html += profileImg;
		         html += '<div class="author-info">';
		         html += '<span class="author-name">' + escapeHtml(reply.userNickname) + '</span>';
		         html += '<span class="reply-time">' + (reply.timeAgo || '') + '</span>';
		         html += '</div>';
		         html += '</div>';
		         html += '</div>';
		         html += '<div class="reply-content" style="color: #999; font-style: italic;">';
		         html += '삭제된 댓글입니다.';
		         html += '</div>';
		         html += '</div>';
		         
		         return html;
		     }
		     
		     // 정상 댓글 처리
		     var actionButtons = '';
		     if (reply.owner) {
		         actionButtons = '<button class="btn-action" onclick="editReply(' + reply.replyId + ')">수정</button>' +
		             '<button class="btn-action" onclick="deleteReply(' + reply.replyId + ')">삭제</button>';
		     }
		     
		     var replyButton = '';
		     if (!isChild) {
		         replyButton = '<button class="btn-reply-write" onclick="toggleChildReplyForm(' + reply.replyId + ')">' +
		             '답글쓰기 ' + (reply.replyCount > 0 ? '(' + reply.replyCount + ')' : '') +
		             '</button>';
		     }
		     
		     var childForm = '';
		     if (!isChild) {
		         childForm = '<div class="child-reply-form" id="childForm' + reply.replyId + '" style="display:none;">' +
		             '<textarea class="reply-textarea" id="childContent' + reply.replyId + '" ' +
		             'placeholder="답글을 입력하세요..." maxlength="1000"></textarea>' +
		             '<div class="reply-write-actions">' +
		             '<span></span>' +
		             '<div>' +
		             '<button class="btn-cancel" onclick="toggleChildReplyForm(' + reply.replyId + ')">취소</button>' +
		             '<button class="btn-submit" onclick="writeChildReply(' + reply.replyId + ')">답글 등록</button>' +
		             '</div>' +
		             '</div>' +
		             '</div>';
		     }
		     
		     return '<div class="reply-item ' + childClass + '" data-reply-id="' + reply.replyId + '">' +
		         '<div class="reply-item-header">' +
		         '<div class="reply-author">' +
		         profileImg +
		         '<div class="author-info">' +
		         '<span class="author-name">' + escapeHtml(reply.userNickname) + '</span>' +
		         '<span class="reply-time">' + (reply.timeAgo || '') + '</span>' +
		         '</div>' +
		         '</div>' +
		         '<div class="reply-actions">' + actionButtons + '</div>' +
		         '</div>' +
		         '<div class="reply-content" data-original="' + escapeHtml(reply.replyContent) + '">' +
		         escapeHtml(reply.replyContent) +
		         '</div>' +
		         '<div class="reply-footer">' +
		         replyButton +
		         '</div>' +
		         childForm +
		         '</div>';
		 }
		
		/**
		 * HTML 이스케이프 처리
		 */
		function escapeHtml(text) {
			if (!text) return '';
			return text.replace(/&/g, '&amp;')
					   .replace(/</g, '&lt;')
					   .replace(/>/g, '&gt;')
					   .replace(/"/g, '&quot;')
					   .replace(/'/g, '&#039;');
		}
		
		/**
		 * 댓글 작성
		 */
		function writeReply() {
			const content = $('#replyContent').val().trim();
			
			if (!content) {
				alert('댓글 내용을 입력해주세요.');
				return;
			}
			
			$.ajax({
				url: '${pageContext.request.contextPath}/reply/command',
				type: 'POST',
				dataType: 'json',
				data: {
					action: 'write',
					roomBoardId: ROOM_BOARD_ID,
					replyContent: content
				},
				success: function(response) {
					if (response.success) {
						$('#replyContent').val('');
						$('#currentLength').text('0');
						loadReplyList();
						alert(response.message);
					} else {
						alert(response.message);
					}
				},
				error: function(xhr, status, error) {
					console.error('Error:', error);
					alert('서버 오류가 발생했습니다.');
				}
			});
		}
		
		/**
		 * 대댓글 폼 토글
		 */
		function toggleChildReplyForm(parentReplyId) {
			$('#childForm' + parentReplyId).toggle();
		}
		
		/**
		 * 대댓글 작성
		 */
		function writeChildReply(parentReplyId) {
			const content = $('#childContent' + parentReplyId).val().trim();
			
			if (!content) {
				alert('답글 내용을 입력해주세요.');
				return;
			}
			
			$.ajax({
				url: '${pageContext.request.contextPath}/reply/command',
				type: 'POST',
				dataType: 'json',
				data: {
					action: 'write',
					roomBoardId: ROOM_BOARD_ID,
					replyContent: content,
					parentReplyId: parentReplyId
				},
				success: function(response) {
					if (response.success) {
						$('#childContent' + parentReplyId).val('');
						toggleChildReplyForm(parentReplyId);
						loadReplyList();
						alert(response.message);
					} else {
						alert(response.message);
					}
				},
				error: function(xhr, status, error) {
					console.error('Error:', error);
					alert('서버 오류가 발생했습니다.');
				}
			});
		}
		
		/**
		 * 댓글 수정
		 */
		function editReply(replyId) {
			const $replyItem = $('.reply-item[data-reply-id="' + replyId + '"]');
			const $contentDiv = $replyItem.find('.reply-content');
			const originalContent = $contentDiv.data('original');
			
			$contentDiv.html(
				'<textarea class="reply-textarea" id="editContent' + replyId + '">' + escapeHtml(originalContent) + '</textarea>' +
				'<div class="reply-write-actions">' +
				'<span></span>' +
				'<div>' +
				'<button class="btn-cancel" onclick="loadReplyList()">취소</button>' +
				'<button class="btn-submit" onclick="updateReply(' + replyId + ')">수정</button>' +
				'</div>' +
				'</div>'
			);
		}
		
		/**
		 * 댓글 수정 완료
		 */
		function updateReply(replyId) {
			const content = $('#editContent' + replyId).val().trim();
			
			if (!content) {
				alert('댓글 내용을 입력해주세요.');
				return;
			}
			
			if (confirm('댓글을 수정하시겠습니까?')) {
				$.ajax({
					url: '${pageContext.request.contextPath}/reply/command',
					type: 'POST',
					dataType: 'json',
					data: {
						action: 'update',
						replyId: replyId,
						replyContent: content
					},
					success: function(response) {
						if (response.success) {
							loadReplyList();
							alert(response.message);
						} else {
							alert(response.message);
						}
					},
					error: function(xhr, status, error) {
						console.error('Error:', error);
						alert('서버 오류가 발생했습니다.');
					}
				});
			}
		}
		
		/**
		 * 댓글 삭제
		 */
		function deleteReply(replyId) {
			if (confirm('댓글을 삭제하시겠습니까?')) {
				$.ajax({
					url: '${pageContext.request.contextPath}/reply/command',
					type: 'POST',
					dataType: 'json',
					data: {
						action: 'delete',
						replyId: replyId
					},
					success: function(response) {
						if (response.success) {
							loadReplyList();
							alert(response.message);
						} else {
							alert(response.message);
						}
					},
					error: function(xhr, status, error) {
						console.error('Error:', error);
						alert('서버 오류가 발생했습니다.');
					}
				});
			}
		}
	</script>
	
	<style>
	* { box-sizing: border-box; }
	
	.reply-container { 
		margin-top: 30px; 
		padding: 20px; 
		background: #f9f9f9; 
		border-radius: 8px; 
	}
	
	.reply-header { 
		display: flex; 
		justify-content: space-between; 
		align-items: center;
		margin-bottom: 15px; 
		padding-bottom: 10px; 
		border-bottom: 2px solid #ddd; 
	}
	
	.reply-count { 
		font-size: 18px; 
		font-weight: bold; 
		color: #333;
	}
	
	.reply-sort { 
		display: flex; 
		gap: 10px; 
	}
	
	.sort-btn { 
		padding: 6px 16px; 
		border: 1px solid #ddd; 
		background: white; 
		cursor: pointer; 
		border-radius: 4px; 
		font-size: 14px;
		transition: all 0.3s;
	}
	
	.sort-btn:hover {
		background: #f0f0f0;
	}
	
	.sort-btn.active { 
		background: #007bff; 
		color: white; 
		border-color: #007bff;
	}
	
	.reply-write-form { 
		margin-bottom: 20px; 
	}
	
	#replyContent, .reply-textarea { 
		width: 100%; 
		min-height: 80px; 
		padding: 12px; 
		border: 1px solid #ddd; 
		border-radius: 4px; 
		resize: vertical; 
		font-size: 14px;
		line-height: 1.5;
		font-family: inherit;
	}
	
	#replyContent:focus, .reply-textarea:focus {
		outline: none;
		border-color: #007bff;
		box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
	}
	
	.reply-write-actions { 
		display: flex; 
		justify-content: space-between; 
		align-items: center;
		margin-top: 10px; 
	}
	
	.char-count { 
		color: #666; 
		font-size: 12px; 
	}
	
	.btn-submit { 
		padding: 8px 20px; 
		background: #007bff; 
		color: white; 
		border: none; 
		border-radius: 4px; 
		cursor: pointer; 
		font-size: 14px;
		font-weight: 500;
		transition: background 0.3s;
	}
	
	.btn-submit:hover {
		background: #0056b3;
	}
	
	.btn-cancel { 
		padding: 8px 20px; 
		background: #6c757d; 
		color: white; 
		border: none; 
		border-radius: 4px; 
		cursor: pointer; 
		margin-right: 5px; 
		font-size: 14px;
		font-weight: 500;
		transition: background 0.3s;
	}
	
	.btn-cancel:hover {
		background: #5a6268;
	}
	
	.reply-item { 
		background: white; 
		padding: 16px; 
		margin-bottom: 10px; 
		border-radius: 6px; 
		border: 1px solid #e0e0e0;
		transition: box-shadow 0.3s;
	}
	
	.reply-item:hover {
		box-shadow: 0 2px 8px rgba(0,0,0,0.08);
	}
	
	.reply-item.child-reply { 
		margin-left: 50px; 
		background: #f8f9fa; 
		border-left: 3px solid #007bff;
	}
	
	.reply-item-header { 
		display: flex; 
		justify-content: space-between; 
		align-items: flex-start;
		margin-bottom: 12px; 
	}
	
	.reply-author { 
		display: flex; 
		align-items: center;
		gap: 10px; 
	}
	
	.profile-img {
		width: 36px;
		height: 36px;
		border-radius: 50%;
		object-fit: cover;
		border: 2px solid #e0e0e0;
	}
	
	.author-info {
		display: flex;
		flex-direction: column;
		gap: 2px;
	}
	
	.author-name { 
		font-weight: 600; 
		font-size: 14px; 
		color: #333;
	}
	
	.reply-time { 
		font-size: 12px; 
		color: #999; 
	}
	
	.reply-actions { 
		display: flex; 
		gap: 8px; 
	}
	
	.btn-action { 
		padding: 5px 12px; 
		font-size: 12px; 
		border: 1px solid #ddd; 
		background: white; 
		cursor: pointer; 
		border-radius: 3px; 
		transition: all 0.3s;
	}
	
	.btn-action:hover {
		background: #f0f0f0;
	}
	
	.reply-content { 
		margin: 12px 0; 
		line-height: 1.6; 
		white-space: pre-wrap; 
		word-break: break-word;
		color: #333;
		font-size: 14px;
	}
	
	.reply-footer { 
		margin-top: 10px; 
		padding-top: 10px; 
		border-top: 1px solid #f0f0f0; 
	}
	
	.btn-reply-write { 
		font-size: 13px; 
		color: #007bff; 
		background: none; 
		border: none; 
		cursor: pointer; 
		font-weight: 500;
		transition: color 0.3s;
	}
	
	.btn-reply-write:hover {
		color: #0056b3;
		text-decoration: underline;
	}
	
	.child-reply-form { 
		margin-top: 15px; 
		padding: 15px; 
		background: #f8f9fa; 
		border-radius: 4px; 
		border: 1px solid #e0e0e0;
	}
	
	.loading, .empty-state { 
		text-align: center; 
		padding: 40px 20px; 
		color: #999; 
		font-size: 14px;
	}
	
	.empty-state {
		background: white;
		border-radius: 6px;
		border: 1px dashed #ddd;
	}
	</style>
</body>
</html>