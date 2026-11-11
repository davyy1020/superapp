const fs = require('fs');
const path = require('path');

const baseDir = path.join(__dirname, 'DRIVE_UPLOAD_SIAP_PAKAI');
const androidDir = path.join(baseDir, '01_APLIKASI_HP_ANDROID (Buka & Install di HP)');
const desktopDir = path.join(baseDir, '02_SUPERADMIN_DESKTOP_WINDOWS (Buka di Laptop PC)');

// Clean & recreate
if (fs.existsSync(baseDir)) {
  fs.rmSync(baseDir, { recursive: true, force: true });
}
fs.mkdirSync(androidDir, { recursive: true });
fs.mkdirSync(desktopDir, { recursive: true });

// Copy APKs
const apkMap = [
  { src: 'Bispira_User_App.apk', dest: '1. Bispira_User_App (Aplikasi Pembeli).apk' },
  { src: 'Bispira_Merchant_App.apk', dest: '2. Bispira_Merchant_App (Aplikasi Resto & Toko).apk' },
  { src: 'Bispira_Driver_App.apk', dest: '3. Bispira_Driver_App (Aplikasi Driver & Kurir).apk' },
  { src: 'Bispira_Health_App.apk', dest: '4. Bispira_Health_App (Aplikasi Tenaga Kesehatan).apk' },
  { src: 'Bispira_Expert_App.apk', dest: '5. Bispira_Expert_App (Aplikasi Konsultan & Ahli).apk' },
];

apkMap.forEach(item => {
  const srcPath = path.join(__dirname, 'BISPIRA_BINARIES_RELEASE', item.src);
  const destPath = path.join(androidDir, item.dest);
  if (fs.existsSync(srcPath)) {
    fs.copyFileSync(srcPath, destPath);
    console.log(`[COPIED] ${item.dest}`);
  }
});

// Copy Desktop Admin (Now Single EXE Installer instead of ZIP!)
const desktopExeSrc = path.join(__dirname, 'BISPIRA_BINARIES_RELEASE', 'Bispira_Superadmin_Windows_Setup.exe');
const desktopExeDest = path.join(desktopDir, 'Bispira_Superadmin_Windows_Setup.exe');
if (fs.existsSync(desktopExeSrc)) {
  fs.copyFileSync(desktopExeSrc, desktopExeDest);
  console.log('[COPIED] Bispira_Superadmin_Windows_Setup.exe (SINGLE EXE INSTALLER)');
}

// Panduan Android
const panduanHp = `========================================================
CARA MUDAH INSTALL APLIKASI BISPIRA DI HP ANDROID
========================================================

1. Buka Google Drive ini langsung dari HP Android Anda.
2. Buka folder "01_APLIKASI_HP_ANDROID".
3. Pilih aplikasi yang ingin Anda coba:
   - "1. Bispira_User_App (Aplikasi Pembeli).apk" -> Untuk pesan makanan, ride, donasi, belanja.
   - "2. Bispira_Merchant_App (Aplikasi Resto & Toko).apk" -> Untuk kasir resto & dapur.
   - "3. Bispira_Driver_App (Aplikasi Driver & Kurir).apk" -> Untuk driver pengantar.
   - "4. Bispira_Health_App (Aplikasi Tenaga Kesehatan).apk" -> Untuk nakes & dokter.
   - "5. Bispira_Expert_App (Aplikasi Konsultan & Ahli).apk" -> Untuk konsultan.

4. Tap pada file APK tersebut, lalu tap ikon "Download" (Tanda panah ke bawah).
5. Setelah selesai ter-download:
   - Tarik layar HP ke bawah (notifikasi) lalu tap file yang baru di-download.
   - ATAU buka menu "File Manager / Pengelola File" -> folder "Download".
6. Tap "Install" / "Pasang".
   (Jika HP meminta izin "Izinkan penginstalan aplikasi tidak dikenal", klik "Setelan / Settings" lalu aktifkan izinnya).
7. Selesai! Ikon aplikasi BISPIRA akan langsung muncul di layar utama HP Anda.
`;
fs.writeFileSync(path.join(androidDir, 'PANDUAN_CARA_INSTALL_DI_HP.txt'), panduanHp, 'utf8');

// Panduan Desktop (Single EXE)
const panduanDesktop = `========================================================
CARA INSTALL SUPERADMIN DI LAPTOP / KOMPUTER WINDOWS (FILE EXE)
========================================================

KINI JAUH LEBIH MUDAH: Tanpa perlu ekstrak file ZIP!

1. Buka Google Drive dari laptop Windows Anda.
2. Masuk ke folder "02_SUPERADMIN_DESKTOP_WINDOWS".
3. Klik kanan pada file "Bispira_Superadmin_Windows_Setup.exe" -> pilih "Download".
4. Setelah selesai download, klik 2x pada file "Bispira_Superadmin_Windows_Setup.exe".
5. Klik "Next" -> "Install".
6. Selesai! BISPIRA Superadmin akan otomatis terbuka dan muncul shortcut di Desktop laptop Anda!

--------------------------------------------------------
💡 JAUH LEBIH PRAKTIS TANPA DOWNLOAD APAPUN:
Buka Superadmin Web langsung di Google Chrome melalui link:
👉 https://superapp.agungtrijayaabadi.com/
--------------------------------------------------------
`;
fs.writeFileSync(path.join(desktopDir, 'CARA_BUKA_DI_LAPTOP.txt'), panduanDesktop, 'utf8');

// HTML Shortcut in Root
const htmlShortcut = `<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="refresh" content="0; url=https://superapp.agungtrijayaabadi.com/">
  <title>Membuka BISPIRA Superadmin Web...</title>
</head>
<body style="font-family: sans-serif; text-align: center; padding: 50px;">
  <h2>Sedang mengalihkan ke BISPIRA Superadmin Cloud...</h2>
  <p>Jika tidak otomatis terbuka, klik link di bawah ini:</p>
  <a href="https://superapp.agungtrijayaabadi.com/" style="font-size: 18px; color: #2563EB; font-weight: bold;">
    👉 Klik Disini untuk Buka Superadmin Web (https://superapp.agungtrijayaabadi.com/)
  </a>
</body>
</html>`;
fs.writeFileSync(path.join(baseDir, '🌐_KLIK_UNTUK_BUKA_SUPERADMIN_LANGSUNG.html'), htmlShortcut, 'utf8');

// Root README
const readmeRoot = `========================================================
PANDUAN AKSES EKOSISTEM APLIKASI BISPIRA SUPERAPP
========================================================

Folder ini berisi seluruh aplikasi BISPIRA yang siap diuji coba:

1. FOLDER "01_APLIKASI_HP_ANDROID":
   Berisi 5 file APK untuk di-install langsung di Handphone Android:
   - User App (Konsumen)
   - Merchant App (Kasir Resto & Toko)
   - Driver App (Kurir & Ojol)
   - Health App (Tenaga Kesehatan)
   - Expert App (Konsultan Profesional)

2. FOLDER "02_SUPERADMIN_DESKTOP_WINDOWS":
   Berisi aplikasi Superadmin khusus Laptop / PC Windows.
   (Download zip -> Extract All -> Jalankan bispira_desktop_admin.exe).

3. AKSES INSTAN TANPA INSTALL (WEB CLOUD):
   Anda juga bisa membuka Superadmin langsung dari browser Chrome di laptop atau HP:
   👉 https://superapp.agungtrijayaabadi.com/

Jika memerlukan bantuan pengujian, kami siap memandu melalui Google Meet / Zoom!
`;
fs.writeFileSync(path.join(baseDir, 'BACA_PANDUAN_LENGKAP.txt'), readmeRoot, 'utf8');

console.log('[SUKSES] Folder DRIVE_UPLOAD_SIAP_PAKAI berhasil disiapkan!');

