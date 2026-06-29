<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% 
    model.User currentUser = (model.User) session.getAttribute("currentUser");
    if (currentUser == null) {
        currentUser = new model.User();
    }
%>
<!DOCTYPE html>
<html lang="ms">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Bayaran Tempahan - MMS</title>
        <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root{
                --green:#0b8a83;
                --green-dark:#056d67;
                --grad:linear-gradient(135deg,#0b8a83,#056d67);
                --green-light:#e6f7f6;
                --text:#1f2937;
                --mid:#4b5563;
                --light:#9ca3af;
                --bg:#f3f4f6;
                --border:#e5e7eb;
                --font:'DM Sans',sans-serif;
            }
            *{
                box-sizing:border-box;
                margin:0;
                padding:0;
            }
            body{
                font-family:var(--font);
                background:var(--bg);
                color:var(--text);
            }
            /* NAVBAR */
            .navbar{
                position:sticky;
                top:0;
                z-index:200;
                background:rgba(255,255,255,0.95);
                backdrop-filter:blur(20px);
                border-bottom:1px solid var(--border);
                box-shadow:0 2px 12px rgba(0,0,0,0.05);
            }
            .nav-inner{
                max-width:1280px;
                margin:0 auto;
                padding:0 5%;
                height:66px;
                display:flex;
                align-items:center;
                gap:24px;
            }
            .nav-brand{
                display:flex;
                align-items:center;
                gap:10px;
                text-decoration:none;
                font-weight:700;
                font-size:18px;
                color:var(--green);
                flex-shrink:0;
            }
            .nav-logo{
                width:36px;
                height:36px;
                background:var(--grad);
                border-radius:10px;
                display:flex;
                align-items:center;
                justify-content:center;
                color:white;
                font-size:15px;
            }
            .nav-links{
                display:flex;
                align-items:center;
                gap:4px;
                flex:1;
            }
            .nav-links a{
                padding:7px 13px;
                border-radius:8px;
                font-size:13px;
                font-weight:500;
                color:var(--mid);
                text-decoration:none;
                transition:all 0.2s;
            }
            .nav-links a:hover{
                color:var(--green);
                background:var(--green-light);
            }
            .btn-out{
                display:flex;
                align-items:center;
                gap:7px;
                padding:8px 14px;
                border-radius:8px;
                font-size:13px;
                font-weight:600;
                color:#ef4444;
                text-decoration:none;
                border:1.5px solid #fee2e2;
                background:#fff5f5;
            }
            /* MAIN */
            .main{
                max-width:480px;
                margin:50px auto;
                padding:0 20px 60px;
            }
            /* ── RECEIPT CARD ── */
            .receipt-card{
                background:white;
                border-radius:20px;
                overflow:hidden;
                box-shadow:0 8px 32px rgba(0,0,0,0.08);
                border:1px solid var(--border);
            }
            .receipt-header{
                background:var(--grad);
                padding:24px 28px;
                text-align:center;
                position:relative;
                overflow:hidden;
            }
            .receipt-header::before{
                content:'';
                position:absolute;
                inset:0;
                background-image:radial-gradient(rgba(255,255,255,0.07) 1px,transparent 1px);
                background-size:20px 20px;
            }
            .receipt-header-icon{
                width:48px;
                height:48px;
                background:rgba(255,255,255,0.15);
                border-radius:14px;
                display:flex;
                align-items:center;
                justify-content:center;
                color:white;
                font-size:20px;
                margin:0 auto 10px;
                position:relative;
                z-index:1;
                border:1.5px solid rgba(255,255,255,0.2);
            }
            .receipt-header h2{
                color:white;
                font-size:18px;
                font-weight:700;
                position:relative;
                z-index:1;
            }
            .receipt-header p{
                color:rgba(255,255,255,0.7);
                font-size:12px;
                margin-top:4px;
                position:relative;
                z-index:1;
            }
            .receipt-body{
                padding:24px 28px;
            }
            .receipt-row{
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:10px 0;
                border-bottom:1px solid #f3f4f6;
                font-size:14px;
            }
            .receipt-row:last-of-type{
                border-bottom:none;
            }
            .receipt-label{
                color:var(--mid);
            }
            .receipt-value{
                font-weight:600;
                color:var(--text);
            }
            .total-row{
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:16px 28px;
                background:#f9fefE;
                border-top:2px dashed var(--border);
            }
            .total-label{
                font-weight:700;
                font-size:15px;
            }
            .total-value{
                font-weight:800;
                font-size:22px;
                color:var(--green);
            }
            .receipt-actions{
                padding:20px 28px;
                display:flex;
                flex-direction:column;
                gap:10px;
                border-top:1px solid var(--border);
            }
            .btn-pay{
                display:flex;
                align-items:center;
                justify-content:center;
                gap:8px;
                padding:14px;
                background:var(--grad);
                color:white;
                border:none;
                border-radius:12px;
                font-size:15px;
                font-weight:600;
                cursor:pointer;
                font-family:var(--font);
                text-decoration:none;
                transition:all 0.2s;
                width:100%;
            }
            .btn-pay:hover{
                transform:translateY(-1px);
                box-shadow:0 6px 20px rgba(11,138,131,0.3);
            }
            .btn-back{
                display:flex;
                align-items:center;
                justify-content:center;
                gap:8px;
                padding:12px;
                background:white;
                color:var(--mid);
                border:1.5px solid var(--border);
                border-radius:12px;
                font-size:14px;
                font-weight:500;
                cursor:pointer;
                font-family:var(--font);
                text-decoration:none;
                transition:all 0.2s;
            }
            .btn-back:hover{
                border-color:var(--green);
                color:var(--green);
            }
            .secure-note{
                display:flex;
                align-items:center;
                justify-content:center;
                gap:6px;
                font-size:12px;
                color:var(--light);
                padding:0 28px 20px;
            }
            /* ── STATUS CARDS ── */
            .status-card{
                background:white;
                border-radius:20px;
                padding:40px 32px;
                border:1px solid var(--border);
                box-shadow:0 8px 32px rgba(0,0,0,0.08);
                text-align:center;
            }
            .status-icon{
                width:72px;
                height:72px;
                border-radius:50%;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:30px;
                margin:0 auto 20px;
            }
            .icon-success{
                background:#dcfce7;
                color:#15803d;
            }
            .icon-fail{
                background:#fee2e2;
                color:#b91c1c;
            }
            .status-title{
                font-size:22px;
                font-weight:700;
                margin-bottom:8px;
            }
            .status-sub{
                font-size:14px;
                color:var(--mid);
                margin-bottom:28px;
                line-height:1.7;
            }
            .info-box{
                background:var(--bg);
                border-radius:12px;
                padding:16px;
                margin-bottom:22px;
                text-align:left;
            }
            .info-row{
                display:flex;
                justify-content:space-between;
                font-size:13px;
                padding:6px 0;
                border-bottom:1px solid var(--border);
            }
            .info-row:last-child{
                border-bottom:none;
            }
            .info-row span:first-child{
                color:var(--mid);
            }
            .info-row span:last-child{
                font-weight:600;
            }
        </style>
    </head>
    <body>

        <!-- NAVBAR -->
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
                    <a href="${pageContext.request.contextPath}/donation">Sumbangan</a>
                    <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
                </nav>
                <a href="${pageContext.request.contextPath}/logout" class="btn-out">
                    <i class="fa-solid fa-power-off"></i> Keluar
                </a>
            </div>
        </header>

        <div class="main">

            <c:if test="${not empty payError}">
                <div class="status-card" style="margin-bottom:16px;">
                    <div class="status-icon icon-fail"><i class="fa-solid fa-circle-exclamation"></i></div>
                    <div class="status-title" style="color:#b91c1c;">ToyyibPay Tidak Dapat Diproses</div>
                    <div class="status-sub">${payError}</div>
                    <a href="${pageContext.request.contextPath}/bookings" class="btn-back" style="margin-top:10px;">
                        <i class="fa-solid fa-arrow-left"></i> Kembali
                    </a>
                </div>
            </c:if>

            <%-- ══ 1. SELEPAS BALIK DARI TOYYIBPAY (ada paySuccess) ══ --%>
            <c:if test="${paySuccess != null}">
                <c:choose>
                    <c:when test="${paySuccess == true}">
                        <div class="status-card">
                            <div class="status-icon icon-success"><i class="fa-solid fa-circle-check"></i></div>
                            <div class="status-title" style="color:#15803d;">Bayaran Berjaya!</div>
                            <div class="status-sub">
                                Terima kasih! Bayaran anda telah berjaya diproses melalui ToyyibPay.
                            </div>
                            <c:if test="${not empty billCode or not empty refNo}">
                                <div class="info-box">
                                    <c:if test="${not empty refNo}">
                                        <div class="info-row"><span>No. Rujukan</span><span>${refNo}</span></div>
                                    </c:if>
                                    <c:if test="${not empty billCode}">
                                        <div class="info-row"><span>Kod Bil</span><span>${billCode}</span></div>
                                    </c:if>
                                    <div class="info-row"><span>Status</span><span style="color:#15803d;">✓ Dibayar</span></div>
                                </div>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/bookings" class="btn-pay" style="margin-bottom:10px;">
                                <i class="fa-solid fa-calendar-check"></i> Lihat Tempahan Saya
                            </a>
                            <a href="${pageContext.request.contextPath}/home" class="btn-back">
                                <i class="fa-solid fa-house"></i> Kembali ke Utama
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="status-card">
                            <div class="status-icon icon-fail"><i class="fa-solid fa-circle-xmark"></i></div>
                            <div class="status-title" style="color:#b91c1c;">Bayaran Tidak Berjaya</div>
                            <div class="status-sub">
                                Maaf, bayaran anda tidak berjaya diproses.<br>Sila cuba lagi atau hubungi pihak masjid.
                            </div>
                            <a href="${pageContext.request.contextPath}/bookings" class="btn-pay">
                                <i class="fa-solid fa-rotate-left"></i> Cuba Lagi
                            </a>
                            <a href="${pageContext.request.contextPath}/home" class="btn-back" style="margin-top:10px;">
                                <i class="fa-solid fa-house"></i> Kembali ke Utama
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:if>

            <%-- ══ 2. RESIT + BUTANG BAYAR (simMode = ToyyibPay tak dapat dicapai dari localhost) ══ --%>
            <%-- Ini tunjuk resit tempahan dan butang untuk cuba bayar semula --%>
            <c:if test="${simMode == true && paySuccess == null}">
                <c:if test="${not empty booking}">
                    <div class="receipt-card">
                        <div class="receipt-header">
                            <div class="receipt-header-icon"><i class="fa-solid fa-file-invoice"></i></div>
                            <h2>Semak Bayaran</h2>
                            <p>Masjid Management System (MMS)</p>
                        </div>
                        <div class="receipt-body">
                            <div class="receipt-row">
                                <span class="receipt-label">No. Tempahan</span>
                                <span class="receipt-value">#${booking.bookingId}</span>
                            </div>
                            <div class="receipt-row">
                                <span class="receipt-label">Fasiliti</span>
                                <span class="receipt-value">${booking.facilityName}</span>
                            </div>
                            <div class="receipt-row">
                                <span class="receipt-label">Tempoh</span>
                                <span class="receipt-value">${booking.totalDays} hari</span>
                            </div>
                            <div class="receipt-row">
                                <span class="receipt-label">Sesi</span>
                                <span class="receipt-value">
                                    <c:choose>
                                        <c:when test="${booking.sessionType=='HALF_DAY'}">Separuh Hari</c:when>
                                        <c:otherwise>Sehari Penuh</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="total-row">
                            <span class="total-label">JUMLAH BAYARAN</span>
                            <span class="total-value">RM <fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="receipt-actions">
                            <%-- Butang ini akan cuba redirect ke ToyyibPay sekali lagi --%>
                            <form action="${pageContext.request.contextPath}/payment/createBill" method="post">
                                <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                <button type="submit" class="btn-pay">
                                    <i class="fa-solid fa-paper-plane"></i> Bayar dengan ToyyibPay
                                </button>
                            </form>
                            <a href="${pageContext.request.contextPath}/bookings" class="btn-back">
                                <i class="fa-solid fa-arrow-left"></i> Kembali
                            </a>
                        </div>
                        <div class="secure-note">
                            <i class="fa-solid fa-lock"></i>
                            Bayaran diproses secara selamat melalui ToyyibPay
                        </div>
                    </div>
                </c:if>
            </c:if>

            <%-- ══ 3. DEFAULT (tiada parameter — akses terus ke /payment/return) ══ --%>
            <c:if test="${paySuccess == null && simMode != true && empty booking}">
                <div class="status-card">
                    <div class="status-icon" style="background:#e0e7ff;color:#4338ca;">
                        <i class="fa-solid fa-clock"></i>
                    </div>
                    <div class="status-title">Menunggu Maklumat Bayaran</div>
                    <div class="status-sub">Sila kembali ke halaman tempahan dan klik "Bayar Sekarang".</div>
                    <a href="${pageContext.request.contextPath}/bookings" class="btn-back">
                        <i class="fa-solid fa-arrow-left"></i> Kembali ke Tempahan
                    </a>
                </div>
            </c:if>

        </div>
    </body>
</html>
