const http = require('http');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

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

const APPS = [
  { id: 'admin', name: 'Superadmin Web & Desktop', port: 5051, dir: path.join(__dirname, 'bispira_desktop_admin', 'build', 'web'), icon: '🖥️', desc: 'Panel Eksekutif, Ledger Real-Time, Monitoring 13 Kluster & Transaksi' },
  { id: 'user', name: 'Bispira User SuperApp', port: 5052, dir: path.join(__dirname, 'bispira_user_app', 'build', 'web'), icon: '📱', desc: 'Aplikasi Konsumen: Food (Delivery/Pick Up), Ride, Health, Donasi, Pajak' },
  { id: 'merchant', name: 'Bispira Merchant / Resto', port: 5053, dir: path.join(__dirname, 'bispira_merchant_app', 'build', 'web'), icon: '🏪', desc: 'Aplikasi Kasir Outlet & Dapur: Terima Pesanan, Pick Up vs Delivery' },
  { id: 'driver', name: 'Bispira Driver / Kurir', port: 5054, dir: path.join(__dirname, 'bispira_driver_app', 'build', 'web'), icon: '🛵', desc: 'Aplikasi Mitra Driver: Navigasi OSRM, Order Ride, Food & Kurir Barang' },
  { id: 'health', name: 'Bispira Health & Homecare', port: 5055, dir: path.join(__dirname, 'bispira_health_app', 'build', 'web'), icon: '🩺', desc: 'Layanan Nakes: Booking Homecare, Tes Lab, & Perawat Pribadi' },
  { id: 'expert', name: 'Bispira Expert & Konsultan', port: 5056, dir: path.join(__dirname, 'bispira_expert_app', 'build', 'web'), icon: '👨‍💼', desc: 'Konsultasi Profesional: Legal, Pajak, Bisnis & Edukasi' },
  { id: 'portal', name: 'Bispira Web Landing Portal', port: 5057, dir: path.join(__dirname, 'bispira_web_portal'), icon: '🌐', desc: 'Halaman Publik Ekosistem, Profile BISPIRA, & Download Link' },
];

function serveStatic(rootDir) {
  return (req, res) => {
    let cleanUrl = req.url.split('?')[0];
    if (cleanUrl === '/' || cleanUrl === '') cleanUrl = '/index.html';
    let filePath = path.join(rootDir, cleanUrl);

    fs.stat(filePath, (err, stats) => {
      if (err || !stats.isFile()) {
        // Fallback to index.html for Single Page Apps (SPA)
        filePath = path.join(rootDir, 'index.html');
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
  };
}

// Start individual app servers
APPS.forEach(app => {
  if (fs.existsSync(app.dir)) {
    const server = http.createServer(serveStatic(app.dir));
    server.listen(app.port, () => {
      console.log(`[OK] ${app.name} berjalan di -> http://localhost:${app.port}`);
    });
  } else {
    console.warn(`[SKIP] Direktori tidak ditemukan untuk ${app.name}: ${app.dir}`);
  }
});

// HUB HTML Generator
function getHubHtml() {
  return `<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>BISPIRA SuperApp - Web Testing Suite & App Launcher</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800;900&display=swap" rel="stylesheet">
  <style>
    :root {
      --bg: #0F172A;
      --card-bg: #1E293B;
      --border: #334155;
      --brand: #2563EB;
      --brand-hover: #1D4ED8;
      --accent: #F97316;
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
      background: rgba(30, 41, 59, 0.85);
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
      padding: 4px 12px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .status-dot {
      width: 8px;
      height: 8px;
      background: #10B981;
      border-radius: 50%;
      animation: pulse 1.5s infinite;
    }
    @keyframes pulse {
      0%, 100% { opacity: 1; transform: scale(1); }
      50% { opacity: 0.4; transform: scale(0.85); }
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
      background: linear-gradient(135deg, rgba(37, 99, 235, 0.15), rgba(249, 115, 22, 0.15));
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
      display: flex;
      align-items: center;
      gap: 10px;
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
      position: relative;
      overflow: hidden;
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
    .app-port {
      display: inline-block;
      font-size: 11px;
      font-weight: 700;
      background: #334155;
      color: #93C5FD;
      padding: 2px 8px;
      border-radius: 6px;
    }
    .app-desc {
      color: var(--text-muted);
      font-size: 13px;
      line-height: 1.5;
      margin-bottom: 20px;
      flex: 1;
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
      background: rgba(0,0,0,0.8);
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
        <h1>BISPIRA TESTING SUITE</h1>
        <div style="font-size: 11px; color: var(--text-muted); font-weight: 600;">Ecosystem Multi-App Chrome Launcher</div>
      </div>
    </div>
    <div class="status-pill">
      <div class="status-dot"></div>
      Semua Server Web Aktif
    </div>
  </header>

  <div class="main-container">
    <div class="hero">
      <h2>Uji Coba Semua Aplikasi BISPIRA di Chrome</h2>
      <p>Klik tombol untuk membuka aplikasi secara penuh di tab baru, atau gunakan simulator untuk melihat tampilan responsif smartphone/desktop langsung di layar Anda.</p>
    </div>

    <!-- Live Cloud Highlight -->
    <div class="highlight-card">
      <div class="highlight-info">
        <h3>🚀 Superadmin Production Cloud (Next.js 16)</h3>
        <p>Akses langsung web admin pusat tanpa perlu download file ZIP. Berjalan live di server cPanel DomaiNesia dengan koneksi MySQL aktif.</p>
      </div>
      <a href="https://superapp.agungtrijayaabadi.com/" target="_blank" class="highlight-btn">Buka Web Admin Cloud 🌐</a>
    </div>

    <!-- Grid of Apps -->
    <div class="grid">
      ${APPS.map(app => `
        <div class="app-card">
          <div>
            <div class="card-header">
              <div class="app-icon">${app.icon}</div>
              <div class="app-meta">
                <h4>${app.name}</h4>
                <span class="app-port">PORT: ${app.port}</span>
              </div>
            </div>
            <p class="app-desc">${app.desc}</p>
          </div>
          <div class="card-actions">
            <a href="http://localhost:${app.port}" target="_blank" class="btn-open">Buka di Tab Baru ↗</a>
            <button class="btn-preview" onclick="openSimulator('http://localhost:${app.port}', '${app.name}')">📱 Simulator</button>
          </div>
        </div>
      `).join('')}
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
    Ekosistem BISPIRA SuperApp • Kompilasi Web Engine • Siap Presentasi & Uji Coba Klien
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
}

// HUB Server on port 5050
const hubServer = http.createServer((req, res) => {
  res.writeHead(200, {
    'Content-Type': 'text/html; charset=utf-8',
    'Cache-Control': 'no-cache, no-store, must-revalidate',
  });
  res.end(getHubHtml());
});

const HUB_PORT = 5050;
hubServer.listen(HUB_PORT, () => {
  console.log('========================================================');
  console.log(`🚀 BISPIRA WEB LAUNCHER AKTIF DI: http://localhost:${HUB_PORT}`);
  console.log('========================================================');
  console.log('Membuka browser Google Chrome secara otomatis...');

  // Launch Google Chrome to the Hub URL
  const chromeCmd = `start chrome "http://localhost:${HUB_PORT}"`;
  exec(chromeCmd, (err) => {
    if (err) {
      // Fallback to default browser
      exec(`start http://localhost:${HUB_PORT}`);
    }
  });
});

