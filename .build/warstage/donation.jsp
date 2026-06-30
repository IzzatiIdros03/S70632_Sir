<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <title>E-Sumbangan - MMS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
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

            /* ── NAVBAR (sama dengan module lain) ── */
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
            }
            .hamburger span {
                width: 22px;
                height: 2px;
                background: var(--text-mid);
                border-radius: 2px;
                display: block;
                transition: all 0.3s;
            }
            .mobile-nav {
                display: none;
                flex-direction: column;
                padding: 12px 5% 16px;
                border-top: 1px solid var(--border);
                background: white;
            }
            .mobile-nav a {
                padding: 10px 12px;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 500;
                color: var(--text-mid);
                text-decoration: none;
            }
            .mobile-nav a:hover {
                color: var(--green-main);
                background: var(--green-light);
            }
            .mobile-nav .mobile-logout {
                color: #ef4444;
                margin-top: 8px;
            }
            .mobile-nav.open {
                display: flex;
            }

            /* ── PAGE HEADER (lurus, sama dengan module lain) ── */
            .page-header {
                background: var(--green-gradient);
                padding: 40px 5% 52px;
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
            .ph-content {
                position: relative;
                z-index: 2;
                max-width: 1280px;
                margin: 0 auto;
            }
            .ph-icon {
                width: 48px;
                height: 48px;
                background: rgba(255,255,255,0.15);
                border-radius: 14px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 22px;
                margin-bottom: 10px;
                border: 1px solid rgba(255,255,255,0.2);
            }
            .ph-content h1 {
                font-size: clamp(1.5rem,3vw,2rem);
                font-weight: 800;
                color: white;
                margin-bottom: 6px;
            }
            .ph-content p {
                font-size: 14px;
                color: rgba(255,255,255,0.8);
            }

            /* ── MAIN ── */
            .main {
                max-width: 1280px;
                margin: 32px auto 60px;
                padding: 0 5%;
            }

            /* ── ALERT ── */
            .alert-error {
                background: #fef2f2;
                color: #991b1b;
                padding: 14px 18px;
                border-radius: 12px;
                border: 1px solid #fca5a5;
                margin-bottom: 24px;
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 14px;
            }

            /* ── GRID ── */
            .grid {
                display: grid;
                grid-template-columns: 1.15fr 0.85fr;
                gap: 24px;
                align-items: start;
            }

            /* ── CARD ── */
            .card {
                background: white;
                border-radius: 16px;
                padding: 28px;
                border: 1px solid var(--border);
                box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            }
            .card-head {
                display: flex;
                align-items: center;
                gap: 12px;
                padding-bottom: 18px;
                margin-bottom: 22px;
                border-bottom: 1px solid var(--border);
            }
            .card-icon {
                width: 40px;
                height: 40px;
                border-radius: 11px;
                flex-shrink: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 17px;
            }
            .card-head h2 {
                font-size: 15px;
                font-weight: 700;
                color: var(--text-dark);
            }
            .card-head p {
                font-size: 12px;
                color: var(--text-light);
                margin-top: 2px;
            }

            /* ── FORM ── */
            .form-group {
                margin-bottom: 16px;
            }
            .form-group label {
                display: block;
                font-size: 12.5px;
                font-weight: 600;
                color: var(--text-dark);
                margin-bottom: 6px;
            }
            .form-group label span {
                color: #ef4444;
            }
            .form-control {
                width: 100%;
                padding: 10px 14px;
                border-radius: 10px;
                border: 1.5px solid var(--border);
                font-size: 13.5px;
                font-family: 'Poppins', sans-serif;
                background: #f9fafb;
                color: var(--text-dark);
                transition: all 0.2s;
            }
            .form-control:focus {
                outline: none;
                background: white;
                border-color: var(--green-main);
                box-shadow: 0 0 0 3px rgba(11,138,131,0.1);
            }
            .pills {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
                margin-bottom: 10px;
            }
            .pill {
                padding: 6px 15px;
                border-radius: 50px;
                font-size: 13px;
                font-weight: 600;
                border: 1.5px solid var(--border);
                background: white;
                cursor: pointer;
                color: var(--text-mid);
                transition: all 0.2s;
                user-select: none;
            }
            .pill:hover, .pill.active {
                border-color: var(--green-main);
                background: var(--green-light);
                color: var(--green-main);
            }
            .pay-note {
                display: flex;
                align-items: center;
                gap: 12px;
                background: #f0fdf4;
                border: 1.5px solid #86efac;
                border-radius: 12px;
                padding: 12px 16px;
                margin-bottom: 16px;
            }
            .pay-note-icon {
                width: 36px;
                height: 36px;
                background: #16a34a;
                border-radius: 9px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 15px;
                flex-shrink: 0;
            }
            .pay-note p {
                font-size: 13px;
                font-weight: 700;
                color: #15803d;
                margin: 0;
            }
            .pay-note small {
                font-size: 11.5px;
                color: #166534;
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
                gap: 8px;
                box-shadow: 0 4px 16px rgba(11,138,131,0.3);
                transition: all 0.2s;
            }
            .btn-submit:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 24px rgba(11,138,131,0.4);
            }
            .secure-note {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
                font-size: 11.5px;
                color: var(--text-light);
                margin-top: 10px;
            }

            /* ── TOYYIBPAY CARD ── */
            .toyyib-card {
                background: var(--green-gradient);
                border-radius: 16px;
                padding: 24px;
                color: white;
                position: relative;
                overflow: hidden;
                margin-bottom: 20px;
            }
            .toyyib-card::before {
                content: '';
                position: absolute;
                top: -20px;
                right: -20px;
                width: 100px;
                height: 100px;
                background: rgba(255,255,255,0.07);
                border-radius: 50%;
            }
            .toyyib-card::after {
                content: '';
                position: absolute;
                bottom: -30px;
                left: -10px;
                width: 130px;
                height: 130px;
                background: rgba(255,255,255,0.05);
                border-radius: 50%;
            }
            .toyyib-inner {
                position: relative;
                z-index: 2;
            }
            .toyyib-head {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 14px;
            }
            .toyyib-head-icon {
                width: 44px;
                height: 44px;
                background: rgba(255,255,255,0.18);
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                border: 1px solid rgba(255,255,255,0.2);
            }
            .toyyib-head h3 {
                font-size: 16px;
                font-weight: 700;
            }
            .toyyib-head p {
                font-size: 12px;
                color: rgba(255,255,255,0.7);
                margin: 0;
            }
            .toyyib-desc {
                font-size: 13px;
                color: rgba(255,255,255,0.85);
                line-height: 1.6;
                margin-bottom: 16px;
            }
            .toyyib-feats {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }
            .toyyib-feat {
                display: flex;
                align-items: center;
                gap: 10px;
                background: rgba(255,255,255,0.1);
                border-radius: 9px;
                padding: 8px 12px;
                border: 1px solid rgba(255,255,255,0.12);
            }
            .toyyib-feat i {
                font-size: 13px;
                width: 14px;
                text-align: center;
            }
            .toyyib-feat span {
                font-size: 12.5px;
                font-weight: 500;
            }

            /* ── STEPS CARD ── */
            .steps {
                display: flex;
                flex-direction: column;
            }
            .step {
                display: flex;
                gap: 14px;
                padding-bottom: 18px;
                position: relative;
            }
            .step:not(:last-child)::before {
                content: '';
                position: absolute;
                left: 15px;
                top: 32px;
                width: 2px;
                height: calc(100% - 14px);
                background: #e5e7eb;
            }
            .step-num {
                width: 32px;
                height: 32px;
                border-radius: 50%;
                background: var(--green-gradient);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 13px;
                font-weight: 700;
                flex-shrink: 0;
                z-index: 1;
                box-shadow: 0 2px 8px rgba(11,138,131,0.25);
            }
            .step-body p {
                font-size: 13.5px;
                font-weight: 600;
                color: var(--text-dark);
                margin: 4px 0 2px;
            }
            .step-body small {
                font-size: 12px;
                color: var(--text-light);
                line-height: 1.5;
            }

            /* ── BENEFITS CARD ── */
            .benefits {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            .benefit {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 10px 12px;
                border-radius: 10px;
                background: #f9fafb;
                border: 1px solid var(--border);
                transition: all 0.2s;
            }
            .benefit:hover {
                background: var(--green-light);
                border-color: rgba(11,138,131,0.2);
            }
            .benefit-icon {
                width: 34px;
                height: 34px;
                border-radius: 9px;
                flex-shrink: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
            }
            .benefit p {
                font-size: 13px;
                font-weight: 600;
                color: var(--text-dark);
                margin: 0;
            }
            .benefit small {
                font-size: 11.5px;
                color: var(--text-light);
            }

            @media (max-width: 900px) {
                .grid {
                    grid-template-columns: 1fr;
                }
            }
            @media (max-width: 680px) {
                .nav-links {
                    display: none;
                }
                .nav-right .user-name {
                    display: none;
                }
                .hamburger {
                    display: flex;
                }
            }
        </style>
    </head>
    <body>

        <!-- ── NAVBAR ── -->
        <header class="navbar">
            <div class="nav-inner">
                <a href="${pageContext.request.contextPath}/home" class="nav-brand">
                    <div class="nav-logo"><i class="fa-solid fa-mosque"></i></div>
                    <span>MMS</span>
                </a>
                <nav class="nav-links">
                    <a href="${pageContext.request.contextPath}/home">Utama</a>
                    <a href="${pageContext.request.contextPath}/bookings">Tempahan</a>
                    <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
                    <a href="${pageContext.request.contextPath}/activity">Aktiviti</a>
                    <a href="${pageContext.request.contextPath}/donation" class="active">Sumbangan</a>
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
                        <div class="user-avatar"><%= currentUser.getName() != null && !currentUser.getName().isEmpty() ? currentUser.getName().substring(0, 1).toUpperCase() : "U"%></div>
                        <span class="user-name"><%= currentUser.getName()%></span>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                        <i class="fa-solid fa-power-off"></i> <span>Keluar</span>
                    </a>
                </div>
                <button class="hamburger" id="hamburger"><span></span><span></span><span></span></button>
            </div>
            <div class="mobile-nav" id="mobileNav">
                <a href="${pageContext.request.contextPath}/home">Utama</a>
                <a href="${pageContext.request.contextPath}/bookings">Tempahan</a>
                <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
                <a href="${pageContext.request.contextPath}/activity">Aktiviti</a>
                <a href="${pageContext.request.contextPath}/donation">Sumbangan</a>
                <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
                <a href="${pageContext.request.contextPath}/logout" class="mobile-logout"><i class="fa-solid fa-power-off"></i> Keluar</a>
            </div>
        </header>

        <!-- ── PAGE HEADER (lurus, sama design module lain) ── -->
        <div class="page-header">
            <div class="ph-content">
                <div class="ph-icon"><i class="fa-solid fa-hand-holding-heart"></i></div>
                <h1>E-Sumbangan Masjid</h1>
                <p>Setiap sumbangan anda adalah amal jariah yang berterusan. Bayar dengan mudah melalui ToyyibPay.</p>
            </div>
        </div>

        <!-- ── MAIN ── -->
        <div class="main">

            <c:if test="${not empty payError}">
                <div class="alert-error"><i class="fa-solid fa-circle-exclamation"></i> ${payError}</div>
            </c:if>

            <div class="grid">

                <!-- KIRI: BORANG -->
                <div class="card">
                    <div class="card-head">
                        <div class="card-icon" style="background:#e6f7f6;color:#0b8a83;">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </div>
                        <div>
                            <h2>Borang Sumbangan</h2>
                            <p>Isi maklumat di bawah untuk teruskan ke ToyyibPay</p>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/donation/process" method="post">
                        <div class="form-group">
                            <label>Nama Penuh Penderma <span>*</span></label>
                            <input type="text" name="donorName" class="form-control"
                                   value="<%= currentUser.getName() != null ? currentUser.getName() : ""%>"
                                   placeholder="Nama penuh anda" required>
                        </div>
                        <div class="form-group">
                            <label>Alamat Emel <span>*</span></label>
                            <input type="email" name="donorEmail" class="form-control"
                                   value="<%= currentUser.getEmail() != null ? currentUser.getEmail() : ""%>"
                                   placeholder="emel@contoh.com" required>
                        </div>
                        <div class="form-group">
                            <label>No. Telefon <span>*</span></label>
                            <input type="text" name="donorPhone" class="form-control"
                                   value="<%= currentUser.getPhone() != null ? currentUser.getPhone() : ""%>"
                                   placeholder="Contoh: 0123456789" required>
                        </div>
                        <div class="form-group">
                            <label>Jumlah Sumbangan (RM) <span>*</span></label>
                            <div class="pills">
                                <span class="pill" onclick="setAmount(10, this)">RM 10</span>
                                <span class="pill" onclick="setAmount(20, this)">RM 20</span>
                                <span class="pill" onclick="setAmount(50, this)">RM 50</span>
                                <span class="pill" onclick="setAmount(100, this)">RM 100</span>
                                <span class="pill" onclick="setAmount(200, this)">RM 200</span>
                                <span class="pill" onclick="setAmount(500, this)">RM 500</span>
                            </div>
                            <input type="number" name="amount" id="amountInput" class="form-control"
                                   placeholder="Atau taip jumlah lain (RM)..." min="1" step="0.01" required>
                        </div>

                        <div class="pay-note">
                            <div class="pay-note-icon"><i class="fa-solid fa-lock"></i></div>
                            <div>
                                <p>Pembayaran via ToyyibPay</p>
                                <small>Anda akan diarahkan ke halaman pembayaran selamat ToyyibPay</small>
                            </div>
                        </div>

                        <button type="submit" class="btn-submit">
                            <i class="fa-solid fa-credit-card"></i> Teruskan ke ToyyibPay
                        </button>
                        <div class="secure-note">
                            <i class="fa-solid fa-lock"></i> Transaksi dilindungi enkripsi SSL
                        </div>
                    </form>
                </div>

                <!-- KANAN: INFO -->
                <div>


                    <!-- Cara bayar -->
                    <div class="card" style="margin-bottom:20px;">
                        <div class="card-head">
                            <div class="card-icon" style="background:#eff6ff;color:#2563eb;">
                                <i class="fa-solid fa-list-ol"></i>
                            </div>
                            <div>
                                <h2>Cara Membuat Sumbangan</h2>
                                <p>4 langkah mudah</p>
                            </div>
                        </div>
                        <div class="steps">
                            <div class="step">
                                <div class="step-num">1</div>
                                <div class="step-body"><p>Isi Borang</p><small>Masukkan nama, emel, telefon & jumlah</small></div>
                            </div>
                            <div class="step">
                                <div class="step-num">2</div>
                                <div class="step-body"><p>Klik Teruskan ke ToyyibPay</p><small>Diarahkan ke halaman pembayaran selamat</small></div>
                            </div>
                            <div class="step">
                                <div class="step-num">3</div>
                                <div class="step-body"><p>Pilih Kaedah Pembayaran</p><small>FPX, DuitNow atau kad kredit/debit</small></div>
                            </div>
                            <div class="step">
                                <div class="step-num">4</div>
                                <div class="step-body"><p>Selesai!</p><small>Resit digital dihantar ke emel anda secara automatik</small></div>
                            </div>
                        </div>
                    </div>

                    <!-- Manfaat -->
                    <div class="card">
                        <div class="card-head">
                            <div class="card-icon" style="background:#fff7ed;color:#ea580c;">
                                <i class="fa-solid fa-heart"></i>
                            </div>
                            <div>
                                <h2>Manfaat Sumbangan Anda</h2>
                                <p>Amal jariah yang berterusan</p>
                            </div>
                        </div>
                        <div class="benefits">
                            <div class="benefit">
                                <div class="benefit-icon" style="background:#e6f7f6;color:#0b8a83;"><i class="fa-solid fa-wrench"></i></div>
                                <div><p>Penyelenggaraan Fasiliti</p><small>Kebersihan & kemudahan masjid</small></div>
                            </div>
                            <div class="benefit">
                                <div class="benefit-icon" style="background:#fef3c7;color:#d97706;"><i class="fa-solid fa-book-open"></i></div>
                                <div><p>Program Ilmu & Pengajian</p><small>Kelas fardhu ain, tahfiz, ceramah</small></div>
                            </div>
                            <div class="benefit">
                                <div class="benefit-icon" style="background:#fff1f4;color:#e11d48;"><i class="fa-solid fa-hand-holding-heart"></i></div>
                                <div><p>Bantuan Asnaf & Yatim</p><small>Menyantuni golongan yang memerlukan</small></div>
                            </div>
                            <div class="benefit">
                                <div class="benefit-icon" style="background:#eff6ff;color:#2563eb;"><i class="fa-solid fa-people-group"></i></div>
                                <div><p>Aktiviti Komuniti</p><small>Program kemasyarakatan setempat</small></div>
                            </div>
                            <div class="benefit">
                                <div class="benefit-icon" style="background:#f5f3ff;color:#7c3aed;"><i class="fa-solid fa-mosque"></i></div>
                                <div><p>Pembangunan Masjid</p><small>Pengubahsuaian & peluasan masjid</small></div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <script>
            function setAmount(val, el) {
                document.getElementById('amountInput').value = val;
                document.querySelectorAll('.pill').forEach(p => p.classList.remove('active'));
                el.classList.add('active');
            }
            document.getElementById('amountInput').addEventListener('input', function () {
                document.querySelectorAll('.pill').forEach(p => p.classList.remove('active'));
            });
            document.getElementById('hamburger').addEventListener('click', function () {
                document.getElementById('mobileNav').classList.toggle('open');
            });
        </script>
    </body>
</html>
