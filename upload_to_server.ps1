# ==============================================================================
# BISPIRA SuperApp - Windows to VPS Sync & Deployment Helper
# ==============================================================================
param(
    [string]$ServerHost = "145.79.15.101",
    [string]$ServerUser = "root",
    [string]$RemoteDir = "/var/www/bispira"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "🚀 BISPIRA SuperApp - VPS Deployment Sync" -ForegroundColor Yellow
Write-Host "Server Target: $ServerUser@$ServerHost:$RemoteDir" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan

$SSH = "C:\Windows\System32\OpenSSH\ssh.exe"
$SCP = "C:\Windows\System32\OpenSSH\scp.exe"

# 1. Pastikan folder tujuan ada di server
Write-Host "`n📁 [1/4] Membuat direktori tujuan di server..." -ForegroundColor Green
& $SSH "$ServerUser@$ServerHost" "mkdir -p $RemoteDir"

# 2. Upload file database dump
Write-Host "`n🗄️ [2/4] Mengunggah file database bispira_db_dump.sql..." -ForegroundColor Green
& $SCP "bispira_db_dump.sql" "$ServerUser@$ServerHost`:$RemoteDir/bispira_db_dump.sql"

# 3. Pull / Clone Git repo atau Sync file backend
Write-Host "`n📦 [3/4] Mengupdate repository di server via Git..." -ForegroundColor Green
$gitCmd = @"
if [ -d "$RemoteDir/.git" ]; then
    cd $RemoteDir && git pull origin main
else
    cd /var/www && git clone https://github.com/davyy1020/superapp.git bispira
fi
"@
& $SSH "$ServerUser@$ServerHost" "$gitCmd"

# 4. Jalankan script deployment otomatis
Write-Host "`n⚡ [4/4] Menjalankan automasi deployment di server..." -ForegroundColor Green
& $SSH "$ServerUser@$ServerHost" "cd $RemoteDir/bispira_admin_web && chmod +x deploy.sh && ./deploy.sh"

Write-Host "`n🎉 Deployment Selesai! Backend Bispira aktif di server." -ForegroundColor Yellow
