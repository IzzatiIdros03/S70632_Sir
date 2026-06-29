<%@ page contentType="text/html;charset=UTF-8" %>
<%
    model.User currentUser = (model.User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ms">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Profil AJK - MMS</title>
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
                --gold: #f59e0b;
                --gold-light: #fef3c7;
                --purple: #7c3aed;
                --purple-light: #f3eeff;
                --blue: #2563eb;
                --blue-light: #eff6ff;
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
            }

            /* ===== NAVBAR (sama macam home) ===== */
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
                transition: background 0.2s;
            }
            .mobile-nav a:hover {
                background: var(--green-light);
                color: var(--green-main);
            }
            .mobile-logout {
                color: #ef4444 !important;
                margin-top: 6px;
            }

            /* ===== PAGE HEADER ===== */
            .page-header {
                background: var(--green-gradient);
                padding: 48px 5% 56px;
                text-align: center;
                position: relative;
                overflow: hidden;
            }
            .page-header::before {
                content: '';
                position: absolute;
                inset: 0;
                background-image: radial-gradient(rgba(255,255,255,0.07) 1px, transparent 1px);
                background-size: 24px 24px;
            }
            .page-header-orb {
                position: absolute;
                border-radius: 50%;
                pointer-events: none;
                filter: blur(60px);
            }
            .orb1 {
                width: 300px;
                height: 300px;
                background: rgba(255,255,255,0.08);
                top: -80px;
                right: -60px;
            }
            .orb2 {
                width: 200px;
                height: 200px;
                background: rgba(5,109,103,0.5);
                bottom: -60px;
                left: 5%;
            }
            .page-header-content {
                position: relative;
                z-index: 2;
            }
            .page-header-icon {
                width: 60px;
                height: 60px;
                background: rgba(255,255,255,0.15);
                border-radius: 16px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 26px;
                margin: 0 auto 16px;
                border: 1.5px solid rgba(255,255,255,0.2);
            }
            .page-header h1 {
                font-size: clamp(1.6rem, 3vw, 2.2rem);
                font-weight: 800;
                color: white;
                margin-bottom: 8px;
            }
            .page-header p {
                font-size: 15px;
                color: rgba(255,255,255,0.8);
            }

            /* ===== MAIN CONTENT ===== */
            .profile-main {
                max-width: 1100px;
                margin: -28px auto 60px;
                padding: 0 5%;
                position: relative;
                z-index: 3;
            }

            /* ===== STATS STRIP ===== */
            .stats-strip {
                display: flex;
                gap: 16px;
                flex-wrap: wrap;
                margin-bottom: 32px;
            }
            .stat-card {
                flex: 1;
                min-width: 140px;
                background: white;
                border-radius: 14px;
                padding: 18px 20px;
                border: 1px solid var(--border);
                box-shadow: 0 4px 16px rgba(0,0,0,0.06);
                display: flex;
                align-items: center;
                gap: 14px;
                animation: fadeUp 0.5s ease both;
            }
            .stat-card:nth-child(2) {
                animation-delay: 0.1s;
            }
            .stat-card:nth-child(3) {
                animation-delay: 0.2s;
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
            .stat-icon {
                width: 44px;
                height: 44px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 18px;
                flex-shrink: 0;
            }
            .stat-card b {
                display: block;
                font-size: 22px;
                font-weight: 800;
                color: var(--text-dark);
            }
            .stat-card span {
                font-size: 12px;
                color: var(--text-light);
            }

            /* ===== SECTION TITLE ===== */
            .section-title {
                font-size: 17px;
                font-weight: 700;
                color: var(--text-dark);
                margin-bottom: 28px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .section-title::after {
                content: '';
                flex: 1;
                height: 1px;
                background: var(--border);
            }

            /* ===== ORG CHART ===== */
            .org-wrapper {
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 0;
            }

            /* Level 1 - Pengerusi */
            .level-1 {
                display: flex;
                justify-content: center;
                width: 100%;
            }

            /* Connector */
            .v-line {
                width: 2px;
                height: 32px;
                background: linear-gradient(to bottom, var(--green-main), var(--border));
                margin: 0 auto;
            }
            .h-branch {
                display: flex;
                align-items: flex-start;
                justify-content: center;
                width: 100%;
                position: relative;
                margin-bottom: 0;
            }
            .h-branch::before {
                content: '';
                position: absolute;
                top: 0;
                left: 50%;
                right: 50%;
                height: 2px;
                background: var(--border);
                transition: all 0.3s;
            }
            .branch-2::before {
                left: 25%;
                right: 25%;
            }
            .branch-3::before {
                left: 14%;
                right: 14%;
            }

            .branch-col {
                display: flex;
                flex-direction: column;
                align-items: center;
                flex: 1;
                max-width: 280px;
            }
            .branch-col .v-line-top {
                width: 2px;
                height: 32px;
                background: linear-gradient(to bottom, var(--border), var(--border));
            }

            /* Level rows */
            .level-2, .level-3 {
                display: flex;
                justify-content: center;
                gap: 24px;
                width: 100%;
                flex-wrap: wrap;
            }

            /* ===== ORG CARD ===== */
            .org-card {
                background: white;
                border-radius: 18px;
                padding: 24px 20px 20px;
                text-align: center;
                width: 240px;
                border: 1.5px solid var(--border);
                box-shadow: 0 4px 16px rgba(0,0,0,0.06);
                transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                position: relative;
                overflow: hidden;
            }
            .org-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                border-radius: 18px 18px 0 0;
            }
            .org-card:hover {
                transform: translateY(-6px);
                box-shadow: 0 16px 40px rgba(0,0,0,0.12);
            }

            /* Card tiers */
            .card-tier-1::before {
                background: var(--green-gradient);
            }
            .card-tier-1 {
                width: 280px;
                border-color: rgba(11,138,131,0.2);
            }
            .card-tier-1:hover {
                border-color: var(--green-main);
            }

            .card-tier-2::before {
                background: linear-gradient(135deg, var(--gold), #d97706);
            }
            .card-tier-2:hover {
                border-color: var(--gold);
            }

            .card-tier-3::before {
                background: linear-gradient(135deg, var(--blue), #1d4ed8);
            }
            .card-tier-3:hover {
                border-color: var(--blue);
            }

            /* Avatar inisial */
            .org-avatar {
                width: 76px;
                height: 76px;
                border-radius: 50%;
                margin: 0 auto 14px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 30px;
                color: white;
                position: relative;
                z-index: 1;
                box-shadow: 0 6px 20px rgba(0,0,0,0.18);
                border: 3px solid #ffffff;
                outline: 3px solid rgba(0,0,0,0.04);
            }
            .avatar-green {
                background: var(--green-gradient);
            }
            .avatar-gold {
                background: linear-gradient(135deg, #f59e0b, #d97706);
            }
            .avatar-blue {
                background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            }
            .avatar-purple {
                background: linear-gradient(135deg, #8b5cf6, #6d28d9);
            }
            .avatar-teal {
                background: linear-gradient(135deg, #14b8a6, #0f766e);
            }

            /* Badge jawatan */
            .jawatan-badge {
                display: inline-block;
                font-size: 10px;
                font-weight: 700;
                letter-spacing: 0.8px;
                text-transform: uppercase;
                padding: 4px 10px;
                border-radius: 20px;
                margin-bottom: 8px;
            }
            .badge-green {
                background: var(--green-light);
                color: var(--green-dark);
            }
            .badge-gold {
                background: var(--gold-light);
                color: #92400e;
            }
            .badge-blue {
                background: var(--blue-light);
                color: #1e40af;
            }
            .badge-purple {
                background: var(--purple-light);
                color: #5b21b6;
            }

            .org-name {
                font-size: 14px;
                font-weight: 700;
                color: var(--text-dark);
                margin-bottom: 14px;
                line-height: 1.3;
            }

            /* Contact buttons */
            .contact-btns {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }
            .contact-btn {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 8px 12px;
                border-radius: 8px;
                font-size: 12px;
                font-weight: 500;
                text-decoration: none;
                transition: all 0.2s;
                border: 1px solid var(--border);
                color: var(--text-mid);
                background: #f9fafb;
            }
            .contact-btn:hover {
                background: var(--green-light);
                color: var(--green-main);
                border-color: var(--green-main);
            }
            .contact-btn i {
                font-size: 12px;
                width: 14px;
                text-align: center;
            }
            .contact-btn.tel i {
                color: var(--green-main);
            }
            .contact-btn.email i {
                color: var(--gold);
            }

            /* ===== RESPONSIVE ===== */
            @media (max-width: 900px) {
                .level-2, .level-3 {
                    gap: 16px;
                }
                .org-card {
                    width: 200px;
                    padding: 20px 14px 16px;
                }
                .card-tier-1 {
                    width: 220px;
                }
            }
            @media (max-width: 768px) {
                .nav-links, .nav-right {
                    display: none;
                }
                .hamburger {
                    display: flex;
                }
                .branch-2::before, .branch-3::before {
                    display: none;
                }
                .level-2, .level-3 {
                    flex-direction: column;
                    align-items: center;
                }
                .h-branch {
                    flex-direction: column;
                    align-items: center;
                }
                .branch-col .v-line-top {
                    display: block;
                }
                .stats-strip {
                    gap: 10px;
                }
            }
            @media (max-width: 520px) {
                .org-card, .card-tier-1 {
                    width: 100%;
                    max-width: 300px;
                }
            }
        </style>
    </head>
    <body>

        <!-- ===== NAVBAR ===== -->
        <header class="navbar" id="navbar">
            <div class="nav-inner">
                <a href="${pageContext.request.contextPath}/home" class="nav-brand">
                    <div class="nav-logo"><i class="fa-solid fa-mosque"></i></div>
                    <span>MMS</span>
                </a>
                <nav class="nav-links">
                    <a href="${pageContext.request.contextPath}/home">Utama</a>
                    <a href="${pageContext.request.contextPath}/user/bookings">Tempahan</a>
                    <a href="${pageContext.request.contextPath}/profile.jsp" class="active">Profil AJK</a>
                    <a href="${pageContext.request.contextPath}/activity.jsp">Aktiviti</a>
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
                <a href="${pageContext.request.contextPath}/activity.jsp">Aktiviti</a>
                <a href="${pageContext.request.contextPath}/donation.jsp">Sumbangan</a>
                <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
                <a href="${pageContext.request.contextPath}/logout" class="mobile-logout">
                    <i class="fa-solid fa-power-off"></i> Keluar
                </a>
            </div>
        </header>

        <!-- ===== PAGE HEADER ===== -->
        <div class="page-header">
            <div class="page-header-orb orb1"></div>
            <div class="page-header-orb orb2"></div>
            <div class="page-header-content">
                <div class="page-header-icon"><i class="fa-solid fa-sitemap"></i></div>
                <h1>Carta Organisasi Masjid</h1>
                <p>Struktur Jawatankuasa Pengurusan Sesi 2025/2026</p>
            </div>
        </div>

        <!-- ===== MAIN ===== -->
        <main class="profile-main">

            <!-- Stats strip -->
            <div class="stats-strip">
                <div class="stat-card">
                    <div class="stat-icon" style="background:#e6f7f6; color:#0b8a83;"><i class="fa-solid fa-users"></i></div>
                    <div><b>6</b><span>Jumlah AJK</span></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background:#fef3c7; color:#d97706;"><i class="fa-solid fa-layer-group"></i></div>
                    <div><b>3</b><span>Peringkat Hierarki</span></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background:#eff6ff; color:#2563eb;"><i class="fa-solid fa-calendar-check"></i></div>
                    <div><b>2025/2026</b><span>Sesi Semasa</span></div>
                </div>
            </div>

            <!-- Org Chart -->
            <div class="section-title"><i class="fa-solid fa-sitemap" style="color:var(--green-main)"></i> Struktur Carta Organisasi</div>

            <div class="org-wrapper">

                <!-- LEVEL 1: Pengerusi -->
                <div class="level-1">
                    <div class="org-card card-tier-1">
                        <div class="org-avatar avatar-green"><i class="fa-solid fa-user-tie"></i></div>
                        <div class="jawatan-badge badge-green">Pengerusi Masjid</div>
                        <div class="org-name">Tuan Haji Ahmad Bin Ali</div>
                        <div class="contact-btns">
                        </div>
                    </div>
                </div>

                <!-- Connector -->
                <div class="v-line"></div>

                <!-- H-branch untuk level 2 -->
                <div class="h-branch branch-2" style="max-width:560px;">
                    <div class="branch-col">
                        <div class="v-line-top" style="width:2px;height:32px;background:var(--border);"></div>
                        <!-- LEVEL 2: Setiausaha -->
                        <div class="org-card card-tier-2">
                            <div class="org-avatar avatar-gold"><i class="fa-solid fa-user-large"></i></div>
                            <div class="jawatan-badge badge-gold">Setiausaha</div>
                            <div class="org-name">Pn. Nurul Aisyah Bt. Hassan</div>

                        </div>
                    </div>
                    <div class="branch-col">
                        <div class="v-line-top" style="width:2px;height:32px;background:var(--border);"></div>
                        <!-- LEVEL 2: Bendahari -->
                        <div class="org-card card-tier-2">
                            <div class="org-avatar avatar-gold"><i class="fa-solid fa-user-tie"></i></div>
                            <div class="jawatan-badge badge-gold">Bendahari</div>
                            <div class="org-name">Encik Rahman Bin Salleh</div>

                        </div>
                    </div>
                </div>

                <!-- Connector -->
                <div class="v-line"></div>

                <!-- H-branch untuk level 3 -->
                <div class="h-branch branch-3" style="max-width:800px;">
                    <div class="branch-col">
                        <div class="v-line-top" style="width:2px;height:32px;background:var(--border);"></div>
                        <div class="org-card card-tier-3">
                            <div class="org-avatar avatar-blue"><i class="fa-solid fa-mosque"></i></div>
                            <div class="jawatan-badge badge-blue">Imam Utama</div>
                            <div class="org-name">Ustaz Hakim Bin Musa</div>

                        </div>
                    </div>
                    <div class="branch-col">
                        <div class="v-line-top" style="width:2px;height:32px;background:var(--border);"></div>
                        <div class="org-card card-tier-3">
                            <div class="org-avatar avatar-purple"><i class="fa-solid fa-microphone"></i></div>
                            <div class="jawatan-badge badge-purple">Bilal</div>
                            <div class="org-name">En. Abu Bakar</div>

                        </div>
                    </div>
                    <div class="branch-col">
                        <div class="v-line-top" style="width:2px;height:32px;background:var(--border);"></div>
                        <div class="org-card card-tier-3">
                            <div class="org-avatar avatar-teal"><i class="fa-solid fa-key"></i></div>
                            <div class="jawatan-badge badge-blue">Siak</div>
                            <div class="org-name">En. Othman</div>

                        </div>
                    </div>
                </div>

            </div>

            <!-- AJK Hubungi -->
            <div class="v-line"></div>
            <div style="width:100%;display:flex;justify-content:center;margin-bottom:0;">
                <div class="branch-col" style="max-width:300px;">
                    <div class="v-line-top" style="width:2px;height:32px;background:var(--border);"></div>
                    <div class="org-card" style="width:280px;border-color:rgba(229,57,53,0.2);">
                        <div class="org-avatar" style="background:linear-gradient(135deg,#e53935,#b71c1c);border:3px solid #ffffff;outline:3px solid rgba(0,0,0,0.04);"><i class="fa-solid fa-headset"></i></div>
                        <div class="jawatan-badge" style="background:#fce4ec;color:#880e4f;">AJK Hubungi</div>
                        <div class="org-name">Pn. Aminah Bt. Hassan</div>
                        <div class="contact-btns">
                            <a href="tel:0123456999" class="contact-btn tel">
                                <i class="fa-solid fa-phone"></i> 012-3456999
                            </a>
                            <a href="mailto:hubungi@masjid.test" class="contact-btn email">
                                <i class="fa-solid fa-envelope"></i> hubungi@masjid.test
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Legend -->
            <div style="margin-top:40px; padding:20px 24px; background:white; border-radius:14px; border:1px solid var(--border); display:flex; gap:24px; flex-wrap:wrap; align-items:center;">
                <span style="font-size:13px; font-weight:600; color:var(--text-mid);">Legenda:</span>
                <div style="display:flex;align-items:center;gap:8px;font-size:13px;color:var(--text-mid);">
                    <div style="width:14px;height:14px;border-radius:4px;background:var(--green-gradient);"></div> Pengerusi
                </div>
                <div style="display:flex;align-items:center;gap:8px;font-size:13px;color:var(--text-mid);">
                    <div style="width:14px;height:14px;border-radius:4px;background:linear-gradient(135deg,#f59e0b,#d97706);"></div> Exco Utama
                </div>
                <div style="display:flex;align-items:center;gap:8px;font-size:13px;color:var(--text-mid);">
                    <div style="width:14px;height:14px;border-radius:4px;background:linear-gradient(135deg,#3b82f6,#1d4ed8);"></div> AJK
                </div>
                <div style="margin-left:auto;font-size:12px;color:var(--text-light);">
                    <i class="fa-solid fa-circle-info"></i> Klik nombor telefon untuk membuat panggilan terus
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

            // Animate cards on scroll
            const observer = new IntersectionObserver(entries => {
                entries.forEach((e, i) => {
                    if (e.isIntersecting) {
                        setTimeout(() => {
                            e.target.style.opacity = '1';
                            e.target.style.transform = 'translateY(0)';
                        }, i * 100);
                    }
                });
            }, {threshold: 0.1});
            document.querySelectorAll('.org-card').forEach(c => {
                c.style.opacity = '0';
                c.style.transform = 'translateY(20px)';
                c.style.transition = 'all 0.4s ease';
                observer.observe(c);
            });
        </script>

    </body>
</html>
