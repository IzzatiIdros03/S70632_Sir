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
        <title>Dashboard Koordinator - MMS</title>
        <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
        <style>
            :root{
                --primary:#1a3a6b;
                --primary-dark:#0f2447;
                --primary-mid:#1e4a8a;
                --primary-light:#2563b8;
                --primary-pale:#e8eef8;
                --accent:#3b7dd8;
                --sidebar-bg:#0f2447;
                --sidebar-hover:rgba(255,255,255,0.07);
                --sidebar-active:rgba(59,125,216,0.18);
                --sidebar-border:rgba(255,255,255,0.08);
                --bg:#f0f3f9;
                --bg-card:#ffffff;
                --bg-secondary:#f5f7fc;
                --border:#dde3ee;
                --border-light:#eaeff8;
                --text:#1a2540;
                --text-secondary:#64748b;
                --text-muted:#94a3b8;
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
                --shadow:0 1px 3px rgba(15,36,71,0.08),0 1px 2px rgba(15,36,71,0.04);
                --shadow-md:0 4px 16px rgba(15,36,71,0.1);
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

            /* SIDEBAR */
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
                background:radial-gradient(circle,rgba(59,125,216,0.12) 0%,transparent 70%);
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
                background:linear-gradient(135deg,var(--accent),#1a56a8);
                display:flex;
                align-items:center;
                justify-content:center;
                box-shadow:0 2px 8px rgba(59,125,216,0.35);
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
                color:var(--accent);
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
            .nav-pill{
                margin-left:auto;
                font-size:9px;
                font-weight:600;
                background:rgba(220,38,38,0.15);
                color:#f87171;
                padding:2px 7px;
                border-radius:10px;
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
                background:linear-gradient(135deg,var(--accent),#1a56a8);
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

            /* PAGE */
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
            .stats-row.col6{
                grid-template-columns:repeat(6,1fr);
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
                background:var(--primary-light);
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

            /* FILTER */
            .filter-wrap{
                padding:14px 18px;
                border-bottom:1px solid var(--border-light);
                display:flex;
                align-items:flex-end;
                gap:12px;
                flex-wrap:wrap;
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
            .fg input{
                padding:7px 11px;
                border-radius:var(--radius-sm);
                border:1px solid var(--border);
                font-size:13px;
                font-family:var(--font);
                background:var(--bg-card);
                color:var(--text);
            }
            .fg input:focus{
                outline:none;
                border-color:var(--accent);
            }
            .btn-filter{
                padding:8px 16px;
                background:var(--primary-light);
                color:#fff;
                border:none;
                border-radius:var(--radius-sm);
                font-size:12px;
                font-weight:500;
                cursor:pointer;
                font-family:var(--font);
                display:flex;
                align-items:center;
                gap:6px;
            }
            .btn-filter:hover{
                background:var(--primary-mid);
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
            .uid{
                font-size:10px;
                color:var(--text-muted);
                font-family:var(--font-mono);
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
            .b-upcoming{
                background:var(--blue-bg);
                color:var(--blue);
            }
            .b-ongoing{
                background:var(--amber-bg);
                color:var(--amber);
            }
            .b-completed{
                background:var(--slate-bg);
                color:var(--slate);
            }
            .b-viewonly{
                background:var(--red-bg);
                color:var(--red);
                font-size:10px;
            }
            .b-pending-req{
                background:var(--blue-bg);
                color:var(--blue);
            }

            /* CHARTS */
            .charts-grid{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:16px;
                margin-bottom:20px;
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
                box-shadow:0 0 0 3px rgba(26,58,107,.08);
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
            /* Chart header dengan filter */
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
                color:var(--primary-dark);
                box-shadow:0 1px 3px rgba(0,0,0,.08);
            }
            .chart-wrap{
                position:relative;
                height:180px;
            }

            /* VIEW BANNER */
            .view-banner{
                display:flex;
                align-items:center;
                gap:10px;
                padding:11px 16px;
                background:#fef9f0;
                border:1px solid #fde68a;
                border-radius:var(--radius);
                font-size:12.5px;
                color:var(--amber);
                margin-bottom:18px;
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
                transition:all 0.15s;
            }
            .btn-lulus{
                background:var(--green-bg);
                color:var(--green);
            }
            .btn-lulus:hover{
                background:#bbf7d0;
            }
            .btn-tolak{
                background:var(--red-bg);
                color:var(--red);
            }
            .btn-tolak:hover{
                background:#fecaca;
            }

            @media print{
                .sidebar,.topbar,.filter-wrap,.acts,.btn-print,.btn-logout{
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
                .stats-row.col6{
                    grid-template-columns:repeat(3,1fr);
                }
                .stats-row.col4{
                    grid-template-columns:repeat(2,1fr);
                }
                .charts-grid{
                    grid-template-columns:1fr;
                }
            }
        </style>
    </head>
    <body>
        <div class="layout">

            <!-- SIDEBAR -->
            <aside class="sidebar">
                <div class="sidebar-brand">
                    <div class="brand-icon">
                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.2"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                    </div>
                    <div>
                        <div class="brand-name">MMS</div>
                        <div class="brand-role">Coordinator</div>
                    </div>
                </div>

                <div class="nav-section-label">Modul Utama</div>
                <div class="nav-item" onclick="showPage('tempahan', this)">
                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                    Pengurusan Tempahan
                </div>
                <a href="${pageContext.request.contextPath}/coordinator/activity" class="nav-item">
                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/></svg>
                    Pengurusan Aktiviti
                </a>

                <div class="nav-divider"></div>
                <div class="nav-section-label">Laporan &amp; Lihat</div>
                <div class="nav-item active" onclick="showPage('laporan', this)">
                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                    Laporan Koordinator
                </div>
                <div class="nav-item" onclick="showPage('kewangan', this)">
                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
                    Laporan Kewangan
                    <span class="nav-pill">View</span>
                </div>

                <div class="sidebar-footer">
                    <div class="footer-av">${currentUser.name.substring(0,1).toUpperCase()}</div>
                    <div>
                        <div class="footer-name">${currentUser.name}</div>
                        <div class="footer-role">Coordinator</div>
                    </div>
                </div>
            </aside>

            <!-- MAIN -->
            <div class="main">
                <header class="topbar">
                    <div class="topbar-title" id="page-title">Laporan Koordinator</div>
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

                    <!-- ══════ PAGE: LAPORAN KOORDINATOR ══════ -->
                    <div class="page active" id="page-laporan">

                        <div class="stats-row col6">
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#fef3c7"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#b45309" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
                                <div><div class="stat-val">${pendingBookings}</div><div class="stat-lbl">Tempahan Menunggu</div></div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#dcfce7"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#15803d" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg></div>
                                <div><div class="stat-val">${approvedBookings}</div><div class="stat-lbl">Tempahan Diluluskan</div></div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#dbeafe"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#1d4ed8" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg></div>
                                <div><div class="stat-val">${totalBookings}</div><div class="stat-lbl">Jumlah Tempahan</div></div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#e0e7ff"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#4338ca" stroke-width="2"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
                                <div><div class="stat-val">${totalEvents}</div><div class="stat-lbl">Jumlah Aktiviti</div></div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#dcfce7"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#15803d" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg></div>
                                <div><div class="stat-val" style="font-size:14px;">RM <fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></div><div class="stat-lbl">Jumlah Hasil</div></div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#fce7f3"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#9d174d" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="16"/><line x1="8" y1="12" x2="16" y2="12"/></svg></div>
                                <div><div class="stat-val">${pendingEvents}</div><div class="stat-lbl">Aktiviti Pending</div></div>
                            </div>
                        </div>

                        <div class="charts-grid">
                            <div class="chart-card">
                                <div class="chart-head-row">
                                    <div class="chart-title">Bilangan Tempahan</div>
                                    <div class="fb-group">
                                        <button class="fb-btn active" onclick="setChartFilter('book', 'bulan', this)">Bulan</button>
                                        <button class="fb-btn" onclick="setChartFilter('book', 'tahun', this)">Tahun</button>
                                    </div>
                                </div>
                                <div class="chart-wrap"><canvas id="cBookingMonth"></canvas></div>
                            </div>
                            <div class="chart-card">
                                <div class="chart-head-row">
                                    <div class="chart-title">Hasil Tempahan (RM)</div>
                                    <div class="fb-group">
                                        <button class="fb-btn active" onclick="setChartFilter('rev', 'bulan', this)">Bulan</button>
                                        <button class="fb-btn" onclick="setChartFilter('rev', 'tahun', this)">Tahun</button>
                                    </div>
                                </div>
                                <div class="chart-wrap"><canvas id="cRevenueMonth"></canvas></div>
                            </div>
                        </div>

                        <!-- Rekod Tempahan Terkini -->
                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Rekod Tempahan Terkini</div>
                                <span class="count-chip">${totalBookings} rekod</span>
                            </div>
                            <div class="filter-wrap">
                                <form action="${pageContext.request.contextPath}/admin/report" method="get" style="display:flex;align-items:flex-end;gap:12px;flex-wrap:wrap;">
                                    <div class="fg"><label>Tarikh Mula</label><input type="date" name="startDate" value="${startDate}"></div>
                                    <div class="fg"><label>Tarikh Tamat</label><input type="date" name="endDate" value="${endDate}"></div>
                                    <button type="submit" class="btn-filter">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>
                                        Tapis
                                    </button>
                                </form>
                            </div>
                            <div class="table-wrap">
                                <table>
                                    <thead><tr><th>ID</th><th>Pemohon</th><th>Fasiliti</th><th>Sesi</th><th>Tarikh Mula</th><th>Tarikh Tamat</th><th>Hari</th><th>Jumlah (RM)</th><th>Status</th><th>Tindakan</th></tr></thead>
                                    <tbody>
                                        <c:set var="bookingList" value="${not empty filteredBookings ? filteredBookings : allBookings}"/>
                                        <c:forEach items="${bookingList}" var="b">
                                            <tr>
                                                <td><span style="font-family:var(--font-mono);font-size:12px">#${b.bookingId}</span></td>
                                                <td><div style="font-weight:500;">${b.userName}</div><div class="uid">#${b.userId}</div></td>
                                                <td style="color:var(--primary-light);font-weight:500;">${b.facilityName}</td>
                                                <td style="font-size:12px;color:var(--text-secondary);">
                                                    <c:choose><c:when test="${b.sessionType=='HALF_DAY'}">½ Hari</c:when><c:otherwise>Sehari</c:otherwise></c:choose>
                                                        </td>
                                                            <td>${b.startDate}</td>
                                                <td>${b.endDate}</td>
                                                <td style="text-align:center;font-family:var(--font-mono);">${b.totalDays}</td>
                                                <td style="font-family:var(--font-mono);font-weight:600;"><fmt:formatNumber value="${b.totalAmount}" pattern="#,##0.00"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${b.status=='APPROVED'}"><span class="badge b-approved">Diluluskan</span></c:when>
                                                        <c:when test="${b.status=='PENDING'}"><span class="badge b-pending">Menunggu</span></c:when>
                                                        <c:when test="${b.status=='REJECTED'}"><span class="badge b-rejected">Ditolak</span></c:when>
                                                        <c:otherwise><span class="badge b-canceled">Dibatalkan</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${b.status=='PENDING'}">
                                                        <div class="acts">
                                                            <form action="${pageContext.request.contextPath}/admin/booking/updateStatus" method="post" style="display:inline;">
                                                                <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                                <input type="hidden" name="status" value="APPROVED">
                                                                <button type="submit" class="btn-sm btn-lulus">Lulus</button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/admin/booking/updateStatus" method="post" style="display:inline;">
                                                                <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                                <input type="hidden" name="status" value="REJECTED">
                                                                <button type="submit" class="btn-sm btn-tolak">Tolak</button>
                                                            </form>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${b.status!='PENDING'}"><span style="color:var(--text-muted);font-size:12px;">—</span></c:if>
                                                    </td>
                                                </tr>
                                        </c:forEach>
                                        <c:if test="${empty bookingList}">
                                            <tr><td colspan="10" class="empty-row">Tiada rekod. Sila tapis tarikh untuk melihat rekod.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                            <c:if test="${not empty filteredBookings}">
                                <div style="padding:12px 18px;background:var(--bg-secondary);border-top:1px solid var(--border-light);display:flex;gap:20px;font-size:12px;color:var(--text-secondary);">
                                    <span><strong style="color:var(--text);">${filteredBookings.size()}</strong> rekod dijumpai</span>
                                    <span>Jumlah: <strong style="color:var(--text);font-family:var(--font-mono);">RM <fmt:formatNumber value="${filteredRevenue}" pattern="#,##0.00"/></strong></span>
                                </div>
                            </c:if>
                        </div>

                        <!-- Aktiviti -->
                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Aktiviti Berdaftar</div>
                                <span class="count-chip">${totalEvents} aktiviti</span>
                            </div>
                            <div class="table-wrap">
                                <table>
                                    <thead><tr><th>ID</th><th>Nama Aktiviti</th><th>Pemohon</th><th>Tarikh</th><th>Lokasi</th><th>Status</th><th>Kelulusan</th></tr></thead>
                                    <tbody>
                                        <c:forEach items="${allEvents}" var="ev">
                                            <tr>
                                                <td><span style="font-family:var(--font-mono);font-size:12px">#${ev.eventId}</span></td>
                                                <td style="font-weight:500;">${ev.name}</td>
                                                <td><div>${not empty ev.userName ? ev.userName : 'Koordinator'}</div></td>
                                                <td>${ev.date}</td>
                                                <td style="color:var(--text-secondary);font-size:12px;">${not empty ev.location ? ev.location : '—'}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${ev.status=='ONGOING'}"><span class="badge b-ongoing">Berlangsung</span></c:when>
                                                        <c:when test="${ev.status=='COMPLETED'}"><span class="badge b-completed">Selesai</span></c:when>
                                                        <c:otherwise><span class="badge b-upcoming">Akan Datang</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${ev.requestStatus=='PENDING_APPROVAL'}"><span class="badge b-pending-req">Menunggu</span></c:when>
                                                        <c:when test="${ev.requestStatus=='APPROVED'}"><span class="badge b-approved">Diluluskan</span></c:when>
                                                        <c:otherwise><span class="badge b-rejected">Ditolak</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty allEvents}">
                                            <tr><td colspan="7" class="empty-row">Tiada rekod aktiviti.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div><!-- /page-laporan -->

                    <!-- ══════ PAGE: LAPORAN KEWANGAN (VIEW ONLY) ══════ -->
                    <div class="page" id="page-kewangan">

                        <div class="view-banner">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            Anda hanya boleh <strong style="margin:0 3px">melihat</strong> laporan ini. Pengurusan kewangan dikendalikan sepenuhnya oleh Bendahari.
                        </div>

                        <div class="stats-row col4">
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#dcfce7"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#15803d" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg></div>
                                <div><div class="stat-val" style="font-size:14px;">RM <fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></div><div class="stat-lbl">Hasil Tempahan</div></div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#dbeafe"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#1d4ed8" stroke-width="2"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg></div>
                                <div><div class="stat-val">${approvedBookings}</div><div class="stat-lbl">Bayaran Tempahan</div></div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#fce7f3"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#9d174d" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg></div>
                                <div><div class="stat-val" style="font-size:14px;">RM <fmt:formatNumber value="${totalDonation}" pattern="#,##0.00"/></div><div class="stat-lbl">Jumlah Sumbangan</div></div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background:#e0e7ff"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#4338ca" stroke-width="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg></div>
                                <div><div class="stat-val" style="font-size:13px;">RM <fmt:formatNumber value="${totalRevenue + totalDonation}" pattern="#,##0.00"/></div><div class="stat-lbl">Jumlah Keseluruhan</div></div>
                            </div>
                        </div>

                        <div class="charts-grid">
                            <div class="chart-card">
                                <div class="chart-head-row">
                                    <div class="chart-title">Graf Bayaran Tempahan (RM)</div>
                                    <div class="fb-group">
                                        <button class="fb-btn active" onclick="setChartFilter('rev', 'bulan', this)">Bulan</button>
                                        <button class="fb-btn" onclick="setChartFilter('rev', 'tahun', this)">Tahun</button>
                                    </div>
                                </div>
                                <div class="chart-wrap"><canvas id="cKewBayaran"></canvas></div>
                            </div>
                            <div class="chart-card">
                                <div class="chart-head-row">
                                    <div class="chart-title">Graf Sumbangan / Derma (RM)</div>
                                    <div class="fb-group">
                                        <button class="fb-btn active" onclick="setChartFilter('don', 'bulan', this)">Bulan</button>
                                        <button class="fb-btn" onclick="setChartFilter('don', 'tahun', this)">Tahun</button>
                                    </div>
                                </div>
                                <div class="chart-wrap"><canvas id="cKewSumbangan"></canvas></div>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Senarai Bayaran Tempahan</div>
                                <div class="card-meta">
                                    <span class="badge b-viewonly">View Only</span>
                                    <span class="count-chip"><span id="bookCount">${approvedBookings}</span> rekod</span>
                                </div>
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
                                    <thead><tr><th>Ref</th><th>Pemohon</th><th>Fasiliti</th><th>Tarikh</th><th>Jumlah</th><th>Status Bayaran</th></tr></thead>
                                    <tbody id="bookTbody">
                                        <c:forEach items="${allBookings}" var="b">
                                            <c:if test="${b.status=='APPROVED' or b.status=='PAID'}">
                                                <tr data-search="${b.bookingId} ${b.userName} ${b.facilityName}" data-date="${b.startDate}">
                                                    <td><span style="font-family:var(--font-mono);font-size:12px">#${b.bookingId}</span></td>
                                                    <td>${b.userName}</td>
                                                    <td style="color:var(--primary-light);">${b.facilityName}</td>
                                                    <td>${b.startDate}</td>
                                                    <td style="font-family:var(--font-mono);">RM <fmt:formatNumber value="${b.totalAmount}" pattern="#,##0.00"/></td>
                                                    <td><span class="badge b-approved">Dibayar</span></td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <div id="bookEmpty" class="empty-filter" style="display:none;">
                                    <i>🔍</i> Tiada rekod sepadan dengan carian/filter anda.
                                </div>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Senarai Sumbangan / Derma</div>
                                <div class="card-meta">
                                    <span class="badge b-viewonly">View Only</span>
                                    <span class="count-chip"><span id="donCount">${totalDonationRecords}</span> rekod</span>
                                </div>
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
                                    <thead><tr><th>#</th><th>Penderma</th><th>Jenis</th><th>Kaedah</th><th>Tarikh</th><th>Jumlah</th><th>Catatan</th></tr></thead>
                                    <tbody id="donTbody">
                                        <c:forEach items="${allDonations}" var="d" varStatus="s">
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
                                        <c:if test="${empty allDonations}">
                                            <tr><td colspan="7" class="empty-row">Tiada rekod sumbangan.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                                <div id="donEmpty" class="empty-filter" style="display:none;">
                                    <i>🔍</i> Tiada rekod sepadan dengan carian/filter anda.
                                </div>
                            </div>
                        </div>

                    </div><!-- /page-kewangan -->

                    <!-- ══════ PAGE: PENGURUSAN TEMPAHAN ══════ -->
                    <div class="page" id="page-tempahan">
                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Semua Tempahan</div>
                                <span class="count-chip">${totalBookings} rekod</span>
                            </div>
                            <div class="table-wrap">
                                <table>
                                    <thead><tr><th>ID</th><th>Pemohon</th><th>Fasiliti</th><th>Tarikh Mula</th><th>Tarikh Tamat</th><th>Sesi</th><th>Jumlah</th><th>Status</th><th>Tindakan</th></tr></thead>
                                    <tbody>
                                        <c:forEach items="${allBookings}" var="b">
                                            <tr>
                                                <td><span style="font-family:var(--font-mono);font-size:12px">#${b.bookingId}</span></td>
                                                <td><div style="font-weight:500;">${b.userName}</div><div class="uid">#${b.userId}</div></td>
                                                <td style="color:var(--primary-light);font-weight:500;">${b.facilityName}</td>
                                                <td>${b.startDate}</td>
                                                <td>${b.endDate}</td>
                                                <td style="font-size:12px;"><c:choose><c:when test="${b.sessionType=='HALF_DAY'}">½ Hari</c:when><c:otherwise>Sehari</c:otherwise></c:choose></td>
                                                <td style="font-family:var(--font-mono);">RM <fmt:formatNumber value="${b.totalAmount}" pattern="#,##0.00"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${b.status=='APPROVED'}"><span class="badge b-approved">Diluluskan</span></c:when>
                                                        <c:when test="${b.status=='PENDING'}"><span class="badge b-pending">Menunggu</span></c:when>
                                                        <c:when test="${b.status=='REJECTED'}"><span class="badge b-rejected">Ditolak</span></c:when>
                                                        <c:otherwise><span class="badge b-canceled">Dibatalkan</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${b.status=='PENDING'}">
                                                        <div class="acts">
                                                            <form action="${pageContext.request.contextPath}/admin/booking/updateStatus" method="post" style="display:inline;">
                                                                <input type="hidden" name="bookingId" value="${b.bookingId}"><input type="hidden" name="status" value="APPROVED">
                                                                <button type="submit" class="btn-sm btn-lulus">Lulus</button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/admin/booking/updateStatus" method="post" style="display:inline;">
                                                                <input type="hidden" name="bookingId" value="${b.bookingId}"><input type="hidden" name="status" value="REJECTED">
                                                                <button type="submit" class="btn-sm btn-tolak">Tolak</button>
                                                            </form>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${b.status!='PENDING'}"><span style="color:var(--text-muted);font-size:12px;">—</span></c:if>
                                                    </td>
                                                </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div><!-- /page-tempahan -->

                </div><!-- /content -->
            </div><!-- /main -->
        </div><!-- /layout -->

        <script>
            const PAGE_TITLES = {laporan: 'Laporan Koordinator', kewangan: 'Laporan Kewangan', tempahan: 'Pengurusan Tempahan'};
            function showPage(id, el) {
                document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
                document.querySelectorAll('.nav-item').forEach(n => {
                    if (!n.tagName || n.tagName !== 'A')
                        n.classList.remove('active');
                });
                document.getElementById('page-' + id).classList.add('active');
                if (el && el.tagName !== 'A')
                    el.classList.add('active');
                document.getElementById('page-title').textContent = PAGE_TITLES[id] || id;
            }

            // Real data from controller — 4 mode untuk setiap chart
            const bmLabels = ${bookingMonthLabels};
            const bmData = ${bookingMonthData};

            const BOOK_DATA = {
                hari: {labels: ${bookingDayLabels}, data: ${bookingDayData}},
                minggu: {labels: ${bookingWeekLabels}, data: ${bookingWeekData}},
                bulan: {labels: ${bookingMonthLabels}, data: ${bookingMonthData}},
                tahun: {labels: ${bookingYearLabels}, data: ${bookingYearData}}
            };

            const REV_DATA = {
                hari: {labels: ${revenueDayLabels}, data: ${revenueDayData}},
                minggu: {labels: ${revenueWeekLabels}, data: ${revenueWeekData}},
                bulan: {labels: ${revenueMonthLabels}, data: ${revenueMonthData}},
                tahun: {labels: ${revenueYearLabels}, data: ${revenueYearData}}
            };
            const DON_DATA = {
                hari: {labels: ${donDayLabels}, data: ${donDayData}},
                minggu: {labels: ${donWeekLabels}, data: ${donWeekData}},
                bulan: {labels: ${donMonthLabels}, data: ${donMonthData}},
                tahun: {labels: ${donYearLabels}, data: ${donYearData}}
            };

            // BIRU MUDA palette untuk chart (page kekal navy biru)
            const C = {blue: '#93c5fd', dark: '#60a5fa', green: '#86efac', amber: '#fcd34d', grid: '#dbeafe', tick: '#94a3b8'};

            // Chart instance cache
            const chartInstances = {};

            function barChart(id, labels, data, color) {
                const ctx = document.getElementById(id);
                if (!ctx)
                    return;
                if (chartInstances[id])
                    chartInstances[id].destroy();
                chartInstances[id] = new Chart(ctx, {type: 'bar',
                    data: {labels: labels.length ? labels : ['—'], datasets: [{data: data.length ? data : [0],
                                backgroundColor: color + '99', borderColor: color, borderWidth: 1.5, borderRadius: 6, label: ''}]},
                    options: {responsive: true, maintainAspectRatio: false,
                        plugins: {legend: {display: false}},
                        scales: {x: {grid: {display: false}, ticks: {font: {size: 10}, color: C.tick}},
                            y: {beginAtZero: true, grid: {color: C.grid}, ticks: {font: {size: 10}, color: C.tick}}}}
                });
            }
            function lineChart(id, labels, data, color) {
                const ctx = document.getElementById(id);
                if (!ctx)
                    return;
                if (chartInstances[id])
                    chartInstances[id].destroy();
                chartInstances[id] = new Chart(ctx, {type: 'line',
                    data: {labels: labels.length ? labels : ['—'], datasets: [{data: data.length ? data : [0],
                                borderColor: color, backgroundColor: color + '20', borderWidth: 2, pointBackgroundColor: color,
                                pointRadius: 4, fill: true, tension: 0.4, label: ''}]},
                    options: {responsive: true, maintainAspectRatio: false,
                        plugins: {legend: {display: false}},
                        scales: {x: {grid: {display: false}, ticks: {font: {size: 10}, color: C.tick}},
                            y: {beginAtZero: true, grid: {color: C.grid}, ticks: {font: {size: 10}, color: C.tick}}}}
                });
            }

            // ===== Render chart dengan filter =====
            function renderBookChart(mode) {
                const d = BOOK_DATA[mode] || BOOK_DATA.bulan;
                barChart('cBookingMonth', d.labels, d.data.map(v => parseInt(v)), C.blue);
            }
            function renderRevChart(mode) {
                const d = REV_DATA[mode] || REV_DATA.bulan;
                lineChart('cRevenueMonth', d.labels, d.data.map(v => parseFloat(v)), C.green);
                barChart('cKewBayaran', d.labels, d.data.map(v => parseFloat(v)), C.blue);
            }
            function renderDonChart(mode) {
                const d = DON_DATA[mode] || DON_DATA.bulan;
                barChart('cKewSumbangan', d.labels, d.data.map(v => parseFloat(v)), C.amber);
            }

            // ===== Filter handler =====
            function setChartFilter(chartKey, mode, btnEl) {
                const group = btnEl.parentElement;
                group.querySelectorAll('.fb-btn').forEach(b => b.classList.remove('active'));
                btnEl.classList.add('active');
                if (chartKey === 'book')
                    renderBookChart(mode);
                if (chartKey === 'rev')
                    renderRevChart(mode);
                if (chartKey === 'don')
                    renderDonChart(mode);
            }

            // Initial render
            renderBookChart('bulan');
            renderRevChart('bulan');
            renderDonChart('bulan');

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
