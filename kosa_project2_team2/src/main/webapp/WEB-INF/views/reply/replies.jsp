<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<style>
/* ===== 댓글 영역 스타일 ===== */
.reply-container { 
    max-width: 800px;
    margin: 40px auto 0;
    padding: 0;
    background: white; 
    border-radius: 20px;
    box-shadow: 
        0 10px 30px rgba(0, 0, 0, 0.1),
        0 1px 8px rgba(0, 0, 0, 0.06);
    overflow: hidden;
}

.reply-header { 
    display: flex; 
    justify-content: space-between; 
    align-items: center;
    padding: 20px 24px 16px; 
    border-bottom: 1px solid #f0f0f0;
}

.reply-stats {
    display: flex;
    gap: 20px;
    align-items: center;
}

.stat-item {
    display: flex;
    align-items: center;
    gap: 6px;
    color: #666;
    font-size: 14px;
}

/* 탭 버튼 스타일 */
.stat-item.tab-button {
    cursor: pointer;
    padding: 8px 16px;
    border-radius: 8px;
    transition: all 0.2s;
    user-select: none;
}

.stat-item.tab-button:hover {
    background: #f5f5f5;
}

.stat-item.tab-button.active {
    background: #fff5f5;
    color: #ff5a5f;
    font-weight: 600;
}

.stat-item.tab-button.active svg {
    stroke: #ff5a5f;
}

.stat-icon {
    font-size: 16px;
}

.reply-sort { 
    display: flex;
    align-items: center;
    gap: 4px;
}

.sort-btn { 
    padding: 6px 14px; 
    border: none; 
    background: white; 
    cursor: pointer; 
    font-size: 13px;
    color: #999;
    font-weight: 500;
    border-radius: 4px;
    transition: all 0.2s;
}

.sort-btn:hover {
    background: #f8f8f8;
}

.sort-btn.active { 
    background: white; 
    color: #333;
    font-weight: 700;
}

#replyList {
    padding: 0;
    background: white;
}

/* 댓글 작성 폼 */
.reply-write-form { 
    padding: 20px 24px;
    background: white;
    border-top: 1px solid #f0f0f0;xr
}

/* 댓글 입력창 전환 애니메이션 */
/* .reply-write-form {
    transition: all 0.3s ease;
}

.reply-write-form.hidden {
    display: none !important;
}  */

.write-form-header {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 12px;
}

.write-form-header .profile-img {
    width: 28px;
    height: 28px;
}

.write-form-header .author-name {
    font-weight: 700;
    font-size: 13px;
    color: #333;
}

.attached-images {
    display: none;
    gap: 8px;
    margin-bottom: 12px;
    flex-wrap: wrap;
}

.attached-image {
    position: relative;
    width: 70px;
    height: 70px;
    border-radius: 8px;
    overflow: hidden;
    border: 1px solid #e0e0e0;
}

.attached-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.remove-image {
    position: absolute;
    top: 4px;
    right: 4px;
    background: rgba(0,0,0,0.6);
    color: white;
    border: none;
    border-radius: 50%;
    width: 18px;
    height: 18px;
    cursor: pointer;
    font-size: 11px;
    line-height: 1;
    padding: 0;
}

#replyContent, .reply-textarea { 
    width: 100%; 
    min-height: 48px; 
    padding: 12px 16px; 
    border: 1px solid #e8e8e8; 
    border-radius: 8px; 
    resize: none; 
    font-size: 14px;
    line-height: 1.5;
    font-family: inherit;
    background: #fafafa;
}

#replyContent:focus, .reply-textarea:focus {
    outline: none;
    border-color: #d0d0d0;
    background: white;
}

#replyContent::placeholder {
    color: #bbb;
}

.reply-write-actions { 
    display: flex; 
    justify-content: space-between; 
    align-items: center;
    margin-top: 12px; 
}

.write-tools {
    display: flex;
    gap: 8px;
    align-items: center;
}

.tool-btn {
    background: none;
    border: none;
    cursor: pointer;
    font-size: 20px;
    color: #bbb;
    padding: 4px;
    transition: color 0.2s;
}

.tool-btn:hover {
    color: #888;
}

.image-input {
    display: none;
}

.char-count { 
    color: #bbb; 
    font-size: 11px;
    margin-left: auto;
    margin-right: 12px;
}

.btn-submit { 
    padding: 8px 20px; 
    background: #ff5a5f; 
    color: white; 
    border: none; 
    border-radius: 6px; 
    cursor: pointer; 
    font-size: 13px;
    font-weight: 600;
    transition: background 0.2s;
}

.btn-submit:hover {
    background: #ff3d42;
}

.btn-submit:disabled {
    background: #e0e0e0;
    cursor: not-allowed;
}

.btn-cancel { 
    padding: 8px 16px; 
    background: #f0f0f0; 
    color: #666; 
    border: none; 
    border-radius: 6px; 
    cursor: pointer; 
    margin-right: 6px; 
    font-size: 13px;
    font-weight: 500;
    transition: background 0.2s;
}

.btn-cancel:hover {
    background: #e0e0e0;
}

/* 댓글 아이템 */
.reply-item { 
    background: white; 
    padding: 10px 24px 0px 20px;
    border-bottom: 1px solid #f5f5f5;
    transition: background 0.2s;
    position: relative;
}

.reply-item:hover {
    background: #fafafa;
}

.reply-item.child-reply { 
    margin-left: 52px; 
    background: #ffffff; 
    padding-left: 20px;
}

.reply-item-header { 
    display: flex; 
    justify-content: space-between; 
    align-items: flex-start;
    margin-bottom: 10px; 
    position: relative;
}

.reply-author { 
    display: flex; 
    align-items: flex-start;
    gap: 12px;
    flex: 1;
}

.profile-img {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
    flex-shrink: 0;
}

.reply-main-content {
    flex: 1;
    min-width: 0;
}

.author-info {
    display: flex;
    align-items: center;
    gap: 6px;
    margin-bottom: 6px;
}

.author-name { 
    font-weight: 700; 
    font-size: 14px; 
    color: #333;
}

.reply-content { 
    margin: 0px 0 0px; 
    line-height: 1.5; 
    white-space: pre-wrap; 
    word-break: break-word;
    color: #333;
    font-size: 14px;
}

.reply-time { 
    font-size: 12px; 
    color: #aaa; 
    margin-right: 12px;
}

.btn-reply-write { 
    font-size: 12px; 
    color: #aaa; 
    background: none; 
    border: none; 
    cursor: pointer; 
    font-weight: 500;
    padding: 0;
    margin-right: 8px;
    transition: color 0.2s;
}

.btn-reply-write:hover {
    color: #666;
}

/* .btn-like {
    background: none;
    border: none;
    cursor: pointer;
    font-size: 13px;
    color: #ccc;
    padding: 0;
    transition: all 0.2s;
    display: inline-flex;
    align-items: center;
} */

.btn-like {
    background: none;
    border: none;
    cursor: pointer;
    font-size: 13px;
    color: #ccc;
    padding: 0;
    transition: all 0.2s;
    display: inline-flex;
    align-items: center;
}

.btn-like:hover {
    color: #ff5a5f;
}

.btn-like svg {
    transition: all 0.2s;
}

/* 좋아요 카운트 스타일 추가 */
.btn-like .like-count {
    font-size: 12px;
    margin-left: 4px;
    font-weight: 500;
}

.btn-like.liked svg {
    fill: #ff5a5f;
    stroke: #ff5a5f;
}


/* 더보기 메뉴 */
.reply-more-menu {
    position: absolute;
    right: 0;
    top: 0;
}

.btn-more {
    background: none;
    border: none;
    cursor: pointer;
    padding: 4px 8px;
    color: #d0d0d0;
    font-size: 20px;
    line-height: 1;
    border-radius: 4px;
    transition: all 0.2s;
}

.btn-more:hover {
    color: #999;
    background: #f5f5f5;
}

.dropdown-menu {
    display: none;
    position: absolute;
    right: 0;
    top: 100%;
    background: white;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    box-shadow: 0 4px 16px rgba(0,0,0,0.12);
    min-width: 100px;
    z-index: 1000;
    margin-top: 4px;
}

.dropdown-menu.show {
    display: block;
}

.dropdown-item {
    padding: 10px 16px;
    cursor: pointer;
    border: none;
    background: none;
    width: 100%;
    text-align: left;
    font-size: 13px;
    color: #333;
    transition: background 0.2s;
}

.dropdown-item:hover {
    background: #f8f8f8;
}

.dropdown-item:first-child {
    border-radius: 8px 8px 0 0;
}

.dropdown-item:last-child {
    border-radius: 0 0 8px 8px;
}

.dropdown-item.danger {
    color: #ff5a5f;
}

.dropdown-item.danger:hover {
    background: #fff5f5;
}

/* 대댓글 폼 */
.child-reply-form { 
    margin-top: 12px; 
    margin-left: 52px;     /* ✅ 추가: 프로필 이미지 너비만큼 왼쪽 여백 */
    margin-right: 0;       /* ✅ 추가: 오른쪽 여백 제거 */
    padding: 12px; 
    background: #f9f9f9;   /* ✅ 수정: 배경색 살짝 변경 */
    border-radius: 8px; 
    border: 1px solid #e8e8e8;
}

.loading, .empty-state { 
    text-align: center; 
    padding: 60px 20px; 
    color: #aaa; 
    font-size: 13px;
    background: white;
}

.empty-state {
    border-radius: 0;
}

/* 좋아요 목록 스타일 */
.like-list-container {
    padding: 20px 24px;
    background: white;
}

.like-users-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
    margin-bottom: 20px;
}

.like-user-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 0;
    transition: all 0.2s;
}

.like-user-item:hover {
    transform: translateY(-2px);
}

.like-user-avatar {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    object-fit: cover;
    flex-shrink: 0;
    border: 2px solid #f0f0f0;
}

.like-user-info {
    flex: 1;
    min-width: 0;
}

.like-user-name {
    font-weight: 700;
    font-size: 14px;
    color: #333;
    margin-bottom: 4px;
}

.like-user-date {
    font-size: 12px;
    color: #999;
}

/* 페이지네이션 컨테이너 */
.pagination-container {
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 0x 0;
    background: white;
    transform: scale(0.6);
}

@media (max-width: 768px) {
  .pagination-container {
    transform: scale(0.6); 
  }
}

/* 정렬 버튼은 댓글 탭에서만 표시 */
#replySortButtons.hidden {
    display: none;
}

/* 좋아요 SVG 버튼 스타일 */
.post-like-btn {
    background: none;
    border: none;
    cursor: pointer;
    padding: 4px;
    border-radius: 50%;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
}

.post-like-btn:hover {
    background: rgba(255, 90, 95, 0.1);
}

.post-like-btn svg {
    transition: all 0.2s;
}

.post-like-btn.liked svg {
    fill: #ff5a5f;
    stroke: #ff5a5f;
}

.like-text-btn {
    cursor: pointer;
    transition: all 0.2s;
}

.like-text-btn:hover {
    background: #f5f5f5;
}

/* 정렬 버튼은 댓글 탭에서만 표시 */
.reply-sort.hidden {
    display: none;
}

</style>

<!-- 댓글 영역 -->
<div class="reply-container">
    <!-- 댓글 통계 -->
    <div class="reply-header">
        <div class="reply-stats">
        	<div class="stat-item">
        	    <!-- 좋아요 SVG 버튼 (게시글 좋아요 토글) -->
        	    <button class="post-like-btn" id="postLikeBtn" onclick="togglePostLike()" title="좋아요">
    	            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
    	                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
    	            </svg>
    	        </button>
    	        <!-- 좋아요 텍스트 (탭 전환용) -->
    	        <span class="like-text-btn tab-button" data-tab="like" onclick="switchTab('like')" 
    	              style="margin-left: 0px; padding: 4px 0px; border-radius: 4px;">
    	            좋아요 <strong id="likeTotalCount">0</strong>
    	        </span>
	        </div>
	        <div class="stat-item tab-button active" data-tab="reply" onclick="switchTab('reply')">
	            <span class="stat-icon">💬</span>
	            <span>댓글 <strong id="replyTotalCount">0</strong></span>
	        </div>
	        
	    </div>
        
        <div class="reply-sort" id="replySortButtons">
		    <button class="sort-btn active" data-order="ASC">등록순</button>
		    <button class="sort-btn" data-order="DESC">최신순</button>
		</div>
    </div>
    
    <!-- 댓글 목록 -->
    <div id="replyList">
        <div class="loading">댓글을 불러오는 중...</div>
    </div>
    
    <!-- 좋아요 목록 (새로 추가) -->
	<div id="likeList" class="like-list-container" style="display:none;">
	    <div class="loading">좋아요 목록을 불러오는 중...</div>
	</div>
	
	<!-- 페이지네이션 (좋아요 목록용) -->
	<div id="likePagination" class="pagination-container" style="display:none;">
	    <svg width="471" height="52" viewBox="0 0 471 52" fill="none" xmlns="http://www.w3.org/2000/svg">
	        <path d="M31 39L19 27L31 15" stroke="#FF7272" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
	        <path d="M442 14L454 26L442 38" stroke="#FF7272" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
	        <circle cx="110" cy="26" r="26" fill="#FF7272"/>
	        <path d="M106.456 34V32.08H109.888V19.96L106.672 22.384L105.496 20.776L110.464 17.2H112.048V32.08H114.904V34H106.456Z" fill="white"/>
	        <path d="M174.698 34C174.65 33.712 174.626 33.416 174.626 33.112C174.626 32.072 174.802 31.144 175.154 30.328C175.522 29.496 175.994 28.744 176.57 28.072C177.146 27.384 177.754 26.752 178.394 26.176C179.05 25.584 179.658 25.024 180.218 24.496C180.794 23.952 181.266 23.408 181.634 22.864C182.002 22.32 182.186 21.752 182.186 21.16C182.186 20.488 181.938 19.936 181.442 19.504C180.946 19.056 180.306 18.832 179.522 18.832C178.85 18.832 178.234 18.968 177.674 19.24C177.13 19.496 176.618 19.848 176.138 20.296L174.938 18.832C175.578 18.256 176.282 17.792 177.05 17.44C177.834 17.088 178.738 16.912 179.762 16.912C180.706 16.912 181.53 17.096 182.234 17.464C182.938 17.816 183.482 18.304 183.866 18.928C184.266 19.552 184.466 20.248 184.466 21.016C184.466 21.784 184.298 22.496 183.962 23.152C183.626 23.808 183.194 24.424 182.666 25C182.138 25.576 181.57 26.136 180.962 26.68C180.354 27.208 179.77 27.752 179.21 28.312C178.65 28.872 178.17 29.456 177.77 30.064C177.386 30.672 177.146 31.328 177.05 32.032H184.442V34H174.698ZM248.388 34.288C247.348 34.288 246.444 34.152 245.676 33.88C244.908 33.592 244.252 33.248 243.708 32.848L244.692 31.048C245.14 31.384 245.66 31.68 246.252 31.936C246.844 32.192 247.564 32.32 248.412 32.32C249.468 32.32 250.3 32.04 250.908 31.48C251.532 30.92 251.844 30.224 251.844 29.392C251.844 28.8 251.684 28.264 251.364 27.784C251.044 27.288 250.548 26.888 249.876 26.584C249.22 26.28 248.364 26.128 247.308 26.128H245.964V24.376H247.212C248.156 24.376 248.932 24.232 249.54 23.944C250.164 23.656 250.628 23.28 250.932 22.816C251.236 22.352 251.388 21.864 251.388 21.352C251.388 20.6 251.1 19.992 250.524 19.528C249.964 19.064 249.268 18.832 248.436 18.832C247.684 18.832 247.012 18.96 246.42 19.216C245.844 19.456 245.372 19.728 245.004 20.032L244.116 18.328C244.596 18.008 245.212 17.696 245.964 17.392C246.716 17.072 247.596 16.912 248.604 16.912C249.66 16.912 250.556 17.104 251.292 17.488C252.028 17.872 252.588 18.384 252.972 19.024C253.372 19.648 253.572 20.328 253.572 21.064C253.572 22.008 253.332 22.8 252.852 23.44C252.388 24.08 251.724 24.608 250.86 25.024C251.868 25.408 252.652 25.976 253.212 26.728C253.788 27.464 254.076 28.328 254.076 29.32C254.076 30.152 253.868 30.952 253.452 31.72C253.052 32.472 252.428 33.088 251.58 33.568C250.748 34.048 249.684 34.288 248.388 34.288ZM320.47 34V30.424H313.294V28.696L318.31 17.032L320.182 17.824L315.646 28.456H320.47V23.68H322.63V28.456H324.622V30.424H322.63V34H320.47ZM387.824 34.288C386.848 34.288 386.008 34.184 385.304 33.976C384.6 33.752 383.96 33.44 383.384 33.04L384.512 31.192C384.96 31.512 385.456 31.784 386 32.008C386.544 32.216 387.16 32.32 387.848 32.32C388.92 32.32 389.784 32.016 390.44 31.408C391.096 30.784 391.424 29.992 391.424 29.032C391.424 28.04 391.08 27.232 390.392 26.608C389.72 25.968 388.752 25.648 387.488 25.648H384.512V17.2H392.816V19.144H386.552V23.704H387.752C389 23.704 390.064 23.92 390.944 24.352C391.84 24.784 392.52 25.384 392.984 26.152C393.464 26.92 393.704 27.8 393.704 28.792C393.704 29.864 393.456 30.816 392.96 31.648C392.48 32.464 391.8 33.112 390.92 33.592C390.04 34.056 389.008 34.288 387.824 34.288Z" fill="#333333"/>
	    </svg>
	</div>
	
	<!-- 페이지네이션 (댓글 목록용) -->
	<div id="replyPagination" class="pagination-container" style="display:none;">
	    <svg width="471" height="52" viewBox="0 0 471 52" fill="none" xmlns="http://www.w3.org/2000/svg">
	        <path d="M31 39L19 27L31 15" stroke="#FF7272" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
	        <path d="M442 14L454 26L442 38" stroke="#FF7272" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
	        <circle cx="110" cy="26" r="26" fill="#FF7272"/>
	        <path d="M106.456 34V32.08H109.888V19.96L106.672 22.384L105.496 20.776L110.464 17.2H112.048V32.08H114.904V34H106.456Z" fill="white"/>
	        <path d="M174.698 34C174.65 33.712 174.626 33.416 174.626 33.112C174.626 32.072 174.802 31.144 175.154 30.328C175.522 29.496 175.994 28.744 176.57 28.072C177.146 27.384 177.754 26.752 178.394 26.176C179.05 25.584 179.658 25.024 180.218 24.496C180.794 23.952 181.266 23.408 181.634 22.864C182.002 22.32 182.186 21.752 182.186 21.16C182.186 20.488 181.938 19.936 181.442 19.504C180.946 19.056 180.306 18.832 179.522 18.832C178.85 18.832 178.234 18.968 177.674 19.24C177.13 19.496 176.618 19.848 176.138 20.296L174.938 18.832C175.578 18.256 176.282 17.792 177.05 17.44C177.834 17.088 178.738 16.912 179.762 16.912C180.706 16.912 181.53 17.096 182.234 17.464C182.938 17.816 183.482 18.304 183.866 18.928C184.266 19.552 184.466 20.248 184.466 21.016C184.466 21.784 184.298 22.496 183.962 23.152C183.626 23.808 183.194 24.424 182.666 25C182.138 25.576 181.57 26.136 180.962 26.68C180.354 27.208 179.77 27.752 179.21 28.312C178.65 28.872 178.17 29.456 177.77 30.064C177.386 30.672 177.146 31.328 177.05 32.032H184.442V34H174.698ZM248.388 34.288C247.348 34.288 246.444 34.152 245.676 33.88C244.908 33.592 244.252 33.248 243.708 32.848L244.692 31.048C245.14 31.384 245.66 31.68 246.252 31.936C246.844 32.192 247.564 32.32 248.412 32.32C249.468 32.32 250.3 32.04 250.908 31.48C251.532 30.92 251.844 30.224 251.844 29.392C251.844 28.8 251.684 28.264 251.364 27.784C251.044 27.288 250.548 26.888 249.876 26.584C249.22 26.28 248.364 26.128 247.308 26.128H245.964V24.376H247.212C248.156 24.376 248.932 24.232 249.54 23.944C250.164 23.656 250.628 23.28 250.932 22.816C251.236 22.352 251.388 21.864 251.388 21.352C251.388 20.6 251.1 19.992 250.524 19.528C249.964 19.064 249.268 18.832 248.436 18.832C247.684 18.832 247.012 18.96 246.42 19.216C245.844 19.456 245.372 19.728 245.004 20.032L244.116 18.328C244.596 18.008 245.212 17.696 245.964 17.392C246.716 17.072 247.596 16.912 248.604 16.912C249.66 16.912 250.556 17.104 251.292 17.488C252.028 17.872 252.588 18.384 252.972 19.024C253.372 19.648 253.572 20.328 253.572 21.064C253.572 22.008 253.332 22.8 252.852 23.44C252.388 24.08 251.724 24.608 250.86 25.024C251.868 25.408 252.652 25.976 253.212 26.728C253.788 27.464 254.076 28.328 254.076 29.32C254.076 30.152 253.868 30.952 253.452 31.72C253.052 32.472 252.428 33.088 251.58 33.568C250.748 34.048 249.684 34.288 248.388 34.288ZM320.47 34V30.424H313.294V28.696L318.31 17.032L320.182 17.824L315.646 28.456H320.47V23.680H322.63V28.456H324.622V30.424H322.63V34H320.47ZM387.824 34.288C386.848 34.288 386.008 34.184 385.304 33.976C384.6 33.752 383.96 33.44 383.384 33.04L384.512 31.192C384.96 31.512 385.456 31.784 386 32.008C386.544 32.216 387.16 32.32 387.848 32.32C388.92 32.32 389.784 32.016 390.44 31.408C391.096 30.784 391.424 29.992 391.424 29.032C391.424 28.04 391.08 27.232 390.392 26.608C389.72 25.968 388.752 25.648 387.488 25.648H384.512V17.2H392.816V19.144H386.552V23.704H387.752C389 23.704 390.064 23.92 390.944 24.352C391.84 24.784 392.52 25.384 392.984 26.152C393.464 26.92 393.704 27.8 393.704 28.792C393.704 29.864 393.456 30.816 392.96 31.648C392.48 32.464 391.8 33.112 390.92 33.592C390.04 34.056 389.008 34.288 387.824 34.288Z" fill="#333333"/>
	    </svg>
	</div>
	
    <!-- 댓글 작성 폼 -->
    <div class="reply-write-form">
        <div class="write-form-header">
            <c:choose>
                <c:when test="${not empty sessionScope.LOGIN_USER.user_photo}">
                    <img src="${pageContext.request.contextPath}${sessionScope.LOGIN_USER.user_photo}" 
                         alt="프로필" class="profile-img">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/images/default-avatar.png" 
                         alt="프로필" class="profile-img">
                </c:otherwise>
            </c:choose>
            <span class="author-name">
                ${not empty sessionScope.LOGIN_USER ? sessionScope.LOGIN_USER.user_nickname : '방문자'}
            </span>
        </div>
        <div id="attachedImages" class="attached-images"></div>
        <textarea id="replyContent" placeholder="댓글을 남겨보세요" maxlength="3000"></textarea>
        <div class="reply-write-actions">
            <div class="write-tools">
                <input type="file" id="imageInput" class="image-input" accept="image/*" multiple onchange="handleImageSelect(event)">
                <button class="tool-btn" title="이미지 첨부" onclick="document.getElementById('imageInput').click()">📷</button>
                <button class="tool-btn" title="이모티콘">😊</button>
            </div>
            <span class="char-count"><span id="currentLength">0</span>/1000</span>
            <button class="btn-submit" onclick="writeReply()">등록</button>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
// 게시글 ID (JSP에서 전달받음)
var ROOM_BOARD_ID = ${param.roomBoardId};
var currentOrder = 'ASC';

//게시글 좋아요 상태 전역 변수
var isPostLiked = false;

jQuery(document).ready(function() {
    console.log('댓글 시스템 로드, ROOM_BOARD_ID:', ROOM_BOARD_ID);
    loadReplyList();
    loadInitialLikeCount();
    loadPostLikeStatus(); // 게시글 좋아요 상태 로드
    
    // 글자 수 카운터
    jQuery('#replyContent').on('input', function() {
        jQuery('#currentLength').text(jQuery(this).val().length);
    });
    
    // 정렬 버튼 클릭
    jQuery('.sort-btn').on('click', function() {
        jQuery('.sort-btn').removeClass('active');
        jQuery(this).addClass('active');
        currentOrder = jQuery(this).data('order');
        loadReplyList();
    });
});

/**
 * ✅ 댓글 목록 불러오기 - /reply/list.ajax
 */
function loadReplyList() {
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/reply/list.ajax',
        type: 'GET',
        dataType: 'json',
        data: {
            roomBoardId: ROOM_BOARD_ID,
            orderBy: currentOrder
        },
        success: function(response) {
            console.log('댓글 목록 응답:', response);
            if (response.success) {
                displayReplyList(response.replies);
                jQuery('#replyTotalCount').text(response.totalCount);
            } else {
                alert(response.message);
            }
        },
        error: function(xhr, status, error) {
            console.error('댓글 목록 로드 에러:', error);
            alert('서버 오류가 발생했습니다: ' + error);
        }
    });
}

/**
 * 댓글 목록 표시
 */
function displayReplyList(replies) {
    var replyList = jQuery('#replyList');
    replyList.empty();
    
    if (replies.length === 0) {
        replyList.html('<div class="empty-state">첫 댓글을 작성해보세요!</div>');
        jQuery('#replyPagination').hide();
        return;
    }
    
    // 재귀 함수로 모든 깊이의 답글 처리
    function renderReply(reply, isChild) {
        replyList.append(createReplyHtml(reply, isChild));
        
        if (reply.replies && reply.replies.length > 0) {
            for (var j = 0; j < reply.replies.length; j++) {
                renderReply(reply.replies[j], true);
            }
        }
    }
    
    for (var i = 0; i < replies.length; i++) {
        renderReply(replies[i], false);
    }
    
    // 페이지네이션 표시 (댓글이 있을 때만)
    if (replies.length > 0) {
        jQuery('#replyPagination').show();
    }
}

/**
 * 댓글 HTML 생성
 */
function createReplyHtml(reply, isChild) {
    var childClass = isChild ? 'child-reply' : '';
    var contextPath = '${pageContext.request.contextPath}';
    
    var profileImgSrc = reply.userPhoto ? 
        contextPath + reply.userPhoto : 
        contextPath + '/images/default-avatar.png';
    var defaultImgSrc = contextPath + '/images/default-avatar.png';
    var profileImg = '<img src="' + profileImgSrc + '" alt="프로필" class="profile-img" ' +
        'onerror="this.onerror=null; this.src=\'' + defaultImgSrc + '\';">';
    
    // 삭제된 댓글 처리
    if (reply.status === 'DELETED' && reply.parentReplyId == null) {
        return '<div class="reply-item ' + childClass + '" data-reply-id="' + reply.replyId + '">' +
            '<div class="reply-item-header">' +
            '<div class="reply-author">' +
            '<div class="reply-main-content">' +
            '<div class="reply-content" style="color: #999; font-style: italic;">삭제된 댓글입니다.</div>' +
            '</div></div></div></div>';
    } else if (reply.status === 'DELETED' && reply.parentReplyId != null){
        return '';
    } 
    
    // 더보기 메뉴 버튼
    var actionButtons = '';
    if (reply.owner) {
        actionButtons = '<div class="reply-more-menu">' +
            '<button class="btn-more" onclick="toggleDropdown(event, ' + reply.replyId + ')">⋮</button>' +
            '<div class="dropdown-menu" id="dropdown' + reply.replyId + '">' +
            '<button class="dropdown-item" onclick="editReply(' + reply.replyId + ')">수정</button>' +
            '<button class="dropdown-item danger" onclick="deleteReply(' + reply.replyId + ')">삭제</button>' +
            '</div></div>';
    } else {
        actionButtons = '<div class="reply-more-menu">' +
            '<button class="btn-more" onclick="toggleDropdown(event, ' + reply.replyId + ')">⋮</button>' +
            '<div class="dropdown-menu" id="dropdown' + reply.replyId + '">' +
            '<button class="dropdown-item danger" onclick="reportReply(' + reply.replyId + ')">신고하기</button>' +
            '</div></div>';
    }
    
    var replyButton = '<button class="btn-reply-write" onclick="toggleChildReplyForm(' + reply.replyId + ')">답글쓰기</button>';

    // 좋아요 버튼 (isLiked 상태 반영)
    var isLikedClass = reply.isLiked ? 'liked' : '';
    var fillColor = reply.isLiked ? '#ff5a5f' : 'none';
    var strokeColor = reply.isLiked ? '#ff5a5f' : 'currentColor';
    
    var likeButton = '<button class="btn-like ' + isLikedClass + '" data-reply-id="' + reply.replyId + '" onclick="toggleReplyLike(' + reply.replyId + ')">' +
       '<svg width="14" height="14" viewBox="0 0 24 24" fill="' + fillColor + '" stroke="' + strokeColor + '" stroke-width="2">' +
       '<path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>' +
       '</svg>' +
       (reply.likeCount > 0 ? ' <span class="like-count">' + reply.likeCount + '</span>' : '') +
       '</button>';
    
    var childForm = '<div class="child-reply-form" id="childForm' + reply.replyId + '" style="display:none;">' +
        '<textarea class="reply-textarea" id="childContent' + reply.replyId + '" ' +
        'placeholder="답글을 입력하세요..." maxlength="3000"></textarea>' +
        '<div class="reply-write-actions">' +
        '<div class="write-tools"></div>' +
        '<span class="char-count"><span id="childLength' + reply.replyId + '">0</span>/3000</span>' +
        '<button class="btn-cancel" onclick="toggleChildReplyForm(' + reply.replyId + ')">취소</button>' +
        '<button class="btn-submit" onclick="writeChildReply(' + reply.replyId + ')">등록</button>' +
        '</div></div>';
        
    var timeText = '';
    if (reply.replyUpdatedAt && reply.replyUpdatedAt !== reply.replyCreatedAt) {
        timeText = '(수정됨) ' + formatDateTime(reply.replyUpdatedAt);
    } else {
        timeText = formatDateTime(reply.replyCreatedAt);
    }
        
    return '<div class="reply-item ' + childClass + '" data-reply-id="' + reply.replyId + '">' +
        '<div class="reply-item-header">' +
        '<div class="reply-author">' +
        profileImg +
        '<div class="reply-main-content">' +
        '<div class="author-info"><span class="author-name">' + escapeHtml(reply.userNickname) + '</span></div>' +
        '<div class="reply-content" data-original="' + escapeHtml(reply.replyContent) + '">' +
        escapeHtml(reply.replyContent) + '</div>' +
        '<span class="reply-time">' + timeText + '</span>' + replyButton + likeButton +
	    '</div></div>' +
	    actionButtons +
	    '</div>' +
	    childForm +
	    '</div>';  
}

function escapeHtml(text) {
    if (!text) return '';
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function formatDateTime(dateStr) {
    if (!dateStr) return '';
    var date = new Date(dateStr);
    var year = date.getFullYear();
    var month = String(date.getMonth() + 1).padStart(2, '0');
    var day = String(date.getDate()).padStart(2, '0');
    var hours = String(date.getHours()).padStart(2, '0');
    var minutes = String(date.getMinutes()).padStart(2, '0');
    return year + '.' + month + '.' + day + ' ' + hours + ':' + minutes;
}

var selectedImages = [];

function handleImageSelect(event) {
    var files = event.target.files;
    for (var i = 0; i < files.length; i++) {
        if (selectedImages.length >= 5) {
            alert('이미지는 최대 5개까지 첨부할 수 있습니다.');
            break;
        }
        if (!files[i].type.startsWith('image/')) {
            alert('이미지 파일만 첨부할 수 있습니다.');
            continue;
        }
        selectedImages.push(files[i]);
    }
    displayAttachedImages();
    event.target.value = '';
}

function displayAttachedImages() {
    var container = jQuery('#attachedImages');
    container.empty();
    if (selectedImages.length === 0) {
        container.hide();
        return;
    }
    container.css('display', 'flex');
    for (var i = 0; i < selectedImages.length; i++) {
        (function(index) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var imageHtml = '<div class="attached-image">' +
                    '<img src="' + e.target.result + '" alt="첨부 이미지">' +
                    '<button class="remove-image" onclick="removeImage(' + index + ')">×</button></div>';
                container.append(imageHtml);
            };
            reader.readAsDataURL(selectedImages[index]);
        })(i);
    }
}

function removeImage(index) {
    selectedImages.splice(index, 1);
    displayAttachedImages();
}

/**
 * ✅ 댓글 좋아요 토글
 */
function toggleReplyLike(replyId) {
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/like/action.ajax',
        type: 'POST',
        dataType: 'json',
        data: {
            targetType: 'REPLY',
            targetId: replyId
        },
        success: function(response) {
            console.log('좋아요 응답:', response);
            if (response.success) {
                var likeBtn = jQuery('.btn-like[data-reply-id="' + replyId + '"]');
                var svg = likeBtn.find('svg');
                var likeCountSpan = likeBtn.find('.like-count');
                
                // 좋아요 상태에 따라 UI 업데이트
                if (response.isLiked) {
                    likeBtn.addClass('liked');
                    svg.attr('fill', '#ff5a5f');
                    svg.attr('stroke', '#ff5a5f');
                } else {
                    likeBtn.removeClass('liked');
                    svg.attr('fill', 'none');
                    svg.attr('stroke', 'currentColor');
                }
                
                // 좋아요 개수 업데이트
                if (response.likeCount > 0) {
                    if (likeCountSpan.length > 0) {
                        likeCountSpan.text(response.likeCount);
                    } else {
                        likeBtn.append(' <span class="like-count">' + response.likeCount + '</span>');
                    }
                } else {
                    likeCountSpan.remove();
                }
                
                console.log('좋아요 ' + response.action + '! 총 ' + response.likeCount + '개');
            } else {
                alert(response.message || '좋아요 처리에 실패했습니다.');
            }
        },
        error: function(xhr, status, error) {
            console.error('좋아요 처리 중 오류:', error);
            console.error('응답:', xhr.responseText);
            alert('좋아요 처리에 실패했습니다.');
        }
    });
}

/**
 * ✅ 댓글 작성 - /reply/write.ajax
 */
function writeReply() {
    var content = jQuery('#replyContent').val().trim();
    if (!content) {
        alert('댓글 내용을 입력해주세요.');
        return;
    }
    if (selectedImages.length > 0) {
        alert('이미지 첨부 기능은 준비 중입니다.\n텍스트 댓글만 등록됩니다.');
    }
    
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/reply/write.ajax',
        type: 'POST',
        dataType: 'json',
        data: {
            roomBoardId: ROOM_BOARD_ID,
            replyContent: content
        },
        success: function(response) {
            if (response.success) {
                jQuery('#replyContent').val('');
                jQuery('#currentLength').text('0');
                selectedImages = [];
                displayAttachedImages();
                loadReplyList();
                alert(response.message);
            } else {
                alert(response.message);
            }
        },
        error: function(xhr, status, error) {
            console.error('댓글 작성 에러:', error);
            alert('서버 오류가 발생했습니다: ' + error);
        }
    });
}

function toggleChildReplyForm(parentReplyId) {
    var form = jQuery('#childForm' + parentReplyId);
    form.toggle();
    if (form.is(':visible')) {
        jQuery('#childContent' + parentReplyId).off('input').on('input', function() {
            jQuery('#childLength' + parentReplyId).text(jQuery(this).val().length);
        });
    }
}

/**
 * ✅ 대댓글 작성 - /reply/write.ajax
 */
function writeChildReply(parentReplyId) {
    var content = jQuery('#childContent' + parentReplyId).val().trim();
    if (!content) {
        alert('답글 내용을 입력해주세요.');
        return;
    }
    
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/reply/write.ajax',
        type: 'POST',
        dataType: 'json',
        data: {
            roomBoardId: ROOM_BOARD_ID,
            replyContent: content,
            parentReplyId: parentReplyId
        },
        success: function(response) {
            if (response.success) {
                jQuery('#childContent' + parentReplyId).val('');
                toggleChildReplyForm(parentReplyId);
                loadReplyList();
                alert(response.message);
            } else {
                alert(response.message);
            }
        },
        error: function(xhr, status, error) {
            console.error('답글 작성 에러:', error);
            alert('서버 오류가 발생했습니다: ' + error);
        }
    });
}

/**
 * ✅ 댓글 수정 모드 활성화
 */
function editReply(replyId) {
    jQuery('.dropdown-menu').removeClass('show');
    var replyItem = jQuery('.reply-item[data-reply-id="' + replyId + '"]');
    var contentDiv = replyItem.find('.reply-content');
    var originalContent = contentDiv.data('original');
    contentDiv.html(
        '<textarea class="reply-textarea" id="editContent' + replyId + '" style="margin-top:8px;">' + escapeHtml(originalContent) + '</textarea>' +
        '<div class="reply-write-actions" style="margin-top:12px;">' +
        '<div class="write-tools"></div>' +
        '<span class="char-count"><span id="editLength' + replyId + '">' + originalContent.length + '</span>/3000</span>' +
        '<button class="btn-cancel" onclick="loadReplyList()">취소</button>' +
        '<button class="btn-submit" onclick="updateReply(' + replyId + ')">수정</button></div>'
    );
    jQuery('#editContent' + replyId).on('input', function() {
        jQuery('#editLength' + replyId).text(jQuery(this).val().length);
    });
}

/**
 * ✅ 댓글 수정 - /reply/update.ajax
 */
function updateReply(replyId) {
    var content = jQuery('#editContent' + replyId).val().trim();
    if (!content) {
        alert('댓글 내용을 입력해주세요.');
        return;
    }
    if (confirm('댓글을 수정하시겠습니까?')) {
        jQuery.ajax({
            url: '${pageContext.request.contextPath}/reply/update.ajax',
            type: 'POST',
            dataType: 'json',
            data: {
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
                console.error('댓글 수정 에러:', error);
                alert('서버 오류가 발생했습니다: ' + error);
            }
        });
    }
}

/**
 * ✅ 댓글 삭제 - /reply/delete.ajax
 */
function deleteReply(replyId) {
    jQuery('.dropdown-menu').removeClass('show');
    if (confirm('댓글을 삭제하시겠습니까?')) {
        jQuery.ajax({
            url: '${pageContext.request.contextPath}/reply/delete.ajax',
            type: 'POST',
            dataType: 'json',
            data: {
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
                console.error('댓글 삭제 에러:', error);
                alert('서버 오류가 발생했습니다: ' + error);
            }
        });
    }
}

function toggleDropdown(event, replyId) {
    event.stopPropagation();
    var dropdown = jQuery('#dropdown' + replyId);
    var isVisible = dropdown.hasClass('show');
    jQuery('.dropdown-menu').removeClass('show');
    if (!isVisible) {
        dropdown.addClass('show');
    }
}

function reportReply(replyId) {
    jQuery('.dropdown-menu').removeClass('show');
    if (confirm('이 댓글을 신고하시겠습니까?')) {
        alert('신고 기능은 준비 중입니다.');
    }
}

jQuery(document).on('click', function(e) {
    if (!jQuery(e.target).closest('.reply-more-menu').length) {
        jQuery('.dropdown-menu').removeClass('show');
    }
});

//현재 활성 탭 추적
var currentTab = 'reply';

/**
 * 탭 전환 함수
 */
function switchTab(tabName) {
    if (currentTab === tabName) return;
    
    currentTab = tabName;
    updateTabActiveState(tabName);
    
    if (tabName === 'reply') {
    	// 댓글 탭
        jQuery('#replyList').show();
        jQuery('#likeList').hide();
        jQuery('#likePagination').hide();
        jQuery('#replyPagination').show();
        jQuery('#replySortButtons').removeClass('hidden');
        jQuery('.reply-write-form').show(); // 댓글 입력창 표시
        loadReplyList();
    } else {
    	// 좋아요 탭
        jQuery('#replyList').hide();
        jQuery('#likeList').show();
        jQuery('#likePagination').show();
        jQuery('#replyPagination').hide();
        jQuery('#replySortButtons').addClass('hidden');
        jQuery('.reply-write-form').hide(); // 댓글 입력창 숨김
        loadLikeList();
    }
}

/**
 * 좋아요 목록 불러오기
 */
function loadLikeList() {
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/like/detail.ajax',
        type: 'GET',
        dataType: 'json',
        data: {
            roomBoardId: ROOM_BOARD_ID
        },
        success: function(response) {
            console.log('좋아요 목록 응답:', response);
            if (response.success) {
                displayLikeList(response.likeUsers);
                jQuery('#likeTotalCount').text(response.totalCount);
            } else {
                alert(response.message);
            }
        },
        error: function(xhr, status, error) {
            console.error('좋아요 목록 로드 에러:', error);
            alert('서버 오류가 발생했습니다: ' + error);
        }
    });
}

/**
 * 좋아요 목록 표시
 */
function displayLikeList(likeUsers) {
    var likeList = jQuery('#likeList');
    likeList.empty();
    
    if (likeUsers.length === 0) {
        likeList.html('<div class="empty-state">아직 좋아요가 없습니다.</div>');
        jQuery('#likePagination').hide();
        return;
    }
    
    var contextPath = '${pageContext.request.contextPath}';
    
    // 그리드 컨테이너 생성
    var gridContainer = jQuery('<div class="like-users-grid"></div>');
    
    for (var i = 0; i < likeUsers.length; i++) {
        var user = likeUsers[i];
        var profileImgSrc = user.userPhoto ? 
            contextPath + user.userPhoto : 
            contextPath + '/images/default-avatar.png';
        
        var likeDate = formatDateTime(user.likeCreatedAt);
        
        var userHtml = '<div class="like-user-item">' +
            '<img src="' + profileImgSrc + '" alt="프로필" class="like-user-avatar" ' +
            'onerror="this.src=\'' + contextPath + '/images/default-avatar.png\';">' +
            '<div class="like-user-info">' +
            '<div class="like-user-name">' + escapeHtml(user.userNickname) + '</div>' +
            '<div class="like-user-date">' + likeDate + '</div>' +
            '</div></div>';
        
        gridContainer.append(userHtml);
    }
    
    likeList.append(gridContainer);
    
    // 페이지네이션 표시 (좋아요가 있을 때만)
    if (likeUsers.length > 0) {
        jQuery('#likePagination').show();
    }
}

// 페이지 로드 시 좋아요 개수도 함께 로드
jQuery(document).ready(function() {
    console.log('댓글 시스템 로드, ROOM_BOARD_ID:', ROOM_BOARD_ID);
    loadReplyList();
    loadInitialLikeCount(); // 초기 좋아요 개수 로드
    
    // 글자 수 카운터
    jQuery('#replyContent').on('input', function() {
        jQuery('#currentLength').text(jQuery(this).val().length);
    });
    
    // 정렬 버튼 클릭
    jQuery('.sort-btn').on('click', function() {
        jQuery('.sort-btn').removeClass('active');
        jQuery(this).addClass('active');
        currentOrder = jQuery(this).data('order');
        loadReplyList();
    });
});

/**
 * 초기 좋아요 개수 로드
 */
function loadInitialLikeCount() {
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/like/count.ajax',
        type: 'GET',
        dataType: 'json',
        data: {
            targetType: 'ROOM_BOARD',
            targetId: ROOM_BOARD_ID
        },
        success: function(response) {
            if (response.success) {
                jQuery('#likeTotalCount').text(response.likeCount);
            }
        },
        error: function(xhr, status, error) {
            console.error('좋아요 개수 로드 에러:', error);
        }
    });
}

/**
 * 게시글 좋아요 토글
 */
function togglePostLike() {
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/like/action.ajax',
        type: 'POST',
        dataType: 'json',
        data: {
            targetType: 'ROOM_BOARD',
            targetId: ROOM_BOARD_ID
        },
        success: function(response) {
            console.log('게시글 좋아요 응답:', response);
            if (response.success) {
                isPostLiked = response.isLiked;
                updatePostLikeUI();
                
                // 좋아요 개수 업데이트
                jQuery('#likeTotalCount').text(response.likeCount);
                
                // 게시글 상세 페이지의 좋아요 개수도 업데이트 (window.updatePostLikeCount 가 있는 경우)
                if (typeof window.updatePostLikeCount === 'function') {
                    window.updatePostLikeCount(response.likeCount, response.isLiked);
                }
                
                // 좋아요 탭이 활성화되어 있으면 목록도 새로고침
                if (currentTab === 'like') {
                    loadLikeList();
                }
                
                console.log('게시글 좋아요 ' + response.action + '! 총 ' + response.likeCount + '개');
            } else {
                alert(response.message || '좋아요 처리에 실패했습니다.');
            }
        },
        error: function(xhr, status, error) {
            console.error('게시글 좋아요 처리 중 오류:', error);
            console.error('응답:', xhr.responseText);
            alert('좋아요 처리에 실패했습니다.');
        }
    });
}

/**
 * 게시글 좋아요 개수 업데이트 함수 (detailRoomBoard.jsp에서 호출)
 */
window.updateReplyLikeCount = function(likeCount) {
    jQuery('#likeTotalCount').text(likeCount);
    
    // 좋아요 탭이 활성화되어 있으면 목록도 새로고침
    if (currentTab === 'like') {
        loadLikeList();
    }
};

/**
 * 초기 좋아요 개수 로드
 */
function loadInitialLikeCount() {
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/like/count.ajax',
        type: 'GET',
        dataType: 'json',
        data: {
            targetType: 'ROOM_BOARD',
            targetId: ROOM_BOARD_ID
        },
        success: function(response) {
            if (response.success) {
                jQuery('#likeTotalCount').text(response.likeCount);
                
                // 게시글 상세의 좋아요 개수도 동기화
                const postLikeCount = jQuery('.post-detail-container .like-count');
                if (postLikeCount.length > 0) {
                    postLikeCount.text(response.likeCount);
                }
            }
        },
        error: function(xhr, status, error) {
            console.error('좋아요 개수 로드 에러:', error);
        }
    });
}

/**
 * 게시글 좋아요 상태 로드
 */
function loadPostLikeStatus() {
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/like/count.ajax',
        type: 'GET',
        dataType: 'json',
        data: {
            targetType: 'ROOM_BOARD',
            targetId: ROOM_BOARD_ID
        },
        success: function(response) {
            console.log('게시글 좋아요 상태 응답:', response);
            if (response.success) {
                isPostLiked = response.isLiked;
                updatePostLikeUI();
            }
        },
        error: function(xhr, status, error) {
            console.error('게시글 좋아요 상태 로드 에러:', error);
        }
    });
}

/**
 * 게시글 좋아요 UI 업데이트
 */
function updatePostLikeUI() {
    var postLikeBtn = jQuery('#postLikeBtn');
    var svg = postLikeBtn.find('svg');
    
    if (isPostLiked) {
        postLikeBtn.addClass('liked');
        svg.attr('fill', '#ff5a5f');
        svg.attr('stroke', '#ff5a5f');
    } else {
        postLikeBtn.removeClass('liked');
        svg.attr('fill', 'none');
        svg.attr('stroke', 'currentColor');
    }
}

/**
 * 게시글 좋아요 토글
 */
function togglePostLike() {
    jQuery.ajax({
        url: '${pageContext.request.contextPath}/like/action.ajax',
        type: 'POST',
        dataType: 'json',
        data: {
            targetType: 'ROOM_BOARD',
            targetId: ROOM_BOARD_ID
        },
        success: function(response) {
            console.log('게시글 좋아요 응답:', response);
            if (response.success) {
                isPostLiked = response.isLiked;
                updatePostLikeUI();
                
                // 좋아요 개수 업데이트
                jQuery('#likeTotalCount').text(response.likeCount);
                
                // 게시글 상세 페이지의 좋아요 개수도 업데이트
                if (typeof window.updatePostLikeCount === 'function') {
                    window.updatePostLikeCount(response.likeCount, response.isLiked);
                }
                
                // 좋아요 탭이 활성화되어 있으면 목록도 새로고침
                if (currentTab === 'like') {
                    loadLikeList();
                }
                
                console.log('게시글 좋아요 ' + response.action + '! 총 ' + response.likeCount + '개');
            } else {
                alert(response.message || '좋아요 처리에 실패했습니다.');
            }
        },
        error: function(xhr, status, error) {
            console.error('게시글 좋아요 처리 중 오류:', error);
            console.error('응답:', xhr.responseText);
            alert('좋아요 처리에 실패했습니다.');
        }
    });
}

/**
 * 탭 선택에 따른 UI 업데이트
 */
function updateTabActiveState(tabName) {
    // 탭 버튼 스타일 초기화
    jQuery('.tab-button').removeClass('active');
    jQuery('.like-text-btn').removeClass('active');
    
    if (tabName === 'like') {
        jQuery('.like-text-btn').addClass('active');
    } else {
        jQuery('.tab-button[data-tab="' + tabName + '"]').addClass('active');
    }
}

</script>