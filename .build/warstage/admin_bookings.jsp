<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ms">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Pengurusan Tempahan - MMS</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/admin_bookings.css">
        <style>
            /* FILTER BAR */
            .filter-bar{
                display:flex;
                gap:8px;
                padding:14px 18px;
                background:#f8fafc;
                border-bottom:1px solid #e5e7eb;
                flex-wrap:wrap;
                align-items:center;
            }
            .search-box{
                position:relative;
                flex:1;
                min-width:220px;
            }
            .search-box .search-ic{
                position:absolute;
                left:11px;
                top:50%;
                transform:translateY(-50%);
                font-size:12px;
                color:#9ca3af;
                font-style:normal;
                pointer-events:none;
            }
            .search-box input{
                width:100%;
                padding:8px 12px 8px 32px;
                border-radius:8px;
                border:1px solid #d1d5db;
                background:#fff;
                font-family:inherit;
                font-size:13px;
                color:#1f2937;
                transition:all .2s;
            }
            .search-box input:focus{
                outline:none;
                border-color:#1a3a6b;
                box-shadow:0 0 0 3px rgba(26,58,107,.08);
            }
            .filter-select{
                padding:8px 12px;
                border-radius:8px;
                border:1px solid #d1d5db;
                background:#fff;
                font-family:inherit;
                font-size:12.5px;
                font-weight:500;
                color:#1f2937;
                cursor:pointer;
                min-width:120px;
                transition:all .2s;
            }
            .filter-select:hover{
                border-color:#1a3a6b;
            }
            .filter-select:focus{
                outline:none;
                border-color:#1a3a6b;
            }
            .filter-count{
                font-size:11.5px;
                color:#6b7280;
                background:#fff;
                padding:5px 11px;
                border-radius:20px;
                border:1px solid #e5e7eb;
                font-weight:600;
                white-space:nowrap;
            }
            .empty-filter{
                padding:40px 20px;
                text-align:center;
                color:#9ca3af;
                font-size:13px;
                background:#f9fafb;
            }
            .empty-filter i{
                font-style:normal;
                font-size:24px;
                display:block;
                margin-bottom:8px;
            }
        </style>
    </head>
    <body>

        <header class="top-bar">
            <div class="logo">
                <div class="logo-circle"><i class="fa-solid fa-mosque"></i></div>
                <span>MMS ADMIN</span>
            </div>
            <nav>
                <span class="admin-badge" style="background:red; color:white; padding:2px 5px; border-radius:4px; font-size:10px;">ADMIN</span>
                <a href="${pageContext.request.contextPath}/admin/bookings" class="active">Tempahan</a>
                <a href="${pageContext.request.contextPath}/admin/report">Laporan</a> 
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout"><i class="fa-solid fa-power-off"></i> Keluar</a>
            </nav>
        </header>

        <main class="admin-container">
            <div class="admin-header">
                <div class="header-text">
                    <h1>Dashboard Koordinator</h1>
                    <p>Senarai permohonan tempahan fasiliti masjid.</p>
                </div>
            </div>

            <div class="table-card">
                <!-- FILTER BAR -->
                <div class="filter-bar">
                    <div class="search-box">
                        <i class="search-ic">🔍</i>
                        <input type="text" id="bookSearch" placeholder="Cari nama, ID, fasiliti..." onkeyup="filterBookings()">
                    </div>
                    <select id="bookStatus" class="filter-select" onchange="filterBookings()">
                        <option value="all">Semua Status</option>
                        <option value="PENDING">Menunggu</option>
                        <option value="APPROVED">Diluluskan</option>
                        <option value="PAID">Dibayar</option>
                        <option value="REJECTED">Ditolak</option>
                        <option value="CANCELED">Dibatalkan</option>
                    </select>
                    <select id="bookYear" class="filter-select" onchange="filterBookings()">
                        <option value="all">Semua Tahun</option>
                    </select>
                    <select id="bookMonth" class="filter-select" onchange="filterBookings()">
                        <option value="all">Semua Bulan</option>
                        <option value="01">Januari</option><option value="02">Februari</option>
                        <option value="03">Mac</option><option value="04">April</option>
                        <option value="05">Mei</option><option value="06">Jun</option>
                        <option value="07">Julai</option><option value="08">Ogos</option>
                        <option value="09">September</option><option value="10">Oktober</option>
                        <option value="11">November</option><option value="12">Disember</option>
                    </select>
                    <span class="filter-count"><span id="bookCount">0</span> rekod</span>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th width="5%">ID</th>
                                <th width="20%">Pemohon</th>
                                <th width="20%">Fasiliti (Tempat)</th>
                                <th width="20%">Tarikh</th>
                                <th width="10%">Jumlah</th>
                                <th width="10%">Status</th>
                                <th width="15%" style="text-align: center;">Tindakan</th>
                            </tr>
                        </thead>
                        <tbody id="bookTbody">
                            <c:forEach var="b" items="${bookings}">
                                <tr data-search="${b.bookingId} ${b.userName} ${b.facilityName}" data-date="${b.startDate}" data-status="${b.status}">
                                    <td><span style="font-weight:bold;">#${b.bookingId}</span></td>

                                    <td>
                                        <div style="font-weight:600; color:#111827;">${b.userName != null ? b.userName : 'Unknown'}</div>
                                        <div style="font-size:12px; color:#6b7280;">ID User: #${b.userId}</div>
                                    </td>

                                    <td style="font-weight:600; color:#0369a1;">${b.facilityName}</td>

                                    <td>
                                        <div>Mula: ${b.startDate}</div>
                                        <div>Tamat: ${b.endDate}</div>
                                    </td>

                                    <td style="font-weight: 500;">RM ${b.totalAmount}</td>

                                    <td>
                                        <span style="padding: 3px 8px; border-radius: 10px; font-size: 11px; font-weight: bold;
                                              background: ${b.status == 'APPROVED' or b.status == 'PAID' ? '#dcfce7' : (b.status == 'REJECTED' ? '#fee2e2' : (b.status == 'CANCELED' ? '#f3f4f6' : '#fef9c3'))};
                                              color: ${b.status == 'APPROVED' or b.status == 'PAID' ? '#166534' : (b.status == 'REJECTED' ? '#991b1b' : (b.status == 'CANCELED' ? '#6b7280' : '#854d0e'))};">
                                            ${b.status}
                                        </span>
                                    </td>

                                    <td style="text-align: center;">
                                        <c:if test="${b.status == 'PENDING'}">
                                            <div style="display:flex; gap:5px; justify-content:center;">
                                                <form action="${pageContext.request.contextPath}/admin/booking/updateStatus" method="post">
                                                    <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                    <input type="hidden" name="status" value="APPROVED">
                                                    <button type="submit" style="background:none; border:none; cursor:pointer; color:green; font-size:18px;" title="Luluskan">
                                                        <i class="fa-solid fa-check-circle"></i>
                                                    </button>
                                                </form>

                                                <form action="${pageContext.request.contextPath}/admin/booking/updateStatus" method="post">
                                                    <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                    <input type="hidden" name="status" value="REJECTED">
                                                    <button type="submit" style="background:none; border:none; cursor:pointer; color:red; font-size:18px;" title="Tolak">
                                                        <i class="fa-solid fa-circle-xmark"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </c:if>
                                        <c:if test="${b.status != 'PENDING'}">
                                            <span style="color:gray; font-size:12px;">Selesai</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty bookings}">
                                <tr>
                                    <td colspan="7" style="text-align:center; padding:20px;">Tiada permohonan.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                    <div id="bookEmpty" class="empty-filter" style="display:none;">
                        <i>🔍</i>
                        Tiada rekod sepadan dengan carian/filter anda.
                    </div>
                </div>
            </div>
        </main>

        <script>
            // ============================================
            // TABLE FILTER LOGIC (Search + Year + Month + Status)
            // ============================================
            function buildYearDropdown() {
                const tbody = document.getElementById('bookTbody');
                const select = document.getElementById('bookYear');
                if (!tbody || !select)
                    return;
                const years = new Set();
                tbody.querySelectorAll('tr[data-date]').forEach(tr => {
                    const date = tr.dataset.date;
                    if (date && date.length >= 4)
                        years.add(date.substring(0, 4));
                });
                const sortedYears = [...years].sort().reverse();
                sortedYears.forEach(y => {
                    const opt = document.createElement('option');
                    opt.value = y;
                    opt.textContent = y;
                    select.appendChild(opt);
                });
            }

            function filterBookings() {
                const tbody = document.getElementById('bookTbody');
                if (!tbody)
                    return;
                const query = (document.getElementById('bookSearch').value || '').toLowerCase().trim();
                const status = document.getElementById('bookStatus').value;
                const year = document.getElementById('bookYear').value;
                const month = document.getElementById('bookMonth').value;
                let visible = 0;
                tbody.querySelectorAll('tr[data-date]').forEach(tr => {
                    const search = (tr.dataset.search || '').toLowerCase();
                    const date = tr.dataset.date || '';
                    const trStatus = tr.dataset.status || '';
                    const trYear = date.substring(0, 4);
                    const trMonth = date.substring(5, 7);

                    const matchQuery = !query || search.includes(query);
                    const matchStatus = (status === 'all') || (trStatus === status);
                    const matchYear = (year === 'all') || (trYear === year);
                    const matchMonth = (month === 'all') || (trMonth === month);

                    if (matchQuery && matchStatus && matchYear && matchMonth) {
                        tr.style.display = '';
                        visible++;
                    } else {
                        tr.style.display = 'none';
                    }
                });
                document.getElementById('bookCount').textContent = visible;
                document.getElementById('bookEmpty').style.display = visible === 0 ? 'block' : 'none';
            }

            // Init
            buildYearDropdown();
            filterBookings();
        </script>
    </body>
</html>
