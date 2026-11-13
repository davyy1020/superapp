const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

console.log('=== SYNCING CORRECTED WINDOWS RELEASE FILES ===');

// 1. Copy EXE installer to Drive folder
const exeSrc = path.join(process.cwd(), 'BISPIRA_BINARIES_RELEASE', 'Bispira_Superadmin_Windows_Setup.exe');
const exeDriveDest = path.join(process.cwd(), 'DRIVE_UPLOAD_SIAP_PAKAI', '02_SUPERADMIN_DESKTOP_WINDOWS (Buka di Laptop PC)', 'Bispira_Superadmin_Windows_Setup.exe');
fs.copyFileSync(exeSrc, exeDriveDest);
console.log('[OK 1/4] Copied Bispira_Superadmin_Windows_Setup.exe to DRIVE_UPLOAD_SIAP_PAKAI');

// 2. Properly update Bispira_Desktop_Admin_Windows folder
const releaseBuildDir = path.join(process.cwd(), 'bispira_desktop_admin', 'build', 'windows', 'x64', 'runner', 'Release');
const targetFolder = path.join(process.cwd(), 'BISPIRA_BINARIES_RELEASE', 'Bispira_Desktop_Admin_Windows');

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

if (fs.existsSync(targetFolder)) fs.rmSync(targetFolder, { recursive: true, force: true });
copyFolderSync(releaseBuildDir, targetFolder);
console.log('[OK 2/4] Copied complete release files (including data/ folder)');

// 3. Re-create Bispira_Desktop_Admin_Windows.zip
const zipDest = path.join(process.cwd(), 'BISPIRA_BINARIES_RELEASE', 'Bispira_Desktop_Admin_Windows.zip');
if (fs.existsSync(zipDest)) fs.unlinkSync(zipDest);
execSync(`C:\\Windows\\System32\\tar.exe -a -c -f "${zipDest}" -C "${targetFolder}" .`);
console.log('[OK 3/4] Re-created Bispira_Desktop_Admin_Windows.zip');

// Copy zip to Drive folder as well
const zipDriveDest = path.join(process.cwd(), 'DRIVE_UPLOAD_SIAP_PAKAI', '02_SUPERADMIN_DESKTOP_WINDOWS (Buka di Laptop PC)', 'Bispira_Desktop_Admin_Windows.zip');
fs.copyFileSync(zipDest, zipDriveDest);
console.log('[OK 4/4] Copied Bispira_Desktop_Admin_Windows.zip to DRIVE_UPLOAD_SIAP_PAKAI');

console.log('=== SYNC COMPLETE! ===');
