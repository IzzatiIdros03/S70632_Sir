<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="currentUser" scope="session" type="model.User" />
<!DOCTYPE html>
<html lang="ms">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kemaskini Tempahan - MMS</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        
        <link rel="stylesheet" href="${pageContext.request.contextPath}/home.css">

        <style>
            body {
                /* Menggunakan tema latar belakang yang bersih, atau boleh diganti dengan gambar masjid */
                background-color: #f4f7f6; 
                font-family: 'Poppins', sans-serif;
                margin: 0;
            }
            
            .edit-container {
                max-width: 800px;
                margin: 60px auto;
                padding: 0 20px;
            }
            
            .form-card {
                background: white;
                padding: 40px;
                border-radius: 24px;
                box-shadow: 0 10px 30px rgba(5, 78, 60, 0.05);
                border: 1px solid #e2e8f0;
            }
            
            .form-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
                border-bottom: 1px solid #f1f5f9;
                padding-bottom: 20px;
            }
            
            .form-header h2 {
                margin: 0;
                color: #054e3c; /* Ditukar ke warna hijau tema login */
                font-size: 24px;
                font-weight: 600;
            }
            
            .form-group {
                margin-bottom: 20px;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #334155;
                font-size: 14px;
            }
            
            .form-group input, .form-group select {
                width: 100%;
                padding: 12px 16px;
                border: 1.5px solid #cbd5e1;
                border-radius: 12px;
                font-family: 'Poppins', sans-serif;
                font-size: 14px;
                color: #334155;
                box-sizing: border-box;
                transition: border-color 0.2s;
            }

            .form-group input:focus, .form-group select:focus {
                outline: none;
                border-color: #054e3c;
            }
            
            .readonly-field {
                background-color: #f1f5f9;
                color: #64748b;
                cursor: not-allowed;
            }
            
            .grid-2 {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            @media (max-width: 600px) {
                .grid-2 {
                    grid-template-columns: 1fr;
                    gap: 0;
                }
            }
            
            /* BUTANG BARU: Mengikut warna butang halaman Log Masuk */
            .btn-save {
                width: 100%;
                background-color: #054e3c; /* Hijau Emerald Tua */
                color: white;
                padding: 15px;
                border: none;
                border-radius: 12px;
                font-family: 'Poppins', sans-serif;
                font-weight: 600;
                font-size: 16px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                transition: background-color 0.2s, transform 0.2s;
                box-shadow: 0 4px 12px rgba(5, 78, 60, 0.2);
            }
            
            .btn-save:hover {
                background-color: #043e30;
                transform: translateY(-2px);
            }
            
            .alert-error {
                background-color: #fef2f2;
                color: #dc2626;
                padding: 15px;
                border-radius: 12px;
                margin-bottom: 20px;
                border: 1px solid #fee2e2;
                font-size: 14px;
            }
        </style>
    </head>
    <body>


        <main class="edit-container">
            <div class="form-card">
                <div class="form-header">
                    <h2>Kemaskini Tempahan (#${booking.bookingId})</h2>
                    <a href="${pageContext.request.contextPath}/bookings" style="text-decoration:none; color:#64748b; font-size: 14px; font-weight: 500;">
                        <i class="fa-solid fa-arrow-left"></i> Kembali
                    </a>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert-error"><i class="fa-solid fa-circle-exclamation"></i> ${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/booking/update" method="post">
                    <input type="hidden" name="bookingId" value="${booking.bookingId}">

                    <div class="form-group">
                        <label>Nama Pemohon</label>
                        <input type="text" value="${currentUser.name}" readonly class="readonly-field">
                    </div>

                    <div class="grid-2">
                        <div class="form-group">
                            <label>Emel</label>
                            <input type="email" name="email" value="${booking.email}" required>
                        </div>
                        <div class="form-group">
                            <label>No. Telefon</label>
                            <input type="tel" name="phone" value="${booking.phone}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Alamat / Tujuan</label>
                        <input type="text" name="address" value="${booking.address}" required>
                    </div>

                    <div class="form-group">
                        <label>Jenis Fasiliti</label>
                        <select name="facilityId" required>
                            <c:forEach var="f" items="${facilities}">
                                <option value="${f.facilityId}" ${booking.facilityId == f.facilityId ? 'selected' : ''}>
                                    ${f.name} (RM ${f.ratePerDay} / hari)
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="grid-2">
                        <div class="form-group">
                            <label>Tarikh Mula</label>
                            <input type="date" name="startDate" value="${booking.startDate}" required>
                        </div>
                        <div class="form-group">
                            <label>Tarikh Tamat</label>
                            <input type="date" name="endDate" value="${booking.endDate}" required>
                        </div>
                    </div>

                    <button type="submit" class="btn-save">
                        <i class="fa-solid fa-floppy-disk"></i> Simpan Perubahan
                    </button>
                </form>
            </div>
        </main>
    </body>
</html>