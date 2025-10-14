<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>공지사항</title>
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

h2 {
	text-align: center;
	font-weight: 700;
	color: #444;
	margin-top: 80px;
	margin-bottom: 40px;
}

.notice-container {
	max-width: 1000px;
	margin: 0 auto 80px;
	background: #fff;
	border-radius: 16px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
	padding: 40px 50px;
}

.notice-header {
	display: flex;
	justify-content: flex-end;
	margin-bottom: 20px;
}

.btn-write {
	background-color: #FF7272;
	color: #fff;
	border: none;
	border-radius: 8px;
	padding: 8px 18px;
	font-size: 14px;
	transition: 0.3s;
}

.btn-write:hover {
	background-color: #E85A5A;
	box-shadow: 0 3px 8px rgba(255, 114, 114, 0.25);
} /* 테이블 */
table {
	width: 100%;
	border-collapse: collapse;
	font-size: 15px;
	text-align: center;
}

.table-title, .table-content {
	max-width: 250px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	vertical-align: middle;
}

thead {
	background-color: #fffafa;
}

th {
	padding: 15px;
	color: #555;
	border-bottom: 2px solid #f0eaea;
	font-weight: 600;
}

td {
	padding: 10px;
	border-bottom: 1px solid #f5f5f5;
	vertical-align: middle;
}

tr:hover {
	background-color: #fff8f8;
	transition: 0.2s;
}

.btn-edit, .btn-delete {
	border: 1px solid #ddd;
	border-radius: 6px;
	background: #fff;
	padding: 5px 12px;
	font-size: 14px;
	transition: 0.25s;
}

.btn-edit:hover {
	background-color: #ffeaea;
	border-color: #FF7272;
	color: #FF7272;
}

.btn-delete:hover {
	background-color: #FF7272;
	color: #fff;
	border-color: #FF7272;
} /* 페이지네이션 */
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
} /* ===== sideBar 전체 레이아웃 ===== */
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
} /* ===== 반응형 ===== */
@media ( max-width : 900px) {
	.layout-wrap {
		grid-template-columns: 1fr;
	}
	main {
		border-left: none;
		border-top: 1px solid #e5e7eb;
		padding: 16px;
	}
}
</style>
</head>
<body>
	<jsp:include page="/include/nav.jsp" />
	<!-- 사이드바 + 메인 레이아웃 -->
	<div class="layout-wrap">
		<!-- 좌측 사이드바 -->
		<jsp:include page="/include/adminSidebar.jsp">
			<jsp:param name="current" value="adminNotice" />
		</jsp:include>
		<!-- 우측 본문 -->
		<main>
			<!-- 제목 -->
			<h2>공지사항</h2>
			<div class="notice-container">
				<div class="notice-header">
					<c:if
						test="${not empty sessionScope.LOGIN_USER and sessionScope.LOGIN_USER.user_status eq 'ADMIN'}">
						<button class="btn-write">글쓰기</button>
					</c:if>
				</div>
				<!-- 공지사항 테이블 더미-->
				<table>
					<thead>
						<tr>
							<th style="width: 10%;">순번</th>
							<th style="width: 10%;">제목</th>
							<th style="width: 50%;">내용</th>
							<th style="width: 10%;">조회수</th>
							<c:if
								test="${not empty sessionScope.LOGIN_USER and sessionScope.LOGIN_USER.user_status eq 'ADMIN'}">
								<th style="width: 20%;">관리</th>
							</c:if>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${not empty noticeList}">
								<c:forEach var="notice" items="${noticeList}">
									<tr>
										<td>${notice.adminNoticeId}</td>
										<td class="table-title">${notice.adminNoticeTitle}</td>
										<td class="table-content">${notice.adminNoticeContent}</td>
										<td>${notice.adminNoticeViewCnt}</td>
										<c:if
											test="${not empty sessionScope.LOGIN_USER and sessionScope.LOGIN_USER.user_status eq 'ADMIN'}">
											<td>
												<button class="btn-edit">수정</button>
												<button class="btn-delete">삭제</button>
											</td>
										</c:if>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="5">등록된 공지사항이 없습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
				<!-- 페이지네이션 -->
				<div class="pagination">
					<c:if test="${totalPage > 1}">
						<c:forEach var="i" begin="1" end="${totalPage}">
							<a
								href="${pageContext.request.contextPath}/adminNotice.admin?page=${i}"
								class="page-num ${i == currentPage ? 'active' : ''}"> ${i} </a>
						</c:forEach>
					</c:if>
				</div>
			</div>
		</main>
	</div>
</body>
</html>