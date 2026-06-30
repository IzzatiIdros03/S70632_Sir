<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ms">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Akaun Baru - MMS</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- TEMA MASJID (EMERALD GREEN) --- */
        :root {
            --primary-color: #047857; /* Hijau Emerald Gelap */
            --primary-hover: #065f46; /* Hijau lebih gelap untuk hover */
            --bg-color: #ecfdf5;      /* Latar belakang hijau sangat cair */
            --text-dark: #1f2937;
            --text-grey: #6b7280;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-color);
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        /* --- KOTAK CARD --- */
        .auth-card {
            background-color: white;
            width: 100%;
            max-width: 400px;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
            text-align: center;
            border: 1px solid #d1fae5;
        }

        /* --- LOGO SEBIJIK MACAM LOGIN (SOLID GREEN) --- */
        .logo-circle {
            width: 80px;
            height: 80px;
            background-color: var(--primary-color); /* Background HIJAU */
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px auto;
            box-shadow: 0 4px 6px -1px rgba(4, 120, 87, 0.3); /* Shadow hijau lembut */
        }

        .logo-icon {
            font-size: 2.2rem;
            color: white; /* Ikon PUTIH */
        }

        .auth-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 5px;
        }

        .auth-subtitle {
            font-size: 0.9rem;
            color: var(--text-grey);
            margin-bottom: 25px;
        }

        /* --- BORANG --- */
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
            text-align: left;
        }

        label {
            font-size: 0.85rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: -5px;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 0.95rem;
            box-sizing: border-box;
            transition: all 0.2s;
            font-family: inherit;
        }

        input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(4, 120, 87, 0.1);
        }

        /* --- BUTANG --- */
        .btn-submit {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 14px;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
            transition: background 0.3s;
            box-shadow: 0 4px 6px -1px rgba(4, 120, 87, 0.4);
        }

        .btn-submit:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
        }

        /* --- FOOTER LINK --- */
        .auth-footer {
            margin-top: 25px;
            font-size: 0.9rem;
            color: var(--text-grey);
        }

        .auth-footer a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .auth-footer a:hover {
            text-decoration: underline;
        }

        /* --- ALERT ERROR --- */
        .alert {
            background-color: #fee2e2;
            color: #991b1b;
            padding: 12px;
            border-radius: 8px;
            font-size: 0.9rem;
            margin-bottom: 20px;
            border: 1px solid #fecaca;
            display: flex;
            align-items: center;
            gap: 10px;
            justify-content: center;
        }
    </style>
</head>
<body>

    <div class="auth-card">
        <div class="logo-circle">
            <i class="fa-solid fa-mosque logo-icon"></i>
        </div>

        <div class="auth-title">Daftar Akaun</div>
        <div class="auth-subtitle">Sertai komuniti kariah masjid kami</div>

        <c:if test="${not empty error}">
            <div class="alert">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
            
            <div>
                <label>Nama Penuh</label>
                <input type="text" name="name" required placeholder="Contoh: Ali Bin Abu">
            </div>

            <div>
                <label>Alamat Emel</label>
                <input type="email" name="email" required placeholder="ali@gmail.com">
            </div>

            <div>
                <label>Nombor Telefon</label>
                <input type="text" name="phone" required placeholder="0123456789">
            </div>

            <div>
                <label>Kata Laluan</label>
                <input type="password" name="password" required placeholder="••••••••">
            </div>

            <button type="submit" class="btn-submit">Daftar Sekarang</button>
        </form>

        <div class="auth-footer">
            Sudah ada akaun? 
            <a href="${pageContext.request.contextPath}/login">Log Masuk di sini</a>
        </div>
    </div>

</body>
</html>