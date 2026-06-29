<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ms">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MMS - Sistem Pengurusan Masjid</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/landing.css">
    </head>
    <body>

        <!-- ===== NAVBAR ===== -->
        <nav class="navbar" id="navbar">
            <div class="nav-container">
                <a href="#" class="nav-brand">
                    <div class="nav-logo">
                        <i class="fa-solid fa-mosque"></i>
                    </div>
                    <span>MMS</span>
                </a>
                <ul class="nav-links">
                    <li><a href="#features">Ciri-ciri</a></li>
                    <li><a href="#about">Tentang Kami</a></li>
                    <li><a href="#contact">Hubungi</a></li>
                </ul>
                <div class="nav-actions">
                    <a href="${pageContext.request.contextPath}/login" class="btn-login">Log Masuk</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn-daftar">Daftar Sekarang</a>
                </div>
                <button class="hamburger" id="hamburger" aria-label="Menu">
                    <span></span><span></span><span></span>
                </button>
            </div>
            <!-- Mobile Menu -->
            <div class="mobile-menu" id="mobileMenu">
                <a href="#features">Ciri-ciri</a>
                <a href="#about">Tentang Kami</a>
                <a href="#contact">Hubungi</a>
                <a href="${pageContext.request.contextPath}/login" class="mobile-login">Log Masuk</a>
                <a href="${pageContext.request.contextPath}/register" class="mobile-daftar">Daftar Sekarang</a>
            </div>
        </nav>

        <!-- ===== HERO SECTION ===== -->
        <section class="hero">
            <div class="hero-bg-pattern"></div>
            <div class="hero-orb orb-1"></div>
            <div class="hero-orb orb-2"></div>
            <div class="hero-container">
                <div class="hero-badge">
                    <i class="fa-solid fa-star"></i>
                    Sistem Pengurusan Masjid Digital
                </div>
                <h1 class="hero-title">
                    Urus Masjid Anda<br>
                    <span class="hero-highlight">Lebih Mudah & Cekap</span>
                </h1>
                <p class="hero-desc">
                    Platform pengurusan masjid bersepadu yang menghubungkan AJK, jemaah dan kemudahan masjid
                    dalam satu sistem yang mudah digunakan.
                </p>
                <div class="hero-cta">
                    <a href="${pageContext.request.contextPath}/register" class="cta-primary">
                        <i class="fa-solid fa-rocket"></i>
                        Mulakan Sekarang — Percuma
                    </a>
                    <a href="#features" class="cta-secondary">
                        Ketahui Lebih Lanjut
                        <i class="fa-solid fa-arrow-down"></i>
                    </a>
                </div>
                <div class="hero-stats">
                    <div class="stat-item">
                        <span class="stat-number">500+</span>
                        <span class="stat-label">Masjid Berdaftar</span>
                    </div>
                    <div class="stat-divider"></div>
                    <div class="stat-item">
                        <span class="stat-number">12K+</span>
                        <span class="stat-label">Pengguna Aktif</span>
                    </div>
                    <div class="stat-divider"></div>
                    <div class="stat-item">
                        <span class="stat-number">98%</span>
                        <span class="stat-label">Kepuasan Pengguna</span>
                    </div>
                </div>
            </div>
            <!-- Hero Visual -->
            <div class="hero-visual">
                <div class="hero-card card-main">
                    <div class="card-header">
                        <i class="fa-solid fa-mosque"></i>
                        <span>Masjid Al-Furqan</span>
                        <span class="card-badge">Aktif</span>
                    </div>
                    <div class="card-stats-row">
                        <div class="cs">
                            <i class="fa-solid fa-calendar-check"></i>
                            <div>
                                <b>24</b>
                                <small>Tempahan Bulan Ini</small>
                            </div>
                        </div>
                        <div class="cs">
                            <i class="fa-solid fa-users"></i>
                            <div>
                                <b>8</b>
                                <small>Ahli AJK</small>
                            </div>
                        </div>
                    </div>
                    <div class="card-event">
                        <span class="event-dot"></span>
                        <div>
                            <p>Solat Jumaat</p>
                            <small>Hari ini, 1:00 PM</small>
                        </div>
                    </div>
                    <div class="card-event">
                        <span class="event-dot dot-orange"></span>
                        <div>
                            <p>Kelas Fardhu Ain</p>
                            <small>Esok, 8:00 AM</small>
                        </div>
                    </div>
                </div>
                <div class="hero-card card-mini card-mini-1">
                    <i class="fa-solid fa-hand-holding-heart"></i>
                    <div>
                        <b>RM 4,250</b>
                        <small>Sumbangan Terkini</small>
                    </div>
                </div>
                <div class="hero-card card-mini card-mini-2">
                    <i class="fa-solid fa-bell"></i>
                    <div>
                        <b>3 Notifikasi</b>
                        <small>Menunggu kelulusan</small>
                    </div>
                </div>
            </div>
        </section>

        <!-- ===== FEATURES SECTION ===== -->
        <section class="features" id="features">
            <div class="section-container">
                <div class="section-label">
                    <i class="fa-solid fa-sparkles"></i> Ciri-ciri Utama
                </div>
                <h2 class="section-title">Semua Yang Anda Perlukan</h2>
                <p class="section-subtitle">
                    Direka khusus untuk keperluan pengurusan masjid moden di Malaysia
                </p>
                <div class="features-grid">
                    <div class="feature-card" data-delay="0">
                        <div class="feature-icon">
                            <i class="fa-solid fa-calendar-days"></i>
                        </div>
                        <h3>Tempahan Fasiliti</h3>
                        <p>Urus tempahan dewan, surau dan kemudahan masjid secara online dengan mudah dan pantas.</p>
                        <a href="${pageContext.request.contextPath}/register" class="feature-link">
                            Cuba Sekarang <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                    <div class="feature-card" data-delay="100">
                        <div class="feature-icon">
                            <i class="fa-solid fa-user-tie"></i>
                        </div>
                        <h3>Profil AJK Masjid</h3>
                        <p>Rekod dan urus maklumat Ahli Jawatankuasa masjid dengan sistematik dan teratur.</p>
                        <a href="${pageContext.request.contextPath}/register" class="feature-link">
                            Cuba Sekarang <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                    <div class="feature-card" data-delay="200">
                        <div class="feature-icon">
                            <i class="fa-solid fa-bullhorn"></i>
                        </div>
                        <h3>Aktiviti Masjid</h3>
                        <p>Rancang, iklan dan pantau semua aktiviti dan program masjid dalam satu platform.</p>
                        <a href="${pageContext.request.contextPath}/register" class="feature-link">
                            Cuba Sekarang <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                    <div class="feature-card" data-delay="300">
                        <div class="feature-icon">
                            <i class="fa-solid fa-hand-holding-dollar"></i>
                        </div>
                        <h3>E-Sumbangan</h3>
                        <p>Terima dan rekod sumbangan jemaah secara digital dengan laporan kewangan yang jelas.</p>
                        <a href="${pageContext.request.contextPath}/register" class="feature-link">
                            Cuba Sekarang <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                    <div class="feature-card" data-delay="400">
                        <div class="feature-icon">
                            <i class="fa-solid fa-bell-concierge"></i>
                        </div>
                        <h3>Notifikasi Masa Nyata</h3>
                        <p>Terima makluman terkini berkenaan aktiviti, kelulusan dan pengumuman penting masjid.</p>
                        <a href="${pageContext.request.contextPath}/register" class="feature-link">
                            Cuba Sekarang <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <!-- ===== ABOUT / HOW IT WORKS ===== -->
        <section class="how-it-works" id="about">
            <div class="section-container">
                <div class="section-label">
                    <i class="fa-solid fa-circle-info"></i> Cara Penggunaan
                </div>
                <h2 class="section-title">Mudah Digunakan, Dua Langkah</h2>
                <div class="steps-grid">
                    <div class="step-item">
                        <div class="step-number">01</div>
                        <div class="step-icon"><i class="fa-solid fa-user-plus"></i></div>
                        <h3>Daftar Akaun</h3>
                        <p>Daftarkan diri anda secara percuma dalam masa kurang dari 2 minit. Tiada caj tersembunyi.</p>
                    </div>
                    <div class="step-connector">
                        <i class="fa-solid fa-arrow-right"></i>
                    </div>
                    <div class="step-item">
                        <div class="step-number">02</div>
                        <div class="step-icon"><i class="fa-solid fa-wand-magic-sparkles"></i></div>
                        <h3>Mula Mengurus</h3>
                        <p>Akses semua ciri pengurusan masjid terus dari telefon atau komputer anda.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- ===== CTA BANNER ===== -->
        <section class="cta-banner">
            <div class="cta-orb cta-orb-1"></div>
            <div class="cta-orb cta-orb-2"></div>
            <div class="cta-content">
                <div class="cta-icon"><i class="fa-solid fa-mosque"></i></div>
                <h2>Sedia untuk bermula?</h2>
                <p>Sertai ribuan pengguna yang telah mempercayai MMS untuk mengurus masjid mereka.</p>
                <div class="cta-buttons">
                    <a href="${pageContext.request.contextPath}/register" class="cta-btn-white">
                        <i class="fa-solid fa-user-plus"></i> Daftar Percuma
                    </a>
                    <a href="${pageContext.request.contextPath}/login" class="cta-btn-outline">
                        Log Masuk
                    </a>
                </div>
            </div>
        </section>

        <!-- ===== FOOTER ===== -->
        <footer class="footer" id="contact">
            <div class="footer-container">
                <div class="footer-brand">
                    <div class="footer-logo">
                        <i class="fa-solid fa-mosque"></i>
                        <span>MMS</span>
                    </div>
                    <p>Sistem Pengurusan Masjid Berpusat — mendigitalkan pengurusan masjid di seluruh Malaysia.</p>
                    <div class="footer-socials">
                        <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                        <a href="#"><i class="fa-brands fa-twitter"></i></a>
                        <a href="#"><i class="fa-brands fa-instagram"></i></a>
                    </div>
                </div>
                <div class="footer-links">
                    <h4>Pautan Pantas</h4>
                    <ul>
                        <li><a href="#features">Ciri-ciri</a></li>
                        <li><a href="#about">Tentang Kami</a></li>
                        <li><a href="${pageContext.request.contextPath}/login">Log Masuk</a></li>
                        <li><a href="${pageContext.request.contextPath}/register">Daftar</a></li>
                    </ul>
                </div>
                <div class="footer-links">
                    <h4>Hubungi Kami</h4>
                    <ul>
                        <li><i class="fa-solid fa-envelope"></i> info@mms.gov.my</li>
                        <li><i class="fa-solid fa-phone"></i> 03-1234 5678</li>
                        <li><i class="fa-solid fa-location-dot"></i> Kuala Lumpur, Malaysia</li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>© 2025 Sistem Pengurusan Masjid (MMS). Hak Cipta Terpelihara.</p>
            </div>
        </footer>

        <script>
            // Navbar scroll effect
            window.addEventListener('scroll', () => {
                const nav = document.getElementById('navbar');
                nav.classList.toggle('scrolled', window.scrollY > 50);
            });

            // Hamburger menu
            document.getElementById('hamburger').addEventListener('click', () => {
                document.getElementById('mobileMenu').classList.toggle('open');
                document.getElementById('hamburger').classList.toggle('active');
            });

            // Smooth scroll for anchor links
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        e.preventDefault();
                        target.scrollIntoView({behavior: 'smooth', block: 'start'});
                        document.getElementById('mobileMenu').classList.remove('open');
                    }
                });
            });

            // Animate feature cards on scroll
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const delay = entry.target.getAttribute('data-delay') || 0;
                        setTimeout(() => {
                            entry.target.classList.add('visible');
                        }, parseInt(delay));
                    }
                });
            }, {threshold: 0.1});

            document.querySelectorAll('.feature-card, .step-item').forEach(el => observer.observe(el));
        </script>
    </body>
</html>
