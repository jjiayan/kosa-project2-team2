<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 회원관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	    
	<!-- Font Awesome (아이콘용) -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css">
	    
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #fffdfd;
            color: #333;
        }

        .member-container {
            max-width: 1100px;
            margin: 80px auto;
        }

        h2 {
            font-weight: 700;
            margin-bottom: 40px;
            text-align: center;
            color: #444;
        }

        /* ✅ 검색창 오른쪽 정렬 + 테두리 제거 + 아이콘 정렬 보정 */
        .search-box {
            position: relative;
            display: flex;
            justify-content: flex-end;
            margin-bottom: 40px;
            margin-right: 5px;
        }

        .search-box input {
            background-color: #fffafa;
            border: none;
            border-radius: 25px;
            padding: 10px 40px 10px 18px;
            width: 260px;
            font-size: 14px;
            transition: all 0.25s ease-in-out;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .search-box input::placeholder {
            color: #d88c8c;
        }

        .search-box input:focus {
            outline: none;
            background-color: #fff5f5;
            box-shadow: 0 0 8px rgba(255,114,114,0.3);
        }

        .search-box i {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #FF7272;
            font-size: 16px;
            pointer-events: none;
        }

        /* 회원 카드 */
        .member-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
            justify-items: center;
        }

        .member-card {
            width: 90%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border: 1px solid #f0eaea;
            border-radius: 12px;
            padding: 18px 22px;
            background-color: #fff;
            box-shadow: 0 3px 8px rgba(0,0,0,0.04);
            transition: 0.3s ease-in-out;
        }

        .member-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 6px 14px rgba(255,114,114,0.15);
        }

        .member-info {
            display: flex;
            align-items: center;
        }

        .member-info img {
            width: 55px;
            height: 55px;
            border-radius: 50%;
            margin-right: 15px;
            border: 2px solid #FFBDBD;
        }

        .member-info .name {
            font-weight: 600;
            font-size: 16px;
            margin-bottom: 2px;
        }

        .member-info .date {
            color: #999;
            font-size: 13px;
        }

        .btn-delete {
            background-color: #FF7272;
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 8px 20px;
            font-weight: 500;
            box-shadow: 0 3px 6px rgba(255,114,114,0.25);
            transition: all 0.3s ease;
        }

        .btn-delete:hover {
            background-color: #E85A5A;
            box-shadow: 0 4px 10px rgba(232,90,90,0.3);
            transform: translateY(-1px);
        }

        /* 페이지네이션 */
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 45px;
            gap: 10px;
            align-items: center;
        }

        .pagination button {
            border: none;
            background: none;
            color: #FF7272;
            font-size: 20px;
            cursor: pointer;
            transition: 0.2s;
        }

        .pagination button:hover {
            color: #E85A5A;
        }

        .pagination .page-num {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            border: 1px solid #FFBDBD;
            background-color: #fffafa;
            color: #FF7272;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .pagination .page-num.active {
            background-color: #FF7272;
            color: #fff;
            border-color: #FF7272;
            box-shadow: 0 3px 6px rgba(255,114,114,0.3);
        }

        .pagination .page-num:hover {
            background-color: #FFDADA;
            color: #fff;
        }

        @media (max-width: 900px) {
            .member-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 600px) {
            .member-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
	<jsp:include page="/include/nav.jsp" />

    <div class="member-container">
        <h2>회원관리</h2>

        <!-- 검색창 (디자인 통일성 필요) -->
        <div class="search-box">
            <input type="text" placeholder="닉네임을 입력해주세요.">
            <i class="fa fa-search"></i>
        </div>

        <!-- 회원 목록 카드 더미 -->
        <div class="member-grid">
            <div class="member-card">
                <div class="member-info">
                    <img src="https://via.placeholder.com/50" alt="프로필">
                    <div>
                        <div class="name">건재이</div>
                        <div class="date">가입일 2025.10.02</div>
                    </div>
                </div>
                <button class="btn-delete">탈퇴</button>
            </div>
            <div class="member-card">
                <div class="member-info">
                    <img src="https://via.placeholder.com/50" alt="프로필">
                    <div>
                        <div class="name">서희정</div>
                        <div class="date">가입일 2025.09.20</div>
                    </div>
                </div>
                <button class="btn-delete">탈퇴</button>
            </div>
            <div class="member-card">
                <div class="member-info">
                    <img src="https://via.placeholder.com/50" alt="프로필">
                    <div>
                        <div class="name">홍길동</div>
                        <div class="date">가입일 2025.08.15</div>
                    </div>
                </div>
                <button class="btn-delete">탈퇴</button>
            </div>
        </div>

        <!-- 페이지네이션 (통일 필요)-->
        <div class="pagination">
            <button>&lt;</button>
            <button class="page-num active">1</button>
            <button class="page-num">2</button>
            <button class="page-num">3</button>
            <button class="page-num">4</button>
            <button class="page-num">5</button>
            <button>&gt;</button>
        </div>
    </div>
</body>
</html>
