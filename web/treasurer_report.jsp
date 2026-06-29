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
        <title>Dashboard Bendahari - MMS</title>
        <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
        <style>
            :root{
                --primary:#6b1a2a;
                --primary-dark:#4a0f1c;
                --primary-mid:#7d2235;
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
                --slate:#475569;
                --slate-bg:#f1f5f9;
                --blue:#1d4ed8;
                --blue-bg:#dbeafe;
                --purple:#7e22ce;
                --purple-bg:#f3e8ff;
                --radius:10px;
                --radius-sm:6px;
                --radius-lg:14px;
                --shadow:0 1px 3px rgba(74,15,28,0.08),0 1px 2px rgba(74,15,28,0.04);
                --shadow-md:0 4px 16px rgba(74,15,28,0.1);
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
                height:100vh;
                overflow:hidden;
            }

            /* SIDEBAR — dark maroon */
            .sidebar{
                width:230px;
                min-width:230px;
                background:var(--sidebar-bg);
                display:flex;
                flex-direction:column;
                border-right:1px solid rgba(255,255,255,0.04);
                position:relative;
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
                cursor:pointer;
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
            .nav-icon{
                width:15px;
                height:15px;
                flex-shrink:0;
                opacity:0.7;
            }
            .nav-item.active .nav-icon,.nav-item:hover .nav-icon{
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
                flex:1;
                display:flex;
                flex-direction:column;
                overflow:hidden;
            }
            .topbar{
                background:var(--bg-card);
                border-bottom:1px solid var(--border);
                padding:0 24px;
                height:54px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                flex-shrink:0;
            }
            .topbar-title{
                font-size:15px;
                font-weight:600;
                color:var(--text);
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
                flex:1;
                overflow-y:auto;
                padding:24px;
            }

            .page{
                display:none;
            }
            .page.active{
                display:block;
            }

            /* STATS */
            .stats-row{
                display:grid;
                gap:14px;
                margin-bottom:22px;
            }
            .stats-row.col4{
                grid-template-columns:repeat(4,1fr);
            }
            .stats-row.col5{
                grid-template-columns:repeat(5,1fr);
            }
            .stat-card{
                background:var(--bg-card);
                border:1px solid var(--border);
                border-radius:var(--radius-lg);
                padding:16px 18px;
                display:flex;
                align-items:center;
                gap:13px;
                box-shadow:var(--shadow);
            }
            .stat-icon{
                width:38px;
                height:38px;
                border-radius:var(--radius);
                display:flex;
                align-items:center;
                justify-content:center;
                flex-shrink:0;
            }
            .stat-val{
                font-size:20px;
                font-weight:600;
                line-height:1.2;
                color:var(--text);
            }
            .stat-lbl{
                font-size:11px;
                color:var(--text-secondary);
                margin-top:3px;
            }

            /* SUMMARY BOX (laporan page top) */
            .summary-box{
                background:linear-gradient(135deg,var(--primary-dark),var(--primary));
                border-radius:var(--radius-lg);
                padding:20px 24px;
                display:flex;
                align-items:center;
                gap:0;
                margin-bottom:22px;
                flex-wrap:wrap;
            }
            .summary-item{
                flex:1;
                min-width:120px;
                text-align:center;
                padding:8px 12px;
            }
            .summary-val{
                font-size:20px;
                font-weight:600;
                color:#fff;
            }
            .summary-lbl{
                font-size:11px;
                color:rgba(255,255,255,0.6);
                margin-top:4px;
            }
            .summary-divider{
                width:1px;
                height:40px;
                background:rgba(255,255,255,0.15);
                flex-shrink:0;
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
            .card-header{
                padding:14px 18px;
                border-bottom:1px solid var(--border-light);
                display:flex;
                align-items:center;
                justify-content:space-between;
            }
            /* FILTER BAR — search + dropdowns */
            .filter-bar{
                display:flex;
                gap:8px;
                padding:10px 18px;
                background:var(--bg-secondary);
                border-bottom:1px solid var(--border-light);
                flex-wrap:wrap;
                align-items:center;
            }
            .search-box{
                position:relative;
                flex:1;
                min-width:200px;
            }
            .search-box .search-ic{
                position:absolute;
                left:10px;
                top:50%;
                transform:translateY(-50%);
                font-size:11px;
                color:var(--text-muted);
                font-style:normal;
                pointer-events:none;
            }
            .search-box input{
                width:100%;
                padding:7px 12px 7px 30px;
                border-radius:8px;
                border:1px solid var(--border);
                background:#fff;
                font-family:var(--font);
                font-size:12px;
                color:var(--text);
                transition:all .2s;
            }
            .search-box input:focus{
                outline:none;
                border-color:var(--primary);
                box-shadow:0 0 0 3px rgba(122,40,32,.08);
            }
            .filter-select{
                padding:7px 11px;
                border-radius:8px;
                border:1px solid var(--border);
                background:#fff;
                font-family:var(--font);
                font-size:12px;
                font-weight:500;
                color:var(--text);
                cursor:pointer;
                min-width:130px;
                transition:all .2s;
            }
            .filter-select:hover{
                border-color:var(--primary);
            }
            .filter-select:focus{
                outline:none;
                border-color:var(--primary);
            }
            .empty-filter{
                padding:32px 20px;
                text-align:center;
                color:var(--text-muted);
                font-size:13px;
                background:var(--bg-secondary);
            }
            .empty-filter i{
                font-style:normal;
                font-size:20px;
                margin-right:6px;
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
            .card-meta{
                display:flex;
                align-items:center;
                gap:8px;
            }
            .count-chip{
                font-size:11px;
                background:var(--bg-secondary);
                border:1px solid var(--border);
                padding:2px 9px;
                border-radius:10px;
                color:var(--text-secondary);
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
                white-space:nowrap;
            }
            .b-approved{
                background:var(--green-bg);
                color:var(--green);
            }
            .b-pending{
                background:var(--amber-bg);
                color:var(--amber);
            }
            .b-rejected{
                background:var(--red-bg);
                color:var(--red);
            }
            .b-canceled{
                background:var(--slate-bg);
                color:var(--slate);
            }
            .b-paid{
                background:#dcfce7;
                color:#15803d;
            }
            .b-unpaid{
                background:#fef3c7;
                color:#b45309;
            }

            /* CHARTS */
            .charts-grid{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:16px;
                margin-bottom:20px;
            }
            .charts-grid.col3{
                grid-template-columns:repeat(3,1fr);
            }
            .chart-card{
                background:var(--bg-card);
                border:1px solid var(--border);
                border-radius:var(--radius-lg);
                padding:18px 20px;
                box-shadow:var(--shadow);
            }
            .chart-title{
                font-size:12px;
                font-weight:600;
                color:var(--text-secondary);
                text-transform:uppercase;
                letter-spacing:0.5px;
                margin-bottom:14px;
            }
            /* Chart header row dengan filter butang */
            .chart-head-row{
                display:flex;
                align-items:center;
                justify-content:space-between;
                margin-bottom:14px;
                gap:10px;
                flex-wrap:wrap;
            }
            .chart-head-row .chart-title{
                margin-bottom:0;
            }
            /* Filter button group */
            .fb-group{
                display:flex;
                background:var(--bg);
                padding:3px;
                border-radius:8px;
                gap:2px;
                border:1px solid var(--border-light);
            }
            .fb-btn{
                padding:5px 12px;
                border-radius:6px;
                border:none;
                background:transparent;
                font-family:var(--font);
                font-size:11px;
                font-weight:600;
                color:var(--text-secondary);
                cursor:pointer;
                transition:all .2s;
                letter-spacing:.2px;
            }
            .fb-btn:hover{
                color:var(--text);
            }
            .fb-btn.active{
                background:#fff;
                color:var(--primary);
                box-shadow:0 1px 3px rgba(0,0,0,.08);
            }
            .chart-wrap{
                position:relative;
                height:180px;
            }

            /* ACTIONS */
            .acts{
                display:flex;
                gap:5px;
                flex-wrap:wrap;
            }
            .btn-sm{
                padding:4px 10px;
                border-radius:6px;
                font-size:11px;
                font-weight:500;
                border:none;
                cursor:pointer;
                font-family:var(--font);
            }
            .btn-edit{
                background:var(--blue-bg);
                color:var(--blue);
            }
            .btn-edit:hover{
                background:#bfdbfe;
            }
            .btn-del{
                background:var(--red-bg);
                color:var(--red);
            }
            .btn-del:hover{
                background:#fecaca;
            }

            /* MODAL */
            .modal-ov{
                display:none;
                position:fixed;
                inset:0;
                background:rgba(0,0,0,.45);
                z-index:999;
                align-items:center;
                justify-content:center;
                padding:20px;
            }
            .modal-ov.open{
                display:flex;
            }
            .modal{
                background:#fff;
                border-radius:var(--radius-lg);
                padding:24px;
                width:100%;
                max-width:460px;
                box-shadow:var(--shadow-md);
                max-height:90vh;
                overflow-y:auto;
            }
            .modal-title{
                font-size:14px;
                font-weight:600;
                color:var(--text);
                margin-bottom:16px;
                padding-bottom:12px;
                border-bottom:1px solid var(--border-light);
            }
            .modal-grid{
                display:grid;
                grid-template-columns:1fr 1fr;
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
            }
            .fg input,.fg select,.fg textarea{
                padding:8px 11px;
                border-radius:var(--radius-sm);
                border:1px solid var(--border);
                font-size:13px;
                font-family:var(--font);
                background:var(--bg-card);
                color:var(--text);
            }
            .fg input:focus,.fg select:focus,.fg textarea:focus{
                outline:none;
                border-color:var(--accent);
            }
            .fg textarea{
                resize:vertical;
                min-height:60px;
            }
            .fg.full{
                grid-column:1/-1;
            }
            .modal-acts{
                display:flex;
                gap:10px;
                justify-content:flex-end;
                margin-top:16px;
            }
            .btn-cl{
                padding:8px 16px;
                background:var(--bg-secondary);
                color:var(--text-secondary);
                border:1px solid var(--border);
                border-radius:var(--radius-sm);
                font-size:13px;
                cursor:pointer;
                font-family:var(--font);
            }
            .btn-sv{
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
                .sidebar,.topbar,.acts,.btn-print,.btn-logout,.modal-ov{
                    display:none!important;
                }
                .page{
                    display:block!important;
                }
                .layout{
                    height:auto;
                }
                .main{
                    overflow:visible;
                }
                .content{
                    overflow:visible;
                }
            }
            @media(max-width:900px){
                .sidebar{
                    display:none;
                }
                .stats-row.col5,.stats-row.col4{
                    grid-template-columns:repeat(2,1fr);
                }
                .charts-grid{
                    grid-template-columns:1fr;
                }
                .summary-box{
                    flex-direction:column;
                    gap:10px;
                }
                .summary-divider{
                    display:none;
                }
            }
        </style>
    </head>
    <body>
        <div class="layout">

            <!-- SIDEBAR — dark maroon -->
            <aside class="sidebar">
                <div class="sidebar-brand">
                    <div class="brand-icon">
                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.2"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
                    </div>
                    <div>
                        <div class="brand-name">MMS</div>
                        <div class="brand-role">Treasurer</div>
                    </div>
                </div>

                <div class="nav-section-label">Modul Utama</div>
                <div class="nav-item" onclick="showPage('bayaran', this)">
                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg>
                    Pengurusan Bayaran
                </div>
                <a href="${pageContext.request.contextPath}/treasurer/donations" class="nav-item">
                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>
                    Pengurusan Sumbangan
                </a>

                <div class="nav-divider"></div>
                <div class="nav-section-label">Laporan</div>
                <div class="nav-item active" onclick="showPage('laporan', this)">
                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                    Laporan Kewangan
                </div>

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
                    <div class="topbar-title" id="page-title">Laporan Kewangan</div>
                    <div class="topbar-right">
                        <div class="topbar-chip">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            <fmt:formatDate value="${nowDate}" pattern="d MMM yyyy"/>
                        </div>
                        <button class="btn-print" onclick="window.print()">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 01-2-2v-5a2 2 0 012-2h16a2 2 0 012 2v5a2 2 0 01-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
                            Cetak
                        </button>
                        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                            Keluar
                        </a>
                    </div>
                </header>

                <div class="content">

                    <%-- Alerts --%>
                    <c:if test="${not empty success}">
                        <div style="padding:10px 14px;border-radius:var(--radius);background:var(--green-bg);color:var(--green);border:1px solid #6ee7b7;font-size:13px;margin-bottom:16px;">${success}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div style="padding:10px 14px;border-radius:var(--radius);background:var(--red-bg);color:var(--red);border:1px solid #fca5a5;font-size:13px;margin-bottom:16px;">${error}</div>
                    </c:if>

                    <!-- ══════ PAGE: LAPORAN KEWANGAN ══════ -->
                    <div class="page active" id="page-laporan">

                        <div class="summary-box">
                            <div class="summary-item">
                                <div class="summary-val">RM <fmt:formatNumber value="${totalRevenue + totalDonation}" pattern="#,##0.00"/></div>
                                <div class="summary-lbl">Jumlah Keseluruhan</div>
                            </div>
                            <div class="summary-divider"></div>
                            <div class="summary-item">
                                <div class="summary-val">RM <fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></div>
                                <div class="summary-lbl">Hasil Tempahan</div>
                            </div>
                            <div class="summary-divider"></div>
                            <div class="summary-item">
                                <div class="summary-val">RM <fmt:formatNumber value="${totalDonation}" pattern="#,##0.00"/></div>
                                <div class="summary-lbl">Jumlah Sumbangan</div>
                            </div>
                            <div class="summary-divider"></div>
                            <div class="summary-item">
                                <div class="summary-val">${approvedBookings}</div>
                                <div class="summary-lbl">Bayaran Tempahan</div>
                            </div>
                            <div class="summary-divider"></div>
                            <div class="summary-item">
                                <div class="summary-val">${totalDonationRecords}</div>
                                <div class="summary-lbl">Rekod Sumbangan</div>
                            </div>
                        </div>

                        <div class="charts-grid">
                            <div class="chart-card">
                                <div class="chart-head-row">
                                    <div class="chart-title">Hasil Bayaran Tempahan (RM)</div>
                                    <div class="fb-group">
                                        <button class="fb-btn active" onclick="setChartFilter('rev', 'bulan', this)">Bulan</button>
                                        <button class="fb-btn" onclick="setChartFilter('rev', 'tahun', this)">Tahun</button>
                                    </div>
                                </div>
                                <div class="chart-wrap"><canvas id="cRevMonth"></canvas></div>
                            </div>
                            <div class="chart-card">
                                <div class="chart-head-row">
                                    <div class="chart-title">Sumbangan / Derma (RM)</div>
                                    <div class="fb-group">
                                        <button class="fb-btn active" onclick="setChartFilter('don', 'bulan', this)">Bulan</button>
                                        <button class="fb-btn" onclick="setChartFilter('don', 'tahun', this)">Tahun</button>
                                    </div>
                                </div>
                                <div class="chart-wrap"><canvas id="cDonMonth"></canvas></div>
                            </div>
                        </div>

                        <div class="charts-grid col2">
                            <div class="chart-card">
                                <div class="chart-title">Kaedah Bayaran</div>
                                <div class="chart-wrap"><canvas id="cDonMethod"></canvas></div>
                            </div>
                            <div class="chart-card">
                                <div class="chart-title">Status Tempahan</div>
                                <div class="chart-wrap"><canvas id="cBookingStatus"></canvas></div>
                            </div>
                        </div>

                        <!-- Senarai Bayaran Tempahan -->
                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Senarai Bayaran Tempahan</div>
                                <span class="count-chip"><span id="bookCount">${approvedBookings}</span> rekod</span>
                            </div>
                            <div class="filter-bar">
                                <div class="search-box">
                                    <i class="search-ic">🔍</i>
                                    <input type="text" id="bookSearch" placeholder="Cari nama, ref, fasiliti..." onkeyup="filterBookings()">
                                </div>
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
                            </div>
                            <div class="table-wrap">
                                <table>
                                    <thead><tr><th>Ref</th><th>Pemohon</th><th>Fasiliti</th><th>Tarikh Tempahan</th><th>Jumlah</th><th>Status</th></tr></thead>
                                    <tbody id="bookTbody">
                                        <c:forEach items="${allBookings}" var="b">
                                            <c:if test="${b.status=='APPROVED' or b.status=='PAID'}">
                                                <tr data-search="${b.bookingId} ${b.userName} ${b.facilityName}" data-date="${b.startDate}">
                                                    <td><span style="font-family:var(--font-mono);font-size:12px">#${b.bookingId}</span></td>
                                                    <td style="font-weight:500;">${b.userName}</td>
                                                    <td>${b.facilityName}</td>
                                                    <td>${b.startDate}</td>
                                                    <td style="font-family:var(--font-mono);font-weight:600;">RM <fmt:formatNumber value="${b.totalAmount}" pattern="#,##0.00"/></td>
                                                    <td><span class="badge b-paid">Dibayar</span></td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${empty allBookings}">
                                            <tr><td colspan="6" class="empty-row">Tiada rekod bayaran.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                                <div id="bookEmpty" class="empty-filter" style="display:none;">
                                    <i>🔍</i> Tiada rekod sepadan dengan carian/filter anda.
                                </div>
                            </div>
                        </div>

                        <!-- Senarai Sumbangan -->
                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Senarai Sumbangan / Derma</div>
                                <span class="count-chip"><span id="donCount">${totalDonationRecords}</span> rekod</span>
                            </div>
                            <div class="filter-bar">
                                <div class="search-box">
                                    <i class="search-ic">🔍</i>
                                    <input type="text" id="donSearch" placeholder="Cari nama, jenis, kaedah..." onkeyup="filterDonations()">
                                </div>
                                <select id="donYear" class="filter-select" onchange="filterDonations()">
                                    <option value="all">Semua Tahun</option>
                                </select>
                                <select id="donMonth" class="filter-select" onchange="filterDonations()">
                                    <option value="all">Semua Bulan</option>
                                    <option value="01">Januari</option><option value="02">Februari</option>
                                    <option value="03">Mac</option><option value="04">April</option>
                                    <option value="05">Mei</option><option value="06">Jun</option>
                                    <option value="07">Julai</option><option value="08">Ogos</option>
                                    <option value="09">September</option><option value="10">Oktober</option>
                                    <option value="11">November</option><option value="12">Disember</option>
                                </select>
                            </div>
                            <div class="table-wrap">
                                <table>
                                    <thead><tr><th>#</th><th>Penderma</th><th>Jenis</th><th>Kaedah</th><th>Tarikh Terima</th><th>Jumlah</th><th>Catatan</th></tr></thead>
                                    <tbody id="donTbody">
                                        <c:forEach items="${donations}" var="d" varStatus="s">
                                            <tr data-search="${d.donorName} ${d.donationType} ${d.paymentMethod}" data-date="${d.date}">
                                                <td style="color:var(--text-muted);">${s.count}</td>
                                                <td style="font-weight:500;">${d.donorName}</td>
                                                <td><span class="badge" style="background:#fce7f3;color:#9d174d;">${d.donationType}</span></td>
                                                <td style="color:var(--text-secondary);">${d.paymentMethod}</td>
                                                <td>${d.date}</td>
                                                <td style="font-family:var(--font-mono);font-weight:600;">RM <fmt:formatNumber value="${d.amount}" pattern="#,##0.00"/></td>
                                                <td style="color:var(--text-secondary);font-size:12px;">${not empty d.notes ? d.notes : '—'}</td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty donations}">
                                            <tr><td colspan="7" class="empty-row">Tiada rekod sumbangan.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                                <div id="donEmpty" class="empty-filter" style="display:none;">
                                    <i>🔍</i> Tiada rekod sepadan dengan carian/filter anda.
                                </div>
                            </div>
                        </div>

                    </div><!-- /page-laporan -->

                    <!-- ══════ PAGE: PENGURUSAN BAYARAN ══════ -->
                    <div class="page" id="page-bayaran">

                        <div class="stats-row col4">
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#fef3c7"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#b45309" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
                                <div><div class="stat-val">${pendingBookings}</div><div class="stat-lbl">Menunggu Kelulusan</div></div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#dcfce7"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#15803d" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg></div>
                                <div><div class="stat-val">${approvedBookings}</div><div class="stat-lbl">Diluluskan</div></div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#dbeafe"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#1d4ed8" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg></div>
                                <div><div class="stat-val">${totalBookings}</div><div class="stat-lbl">Jumlah Tempahan</div></div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#dcfce7"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#15803d" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg></div>
                                <div><div class="stat-val" style="font-size:14px;">RM <fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></div><div class="stat-lbl">Jumlah Hasil</div></div>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Semua Rekod Tempahan</div>
                                <span class="count-chip">${totalBookings} rekod</span>
                            </div>
                            <div class="table-wrap">
                                <table>
                                    <thead><tr><th>ID</th><th>Pemohon</th><th>Fasiliti</th><th>Sesi</th><th>Tarikh Mula</th><th>Tarikh Tamat</th><th>Hari</th><th>Jumlah</th><th>Status</th></tr></thead>
                                    <tbody>
                                        <c:forEach items="${allBookings}" var="b">
                                            <tr>
                                                <td><span style="font-family:var(--font-mono);font-size:12px">#${b.bookingId}</span></td>
                                                <td style="font-weight:500;">${b.userName}</td>
                                                <td>${b.facilityName}</td>
                                                <td style="font-size:12px;"><c:choose><c:when test="${b.sessionType=='HALF_DAY'}">½ Hari</c:when><c:otherwise>Sehari</c:otherwise></c:choose></td>
                                                <td>${b.startDate}</td>
                                                <td>${b.endDate}</td>
                                                <td style="text-align:center;font-family:var(--font-mono);">${b.totalDays}</td>
                                                <td style="font-family:var(--font-mono);">RM <fmt:formatNumber value="${b.totalAmount}" pattern="#,##0.00"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${b.status=='APPROVED'}"><span class="badge b-approved">Diluluskan</span></c:when>
                                                        <c:when test="${b.status=='PENDING'}"><span class="badge b-pending">Menunggu</span></c:when>
                                                        <c:when test="${b.status=='REJECTED'}"><span class="badge b-rejected">Ditolak</span></c:when>
                                                        <c:otherwise><span class="badge b-canceled">Dibatalkan</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div><!-- /page-bayaran -->

                </div><!-- /content -->
            </div><!-- /main -->
        </div><!-- /layout -->

        <script>
            const PAGE_TITLES = {laporan: 'Laporan Kewangan', bayaran: 'Pengurusan Bayaran'};
            function showPage(id, el) {
                document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
                document.querySelectorAll('.nav-item').forEach(n => {
                    if (n.tagName !== 'A')
                        n.classList.remove('active');
                });
                document.getElementById('page-' + id).classList.add('active');
                if (el && el.tagName !== 'A')
                    el.classList.add('active');
                document.getElementById('page-title').textContent = PAGE_TITLES[id] || id;
            }

            // Real data from controller — 4 mode untuk setiap chart
            const REV_DATA = {
                hari: {labels: ${revDayLabels}, data: ${revDayData}},
                minggu: {labels: ${revWeekLabels}, data: ${revWeekData}},
                bulan: {labels: ${revMonthLabels}, data: ${revMonthData}},
                tahun: {labels: ${revYearLabels}, data: ${revYearData}}
            };
            const DON_DATA = {
                hari: {labels: ${donDayLabels}, data: ${donDayData}},
                minggu: {labels: ${donWeekLabels}, data: ${donWeekData}},
                bulan: {labels: ${donMonthLabels}, data: ${donMonthData}},
                tahun: {labels: ${donYearLabels}, data: ${donYearData}}
            };
            const donMethodLabels = ${donMethodLabels};
            const donMethodData = ${donMethodData};
            const bookingStatus = ${bookingStatusData};

            // PINK soft palette untuk chart (page kekal maroon)
            const C = {accent: '#f9a8d4', dark: '#ec4899', green: '#86efac', blue: '#93c5fd', amber: '#fcd34d', grid: '#fce7f3', tick: '#9ca3af'};

            // Chart instance cache (supaya boleh destroy & recreate)
            const chartInstances = {};

            function barChart(id, labels, data, color) {
                const ctx = document.getElementById(id);
                if (!ctx)
                    return;
                if (chartInstances[id])
                    chartInstances[id].destroy();
                chartInstances[id] = new Chart(ctx, {type: 'bar',
                    data: {labels: labels.length ? labels : ['—'],
                        datasets: [{data: data.length ? data : [0], backgroundColor: color + '99', borderColor: color, borderWidth: 1.5, borderRadius: 6, label: ''}]},
                    options: {responsive: true, maintainAspectRatio: false,
                        plugins: {legend: {display: false}},
                        scales: {x: {grid: {display: false}, ticks: {font: {size: 10}, color: C.tick}},
                            y: {beginAtZero: true, grid: {color: C.grid}, ticks: {font: {size: 10}, color: C.tick}}}}
                });
            }

            function pieChart(id, labels, data, colors) {
                const ctx = document.getElementById(id);
                if (!ctx)
                    return;
                if (chartInstances[id])
                    chartInstances[id].destroy();
                chartInstances[id] = new Chart(ctx, {type: 'pie',
                    data: {labels: labels.length ? labels : ['Tiada Data'],
                        datasets: [{data: data.length ? data : [1], backgroundColor: colors, borderWidth: 2, borderColor: '#fff'}]},
                    options: {responsive: true, maintainAspectRatio: false,
                        plugins: {legend: {position: 'bottom', labels: {font: {size: 10}, padding: 10, boxWidth: 10}}}}
                });
            }

            // ===== Render bar chart dengan filter =====
            function renderRevChart(mode) {
                const d = REV_DATA[mode] || REV_DATA.bulan;
                barChart('cRevMonth', d.labels, d.data.map(v => parseFloat(v)), C.blue);
            }
            function renderDonChart(mode) {
                const d = DON_DATA[mode] || DON_DATA.bulan;
                barChart('cDonMonth', d.labels, d.data.map(v => parseFloat(v)), C.accent);
            }

            // ===== Filter button handler =====
            function setChartFilter(chartKey, mode, btnEl) {
                const group = btnEl.parentElement;
                group.querySelectorAll('.fb-btn').forEach(b => b.classList.remove('active'));
                btnEl.classList.add('active');
                if (chartKey === 'rev')
                    renderRevChart(mode);
                if (chartKey === 'don')
                    renderDonChart(mode);
            }

            // Initial render (default: Bulan)
            renderRevChart('bulan');
            renderDonChart('bulan');
            pieChart('cDonMethod', donMethodLabels, donMethodData, ['#f9a8d4', '#86efac', '#fcd34d', '#c4b5fd']);
            pieChart('cBookingStatus', ['Pending', 'Diluluskan', 'Ditolak', 'Dibatalkan'],
                    bookingStatus, ['#fcd34d', '#86efac', '#fca5a5', '#cbd5e1']);

            // ============================================
            // TABLE FILTER LOGIC (Search + Year + Month)
            // ============================================
            function buildYearDropdown(tbodyId, selectId) {
                const tbody = document.getElementById(tbodyId);
                const select = document.getElementById(selectId);
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

            function applyTableFilter(tbodyId, searchId, yearId, monthId, countId, emptyId) {
                const tbody = document.getElementById(tbodyId);
                if (!tbody)
                    return;
                const query = (document.getElementById(searchId).value || '').toLowerCase().trim();
                const year = document.getElementById(yearId).value;
                const month = document.getElementById(monthId).value;
                let visible = 0;
                tbody.querySelectorAll('tr[data-date]').forEach(tr => {
                    const search = (tr.dataset.search || '').toLowerCase();
                    const date = tr.dataset.date || '';
                    const trYear = date.substring(0, 4);
                    const trMonth = date.substring(5, 7);

                    const matchQuery = !query || search.includes(query);
                    const matchYear = (year === 'all') || (trYear === year);
                    const matchMonth = (month === 'all') || (trMonth === month);

                    if (matchQuery && matchYear && matchMonth) {
                        tr.style.display = '';
                        visible++;
                    } else {
                        tr.style.display = 'none';
                    }
                });
                document.getElementById(countId).textContent = visible;
                document.getElementById(emptyId).style.display = visible === 0 ? 'block' : 'none';
            }

            function filterBookings() {
                applyTableFilter('bookTbody', 'bookSearch', 'bookYear', 'bookMonth', 'bookCount', 'bookEmpty');
            }
            function filterDonations() {
                applyTableFilter('donTbody', 'donSearch', 'donYear', 'donMonth', 'donCount', 'donEmpty');
            }

            // Init: bina dropdown tahun dari data sedia ada
            buildYearDropdown('bookTbody', 'bookYear');
            buildYearDropdown('donTbody', 'donYear');

            // Init filter sekali untuk update counter dengan jumlah baris sebenar
            filterBookings();
            filterDonations();
        </script>
    </body>
</html>
