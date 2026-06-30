<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="currentUser" scope="session" type="model.User" />
<jsp:useBean id="nowDate" class="java.util.Date" scope="request"/>
<!DOCTYPE html>
<html lang="ms">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Pengurusan Sumbangan - MMS</title>
        <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root{
                --primary:#6b1a2a;
                --primary-dark:#4a0f1c;
                --accent:#b83b5e;
                --sidebar-bg:#4a0f1c;
                --sidebar-hover:rgba(255,255,255,0.07);
                --sidebar-active:rgba(184,59,94,0.2);
                --sidebar-border:rgba(255,255,255,0.08);
                --bg:#f9f0f2;
                --bg-card:#ffffff;
                --bg-secondary:#fdf6f8;
                --border:#eed8de;
                --border-light:#f5e8ec;
                --text:#2a0f17;
                --text-secondary:#7a5060;
                --text-muted:#b08090;
                --green:#15803d;
                --green-bg:#dcfce7;
                --amber:#b45309;
                --amber-bg:#fef3c7;
                --red:#b91c1c;
                --red-bg:#fee2e2;
                --blue:#1d4ed8;
                --blue-bg:#dbeafe;
                --purple:#7e22ce;
                --purple-bg:#f3e8ff;
                --slate:#475569;
                --slate-bg:#f1f5f9;
                --radius:10px;
                --radius-sm:6px;
                --radius-lg:14px;
                --shadow:0 1px 3px rgba(74,15,28,0.08),0 1px 2px rgba(74,15,28,0.04);
                --font:'DM Sans',sans-serif;
                --font-mono:'DM Mono',monospace;
            }
            *,*::before,*::after{
                box-sizing:border-box;
                margin:0;
                padding:0;
            }
            body{
                font-family:var(--font);
                background:var(--bg);
                color:var(--text);
                font-size:14px;
                line-height:1.5;
            }
            .layout{
                display:flex;
                min-height:100vh;
            }

            /* SIDEBAR */
            .sidebar{
                width:230px;
                min-width:230px;
                background:var(--sidebar-bg);
                display:flex;
                flex-direction:column;
                position:fixed;
                top:0;
                left:0;
                height:100vh;
                border-right:1px solid rgba(255,255,255,0.04);
                overflow:hidden;
            }
            .sidebar::before{
                content:'';
                position:absolute;
                top:-60px;
                right:-60px;
                width:180px;
                height:180px;
                border-radius:50%;
                background:radial-gradient(circle,rgba(184,59,94,0.12) 0%,transparent 70%);
                pointer-events:none;
            }
            .sidebar-brand{
                padding:20px 18px 16px;
                border-bottom:1px solid var(--sidebar-border);
                display:flex;
                align-items:center;
                gap:10px;
                flex-shrink:0;
            }
            .brand-icon{
                width:34px;
                height:34px;
                border-radius:9px;
                background:linear-gradient(135deg,var(--accent),#6b1a2a);
                display:flex;
                align-items:center;
                justify-content:center;
                box-shadow:0 2px 8px rgba(184,59,94,0.35);
                flex-shrink:0;
            }
            .brand-name{
                color:#fff;
                font-size:14px;
                font-weight:600;
            }
            .brand-role{
                font-size:9px;
                font-weight:600;
                letter-spacing:1.2px;
                color:#f0a0b4;
                text-transform:uppercase;
                margin-top:1px;
            }
            .nav-section-label{
                padding:14px 18px 5px;
                font-size:9.5px;
                font-weight:600;
                letter-spacing:1px;
                color:rgba(255,255,255,0.25);
                text-transform:uppercase;
            }
            .nav-item{
                display:flex;
                align-items:center;
                gap:10px;
                padding:9px 18px;
                color:rgba(255,255,255,0.55);
                font-size:13px;
                font-weight:400;
                border-left:2px solid transparent;
                transition:all 0.15s;
                text-decoration:none;
            }
            .nav-item:hover{
                background:var(--sidebar-hover);
                color:rgba(255,255,255,0.85);
            }
            .nav-item.active{
                background:var(--sidebar-active);
                color:#fff;
                font-weight:500;
                border-left-color:var(--accent);
            }
            .nav-item i{
                width:15px;
                text-align:center;
                font-size:13px;
                opacity:0.7;
            }
            .nav-item.active i,.nav-item:hover i{
                opacity:1;
            }
            .nav-divider{
                height:1px;
                background:var(--sidebar-border);
                margin:8px 18px;
            }
            .sidebar-footer{
                margin-top:auto;
                padding:14px 18px;
                border-top:1px solid var(--sidebar-border);
                display:flex;
                align-items:center;
                gap:10px;
            }
            .footer-av{
                width:32px;
                height:32px;
                border-radius:50%;
                background:linear-gradient(135deg,var(--accent),#6b1a2a);
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:12px;
                font-weight:600;
                color:#fff;
                flex-shrink:0;
            }
            .footer-name{
                color:#fff;
                font-size:12px;
                font-weight:500;
            }
            .footer-role{
                color:rgba(255,255,255,0.35);
                font-size:10px;
            }

            /* MAIN */
            .main{
                margin-left:230px;
                flex:1;
                display:flex;
                flex-direction:column;
                min-height:100vh;
            }
            .topbar{
                background:var(--bg-card);
                border-bottom:1px solid var(--border);
                padding:0 24px;
                height:54px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                position:sticky;
                top:0;
                z-index:100;
            }
            .topbar-title{
                font-size:15px;
                font-weight:600;
                color:var(--text);
                display:flex;
                align-items:center;
                gap:8px;
            }
            .topbar-title i{
                color:var(--accent);
            }
            .topbar-right{
                display:flex;
                align-items:center;
                gap:8px;
            }
            .topbar-chip{
                display:flex;
                align-items:center;
                gap:6px;
                background:var(--bg-secondary);
                border:1px solid var(--border);
                padding:5px 11px;
                border-radius:20px;
                font-size:12px;
                color:var(--text-secondary);
            }
            .btn-print{
                display:flex;
                align-items:center;
                gap:6px;
                background:var(--bg-secondary);
                border:1px solid var(--border);
                padding:5px 11px;
                border-radius:20px;
                font-size:12px;
                color:var(--text-secondary);
                cursor:pointer;
                font-family:var(--font);
            }
            .btn-logout{
                display:flex;
                align-items:center;
                gap:6px;
                background:#fee2e2;
                border:1px solid #fca5a5;
                padding:5px 11px;
                border-radius:20px;
                font-size:12px;
                color:#b91c1c;
                cursor:pointer;
                font-family:var(--font);
                text-decoration:none;
            }
            .content{
                padding:24px;
                flex:1;
            }

            /* ALERTS */
            .alert{
                padding:12px 16px;
                border-radius:var(--radius);
                margin-bottom:18px;
                display:flex;
                align-items:center;
                gap:9px;
                font-size:13px;
                font-weight:500;
            }
            .a-ok{
                background:var(--green-bg);
                color:var(--green);
                border:1px solid #6ee7b7;
            }
            .a-err{
                background:var(--red-bg);
                color:var(--red);
                border:1px solid #fca5a5;
            }

            /* STATS */
            .stats-row{
                display:grid;
                grid-template-columns:repeat(3,1fr);
                gap:14px;
                margin-bottom:22px;
            }
            .stat-card{
                background:var(--bg-card);
                border:1px solid var(--border);
                border-radius:var(--radius-lg);
                padding:18px 18px;
                display:flex;
                align-items:center;
                gap:13px;
                box-shadow:var(--shadow);
            }
            .stat-icon{
                width:44px;
                height:44px;
                border-radius:var(--radius);
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:18px;
                flex-shrink:0;
            }
            .stat-val{
                font-size:18px;
                font-weight:600;
                line-height:1.2;
                color:var(--text);
            }
            .stat-lbl{
                font-size:11px;
                color:var(--text-secondary);
                margin-top:3px;
            }

            /* CARD */
            .card{
                background:var(--bg-card);
                border:1px solid var(--border);
                border-radius:var(--radius-lg);
                overflow:hidden;
                box-shadow:var(--shadow);
                margin-bottom:20px;
            }
            .card-section-title{
                font-size:13px;
                font-weight:600;
                color:var(--text);
                display:flex;
                align-items:center;
                gap:8px;
                padding:16px 20px;
                border-bottom:1px solid var(--border-light);
            }
            .card-section-title::before{
                content:'';
                display:block;
                width:3px;
                height:14px;
                background:var(--accent);
                border-radius:2px;
            }
            .card-top{
                display:flex;
                align-items:center;
                justify-content:space-between;
                padding:16px 20px;
                border-bottom:1px solid var(--border-light);
            }
            .card-title{
                font-size:13px;
                font-weight:600;
                color:var(--text);
                display:flex;
                align-items:center;
                gap:8px;
            }
            .card-title::before{
                content:'';
                display:block;
                width:3px;
                height:14px;
                background:var(--accent);
                border-radius:2px;
            }
            .count-chip{
                font-size:11px;
                background:var(--bg-secondary);
                border:1px solid var(--border);
                padding:2px 9px;
                border-radius:10px;
                color:var(--text-secondary);
            }

            /* ADD FORM */
            .add-form-wrap{
                padding:20px;
            }
            .form-row{
                display:grid;
                grid-template-columns:repeat(auto-fit,minmax(150px,1fr));
                gap:12px;
            }
            .fg{
                display:flex;
                flex-direction:column;
                gap:4px;
            }
            .fg label{
                font-size:11px;
                font-weight:600;
                color:var(--text-secondary);
                text-transform:uppercase;
                letter-spacing:0.5px;
            }
            .fg input,.fg select{
                padding:8px 11px;
                border-radius:var(--radius-sm);
                border:1px solid var(--border);
                font-size:13px;
                font-family:var(--font);
                background:var(--bg-card);
                color:var(--text);
                transition:border 0.15s;
            }
            .fg input:focus,.fg select:focus{
                outline:none;
                border-color:var(--accent);
                background:#fff;
            }
            .btn-add{
                padding:9px 18px;
                background:linear-gradient(135deg,var(--accent),var(--primary));
                color:#fff;
                border:none;
                border-radius:var(--radius-sm);
                font-size:13px;
                font-weight:500;
                cursor:pointer;
                font-family:var(--font);
                display:flex;
                align-items:center;
                gap:7px;
                margin-top:12px;
                transition:opacity 0.2s;
            }
            .btn-add:hover{
                opacity:0.9;
            }

            /* TABLE */
            .table-wrap{
                overflow-x:auto;
            }
            table{
                width:100%;
                border-collapse:collapse;
                font-size:13px;
            }
            thead th{
                padding:9px 16px;
                text-align:left;
                font-size:10.5px;
                font-weight:600;
                letter-spacing:0.5px;
                color:var(--text-secondary);
                text-transform:uppercase;
                background:var(--bg-secondary);
                border-bottom:1px solid var(--border);
            }
            tbody td{
                padding:11px 16px;
                border-bottom:1px solid var(--border-light);
                color:var(--text);
                vertical-align:middle;
            }
            tbody tr:last-child td{
                border-bottom:none;
            }
            tbody tr:hover td{
                background:var(--bg-secondary);
            }
            tfoot td{
                padding:12px 16px;
                background:var(--bg-secondary);
                border-top:2px solid var(--border);
            }
            .empty-row{
                text-align:center;
                padding:40px!important;
                color:var(--text-muted);
            }

            /* BADGES */
            .badge{
                display:inline-flex;
                align-items:center;
                padding:2px 9px;
                border-radius:20px;
                font-size:11px;
                font-weight:500;
            }
            .badge-green{
                background:var(--green-bg);
                color:var(--green);
            }
            .badge-blue{
                background:var(--blue-bg);
                color:var(--blue);
            }
            .badge-gold{
                background:var(--amber-bg);
                color:var(--amber);
            }
            .badge-purple{
                background:var(--purple-bg);
                color:var(--purple);
            }
            .badge-gray{
                background:var(--slate-bg);
                color:var(--slate);
            }

            /* ACTION BUTTONS */
            .btn-edit{
                padding:4px 10px;
                border-radius:6px;
                font-size:11px;
                font-weight:500;
                background:var(--blue-bg);
                color:var(--blue);
                border:none;
                cursor:pointer;
                font-family:var(--font);
            }
            .btn-edit:hover{
                background:#bfdbfe;
            }
            .btn-delete{
                padding:4px 10px;
                border-radius:6px;
                font-size:11px;
                font-weight:500;
                background:var(--red-bg);
                color:var(--red);
                border:none;
                cursor:pointer;
                font-family:var(--font);
            }
            .btn-delete:hover{
                background:#fecaca;
            }

            /* MODAL */
            .modal-overlay{
                display:none;
                position:fixed;
                inset:0;
                background:rgba(0,0,0,0.45);
                z-index:999;
                align-items:center;
                justify-content:center;
            }
            .modal-overlay.open{
                display:flex;
            }
            .modal{
                background:#fff;
                border-radius:var(--radius-lg);
                padding:24px;
                width:90%;
                max-width:480px;
                box-shadow:0 20px 60px rgba(0,0,0,0.2);
            }
            .modal-title{
                font-size:14px;
                font-weight:600;
                color:var(--text);
                margin-bottom:18px;
                padding-bottom:12px;
                border-bottom:1px solid var(--border-light);
            }
            .modal-form .fg{
                margin-bottom:12px;
            }
            .modal-actions{
                display:flex;
                gap:10px;
                margin-top:18px;
                justify-content:flex-end;
            }
            .btn-cancel{
                padding:8px 16px;
                background:var(--bg-secondary);
                color:var(--text-secondary);
                border:1px solid var(--border);
                border-radius:var(--radius-sm);
                font-size:13px;
                cursor:pointer;
                font-family:var(--font);
            }
            .btn-save{
                padding:8px 16px;
                background:linear-gradient(135deg,var(--accent),var(--primary));
                color:#fff;
                border:none;
                border-radius:var(--radius-sm);
                font-size:13px;
                font-weight:500;
                cursor:pointer;
                font-family:var(--font);
            }

            @media print{
                .sidebar,.topbar,.add-form-wrap,.btn-edit,.btn-delete,.btn-print,.modal-overlay{
                    display:none!important;
                }
                .main{
                    margin-left:0;
                }
            }
            @media(max-width:900px){
                .sidebar{
                    display:none;
                }
                .main{
                    margin-left:0;
                }
                .stats-row{
                    grid-template-columns:1fr;
                }
            }
        </style>
    </head>
    <body>
        <div class="layout">

            <!-- SIDEBAR — dark maroon (sama macam treasurer_report) -->
            <aside class="sidebar">
                <div class="sidebar-brand">
                    <div class="brand-icon">
                        <i class="fa-solid fa-dollar-sign" style="color:#fff;font-size:15px;"></i>
                    </div>
                    <div>
                        <div class="brand-name">MMS</div>
                        <div class="brand-role">Treasurer</div>
                    </div>
                </div>

                <div class="nav-section-label">Modul Utama</div>
                <a href="${pageContext.request.contextPath}/treasurer/report#bayaran" class="nav-item">
                    <i class="fa-solid fa-credit-card"></i>
                    Pengurusan Bayaran
                </a>
                <a href="${pageContext.request.contextPath}/treasurer/donations" class="nav-item active">
                    <i class="fa-solid fa-hand-holding-heart"></i>
                    Pengurusan Sumbangan
                </a>

                <div class="nav-divider"></div>
                <div class="nav-section-label">Laporan</div>
                <%-- BETUL: /treasurer/report bukan /admin/report --%>
                <a href="${pageContext.request.contextPath}/treasurer/report" class="nav-item">
                    <i class="fa-solid fa-chart-pie"></i>
                    Laporan Kewangan
                </a>

                <div class="sidebar-footer">
                    <div class="footer-av">${currentUser.name.substring(0,1).toUpperCase()}</div>
                    <div>
                        <div class="footer-name">${currentUser.name}</div>
                        <div class="footer-role">Treasurer</div>
                    </div>
                </div>
            </aside>

            <!-- MAIN -->
            <div class="main">
                <header class="topbar">
                    <div class="topbar-title">
                        <i class="fa-solid fa-hand-holding-heart"></i>
                        Pengurusan Sumbangan
                    </div>
                    <div class="topbar-right">
                        <div class="topbar-chip">
                            <i class="fa-regular fa-clock" style="font-size:11px;"></i>
                            <fmt:formatDate value="${nowDate}" pattern="d MMM yyyy"/>
                        </div>
                        <button class="btn-print" onclick="window.print()">
                            <i class="fa-solid fa-print"></i> Cetak
                        </button>
                        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                            <i class="fa-solid fa-power-off"></i> Keluar
                        </a>
                    </div>
                </header>

                <div class="content">

                    <!-- Alerts -->
                    <c:if test="${not empty success}"><div class="alert a-ok"><i class="fa-solid fa-circle-check"></i> ${success}</div></c:if>
                    <c:if test="${not empty error}"><div class="alert a-err"><i class="fa-solid fa-circle-exclamation"></i> ${error}</div></c:if>

                        <!-- Stats -->
                        <div class="stats-row">
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#fce7f3;color:#9d174d;"><i class="fa-solid fa-hand-holding-dollar"></i></div>
                                <div><div class="stat-val">RM <fmt:formatNumber value="${totalAmount}" pattern="#,##0.00"/></div><div class="stat-lbl">Jumlah Terkumpul</div></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon" style="background:#fef3c7;color:#d97706;"><i class="fa-solid fa-list"></i></div>
                            <div><div class="stat-val">${totalRecords}</div><div class="stat-lbl">Jumlah Rekod</div></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon" style="background:#dbeafe;color:#1d4ed8;"><i class="fa-solid fa-calendar"></i></div>
                            <div><div class="stat-val">RM <fmt:formatNumber value="${monthAmount}" pattern="#,##0.00"/></div><div class="stat-lbl">Bulan Ini</div></div>
                        </div>
                    </div>

                    <!-- Tambah Rekod -->
                    <div class="card">
                        <div class="card-section-title">
                            <i class="fa-solid fa-plus" style="color:var(--accent);"></i> Tambah Rekod Sumbangan Baru
                        </div>
                        <div class="add-form-wrap">
                            <form action="${pageContext.request.contextPath}/treasurer/donations" method="post">
                                <input type="hidden" name="action" value="add">
                                <div class="form-row">
                                    <div class="fg"><label>Nama Penderma</label><input type="text" name="donor_name" placeholder="Nama penderma" required></div>
                                    <div class="fg"><label>Jumlah (RM)</label><input type="number" name="amount" placeholder="0.00" min="0.01" step="0.01" required></div>
                                    <div class="fg"><label>Kaedah Bayaran</label>
                                        <select name="payment_method">
                                            <option value="Tunai">Tunai</option>    
                                            <option value="Pindahan Bank">Pindahan Bank</option>
                                        </select>
                                    </div>
                                    <div class="fg"><label>Tarikh</label><input type="date" name="date" required></div>
                                    <div class="fg"><label>Catatan</label><input type="text" name="notes" placeholder="(Pilihan)"></div>
                                </div>
                                <button type="submit" class="btn-add"><i class="fa-solid fa-plus"></i> Tambah Rekod</button>
                            </form>
                        </div>
                    </div>

                    <!-- Senarai Sumbangan -->
                    <div class="card">
                        <div class="card-top">
                            <div class="card-title"><i class="fa-solid fa-table" style="color:var(--accent);"></i> Senarai Semua Sumbangan</div>
                            <div style="display:flex;align-items:center;gap:8px;">
                                <span class="count-chip">${totalRecords} rekod</span>
                                <button class="btn-print" onclick="window.print()"><i class="fa-solid fa-print"></i> Cetak Laporan</button>
                            </div>
                        </div>
                        <div class="table-wrap">
                            <c:choose>
                                <c:when test="${empty donations}">
                                    <div class="empty-row" style="padding:40px;text-align:center;color:var(--text-muted);">
                                        <i class="fa-solid fa-inbox" style="font-size:40px;opacity:0.3;display:block;margin-bottom:10px;"></i>
                                        Tiada rekod sumbangan lagi.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table>
                                        <thead>
                                            <tr><th>#</th><th>Tarikh</th><th>Nama Penderma</th><th>Kaedah</th><th>Jumlah</th><th>Catatan</th><th>Tindakan</th></tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${donations}" var="d" varStatus="s">
                                                <tr>
                                                    <td style="color:var(--text-muted);">${s.count}</td>
                                                    <td style="white-space:nowrap;">${d.date}</td>
                                                    <td style="font-weight:500;">${d.donorName}</td>
                                                    <td style="color:var(--text-secondary);">${d.paymentMethod}</td>
                                                    <td style="font-weight:600;font-family:var(--font-mono);color:var(--accent);">RM <fmt:formatNumber value="${d.amount}" pattern="#,##0.00"/></td>
                                                    <td style="color:var(--text-muted);font-size:12px;">${not empty d.notes ? d.notes : '—'}</td>
                                                    <td>
                                                        <div style="display:flex;gap:6px;">
                                                            <button class="btn-edit" onclick="openEdit('${d.donationId}', '${d.donorName}', '${d.amount}', '${d.donationType}', '${d.paymentMethod}', '${d.notes}')">
                                                                <i class="fa-solid fa-pen"></i> Edit
                                                            </button>
                                                            <form action="${pageContext.request.contextPath}/treasurer/donations" method="post" style="display:inline;" onsubmit="return confirm('Padam rekod ini?')">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="donation_id" value="${d.donationId}">
                                                                <button type="submit" class="btn-delete"><i class="fa-solid fa-trash"></i> Padam</button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <td colspan="5" style="text-align:right;font-weight:700;font-size:13px;color:var(--text-secondary);">JUMLAH KESELURUHAN:</td>
                                                <td style="font-weight:700;font-family:var(--font-mono);color:var(--accent);font-size:14px;">RM <fmt:formatNumber value="${totalAmount}" pattern="#,##0.00"/></td>
                                                <td colspan="2"></td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div><!-- /content -->
            </div><!-- /main -->
        </div><!-- /layout -->

        <!-- Edit Modal -->
        <div class="modal-overlay" id="editModal">
            <div class="modal">
                <div class="modal-title">Edit Rekod Sumbangan</div>
                <form action="${pageContext.request.contextPath}/treasurer/donations" method="post" class="modal-form">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="donation_id" id="editId">
                    <div class="fg"><label>Nama Penderma</label><input type="text" name="donor_name" id="editName" required></div>
                    <div class="fg"><label>Jumlah (RM)</label><input type="number" name="amount" id="editAmount" min="0.01" step="0.01" required></div>
                    <div class="fg"><label>Jenis Tabung</label>
                        <select name="donation_type" id="editType">
                            <option value="Tabung Umum">Tabung Umum</option>
                            <option value="Tabung Pembangunan">Tabung Pembangunan</option>
                            <option value="Tabung Asnaf">Tabung Asnaf</option>
                            <option value="Program Ilmu">Program Ilmu</option>
                            <option value="Tabung Wakaf">Tabung Wakaf</option>
                        </select>
                    </div>
                    <div class="fg"><label>Kaedah Bayaran</label>
                        <select name="payment_method" id="editMethod">
                            <option value="Tunai">Tunai</option>
                            <option value="QR Code">QR Code</option>
                            <option value="Pindahan Bank">Pindahan Bank</option>
                        </select>
                    </div>
                    <div class="fg"><label>Catatan</label><input type="text" name="notes" id="editNotes"></div>
                    <div class="modal-actions">
                        <button type="button" class="btn-cancel" onclick="closeEdit()">Batal</button>
                        <button type="submit" class="btn-save">Simpan</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openEdit(id, name, amount, type, method, notes) {
                document.getElementById('editId').value = id;
                document.getElementById('editName').value = name;
                document.getElementById('editAmount').value = amount;
                document.getElementById('editType').value = type;
                document.getElementById('editMethod').value = method;
                document.getElementById('editNotes').value = notes;
                document.getElementById('editModal').classList.add('open');
            }
            function closeEdit() {
                document.getElementById('editModal').classList.remove('open');
            }
            document.getElementById('editModal').addEventListener('click', function (e) {
                if (e.target === this)
                    closeEdit();
            });
        </script>
    </body>
</html>
