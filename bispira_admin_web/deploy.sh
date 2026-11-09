#!/usr/bin/env bash
# ==============================================================================
# BISPIRA SuperApp - Server Deployment Automation Script (Ubuntu / Debian VPS)
# ==============================================================================
set -e

echo "🚀 [1/6] Memulai Deployment Backend BISPIRA..."

# 1. Update OS & Install Dependencies
echo "📦 [2/6] Memperbarui paket sistem & Node.js..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y curl git ufw nginx mysql-server

# Install Node.js 20 LTS jika belum ada
if ! command -v node &> /dev/null; then
    echo "⬇️ Menginstall Node.js 20 LTS..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
fi

# Install PM2 jika belum ada
if ! command -v pm2 &> /dev/null; then
    echo "⬇️ Menginstall PM2 Process Manager..."
    sudo npm install -g pm2
fi

echo "✅ Node.js: $(node -v) | NPM: $(npm -v) | PM2: $(pm2 -v)"

# 2. Setup Database MySQL
echo "🗄️ [3/6] Konfigurasi Database MySQL..."
sudo systemctl enable --now mysql

# Jalankan dump database jika file dump ada di folder
if [ -f "../bispira_db_dump.sql" ]; then
    echo "📥 Mengimpor skema & data dari ../bispira_db_dump.sql..."
    sudo mysql -e "CREATE DATABASE IF NOT EXISTS bispira_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    sudo mysql bispira_db < ../bispira_db_dump.sql
    echo "✅ Database bispira_db berhasil diimpor!"
elif [ -f "./bispira_db_dump.sql" ]; then
    echo "📥 Mengimpor skema & data dari ./bispira_db_dump.sql..."
    sudo mysql -e "CREATE DATABASE IF NOT EXISTS bispira_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    sudo mysql bispira_db < ./bispira_db_dump.sql
    echo "✅ Database bispira_db berhasil diimpor!"
fi

# 3. Setup Environment File (.env)
echo "⚙️ [4/6] Menyiapkan file konfigurasi lingkungan (.env)..."
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo "ℹ️ File .env dibuat dari .env.example. Silakan sesuaikan kredensial jika menggunakan password MySQL."
fi

# 4. Install Dependencies & Build Next.js
echo "🔨 [5/6] Mengompilasi aplikasi Next.js (npm install & build)..."
npm install --production=false
npm run build

# 5. Start / Restart Service dengan PM2
echo "🔄 [6/6] Menjalankan backend dengan PM2..."
pm2 delete bispira-backend 2>/dev/null || true
pm2 start ecosystem.config.js
pm2 save
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u $USER --hp $HOME 2>/dev/null || true

echo "=============================================================================="
echo "🎉 DEPLOYMENT SELESAI! Backend BISPIRA aktif pada http://localhost:3000"
echo "Status PM2:"
pm2 status
echo "=============================================================================="
