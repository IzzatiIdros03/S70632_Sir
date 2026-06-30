<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="currentUser" scope="session" type="model.User" />
<jsp:useBean id="nowDate" class="java.util.Date" scope="request"/>
<!DOCTYPE html>
<html lang="ms">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Pengurusan Aktiviti - MMS</title>
        <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --primary: #1a3a6b;
                --primary-dark: #0f2447;
                --primary-mid: #1e4a8a;
                --primary-light: #2563b8;
                --primary-pale: #e8eef8;
                --accent: #3b7dd8;
                --sidebar-bg: #0f2447;
                --sidebar-hover: rgba(255,255,255,0.07);
                --sidebar-active: rgba(59,125,216,0.18);
                --sidebar-border: rgba(255,255,255,0.08);
                --bg: #f0f3f9;
                --bg-card: #ffffff;
                --bg-secondary: #f5f7fc;
                --border: #dde3ee;
                --border-light: #eaeff8;
                --text: #1a2540;
                --text-secondary: #64748b;
                --text-muted: #94a3b8;
                --green: #15803d;
                --green-bg: #dcfce7;
                --amber: #b45309;
                --amber-bg: #fef3c7;
                --red: #b91c1c;
                --red-bg: #fee2e2;
                --slate: #475569;
                --slate-bg: #f1f5f9;
                --blue: #1d4ed8;
                --blue-bg: #dbeafe;
                --purple: #7e22ce;
                --purple-bg: #f3e8ff;
                --radius: 10px;
                --radius-sm: 6px;
                --radius-lg: 14px;
                --shadow: 0 1px 3px rgba(15,36,71,0.08), 0 1px 2px rgba(15,36,71,0.04);
                --shadow-md: 0 4px 16px rgba(15,36,71,0.1);
                --font: 'DM Sans', sans-serif;
                --font-mono: 'DM Mono', monospace;
            }
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: var(--font);
                background: var(--bg);
                color: var(--text);
                font-size: 14px;
                line-height: 1.5;
            }
            .layout {
                display: flex;
                height: 100vh;
                overflow: hidden;
            }

            /* ── SIDEBAR ── */
            .sidebar {
                width: 230px;
                min-width: 230px;
                background: var(--sidebar-bg);
                display: flex;
                flex-direction: column;
                border-right: 1px solid rgba(255,255,255,0.04);
                position: relative;
                overflow: hidden;
            }
            .sidebar::before {
                content: '';
                position: absolute;
                top: -60px;
                right: -60px;
                width: 180px;
                height: 180px;
                border-radius: 50%;
                background: radial-gradient(circle, rgba(59,125,216,0.12) 0%, transparent 70%);
                pointer-events: none;
            }
            .sidebar-brand {
                padding: 20px 18px 16px;
                border-bottom: 1px solid var(--sidebar-border);
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .brand-icon {
                width: 34px;
                height: 34px;
                border-radius: 9px;
                background: linear-gradient(135deg, var(--accent), #1a56a8);
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 2px 8px rgba(59,125,216,0.35);
                flex-shrink: 0;
            }
            .brand-name {
                color: #fff;
                font-size: 14px;
                font-weight: 600;
            }
            .brand-role {
                font-size: 9px;
                font-weight: 600;
                letter-spacing: 1.2px;
                color: var(--accent);
                text-transform: uppercase;
                margin-top: 1px;
            }
            .nav-section-label {
                padding: 14px 18px 5px;
                font-size: 9.5px;
                font-weight: 600;
                letter-spacing: 1px;
                color: rgba(255,255,255,0.25);
                text-transform: uppercase;
            }
            .nav-item {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 9px 18px;
                cursor: pointer;
                color: rgba(255,255,255,0.55);
                font-size: 13px;
                font-weight: 400;
                border-left: 2px solid transparent;
                transition: all 0.15s;
                text-decoration: none;
            }
            .nav-item:hover {
                background: var(--sidebar-hover);
                color: rgba(255,255,255,0.85);
            }
            .nav-item.active {
                background: var(--sidebar-active);
                color: #fff;
                font-weight: 500;
                border-left-color: var(--accent);
            }
            .nav-icon {
                width: 15px;
                height: 15px;
                flex-shrink: 0;
                opacity: 0.7;
            }
            .nav-item.active .nav-icon, .nav-item:hover .nav-icon {
                opacity: 1;
            }
            .nav-pill {
                margin-left: auto;
                font-size: 9px;
                font-weight: 600;
                background: rgba(220,38,38,0.15);
                color: #f87171;
                padding: 2px 7px;
                border-radius: 10px;
            }
            .nav-divider {
                height: 1px;
                background: var(--sidebar-border);
                margin: 8px 18px;
            }
            .sidebar-footer {
                margin-top: auto;
                padding: 14px 18px;
                border-top: 1px solid var(--sidebar-border);
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .footer-av {
                width: 32px;
                height: 32px;
                border-radius: 50%;
                background: linear-gradient(135deg, var(--accent), #1a56a8);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                font-weight: 600;
                color: #fff;
                flex-shrink: 0;
            }
            .footer-name {
                color: #fff;
                font-size: 12px;
                font-weight: 500;
            }
            .footer-role {
                color: rgba(255,255,255,0.35);
                font-size: 10px;
            }

            /* ── MAIN ── */
            .main {
                flex: 1;
                display: flex;
                flex-direction: column;
                overflow: hidden;
            }
            .topbar {
                background: var(--bg-card);
                border-bottom: 1px solid var(--border);
                padding: 0 24px;
                height: 54px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                flex-shrink: 0;
            }
            .topbar-title {
                font-size: 15px;
                font-weight: 600;
                color: var(--text);
            }
            .topbar-right {
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .topbar-chip {
                display: flex;
                align-items: center;
                gap: 6px;
                background: var(--bg-secondary);
                border: 1px solid var(--border);
                padding: 5px 11px;
                border-radius: 20px;
                font-size: 12px;
                color: var(--text-secondary);
            }
            .btn-topbar {
                display: flex;
                align-items: center;
                gap: 6px;
                background: var(--bg-secondary);
                border: 1px solid var(--border);
                padding: 5px 11px;
                border-radius: 20px;
                font-size: 12px;
                color: var(--text-secondary);
                cursor: pointer;
                font-family: var(--font);
                transition: all 0.15s;
                text-decoration: none;
            }
            .btn-topbar:hover {
                border-color: var(--accent);
                color: var(--accent);
            }
            .btn-logout {
                display: flex;
                align-items: center;
                gap: 6px;
                background: #fee2e2;
                border: 1px solid #fca5a5;
                padding: 5px 11px;
                border-radius: 20px;
                font-size: 12px;
                color: #b91c1c;
                font-weight: 500;
                cursor: pointer;
                font-family: var(--font);
                text-decoration: none;
            }
            .btn-logout:hover {
                background: #fecaca;
            }
            .content {
                flex: 1;
                overflow-y: auto;
                padding: 24px;
            }

            /* ── ALERTS ── */
            .alert {
                padding: 12px 16px;
                border-radius: var(--radius);
                margin-bottom: 18px;
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 13px;
                font-weight: 500;
            }
            .a-ok  {
                background: var(--green-bg);
                color: #065f46;
                border: 1px solid #6ee7b7;
            }
            .a-err {
                background: var(--red-bg);
                color: var(--red);
                border: 1px solid #fca5a5;
            }

            /* ── STATS ── */
            .stats-row {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 14px;
                margin-bottom: 22px;
            }
            .stat-card {
                background: var(--bg-card);
                border: 1px solid var(--border);
                border-radius: var(--radius-lg);
                padding: 16px 18px;
                display: flex;
                align-items: center;
                gap: 13px;
                box-shadow: var(--shadow);
            }
            .stat-icon {
                width: 38px;
                height: 38px;
                border-radius: var(--radius);
                display: flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
            }
            .stat-val {
                font-size: 20px;
                font-weight: 600;
                line-height: 1.2;
                color: var(--text);
            }
            .stat-lbl {
                font-size: 11px;
                color: var(--text-secondary);
                margin-top: 3px;
            }

            /* ── CARD ── */
            .card {
                background: var(--bg-card);
                border: 1px solid var(--border);
                border-radius: var(--radius-lg);
                overflow: hidden;
                box-shadow: var(--shadow);
                margin-bottom: 20px;
            }
            .card-header {
                padding: 14px 18px;
                border-bottom: 1px solid var(--border-light);
                display: flex;
                align-items: center;
                justify-content: space-between;
                flex-wrap: wrap;
                gap: 10px;
            }
            .card-title {
                font-size: 13px;
                font-weight: 600;
                color: var(--text);
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .card-title::before {
                content: '';
                display: block;
                width: 3px;
                height: 14px;
                background: var(--accent);
                border-radius: 2px;
            }
            .count-chip {
                font-size: 11px;
                background: var(--bg-secondary);
                border: 1px solid var(--border);
                padding: 2px 9px;
                border-radius: 10px;
                color: var(--text-secondary);
            }
            /* FILTER BAR */
            .filter-bar{
                display:flex;
                gap:8px;
                padding:10px 18px;
                background:var(--bg-secondary);
                border-bottom:1px solid var(--border-light);
                flex-wrap:wrap;
                align-items:center;
            }
            .filter-bar .search-box{
                position:relative;
                flex:1;
                min-width:200px;
            }
            .filter-bar .search-box .search-ic{
                position:absolute;
                left:10px;
                top:50%;
                transform:translateY(-50%);
                font-size:11px;
                color:var(--text-muted);
                font-style:normal;
                pointer-events:none;
            }
            .filter-bar .search-box input{
                width:100%;
                padding:7px 12px 7px 30px;
                border-radius:8px;
                border:1px solid var(--border);
                background:#fff;
                font-family:inherit;
                font-size:12px;
                color:var(--text);
                transition:all .2s;
            }
            .filter-bar .search-box input:focus{
                outline:none;
                border-color:var(--primary);
                box-shadow:0 0 0 3px rgba(26,58,107,.08);
            }
            .filter-select{
                padding:7px 11px;
                border-radius:8px;
                border:1px solid var(--border);
                background:#fff;
                font-family:inherit;
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
            .card-body {
                padding: 18px;
            }

            /* ── FORM ── */
            .form-row {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
                gap: 12px;
            }
            .fg label {
                display: block;
                font-size: 11px;
                font-weight: 600;
                color: var(--text-secondary);
                margin-bottom: 5px;
                text-transform: uppercase;
                letter-spacing: 0.4px;
            }
            .fg input, .fg select, .fg textarea {
                width: 100%;
                padding: 8px 11px;
                border-radius: var(--radius-sm);
                border: 1.5px solid var(--border);
                font-size: 13px;
                font-family: var(--font);
                background: var(--bg-secondary);
                color: var(--text);
                transition: all 0.2s;
            }
            .fg input:focus, .fg select:focus, .fg textarea:focus {
                outline: none;
                border-color: var(--accent);
                background: #fff;
                box-shadow: 0 0 0 3px rgba(59,125,216,0.1);
            }
            .fg textarea {
                resize: vertical;
                min-height: 60px;
            }
            .fg.full {
                grid-column: 1 / -1;
            }
            .btn-add {
                padding: 9px 18px;
                background: linear-gradient(135deg, var(--accent), var(--primary-dark));
                color: #fff;
                border: none;
                border-radius: var(--radius-sm);
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                font-family: var(--font);
                display: flex;
                align-items: center;
                gap: 7px;
                transition: all 0.2s;
                margin-top: 14px;
            }
            .btn-add:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(59,125,216,0.3);
            }

            /* ── TABLE ── */
            .table-wrap {
                overflow-x: auto;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                font-size: 12.5px;
            }
            thead tr {
                background: var(--bg-secondary);
                border-bottom: 2px solid var(--border);
            }
            th {
                padding: 11px 14px;
                text-align: left;
                font-size: 11px;
                font-weight: 700;
                color: var(--text-muted);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                white-space: nowrap;
            }
            td {
                padding: 12px 14px;
                border-bottom: 1px solid var(--border-light);
                vertical-align: middle;
            }
            tr:hover td {
                background: var(--bg-secondary);
            }
            tr:last-child td {
                border-bottom: none;
            }

            /* ── BADGES ── */
            .badge {
                padding: 3px 9px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 700;
            }
            .b-up   {
                background: #e8eef8;
                color: var(--primary-dark);
            }
            .b-on   {
                background: var(--amber-bg);
                color: #92400e;
            }
            .b-done {
                background: var(--slate-bg);
                color: var(--slate);
            }
            .b-pend {
                background: var(--blue-bg);
                color: var(--blue);
            }
            .b-appr {
                background: var(--green-bg);
                color: #065f46;
            }
            .b-rej  {
                background: var(--red-bg);
                color: var(--red);
            }

            /* ── ACTION BUTTONS ── */
            .acts {
                display: flex;
                gap: 5px;
                flex-wrap: wrap;
            }
            .btn-act {
                display: flex;
                align-items: center;
                gap: 4px;
                padding: 5px 10px;
                border-radius: var(--radius-sm);
                font-size: 11px;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.2s;
                border: none;
                cursor: pointer;
                font-family: var(--font);
                white-space: nowrap;
            }
            .btn-lus {
                background: var(--green-bg);
                color: #065f46;
            }
            .btn-lus:hover {
                background: #a7f3d0;
            }
            .btn-tol {
                background: var(--red-bg);
                color: var(--red);
            }
            .btn-tol:hover {
                background: #fecaca;
            }
            .btn-ed  {
                background: var(--blue-bg);
                color: var(--blue);
            }
            .btn-ed:hover  {
                background: #bfdbfe;
            }
            .btn-del {
                background: var(--red-bg);
                color: var(--red);
            }
            .btn-del:hover {
                background: #fecaca;
            }

            /* ── EMPTY ── */
            .empty-state {
                text-align: center;
                padding: 40px 20px;
                color: var(--text-muted);
                font-size: 13px;
            }

            /* ── MODAL ── */
            .modal-ov {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,0.45);
                z-index: 999;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            .modal-ov.open {
                display: flex;
            }
            .modal {
                background: #fff;
                border-radius: var(--radius-lg);
                padding: 24px;
                width: 100%;
                max-width: 480px;
                box-shadow: 0 20px 60px rgba(15,36,71,0.2);
                max-height: 90vh;
                overflow-y: auto;
            }
            .modal-title {
                font-size: 15px;
                font-weight: 700;
                color: var(--text);
                margin-bottom: 16px;
                display: flex;
                align-items: center;
                gap: 8px;
                padding-bottom: 12px;
                border-bottom: 1px solid var(--border);
            }
            .modal-title i {
                color: var(--accent);
            }
            .modal-acts {
                display: flex;
                gap: 10px;
                margin-top: 16px;
                justify-content: flex-end;
            }
            .btn-cl {
                padding: 8px 16px;
                background: var(--bg);
                color: var(--text-secondary);
                border: 1px solid var(--border);
                border-radius: var(--radius-sm);
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                font-family: var(--font);
            }
            .btn-sv {
                padding: 8px 16px;
                background: linear-gradient(135deg, var(--accent), var(--primary-dark));
                color: #fff;
                border: none;
                border-radius: var(--radius-sm);
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                font-family: var(--font);
                display: flex;
                align-items: center;
                gap: 6px;
            }

            @media print {
                .sidebar, .topbar, .btn-add, .acts, .modal-ov {
                    display: none !important;
                }
                .layout {
                    display: block;
                }
                .content {
                    padding: 0;
                    overflow: visible;
                }
                .card {
                    box-shadow: none;
                    border: 1px solid #ccc;
                }
            }
            @media (max-width: 900px) {
                .sidebar {
                    display: none;
                }
                .stats-row {
                    grid-template-columns: 1fr 1fr;
                }
                .content {
                    padding: 16px;
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
                <a href="${pageContext.request.contextPath}/admin/bookings" class="nav-item">
                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                    Pengurusan Tempahan
                </a>
                <a href="${pageContext.request.contextPath}/coordinator/activity" class="nav-item active">
                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/></svg>
                    Pengurusan Aktiviti
                </a>

                <div class="nav-divider"></div>
                <div class="nav-section-label">Laporan &amp; Lihat</div>
                <a href="${pageContext.request.contextPath}/admin/report" class="nav-item">
                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                    Laporan Koordinator
                </a>
                <a href="${pageContext.request.contextPath}/admin/report?page=kewangan" class="nav-item">
                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
                    Laporan Kewangan
                    <span class="nav-pill">View</span>
                </a>

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
                    <div class="topbar-title">Pengurusan Aktiviti</div>
                    <div class="topbar-right">
                        <div class="topbar-chip">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            <fmt:formatDate value="${nowDate}" pattern="d MMM yyyy"/>
                        </div>
                        <button class="btn-topbar" onclick="window.print()">
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

                    <!-- ALERTS -->
                    <c:if test="${not empty success}">
                        <div class="alert a-ok"><i class="fa-solid fa-circle-check"></i> ${success}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert a-err"><i class="fa-solid fa-circle-exclamation"></i> ${error}</div>
                    </c:if>
                    <c:if test="${param.msg == 'deleted'}">
                        <div class="alert a-ok"><i class="fa-solid fa-trash"></i> Aktiviti berjaya dipadamkan.</div>
                    </c:if>

                    <!-- STATS -->
                    <div class="stats-row">
                        <div class="stat-card">
                            <div class="stat-icon" style="background:var(--blue-bg);">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#1d4ed8" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            </div>
                            <div><div class="stat-val">${countPending}</div><div class="stat-lbl">Menunggu Kelulusan</div></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon" style="background:var(--green-bg);">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#15803d" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                            </div>
                            <div><div class="stat-val">${countApproved}</div><div class="stat-lbl">Diluluskan</div></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon" style="background:#e8eef8;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#1a3a6b" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                            </div>
                            <div><div class="stat-val">${countUpcoming}</div><div class="stat-lbl">Akan Datang</div></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon" style="background:var(--amber-bg);">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#b45309" stroke-width="2"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
                            </div>
                            <div><div class="stat-val">${allEvents.size()}</div><div class="stat-lbl">Jumlah Rekod</div></div>
                        </div>
                    </div>

                    <!-- TAMBAH AKTIVITI -->
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">Tambah Aktiviti Baharu (Terus Diluluskan)</div>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/coordinator/activity" method="post">
                                <input type="hidden" name="action" value="add">
                                <div class="form-row">
                                    <div class="fg">
                                        <label>Nama Aktiviti *</label>
                                        <input type="text" name="name" placeholder="Contoh: Kuliah Maghrib" required>
                                    </div>
                                    <div class="fg">
                                        <label>Tarikh *</label>
                                        <input type="date" name="date" required>
                                    </div>
                                    <div class="fg">
                                        <label>Masa</label>
                                        <input type="time" name="time">
                                    </div>
                                    <div class="fg">
                                        <label>Lokasi</label>
                                        <input type="text" name="location" placeholder="Contoh: Dewan Utama">
                                    </div>
                                    <div class="fg">
                                        <label>Status</label>
                                        <select name="status">
                                            <option value="UPCOMING">Akan Datang</option>
                                            <option value="ONGOING">Sedang Berlangsung</option>
                                            <option value="COMPLETED">Selesai</option>
                                        </select>
                                    </div>
                                    <div class="fg full">
                                        <label>Penerangan</label>
                                        <textarea name="description" placeholder="Huraian ringkas..."></textarea>
                                    </div>
                                </div>
                                <button type="submit" class="btn-add">
                                    <i class="fa-solid fa-plus"></i> Tambah Aktiviti
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- SENARAI AKTIVITI -->
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">Semua Aktiviti &amp; Permohonan</div>
                            <span class="count-chip"><span id="evCount">${allEvents.size()}</span> rekod</span>
                        </div>
                        <div class="filter-bar">
                            <div class="search-box">
                                <i class="search-ic">🔍</i>
                                <input type="text" id="evSearch" placeholder="Cari nama, pemohon, lokasi..." onkeyup="filterEvents()">
                            </div>
                            <select id="evStatus" class="filter-select" onchange="filterEvents()">
                                <option value="all">Semua Kelulusan</option>
                                <option value="PENDING_APPROVAL">Menunggu</option>
                                <option value="APPROVED">Diluluskan</option>
                                <option value="REJECTED">Ditolak</option>
                            </select>
                            <select id="evYear" class="filter-select" onchange="filterEvents()">
                                <option value="all">Semua Tahun</option>
                            </select>
                            <select id="evMonth" class="filter-select" onchange="filterEvents()">
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
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Nama Aktiviti</th>
                                        <th>Pemohon</th>
                                        <th>Tarikh</th>
                                        <th>Masa</th>
                                        <th>Lokasi</th>
                                        <th>Status</th>
                                        <th>Kelulusan</th>
                                        <th style="text-align:center;">Tindakan</th>
                                    </tr>
                                </thead>
                                <tbody id="evTbody">
                                    <c:forEach items="${allEvents}" var="ev" varStatus="s">
                                        <tr data-search="${ev.name} ${ev.userName} ${ev.location}" data-date="${ev.date}" data-reqstatus="${ev.requestStatus}">
                                            <td style="color:var(--text-muted);font-size:11px;font-family:var(--font-mono);">${s.count}</td>
                                            <td style="font-weight:600;color:var(--text);">${ev.name}</td>
                                            <td style="color:var(--text-secondary);font-size:12px;">${not empty ev.userName ? ev.userName : 'Koordinator'}</td>
                                            <td>${ev.date}</td>
                                            <td style="color:var(--text-secondary);">${ev.time != null ? ev.time : '—'}</td>
                                            <td style="color:var(--text-secondary);font-size:12px;">${not empty ev.location ? ev.location : '—'}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${ev.status=='ONGOING'}"><span class="badge b-on">Berlangsung</span></c:when>
                                                    <c:when test="${ev.status=='COMPLETED'}"><span class="badge b-done">Selesai</span></c:when>
                                                    <c:otherwise><span class="badge b-up">Akan Datang</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${ev.requestStatus=='PENDING_APPROVAL'}"><span class="badge b-pend">Menunggu</span></c:when>
                                                    <c:when test="${ev.requestStatus=='APPROVED'}"><span class="badge b-appr">Diluluskan</span></c:when>
                                                    <c:otherwise><span class="badge b-rej">Ditolak</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="acts">
                                                    <c:if test="${ev.requestStatus == 'PENDING_APPROVAL'}">
                                                        <form action="${pageContext.request.contextPath}/coordinator/activity" method="post" style="display:inline;">
                                                            <input type="hidden" name="action" value="approve">
                                                            <input type="hidden" name="event_id" value="${ev.eventId}">
                                                            <button type="submit" class="btn-act btn-lus"><i class="fa-solid fa-check"></i> Lulus</button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/coordinator/activity" method="post" style="display:inline;">
                                                            <input type="hidden" name="action" value="reject">
                                                            <input type="hidden" name="event_id" value="${ev.eventId}">
                                                            <button type="submit" class="btn-act btn-tol"><i class="fa-solid fa-xmark"></i> Tolak</button>
                                                        </form>
                                                    </c:if>
                                                    <button type="button" class="btn-act btn-ed"
                                                            onclick="openEdit(this)"
                                                            data-id="${ev.eventId}"
                                                            data-name="${fn:escapeXml(ev.name)}"
                                                            data-date="${ev.date}"
                                                            data-time="${ev.time}"
                                                            data-loc="${fn:escapeXml(ev.location)}"
                                                            data-desc="${fn:escapeXml(ev.description)}"
                                                            data-status="${ev.status}">
                                                        <i class="fa-solid fa-pen"></i> Edit
                                                    </button>
                                                    <form action="${pageContext.request.contextPath}/coordinator/activity" method="post" style="display:inline;"
                                                          onsubmit="return confirm('Padam aktiviti ini?')">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="event_id" value="${ev.eventId}">
                                                        <button type="submit" class="btn-act btn-del"><i class="fa-solid fa-trash"></i></button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty allEvents}">
                                        <tr><td colspan="9" class="empty-state">Tiada rekod aktiviti lagi.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                            <div id="evEmpty" class="empty-filter" style="display:none;">
                                <i>🔍</i> Tiada rekod sepadan dengan carian/filter anda.
                            </div>
                        </div>
                    </div>

                </div><!-- /content -->
            </div><!-- /main -->
        </div><!-- /layout -->

        <!-- MODAL EDIT -->
        <div class="modal-ov" id="editModal">
            <div class="modal">
                <div class="modal-title"><i class="fa-solid fa-pen"></i> Kemaskini Aktiviti</div>
                <form action="${pageContext.request.contextPath}/coordinator/activity" method="post">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="event_id" id="editId">
                    <div class="form-row">
                        <div class="fg">
                            <label>Nama Aktiviti *</label>
                            <input type="text" name="name" id="editName" required>
                        </div>
                        <div class="fg">
                            <label>Tarikh *</label>
                            <input type="date" name="date" id="editDate" required>
                        </div>
                        <div class="fg">
                            <label>Masa</label>
                            <input type="time" name="time" id="editTime">
                        </div>
                        <div class="fg">
                            <label>Lokasi</label>
                            <input type="text" name="location" id="editLoc">
                        </div>
                        <div class="fg">
                            <label>Status</label>
                            <select name="status" id="editStatus">
                                <option value="UPCOMING">Akan Datang</option>
                                <option value="ONGOING">Sedang Berlangsung</option>
                                <option value="COMPLETED">Selesai</option>
                            </select>
                        </div>
                        <div class="fg full">
                            <label>Penerangan</label>
                            <textarea name="description" id="editDesc"></textarea>
                        </div>
                    </div>
                    <div class="modal-acts">
                        <button type="button" class="btn-cl" onclick="closeEdit()">Batal</button>
                        <button type="submit" class="btn-sv"><i class="fa-solid fa-floppy-disk"></i> Simpan</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openEdit(button) {
                document.getElementById('editId').value = button.dataset.id;
                document.getElementById('editName').value = button.dataset.name || '';
                document.getElementById('editDate').value = button.dataset.date || '';
                document.getElementById('editTime').value = button.dataset.time || '';
                document.getElementById('editLoc').value = button.dataset.loc || '';
                document.getElementById('editDesc').value = button.dataset.desc || '';
                document.getElementById('editStatus').value = button.dataset.status || '';
                document.getElementById('editModal').classList.add('open');
            }
            function closeEdit() {
                document.getElementById('editModal').classList.remove('open');
            }
            document.getElementById('editModal').addEventListener('click', function (e) {
                if (e.target === this)
                    closeEdit();
            });

            // ============================================
            // TABLE FILTER LOGIC (Search + Year + Month + Status)
            // ============================================
            function buildYearDropdownEv() {
                const tbody = document.getElementById('evTbody');
                const select = document.getElementById('evYear');
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

            function filterEvents() {
                const tbody = document.getElementById('evTbody');
                if (!tbody)
                    return;
                const query = (document.getElementById('evSearch').value || '').toLowerCase().trim();
                const status = document.getElementById('evStatus').value;
                const year = document.getElementById('evYear').value;
                const month = document.getElementById('evMonth').value;
                let visible = 0;
                tbody.querySelectorAll('tr[data-date]').forEach(tr => {
                    const search = (tr.dataset.search || '').toLowerCase();
                    const date = tr.dataset.date || '';
                    const trStatus = tr.dataset.reqstatus || '';
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
                document.getElementById('evCount').textContent = visible;
                document.getElementById('evEmpty').style.display = visible === 0 ? 'block' : 'none';
            }

            // Init
            buildYearDropdownEv();
            filterEvents();
        </script>
    </body>
</html>
