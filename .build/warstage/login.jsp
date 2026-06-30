<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Log Masuk - MMS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/auth.css">
</head>
<body>
<div class="auth-card">
    
    <div class="auth-icon">
        <i class="fa-solid fa-mosque"></i>
    </div>

    <div class="auth-title">Log Masuk</div>
    <div class="auth-subtitle">Sistem Pengurusan Masjid</div>

    <c:if test="${not empty error}">
        <div class="alert">
            <i class="fa-solid fa-circle-exclamation"></i> ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <label>Email</label>
        <input type="email" name="email" placeholder="contoh@email.com" required>

        <label>Kata Laluan</label>
        <input type="password" name="password" required>

        <button type="submit" class="auth-button">
            Log Masuk <i class="fa-solid fa-arrow-right" style="margin-left:5px;"></i>
        </button>
    </form>

    <div class="auth-extra">
        Belum ada akaun?
        <a href="${pageContext.request.contextPath}/register">Daftar sekarang</a>
    </div>
</div>
</body>
</html>