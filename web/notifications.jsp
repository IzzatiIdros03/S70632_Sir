<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="currentUser" scope="session" type="model.User" />
<!DOCTYPE html>
<html lang="ms">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifikasi - MMS</title>
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
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); color: var(--text-dark); }
        .navbar { position: sticky; top: 0; z-index: 200; background: rgba(255,255,255,0.95); backdrop-filter: blur(20px); border-bottom: 1px solid var(--border); box-shadow: 0 2px 12px rgba(0,0,0,0.05); }
        .nav-inner { display: flex; align-items: center; gap: 20px; padding: 0 24px; height: 64px; max-width: 1200px; margin: 0 auto; }
        .nav-brand { display: flex; align-items: center; gap: 10px; text-decoration: none; font-weight: 800; font-size: 18px; color: var(--green-main); }
        .nav-logo { width: 36px; height: 36px; background: var(--green-gradient); border-radius: 10px; display: flex; align-items: center; justify-content: center; color: white; font-size: 16px; }
        .nav-links { display: flex; gap: 4px; flex: 1; }
        .nav-links a { text-decoration: none; color: var(--text-mid); font-size: 14px; font-weight: 500; padding: 6px 14px; border-radius: 8px; transition: all .2s; }
        .nav-links a:hover, .nav-links a.active { background: var(--green-light); color: var(--green-main); }
        .nav-right { display: flex; align-items: center; gap: 12px; }
        .nav-user { display: flex; align-items: center; gap: 8px; }
        .user-avatar { width: 34px; height: 34px; background: var(--green-gradient); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 14px; }
        .user-name { font-size: 13px; font-weight: 600; color: var(--text-dark); }
        .btn-logout { display: flex; align-items: center; gap: 6px; background: #fef2f2; color: #dc2626; border: none; padding: 7px 14px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; text-decoration: none; }
        .notif-bell { position: relative; display: flex; align-items: center; }
        .notif-bell a { color: var(--text-mid); font-size: 18px; padding: 6px 10px; border-radius: 8px; text-decoration: none; display: flex; align-items: center; }
        .notif-bell a:hover { background: var(--green-light); color: var(--green-main); }
        .notif-badge { position: absolute; top: 2px; right: 4px; background: #ef4444; color: white; border-radius: 50%; width: 16px; height: 16px; font-size: 9px; font-weight: 700; display: flex; align-items: center; justify-content: center; }
        .page-header { background: var(--green-gradient); padding: 32px 24px 28px; color: white; }
        .ph-inner { max-width: 1200px; margin: 0 auto; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px; }
        .ph-icon { width: 50px; height: 50px; background: rgba(255,255,255,0.15); border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 22px; margin-bottom: 8px; }
        .page-header h1 { font-size: 22px; font-weight: 800; margin-bottom: 4px; }
        .page-header p { font-size: 13px; opacity: 0.85; }
        .btn-markread { background: rgba(255,255,255,0.2); color: white; border: 1.5px solid rgba(255,255,255,0.4); padding: 9px 18px; border-radius: 10px; font-size: 13px; font-weight: 600; cursor: pointer; text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .btn-markread:hover { background: rgba(255,255,255,0.3); }
        .main-content { max-width: 800px; margin: 0 auto; padding: 28px 20px; }
        .notif-list { display: flex; flex-direction: column; gap: 12px; }
        .notif-item { background: white; border-radius: 14px; padding: 18px 20px; border: 1px solid var(--border); display: flex; gap: 16px; align-items: flex-start; transition: box-shadow .2s; }
        .notif-item:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.07); }
        .notif-item.unread { border-left: 4px solid var(--green-main); background: #f0fffe; }
        .notif-item.approved { border-left: 4px solid #16a34a; }
        .notif-item.rejected { border-left: 4px solid #dc2626; background: #fff5f5; }
        .notif-icon { width: 42px; height: 42px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 18px; flex-shrink: 0; }
        .icon-approved { background: #d1fae5; color: #16a34a; }
        .icon-rejected { background: #fee2e2; color: #dc2626; }
        .icon-default { background: var(--green-light); color: var(--green-main); }
        .notif-body { flex: 1; }
        .notif-body p { font-size: 14px; color: var(--text-dark); line-height: 1.6; margin-bottom: 6px; }
        .notif-time { font-size: 11px; color: var(--text-light); }
        .notif-dot { width: 8px; height: 8px; background: var(--green-main); border-radius: 50%; flex-shrink: 0; margin-top: 6px; }
        .empty-state { text-align: center; padding: 60px 20px; color: var(--text-light); }
        .empty-state i { font-size: 48px; margin-bottom: 16px; opacity: .4; }
        .empty-state p { font-size: 15px; }
    </style>
</head>
<body>

<header class="navbar">
    <div class="nav-inner">
        <a href="${pageContext.request.contextPath}/home" class="nav-brand">
            <div class="nav-logo"><i class="fa-solid fa-mosque"></i></div><span>MMS</span>
        </a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/home">Utama</a>
            <a href="${pageContext.request.contextPath}/bookings">Tempahan</a>
            <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
            <a href="${pageContext.request.contextPath}/activity">Aktiviti</a>
            <a href="${pageContext.request.contextPath}/donation.jsp">Sumbangan</a>
            <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
        </nav>
        <div class="nav-right">
            <div class="notif-bell">
                <a href="${pageContext.request.contextPath}/notifications" title="Notifikasi" class="active">
                    <i class="fa-solid fa-bell"></i>
                </a>
                <c:if test="${unreadCount > 0}">
                    <span class="notif-badge">${unreadCount}</span>
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
    </div>
</header>

<div class="page-header">
    <div class="ph-inner">
        <div>
            <div class="ph-icon"><i class="fa-solid fa-bell"></i></div>
            <h1>Notifikasi</h1>
            <p>Semak status permohonan tempahan dan aktiviti anda</p>
        </div>
        <c:if test="${unreadCount > 0}">
            <form action="${pageContext.request.contextPath}/notifications/markRead" method="post">
                <button type="submit" class="btn-markread">
                    <i class="fa-solid fa-check-double"></i> Tandakan Semua Dibaca
                </button>
            </form>
        </c:if>
    </div>
</div>

<main class="main-content">
    <c:choose>
        <c:when test="${empty notifications}">
            <div class="empty-state">
                <i class="fa-regular fa-bell-slash"></i>
                <p>Tiada notifikasi pada masa ini.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="notif-list">
                <c:forEach var="n" items="${notifications}">
                    <c:set var="isApproved" value="${n.type == 'BOOKING_APPROVED' || n.type == 'ACTIVITY_APPROVED'}" />
                    <c:set var="isRejected" value="${n.type == 'BOOKING_REJECTED' || n.type == 'ACTIVITY_REJECTED'}" />
                    <div class="notif-item ${!n.read ? 'unread' : ''} ${isApproved ? 'approved' : ''} ${isRejected ? 'rejected' : ''}">
                        <div class="notif-icon ${isApproved ? 'icon-approved' : isRejected ? 'icon-rejected' : 'icon-default'}">
                            <c:choose>
                                <c:when test="${isApproved}"><i class="fa-solid fa-circle-check"></i></c:when>
                                <c:when test="${isRejected}"><i class="fa-solid fa-circle-xmark"></i></c:when>
                                <c:otherwise><i class="fa-solid fa-info-circle"></i></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="notif-body">
                            <p>${n.message}</p>
                            <span class="notif-time">
                                <i class="fa-regular fa-clock"></i>
                                <fmt:formatDate value="${n.createdAt}" pattern="dd MMM yyyy, hh:mm a" />
                            </span>
                        </div>
                        <c:if test="${!n.read}">
                            <div class="notif-dot"></div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

</body>
</html>