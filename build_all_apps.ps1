# ==============================================================================
# BISPIRA SuperApp - Comprehensive Multi-App Production Build Pipeline
# ==============================================================================
param(
    [string]$OutputDir = "$PSScriptRoot\BISPIRA_BINARIES_RELEASE"
)

$ErrorActionPreference = "Continue"

# Setup Java & Flutter Environment
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "🚀 BISPIRA SuperApp - Multi-Platform Release Build Engine" -ForegroundColor Yellow
Write-Host "Target Output Directory: $OutputDir" -ForegroundColor White
Write-Host "Java Version: $env:JAVA_HOME" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Pastikan folder output siap
if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$apps = @(
    @{ Name = "Bispira User App"; Folder = "bispira_user_app"; OutName = "Bispira_User_App.apk"; Type = "apk" },
    @{ Name = "Bispira Driver App"; Folder = "bispira_driver_app"; OutName = "Bispira_Driver_App.apk"; Type = "apk" },
    @{ Name = "Bispira Health App"; Folder = "bispira_health_app"; OutName = "Bispira_Health_App.apk"; Type = "apk" },
    @{ Name = "Bispira Expert App"; Folder = "bispira_expert_app"; OutName = "Bispira_Expert_App.apk"; Type = "apk" },
    @{ Name = "Bispira Merchant App"; Folder = "bispira_merchant_app"; OutName = "Bispira_Merchant_App.apk"; Type = "apk" },
    @{ Name = "Bispira Desktop Admin"; Folder = "bispira_desktop_admin"; OutName = "Bispira_Desktop_Admin"; Type = "windows" }
)

$successCount = 0
$failCount = 0

foreach ($app in $apps) {
    Write-Host "`n----------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "🔨 Memulai Build: $($app.Name)..." -ForegroundColor Yellow
    
    $appPath = Join-Path $PSScriptRoot $app.Folder
    Set-Location $appPath

    if ($app.Type -eq "apk") {
        Write-Host "📱 Mengompilasi Android APK (flutter build apk --release)..." -ForegroundColor Cyan
        flutter build apk --release
        
        $apkSource = "$appPath\build\app\outputs\flutter-apk\app-release.apk"
        if (Test-Path $apkSource) {
            $destFile = "$OutputDir\$($app.OutName)"
            Copy-Item -Path $apkSource -Destination $destFile -Force
            $sizeMb = [Math]::Round((Get-Item $destFile).Length / 1MB, 2)
            Write-Host "✅ Selesai! Disimpan ke: $destFile ($sizeMb MB)" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "❌ Gagal menemukan APK hasil build di $apkSource" -ForegroundColor Red
            $failCount++
        }
    }
    elseif ($app.Type -eq "windows") {
        Write-Host "💻 Mengompilasi Windows Desktop (.exe)..." -ForegroundColor Cyan
        flutter build windows --release
        
        $winSource = "$appPath\build\windows\x64\runner\Release"
        if (Test-Path $winSource) {
            $destDir = "$OutputDir\$($app.OutName)"
            Copy-Item -Path $winSource -Destination $destDir -Recurse -Force
            Write-Host "✅ Selesai! Disimpan ke folder: $destDir" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "❌ Gagal menemukan direktori release Windows di $winSource" -ForegroundColor Red
            $failCount++
        }
    }
}

Set-Location $PSScriptRoot

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "🎉 PROSES BUILD SELESAI!" -ForegroundColor Yellow
Write-Host "Berhasil: $successCount / $($apps.Count) aplikasi" -ForegroundColor Green
Write-Host "Lokasi File Siap Install: $OutputDir" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan

