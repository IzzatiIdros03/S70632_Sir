<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="currentUser" scope="session" class="model.User" />
<!DOCTYPE html>
<html lang="ms">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Aktiviti Masjid - MMS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.css">
        <style>
            :root{
                --green:#0b8a83;
                --green-dark:#056d67;
                --grad:linear-gradient(135deg,#0b8a83,#056d67);
                --green-light:#e6f7f6;
                --gold:#f59e0b;
                --text:#1f2937;
                --mid:#4b5563;
                --light:#9ca3af;
                --bg:#f3f4f6;
                --white:#fff;
                --border:#e5e7eb;
            }
            *{
                box-sizing:border-box;
                margin:0;
                padding:0;
            }
            body{
                font-family:'Poppins',sans-serif;
                background:var(--bg);
                color:var(--text);
            }
            /* NAVBAR */
            .navbar{
                position:sticky;
                top:0;
                z-index:200;
                background:rgba(255,255,255,.95);
                backdrop-filter:blur(20px);
                border-bottom:1px solid var(--border);
                box-shadow:0 2px 12px rgba(0,0,0,.05);
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
                font-weight:800;
                font-size:19px;
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
                color:#fff;
                font-size:16px;
                box-shadow:0 4px 12px rgba(11,138,131,.3);
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
                font-size:13.5px;
                font-weight:500;
                color:var(--mid);
                text-decoration:none;
                transition:all .2s;
            }
            .nav-links a:hover,.nav-links a.active{
                color:var(--green);
                background:var(--green-light);
                font-weight:600;
            }
            .nav-right{
                display:flex;
                align-items:center;
                gap:12px;
                flex-shrink:0;
            }
            .nav-user{
                display:flex;
                align-items:center;
                gap:9px;
            }
            .user-av{
                width:34px;
                height:34px;
                background:var(--grad);
                border-radius:50%;
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-size:13px;
                font-weight:700;
            }
            .user-nm{
                font-size:13px;
                font-weight:600;
                color:var(--text);
                max-width:120px;
                overflow:hidden;
                text-overflow:ellipsis;
                white-space:nowrap;
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
                transition:all .2s;
            }
            .btn-out:hover{
                background:#fecaca;
            }
            .hamburger{
                display:none;
                flex-direction:column;
                gap:5px;
                background:none;
                border:none;
                cursor:pointer;
                padding:4px;
                margin-left:auto;
            }
            .hamburger span{
                display:block;
                width:22px;
                height:2px;
                background:var(--text);
                border-radius:2px;
                transition:all .3s;
            }
            .hamburger.open span:nth-child(1){
                transform:rotate(45deg) translate(5px,5px);
            }
            .hamburger.open span:nth-child(2){
                opacity:0;
            }
            .hamburger.open span:nth-child(3){
                transform:rotate(-45deg) translate(5px,-5px);
            }
            .mob-nav{
                display:none;
                flex-direction:column;
                padding:8px 5% 16px;
                border-top:1px solid var(--border);
                background:#fff;
                gap:2px;
            }
            .mob-nav.open{
                display:flex;
            }
            .mob-nav a{
                padding:10px 14px;
                border-radius:8px;
                font-size:14px;
                font-weight:500;
                color:var(--mid);
                text-decoration:none;
            }
            .mob-nav a:hover{
                background:var(--green-light);
                color:var(--green);
            }
            .mob-out{
                color:#ef4444!important;
                margin-top:6px;
            }
            /* PAGE HEADER */
            .ph{
                background:var(--grad);
                padding:44px 5% 52px;
                text-align:center;
                position:relative;
                overflow:hidden;
            }
            .ph::before{
                content:'';
                position:absolute;
                inset:0;
                background-image:radial-gradient(rgba(255,255,255,.07) 1px,transparent 1px);
                background-size:24px 24px;
            }
            .orb{
                position:absolute;
                border-radius:50%;
                filter:blur(60px);
                pointer-events:none;
            }
            .o1{
                width:300px;
                height:300px;
                background:rgba(255,255,255,.08);
                top:-80px;
                right:-60px;
            }
            .o2{
                width:200px;
                height:200px;
                background:rgba(5,109,103,.5);
                bottom:-60px;
                left:5%;
            }
            .ph-content{
                position:relative;
                z-index:2;
            }
            .ph-icon{
                width:58px;
                height:58px;
                background:rgba(255,255,255,.15);
                border-radius:16px;
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-size:24px;
                margin:0 auto 14px;
                border:1.5px solid rgba(255,255,255,.2);
            }
            .ph h1{
                font-size:clamp(1.6rem,3vw,2.1rem);
                font-weight:800;
                color:#fff;
                margin-bottom:6px;
            }
            .ph p{
                font-size:14px;
                color:rgba(255,255,255,.8);
            }
            /* MAIN */
            .main{
                max-width:1200px;
                margin:-26px auto 60px;
                padding:0 5%;
                position:relative;
                z-index:3;
            }
            /* ALERTS */
            .alert{
                padding:14px 18px;
                border-radius:12px;
                margin-bottom:20px;
                display:flex;
                align-items:center;
                gap:10px;
                font-size:14px;
                font-weight:500;
                animation:fadeUp .4s ease;
            }
            .a-ok{
                background:#d1fae5;
                color:#065f46;
                border:1px solid #6ee7b7;
            }
            .a-err{
                background:#fef2f2;
                color:#991b1b;
                border:1px solid #fca5a5;
            }
            .a-info{
                background:#fef3c7;
                color:#92400e;
                border:1px solid #fde68a;
            }
            @keyframes fadeUp{
                from{
                    opacity:0;
                    transform:translateY(10px)
                }
                to{
                    opacity:1;
                    transform:translateY(0)
                }
            }
            /* STATS */
            .stats{
                display:flex;
                gap:14px;
                flex-wrap:wrap;
                margin-bottom:22px;
            }
            .s-card{
                flex:1;
                min-width:130px;
                background:#fff;
                border-radius:14px;
                padding:16px 18px;
                border:1px solid var(--border);
                box-shadow:0 2px 8px rgba(0,0,0,.05);
                display:flex;
                align-items:center;
                gap:12px;
            }
            .s-ic{
                width:40px;
                height:40px;
                border-radius:10px;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:16px;
                flex-shrink:0;
            }
            .s-card b{
                display:block;
                font-size:20px;
                font-weight:800;
                color:var(--text);
            }
            .s-card span{
                font-size:11px;
                color:var(--light);
            }
            /* SECTION TITLE */
            .sec-title{
                font-size:16px;
                font-weight:700;
                color:var(--text);
                display:flex;
                align-items:center;
                gap:9px;
                margin-bottom:18px;
                margin-top:28px;
            }
            .sec-title i{
                color:var(--green);
            }
            .sec-title .cnt{
                font-size:12px;
                color:var(--light);
                background:var(--bg);
                padding:3px 10px;
                border-radius:20px;
                border:1px solid var(--border);
                margin-left:auto;
            }
            /* SECTION INTRO BAR (subtitle bawah section title) */
            .sec-intro{
                font-size:13px;
                color:var(--mid);
                margin:-10px 0 18px 0;
                padding-left:2px;
            }
            /* EVENT GRID */
            .ev-grid{
                display:grid;
                grid-template-columns:repeat(auto-fill,minmax(300px,1fr));
                gap:20px;
                margin-bottom:28px;
            }
            /* UPCOMING CARD — design baru lebih cantik */
            .up-card{
                position:relative;
                background:#fff;
                border-radius:18px;
                border:1.5px solid var(--border);
                overflow:hidden;
                transition:all .35s cubic-bezier(.4,0,.2,1);
                box-shadow:0 4px 14px rgba(0,0,0,.05);
                display:flex;
                flex-direction:column;
                animation:slideUp .5s ease-out backwards;
            }
            .up-card:nth-child(1){
                animation-delay:.05s;
            }
            .up-card:nth-child(2){
                animation-delay:.12s;
            }
            .up-card:nth-child(3){
                animation-delay:.19s;
            }
            .up-card:nth-child(4){
                animation-delay:.26s;
            }
            .up-card:nth-child(5){
                animation-delay:.33s;
            }
            .up-card:nth-child(6){
                animation-delay:.4s;
            }
            @keyframes slideUp{
                from{
                    opacity:0;
                    transform:translateY(18px);
                }
                to{
                    opacity:1;
                    transform:translateY(0);
                }
            }
            .up-card::before{
                content:'';
                position:absolute;
                top:0;
                left:0;
                right:0;
                height:5px;
                background:var(--grad);
            }
            .up-card.is-live::before{
                background:linear-gradient(135deg,#f59e0b,#ef4444);
            }
            .up-card:hover{
                transform:translateY(-6px);
                box-shadow:0 18px 40px rgba(11,138,131,.18);
                border-color:var(--green);
            }
            .up-card.is-live:hover{
                box-shadow:0 18px 40px rgba(245,158,11,.22);
                border-color:var(--gold);
            }
            .up-head{
                padding:22px 20px 14px;
                display:flex;
                align-items:flex-start;
                justify-content:space-between;
                gap:12px;
            }
            .up-date-box{
                min-width:62px;
                background:var(--green-light);
                border-radius:12px;
                padding:8px 10px;
                text-align:center;
                border:1px solid rgba(11,138,131,.15);
            }
            .up-card.is-live .up-date-box{
                background:#fef3c7;
                border-color:rgba(245,158,11,.25);
            }
            .up-date-day{
                font-size:22px;
                font-weight:800;
                color:var(--green-dark);
                line-height:1;
            }
            .up-card.is-live .up-date-day{
                color:#b45309;
            }
            .up-date-mon{
                font-size:10px;
                font-weight:700;
                color:var(--green);
                text-transform:uppercase;
                letter-spacing:.6px;
                margin-top:3px;
            }
            .up-card.is-live .up-date-mon{
                color:#d97706;
            }
            .up-badges{
                display:flex;
                flex-direction:column;
                align-items:flex-end;
                gap:6px;
            }
            .up-pill{
                padding:5px 11px;
                border-radius:20px;
                font-size:10.5px;
                font-weight:700;
                display:inline-flex;
                align-items:center;
                gap:5px;
            }
            .up-pill.up-soon{
                background:var(--green-light);
                color:var(--green-dark);
            }
            .up-pill.up-live{
                background:#fef3c7;
                color:#92400e;
            }
            .up-pill.up-live i{
                animation:pulse 1.5s infinite;
            }
            @keyframes pulse{
                0%,100%{
                    opacity:1;
                }
                50%{
                    opacity:.4;
                }
            }
            .up-countdown{
                font-size:10.5px;
                font-weight:600;
                color:var(--light);
                background:#f9fafb;
                padding:3px 9px;
                border-radius:12px;
                border:1px solid var(--border);
            }
            .up-body{
                padding:0 20px 16px;
                flex:1;
            }
            .up-title{
                font-size:16px;
                font-weight:700;
                color:var(--text);
                margin-bottom:12px;
                line-height:1.35;
            }
            .up-meta{
                display:flex;
                flex-direction:column;
                gap:7px;
            }
            .up-meta-row{
                display:flex;
                align-items:center;
                gap:9px;
                font-size:12.5px;
                color:var(--mid);
            }
            .up-meta-row i{
                color:var(--green);
                width:14px;
                text-align:center;
                font-size:12px;
            }
            .up-card.is-live .up-meta-row i{
                color:var(--gold);
            }
            .up-desc{
                font-size:12.5px;
                color:var(--light);
                line-height:1.6;
                margin-top:12px;
                padding-top:12px;
                border-top:1px dashed var(--border);
            }
            .up-footer{
                padding:11px 20px;
                background:linear-gradient(135deg,#fafbfc,#f3f4f6);
                border-top:1px solid var(--border);
                display:flex;
                align-items:center;
                gap:8px;
                font-size:11.5px;
                color:var(--mid);
            }
            .up-footer i{
                color:var(--green);
            }
            .up-card.is-live .up-footer i{
                color:var(--gold);
            }
            /* MORE NOTICE — direct user ke kalendar */
            .more-notice{
                margin-bottom:28px;
                padding:18px 22px;
                background:linear-gradient(135deg,#e6f7f6,#d1fae5);
                border:1.5px dashed var(--green);
                border-radius:14px;
                display:flex;
                align-items:center;
                gap:16px;
                cursor:pointer;
                transition:all .3s;
            }
            .more-notice:hover{
                transform:translateY(-2px);
                box-shadow:0 8px 24px rgba(11,138,131,.15);
                background:linear-gradient(135deg,#d1fae5,#a7f3d0);
            }
            .more-notice-ic{
                width:46px;
                height:46px;
                border-radius:12px;
                background:var(--grad);
                color:#fff;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:20px;
                flex-shrink:0;
                box-shadow:0 6px 14px rgba(11,138,131,.25);
            }
            .more-notice-text{
                flex:1;
                display:flex;
                flex-direction:column;
            }
            .more-notice-text b{
                font-size:14px;
                color:var(--green-dark);
                margin-bottom:2px;
            }
            .more-notice-text span{
                font-size:12.5px;
                color:var(--mid);
            }
            .more-notice-arrow{
                color:var(--green);
                font-size:18px;
                animation:bounceUp 1.5s infinite;
            }
            @keyframes bounceUp{
                0%,100%{
                    transform:translateY(0);
                }
                50%{
                    transform:translateY(-4px);
                }
            }
            /* EVENT MODAL POPUP — bila klik tarikh dalam kalendar */
            .ev-modal-overlay{
                position:fixed;
                inset:0;
                background:rgba(15,23,42,.55);
                backdrop-filter:blur(6px);
                z-index:9999;
                display:none;
                align-items:center;
                justify-content:center;
                padding:20px;
                animation:fadeIn .25s ease;
            }
            .ev-modal-overlay.show{
                display:flex;
            }
            @keyframes fadeIn{
                from{
                    opacity:0;
                }
                to{
                    opacity:1;
                }
            }
            .ev-modal{
                background:#fff;
                border-radius:20px;
                max-width:480px;
                width:100%;
                max-height:88vh;
                overflow:hidden;
                box-shadow:0 25px 60px rgba(0,0,0,.3);
                animation:popUp .35s cubic-bezier(.34,1.56,.64,1);
                display:flex;
                flex-direction:column;
            }
            @keyframes popUp{
                from{
                    opacity:0;
                    transform:scale(.85) translateY(20px);
                }
                to{
                    opacity:1;
                    transform:scale(1) translateY(0);
                }
            }
            .ev-modal-head{
                position:relative;
                padding:24px 24px 20px;
                background:var(--grad);
                color:#fff;
                overflow:hidden;
            }
            .ev-modal-head.is-live{
                background:linear-gradient(135deg,#f59e0b,#ef4444);
            }
            .ev-modal-head::before{
                content:'';
                position:absolute;
                top:-30px;
                right:-30px;
                width:120px;
                height:120px;
                background:rgba(255,255,255,.08);
                border-radius:50%;
            }
            .ev-modal-close{
                position:absolute;
                top:16px;
                right:16px;
                width:34px;
                height:34px;
                background:rgba(255,255,255,.2);
                border:none;
                border-radius:50%;
                color:#fff;
                font-size:16px;
                cursor:pointer;
                display:flex;
                align-items:center;
                justify-content:center;
                transition:all .2s;
                z-index:2;
            }
            .ev-modal-close:hover{
                background:rgba(255,255,255,.35);
                transform:rotate(90deg);
            }
            .ev-modal-status{
                position:relative;
                z-index:1;
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding:5px 11px;
                background:rgba(255,255,255,.22);
                border-radius:20px;
                font-size:11.5px;
                font-weight:700;
                margin-bottom:10px;
            }
            .ev-modal-status .dot{
                width:7px;
                height:7px;
                border-radius:50%;
                background:#fff;
            }
            .ev-modal-head.is-live .ev-modal-status .dot{
                animation:pulse 1.5s infinite;
            }
            .ev-modal-title{
                position:relative;
                z-index:1;
                font-size:20px;
                font-weight:800;
                line-height:1.3;
                margin-bottom:6px;
            }
            .ev-modal-countdown{
                position:relative;
                z-index:1;
                font-size:12.5px;
                opacity:.92;
                display:flex;
                align-items:center;
                gap:6px;
            }
            .ev-modal-body{
                padding:22px 24px 24px;
                overflow-y:auto;
            }
            .ev-modal-row{
                display:flex;
                align-items:flex-start;
                gap:14px;
                padding:12px 0;
                border-bottom:1px solid #f3f4f6;
            }
            .ev-modal-row:last-child{
                border-bottom:none;
            }
            .ev-modal-row-ic{
                width:36px;
                height:36px;
                border-radius:10px;
                background:var(--green-light);
                color:var(--green);
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:14px;
                flex-shrink:0;
            }
            .ev-modal-row-content{
                flex:1;
            }
            .ev-modal-row-label{
                font-size:11.5px;
                font-weight:600;
                color:var(--light);
                text-transform:uppercase;
                letter-spacing:.5px;
                margin-bottom:3px;
            }
            .ev-modal-row-val{
                font-size:13.5px;
                font-weight:600;
                color:var(--text);
                line-height:1.5;
            }
            .ev-modal-row-val.desc{
                font-weight:400;
                color:var(--mid);
            }
            /* ============================================
               MY REQUESTS — FILTER + ACCORDION (Professional)
               ============================================ */
            /* Title row dengan filter bulan di kanan */
            .req-title-row{
                display:flex;
                align-items:center;
                gap:14px;
                margin:32px 0 16px;
                flex-wrap:wrap;
            }
            .req-title-row .sec-title{
                margin:0;
            }
            /* Month dropdown — professional & subtle */
            .month-wrap{
                position:relative;
                margin-left:auto;
            }
            .month-btn{
                padding:9px 14px;
                border-radius:10px;
                border:1px solid var(--border);
                background:#fff;
                font-family:'Poppins',sans-serif;
                font-size:12.5px;
                font-weight:600;
                color:var(--text);
                cursor:pointer;
                display:inline-flex;
                align-items:center;
                gap:9px;
                min-width:170px;
                justify-content:space-between;
                box-shadow:0 1px 3px rgba(15,23,42,.04);
                transition:all .2s ease;
                letter-spacing:.1px;
            }
            .month-btn:hover{
                border-color:var(--green);
                box-shadow:0 4px 12px rgba(11,138,131,.08);
            }
            .month-btn .month-lbl{
                display:flex;
                align-items:center;
                gap:8px;
            }
            .month-btn .month-lbl i{
                color:var(--green);
                font-size:13px;
            }
            .month-btn .chev{
                font-size:9px;
                color:#9ca3af;
                transition:transform .2s;
            }
            .month-btn.open{
                border-color:var(--green);
                box-shadow:0 4px 14px rgba(11,138,131,.12);
            }
            .month-btn.open .chev{
                transform:rotate(180deg);
                color:var(--green);
            }
            .month-dropdown{
                position:absolute;
                top:calc(100% + 6px);
                right:0;
                background:#fff;
                border:1px solid var(--border);
                border-radius:12px;
                padding:6px;
                min-width:220px;
                max-height:280px;
                overflow-y:auto;
                box-shadow:0 14px 32px rgba(15,23,42,.12);
                display:none;
                z-index:20;
            }
            .month-dropdown.show{
                display:block;
                animation:dropIn .18s ease;
            }
            @keyframes dropIn{
                from{
                    opacity:0;
                    transform:translateY(-6px);
                }
                to{
                    opacity:1;
                    transform:translateY(0);
                }
            }
            .month-opt{
                padding:9px 12px;
                border-radius:8px;
                font-size:12.5px;
                color:var(--mid);
                cursor:pointer;
                display:flex;
                align-items:center;
                justify-content:space-between;
                transition:all .15s;
                font-weight:500;
            }
            .month-opt:hover{
                background:#f8fafc;
                color:var(--green-dark);
            }
            .month-opt.selected{
                background:var(--green-light);
                color:var(--green-dark);
                font-weight:600;
            }
            .month-opt .opt-cnt{
                font-size:10.5px;
                color:#94a3b8;
                background:#fff;
                padding:1px 8px;
                border-radius:20px;
                border:1px solid var(--border);
                font-weight:600;
            }
            .month-opt.selected .opt-cnt{
                background:#fff;
                color:var(--green);
                border-color:transparent;
            }

            /* Tab status bar */
            .tab-bar{
                display:flex;
                gap:6px;
                flex-wrap:wrap;
                background:#fff;
                padding:6px;
                border-radius:12px;
                border:1px solid var(--border);
                box-shadow:0 1px 3px rgba(15,23,42,.04);
                margin-bottom:14px;
            }
            .tab-btn{
                flex:1;
                min-width:0;
                padding:9px 12px;
                border-radius:8px;
                border:1px solid transparent;
                background:transparent;
                font-family:'Poppins',sans-serif;
                font-size:12.5px;
                font-weight:600;
                color:var(--mid);
                cursor:pointer;
                display:inline-flex;
                align-items:center;
                justify-content:center;
                gap:7px;
                transition:all .25s ease;
                white-space:nowrap;
                letter-spacing:.1px;
            }
            .tab-btn i{
                font-size:11px;
            }
            .tab-btn:hover{
                background:#f8fafc;
                color:var(--text);
            }
            .tab-btn .tab-count{
                background:#f1f5f9;
                color:#64748b;
                padding:2px 8px;
                border-radius:20px;
                font-size:10.5px;
                font-weight:700;
                line-height:1.4;
                min-width:24px;
                text-align:center;
            }
            .tab-btn.active{
                background:linear-gradient(135deg,#0b8a83,#056d67);
                color:#fff;
                box-shadow:0 3px 10px rgba(11,138,131,.25);
            }
            .tab-btn.active .tab-count{
                background:rgba(255,255,255,.25);
                color:#fff;
            }
            .tab-btn.tab-pend.active{
                background:linear-gradient(135deg,#3b82f6,#1e40af);
                box-shadow:0 3px 10px rgba(59,130,246,.25);
            }
            .tab-btn.tab-up.active{
                background:linear-gradient(135deg,#10b981,#047857);
                box-shadow:0 3px 10px rgba(16,185,129,.25);
            }
            .tab-btn.tab-rej.active{
                background:linear-gradient(135deg,#ef4444,#991b1b);
                box-shadow:0 3px 10px rgba(239,68,68,.25);
            }

            /* Result info banner */
            .result-info{
                background:#f0fdfa;
                border:1px solid #99f6e4;
                padding:9px 14px;
                border-radius:9px;
                font-size:12.5px;
                color:#0f766e;
                display:flex;
                align-items:center;
                gap:8px;
                margin-bottom:14px;
                font-weight:500;
            }
            .result-info i{
                color:#14b8a6;
            }
            .result-info b{
                font-weight:700;
            }
            .result-info .clear-filter{
                margin-left:auto;
                background:none;
                border:none;
                color:#0d9488;
                font-size:11.5px;
                font-weight:600;
                cursor:pointer;
                font-family:inherit;
                display:flex;
                align-items:center;
                gap:4px;
                padding:3px 8px;
                border-radius:6px;
                transition:background .15s;
            }
            .result-info .clear-filter:hover{
                background:#ccfbf1;
            }

            /* Accordion list */
            .acc-group{
                display:flex;
                flex-direction:column;
                gap:8px;
            }
            .acc-item{
                background:#fff;
                border-radius:11px;
                border:1px solid var(--border);
                overflow:hidden;
                transition:all .25s ease;
                animation:accSlide .3s ease backwards;
            }
            .acc-item:nth-child(1){
                animation-delay:.03s;
            }
            .acc-item:nth-child(2){
                animation-delay:.06s;
            }
            .acc-item:nth-child(3){
                animation-delay:.09s;
            }
            .acc-item:nth-child(4){
                animation-delay:.12s;
            }
            .acc-item:nth-child(5){
                animation-delay:.15s;
            }
            .acc-item:nth-child(6){
                animation-delay:.18s;
            }
            @keyframes accSlide{
                from{
                    opacity:0;
                    transform:translateY(6px);
                }
                to{
                    opacity:1;
                    transform:translateY(0);
                }
            }
            .acc-item:hover{
                border-color:#cbd5e1;
                box-shadow:0 4px 12px rgba(15,23,42,.06);
            }
            .acc-item.open{
                border-color:var(--green);
                box-shadow:0 6px 20px rgba(11,138,131,.1);
            }
            .acc-head{
                padding:13px 16px;
                display:flex;
                align-items:center;
                gap:13px;
                cursor:pointer;
                background:#fff;
                transition:background .2s;
                user-select:none;
            }
            .acc-item.open .acc-head{
                background:linear-gradient(135deg,#f0fdfa,#fafffe);
            }
            .acc-status-ic{
                width:36px;
                height:36px;
                border-radius:9px;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:13px;
                flex-shrink:0;
            }
            .acc-status-ic.acc-pend{
                background:#eff6ff;
                color:#2563eb;
            }
            .acc-status-ic.acc-up{
                background:#ecfdf5;
                color:#059669;
            }
            .acc-status-ic.acc-rej{
                background:#fef2f2;
                color:#dc2626;
            }
            .acc-main{
                flex:1;
                min-width:0;
            }
            .acc-name{
                font-size:13.5px;
                font-weight:700;
                color:var(--text);
                margin-bottom:3px;
                letter-spacing:-.1px;
                white-space:nowrap;
                overflow:hidden;
                text-overflow:ellipsis;
            }
            .acc-sub{
                font-size:11.5px;
                color:#64748b;
                display:flex;
                gap:14px;
                flex-wrap:wrap;
                font-weight:500;
            }
            .acc-sub span{
                display:inline-flex;
                align-items:center;
                gap:5px;
            }
            .acc-sub i{
                color:#94a3b8;
                font-size:10px;
            }
            .acc-badge{
                padding:4px 11px;
                border-radius:20px;
                font-size:10.5px;
                font-weight:700;
                flex-shrink:0;
            }
            .acc-badge.acc-b-pend{
                background:#dbeafe;
                color:#1e40af;
                border:1px solid #93c5fd;
            }
            .acc-badge.acc-b-up{
                background:#d1fae5;
                color:#065f46;
                border:1px solid #6ee7b7;
            }
            .acc-badge.acc-b-rej{
                background:#fee2e2;
                color:#991b1b;
                border:1px solid #fca5a5;
            }
            .acc-chev{
                color:#94a3b8;
                font-size:12px;
                transition:transform .25s;
                flex-shrink:0;
                width:18px;
                text-align:center;
            }
            .acc-item.open .acc-chev{
                transform:rotate(180deg);
                color:var(--green);
            }
            .acc-body{
                max-height:0;
                overflow:hidden;
                transition:max-height .35s cubic-bezier(.4,0,.2,1);
            }
            .acc-item.open .acc-body{
                max-height:320px;
            }
            .acc-body-inner{
                padding:14px 16px 16px;
                border-top:1px solid #f1f5f9;
                background:#fafbfc;
            }
            .acc-detail-grid{
                display:grid;
                grid-template-columns:repeat(auto-fit,minmax(180px,1fr));
                gap:10px 18px;
                margin-bottom:10px;
            }
            .acc-detail-row{
                display:flex;
                align-items:center;
                gap:9px;
                font-size:12px;
                color:var(--mid);
            }
            .acc-detail-row .det-ic{
                width:24px;
                height:24px;
                border-radius:6px;
                background:#fff;
                border:1px solid var(--border);
                display:flex;
                align-items:center;
                justify-content:center;
                color:var(--green);
                font-size:10px;
                flex-shrink:0;
            }
            .acc-detail-row .det-lbl{
                font-size:11px;
                color:#9ca3af;
                font-weight:500;
                margin-bottom:1px;
            }
            .acc-detail-row .det-val{
                font-size:13px;
                color:var(--text);
                font-weight:600;
            }
            .acc-detail-row > div{
                display:flex;
                flex-direction:column;
            }
            .acc-desc{
                font-size:12.5px;
                color:#6b7280;
                line-height:1.6;
                margin-top:10px;
                padding-top:10px;
                border-top:1px dashed #e2e8f0;
            }
            .acc-actions{
                display:flex;
                gap:8px;
                margin-top:12px;
                padding-top:12px;
                border-top:1px solid #f1f5f9;
            }
            .acc-btn{
                flex:1;
                padding:8px 12px;
                border-radius:8px;
                font-size:11.5px;
                font-weight:600;
                border:1px solid transparent;
                cursor:pointer;
                display:flex;
                align-items:center;
                justify-content:center;
                gap:6px;
                font-family:'Poppins',sans-serif;
                transition:all .2s;
                letter-spacing:.1px;
            }
            .acc-btn-ed{
                background:#eff6ff;
                color:#1d4ed8;
                border-color:#bfdbfe;
            }
            .acc-btn-ed:hover{
                background:#1d4ed8;
                color:#fff;
                border-color:#1d4ed8;
            }
            .acc-btn-del{
                background:#fef2f2;
                color:#b91c1c;
                border-color:#fecaca;
            }
            .acc-btn-del:hover{
                background:#b91c1c;
                color:#fff;
                border-color:#b91c1c;
            }

            /* Empty state for filter */
            .filter-empty{
                text-align:center;
                padding:48px 24px;
                background:#fff;
                border-radius:12px;
                border:1.5px dashed var(--border);
            }
            .filter-empty i{
                font-size:38px;
                color:#cbd5e1;
                margin-bottom:12px;
                display:block;
            }
            .filter-empty h4{
                font-size:14px;
                font-weight:600;
                color:var(--text);
                margin-bottom:4px;
            }
            .filter-empty p{
                font-size:12.5px;
                color:#94a3b8;
            }
            /* EVENT CARD */
            .ev-card{
                background:#fff;
                border-radius:16px;
                border:1.5px solid var(--border);
                overflow:hidden;
                transition:all .3s;
                box-shadow:0 2px 8px rgba(0,0,0,.05);
                display:flex;
                flex-direction:column;
            }
            .ev-card:hover{
                transform:translateY(-4px);
                box-shadow:0 14px 36px rgba(0,0,0,.1);
                border-color:var(--green);
            }
            .ev-card-top{
                padding:18px 18px 0;
            }
            .ev-row{
                display:flex;
                align-items:center;
                justify-content:space-between;
                margin-bottom:12px;
            }
            .badge{
                padding:4px 10px;
                border-radius:20px;
                font-size:11px;
                font-weight:700;
            }
            .b-up{
                background:var(--green-light);
                color:var(--green-dark);
            }
            .b-on{
                background:#fef3c7;
                color:#92400e;
            }
            .b-done{
                background:#f3f4f6;
                color:#6b7280;
            }
            .b-pend{
                background:#eff6ff;
                color:#1e40af;
            }
            .b-rej{
                background:#fef2f2;
                color:#991b1b;
            }
            .ev-icon{
                width:40px;
                height:40px;
                border-radius:10px;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:18px;
            }
            .ic-up{
                background:var(--green-light);
                color:var(--green);
            }
            .ic-on{
                background:#fef3c7;
                color:#d97706;
            }
            .ic-done{
                background:#f3f4f6;
                color:#6b7280;
            }
            .ic-pend{
                background:#eff6ff;
                color:#1e40af;
            }
            .ev-name{
                font-size:15px;
                font-weight:700;
                color:var(--text);
                margin-bottom:9px;
            }
            .ev-meta{
                display:flex;
                flex-direction:column;
                gap:5px;
                margin-bottom:12px;
            }
            .ev-meta-row{
                display:flex;
                align-items:center;
                gap:8px;
                font-size:12px;
                color:var(--mid);
            }
            .ev-meta-row i{
                color:var(--green);
                width:14px;
                text-align:center;
                font-size:11px;
            }
            .ev-desc{
                font-size:12.5px;
                color:var(--light);
                line-height:1.6;
                padding:0 18px 14px;
                flex:1;
            }
            .ev-actions{
                display:flex;
                gap:7px;
                padding:12px 18px;
                border-top:1px solid #f3f4f6;
                background:#fafafa;
            }
            .btn-act{
                flex:1;
                padding:7px;
                border-radius:7px;
                font-size:12px;
                font-weight:600;
                border:none;
                cursor:pointer;
                font-family:'Poppins',sans-serif;
                display:flex;
                align-items:center;
                justify-content:center;
                gap:5px;
                transition:all .2s;
            }
            .btn-ed{
                background:#dbeafe;
                color:#1e40af;
            }
            .btn-ed:hover{
                background:#bfdbfe;
            }
            .btn-del{
                background:#fee2e2;
                color:#991b1b;
            }
            .btn-del:hover{
                background:#fecaca;
            }
            /* EMPTY */
            .empty{
                text-align:center;
                padding:48px 20px;
                background:#fff;
                border-radius:16px;
                border:1px solid var(--border);
            }
            .empty i{
                font-size:46px;
                color:var(--light);
                margin-bottom:12px;
                display:block;
                opacity:.4;
            }
            .empty p{
                font-size:14px;
                color:var(--light);
            }
            /* EMPTY — gaya cantik untuk upcoming */
            .empty-up{
                text-align:center;
                padding:56px 24px;
                background:linear-gradient(135deg,#fff,#f9fefe);
                border-radius:18px;
                border:1.5px dashed var(--green);
                margin-bottom:28px;
                position:relative;
                overflow:hidden;
            }
            .empty-up::before{
                content:'';
                position:absolute;
                top:-40px;
                right:-40px;
                width:140px;
                height:140px;
                background:var(--green-light);
                border-radius:50%;
                opacity:.4;
            }
            .empty-up::after{
                content:'';
                position:absolute;
                bottom:-30px;
                left:-30px;
                width:110px;
                height:110px;
                background:var(--green-light);
                border-radius:50%;
                opacity:.3;
            }
            .empty-up-ic{
                position:relative;
                z-index:1;
                width:78px;
                height:78px;
                margin:0 auto 16px;
                background:var(--grad);
                border-radius:22px;
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-size:32px;
                box-shadow:0 10px 24px rgba(11,138,131,.3);
            }
            .empty-up h4{
                position:relative;
                z-index:1;
                font-size:17px;
                font-weight:700;
                color:var(--text);
                margin-bottom:6px;
            }
            .empty-up p{
                position:relative;
                z-index:1;
                font-size:13px;
                color:var(--mid);
                margin-bottom:0;
            }
            /* REQUEST FORM */
            .req-card{
                background:#fff;
                border-radius:18px;
                padding:22px 26px;
                border:1px solid var(--border);
                box-shadow:0 4px 16px rgba(0,0,0,.05);
                margin-bottom:24px;
            }
            .req-card-title{
                font-size:14px;
                font-weight:700;
                color:var(--text);
                margin-bottom:16px;
                display:flex;
                align-items:center;
                gap:8px;
                padding-bottom:12px;
                border-bottom:1px solid var(--border);
            }
            .req-card-title i{
                color:var(--green);
            }
            .fg{
                margin-bottom:14px;
            }
            .fg label{
                display:block;
                font-size:12px;
                font-weight:600;
                color:var(--mid);
                margin-bottom:5px;
            }
            .fg input,.fg textarea,.fg select{
                width:100%;
                padding:9px 12px;
                border-radius:8px;
                border:1.5px solid var(--border);
                font-size:13px;
                font-family:'Poppins',sans-serif;
                background:#f9fafb;
                color:var(--text);
                transition:all .2s;
            }
            .fg input:focus,.fg textarea:focus{
                outline:none;
                border-color:var(--green);
                background:#fff;
                box-shadow:0 0 0 3px rgba(11,138,131,.1);
            }
            .fg textarea{
                resize:vertical;
                min-height:65px;
            }
            .fg.full{
                grid-column:1/-1;
            }
            .fg-grid{
                display:grid;
                grid-template-columns:repeat(auto-fit,minmax(170px,1fr));
                gap:12px;
            }
            .btn-req{
                padding:10px 20px;
                background:var(--grad);
                color:#fff;
                border:none;
                border-radius:8px;
                font-size:13px;
                font-weight:600;
                cursor:pointer;
                font-family:'Poppins',sans-serif;
                display:flex;
                align-items:center;
                gap:7px;
                transition:all .2s;
                margin-top:6px;
            }
            .btn-req:hover{
                transform:translateY(-1px);
                box-shadow:0 4px 12px rgba(11,138,131,.3);
            }
            /* MODAL */
            .modal-ov{
                display:none;
                position:fixed;
                inset:0;
                background:rgba(0,0,0,.5);
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
                border-radius:18px;
                padding:26px;
                width:100%;
                max-width:500px;
                box-shadow:0 20px 60px rgba(0,0,0,.2);
                max-height:90vh;
                overflow-y:auto;
            }
            .modal-title{
                font-size:15px;
                font-weight:700;
                color:var(--text);
                margin-bottom:18px;
                display:flex;
                align-items:center;
                gap:8px;
                padding-bottom:12px;
                border-bottom:1px solid var(--border);
            }
            .modal-title i{
                color:var(--green);
            }
            .modal-acts{
                display:flex;
                gap:10px;
                margin-top:18px;
                justify-content:flex-end;
            }
            .btn-cl{
                padding:9px 18px;
                background:#f3f4f6;
                color:var(--mid);
                border:none;
                border-radius:8px;
                font-size:13px;
                font-weight:600;
                cursor:pointer;
                font-family:'Poppins',sans-serif;
            }
            .btn-sv{
                padding:9px 18px;
                background:var(--grad);
                color:#fff;
                border:none;
                border-radius:8px;
                font-size:13px;
                font-weight:600;
                cursor:pointer;
                font-family:'Poppins',sans-serif;
                display:flex;
                align-items:center;
                gap:6px;
            }
            @media(max-width:768px){
                .nav-links,.nav-right{
                    display:none;
                }
                .hamburger{
                    display:flex;
                }
                .ev-grid{
                    grid-template-columns:1fr;
                }
                .stats{
                    gap:10px;
                }
            }

            /* CALENDAR */
            .cal-card{
                background:var(--white);
                border-radius:16px;
                padding:24px;
                border:1px solid var(--border);
                box-shadow:0 2px 12px rgba(0,0,0,.05);
                margin-bottom:24px;
            }
            .cal-title{
                font-size:15px;
                font-weight:700;
                color:var(--text);
                display:flex;
                align-items:center;
                gap:10px;
                padding-bottom:14px;
                margin-bottom:18px;
                border-bottom:1px solid var(--border);
            }
            .cal-title i{
                color:var(--green);
            }
            .cal-legend{
                display:flex;
                gap:16px;
                flex-wrap:wrap;
                margin-bottom:14px;
            }
            .cal-leg-item{
                display:flex;
                align-items:center;
                gap:6px;
                font-size:12px;
                color:var(--mid);
            }
            .cal-leg-dot{
                width:10px;
                height:10px;
                border-radius:50%;
            }
            #activityCalendar .fc-button-primary{
                background:var(--green)!important;
                border-color:var(--green)!important;
            }
            #activityCalendar .fc-button-primary:hover{
                background:var(--green-dark)!important;
                border-color:var(--green-dark)!important;
            }
            #activityCalendar .fc-day-today{
                background:var(--green-light)!important;
            }
            #activityCalendar .fc-event{
                cursor:pointer;
                font-size:11px;
                padding:2px 4px;
            }
        </style>
    </head>
    <body>
        <header class="navbar" id="navbar">
            <div class="nav-inner">
                <a href="${pageContext.request.contextPath}/home" class="nav-brand">
                    <div class="nav-logo"><i class="fa-solid fa-mosque"></i></div><span>MMS</span>
                </a>
                <nav class="nav-links">
                    <a href="${pageContext.request.contextPath}/home">Utama</a>
                    <a href="${pageContext.request.contextPath}/bookings">Tempahan</a>
                    <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
                    <a href="${pageContext.request.contextPath}/activity" class="active">Aktiviti</a>
                    <a href="${pageContext.request.contextPath}/donation.jsp">Sumbangan</a>
                    <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
                </nav>
                <div class="nav-right">
                    <div style="position:relative;display:flex;align-items:center;">
                        <a href="${pageContext.request.contextPath}/notifications"
                           style="color:var(--text-mid);font-size:18px;padding:6px 10px;border-radius:8px;text-decoration:none;display:flex;align-items:center;"
                           title="Notifikasi">
                            <i class="fa-solid fa-bell"></i>
                        </a>
                        <c:if test="${unreadNotifCount > 0}">
                            <span style="position:absolute;top:2px;right:4px;background:#ef4444;color:white;border-radius:50%;width:16px;height:16px;font-size:9px;font-weight:700;display:flex;align-items:center;justify-content:center;">${unreadNotifCount}</span>
                        </c:if>
                    </div>
                    <div class="nav-user">
                        <div class="user-av">${currentUser.name.substring(0,1).toUpperCase()}</div>
                        <span class="user-nm">${currentUser.name}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-out"><i class="fa-solid fa-power-off"></i> <span>Keluar</span></a>
                </div>
                <button class="hamburger" id="hamburger"><span></span><span></span><span></span></button>
            </div>
            <div class="mob-nav" id="mobNav">
                <a href="${pageContext.request.contextPath}/home">Utama</a>
                <a href="${pageContext.request.contextPath}/bookings">Tempahan</a>
                <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
                <a href="${pageContext.request.contextPath}/activity">Aktiviti</a>
                <a href="${pageContext.request.contextPath}/donation.jsp">Sumbangan</a>
                <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
                <a href="${pageContext.request.contextPath}/logout" class="mob-out"><i class="fa-solid fa-power-off"></i> Keluar</a>
            </div>
        </header>

        <div class="ph">
            <div class="orb o1"></div><div class="orb o2"></div>
            <div class="ph-content">
                <div class="ph-icon"><i class="fa-solid fa-calendar-days"></i></div>
                <h1>Aktiviti Masjid</h1>
                <p>Jadual program & aktiviti komuniti masjid</p>
            </div>
        </div>

        <main class="main">

            <c:if test="${not empty success}"><div class="alert a-ok"><i class="fa-solid fa-circle-check"></i> ${success}</div></c:if>
            <c:if test="${not empty error}"><div class="alert a-err"><i class="fa-solid fa-circle-exclamation"></i> ${error}</div></c:if>
            <c:if test="${param.msg == 'deleted'}"><div class="alert a-info"><i class="fa-solid fa-trash"></i> Permohonan aktiviti telah dipadamkan.</div></c:if>

                <div class="stats">
                    <div class="s-card">
                        <div class="s-ic" style="background:#e6f7f6;color:#0b8a83;"><i class="fa-solid fa-calendar-check"></i></div>
                        <div><b>${countUpcoming}</b><span>Aktiviti Akan Datang</span></div>
                </div>
                <div class="s-card">
                    <div class="s-ic" style="background:#d1fae5;color:#065f46;"><i class="fa-solid fa-list-check"></i></div>
                    <div><b>${approvedEvents.size()}</b><span>Jumlah Aktiviti</span></div>
                </div>
                <div class="s-card">
                    <div class="s-ic" style="background:#eff6ff;color:#2563eb;"><i class="fa-solid fa-paper-plane"></i></div>
                    <div><b>${myEvents.size()}</b><span>Permohonan Saya</span></div>
                </div>
            </div>

            <!-- KALENDAR AKTIVITI -->
            <div class="cal-card">
                <div class="cal-title">
                    <i class="fa-solid fa-calendar-days"></i> Kalendar Aktiviti
                    <span style="font-size:12px;font-weight:400;color:var(--light);margin-left:auto;">Klik tarikh untuk lihat butiran</span>
                </div>
                <div class="cal-legend">
                    <div class="cal-leg-item"><div class="cal-leg-dot" style="background:#10b981;"></div> Akan Datang</div>
                    <div class="cal-leg-item"><div class="cal-leg-dot" style="background:#f59e0b;"></div> Sedang Berlangsung</div>
                    <div class="cal-leg-item"><div class="cal-leg-dot" style="background:#9ca3af;"></div> Sudah Selesai</div>
                </div>
                <div id="activityCalendar"></div>
            </div>

            <%-- ============= SENARAI AKTIVITI AKAN DATANG & BERLANGSUNG ============= --%>
            <jsp:useBean id="now" class="java.util.Date" />
            <fmt:formatDate value="${now}" pattern="yyyyMMdd" var="todayInt" />
            <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="todayStr" />

            <%-- Kira berapa banyak yang akan datang + berlangsung (untuk badge count & empty state) --%>
            <c:set var="upcomingCount" value="0" />
            <c:forEach items="${approvedEvents}" var="ev">
                <fmt:formatDate value="${ev.date}" pattern="yyyyMMdd" var="d" />
                <c:if test="${d >= todayInt}">
                    <c:set var="upcomingCount" value="${upcomingCount + 1}" />
                </c:if>
            </c:forEach>

            <div class="sec-title">
                <i class="fa-solid fa-calendar-check"></i> Aktiviti Akan Datang & Berlangsung
                <span class="cnt">${upcomingCount} aktiviti</span>
            </div>
            <div class="sec-intro">Senarai aktiviti yang dijadualkan dan sedang berlangsung di masjid.</div>

            <c:choose>
                <c:when test="${upcomingCount == 0}">
                    <div class="empty-up">
                        <div class="empty-up-ic"><i class="fa-solid fa-calendar-plus"></i></div>
                        <h4>Tiada Aktiviti Akan Datang</h4>
                        <p>Belum ada aktiviti yang dijadualkan. Anda boleh memohon aktiviti baharu di bawah.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="ev-grid">
                        <c:set var="cardShown" value="0" />
                        <c:forEach items="${approvedEvents}" var="ev">
                            <fmt:formatDate value="${ev.date}" pattern="yyyyMMdd" var="eventInt" />

                            <%-- Skip yang dah lepas (Selesai) DAN had kepada 3 card sahaja --%>
                            <c:if test="${eventInt >= todayInt && cardShown < 3}">
                                <c:set var="cardShown" value="${cardShown + 1}" />
                                <fmt:formatDate value="${ev.date}" pattern="dd" var="dayNum" />
                                <fmt:formatDate value="${ev.date}" pattern="MMM" var="monShort" />

                                <%-- Kira beza hari untuk countdown --%>
                                <c:set var="daysDiff" value="${(eventInt - todayInt)}" />

                                <div class="up-card ${eventInt == todayInt ? 'is-live' : ''}">
                                    <div class="up-head">
                                        <div class="up-date-box">
                                            <div class="up-date-day">${dayNum}</div>
                                            <div class="up-date-mon">${monShort}</div>
                                        </div>
                                        <div class="up-badges">
                                            <c:choose>
                                                <c:when test="${eventInt == todayInt}">
                                                    <span class="up-pill up-live"><i class="fa-solid fa-circle"></i> Berlangsung</span>
                                                    <span class="up-countdown">Hari Ini</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="up-pill up-soon"><i class="fa-solid fa-calendar-days"></i> Akan Datang</span>
                                                    <c:choose>
                                                        <c:when test="${eventInt - todayInt == 1}"><span class="up-countdown">Esok</span></c:when>
                                                        <c:otherwise><span class="up-countdown">${eventInt - todayInt} hari lagi</span></c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="up-body">
                                        <div class="up-title">${ev.name}</div>
                                        <div class="up-meta">
                                            <c:if test="${ev.time != null}">
                                                <div class="up-meta-row"><i class="fa-regular fa-clock"></i><span>${ev.time}</span></div>
                                                    </c:if>
                                                    <c:if test="${not empty ev.location}">
                                                <div class="up-meta-row"><i class="fa-solid fa-location-dot"></i><span>${ev.location}</span></div>
                                                    </c:if>
                                        </div>
                                        <c:if test="${not empty ev.description}">
                                            <p class="up-desc">${ev.description}</p>
                                        </c:if>
                                    </div>
                                    <c:if test="${not empty ev.userName}">
                                        <div class="up-footer">
                                            <i class="fa-solid fa-user-tie"></i> Dianjurkan oleh <b>${ev.userName}</b>
                                        </div>
                                    </c:if>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>

                    <%-- Notice kalau ada lebih dari 3 aktiviti — direct ke kalendar --%>
                    <c:if test="${upcomingCount > 3}">
                        <div class="more-notice" onclick="scrollToCalendar()">
                            <div class="more-notice-ic"><i class="fa-solid fa-calendar-days"></i></div>
                            <div class="more-notice-text">
                                <b>Ada ${upcomingCount - 3} lagi aktiviti akan datang!</b>
                                <span>Klik di sini untuk lihat semua dalam kalendar di atas</span>
                            </div>
                            <i class="fa-solid fa-arrow-up more-notice-arrow"></i>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>

            <div class="sec-title"><i class="fa-solid fa-paper-plane"></i> Mohon Aktiviti Baharu</div>

            <div class="req-card">
                <div class="req-card-title">
                    <i class="fa-solid fa-circle-info"></i>
                    Isi borang untuk memohon aktiviti. Permohonan akan disemak oleh Koordinator (min. 3 hari sebelum tarikh).
                </div>
                <form action="${pageContext.request.contextPath}/activity" method="post">
                    <input type="hidden" name="action" value="request">
                    <div class="fg-grid">
                        <div class="fg">
                            <label>Nama Aktiviti *</label>
                            <input type="text" name="name" placeholder="Contoh: Majlis Ilmu" required>
                        </div>
                        <div class="fg">
                            <label>Tarikh * <small style="color:#ef4444;">(Min 3 hari dari hari ini)</small></label>
                            <input type="date" name="date" min="${minDate}" required>
                        </div>
                        <div class="fg">
                            <label>Masa</label>
                            <input type="time" name="time">
                        </div>
                        <div class="fg">
                            <label>Lokasi</label>
                            <input type="text" name="location" placeholder="Contoh: Dewan Solat Utama">
                        </div>
                        <div class="fg full">
                            <label>Penerangan</label>
                            <textarea name="description" placeholder="Huraian ringkas aktiviti..."></textarea>
                        </div>
                    </div>
                    <button type="submit" class="btn-req"><i class="fa-solid fa-paper-plane"></i> Hantar Permohonan</button>
                </form>
            </div>

            <%-- ============= PERMOHONAN SAYA — ACCORDION + FILTER ============= --%>
            <c:choose>
                <c:when test="${empty myEvents}">
                    <div class="sec-title">
                        <i class="fa-solid fa-user-clock"></i> Permohonan Saya
                        <span class="cnt">0 permohonan</span>
                    </div>
                    <div class="empty">
                        <i class="fa-solid fa-inbox"></i>
                        <p>Anda belum membuat sebarang permohonan aktiviti.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <%-- Kira counts untuk setiap status & bulan --%>
                    <c:set var="cntPending" value="0" />
                    <c:set var="cntApproved" value="0" />
                    <c:set var="cntRejected" value="0" />
                    <c:forEach items="${myEvents}" var="ev">
                        <c:choose>
                            <c:when test="${ev.requestStatus == 'PENDING_APPROVAL'}">
                                <c:set var="cntPending" value="${cntPending + 1}" />
                            </c:when>
                            <c:when test="${ev.requestStatus == 'APPROVED'}">
                                <c:set var="cntApproved" value="${cntApproved + 1}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="cntRejected" value="${cntRejected + 1}" />
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <%-- Header: Title kiri + Month dropdown kanan --%>
                    <div class="req-title-row">
                        <div class="sec-title">
                            <i class="fa-solid fa-user-clock"></i> Permohonan Saya
                            <span class="cnt">${myEvents.size()} permohonan</span>
                        </div>
                        <div class="month-wrap">
                            <button type="button" class="month-btn" id="monthBtn" onclick="toggleMonthDropdown(event)">
                                <span class="month-lbl"><i class="fa-solid fa-calendar"></i><span id="monthBtnLabel">Semua Bulan</span></span>
                                <i class="fa-solid fa-chevron-down chev"></i>
                            </button>
                            <div class="month-dropdown" id="monthDD">
                                <div class="month-opt selected" data-month="all" data-month-label="Semua Bulan" onclick="selectMonth(this)">
                                    Semua Bulan <span class="opt-cnt">${myEvents.size()}</span>
                                </div>
                                <%-- Render semua bulan, JS akan handle dedup --%>
                                <c:forEach items="${myEvents}" var="ev">
                                    <fmt:formatDate value="${ev.date}" pattern="yyyy-MM" var="monKey" />
                                    <fmt:formatDate value="${ev.date}" pattern="MMMM yyyy" var="monLabel" />
                                    <%-- Count event in this month --%>
                                    <c:set var="monCount" value="0" />
                                    <c:forEach items="${myEvents}" var="ev2">
                                        <fmt:formatDate value="${ev2.date}" pattern="yyyy-MM" var="monKey2" />
                                        <c:if test="${monKey == monKey2}">
                                            <c:set var="monCount" value="${monCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    <div class="month-opt" data-month="${monKey}" data-month-label="${monLabel}" onclick="selectMonth(this)" style="display:none;">
                                        ${monLabel} <span class="opt-cnt">${monCount}</span>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <%-- Tab status: semua sebaris --%>
                    <div class="tab-bar">
                        <button type="button" class="tab-btn active" data-status="all" onclick="filterByStatus(this)">
                            <i class="fa-solid fa-list"></i> Semua <span class="tab-count">${myEvents.size()}</span>
                        </button>
                        <button type="button" class="tab-btn tab-pend" data-status="PENDING_APPROVAL" onclick="filterByStatus(this)">
                            <i class="fa-solid fa-hourglass-half"></i> Menunggu <span class="tab-count">${cntPending}</span>
                        </button>
                        <button type="button" class="tab-btn tab-up" data-status="APPROVED" onclick="filterByStatus(this)">
                            <i class="fa-solid fa-circle-check"></i> Diluluskan <span class="tab-count">${cntApproved}</span>
                        </button>
                        <button type="button" class="tab-btn tab-rej" data-status="REJECTED" onclick="filterByStatus(this)">
                            <i class="fa-solid fa-circle-xmark"></i> Ditolak <span class="tab-count">${cntRejected}</span>
                        </button>
                    </div>

                    <%-- Result info banner --%>
                    <div class="result-info" id="resultInfo" style="display:none;">
                        <i class="fa-solid fa-circle-info"></i>
                        Menunjukkan <b id="resultCount">${myEvents.size()}</b> permohonan
                        <span id="resultFilters"></span>
                        <button type="button" class="clear-filter" onclick="clearAllFilters()">
                            <i class="fa-solid fa-xmark"></i> Buang Filter
                        </button>
                    </div>

                    <%-- Accordion list --%>
                    <div class="acc-group" id="accGroup">
                        <c:forEach items="${myEvents}" var="ev">
                            <fmt:formatDate value="${ev.date}" pattern="yyyy-MM" var="evMonth" />
                            <fmt:formatDate value="${ev.date}" pattern="dd MMM yyyy" var="evDateNice" />
                            <div class="acc-item" data-status="${ev.requestStatus}" data-month="${evMonth}">
                                <div class="acc-head" onclick="toggleAcc(this)">
                                    <c:choose>
                                        <c:when test="${ev.requestStatus == 'PENDING_APPROVAL'}">
                                            <div class="acc-status-ic acc-pend"><i class="fa-solid fa-hourglass-half"></i></div>
                                            </c:when>
                                            <c:when test="${ev.requestStatus == 'APPROVED'}">
                                            <div class="acc-status-ic acc-up"><i class="fa-solid fa-circle-check"></i></div>
                                            </c:when>
                                            <c:otherwise>
                                            <div class="acc-status-ic acc-rej"><i class="fa-solid fa-circle-xmark"></i></div>
                                            </c:otherwise>
                                        </c:choose>
                                    <div class="acc-main">
                                        <div class="acc-name">${ev.name}</div>
                                        <div class="acc-sub">
                                            <span><i class="fa-solid fa-calendar"></i> ${evDateNice}</span>
                                            <c:if test="${not empty ev.location}">
                                                <span><i class="fa-solid fa-location-dot"></i> ${ev.location}</span>
                                            </c:if>
                                        </div>
                                    </div>
                                    <c:choose>
                                        <c:when test="${ev.requestStatus == 'PENDING_APPROVAL'}">
                                            <span class="acc-badge acc-b-pend">Menunggu</span>
                                        </c:when>
                                        <c:when test="${ev.requestStatus == 'APPROVED'}">
                                            <span class="acc-badge acc-b-up">Diluluskan</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="acc-badge acc-b-rej">Ditolak</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <i class="fa-solid fa-chevron-down acc-chev"></i>
                                </div>
                                <div class="acc-body">
                                    <div class="acc-body-inner">
                                        <div class="acc-detail-grid">
                                            <c:if test="${ev.time != null}">
                                                <div class="acc-detail-row">
                                                    <div class="det-ic"><i class="fa-regular fa-clock"></i></div>
                                                    <div>
                                                        <div class="det-lbl">Masa</div>
                                                        <div class="det-val">${ev.time}</div>
                                                    </div>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty ev.location}">
                                                <div class="acc-detail-row">
                                                    <div class="det-ic"><i class="fa-solid fa-location-dot"></i></div>
                                                    <div>
                                                        <div class="det-lbl">Lokasi</div>
                                                        <div class="det-val">${ev.location}</div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>
                                        <c:if test="${not empty ev.description}">
                                            <div class="acc-desc">${ev.description}</div>
                                        </c:if>
                                        <c:if test="${ev.requestStatus == 'PENDING_APPROVAL' || ev.requestStatus == 'REJECTED'}">
                                            <div class="acc-actions">
                                                <button type="button" class="acc-btn acc-btn-ed"
                                                        onclick="event.stopPropagation();openEdit('${ev.eventId}', '${ev.name}', '${ev.date}', '${ev.time != null ? ev.time : ''}', '${ev.location}', '${ev.description}')">
                                                    <i class="fa-solid fa-pen"></i> Edit Permohonan
                                                </button>
                                                <form action="${pageContext.request.contextPath}/activity" method="post" style="flex:1;" onsubmit="event.stopPropagation();return confirm('Padam permohonan ini?')">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="event_id" value="${ev.eventId}">
                                                    <button type="submit" class="acc-btn acc-btn-del" style="width:100%;" onclick="event.stopPropagation()">
                                                        <i class="fa-solid fa-trash"></i> Padam
                                                    </button>
                                                </form>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <%-- Empty state bila filter tak ada hasil --%>
                    <div class="filter-empty" id="filterEmpty" style="display:none;">
                        <i class="fa-solid fa-filter-circle-xmark"></i>
                        <h4>Tiada Permohonan Dijumpai</h4>
                        <p>Tiada permohonan yang sepadan dengan pilihan filter anda.</p>
                    </div>
                </c:otherwise>
            </c:choose>

        </main>

        <div class="modal-ov" id="editModal">
            <div class="modal">
                <div class="modal-title"><i class="fa-solid fa-pen"></i> Kemaskini Permohonan</div>
                <form action="${pageContext.request.contextPath}/activity" method="post">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="event_id" id="editId">
                    <div class="fg-grid">
                        <div class="fg">
                            <label>Nama Aktiviti *</label>
                            <input type="text" name="name" id="editName" required>
                        </div>
                        <div class="fg">
                            <label>Tarikh * <small style="color:#ef4444;">(Min 3 hari dari hari ini)</small></label>
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
            window.addEventListener('scroll', () => document.getElementById('navbar').classList.toggle('scrolled', scrollY > 10));
            document.getElementById('hamburger').addEventListener('click', function () {
                this.classList.toggle('open');
                document.getElementById('mobNav').classList.toggle('open');
            });

            function openEdit(id, name, date, time, loc, desc) {
                document.getElementById('editId').value = id;
                document.getElementById('editName').value = name;

                // Ambil element input tarikh modal
                let dateInput = document.getElementById('editDate');
                dateInput.value = date;

                // Kunci semula syarat minima 3 hari mengikut data backend minDate
                dateInput.min = "${minDate}";

                document.getElementById('editTime').value = time;
                document.getElementById('editLoc').value = loc;
                document.getElementById('editDesc').value = desc;
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
            // ACCORDION + FILTER LOGIC (Permohonan Saya)
            // ============================================
            var currentStatus = 'all';
            var currentMonth = 'all';

            function toggleAcc(headEl) {
                headEl.parentElement.classList.toggle('open');
            }

            function toggleMonthDropdown(e) {
                e.stopPropagation();
                var btn = document.getElementById('monthBtn');
                var dd = document.getElementById('monthDD');
                btn.classList.toggle('open');
                dd.classList.toggle('show');
            }

            function selectMonth(optEl) {
                currentMonth = optEl.dataset.month;
                // Update UI
                document.querySelectorAll('.month-opt').forEach(function (o) {
                    o.classList.remove('selected');
                });
                optEl.classList.add('selected');
                // Update button label — ambil dari data-month-label, bukan textContent (elak count masuk sekali)
                var label = optEl.dataset.monthLabel || 'Semua Bulan';
                document.getElementById('monthBtnLabel').textContent = label;
                // Close dropdown
                document.getElementById('monthBtn').classList.remove('open');
                document.getElementById('monthDD').classList.remove('show');
                applyFilters();
            }

            function filterByStatus(btnEl) {
                currentStatus = btnEl.dataset.status;
                document.querySelectorAll('.tab-btn').forEach(function (b) {
                    b.classList.remove('active');
                });
                btnEl.classList.add('active');
                applyFilters();
            }

            function applyFilters() {
                var items = document.querySelectorAll('#accGroup .acc-item');
                var visibleCount = 0;
                items.forEach(function (item) {
                    var matchStatus = (currentStatus === 'all' || item.dataset.status === currentStatus);
                    var matchMonth = (currentMonth === 'all' || item.dataset.month === currentMonth);
                    if (matchStatus && matchMonth) {
                        item.style.display = '';
                        visibleCount++;
                    } else {
                        item.style.display = 'none';
                        // Auto-close yang ditapis keluar
                        item.classList.remove('open');
                    }
                });
                updateResultInfo(visibleCount);
                toggleEmptyState(visibleCount === 0);
            }

            function updateResultInfo(count) {
                var info = document.getElementById('resultInfo');
                if (!info)
                    return;
                var isFiltered = (currentStatus !== 'all' || currentMonth !== 'all');
                if (!isFiltered) {
                    info.style.display = 'none';
                    return;
                }
                info.style.display = 'flex';
                document.getElementById('resultCount').textContent = count;
                var filters = [];
                if (currentStatus !== 'all') {
                    var statusLabel = {
                        'PENDING_APPROVAL': 'Menunggu Kelulusan',
                        'APPROVED': 'Diluluskan',
                        'REJECTED': 'Ditolak'
                    }[currentStatus];
                    filters.push('berstatus <b>' + statusLabel + '</b>');
                }
                if (currentMonth !== 'all') {
                    var monthLabel = document.querySelector('.month-opt.selected').dataset.monthLabel || 'Bulan ini';
                    filters.push('dalam <b>' + monthLabel + '</b>');
                }
                document.getElementById('resultFilters').innerHTML = filters.length > 0 ? ' ' + filters.join(' ') : '';
            }

            function toggleEmptyState(showEmpty) {
                var emptyEl = document.getElementById('filterEmpty');
                var accGrp = document.getElementById('accGroup');
                if (!emptyEl || !accGrp)
                    return;
                if (showEmpty) {
                    emptyEl.style.display = 'block';
                    accGrp.style.display = 'none';
                } else {
                    emptyEl.style.display = 'none';
                    accGrp.style.display = '';
                }
            }

            function clearAllFilters() {
                currentStatus = 'all';
                currentMonth = 'all';
                // Reset status tabs
                document.querySelectorAll('.tab-btn').forEach(function (b) {
                    b.classList.remove('active');
                });
                var defaultTab = document.querySelector('.tab-btn[data-status="all"]');
                if (defaultTab)
                    defaultTab.classList.add('active');
                // Reset month dropdown
                document.querySelectorAll('.month-opt').forEach(function (o) {
                    o.classList.remove('selected');
                });
                var defaultMonth = document.querySelector('.month-opt[data-month="all"]');
                if (defaultMonth)
                    defaultMonth.classList.add('selected');
                document.getElementById('monthBtnLabel').textContent = 'Semua Bulan';
                applyFilters();
            }

            // Click outside untuk close month dropdown
            document.addEventListener('click', function (e) {
                var btn = document.getElementById('monthBtn');
                var dd = document.getElementById('monthDD');
                if (!btn || !dd)
                    return;
                if (!btn.contains(e.target) && !dd.contains(e.target)) {
                    btn.classList.remove('open');
                    dd.classList.remove('show');
                }
            });

            // Dedup month dropdown — tunjuk setiap bulan sekali sahaja
            document.addEventListener('DOMContentLoaded', function () {
                var seen = {};
                document.querySelectorAll('.month-opt[data-month]').forEach(function (opt) {
                    var key = opt.dataset.month;
                    if (key === 'all')
                        return;
                    if (seen[key]) {
                        opt.remove();
                    } else {
                        seen[key] = true;
                        opt.style.display = '';
                    }
                });
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
        <script>
            // Build events array from JSTL — bawa tarikh mentah, warna dikira di JS ikut tarikh sebenar hari ini
            var calEvents = [
            <c:forEach items="${calendarEvents}" var="ev" varStatus="loop">
            {
            title: "${ev.name}",
                    start: "${ev.date}",
                    extendedProps: {
                    eventId: "${ev.eventId}",
                            location: "${ev.location != null ? ev.location : '-'}",
                            time: "${ev.time != null ? ev.time : ''}",
                            organizer: "${ev.userName != null ? ev.userName : '-'}",
                            dateStr: "${ev.date}"
                    }
            }<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
            ];

            // Kira status sebenar event berbanding tarikh hari ini (bukan dari status DB)
            function getEventTimeStatus(dateStr) {
                var today = new Date();
                today.setHours(0, 0, 0, 0);
                var eventDate = new Date(dateStr);
                eventDate.setHours(0, 0, 0, 0);
                if (eventDate.getTime() < today.getTime()) return 'PAST';
                if (eventDate.getTime() === today.getTime()) return 'ONGOING';
                return 'UPCOMING';
            }

            // Warna ikut status sebenar: hijau = akan datang, kuning = hari ini, kelabu = sudah lepas
            function getEventColor(dateStr) {
                var s = getEventTimeStatus(dateStr);
                if (s === 'PAST') return '#9ca3af';
                if (s === 'ONGOING') return '#f59e0b';
                return '#10b981';
            }

            calEvents.forEach(function(ev) {
                ev.color = getEventColor(ev.start);
                ev.extendedProps.status = getEventTimeStatus(ev.start);
            });

            // Helper: ambil description dari hidden div by event ID
            function getEventDescription(eventId) {
                var el = document.getElementById('desc-ev-' + eventId);
                return el ? el.textContent : '';
            }

            // ===== MODAL POPUP FUNCTIONS =====
            function showEventModal(ev) {
                var props = ev.extendedProps;
                var timeStatus = getEventTimeStatus(props.dateStr);
                var statusLabel = timeStatus === 'ONGOING' ? 'Sedang Berlangsung'
                                 : timeStatus === 'PAST' ? 'Sudah Selesai'
                                 : 'Akan Datang';
                var isLive = timeStatus === 'ONGOING';

                // Format tarikh ke format Malaysia (e.g., "15 Jun 2026")
                var dateObj = new Date(props.dateStr);
                var months = ['Januari', 'Februari', 'Mac', 'April', 'Mei', 'Jun', 'Julai', 'Ogos', 'September', 'Oktober', 'November', 'Disember'];
                var formattedDate = dateObj.getDate() + ' ' + months[dateObj.getMonth()] + ' ' + dateObj.getFullYear();

                // Kira countdown
                var today = new Date();
                today.setHours(0, 0, 0, 0);
                var diffDays = Math.round((dateObj - today) / (1000 * 60 * 60 * 24));
                var countdown = '';
                if (diffDays === 0)
                    countdown = '<i class="fa-solid fa-circle"></i> Hari ini';
                else if (diffDays === 1)
                    countdown = '<i class="fa-solid fa-clock"></i> Esok';
                else if (diffDays > 0)
                    countdown = '<i class="fa-solid fa-clock"></i> ' + diffDays + ' hari lagi';
                else
                    countdown = '<i class="fa-solid fa-check"></i> Telah berlalu';

                // Ambil description dari hidden DOM element
                var description = getEventDescription(props.eventId);

                // Build modal HTML
                var modalHTML =
                        '<div class="ev-modal">' +
                        '<div class="ev-modal-head' + (isLive ? ' is-live' : '') + '">' +
                        '<button class="ev-modal-close" onclick="closeEventModal()" aria-label="Tutup">' +
                        '<i class="fa-solid fa-xmark"></i>' +
                        '</button>' +
                        '<div class="ev-modal-status"><span class="dot"></span> ' + statusLabel + '</div>' +
                        '<div class="ev-modal-title">' + ev.title + '</div>' +
                        '<div class="ev-modal-countdown">' + countdown + '</div>' +
                        '</div>' +
                        '<div class="ev-modal-body">' +
                        '<div class="ev-modal-row">' +
                        '<div class="ev-modal-row-ic"><i class="fa-solid fa-calendar"></i></div>' +
                        '<div class="ev-modal-row-content">' +
                        '<div class="ev-modal-row-label">Tarikh</div>' +
                        '<div class="ev-modal-row-val">' + formattedDate + '</div>' +
                        '</div>' +
                        '</div>' +
                        (props.time ?
                                '<div class="ev-modal-row">' +
                                '<div class="ev-modal-row-ic"><i class="fa-regular fa-clock"></i></div>' +
                                '<div class="ev-modal-row-content">' +
                                '<div class="ev-modal-row-label">Masa</div>' +
                                '<div class="ev-modal-row-val">' + props.time + '</div>' +
                                '</div>' +
                                '</div>' : '') +
                        (props.location && props.location !== '-' ?
                                '<div class="ev-modal-row">' +
                                '<div class="ev-modal-row-ic"><i class="fa-solid fa-location-dot"></i></div>' +
                                '<div class="ev-modal-row-content">' +
                                '<div class="ev-modal-row-label">Lokasi</div>' +
                                '<div class="ev-modal-row-val">' + props.location + '</div>' +
                                '</div>' +
                                '</div>' : '') +
                        (props.organizer && props.organizer !== '-' ?
                                '<div class="ev-modal-row">' +
                                '<div class="ev-modal-row-ic"><i class="fa-solid fa-user-tie"></i></div>' +
                                '<div class="ev-modal-row-content">' +
                                '<div class="ev-modal-row-label">Dianjurkan Oleh</div>' +
                                '<div class="ev-modal-row-val">' + props.organizer + '</div>' +
                                '</div>' +
                                '</div>' : '') +
                        (description ?
                                '<div class="ev-modal-row">' +
                                '<div class="ev-modal-row-ic"><i class="fa-solid fa-circle-info"></i></div>' +
                                '<div class="ev-modal-row-content">' +
                                '<div class="ev-modal-row-label">Penerangan</div>' +
                                '<div class="ev-modal-row-val desc">' + description + '</div>' +
                                '</div>' +
                                '</div>' : '') +
                        '</div>' +
                        '</div>';

                var overlay = document.getElementById('eventModalOverlay');
                overlay.innerHTML = modalHTML;
                overlay.classList.add('show');
                document.body.style.overflow = 'hidden';
            }

            function closeEventModal() {
                var overlay = document.getElementById('eventModalOverlay');
                overlay.classList.remove('show');
                document.body.style.overflow = '';
            }

            // Scroll up to kalendar
            function scrollToCalendar() {
                var cal = document.querySelector('.cal-card');
                if (cal)
                    cal.scrollIntoView({behavior: 'smooth', block: 'start'});
            }

            // Tutup modal bila klik luar atau ESC
            document.addEventListener('DOMContentLoaded', function () {
                var overlay = document.getElementById('eventModalOverlay');
                if (overlay) {
                    overlay.addEventListener('click', function (e) {
                        if (e.target === overlay)
                            closeEventModal();
                    });
                }
                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape')
                        closeEventModal();
                });
            });

            document.addEventListener('DOMContentLoaded', function () {
                var calEl = document.getElementById('activityCalendar');
                if (!calEl)
                    return;
                var calendar = new FullCalendar.Calendar(calEl, {
                    initialView: 'dayGridMonth',
                    locale: 'ms',
                    headerToolbar: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'dayGridMonth,listWeek'
                    },
                    buttonText: {today: 'Hari Ini', month: 'Bulan', list: 'Senarai'},
                    events: calEvents,
                    eventClick: function (info) {
                        showEventModal(info.event);
                    },
                    dayCellDidMount: function (info) {
                        // Highlight hari yang ada event
                    }
                });
                calendar.render();
            });
        </script>

        <!-- ===== EVENT DETAIL MODAL (popup bila klik kalendar) ===== -->
        <div id="eventModalOverlay" class="ev-modal-overlay"></div>

        <!-- ===== HIDDEN DESCRIPTION STORE (untuk modal popup) ===== -->
        <div style="display:none;" aria-hidden="true">
            <c:forEach items="${calendarEvents}" var="ev">
                <div id="desc-ev-${ev.eventId}"><c:out value="${ev.description}" default="" /></div>
            </c:forEach>
        </div>
    </body>
</html>