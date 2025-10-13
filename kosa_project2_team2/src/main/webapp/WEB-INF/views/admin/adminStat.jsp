<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 통계보드</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="https://code.highcharts.com/modules/accessibility.js"></script>

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

        .stat-container {
            max-width: 1100px;
            margin: 0 auto 80px;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            padding: 40px 50px;
        }

        .stat-header {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            margin-bottom: 30px;
        }

        .update-time {
            color: #aaa;
            font-size: 14px;
        }

        /* 상단 카드 */
        .stat-cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            border-radius: 12px;
            background: #fffafa;
            padding: 25px 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            text-align: center;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 10px rgba(255,114,114,0.15);
        }

        .stat-card i {
            font-size: 30px;
            color: #FF7272;
            margin-bottom: 10px;
        }

        .stat-card .number {
            font-size: 26px;
            font-weight: 700;
            color: #333;
        }

        .stat-card small {
            display: block;
            margin-top: 5px;
            color: #999;
        }

        .trend-up {
            color: #2ecc71;
            font-weight: 600;
            font-size: 13px;
        }

        .trend-down {
            color: #e74c3c;
            font-weight: 600;
            font-size: 13px;
        }

        /* 차트 영역 */
        .charts {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            margin-bottom: 50px;
        }

        .chart-box {
            background: #fff;
            border: 1px solid #f3f3f3;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        }

        /* 하단 인기 자격증 */
        .top-list {
            background: #fff;
            border: 1px solid #f3f3f3;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        }

        .top-list h5 {
            font-weight: 700;
            margin-bottom: 20px;
            color: #444;
        }

        .rank-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .rank-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .rank-num {
            background: #FF7272;
            color: #fff;
            font-weight: 600;
            width: 28px;
            height: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            font-size: 13px;
        }

        .rank-title {
            font-weight: 600;
        }

        .rank-bar {
            width: 50%;
            height: 8px;
            border-radius: 4px;
            background: #f1f1f1;
            overflow: hidden;
        }

        .rank-fill {
            height: 100%;
            background: #FF7272;
        }
        
        
        /* ===== sideBar 전체 레이아웃 ===== */
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
		}
		
		
    </style>
</head>

<body>
	<jsp:include page="/include/nav.jsp" />
	
	<!-- 사이드바 + 메인 레이아웃 -->
    <div class="layout-wrap">
        
        <!-- 좌측 사이드바 -->
        <jsp:include page="/include/adminSidebar.jsp">
            <jsp:param name="current" value="adminStat"/>
        </jsp:include>
        
        <!-- 우측 본문 -->
        <main>
		            
		    <!-- 페이지 제목 -->
		    <h2>통계</h2>
		
		    <div class="stat-container">
		        <div class="stat-header">
		            <div class="update-time">업데이트: 2025년 10월 2일 18:00</div>
		        </div>
		
		        <!-- 상단 카드 -->
		        <div class="stat-cards">
		            <div class="stat-card">
		                <i class="fa-solid fa-user-group"></i>
		                <div class="number">1,000</div>
		                <small>총 가입자 수</small>
		                <div class="trend-up">▲ 10% 이전 달 대비</div>
		            </div>
		            <div class="stat-card">
		                <i class="fa-solid fa-layer-group"></i>
		                <div class="number">500</div>
		                <small>총 모임 수</small>
		                <div class="trend-down">▼ 5% 이전 달 대비</div>
		            </div>
		            <div class="stat-card">
		                <i class="fa-solid fa-user-check"></i>
		                <div class="number">640</div>
		                <small>모임 참여자 수</small>
		                <div class="trend-up">▲ 30% 이전 달 대비</div>
		            </div>
		            <div class="stat-card">
		                <i class="fa-solid fa-user-xmark"></i>
		                <div class="number">360</div>
		                <small>모임 미참여자 수</small>
		                <div class="trend-down">▼ 5% 이전 달 대비</div>
		            </div>
		        </div>
		
		        <!-- 차트 -->
		        <div class="charts">
		            <div class="chart-box">
		                <div id="ageChart" style="height:300px;"></div>
		            </div>
		            <div class="chart-box">
		                <div id="participationChart" style="height:300px;"></div>
		            </div>
		        </div>
		
		        <!-- 인기 자격증 -->
		        <div class="top-list">
		            <h5>인기 자격증 카테고리 TOP 5</h5>
		
		            <div class="rank-item">
		                <div class="rank-left">
		                    <div class="rank-num">1</div>
		                    <div class="rank-title">정보처리기사</div>
		                </div>
		                <div class="rank-bar"><div class="rank-fill" style="width:80%;"></div></div>
		            </div>
		
		            <div class="rank-item">
		                <div class="rank-left">
		                    <div class="rank-num">2</div>
		                    <div class="rank-title">정보보안기사</div>
		                </div>
		                <div class="rank-bar"><div class="rank-fill" style="width:60%;"></div></div>
		            </div>
		
		            <div class="rank-item">
		                <div class="rank-left">
		                    <div class="rank-num">3</div>
		                    <div class="rank-title">전기기사</div>
		                </div>
		                <div class="rank-bar"><div class="rank-fill" style="width:45%;"></div></div>
		            </div>
		
		            <div class="rank-item">
		                <div class="rank-left">
		                    <div class="rank-num">4</div>
		                    <div class="rank-title">건축기사</div>
		                </div>
		                <div class="rank-bar"><div class="rank-fill" style="width:30%; background:#bdbdbd;"></div></div>
		            </div>
		
		            <div class="rank-item">
		                <div class="rank-left">
		                    <div class="rank-num">5</div>
		                    <div class="rank-title">네트워크관리사</div>
		                </div>
		                <div class="rank-bar"><div class="rank-fill" style="width:28%; background:#bdbdbd;"></div></div>
		            </div>
		        </div>
		    </div>
            
        </main>
    </div>


    <!-- 차트 스크립트 -->
    <script>
        Highcharts.chart('ageChart', {
            chart: { type: 'column', backgroundColor: 'transparent' },
            title: { text: '연령대별 분포' },
            xAxis: { categories: ['10대', '20대', '30대', '40대', '50대 이상'] },
            yAxis: { title: { text: '' } },
            series: [{
                name: '참여자 수',
                data: [30, 70, 55, 40, 25],
                color: '#FF7272'
            }]
        });

        Highcharts.chart('participationChart', {
            chart: { type: 'pie', backgroundColor: 'transparent' },
            title: { text: '참여율 현황' },
            plotOptions: {
                pie: {
                    innerSize: '60%',
                    dataLabels: { format: '{point.percentage:.0f}%', distance: -30 }
                }
            },
            series: [{
                name: '비율',
                data: [
                    { name: '모임 참여자', y: 64, color: '#FF7272' },
                    { name: '모임 미참여자', y: 36, color: '#bdbdbd' }
                ]
            }]
        });
    </script>
</body>
</html>
