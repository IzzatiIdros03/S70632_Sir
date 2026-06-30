<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:useBean id="currentUser" scope="session" type="model.User" />
<!DOCTYPE html>
<html lang="ms">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Utama - MMS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --green-main: #0b8a83;
                --green-dark: #056d67;
                --green-gradient: linear-gradient(135deg, #0b8a83 0%, #056d67 100%);
                --green-light: #e6f7f6;
                --text-dark: #1f2937;
                --text-mid: #4b5563;
                --text-light: #9ca3af;
                --bg: #f3f4f6;
                --white: #ffffff;
                --border: #e5e7eb;
                --radius: 16px;
            }
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            html {
                scroll-behavior: smooth;
            }
            body {
                font-family: 'Poppins', sans-serif;
                background: var(--bg);
                color: var(--text-dark);
                -webkit-font-smoothing: antialiased;
                position: relative;
                min-height: 100vh;
            }

            /* --- BACKGROUND IMAGE OVERLAY --- */
            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                /* Gambar masjid yang estetik & tenang */
                background-image: url('https://images.unsplash.com/photo-1746102268391-a17760aff398?auto=format&fit=crop&w=1920&q=80');
                background-size: cover;
                background-position: center;
                background-attachment: fixed;
                filter: blur(4px) brightness(0.85);
                opacity: 0.35; /* Kepekatan background — dinaikkan supaya gambar masjid kelihatan jelas */
                z-index: -1;
            }

            /* NAVBAR */
            .navbar {
                position: sticky;
                top: 0;
                z-index: 200;
                background: rgba(255,255,255,0.95);
                backdrop-filter: blur(20px);
                border-bottom: 1px solid var(--border);
                box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            }
            .nav-inner {
                max-width: 1280px;
                margin: 0 auto;
                padding: 0 5%;
                height: 66px;
                display: flex;
                align-items: center;
                gap: 24px;
            }
            .nav-brand {
                display: flex;
                align-items: center;
                gap: 10px;
                text-decoration: none;
                font-weight: 800;
                font-size: 19px;
                color: var(--green-main);
                flex-shrink: 0;
            }
            .nav-logo {
                width: 36px;
                height: 36px;
                background: var(--green-gradient);
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 16px;
                box-shadow: 0 4px 12px rgba(11,138,131,0.3);
            }
            .nav-links {
                display: flex;
                align-items: center;
                gap: 4px;
                flex: 1;
            }
            .nav-links a {
                padding: 7px 13px;
                border-radius: 8px;
                font-size: 13.5px;
                font-weight: 500;
                color: var(--text-mid);
                text-decoration: none;
                transition: all 0.2s;
            }
            .nav-links a:hover, .nav-links a.active {
                color: var(--green-main);
                background: var(--green-light);
                font-weight: 600;
            }
            .nav-right {
                display: flex;
                align-items: center;
                gap: 12px;
                flex-shrink: 0;
            }
            .nav-user {
                display: flex;
                align-items: center;
                gap: 9px;
            }
            .user-avatar {
                width: 34px;
                height: 34px;
                background: var(--green-gradient);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 13px;
                font-weight: 700;
            }
            .user-name {
                font-size: 13px;
                font-weight: 600;
                color: var(--text-dark);
                max-width: 120px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
            .btn-logout {
                display: flex;
                align-items: center;
                gap: 7px;
                padding: 8px 14px;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 600;
                color: #ef4444;
                text-decoration: none;
                border: 1.5px solid #fee2e2;
                background: #fff5f5;
                transition: all 0.2s;
            }
            .btn-logout:hover {
                background: #fecaca;
            }
            .hamburger {
                display: none;
                flex-direction: column;
                gap: 5px;
                background: none;
                border: none;
                cursor: pointer;
                padding: 4px;
                margin-left: auto;
            }
            .hamburger span {
                display: block;
                width: 22px;
                height: 2px;
                background: var(--text-dark);
                border-radius: 2px;
                transition: all 0.3s;
            }
            .hamburger.open span:nth-child(1) {
                transform: rotate(45deg) translate(5px,5px);
            }
            .hamburger.open span:nth-child(2) {
                opacity: 0;
            }
            .hamburger.open span:nth-child(3) {
                transform: rotate(-45deg) translate(5px,-5px);
            }

            .mobile-nav {
                display: none;
                flex-direction: column;
                padding: 8px 5% 16px;
                border-top: 1px solid var(--border);
                background: white;
                gap: 2px;
            }
            .mobile-nav.open {
                display: flex;
            }
            .mobile-nav a {
                padding: 10px 14px;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 500;
                color: var(--text-mid);
                text-decoration: none;
            }

            /* HERO */
            .hero-section {
                padding: 24px 5% 0;
                max-width: 1280px;
                margin: 0 auto;
            }
            .hero-slider {
                position: relative;
                width: 100%;
                height: 320px;
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 16px 48px rgba(11,138,131,0.18);
            }
            .slide {
                position: absolute;
                inset: 0;
                background-size: cover;
                background-position: center;
                opacity: 0;
                transition: opacity 1.2s ease, transform 1.2s ease;
                transform: scale(1.05);
            }
            .slide.active {
                opacity: 1;
                transform: scale(1);
            }
            .slide-1 {
                background-image: url('https://images.unsplash.com/photo-1466442929976-97f336a657be?auto=format&fit=crop&w=1200&q=80');
            }
            .slide-2 {
                background-image: url('https://images.unsplash.com/photo-1512632578888-169bbbc64f33?auto=format&fit=crop&w=1200&q=80');
            }
            .slide-3 {
                background-image: url('https://images.unsplash.com/photo-1564769625905-50e93615e769?auto=format&fit=crop&w=1200&q=80');
            }

            .hero-overlay {
                position: absolute;
                inset: 0;
                background: linear-gradient(135deg, rgba(11,138,131,0.4) 0%, rgba(0,0,0,0.3) 100%);
                z-index: 2;
            }
            .slider-dots {
                position: absolute;
                bottom: 64px;
                left: 50%;
                transform: translateX(-50%);
                display: flex;
                gap: 7px;
                z-index: 10;
            }
            .dot {
                width: 7px;
                height: 7px;
                border-radius: 50%;
                background: rgba(255,255,255,0.4);
                cursor: pointer;
                transition: all 0.3s;
            }
            .dot.active {
                background: white;
                width: 22px;
                border-radius: 4px;
            }
            .hero-banner {
                position: absolute;
                bottom: 20px;
                left: 20px;
                right: 20px;
                z-index: 10;
                background: rgba(255,255,255,0.96);
                backdrop-filter: blur(8px);
                border-radius: 12px;
                padding: 12px 18px;
                font-size: 13px;
                font-weight: 600;
                color: var(--text-dark);
                border-left: 4px solid #f59e0b;
                display: flex;
                align-items: center;
                gap: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            }
            .banner-icon {
                width: 32px;
                height: 32px;
                background: #fef3c7;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #f59e0b;
                font-size: 14px;
                flex-shrink: 0;
            }

            /* MAIN */
            .main-content {
                max-width: 1280px;
                margin: 0 auto;
                padding: 32px 5% 60px;
                position: relative;
                z-index: 1;
            }
            .content-wrapper {
                display: flex;
                flex-direction: column;
                gap: 28px;
            }

            /* GREETING */
            .greeting-section {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 20px;
                padding: 28px 32px;
                background: rgba(255, 255, 255, 0.85); /* White with slight transparency */
                backdrop-filter: blur(10px);
                border-radius: var(--radius);
                border: 1px solid var(--border);
                box-shadow: 0 1px 3px rgba(0,0,0,0.06);
                animation: fadeUp 0.5s ease both;
            }
            @keyframes fadeUp {
                from {
                    opacity: 0;
                    transform: translateY(16px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .greeting-sub {
                font-size: 13px;
                color: var(--text-light);
                margin-bottom: 6px;
            }
            .greeting-section h1 {
                font-size: clamp(1.3rem, 2.5vw, 1.8rem);
                font-weight: 800;
                color: var(--text-dark);
                line-height: 1.2;
                margin-bottom: 6px;
            }
            .highlight {
                color: var(--green-main);
            }
            .greeting-desc {
                font-size: 14px;
                color: var(--text-mid);
            }
            .date-card {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 14px 20px;
                background: var(--green-light);
                border-radius: 12px;
                white-space: nowrap;
                flex-shrink: 0;
            }
            .date-card i {
                color: var(--green-main);
                font-size: 20px;
            }
            .date-card span {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: var(--text-dark);
            }
            .date-card small {
                display: block;
                font-size: 12px;
                color: var(--text-mid);
                margin-top: 2px;
            }

            /* STATS */
            .stats-bar {
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
            }
            .stat-pill {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 12px 18px;
                background: rgba(255, 255, 255, 0.9);
                border-radius: 50px;
                border: 1px solid var(--border);
                font-size: 13px;
                color: var(--text-mid);
                box-shadow: 0 1px 3px rgba(0,0,0,0.06);
                transition: all 0.2s;
            }
            .stat-pill:hover {
                border-color: var(--green-main);
                color: var(--green-main);
            }
            .stat-pill i {
                color: var(--green-main);
                font-size: 14px;
            }
            .stat-pill b {
                color: var(--text-dark);
            }

            /* SECTION HEADER */
            .section-header {
                display: flex;
                align-items: baseline;
                justify-content: space-between;
            }
            .section-header h2 {
                font-size: 18px;
                font-weight: 700;
                color: var(--text-dark);
            }
            .section-header p {
                font-size: 13px;
                color: var(--text-light);
            }

            /* CARDS */
            .card-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
            }
            .feature-card {
                position: relative;
                display: flex;
                flex-direction: column;
                background: rgba(255, 255, 255, 0.95);
                border-radius: 18px;
                border: 1.5px solid var(--border);
                padding: 28px 24px 22px;
                text-decoration: none;
                color: inherit;
                overflow: hidden;
                transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                opacity: 0;
                transform: translateY(20px);
                box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            }
            .feature-card.visible {
                opacity: 1;
                transform: translateY(0);
            }
            .feature-card:hover {
                transform: translateY(-6px) scale(1.01);
                box-shadow: 0 20px 40px rgba(0,0,0,0.10);
                border-color: var(--card-color);
            }
            .card-bg-icon {
                position: absolute;
                top: -10px;
                right: -10px;
                font-size: 90px;
                color: var(--card-color);
                opacity: 0.05;
                pointer-events: none;
                transition: opacity 0.3s, transform 0.3s;
            }
            .feature-card:hover .card-bg-icon {
                opacity: 0.09;
                transform: rotate(-10deg) scale(1.1);
            }
            .card-icon-wrap {
                width: 52px;
                height: 52px;
                border-radius: 14px;
                background: var(--card-light);
                color: var(--card-color);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 22px;
                margin-bottom: 18px;
                transition: all 0.3s;
                position: relative;
                z-index: 1;
            }
            .feature-card:hover .card-icon-wrap {
                background: var(--card-color);
                color: white;
                box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            }
            .card-body h3 {
                font-size: 16px;
                font-weight: 700;
                color: var(--text-dark);
                margin-bottom: 8px;
            }
            .card-body p {
                font-size: 13px;
                color: var(--text-mid);
                line-height: 1.6;
            }
            .card-footer {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-top: 20px;
                padding-top: 16px;
                border-top: 1px solid var(--border);
                font-size: 13px;
                font-weight: 600;
                color: var(--card-color);
                position: relative;
                z-index: 1;
            }
            .feature-card:hover .card-footer i {
                transform: translateX(5px);
            }

            /* INFO STRIP */
            .info-strip {
                display: flex;
                gap: 20px;
                justify-content: center;
                flex-wrap: wrap;
                padding: 16px;
                background: rgba(255, 255, 255, 0.8);
                border-radius: 12px;
                border: 1px solid var(--border);
            }
            .info-item {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 12.5px;
                color: var(--text-light);
            }
            .info-item i {
                color: var(--green-main);
                font-size: 13px;
            }

            /* RESPONSIVE */
            @media (max-width: 1100px) {
                .card-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }
            @media (max-width: 768px) {
                .nav-links, .nav-right {
                    display: none;
                }
                .hamburger {
                    display: flex;
                }
                .hero-slider {
                    height: 220px;
                }
                .greeting-section {
                    flex-direction: column;
                    align-items: flex-start;
                    padding: 20px;
                }
            }
            @media (max-width: 520px) {
                .card-grid {
                    grid-template-columns: 1fr;
                }
                .main-content {
                    padding: 20px 4% 40px;
                }
            }
        </style>
    </head>
    <body>

        <header class="navbar" id="navbar">
            <div class="nav-inner">
                <a href="${pageContext.request.contextPath}/home" class="nav-brand">
                    <div class="nav-logo"><i class="fa-solid fa-mosque"></i></div>
                    <span>MMS</span>
                </a>
                <nav class="nav-links">
                    <a href="${pageContext.request.contextPath}/home" class="active">Utama</a>
                    <a href="${pageContext.request.contextPath}/user/bookings">Tempahan</a>
                    <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
                    <a href="${pageContext.request.contextPath}/activity">Aktiviti</a>
                    <a href="${pageContext.request.contextPath}/donation.jsp">Sumbangan</a>
                    <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
                </nav>
                <div class="nav-right">
                    <div style="position:relative;display:flex;align-items:center;">
                        <a href="${pageContext.request.contextPath}/notifications"
                           style="color:var(--text-mid);font-size:18px;padding:6px 10px;border-radius:8px;text-decoration:none;display:flex;align-items:center;"
                           title="Notifikasi">
                            <i class="fa-solid fa-bell"></i>
                        </a>
                        <c:if test="${unreadNotifCount > 0}">
                            <span style="position:absolute;top:2px;right:4px;background:#ef4444;color:white;border-radius:50%;width:16px;height:16px;font-size:9px;font-weight:700;display:flex;align-items:center;justify-content:center;">${unreadNotifCount}</span>
                        </c:if>
                    </div>
                    <div class="nav-user">
                        <div class="user-avatar">${currentUser.name.substring(0,1).toUpperCase()}</div>
                        <span class="user-name">${currentUser.name}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                        <i class="fa-solid fa-power-off"></i> <span>Keluar</span>
                    </a>
                </div>
                <button class="hamburger" id="hamburger"><span></span><span></span><span></span></button>
            </div>
            <div class="mobile-nav" id="mobileNav">
                <a href="${pageContext.request.contextPath}/home">Utama</a>
                <a href="${pageContext.request.contextPath}/user/bookings">Tempahan</a>
                <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
                <a href="${pageContext.request.contextPath}/activity">Aktiviti</a>
                <a href="${pageContext.request.contextPath}/donation.jsp">Sumbangan</a>
                <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
                <a href="${pageContext.request.contextPath}/logout" class="mobile-logout">
                    <i class="fa-solid fa-power-off"></i> Keluar
                </a>
            </div>
        </header>

        <section class="hero-section">
            <div class="hero-slider">
                <div class="slide slide-1 active"></div>
                <div class="slide slide-2"></div>
                <div class="slide slide-3"></div>
                <div class="hero-overlay"></div>
                <div class="slider-dots">
                    <span class="dot active" data-index="0"></span>
                    <span class="dot" data-index="1"></span>
                    <span class="dot" data-index="2"></span>
                </div>
                <div class="hero-banner">
                    <div class="banner-icon"><i class="fa-solid fa-bullhorn"></i></div>
                    <span>MAKLUMAN: Mesyuarat Agung Tahunan akan diadakan pada 15 Julai 2025</span>
                </div>
            </div>
        </section>

        <main class="main-content">
            <div class="content-wrapper">

                <div class="greeting-section">
                    <div class="greeting-text">
                        <p class="greeting-sub">Assalamualaikum Warahmatullahi Wabarakatuh 🌿</p>
                        <h1>Selamat datang, <span class="highlight">${currentUser.name}</span></h1>
                        <p class="greeting-desc">Sistem Pengurusan Masjid Berpusat — semua dalam satu platform.</p>
                    </div>
                    <div class="date-card">
                        <i class="fa-solid fa-calendar-days"></i>
                        <div>
                            <span id="currentDate">--</span>
                            <small id="currentTime">--:--</small>
                        </div>
                    </div>
                </div>

                <div class="stats-bar">
                    <div class="stat-pill"><i class="fa-solid fa-calendar-check"></i><span><b>3</b> Tempahan Aktif</span></div>
                    <div class="stat-pill"><a href="${pageContext.request.contextPath}/notifications" style="text-decoration:none;color:inherit;display:flex;align-items:center;gap:6px;"><i class="fa-solid fa-bell"></i><span><b>${unreadNotifCount > 0 ? unreadNotifCount : 0}</b> Notifikasi Baru</span></a></div>
                    <div class="stat-pill"><i class="fa-solid fa-star"></i><span>Ahli <b>Komuniti</b></span></div>
                </div>

                <div class="section-header">
                    <h2>Akses Pantas</h2>
                    <p>Pilih modul yang anda perlukan</p>
                </div>

                <div class="card-grid">
                    <a href="${pageContext.request.contextPath}/user/bookings" class="feature-card" style="--card-color:#0b8a83;--card-light:#e6f7f6;">
                        <div class="card-bg-icon"><i class="fa-solid fa-calendar-check"></i></div>
                        <div class="card-icon-wrap"><i class="fa-solid fa-calendar-check"></i></div>
                        <div class="card-body">
                            <h3>Tempahan Fasiliti</h3>
                            <p>Urus tempahan dewan, bilik mesyuarat & peralatan masjid.</p>
                        </div>
                        <div class="card-footer"><span>Buat Tempahan</span><i class="fa-solid fa-arrow-right"></i></div>
                    </a>
                    <a href="${pageContext.request.contextPath}/profile.jsp" class="feature-card" style="--card-color:#7c3aed;--card-light:#f3eeff;">
                        <div class="card-bg-icon"><i class="fa-solid fa-user-tie"></i></div>
                        <div class="card-icon-wrap"><i class="fa-solid fa-user-tie"></i></div>
                        <div class="card-body">
                            <h3>Profil AJK Masjid</h3>
                            <p>Kemaskini maklumat peribadi dan jawatan dalam AJK.</p>
                        </div>
                        <div class="card-footer"><span>Lihat Profil</span><i class="fa-solid fa-arrow-right"></i></div>
                    </a>
                    <a href="${pageContext.request.contextPath}/activity" class="feature-card" style="--card-color:#d97706;--card-light:#fffbeb;">
                        <div class="card-bg-icon"><i class="fa-solid fa-mosque"></i></div>
                        <div class="card-icon-wrap"><i class="fa-solid fa-mosque"></i></div>
                        <div class="card-body">
                            <h3>Aktiviti Masjid</h3>
                            <p>Jadual kuliah, ceramah & program komuniti terkini.</p>
                        </div>
                        <div class="card-footer"><span>Lihat Aktiviti</span><i class="fa-solid fa-arrow-right"></i></div>
                    </a>
                    <a href="${pageContext.request.contextPath}/donation.jsp" class="feature-card" style="--card-color:#e11d48;--card-light:#fff1f4;">
                        <div class="card-bg-icon"><i class="fa-solid fa-hand-holding-heart"></i></div>
                        <div class="card-icon-wrap"><i class="fa-solid fa-hand-holding-heart"></i></div>
                        <div class="card-body">
                            <h3>E-Sumbangan</h3>
                            <p>Saluran infaq, wakaf & derma tabung masjid secara digital.</p>
                        </div>
                        <div class="card-footer"><span>Buat Sumbangan</span><i class="fa-solid fa-arrow-right"></i></div>
                    </a>
                </div>

                <div class="info-strip">
                    <div class="info-item"><i class="fa-solid fa-shield-halved"></i><span>Data anda selamat & dilindungi</span></div>
                    <div class="info-item"><i class="fa-solid fa-headset"></i><span>Bantuan: 03-1234 5678</span></div>
                    <div class="info-item"><i class="fa-solid fa-circle-check"></i><span>Sistem Aktif & Dikemaskini</span></div>
                </div>

            </div>
        </main>

        <script>
            window.addEventListener('scroll', () => {
                document.getElementById('navbar').classList.toggle('scrolled', window.scrollY > 10);
            });
            document.getElementById('hamburger').addEventListener('click', function () {
                this.classList.toggle('open');
                document.getElementById('mobileNav').classList.toggle('open');
            });
            let current = 0;
            const slides = document.querySelectorAll('.slide');
            const dots = document.querySelectorAll('.dot');
            function goToSlide(n) {
                slides[current].classList.remove('active');
                dots[current].classList.remove('active');
                current = n;
                slides[current].classList.add('active');
                dots[current].classList.add('active');
            }
            setInterval(() => goToSlide((current + 1) % slides.length), 5000);
            dots.forEach(d => d.addEventListener('click', () => goToSlide(+d.dataset.index)));
            function updateDateTime() {
                const now = new Date();
                const days = ['Ahad', 'Isnin', 'Selasa', 'Rabu', 'Khamis', 'Jumaat', 'Sabtu'];
                const months = ['Jan', 'Feb', 'Mac', 'Apr', 'Mei', 'Jun', 'Jul', 'Ogos', 'Sep', 'Okt', 'Nov', 'Dis'];
                document.getElementById('currentDate').textContent =
                        days[now.getDay()] + ', ' + now.getDate() + ' ' + months[now.getMonth()] + ' ' + now.getFullYear();
                document.getElementById('currentTime').textContent =
                        now.toLocaleTimeString('ms-MY', {hour: '2-digit', minute: '2-digit'});
            }
            updateDateTime();
            setInterval(updateDateTime, 1000);
            const observer = new IntersectionObserver(entries => {
                entries.forEach((e, i) => {
                    if (e.isIntersecting)
                        setTimeout(() => e.target.classList.add('visible'), i * 80);
                });
            }, {threshold: 0.1});
            document.querySelectorAll('.feature-card').forEach(c => observer.observe(c));
        </script>
    </body>
</html>