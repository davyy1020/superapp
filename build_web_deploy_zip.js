const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

console.log('========================================================');
console.log('🚀 MEMPERSIAPKAN PAKET DEPLOY WEB BISPIRA UNTUK CPANEL');
console.log('========================================================');

const deployDir = path.join(__dirname, 'BISPIRA_WEB_DEPLOY');
const zipOutput = path.join(__dirname, 'bispira_web_suite_deploy.zip');

// Clean and recreate directory
if (fs.existsSync(deployDir)) {
  fs.rmSync(deployDir, { recursive: true, force: true });
}
fs.mkdirSync(deployDir, { recursive: true });

// Apps to include
const apps = [
  { id: 'user', name: 'Bispira User SuperApp', src: path.join(__dirname, 'bispira_user_app', 'build', 'web') },
  { id: 'merchant', name: 'Bispira Merchant / Resto', src: path.join(__dirname, 'bispira_merchant_app', 'build', 'web') },
  { id: 'driver', name: 'Bispira Driver / Kurir', src: path.join(__dirname, 'bispira_driver_app', 'build', 'web') },
  { id: 'admin', name: 'Bispira Superadmin Web Suite', src: path.join(__dirname, 'bispira_desktop_admin', 'build', 'web') },
  { id: 'health', name: 'Bispira Health & Homecare', src: path.join(__dirname, 'bispira_health_app', 'build', 'web') },
  { id: 'expert', name: 'Bispira Expert & Konsultan', src: path.join(__dirname, 'bispira_expert_app', 'build', 'web') },
];

// Helper to copy recursively
function copyFolderSync(from, to) {
  fs.mkdirSync(to, { recursive: true });
  fs.readdirSync(from).forEach(element => {
    const fromPath = path.join(from, element);
    const toPath = path.join(to, element);
    if (fs.lstatSync(fromPath).isDirectory()) {
      copyFolderSync(fromPath, toPath);
    } else {
      fs.copyFileSync(fromPath, toPath);
    }
  });
}

// 1. Copy each Flutter Web App and adjust <base href>
apps.forEach(app => {
  if (fs.existsSync(app.src)) {
    const targetDir = path.join(deployDir, app.id);
    console.log(`[COPYING] ${app.name} -> /${app.id}/`);
    copyFolderSync(app.src, targetDir);

    // Adjust base href in index.html for subdirectory hosting
    const indexPath = path.join(targetDir, 'index.html');
    if (fs.existsSync(indexPath)) {
      let html = fs.readFileSync(indexPath, 'utf8');
      html = html.replace(/<base href="\/">/g, `<base href="/${app.id}/">`);
      fs.writeFileSync(indexPath, html, 'utf8');
      console.log(`[BASE-HREF] Updated <base href="/${app.id}/"> in ${app.id}/index.html`);
    }
  } else {
    console.warn(`[WARNING] Build folder tidak ditemukan untuk ${app.name}: ${app.src}`);
  }
});

// 2. Copy Web Landing Portal
const portalSrc = path.join(__dirname, 'bispira_web_portal');
if (fs.existsSync(portalSrc)) {
  const targetPortal = path.join(deployDir, 'portal');
  console.log('[COPYING] Bispira Web Portal -> /portal/');
  copyFolderSync(portalSrc, targetPortal);
}

// 3. Create Hub index.html (Root Landing & Testing Suite)
const hubHtml = `<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>BISPIRA SuperApp - Web Testing Suite & Live Hub</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800;900&display=swap" rel="stylesheet">
  <style>
    :root {
      --bg: #0F172A;
      --card-bg: #1E293B;
      --border: #334155;
      --brand: #2563EB;
      --text: #F8FAFC;
      --text-muted: #94A3B8;
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Plus Jakarta Sans', sans-serif;
      background: var(--bg);
      color: var(--text);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }
    header {
      background: rgba(30, 41, 59, 0.9);
      backdrop-filter: blur(12px);
      border-bottom: 1px solid var(--border);
      padding: 16px 32px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      position: sticky;
      top: 0;
      z-index: 50;
    }
    .logo-badge {
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .logo-badge h1 {
      font-size: 20px;
      font-weight: 900;
      letter-spacing: -0.5px;
      background: linear-gradient(135deg, #60A5FA, #3B82F6, #F97316);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    .status-pill {
      background: #10B98122;
      color: #34D399;
      border: 1px solid #059669;
      padding: 6px 14px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .status-dot {
      width: 8px;
      height: 8px;
      background: #10B981;
      border-radius: 50%;
      box-shadow: 0 0 10px #10B981;
    }
    .main-container {
      max-width: 1300px;
      margin: 0 auto;
      padding: 36px 24px;
      width: 100%;
      flex: 1;
    }
    .hero {
      text-align: center;
      margin-bottom: 36px;
    }
    .hero h2 {
      font-size: 32px;
      font-weight: 900;
      margin-bottom: 8px;
    }
    .hero p {
      color: var(--text-muted);
      font-size: 15px;
      max-width: 700px;
      margin: 0 auto;
    }
    .highlight-card {
      background: linear-gradient(135deg, rgba(37, 99, 235, 0.2), rgba(249, 115, 22, 0.2));
      border: 1px solid rgba(59, 130, 246, 0.4);
      border-radius: 20px;
      padding: 24px 32px;
      margin-bottom: 36px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 16px;
    }
    .highlight-info h3 {
      font-size: 20px;
      font-weight: 800;
      margin-bottom: 6px;
    }
    .highlight-info p {
      color: #CBD5E1;
      font-size: 13.5px;
    }
    .highlight-btn {
      background: linear-gradient(135deg, #2563EB, #1D4ED8);
      color: white;
      text-decoration: none;
      padding: 12px 24px;
      border-radius: 12px;
      font-weight: 800;
      font-size: 14px;
      box-shadow: 0 4px 14px rgba(37, 99, 235, 0.4);
      transition: all 0.2s;
    }
    .highlight-btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(37, 99, 235, 0.6);
    }
    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
      gap: 20px;
      margin-bottom: 40px;
    }
    .app-card {
      background: var(--card-bg);
      border: 1px solid var(--border);
      border-radius: 18px;
      padding: 24px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      transition: all 0.25s ease;
    }
    .app-card:hover {
      border-color: #60A5FA;
      transform: translateY(-4px);
      box-shadow: 0 12px 28px rgba(0,0,0,0.4);
    }
    .card-header {
      display: flex;
      align-items: flex-start;
      gap: 16px;
      margin-bottom: 14px;
    }
    .app-icon {
      font-size: 32px;
      background: #0F172A;
      width: 54px;
      height: 54px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 14px;
      border: 1px solid var(--border);
    }
    .app-meta h4 {
      font-size: 17px;
      font-weight: 800;
      margin-bottom: 4px;
    }
    .app-route {
      display: inline-block;
      font-size: 11px;
      font-weight: 700;
      background: #334155;
      color: #93C5FD;
      padding: 2px 8px;
      border-radius: 6px;
      font-family: monospace;
    }
    .app-desc {
      color: var(--text-muted);
      font-size: 13px;
      line-height: 1.5;
      margin-bottom: 20px;
    }
    .card-actions {
      display: flex;
      gap: 10px;
    }
    .btn-open {
      flex: 1;
      background: #2563EB;
      color: white;
      text-decoration: none;
      padding: 10px 16px;
      border-radius: 10px;
      font-weight: 700;
      font-size: 13px;
      text-align: center;
      transition: background 0.2s;
    }
    .btn-open:hover {
      background: #1D4ED8;
    }
    .btn-preview {
      background: #334155;
      color: #E2E8F0;
      border: none;
      cursor: pointer;
      padding: 10px 14px;
      border-radius: 10px;
      font-weight: 700;
      font-size: 13px;
      transition: background 0.2s;
    }
    .btn-preview:hover {
      background: #475569;
    }
    /* Modal Simulator */
    .modal-backdrop {
      display: none;
      position: fixed;
      top: 0; left: 0; width: 100%; height: 100%;
      background: rgba(0,0,0,0.85);
      backdrop-filter: blur(8px);
      z-index: 100;
      justify-content: center;
      align-items: center;
    }
    .modal-box {
      background: #1E293B;
      border-radius: 24px;
      border: 1px solid var(--border);
      width: 95%;
      max-width: 480px;
      height: 88vh;
      display: flex;
      flex-direction: column;
      overflow: hidden;
      box-shadow: 0 25px 50px -12px rgba(0,0,0,0.8);
    }
    .modal-header {
      padding: 12px 20px;
      background: #0F172A;
      border-bottom: 1px solid var(--border);
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .modal-header span {
      font-size: 13px;
      font-weight: 800;
      color: #94A3B8;
    }
    .close-btn {
      background: none;
      border: none;
      color: #94A3B8;
      font-size: 20px;
      cursor: pointer;
    }
    .device-frame {
      flex: 1;
      width: 100%;
      border: none;
      background: white;
    }
    footer {
      text-align: center;
      padding: 24px;
      color: var(--text-muted);
      font-size: 12px;
      border-top: 1px solid var(--border);
    }
  </style>
</head>
<body>
  <header>
    <div class="logo-badge">
      <span style="font-size: 26px;">⚡</span>
      <div>
        <h1>BISPIRA SUPERAPP</h1>
        <div style="font-size: 11px; color: var(--text-muted); font-weight: 600;">Ekosistem Web Production & Testing Suite</div>
      </div>
    </div>
    <div class="status-pill">
      <div class="status-dot"></div>
      Production Web Live
    </div>
  </header>

  <div class="main-container">
    <div class="hero">
      <h2>Uji Coba Seluruh Ekosistem Aplikasi BISPIRA</h2>
      <p>Klik tombol untuk membuka aplikasi secara penuh di tab baru, atau gunakan simulator untuk melihat tampilan responsif smartphone langsung di layar Anda.</p>
    </div>

    <!-- Live Cloud Backend Highlight -->
    <div class="highlight-card">
      <div class="highlight-info">
        <h3>🚀 Superadmin Production Cloud (Next.js 16)</h3>
        <p>Akses langsung web admin eksekutif. Terhubung live ke MySQL cPanel dengan 13 kluster produk dan ledger transaksi real-time.</p>
      </div>
      <a href="https://superapp.agungtrijayaabadi.com/" target="_blank" class="highlight-btn">Buka Admin Cloud 🌐</a>
    </div>

    <!-- Grid of Apps -->
    <div class="grid">
      <!-- User App -->
      <div class="app-card">
        <div>
          <div class="card-header">
            <div class="app-icon">📱</div>
            <div class="app-meta">
              <h4>Bispira User SuperApp</h4>
              <span class="app-route">/user/</span>
            </div>
          </div>
          <p class="app-desc">Aplikasi Konsumen: Food (Delivery vs Pick Up Ongkir Rp 0), Ride Hailing, Health, Donasi, Pajak Penjual, dan E-Voting.</p>
        </div>
        <div class="card-actions">
          <a href="./user/" target="_blank" class="btn-open">Buka di Tab Baru ↗</a>
          <button class="btn-preview" onclick="openSimulator('./user/', 'Bispira User App')">📱 Simulator</button>
        </div>
      </div>

      <!-- Merchant App -->
      <div class="app-card">
        <div>
          <div class="card-header">
            <div class="app-icon">🏪</div>
            <div class="app-meta">
              <h4>Bispira Merchant / Resto</h4>
              <span class="app-route">/merchant/</span>
            </div>
          </div>
          <p class="app-desc">Aplikasi Kasir Outlet & Dapur: Manajemen Pesanan, Badge Khusus PICK UP vs DELIVERY, Notifikasi Masak & Serah Terima.</p>
        </div>
        <div class="card-actions">
          <a href="./merchant/" target="_blank" class="btn-open">Buka di Tab Baru ↗</a>
          <button class="btn-preview" onclick="openSimulator('./merchant/', 'Bispira Merchant App')">📱 Simulator</button>
        </div>
      </div>

      <!-- Driver App -->
      <div class="app-card">
        <div>
          <div class="card-header">
            <div class="app-icon">🛵</div>
            <div class="app-meta">
              <h4>Bispira Driver / Kurir</h4>
              <span class="app-route">/driver/</span>
            </div>
          </div>
          <p class="app-desc">Aplikasi Mitra Pengemudi: Integrasi Rute Navigasi Peta OSRM, Manajemen Order Motor/Mobil/Kurir, Bagi Hasil Real-Time 95%.</p>
        </div>
        <div class="card-actions">
          <a href="./driver/" target="_blank" class="btn-open">Buka di Tab Baru ↗</a>
          <button class="btn-preview" onclick="openSimulator('./driver/', 'Bispira Driver App')">📱 Simulator</button>
        </div>
      </div>

      <!-- Superadmin Web Suite -->
      <div class="app-card">
        <div>
          <div class="card-header">
            <div class="app-icon">🖥️</div>
            <div class="app-meta">
              <h4>Superadmin Web Suite</h4>
              <span class="app-route">/admin/</span>
            </div>
          </div>
          <p class="app-desc">Versi Flutter Web Desktop Suite: Panel Eksekutif, Visualisasi Dashboard Finansial, Manajemen 13 Kluster, dan Monitoring Mitra.</p>
        </div>
        <div class="card-actions">
          <a href="./admin/" target="_blank" class="btn-open">Buka di Tab Baru ↗</a>
          <button class="btn-preview" onclick="openSimulator('./admin/', 'Superadmin Desktop Web')">💻 Preview</button>
        </div>
      </div>

      <!-- Health App -->
      <div class="app-card">
        <div>
          <div class="card-header">
            <div class="app-icon">🩺</div>
            <div class="app-meta">
              <h4>Bispira Health & Homecare</h4>
              <span class="app-route">/health/</span>
            </div>
          </div>
          <p class="app-desc">Layanan Tenaga Kesehatan: Booking Dokter, Homecare Perawat, Uji Lab Mandiri, dan Manajemen Jadwal Medis.</p>
        </div>
        <div class="card-actions">
          <a href="./health/" target="_blank" class="btn-open">Buka di Tab Baru ↗</a>
          <button class="btn-preview" onclick="openSimulator('./health/', 'Health & Homecare')">📱 Simulator</button>
        </div>
      </div>

      <!-- Expert App -->
      <div class="app-card">
        <div>
          <div class="card-header">
            <div class="app-icon">👨‍💼</div>
            <div class="app-meta">
              <h4>Bispira Expert & Konsultan</h4>
              <span class="app-route">/expert/</span>
            </div>
          </div>
          <p class="app-desc">Konsultasi Profesional: Ahli Hukum, Pajak, Bisnis, Edukasi, dan Perencanaan Finansial dengan Tarif Per Sesi.</p>
        </div>
        <div class="card-actions">
          <a href="./expert/" target="_blank" class="btn-open">Buka di Tab Baru ↗</a>
          <button class="btn-preview" onclick="openSimulator('./expert/', 'Expert & Konsultan')">📱 Simulator</button>
        </div>
      </div>

      <!-- Web Portal -->
      <div class="app-card">
        <div>
          <div class="card-header">
            <div class="app-icon">🌐</div>
            <div class="app-meta">
              <h4>Bispira Web Landing Portal</h4>
              <span class="app-route">/portal/</span>
            </div>
          </div>
          <p class="app-desc">Halaman Publik Ekosistem: Profil Perusahaan, Katalog Layanan Publik, Informasi Pendaftaran Mitra, dan Pusat Bantuan.</p>
        </div>
        <div class="card-actions">
          <a href="./portal/" target="_blank" class="btn-open">Buka di Tab Baru ↗</a>
          <button class="btn-preview" onclick="openSimulator('./portal/', 'Landing Portal')">🌐 Preview</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Device Simulator Modal -->
  <div class="modal-backdrop" id="modalBackdrop" onclick="closeSimulator(event)">
    <div class="modal-box" onclick="event.stopPropagation()">
      <div class="modal-header">
        <span id="simulatorTitle">📱 Simulator Phone</span>
        <button class="close-btn" onclick="closeSimulator()">&times;</button>
      </div>
      <iframe class="device-frame" id="simulatorFrame" src="about:blank"></iframe>
    </div>
  </div>

  <footer>
    Ekosistem BISPIRA SuperApp • PT Agung Tri Jaya Abadi • Production Deployment Build
  </footer>

  <script>
    function openSimulator(url, name) {
      document.getElementById('simulatorTitle').innerText = name + ' (Live Simulation)';
      document.getElementById('simulatorFrame').src = url;
      document.getElementById('modalBackdrop').style.display = 'flex';
    }
    function closeSimulator() {
      document.getElementById('simulatorFrame').src = 'about:blank';
      document.getElementById('modalBackdrop').style.display = 'none';
    }
  </script>
</body>
</html>`;
fs.writeFileSync(path.join(deployDir, 'index.html'), hubHtml, 'utf8');
console.log('[CREATED] BISPIRA_WEB_DEPLOY/index.html (Unified Hub & Simulator)');

// 4. Create .htaccess for cPanel / Apache
const htaccess = `# BISPIRA Web Production Deployment Configuration
RewriteEngine On

# MIME Types for Modern Web & Flutter WASM
AddType application/wasm .wasm
AddType application/javascript .js .mjs
AddType application/json .json
AddType image/svg+xml .svg
AddType font/woff2 .woff2
AddType font/woff .woff
AddType font/ttf .ttf

# Enable GZIP Compression
<IfModule mod_deflate.c>
  AddOutputFilterByType DEFLATE text/html text/plain text/css application/json
  AddOutputFilterByType DEFLATE application/javascript application/wasm
  AddOutputFilterByType DEFLATE image/svg+xml
</IfModule>

# Subdirectory Routing for Flutter Single Page Applications (SPA)
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^user/(.*)$ user/index.html [L]

RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^merchant/(.*)$ merchant/index.html [L]

RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^driver/(.*)$ driver/index.html [L]

RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^admin/(.*)$ admin/index.html [L]

RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^health/(.*)$ health/index.html [L]

RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^expert/(.*)$ expert/index.html [L]
`;
fs.writeFileSync(path.join(deployDir, '.htaccess'), htaccess, 'utf8');
console.log('[CREATED] BISPIRA_WEB_DEPLOY/.htaccess');

// 5. Create server.js and package.json for Node.js Hosting on cPanel
const serverJs = `const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 3000;
const MIME_TYPES = {
  '.html': 'text/html',
  '.js': 'application/javascript',
  '.mjs': 'application/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
  '.wasm': 'application/wasm',
};

const server = http.createServer((req, res) => {
  let cleanUrl = req.url.split('?')[0];
  if (cleanUrl === '/' || cleanUrl === '') cleanUrl = '/index.html';

  let filePath = path.join(__dirname, cleanUrl);

  fs.stat(filePath, (err, stats) => {
    if (err || !stats.isFile()) {
      // Check subpath SPA fallbacks
      const parts = cleanUrl.split('/').filter(Boolean);
      const sub = parts[0];
      if (['user', 'merchant', 'driver', 'admin', 'health', 'expert'].includes(sub)) {
        filePath = path.join(__dirname, sub, 'index.html');
      } else {
        filePath = path.join(__dirname, 'index.html');
      }
    }

    fs.readFile(filePath, (err, content) => {
      if (err) {
        res.writeHead(404, { 'Content-Type': 'text/plain' });
        res.end('404 Not Found');
        return;
      }
      const ext = path.extname(filePath).toLowerCase();
      const mime = MIME_TYPES[ext] || 'application/octet-stream';
      res.writeHead(200, {
        'Content-Type': mime,
        'Access-Control-Allow-Origin': '*',
        'Cache-Control': 'no-cache, no-store, must-revalidate',
      });
      res.end(content);
    });
  });
});

server.listen(PORT, () => {
  console.log(\`Bispira Web Suite running on port \${PORT}\`);
});
`;
fs.writeFileSync(path.join(deployDir, 'server.js'), serverJs, 'utf8');

const packageJson = JSON.stringify({
  name: "bispira-web-suite",
  version: "1.0.0",
  description: "BISPIRA Multi-App Web Suite & Testing Hub",
  main: "server.js",
  scripts: {
    start: "node server.js"
  },
  dependencies: {}
}, null, 2);
fs.writeFileSync(path.join(deployDir, 'package.json'), packageJson, 'utf8');
console.log('[CREATED] BISPIRA_WEB_DEPLOY/server.js & package.json');

// 6. Create Panduan Deploy cPanel
const panduan = `========================================================
PANDUAN DEPLOYMENT BISPIRA WEB SUITE KE CPANEL / HOSTING
========================================================

File zip ini ("bispira_web_suite_deploy.zip") berisi seluruh ekosistem web BISPIRA:
- Root (/)        : Hub Pengujian & Simulator Smartphone Interaktif
- /user/          : Bispira User SuperApp Web (Food Pick Up/Delivery, Ride, dll)
- /merchant/      : Bispira Merchant / Resto App Web (Kasir Dapur)
- /driver/        : Bispira Driver App Web (Navigasi & Order)
- /admin/         : Bispira Superadmin Desktop Web Suite
- /health/        : Bispira Health & Homecare Web
- /expert/        : Bispira Expert & Konsultan Web
- /portal/        : Bispira Web Landing Portal

--------------------------------------------------------
CARA 1: DEPLOY STATIC KE CPANEL (PALING MUDAH & CEPAT)
--------------------------------------------------------
1. Login ke cPanel hosting Anda (misal: https://namadomain.com:2083).
2. Masuk ke menu "File Manager".
3. Masuk ke folder target:
   - Jika ingin di domain utama: masuk ke "public_html".
   - Jika ingin di subdomain (misal: "app.domain.com"): masuk ke folder subdomain tersebut.
4. Klik "Upload" di menu atas cPanel.
5. Upload file "bispira_web_suite_deploy.zip".
6. Setelah upload selesai (100% hijau), kembali ke File Manager, klik kanan pada "bispira_web_suite_deploy.zip" lalu pilih "Extract" (Ekstrak ke direktori saat ini).
7. Hapus file zip setelah terekstrak.
8. Selesai! Buka domain Anda di browser, seluruh web dan simulator langsung aktif!

--------------------------------------------------------
CARA 2: DEPLOY VIA "SETUP NODE.JS APP" DI CPANEL
--------------------------------------------------------
Jika Anda menggunakan hosting Node.js cPanel:
1. Upload dan ekstrak file zip ke direktori aplikasi (misal: "bispira_web").
2. Buka menu "Setup Node.js App" di cPanel.
3. Buat aplikasi baru:
   - Node.js version : 18.x atau 20.x
   - Application mode: Production
   - Application root: bispira_web
   - Application startup file: server.js
4. Klik "Save" / "Start".
5. Selesai! Web suite langsung aktif melayani request.
`;
fs.writeFileSync(path.join(deployDir, 'PANDUAN_DEPLOY_CPANEL.txt'), panduan, 'utf8');
console.log('[CREATED] BISPIRA_WEB_DEPLOY/PANDUAN_DEPLOY_CPANEL.txt');

// 7. Compress into ZIP using PowerShell Compress-Archive
console.log('\nSedang mengompres folder BISPIRA_WEB_DEPLOY menjadi file ZIP...');
if (fs.existsSync(zipOutput)) {
  fs.unlinkSync(zipOutput);
}

const zipCmd = `powershell -Command "Compress-Archive -Path '${deployDir}\\*' -DestinationPath '${zipOutput}' -CompressionLevel Optimal -Force"`;
try {
  execSync(zipCmd, { stdio: 'inherit' });
  console.log(`\n🎉 [SUKSES BESAR] File ZIP berhasil dibuat:`);
  console.log(`📁 ${zipOutput}`);
  
  // Copy to DRIVE_UPLOAD_SIAP_PAKAI as well
  const driveDest = path.join(__dirname, 'DRIVE_UPLOAD_SIAP_PAKAI', 'bispira_web_suite_deploy.zip');
  if (fs.existsSync(path.dirname(driveDest))) {
    fs.copyFileSync(zipOutput, driveDest);
    console.log(`[SYNC DRIVE] Berhasil disalin ke DRIVE_UPLOAD_SIAP_PAKAI/bispira_web_suite_deploy.zip`);
  }
} catch (err) {
  console.error('[ERROR] Gagal membuat file zip:', err.message);
}
