<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 통계보드</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/accessibility.js"></script>

<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: #fffdfd;
	color: #333;
}

header.nav-root * {
	line-height: normal;
	padding: 0;
	margin: 0;
}

.page-header {
	display: flex;
	justify-content: center;
	align-items: center;
	flex-direction: column;
	text-align: center;
	margin-top: 20px;
	margin-bottom: 40px;
	padding: 20px 0;
}

.page-header h1 {
	font-size: 32px;
	font-weight: 700;
	color: #333;
	margin: 0;
}

.stat-container {
	max-width: 1100px;
	margin: 0 auto 80px;
	background: #fff;
	border-radius: 16px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
	padding: 40px 50px;
}

.stat-header {
	display: flex;
	justify-content: right;
	align-items: center;
	margin-bottom: 30px;
	gap: 2px;
}

.update-time {
	color: #aaa;
	font-size: 14px;
}

#refreshBtn {
	border: none;
	color: #aaa;
	font-size: 14px;
	background: #fff;
	border-radius: 100%;
	transition: 0.2s;
}

#refreshBtn:hover {
	color: #FF7272;
}

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
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
	text-align: center;
	transition: all 0.3s ease;
}

.stat-card:hover {
	transform: translateY(-3px);
	box-shadow: 0 4px 10px rgba(255, 114, 114, 0.15);
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
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
}

.top-list {
	background: #fff;
	border: 1px solid #f3f3f3;
	border-radius: 12px;
	padding: 25px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
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
	color: #333;
	min-width: 120px;
	white-space: nowrap;
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

.layout-wrap {
	display: grid;
	grid-template-columns: auto 1fr;
	gap: 0;
	align-items: flex-start;
	margin: 0;
	padding: 0;
}

main {
	background: #fff;
	border-left: 1px solid #e5e7eb;
	padding: 24px 28px;
	min-height: 100vh;
}

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
	<div class="layout-wrap">
		<!-- 사이드바 -->
		<jsp:include page="/include/adminSidebar.jsp">
			<jsp:param name="current" value="adminStat" />
		</jsp:include>

		<!-- 메인 -->
		<main>
			<header class="page-header">
				<h1>통계</h1>
			</header>

			<div class="stat-container">
				<div class="stat-header">
					<div class="update-time">업데이트: 로딩 중...</div>
					<button id="refreshBtn">
						<i class="fa-solid fa-rotate"></i>
					</button>
				</div>

				<!-- 상단 카드 -->
				<div class="stat-cards">
					<div class="stat-card">
						<i class="fa-solid fa-user-group"></i>
						<div class="number">-</div>
						<small>총 가입자 수</small>
					</div>
					<div class="stat-card">
						<i class="fa-solid fa-layer-group"></i>
						<div class="number">-</div>
						<small>총 모임 수</small>
					</div>
					<div class="stat-card">
						<i class="fa-solid fa-user-check"></i>
						<div class="number">-</div>
						<small>모임 참여자 수</small>
					</div>
					<div class="stat-card">
						<i class="fa-solid fa-user-xmark"></i>
						<div class="number">-</div>
						<small>모임 미참여자 수</small>
					</div>
				</div>

				<!-- 차트 -->
				<div class="charts">
					<div class="chart-box">
						<div id="ageChart" style="height: 300px;"></div>
					</div>
					<div class="chart-box">
						<div id="participationChart" style="height: 300px;"></div>
					</div>
				</div>

				<!-- 인기 자격증 -->
				<div class="top-list">
					<h5>인기 자격증 카테고리 TOP 5</h5>
					<p>데이터를 불러오는 중...</p>
				</div>
			</div>
		</main>
	</div>

<script>
$(document).ready(function() {

	function loadDashboardData() {
		$.ajax({
			url: "${pageContext.request.contextPath}/AdminStatAjax",
			method: "GET",
			dataType: "json",
			success: function(data) {
				console.log("[AdminStatAjax 응답]", data);

				$(".update-time").text("업데이트: " + data.lastSyncTime);

				// 상단 카드
				const s = data.summary;
				const cards = $(".stat-card");
				$(cards[0]).find(".number").text(s.totalUsers.toLocaleString());
				$(cards[1]).find(".number").text(s.totalRooms.toLocaleString());
				$(cards[2]).find(".number").text(s.joinedUsers.toLocaleString());
				$(cards[3]).find(".number").text(s.notJoinedUsers.toLocaleString());

				// 연령대별 차트
				const ageCategories = data.ageChart.map(a => a.ageGroup + "대");
				const ageCounts = data.ageChart.map(a => a.count);
				Highcharts.chart('ageChart', {
					chart: { type: 'column', backgroundColor: 'transparent' },
					title: { text: '연령대별 분포' },
					xAxis: { categories: ageCategories },
					yAxis: { title: { text: '인원 수' } },
					series: [{ name: '참여자 수', data: ageCounts, color: '#FF7272' }]
				});

				// 참여율 파이차트
				const p = data.participationChart;
				Highcharts.chart('participationChart', {
					chart: { type: 'pie', backgroundColor: 'transparent' },
					title: { text: '모임 참여율' },
					plotOptions: { pie: { innerSize: '60%', dataLabels: { format: '{point.percentage:.0f}%', distance: -30 } } },
					series: [{
						name: '비율',
						data: [
							{ name: '모임 참여자', y: p.joined, color: '#FF7272' },
							{ name: '모임 미참여자', y: p.notJoined, color: '#bdbdbd' }
						]
					}]
				});

				// 인기 자격증
				const topCerts = data.topCerts || [];
				console.log("🎯 topCerts:", topCerts);
				if (topCerts.length === 0) {
					$(".top-list").html("<h5>인기 자격증 데이터 없음</h5>");
				} else {
					const listContainer = $(".stat-container .top-list");
					let html = '<h5>인기 자격증 카테고리 TOP 5</h5>';
					const max = Math.max(...topCerts.map(c => c.count));
					console.log("🎯 max:", max);

					topCerts.forEach((cert, i) => {
						const width = Math.max(10, (cert.count / max) * 100);
						const color = i >= 3 ? '#bdbdbd' : '#FF7272';
						html += 
						  '<div class="rank-item">' +
						    '<div class="rank-left">' +
						      '<div class="rank-num">' + (i + 1) + '</div>' +
						      '<div class="rank-title">' + cert.name + '</div>' +
						    '</div>' +
						    '<div class="rank-bar">' +
						      '<div class="rank-fill" style="width:' + width + '%; background:' + color + ';"></div>' +
						    '</div>' +
						  '</div>';
					});
					console.log("🎯 최종 HTML:", html);
					listContainer.html(html);
				}
			},
			error: function(err) {
				console.error("❌ 통계 로드 실패:", err);
				alert("통계 데이터를 불러오는 중 오류가 발생했습니다.");
			}
		});
	}

	loadDashboardData();
	$("#refreshBtn").on("click", loadDashboardData);
});
</script>


</body>
</html>
