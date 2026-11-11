@echo off
title BISPIRA SuperApp - Web Testing Suite Launcher
echo ========================================================
echo   MENJALANKAN SELURUH APLIKASI BISPIRA DI GOOGLE CHROME
echo ========================================================
echo.
echo Sedang mengaktifkan server lokal multi-app BISPIRA...
echo Port 5050: Portal & Hub Launcher
echo Port 5051: Superadmin Desktop/Web
echo Port 5052: User SuperApp
echo Port 5053: Merchant / Resto App
echo Port 5054: Driver / Kurir App
echo Port 5055: Health & Homecare App
echo Port 5056: Expert & Konsultan App
echo Port 5057: Landing Portal
echo.
node serve_all_apps_in_chrome.js
pause

