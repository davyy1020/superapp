-- =============================================================================
-- BISPIRA SUPERAPP - ACID RELATIONAL DATABASE SCHEMA (PostgreSQL / MySQL)
-- =============================================================================

CREATE TABLE IF NOT EXISTS users (
    user_id VARCHAR(50) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    wallet_balance DECIMAL(15, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bank_accounts (
    account_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) REFERENCES users(user_id),
    bank_code VARCHAR(10) NOT NULL,
    account_number VARCHAR(30) NOT NULL,
    account_holder_name VARCHAR(100) NOT NULL,
    is_verified BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS virtual_accounts (
    va_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) REFERENCES users(user_id),
    bank_code VARCHAR(10) NOT NULL,
    va_number VARCHAR(30) UNIQUE NOT NULL,
    expected_amount DECIMAL(15, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) REFERENCES users(user_id),
    transaction_type VARCHAR(30) NOT NULL, -- DEPOSIT_VA, WITHDRAWAL_BIFAST, PAYMENT_SPLIT
    gross_amount DECIMAL(15, 2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- MULTI-PARTY SPLIT DISBURSEMENT LEDGER (PIHAK 1, 2, 3)
-- =============================================================================
CREATE TABLE IF NOT EXISTS split_settlements (
    split_id VARCHAR(50) PRIMARY KEY,
    transaction_id VARCHAR(50) REFERENCES transactions(transaction_id),
    service_type VARCHAR(50) NOT NULL, -- BISPIRA_RIDE, BISPIRA_FOOD, BISPIRA_TAX, etc.
    gross_amount DECIMAL(15, 2) NOT NULL,
    
    -- Pihak 1: User / Customer (Pembeli)
    pihak1_user_id VARCHAR(50) REFERENCES users(user_id),
    pihak1_deduction_amount DECIMAL(15, 2) NOT NULL,
    
    -- Pihak 2: Mitra Driver / Merchant / Jasa
    pihak2_mitra_id VARCHAR(50) NOT NULL,
    pihak2_payout_amount DECIMAL(15, 2) NOT NULL,
    
    -- Pihak 3: Admin BISPIRA & Kas Daerah (Platform Service Fee + Tax)
    pihak3_platform_fee DECIMAL(15, 2) NOT NULL,
    
    settlement_status VARCHAR(20) DEFAULT 'SETTLED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
