<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:useBean id="currentUser" scope="session" type="model.User" />
<!DOCTYPE html>
<html lang="ms">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hubungi Kami - MMS</title>
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
            }
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: 'Poppins', sans-serif;
                background: var(--bg);
                color: var(--text-dark);
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
            .mobile-nav a:hover {
                background: var(--green-light);
                color: var(--green-main);
            }
            .mobile-logout {
                color: #ef4444 !important;
                margin-top: 6px;
            }

            /* PAGE HEADER */
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

            /* MAIN */
            .main-content {
                max-width: 960px;
                margin: -28px auto 60px;
                padding: 0 5%;
                position: relative;
                z-index: 3;
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 24px;
                align-items: start;
            }

            /* FORM CARD */
            .form-card {
                background: white;
                border-radius: 20px;
                padding: 32px 36px;
                border: 1px solid var(--border);
                box-shadow: 0 4px 16px rgba(0,0,0,0.06);
            }
            .form-card-title {
                font-size: 16px;
                font-weight: 700;
                color: var(--text-dark);
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 8px;
                padding-bottom: 14px;
                border-bottom: 1px solid var(--border);
            }
            .form-card-title i {
                color: var(--green-main);
            }
            .form-group {
                margin-bottom: 16px;
            }
            .form-group label {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: var(--text-dark);
                margin-bottom: 6px;
            }
            .form-group input, .form-group textarea {
                width: 100%;
                padding: 11px 14px;
                border-radius: 10px;
                border: 1.5px solid var(--border);
                font-size: 14px;
                font-family: 'Poppins', sans-serif;
                background: #f9fafb;
                color: var(--text-dark);
                transition: all 0.2s;
            }
            .form-group input:focus, .form-group textarea:focus {
                outline: none;
                border-color: var(--green-main);
                background: white;
                box-shadow: 0 0 0 3px rgba(11,138,131,0.1);
            }
            .form-group textarea {
                resize: vertical;
                min-height: 100px;
            }
            .btn-submit {
                width: 100%;
                padding: 13px;
                background: var(--green-gradient);
                color: white;
                border: none;
                border-radius: 12px;
                font-size: 15px;
                font-weight: 700;
                cursor: pointer;
                font-family: 'Poppins', sans-serif;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                box-shadow: 0 4px 16px rgba(11,138,131,0.3);
                transition: all 0.2s;
            }
            .btn-submit:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 24px rgba(11,138,131,0.4);
            }

            /* SUCCESS */
            .alert-success {
                background: #d1fae5;
                color: #065f46;
                padding: 14px 18px;
                border-radius: 10px;
                border: 1px solid #6ee7b7;
                margin-bottom: 16px;
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 14px;
                font-weight: 500;
            }

            /* INFO CARD */
            .info-card {
                background: white;
                border-radius: 20px;
                padding: 24px;
                border: 1px solid var(--border);
                box-shadow: 0 4px 16px rgba(0,0,0,0.06);
            }
            .info-card-title {
                font-size: 14px;
                font-weight: 700;
                color: var(--text-dark);
                margin-bottom: 16px;
                display: flex;
                align-items: center;
                gap: 8px;
                padding-bottom: 12px;
                border-bottom: 1px solid var(--border);
            }
            .info-card-title i {
                color: var(--green-main);
            }
            .info-row {
                display: flex;
                align-items: flex-start;
                gap: 12px;
                margin-bottom: 16px;
            }
            .info-row:last-child {
                margin-bottom: 0;
            }
            .info-icon {
                width: 36px;
                height: 36px;
                border-radius: 10px;
                background: var(--green-light);
                color: var(--green-main);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 15px;
                flex-shrink: 0;
            }
            .info-text p {
                font-size: 13px;
                font-weight: 600;
                color: var(--text-dark);
                margin-bottom: 2px;
            }
            .info-text small {
                font-size: 12px;
                color: var(--text-light);
                line-height: 1.5;
            }

            /* Operation hours */
            .hours-card {
                background: var(--green-light);
                border-radius: 12px;
                padding: 16px;
                margin-top: 16px;
                border: 1px solid rgba(11,138,131,0.15);
            }
            .hours-title {
                font-size: 12px;
                font-weight: 700;
                color: var(--green-dark);
                margin-bottom: 10px;
                display: flex;
                align-items: center;
                gap: 6px;
            }
            .hours-row {
                display: flex;
                justify-content: space-between;
                font-size: 12px;
                color: var(--text-mid);
                padding: 4px 0;
                border-bottom: 1px solid rgba(11,138,131,0.1);
            }
            .hours-row:last-child {
                border-bottom: none;
            }
            .hours-row span {
                font-weight: 600;
                color: var(--green-dark);
            }

            @media (max-width: 768px) {
                .nav-links, .nav-right {
                    display: none;
                }
                .hamburger {
                    display: flex;
                }
                .main-content {
                    grid-template-columns: 1fr;
                }
                .form-card {
                    padding: 24px 20px;
                }
            }
        </style>
    </head>
    <body>

        <!-- NAVBAR -->
        <header class="navbar" id="navbar">
            <div class="nav-inner">
                <a href="${pageContext.request.contextPath}/home" class="nav-brand">
                    <div class="nav-logo"><i class="fa-solid fa-mosque"></i></div>
                    <span>MMS</span>
                </a>
                <nav class="nav-links">
                    <a href="${pageContext.request.contextPath}/home">Utama</a>
                    <a href="${pageContext.request.contextPath}/user/bookings">Tempahan</a>
                    <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
                    <a href="${pageContext.request.contextPath}/activity">Aktiviti</a>
                    <a href="${pageContext.request.contextPath}/donation.jsp">Sumbangan</a>
                    <a href="${pageContext.request.contextPath}/contact.jsp" class="active">Hubungi</a>
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
                <a href="${pageContext.request.contextPath}/logout" class="mobile-logout"><i class="fa-solid fa-power-off"></i> Keluar</a>
            </div>
        </header>

        <!-- PAGE HEADER -->
        <div class="page-header">
            <div class="page-header-orb orb1"></div>
            <div class="page-header-orb orb2"></div>
            <div class="page-header-content">
                <div class="page-header-icon"><i class="fa-solid fa-headset"></i></div>
                <h1>Hubungi Kami</h1>
                <p>Ada pertanyaan atau aduan? Kami sedia membantu anda</p>
            </div>
        </div>

        <!-- MAIN -->
        <main class="main-content">

            <!-- Form -->
            <div class="form-card">
                <div class="form-card-title"><i class="fa-solid fa-paper-plane"></i> Hantar Mesej</div>

                <div id="successMsg" style="display:none;" class="alert-success">
                    <i class="fa-solid fa-circle-check"></i> Mesej anda telah berjaya dihantar! Kami akan menghubungi anda dalam masa 1-2 hari bekerja.
                </div>

                <form id="contactForm" onsubmit="handleSubmit(event)">
                    <div class="form-group">
                        <label>Nama Penuh</label>
                        <input type="text" id="nama" value="${currentUser.name}" placeholder="Masukkan nama anda" required>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" id="email" value="${currentUser.email}" placeholder="contoh@email.com" required>
                    </div>
                    <div class="form-group">
                        <label>Nombor Telefon</label>
                        <input type="text" id="phone" value="${currentUser.phone}" placeholder="01X-XXXXXXX">
                    </div>
                    <div class="form-group">
                        <label>Subjek</label>
                        <input type="text" id="subjek" placeholder="Contoh: Pertanyaan mengenai tempahan" required>
                    </div>
                    <div class="form-group">
                        <label>Aduan / Pertanyaan</label>
                        <textarea id="mesej" rows="5" placeholder="Tulis mesej anda di sini..." required></textarea>
                    </div>
                    <button type="submit" class="btn-submit">
                        <i class="fa-solid fa-paper-plane"></i> Hantar Mesej
                    </button>
                </form>
            </div>

            <!-- Info sidebar -->
            <div>
                <div class="info-card">
                    <div class="info-card-title"><i class="fa-solid fa-circle-info"></i> Maklumat Hubungan</div>

                    <div class="info-row">
                        <div class="info-icon"><i class="fa-solid fa-phone"></i></div>
                        <div class="info-text">
                            <p>Telefon</p>
                            <small>03-1234 5678</small>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-icon"><i class="fa-solid fa-envelope"></i></div>
                        <div class="info-text">
                            <p>Email</p>
                            <small>info@masjid-alaman.my</small>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-icon"><i class="fa-solid fa-location-dot"></i></div>
                        <div class="info-text">
                            <p>Alamat</p>
                            <small>Jalan Masjid, 12345<br>Kuala Lumpur, Malaysia</small>
                        </div>
                    </div>

                    <div class="hours-card">
                        <div class="hours-title"><i class="fa-solid fa-clock"></i> Waktu Operasi</div>
                        <div class="hours-row">Isnin — Jumaat <span>8:00 AM — 5:00 PM</span></div>
                        <div class="hours-row">Sabtu <span>8:00 AM — 1:00 PM</span></div>
                        <div class="hours-row">Ahad <span>Tutup</span></div>
                    </div>
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

            function handleSubmit(e) {
                e.preventDefault();
                // Simulasi hantar - tunjuk success message
                document.getElementById('contactForm').style.display = 'none';
                document.getElementById('successMsg').style.display = 'flex';
                window.scrollTo({top: 0, behavior: 'smooth'});
            }
        </script>
    </body>
</html>
