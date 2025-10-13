<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사이드바</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background-color: #f8f9fa;
        }
        
        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 280px;
            height: 100vh;
            background: white;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            z-index: 1000;
        }
        
        .sidebar-content {
            flex: 1;
            padding: 20px 0;
            display: flex;
            flex-direction: column;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            padding: 15px 25px;
            color: #333;
            text-decoration: none;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            background: none;
            width: 100%;
            text-align: left;
            cursor: pointer;
            position: relative;
        }
        
        .nav-item:hover {
            background-color: #f8f9fa;
        }
        
        .nav-item.active {
            background-color: #fce4ec;
            color: #c2185b;
            font-weight: 600;
        }
        
        .nav-item.active::after {
            content: '';
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            background: #ff6b9d;
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .nav-item.active.게시글::after {
            content: '24';
        }
        
        .nav-icon {
            width: 24px;
            height: 24px;
            margin-right: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }
        
        .nav-text {
            flex: 1;
        }
        
        .nav-badge {
            background: #ff6b9d;
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        
        /* 구분선 */
        .nav-divider {
            height: 1px;
            background-color: #e9ecef;
            margin: 10px 25px;
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }
            
            .sidebar.open {
                transform: translateX(0);
            }
        }
        
        /* 메인 컨텐츠 영역 */
        .main-content {
            margin-left: 280px;
            padding: 20px;
            min-height: 100vh;
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
            }
        }
        
        /* 햄버거 메뉴 (모바일용) */
        .menu-toggle {
            display: none;
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1001;
            background: white;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            cursor: pointer;
        }
        
        @media (max-width: 768px) {
            .menu-toggle {
                display: flex;
                align-items: center;
                justify-content: center;
            }
        }
        
        /* 오버레이 (모바일용) */
        .sidebar-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 999;
        }
        
        .sidebar-overlay.show {
            display: block;
        }
    </style>
</head>
<body>
    <!-- 햄버거 메뉴 버튼 (모바일) -->
    <button class="menu-toggle" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>
    
    <!-- 사이드바 오버레이 (모바일) -->
    <div class="sidebar-overlay" onclick="closeSidebar()"></div>
    
    <!-- 사이드바 -->
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-content">
            <!-- 홈 -->
            <a href="/home" class="nav-item">
                <div class="nav-icon">
                    <i class="fas fa-home"></i>
                </div>
                <span class="nav-text">홈</span>
            </a>
            
            <!-- 게시글 (활성화 상태 + 뱃지) -->
            <a href="/posts" class="nav-item active 게시글">
                <div class="nav-icon">
                    <i class="fas fa-file-alt"></i>
                </div>
                <span class="nav-text">게시글</span>
            </a>
            
            <!-- 캘린더 -->
            <a href="/calendar" class="nav-item">
                <div class="nav-icon">
                    <i class="fas fa-calendar-alt"></i>
                </div>
                <span class="nav-text">캘린더</span>
            </a>
            
            <!-- 공지사항 -->
            <a href="/notices" class="nav-item">
                <div class="nav-icon">
                    <i class="fas fa-bell"></i>
                </div>
                <span class="nav-text">공지사항</span>
            </a>
            
            <!-- 관리 -->
            <a href="/manage" class="nav-item">
                <div class="nav-icon">
                    <i class="fas fa-user-cog"></i>
                </div>
                <span class="nav-text">관리</span>
            </a>
        </div>
    </nav>
    
    <!-- 메인 컨텐츠 영역 -->
    <main class="main-content">
        <h1>메인 컨텐츠 영역</h1>
        <p>여기에 페이지 내용이 들어갑니다.</p>
    </main>

    <script>
        // 사이드바 토글 (모바일)
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const overlay = document.querySelector('.sidebar-overlay');
            
            sidebar.classList.toggle('open');
            overlay.classList.toggle('show');
        }
        
        // 사이드바 닫기
        function closeSidebar() {
            const sidebar = document.getElementById('sidebar');
            const overlay = document.querySelector('.sidebar-overlay');
            
            sidebar.classList.remove('open');
            overlay.classList.remove('show');
        }
        
        // 네비게이션 아이템 클릭 처리
        document.addEventListener('DOMContentLoaded', function() {
            const navItems = document.querySelectorAll('.nav-item');
            
            navItems.forEach(item => {
                item.addEventListener('click', function(e) {
                    // 현재 활성화된 아이템 제거
                    navItems.forEach(nav => nav.classList.remove('active'));
                    
                    // 클릭된 아이템 활성화
                    this.classList.add('active');
                    
                    // 모바일에서 사이드바 자동 닫기
                    if (window.innerWidth <= 768) {
                        closeSidebar();
                    }
                });
            });
        });
        
        // 윈도우 리사이즈 처리
        window.addEventListener('resize', function() {
            if (window.innerWidth > 768) {
                closeSidebar();
            }
        });
    </script>
</body>
</html>