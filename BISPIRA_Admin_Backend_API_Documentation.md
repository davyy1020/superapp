# BISPIRA SuperApp - Dokumentasi API & Panduan Backend Admin

Dokumen ini berisi spesifikasi API, skema relasi database (ERD), serta panduan penggunaan **Postman Collection** untuk pengembangan Backend Modul Admin BISPIRA.

---

## 📁 File Yang Tersedia

1. **`BISPIRA_Admin_Backend_Postman_Collection.json`**
   - File JSON Postman Collection (v2.1.0) standar.
   - **Cara Import:** Buka Postman -> Klik tombol **Import** di kiri atas -> Pilih file `BISPIRA_Admin_Backend_Postman_Collection.json`.
   - Sudah termasuk environment variable `{{base_url}}` dan `{{admin_token}}`.

---

## 🗄️ Database ERD & Schema (PostgreSQL + PostGIS)

```sql
-- 1. Cabang Wilayah & Admin
CREATE TABLE branches (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE admins (
    id VARCHAR(50) PRIMARY KEY,
    branch_id VARCHAR(50) REFERENCES branches(id),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL, -- SUPER_ADMIN, REGIONAL_ADMIN
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Configuration & Audit Logs
CREATE TABLE system_configs (
    key VARCHAR(100) PRIMARY KEY,
    value JSONB NOT NULL,
    description TEXT,
    updated_by VARCHAR(50) REFERENCES admins(id),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tariff_change_logs (
    id SERIAL PRIMARY KEY,
    config_key VARCHAR(100) NOT NULL,
    old_value JSONB,
    new_value JSONB,
    changed_by_admin_id VARCHAR(50) REFERENCES admins(id),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Entitas Utama
CREATE TABLE users (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    wallet_balance NUMERIC(12,2) DEFAULT 0.00,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE drivers (
    id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) UNIQUE REFERENCES users(id),
    branch_id VARCHAR(50) REFERENCES branches(id),
    vehicle_type VARCHAR(20) NOT NULL, -- MOTORCYCLE, CAR, AMBULANCE
    license_plate VARCHAR(20) NOT NULL,
    kyc_status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, APPROVED, REJECTED
    is_online BOOLEAN DEFAULT FALSE,
    is_suspended BOOLEAN DEFAULT FALSE,
    current_lat DOUBLE PRECISION,
    current_lng DOUBLE PRECISION,
    last_ping_at TIMESTAMP
);

CREATE TABLE merchants (
    id VARCHAR(50) PRIMARY KEY,
    branch_id VARCHAR(50) REFERENCES branches(id),
    type VARCHAR(20) NOT NULL, -- FOOD, HEALTH
    name VARCHAR(100) NOT NULL,
    address TEXT,
    commission_rate NUMERIC(5,2) DEFAULT 0.00,
    wallet_balance NUMERIC(12,2) DEFAULT 0.00,
    bank_account_no VARCHAR(50),
    bank_name VARCHAR(50),
    status VARCHAR(20) DEFAULT 'PENDING'
);

-- 4. Orders, Payments, & Disbursements
CREATE TABLE orders (
    id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) REFERENCES users(id),
    driver_id VARCHAR(50) REFERENCES drivers(id),
    merchant_id VARCHAR(50) REFERENCES merchants(id),
    branch_id VARCHAR(50) REFERENCES branches(id),
    service_type VARCHAR(20) NOT NULL, -- RIDE, FOOD, HEALTH, AMBULANCE
    base_price NUMERIC(12,2) NOT NULL,
    markup_price NUMERIC(12,2) DEFAULT 0,
    service_fee NUMERIC(12,2) DEFAULT 0,
    app_fee NUMERIC(12,2) DEFAULT 0,
    driver_charge NUMERIC(12,2) DEFAULT 500,
    total_amount NUMERIC(12,2) NOT NULL,
    status VARCHAR(30) NOT NULL, -- PENDING_PAYMENT, SEARCHING_DRIVER, IN_TRIP, COMPLETED, CANCELLED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payments (
    id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50) UNIQUE REFERENCES orders(id),
    bank_target VARCHAR(20) NOT NULL,
    base_amount NUMERIC(12,2) NOT NULL,
    unique_code INT NOT NULL,
    exact_transfer_amount NUMERIC(12,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, PAID, EXPIRED, REJECTED
    expires_at TIMESTAMP NOT NULL,
    verified_by_admin_id VARCHAR(50) REFERENCES admins(id)
);

CREATE TABLE disbursements (
    id VARCHAR(50) PRIMARY KEY,
    merchant_id VARCHAR(50) REFERENCES merchants(id),
    gross_amount NUMERIC(12,2) NOT NULL,
    fee_amount NUMERIC(12,2) NOT NULL,
    net_amount NUMERIC(12,2) NOT NULL,
    payout_batch_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, PROCESSED, FAILED
    processed_at TIMESTAMP
);

-- 5. Security & Logs
CREATE TABLE fake_gps_logs (
    id SERIAL PRIMARY KEY,
    driver_id VARCHAR(50) REFERENCES drivers(id),
    calculated_speed_kmh NUMERIC(8,2),
    details JSONB,
    flagged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 📌 Ringkasan Modul API

| Modul | Method | Endpoint | Deskripsi |
| :--- | :---: | :--- | :--- |
| **Auth** | `POST` | `/api/v1/admin/auth/login` | Login admin & dapatkan JWT |
| **Tariff** | `GET` | `/api/v1/admin/settings/financial` | Ambil tarif & biaya aktif |
| **Tariff** | `PUT` | `/api/v1/admin/settings/financial` | Update tarif & biaya realtime |
| **Entity** | `GET` | `/api/v1/admin/drivers/verification-pending` | Ambil antrean driver baru |
| **Entity** | `POST` | `/api/v1/admin/drivers/:id/approve` | Setujui pendaftaran driver |
| **Payment** | `GET` | `/api/v1/admin/payments/pending` | List transfer pending (Kode Unik 3-Digit) |
| **Payment** | `POST` | `/api/v1/admin/payments/:id/approve` | Konfirmasi pembayaran masuk |
| **Payment** | `POST` | `/api/v1/admin/payments/:id/reject` | Tolak pembayaran |
| **Payout** | `GET` | `/api/v1/admin/disbursements/upcoming` | Preview pencairan toko jam 17:00 WIB |
| **Payout** | `POST` | `/api/v1/admin/disbursements/execute-batch` | Eksekusi transfer batch toko |
| **Tracking** | `GET` | `/api/v1/admin/tracking/drivers-online` | Ambil koordinat GPS driver online |
| **Tracking** | `POST` | `/api/v1/admin/orders/:id/reassign-driver` | Oper order ke driver lain |
| **Security** | `GET` | `/api/v1/admin/security/fake-gps-reports` | Laporan kecurangan Fake GPS |
| **Security** | `POST` | `/api/v1/admin/drivers/:id/suspend` | Suspend akun driver nakal |
| **Stats** | `GET` | `/api/v1/admin/dashboard/stats` | Statistik omzet & order aktif |
