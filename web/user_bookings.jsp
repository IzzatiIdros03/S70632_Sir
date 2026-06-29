<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="currentUser" scope="session" type="model.User" />
<!DOCTYPE html>
<html lang="ms">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tempahan Saya - MMS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap"
              rel="stylesheet">
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

            .navbar {
                position: sticky;
                top: 0;
                z-index: 200;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-bottom: 1px solid var(--border);
                box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
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
                box-shadow: 0 4px 12px rgba(11, 138, 131, 0.3);
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

            .nav-links a:hover,
            .nav-links a.active {
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
                transform: rotate(45deg) translate(5px, 5px);
            }

            .hamburger.open span:nth-child(2) {
                opacity: 0;
            }

            .hamburger.open span:nth-child(3) {
                transform: rotate(-45deg) translate(5px, -5px);
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
                padding: 40px 5% 52px;
                position: relative;
                overflow: hidden;
            }

            .page-header::before {
                content: '';
                position: absolute;
                inset: 0;
                background-image: radial-gradient(rgba(255, 255, 255, 0.07) 1px, transparent 1px);
                background-size: 24px 24px;
            }

            .ph-content {
                position: relative;
                z-index: 2;
                max-width: 1280px;
                margin: 0 auto;
                display: flex;
                align-items: center;
                justify-content: space-between;
                flex-wrap: wrap;
                gap: 16px;
            }

            .ph-icon {
                width: 48px;
                height: 48px;
                background: rgba(255, 255, 255, 0.15);
                border-radius: 14px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 22px;
                margin-bottom: 8px;
                border: 1.5px solid rgba(255, 255, 255, 0.2);
            }

            .ph-content h1 {
                font-size: clamp(1.4rem, 2.5vw, 2rem);
                font-weight: 800;
                color: white;
                margin-bottom: 4px;
            }

            .ph-content p {
                font-size: 14px;
                color: rgba(255, 255, 255, 0.8);
            }

            .btn-new {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 11px 22px;
                background: white;
                color: var(--green-main);
                font-size: 14px;
                font-weight: 700;
                border-radius: 10px;
                text-decoration: none;
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
                transition: all 0.2s;
                white-space: nowrap;
            }

            .btn-new:hover {
                transform: translateY(-2px);
            }

            /* MAIN */
            .main-content {
                max-width: 1280px;
                margin: -24px auto 60px;
                padding: 0 5%;
                position: relative;
                z-index: 3;
            }

            /* ALERTS */
            .alert {
                padding: 14px 18px;
                border-radius: 12px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 14px;
                font-weight: 500;
            }

            .alert-success {
                background: #d1fae5;
                color: #065f46;
                border: 1px solid #6ee7b7;
            }

            .alert-warning {
                background: #fef3c7;
                color: #92400e;
                border: 1px solid #fde68a;
            }

            .alert-error {
                background: #fee2e2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            .alert-canceled {
                background: #f3f4f6;
                color: #6b7280;
                border: 1px solid #e5e7eb;
            }

            /* STATS */
            .stats-strip {
                display: flex;
                gap: 14px;
                flex-wrap: wrap;
                margin-bottom: 20px;
            }

            .stat-card {
                flex: 1;
                min-width: 130px;
                background: white;
                border-radius: 14px;
                padding: 16px 18px;
                border: 1px solid var(--border);
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .stat-icon {
                width: 40px;
                height: 40px;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 16px;
                flex-shrink: 0;
            }

            .stat-card b {
                display: block;
                font-size: 20px;
                font-weight: 800;
                color: var(--text-dark);
            }

            .stat-card span {
                font-size: 11px;
                color: var(--text-light);
            }

            /* TABLE */
            .table-card {
                background: white;
                border-radius: 20px;
                border: 1px solid var(--border);
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
                overflow: hidden;
            }

            .table-top {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 20px 24px;
                border-bottom: 1px solid var(--border);
            }

            .table-title {
                font-size: 15px;
                font-weight: 700;
                color: var(--text-dark);
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .table-title i {
                color: var(--green-main);
            }

            .table-wrap {
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                font-size: 13px;
            }

            thead tr {
                background: #f9fafb;
                border-bottom: 2px solid var(--border);
            }

            th {
                padding: 12px 14px;
                text-align: left;
                font-size: 11px;
                font-weight: 700;
                color: var(--text-light);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                white-space: nowrap;
            }

            td {
                padding: 13px 14px;
                border-bottom: 1px solid #f3f4f6;
                vertical-align: middle;
            }

            tr:last-child td {
                border-bottom: none;
            }

            tr:hover td {
                background: #fafafa;
            }

            .badge {
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
            }

            .badge-pending {
                background: #fef3c7;
                color: #92400e;
            }

            .badge-approved {
                background: #d1fae5;
                color: #065f46;
            }

            .badge-rejected {
                background: #fee2e2;
                color: #991b1b;
            }

            .badge-canceled {
                background: #f3f4f6;
                color: #6b7280;
            }

            .action-wrap {
                display: flex;
                gap: 6px;
                align-items: center;
                flex-wrap: wrap;
            }

            .btn-a {
                display: flex;
                align-items: center;
                gap: 5px;
                padding: 6px 11px;
                border-radius: 7px;
                font-size: 12px;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.2s;
                border: none;
                cursor: pointer;
                font-family: 'Poppins', sans-serif;
                white-space: nowrap;
            }

            .btn-pay {
                background: #d1fae5;
                color: #065f46;
            }

            .btn-pay:hover {
                background: #a7f3d0;
            }

            .btn-edit {
                background: #dbeafe;
                color: #1e40af;
            }

            .btn-edit:hover {
                background: #bfdbfe;
            }

            .btn-cancel {
                background: #fee2e2;
                color: #991b1b;
            }

            .btn-cancel:hover {
                background: #fecaca;
            }

            .empty-cell {
                text-align: center;
                padding: 60px;
                color: var(--text-light);
            }

            .empty-cell i {
                font-size: 40px;
                display: block;
                margin-bottom: 12px;
                opacity: 0.4;
            }

            @media(max-width:768px) {

                .nav-links,
                .nav-right {
                    display: none;
                }

                .hamburger {
                    display: flex;
                }

                .ph-content {
                    flex-direction: column;
                }

                .stats-strip {
                    gap: 10px;
                }
            }
        </style>
    </head>

    <body>
        <header class="navbar" id="navbar">
            <div class="nav-inner">
                <a href="${pageContext.request.contextPath}/home" class="nav-brand">
                    <div class="nav-logo"><i class="fa-solid fa-mosque"></i></div><span>MMS</span>
                </a>
                <nav class="nav-links">
                    <a href="${pageContext.request.contextPath}/home">Utama</a>
                    <a href="${pageContext.request.contextPath}/bookings" class="active">Tempahan</a>
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
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout"><i
                            class="fa-solid fa-power-off"></i> <span>Keluar</span></a>
                </div>
                <button class="hamburger" id="hamburger"><span></span><span></span><span></span></button>
            </div>
            <div class="mobile-nav" id="mobileNav">
                <a href="${pageContext.request.contextPath}/home">Utama</a>
                <a href="${pageContext.request.contextPath}/bookings">Tempahan</a>
                <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
                <a href="${pageContext.request.contextPath}/activity">Aktiviti</a>
                <a href="${pageContext.request.contextPath}/donation.jsp">Sumbangan</a>
                <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
                <a href="${pageContext.request.contextPath}/logout" class="mobile-logout"><i
                        class="fa-solid fa-power-off"></i> Keluar</a>
            </div>
        </header>

        <div class="page-header">
            <div class="ph-content">
                <div>
                    <div class="ph-icon"><i class="fa-solid fa-calendar-check"></i></div>
                    <h1>Tempahan Saya</h1>
                    <p>Semak dan urus rekod tempahan fasiliti masjid anda</p>
                </div>
                <a href="${pageContext.request.contextPath}/booking/new" class="btn-new">
                    <i class="fa-solid fa-plus"></i> Tempahan Baharu
                </a>
            </div>
        </div>

        <main class="main-content">

            <!-- Alerts -->
            <c:if test="${param.msg == 'success'}">
                <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Permohonan tempahan
                    berjaya dihantar! Sila tunggu kelulusan daripada Koordinator.</div>
                </c:if>
                <c:if test="${param.msg == 'updated'}">
                <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Tempahan berjaya
                    dikemaskini!</div>
                </c:if>
                <c:if test="${param.msg == 'canceled'}">
                <div class="alert alert-canceled"><i class="fa-solid fa-circle-xmark"></i> Tempahan telah
                    dibatalkan.</div>
                </c:if>
                <c:if test="${not empty sessionScope.payError}">
                <div class="alert alert-error"><i class="fa-solid fa-circle-exclamation"></i>
                    ${sessionScope.payError}</div>
                    <c:remove var="payError" scope="session" />
                </c:if>

            <!-- Stats -->
            <div class="stats-strip">
                <div class="stat-card">
                    <div class="stat-icon" style="background:#fef3c7;color:#d97706;"><i
                            class="fa-solid fa-clock"></i></div>
                    <div><b id="cntPending">0</b><span>Menunggu Kelulusan</span></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background:#d1fae5;color:#065f46;"><i
                            class="fa-solid fa-circle-check"></i></div>
                    <div><b id="cntApproved">0</b><span>Diluluskan</span></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background:#e6f7f6;color:#0b8a83;"><i
                            class="fa-solid fa-list"></i></div>
                    <div><b id="cntTotal">0</b><span>Jumlah Rekod</span></div>
                </div>
            </div>

            <!-- Flow info -->
            <div
                style="background:white;border-radius:14px;padding:16px 20px;border:1px solid var(--border);margin-bottom:20px;display:flex;gap:0;align-items:center;flex-wrap:wrap;">
                <div
                    style="display:flex;align-items:center;gap:8px;font-size:12px;font-weight:600;color:var(--text-mid);flex:1;min-width:150px;">
                    <div
                        style="width:28px;height:28px;border-radius:50%;background:#fef3c7;color:#d97706;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:800;">
                        1</div>
                    Hantar Permohonan
                </div>
                <i class="fa-solid fa-arrow-right" style="color:var(--border);margin:0 8px;"></i>
                <div
                    style="display:flex;align-items:center;gap:8px;font-size:12px;font-weight:600;color:var(--text-mid);flex:1;min-width:150px;">
                    <div
                        style="width:28px;height:28px;border-radius:50%;background:#dbeafe;color:#1e40af;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:800;">
                        2</div>
                    Admin Semak & Lulus
                </div>
                <i class="fa-solid fa-arrow-right" style="color:var(--border);margin:0 8px;"></i>
                <div
                    style="display:flex;align-items:center;gap:8px;font-size:12px;font-weight:600;color:var(--text-mid);flex:1;min-width:150px;">
                    <div
                        style="width:28px;height:28px;border-radius:50%;background:#d1fae5;color:#065f46;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:800;">
                        3</div>
                    Buat Bayaran
                </div>
            </div>

            <!-- Table -->
            <div class="table-card">
                <div class="table-top">
                    <div class="table-title"><i class="fa-solid fa-table-list"></i> Senarai Tempahan</div>
                </div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Fasiliti</th>
                                <th>Tujuan</th>
                                <th>Sesi</th>
                                <th>Tarikh Mula</th>
                                <th>Tarikh Tamat</th>
                                <th>Hari</th>
                                <th>Jumlah (RM)</th>
                                <th>Status</th>
                                <th style="text-align:center;">Tindakan</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${bookings}" varStatus="s">
                                <tr class="row-booking" data-status="${b.status}">
                                    <td style="color:var(--text-light);font-size:12px;">${s.count}</td>
                                    <td style="font-weight:600;color:#0369a1;">${b.facilityName}</td>
                                    <td style="color:var(--text-mid);">${b.bookingType}</td>
                                    <td style="color:var(--text-mid);font-size:12px;">
                                        <c:choose>
                                            <c:when test="${b.sessionType == 'HALF_DAY'}">½ Hari</c:when>
                                            <c:otherwise>Sehari Penuh</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${b.startDate}</td>
                                    <td>${b.endDate}</td>
                                    <td style="text-align:center;">${b.totalDays}</td>
                                    <td style="font-weight:700;color:var(--green-main);">RM ${b.totalAmount}</td>
                                    <td>
                                        <span class="badge 
                                              <c:choose>
                                                  <c:when test="${b.status == 'APPROVED'}">badge-approved</c:when>
                                                  <c:when test="${b.status == 'REJECTED'}">badge-rejected</c:when>
                                                  <c:when test="${b.status == 'CANCELED'}">badge-canceled</c:when>
                                                  <c:when test="${b.status == 'PAID'}">badge-approved</c:when>
                                              </c:choose>">
                                            ${b.status}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-wrap">
                                            <c:choose>
                                                <%-- APPROVED: boleh bayar sahaja --%>
                                                <c:when test="${b.status == 'APPROVED'}">
                                                    <form
                                                        action="${pageContext.request.contextPath}/payment/createBill"
                                                        method="post" style="display:inline;">
                                                        <input type="hidden" name="bookingId"
                                                               value="${b.bookingId}">
                                                        <button type="submit" class="btn-a btn-pay">
                                                            <i class="fa-solid fa-credit-card"></i> Bayar
                                                            Sekarang
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <%-- PENDING: boleh edit dan batal --%>
                                                <c:when test="${b.status == 'PENDING'}">
                                                    <a href="${pageContext.request.contextPath}/booking/edit?id=${b.bookingId}"
                                                       class="btn-a btn-edit">
                                                        <i class="fa-solid fa-pen"></i> Edit
                                                    </a>
                                                    <form
                                                        action="${pageContext.request.contextPath}/booking/cancel"
                                                        method="post" style="display:inline;"
                                                        onsubmit="return confirm('Pasti mahu batalkan tempahan ini?')">
                                                        <input type="hidden" name="bookingId"
                                                               value="${b.bookingId}">
                                                        <button type="submit" class="btn-a btn-cancel"><i
                                                                class="fa-solid fa-xmark"></i>
                                                            Batal</button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <span
                                                        style="color:var(--text-light);font-size:12px;">—</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty bookings}">
                                <tr>
                                    <td colspan="10" class="empty-cell">
                                        <i class="fa-solid fa-calendar-xmark"></i>
                                        Tiada rekod tempahan lagi.<br>
                                        <a href="${pageContext.request.contextPath}/booking/new"
                                           style="color:var(--green-main);font-weight:600;display:inline-block;margin-top:8px;">Buat
                                            Tempahan Sekarang →</a>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
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

            // Count stats
            const rows = document.querySelectorAll('.row-booking');
            let pending = 0, approved = 0;
            rows.forEach(r => {
                const s = r.getAttribute('data-status');
                if (s === 'PENDING')
                    pending++;
                if (s === 'APPROVED')
                    approved++;
            });
            document.getElementById('cntPending').textContent = pending;
            document.getElementById('cntApproved').textContent = approved;
            document.getElementById('cntTotal').textContent = rows.length;
        </script>
    </body>

</html>