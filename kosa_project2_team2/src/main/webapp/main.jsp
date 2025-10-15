<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>메인 | Certification Bible</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/style/default.css">

<style>
  body {
    margin: 0;
    font-family: 'Noto Sans KR', sans-serif;
    background: linear-gradient(to bottom, rgba(255, 114, 114, 0.15), #fffaf9);
    color: #333;
    overflow: hidden;
    position: relative;
  }

  /* === 떠다니는 배경 이미지 === */
  .floating-bg {
    position: absolute;
    top: 0; left: 0;
    width: 100%; height: 100%;
    overflow: hidden;
    z-index: 0;
  }

  .floating-img {
    position: absolute;
    width: 280px;
    height: 280px;
    opacity: 0.12;
    object-fit: cover;
    border-radius: 50%;
    pointer-events: none;
    animation: floatRandom 18s ease-in-out infinite;
  }

  /* 둥둥 떠다니는 애니메이션 (랜덤한 움직임 느낌) */
  @keyframes floatRandom {
    0%   { transform: translate(0px, 0px); }
    25%  { transform: translate(25px, -30px); }
    50%  { transform: translate(-20px, -10px); }
    75%  { transform: translate(-30px, 25px); }
    100% { transform: translate(0px, 0px); }
  }

  /* Hero Section */
  .hero {
    height: 100vh;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
    position: relative;
    z-index: 2;
    transition: all 1s ease;
  }

  .hero small {
    font-size: clamp(14px, 1.3vw, 18px);
    color: #777;
    margin-bottom: 10px;
    opacity: 0;
 animation: fadeInUp 1.5s ease 0.2s forwards;
    transition: transform 1.2s ease, font-size 1.2s ease, opacity 1s ease;
  }

  .hero h1 {
    font-family: 'Playfair Display', serif;
    font-size: clamp(36px, 5vw, 76px);
    color: #FF7272;
    letter-spacing: 0.3vw;
    font-weight: 400;
    margin: 0;
    line-height: 1.2;
    opacity: 0;
     animation: fadeInUp 1.5s ease 0.2s forwards;
    transition: transform 1.2s ease, font-size 1.2s ease, opacity 1s ease;
  }

  .hero.shrink h1 {
    font-size: clamp(28px, 3.5vw, 64px);
    transform: translateY(-20vh);
  }

  .hero.shrink small {
    font-size: clamp(12px, 1vw, 15px);
    transform: translateY(-20vh);
  }

  .intro {
    opacity: 0;
    transform: translateY(50px);
    transition: all 1.2s ease;
    text-align: center;
    max-width: 90vw;
  }

  .hero.shrink .intro {
    opacity: 1;
    transform: translateY(0);
  }

  .intro p {
    font-size: clamp(12px, 1.3vw, 14px);
    color: #555;
    line-height: 1.8;
    margin: 10px 0;
    word-break: keep-all;
  }

  .intro strong {
    color: #FF7272;
    font-weight: 600;
  }

  .intro {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 40px;
  }

  .btn {
    display: inline-block;
    position: relative;
    font-size: 18px;
    font-weight: 600;
    color: #666;
    text-decoration: none;
    padding: 16px 70px;
    background: transparent;
    cursor: pointer;
    transition: all 0.3s ease;
    margin-top: 40px;
  }

  .btn:hover {
    color: #FF7272;
    letter-spacing: 1px;
    transform: translateY(-3px);
  }

  .btn:active {
    color: #ff4c4c;
    letter-spacing: 3px;
    transform: translateY(1px);
  }

  .btn-2::before,
  .btn-2::after {
    content: "";
    position: absolute;
    left: 50%;
    transform: translateX(-50%);
    width: 0;
    height: 2px;
    background-color: rgba(255, 114, 114, 0.4);
    transition: all 0.35s ease;
  }

  .btn-2::before { top: 0; }
  .btn-2::after { bottom: 0; }

  .btn-2:hover::before,
  .btn-2:hover::after {
    width: 80%;
    background-color: #FF7272;
  }

  .btn-2:active::before,
  .btn-2:active::after {
    background-color: #ff4c4c;
  }

  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(30px); }
    to { opacity: 1; transform: translateY(0); }
  }
</style>
</head>

<body>
  <div class="floating-bg" id="floating-bg"></div>

  <main>
    <section class="hero" id="hero">
      <small>—— 자격증의 바이블 ——</small>
      <h1>THE CERTIFICATION<br>BIBLE</h1>

      <div class="intro">
        <p>혼자 공부하다 지치셨나요?<br>
        비슷한 목표를 가진 사람들과<br>
        함께 배우고, 질문하고, 성장해보세요.</p>
        <p><strong>자격증 준비의 모든 순간,</strong> Certification Bible이 함께합니다.</p>
        
        <a href="${pageContext.request.contextPath}/roomlist.room" class="btn btn-2">공부하러가자 🏃🏻‍♀️</a>
      </div>
    </section>
  </main>

  <script>
    window.addEventListener('load', () => {
      setTimeout(() => {
        document.getElementById('hero').classList.add('shrink');
      }, 2000);
    });

    const bg = document.getElementById('floating-bg');
    const images = [
      "${pageContext.request.contextPath}/images/main_study1.png",
      "${pageContext.request.contextPath}/images/main_study2.png",
      "${pageContext.request.contextPath}/images/main_study3.png",
      "${pageContext.request.contextPath}/images/main_study4.png",
      "${pageContext.request.contextPath}/images/main_study5.png"
    ];

    const placedPositions = [];
    const imgSize = 300;
    const padding = 100;
    const width = window.innerWidth;
    const height = window.innerHeight;

    function isFarEnough(x, y) {
      for (const pos of placedPositions) {
        const dx = x - pos.x;
        const dy = y - pos.y;
        const dist = Math.sqrt(dx * dx + dy * dy);
        if (dist < imgSize + padding) return false;
      }
      return true;
    }

    // 각 이미지 하나씩 무조건 배치
    images.forEach(src => {
      let x, y, tries = 0;
      do {
        x = Math.random() * (width - imgSize);
        y = Math.random() * (height - imgSize);
        tries++;
      } while (!isFarEnough(x, y) && tries < 100);

      placedPositions.push({ x, y });

      const img = document.createElement("img");
      img.src = src;
      img.className = "floating-img";
      img.style.left = x + "px";
      img.style.top = y + "px";

      // 랜덤한 animation-duration (속도 다르게)
      img.style.animationDuration = (15 + Math.random() * 5) + "s";

      // 애니메이션 시작 지점도 다르게
      img.style.animationDelay = (Math.random() * 10) + "s";

      bg.appendChild(img);
    });
  </script>
</body>
</html>
