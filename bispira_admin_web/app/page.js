"use client";

import React, { useState, useEffect } from "react";
import {
  LayoutDashboard,
  Percent,
  CheckCircle2,
  Banknote,
  Navigation,
  Car,
  Store,
  Users,
  Building2,
  Search,
  Bell,
  Sun,
  Moon,
  TrendingUp,
  TrendingDown,
  ShieldAlert,
  AlertTriangle,
  RefreshCw,
  Download,
  Check,
  X,
  ExternalLink,
  ChevronRight,
  Filter,
  Sliders,
  DollarSign,
  MapPin,
  Clock,
  Smartphone,
  Eye,
  FileCheck,
  UserCheck,
  Lock,
  Plus
} from "lucide-react";

export default function AdminPortal() {
  const [activeTab, setActiveTab] = useState("dashboard");
  const [theme, setTheme] = useState("dark");
  const [searchQuery, setSearchQuery] = useState("");
  const [notificationsOpen, setNotificationsOpen] = useState(false);
  const [toastMessage, setToastMessage] = useState(null);

  // Financial Config State (Tariffs)
  const [tariffs, setTariffs] = useState({
    rideBase: 10000,
    ridePerKm: 2800,
    rideAppFee: 2000,
    foodBase: 9000,
    foodPerKm: 2500,
    foodCommission: 15,
    healthCommission: 10,
    ambulanceBase: 200000,
    ambulancePerKm: 15000,
    driverCharge: 500,
  });

  // Simulator State
  const [simDistance, setSimDistance] = useState(4.5);
  const [simService, setSimService] = useState("ride");

  // Reconciliations State
  const [payments, setPayments] = useState([
    { id: "PAY-8821", orderId: "ORD-9912", user: "Budi Pratama", bank: "BCA", amount: 45000, code: 312, total: 45312, time: "3 menit lalu", status: "PENDING" },
    { id: "PAY-8820", orderId: "ORD-9911", user: "Rina Kusuma", bank: "Mandiri", amount: 120000, code: 108, total: 120108, time: "11 menit lalu", status: "PENDING" },
    { id: "PAY-8819", orderId: "ORD-9910", user: "Hendra Wijaya", bank: "BRI", amount: 250000, code: 455, total: 250455, time: "25 menit lalu", status: "PENDING" },
    { id: "PAY-8818", orderId: "ORD-9909", user: "Siti Rahma", bank: "BSI", amount: 35000, code: 219, total: 35219, time: "42 menit lalu", status: "VERIFIED" },
  ]);

  // Drivers KYC State
  const [drivers, setDrivers] = useState([
    { id: "DRV-1029", name: "Agus Santoso", phone: "081289123001", armada: "Motor", plate: "B 4982 BSP", sim: "1234-5678-9011", stnk: "STNK-Aktif-2027", status: "PENDING_KYC", rating: 5.0 },
    { id: "DRV-1030", name: "Dedi Supriyadi", phone: "081377889900", armada: "Mobil", plate: "B 1201 KLP", sim: "9876-5432-1002", stnk: "STNK-Aktif-2026", status: "PENDING_KYC", rating: 5.0 },
    { id: "DRV-0881", name: "Budi Santoso", phone: "081298765432", armada: "Motor", plate: "B 6543 TRF", sim: "2345-6789-0123", stnk: "STNK-Aktif-2028", status: "ACTIVE", rating: 4.96 },
    { id: "DRV-0774", name: "Tono Hermawan", phone: "085611223344", armada: "Ambulance", plate: "B 9110 MED", sim: "7766-5544-3322", stnk: "STNK-Aktif-2029", status: "ACTIVE", rating: 4.98 },
    { id: "DRV-0551", name: "Rian Fahmi", phone: "087899887766", armada: "Motor", plate: "B 3321 VBN", sim: "3344-5566-7788", stnk: "STNK-Aktif-2025", status: "SUSPENDED", rating: 3.82 },
  ]);

  // Fraud / GIS Fleet State
  const [fleetLocations, setFleetLocations] = useState([
    { id: "DRV-0881", name: "Budi Santoso", lat: -6.2088, lng: 106.8456, locName: "SCBD Jakarta", speed: "32 km/h", status: "Delivering", fraudFlag: false },
    { id: "DRV-0912", name: "Ahmad Dani", lat: -6.1754, lng: 106.8272, locName: "Monas Gambir", speed: "24 km/h", status: "Idle", fraudFlag: false },
    { id: "DRV-0551", name: "Rian Fahmi", lat: -6.2240, lng: 106.8090, locName: "Kuningan Barat", speed: "148 km/h ⚠️", status: "Anomaly", fraudFlag: true, fraudReason: "Teleportasi Anomali GPS >140km/h di jalan sempit" },
    { id: "DRV-0774", name: "Tono Hermawan", lat: -6.2300, lng: 106.8200, locName: "RS Cipto Mangunkusumo", speed: "45 km/h", status: "Medevac", fraudFlag: false },
  ]);

  // Merchants State
  const [merchants, setMerchants] = useState([
    { id: "MCH-01", name: "Ayam Goreng Pak Bareng", category: "Kuliner (Food)", branch: "Jakarta Selatan", commission: "15%", wallet: 14250000, bank: "BCA 882019231", status: "Active" },
    { id: "MCH-02", name: "Apotek Medika Sehat 24 Jam", category: "Kesehatan (Health)", branch: "Jakarta Pusat", commission: "10%", wallet: 8900000, bank: "Mandiri 120008819", status: "Active" },
    { id: "MCH-03", name: "Bakso Granat Rawamangun", category: "Kuliner (Food)", branch: "Jakarta Timur", commission: "15%", wallet: 4120000, bank: "BRI 029101889", status: "Active" },
    { id: "MCH-04", name: "Klinik Pratama Bispira Care", category: "Kesehatan (Health)", branch: "Jakarta Selatan", commission: "8%", wallet: 19800000, bank: "BCA 771029191", status: "Active" },
  ]);

  // Payout Batch State
  const [batchSettlementPending, setBatchSettlementPending] = useState(true);
  const [stats, setStats] = useState(null);
  const [isLoading, setIsLoading] = useState(false);

  // Sandbox Tester State
  const [testUserBalance, setTestUserBalance] = useState(250000);
  const [testVaResult, setTestVaResult] = useState(null);
  const [testBifastResult, setTestBifastResult] = useState(null);
  const [testSplitResult, setTestSplitResult] = useState(null);
  const [testLogs, setTestLogs] = useState([]);

  const addTestLog = (title, data) => {
    setTestLogs((prev) => [
      { id: Date.now(), time: new Date().toLocaleTimeString("id-ID"), title, data },
      ...prev.slice(0, 9),
    ]);
  };

  const showToast = (msg) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3500);
  };

  const toggleTheme = () => {
    const next = theme === "dark" ? "light" : "dark";
    setTheme(next);
    document.documentElement.setAttribute("data-theme", next);
  };

  // Fetch live backend data
  const fetchBackendData = async () => {
    setIsLoading(true);
    try {
      // 1. Stats
      const resStats = await fetch("/api/v1/admin/dashboard/stats");
      const dataStats = await resStats.json();
      if (dataStats.status === "SUCCESS") {
        setStats(dataStats.data);
      }

      // 2. Merchants
      const resMch = await fetch("/api/v1/admin/merchants");
      const dataMch = await resMch.json();
      if (dataMch.status === "SUCCESS" && dataMch.data.items) {
        setMerchants(dataMch.data.items);
      }

      // 3. Drivers
      const resDrv = await fetch("/api/v1/admin/drivers/verification-pending");
      const dataDrv = await resDrv.json();
      if (dataDrv.status === "SUCCESS") {
        setDrivers(dataDrv.data.drivers || []);
      }

      // 4. Pending Payments
      const resPay = await fetch("/api/v1/admin/payments/pending");
      const dataPay = await resPay.json();
      if (dataPay.status === "SUCCESS") {
        setPayments(dataPay.data.items || []);
      }

      // 5. User balance
      const resUser = await fetch("/api/v1/user/wallet?userId=BSP-2026-9042");
      const dataUser = await resUser.json();
      if (dataUser.status === "SUCCESS") {
        setTestUserBalance(dataUser.data.user.walletBalance);
      }
    } catch (err) {
      console.warn("Backend fetch sync fallback:", err);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchBackendData();
  }, []);

  const handleApprovePayment = async (id) => {
    try {
      const res = await fetch(`/api/v1/admin/payments/${id}/approve`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ bank_mutation_reference: "MUTASI_WEB_VERIFIED" }),
      });
      const data = await res.json();
      if (data.status === "SUCCESS") {
        showToast(`✅ ${data.message}`);
        fetchBackendData();
      } else {
        showToast(`❌ ${data.message}`);
      }
    } catch (err) {
      showToast(`❌ Gagal: ${err.message}`);
    }
  };

  const handleRejectPayment = async (id) => {
    try {
      const res = await fetch(`/api/v1/admin/payments/${id}/reject`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ reason: "Mutasi transfer tidak ditemukan pada mutasi e-banking" }),
      });
      const data = await res.json();
      if (data.status === "SUCCESS") {
        showToast(`✖️ ${data.message}`);
        fetchBackendData();
      }
    } catch (err) {
      showToast(`❌ Gagal: ${err.message}`);
    }
  };

  const handleApproveDriver = async (id) => {
    try {
      const res = await fetch(`/api/v1/admin/drivers/${id}/approve`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ approval_note: "Dokumen KTP/SIM/STNK disetujui via Web Admin Suite" }),
      });
      const data = await res.json();
      if (data.status === "SUCCESS") {
        showToast(`🎉 ${data.message}`);
        fetchBackendData();
      }
    } catch (err) {
      showToast(`❌ Gagal: ${err.message}`);
    }
  };

  const handleSuspendDriver = (id) => {
    setDrivers((prev) =>
      prev.map((d) => (d.id === id ? { ...d, kycStatus: "SUSPENDED" } : d))
    );
    showToast(`🚨 Akun Driver #${id} telah disuspend karena indikasi anomali.`);
  };

  const handleSaveTariff = async (e) => {
    e.preventDefault();
    try {
      const res = await fetch("/api/v1/admin/settings/financial", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          tariffs: {
            ride_motor_per_km: tariffs.ridePerKm,
            service_fee: tariffs.rideAppFee,
            ambulance_base_fee: tariffs.ambulanceBase,
            driver_charge_per_trip: tariffs.driverCharge,
          },
        }),
      });
      const data = await res.json();
      if (data.status === "SUCCESS") {
        showToast("💾 Seluruh tarif dan komisi tersimpan ke backend Next.js secara realtime!");
        fetchBackendData();
      }
    } catch (err) {
      showToast(`❌ Gagal simpan tarif: ${err.message}`);
    }
  };

  const handleExecuteBatch = async () => {
    try {
      const res = await fetch("/api/v1/admin/disbursements/execute-batch", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
      });
      const data = await res.json();
      if (data.status === "SUCCESS") {
        setBatchSettlementPending(false);
        showToast(`⚡ ${data.message}`);
        fetchBackendData();
      }
    } catch (err) {
      showToast(`❌ Gagal batch payout: ${err.message}`);
    }
  };

  // Sandbox Test Actions for User App Backend
  const handleTestCreateVA = async (bankCode, amount) => {
    try {
      const res = await fetch("/api/v1/va/create", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ userId: "BSP-2026-9042", bankCode, amount }),
      });
      const data = await res.json();
      if (data.status === "SUCCESS") {
        setTestVaResult(data.data);
        addTestLog(`Penerbitan VA ${bankCode} Rp ${amount.toLocaleString("id-ID")}`, data.data);
        showToast(`✅ VA ${bankCode}: ${data.data.vaNumber} berhasil diterbitkan`);
      }
    } catch (err) {
      showToast(`❌ Error: ${err.message}`);
    }
  };

  const handleTestBankInquiry = async (bankCode, accountNumber) => {
    try {
      const res = await fetch("/api/v1/disbursements/bank-query", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ bankCode, accountNumber }),
      });
      const data = await res.json();
      if (data.status === "SUCCESS") {
        setTestBifastResult(data.data);
        addTestLog(`Inquiry BI-Fast Rekening ${accountNumber}`, data.data);
        showToast(`✅ Valid: ${data.data.accountHolderName} (${data.data.bankCode})`);
      }
    } catch (err) {
      showToast(`❌ Error: ${err.message}`);
    }
  };

  const handleTestWithdraw = async (amount) => {
    try {
      const res = await fetch("/api/v1/disbursements/withdraw", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          userId: "BSP-2026-9042",
          amount,
          bankCode: "BNI",
          accountNumber: "9876543210",
          accountHolderName: "DAVY WAHYU SAPUTRA",
        }),
      });
      const data = await res.json();
      if (data.status === "SUCCESS") {
        setTestUserBalance(data.data.newBalance);
        addTestLog(`Penarikan BI-Fast Rp ${amount.toLocaleString("id-ID")}`, data.data);
        showToast(`✅ ${data.message}. Sisa saldo: Rp ${data.data.newBalance.toLocaleString("id-ID")}`);
        fetchBackendData();
      } else {
        showToast(`❌ ${data.message}`);
      }
    } catch (err) {
      showToast(`❌ Error: ${err.message}`);
    }
  };

  const handleTestSplitPayment = async (amount, serviceType) => {
    try {
      const res = await fetch("/api/v1/transactions/split-checkout", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          userId: "BSP-2026-9042",
          totalAmount: amount,
          serviceType,
          mitraId: "drv_8801",
          branchId: "BRN-001",
        }),
      });
      const data = await res.json();
      if (data.status === "SUCCESS") {
        setTestSplitResult(data.data);
        setTestUserBalance(data.data.userRemainingBalance);
        addTestLog(`Split Payment ${serviceType} (3 Pihak)`, data.data);
        showToast(`🎉 Order ${data.data.orderId}: Pihak 1 (User), Pihak 2 (Mitra 90%), Pihak 3 (Pusat & Cabang) sukses!`);
        fetchBackendData();
      } else {
        showToast(`❌ ${data.message}`);
      }
    } catch (err) {
      showToast(`❌ Error: ${err.message}`);
    }
  };

  const handleTestSimulatePaidWebhook = async () => {
    if (!testVaResult) {
      showToast("⚠️ Buat Virtual Account terlebih dahulu sebelum simulasi pembayaran.");
      return;
    }
    try {
      const res = await fetch("/api/v1/webhooks/payment", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          vaNumber: testVaResult.vaNumber,
          amount: testVaResult.expectedAmount,
          bankCode: testVaResult.bankCode,
        }),
      });
      const data = await res.json();
      if (data.status === "SUCCESS") {
        setTestUserBalance(data.data.userNewBalance);
        addTestLog(`Webhook Pembayaran VA ${testVaResult.vaNumber} Lunas`, data.data);
        showToast(`💰 Webhook Berhasil: Saldo user bertambah menjadi Rp ${data.data.userNewBalance.toLocaleString("id-ID")}`);
        fetchBackendData();
      }
    } catch (err) {
      showToast(`❌ Error: ${err.message}`);
    }
  };

  // Calculate live simulation
  const calcSimResult = () => {
    if (simService === "ride") {
      const fare = tariffs.rideBase + simDistance * tariffs.ridePerKm + tariffs.rideAppFee;
      const driverNet = Math.round(fare * 0.95);
      const appFee = fare - driverNet;
      return { total: fare, driverNet, appFee };
    } else if (simService === "ambulance") {
      const fare = tariffs.ambulanceBase + simDistance * tariffs.ambulancePerKm;
      const driverNet = Math.round(fare * 0.95);
      const appFee = fare - driverNet;
      return { total: fare, driverNet, appFee };
    } else {
      const fare = tariffs.foodBase + simDistance * tariffs.foodPerKm;
      const driverNet = Math.round(fare * 0.95);
      return { total: fare, driverNet, appFee: fare - driverNet };
    }
  };

  const simResult = calcSimResult();

  return (
    <div className="app-container" data-theme={theme}>
      {/* Toast Notification */}
      {toastMessage && (
        <div className="toast-container">
          <div className="toast">
            <span>{toastMessage}</span>
          </div>
        </div>
      )}

      {/* SIDEBAR NAVIGATION */}
      <aside className="sidebar">
        <div className="sidebar-header">
          <div className="brand-badge">B</div>
          <div className="brand-info">
            <h1>BISPIRA ADMIN</h1>
            <p>
              <span className="status-dot"></span>
              Sistem Online v2.4 (Next.js)
            </p>
          </div>
        </div>

        <nav className="sidebar-nav">
          <div className="nav-label">Menu Utama</div>
          <button
            className={`nav-item ${activeTab === "dashboard" ? "active" : ""}`}
            onClick={() => setActiveTab("dashboard")}
          >
            <LayoutDashboard size={18} />
            <span>Dashboard Overview</span>
          </button>

          <div className="nav-label">Keuangan & Tarif</div>
          <button
            className={`nav-item ${activeTab === "tariff" ? "active" : ""}`}
            onClick={() => setActiveTab("tariff")}
          >
            <Percent size={18} />
            <span>Tarif & Biaya Layanan</span>
          </button>
          <button
            className={`nav-item ${activeTab === "reconciliation" ? "active" : ""}`}
            onClick={() => setActiveTab("reconciliation")}
          >
            <CheckCircle2 size={18} />
            <span>Rekonsiliasi Kode Unik</span>
            <span className="nav-badge">
              {payments.filter((p) => p.status === "PENDING").length}
            </span>
          </button>
          <button
            className={`nav-item ${activeTab === "settlement" ? "active" : ""}`}
            onClick={() => setActiveTab("settlement")}
          >
            <Banknote size={18} />
            <span>Batch Settlement (17:00)</span>
          </button>

          <div className="nav-label">Operasional Armada</div>
          <button
            className={`nav-item ${activeTab === "gis" ? "active" : ""}`}
            onClick={() => setActiveTab("gis")}
          >
            <Navigation size={18} />
            <span>GIS Tracking & Fraud</span>
            <span className="nav-badge">1 Flag</span>
          </button>
          <button
            className={`nav-item ${activeTab === "drivers" ? "active" : ""}`}
            onClick={() => setActiveTab("drivers")}
          >
            <Car size={18} />
            <span>Driver Master & KYC</span>
            <span className="nav-badge">
              {drivers.filter((d) => d.status === "PENDING_KYC").length}
            </span>
          </button>
          <button
            className={`nav-item ${activeTab === "merchants" ? "active" : ""}`}
            onClick={() => setActiveTab("merchants")}
          >
            <Store size={18} />
            <span>Merchant Master</span>
          </button>

          <div className="nav-label">Pengawasan & Lisensi</div>
          <button
            className={`nav-item ${activeTab === "users" ? "active" : ""}`}
            onClick={() => setActiveTab("users")}
          >
            <Users size={18} />
            <span>User Master & Wallet</span>
          </button>
          <button
            className={`nav-item ${activeTab === "branches" ? "active" : ""}`}
            onClick={() => setActiveTab("branches")}
          >
            <Building2 size={18} />
            <span>Cabang & Lisensi</span>
          </button>

          <div className="nav-label">Developer & Sandbox</div>
          <button
            className={`nav-item ${activeTab === "api-tester" ? "active" : ""}`}
            onClick={() => setActiveTab("api-tester")}
          >
            <Smartphone size={18} />
            <span>Live API Tester (User & Admin)</span>
            <span className="nav-badge" style={{ background: "#10b981", color: "#ffffff" }}>Live</span>
          </button>
        </nav>

        <div className="sidebar-footer">
          <div className="admin-avatar">SA</div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontSize: "13px", fontWeight: "700" }}>Super Administrator</div>
            <div style={{ fontSize: "11px", color: "var(--text-muted)", overflow: "hidden", textOverflow: "ellipsis" }}>
              admin@bispira.id
            </div>
          </div>
        </div>
      </aside>

      {/* MAIN VIEWPORT */}
      <div className="main-wrapper">
        {/* TOPBAR */}
        <header className="topbar">
          <div className="topbar-search">
            <Search size={16} color="var(--text-muted)" />
            <input
              type="text"
              placeholder="Cari Order ID, Driver, Merchant, Rekening..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>

          <div className="topbar-actions">
            <button className="action-btn" onClick={toggleTheme} title="Ganti Tema">
              {theme === "dark" ? <Sun size={18} /> : <Moon size={18} />}
            </button>
            <button
              className="action-btn"
              onClick={() => showToast("🔄 Data dashboard berhasil disinkronkan realtime!")}
              title="Sinkronisasi Data"
            >
              <RefreshCw size={18} />
            </button>
            <button
              className="action-btn"
              onClick={() => setNotificationsOpen(!notificationsOpen)}
              title="Notifikasi"
            >
              <Bell size={18} />
              <span className="indicator"></span>
            </button>
          </div>
        </header>

        {/* CONTENT BODY */}
        <main className="content-body">
          {/* TAB 1: DASHBOARD */}
          {activeTab === "dashboard" && (
            <div>
              <div className="page-header">
                <div>
                  <h2 className="page-title">Executive Command Dashboard</h2>
                  <p className="page-desc">
                    Monitoring operasional dan keuangan 4 pilar layanan SuperApp BISPIRA di seluruh cabang.
                  </p>
                </div>
                <div style={{ display: "flex", gap: "10px" }}>
                  <button className="btn-secondary" onClick={() => showToast("📥 Laporan Excel telah diunduh.")}>
                    <Download size={16} /> Unduh Laporan
                  </button>
                  <button className="btn-primary" onClick={() => setActiveTab("tariff")}>
                    <Sliders size={16} /> Atur Parameter Tarif
                  </button>
                </div>
              </div>

              {/* STATS CARDS */}
              <div className="stats-grid">
                <div className="card">
                  <div className="stat-header">
                    <span className="stat-title">Omzet Kotor Harian</span>
                    <div className="stat-icon" style={{ background: "rgba(37, 99, 235, 0.15)", color: "#3b82f6" }}>
                      <DollarSign size={22} />
                    </div>
                  </div>
                  <div className="stat-value">Rp 184.520.000</div>
                  <div className="stat-trend trend-up">
                    <TrendingUp size={14} /> +18.4% vs kemarin
                  </div>
                </div>

                <div className="card">
                  <div className="stat-header">
                    <span className="stat-title">Total Transaksi Selesai</span>
                    <div className="stat-icon" style={{ background: "rgba(16, 185, 129, 0.15)", color: "#10b981" }}>
                      <CheckCircle2 size={22} />
                    </div>
                  </div>
                  <div className="stat-value">1.482 Trip</div>
                  <div className="stat-trend trend-up">
                    <TrendingUp size={14} /> 98.2% Completion Rate
                  </div>
                </div>

                <div className="card">
                  <div className="stat-header">
                    <span className="stat-title">Mitra Driver Online</span>
                    <div className="stat-icon" style={{ background: "rgba(245, 158, 11, 0.15)", color: "#f59e0b" }}>
                      <Car size={22} />
                    </div>
                  </div>
                  <div className="stat-value">429 Driver</div>
                  <div className="stat-trend trend-up">
                    <TrendingUp size={14} /> 85 Armada Siaga di Peta
                  </div>
                </div>

                <div className="card">
                  <div className="stat-header">
                    <span className="stat-title">Pencairan Batch 17:00</span>
                    <div className="stat-icon" style={{ background: "rgba(139, 92, 246, 0.15)", color: "#8b5cf6" }}>
                      <Banknote size={22} />
                    </div>
                  </div>
                  <div className="stat-value">Rp 42.850.000</div>
                  <div className="stat-trend trend-neutral">
                    <Clock size={14} /> 58 Rekening Siap Transfer
                  </div>
                </div>
              </div>

              {/* PILLAR BREAKDOWN */}
              <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))", gap: "16px", marginBottom: "28px" }}>
                <div className="card" style={{ padding: "16px", borderLeft: "4px solid #2563eb" }}>
                  <div style={{ fontSize: "12px", color: "var(--text-muted)", fontWeight: "700" }}>BISPIRA RIDE 🛵</div>
                  <div style={{ fontSize: "20px", fontWeight: "800", marginTop: "4px" }}>712 Trip (48%)</div>
                  <div style={{ fontSize: "12px", color: "#60a5fa", marginTop: "2px" }}>Rp 72.400.000</div>
                </div>
                <div className="card" style={{ padding: "16px", borderLeft: "4px solid #f59e0b" }}>
                  <div style={{ fontSize: "12px", color: "var(--text-muted)", fontWeight: "700" }}>BISPIRA FOOD 🍔</div>
                  <div style={{ fontSize: "20px", fontWeight: "800", marginTop: "4px" }}>520 Order (35%)</div>
                  <div style={{ fontSize: "12px", color: "#fbbf24", marginTop: "2px" }}>Rp 58.120.000</div>
                </div>
                <div className="card" style={{ padding: "16px", borderLeft: "4px solid #10b981" }}>
                  <div style={{ fontSize: "12px", color: "var(--text-muted)", fontWeight: "700" }}>BISPIRA HEALTH 💊</div>
                  <div style={{ fontSize: "20px", fontWeight: "800", marginTop: "4px" }}>210 Resep (14%)</div>
                  <div style={{ fontSize: "12px", color: "#34d399", marginTop: "2px" }}>Rp 29.000.000</div>
                </div>
                <div className="card" style={{ padding: "16px", borderLeft: "4px solid #ef4444" }}>
                  <div style={{ fontSize: "12px", color: "var(--text-muted)", fontWeight: "700" }}>AMBULANCE MEDEVAC 🚑</div>
                  <div style={{ fontSize: "20px", fontWeight: "800", marginTop: "4px" }}>40 Darurat (3%)</div>
                  <div style={{ fontSize: "12px", color: "#f87171", marginTop: "2px" }}>Rp 25.000.000</div>
                </div>
              </div>

              {/* RECENT TRANSACTIONS TABLE */}
              <div className="table-wrapper">
                <div className="table-header-bar">
                  <h3 className="table-header-title">Aktivitas Transaksi Realtime</h3>
                  <div className="table-actions">
                    <button className="btn-secondary" style={{ padding: "6px 12px", fontSize: "12px" }}>
                      <Filter size={14} /> Filter Layanan
                    </button>
                  </div>
                </div>
                <table>
                  <thead>
                    <tr>
                      <th>Order ID</th>
                      <th>Layanan</th>
                      <th>Pelanggan</th>
                      <th>Driver / Toko</th>
                      <th>Total Biaya</th>
                      <th>Status Order</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td style={{ fontWeight: "700", color: "#60a5fa" }}>#ORD-9912</td>
                      <td>🛵 Bispira Ride</td>
                      <td>Budi Pratama</td>
                      <td>DRV-0881 (Budi Santoso)</td>
                      <td>Rp 18.000</td>
                      <td><span className="badge badge-success">Selesai ✅</span></td>
                    </tr>
                    <tr>
                      <td style={{ fontWeight: "700", color: "#60a5fa" }}>#ORD-9911</td>
                      <td>🍔 Bispira Food</td>
                      <td>Siti Rahmawati</td>
                      <td>Ayam Goreng Pak Bareng</td>
                      <td>Rp 54.000</td>
                      <td><span className="badge badge-info">Sedang Diantar 🚀</span></td>
                    </tr>
                    <tr>
                      <td style={{ fontWeight: "700", color: "#60a5fa" }}>#ORD-9910</td>
                      <td>🚑 Ambulance</td>
                      <td>Bp. Hendra</td>
                      <td>DRV-0774 (Ambulance RSCM)</td>
                      <td>Rp 250.000</td>
                      <td><span className="badge badge-warning">Menuju Lokasi 🚨</span></td>
                    </tr>
                    <tr>
                      <td style={{ fontWeight: "700", color: "#60a5fa" }}>#ORD-9909</td>
                      <td>💊 Bispira Health</td>
                      <td>Rina Kusuma</td>
                      <td>Apotek Medika Sehat</td>
                      <td>Rp 72.500</td>
                      <td><span className="badge badge-purple">Disiapkan Toko 📦</span></td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB 2: TARIFF & FINANCIAL CUSTOMIZATION */}
          {activeTab === "tariff" && (
            <div>
              <div className="page-header">
                <div>
                  <h2 className="page-title">Pengaturan Tarif & Biaya Layanan Realtime</h2>
                  <p className="page-desc">
                    Sesuaikan tarif dasar, tarif per km, dan bagi hasil tanpa perlu build/redeploy aplikasi mobile.
                  </p>
                </div>
                <button className="btn-primary" onClick={handleSaveTariff}>
                  <Check size={16} /> Simpan Perubahan Tarif
                </button>
              </div>

              <div style={{ display: "grid", gridTemplateColumns: "1.4fr 1fr", gap: "24px" }}>
                {/* Form Editor */}
                <div className="card">
                  <h3 style={{ fontSize: "16px", fontWeight: "800", marginBottom: "16px" }}>
                    Parameter Finansial Tiap Moda
                  </h3>

                  <form onSubmit={handleSaveTariff}>
                    <div style={{ marginBottom: "20px", paddingBottom: "16px", borderBottom: "1px solid var(--border-subtle)" }}>
                      <h4 style={{ fontSize: "14px", fontWeight: "700", color: "#60a5fa", marginBottom: "12px" }}>
                        🛵 BISPIRA RIDE (Transportasi Motor)
                      </h4>
                      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: "12px" }}>
                        <div className="form-group">
                          <label className="form-label">Tarif Dasar (Rp)</label>
                          <input
                            type="number"
                            className="form-input"
                            value={tariffs.rideBase}
                            onChange={(e) => setTariffs({ ...tariffs, rideBase: Number(e.target.value) })}
                          />
                        </div>
                        <div className="form-group">
                          <label className="form-label">Per Kilometer (Rp)</label>
                          <input
                            type="number"
                            className="form-input"
                            value={tariffs.ridePerKm}
                            onChange={(e) => setTariffs({ ...tariffs, ridePerKm: Number(e.target.value) })}
                          />
                        </div>
                        <div className="form-group">
                          <label className="form-label">Platform App Fee (Rp)</label>
                          <input
                            type="number"
                            className="form-input"
                            value={tariffs.rideAppFee}
                            onChange={(e) => setTariffs({ ...tariffs, rideAppFee: Number(e.target.value) })}
                          />
                        </div>
                      </div>
                    </div>

                    <div style={{ marginBottom: "20px", paddingBottom: "16px", borderBottom: "1px solid var(--border-subtle)" }}>
                      <h4 style={{ fontSize: "14px", fontWeight: "700", color: "#fbbf24", marginBottom: "12px" }}>
                        🍔 BISPIRA FOOD & DELIVERY
                      </h4>
                      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: "12px" }}>
                        <div className="form-group">
                          <label className="form-label">Ongkir Dasar (Rp)</label>
                          <input
                            type="number"
                            className="form-input"
                            value={tariffs.foodBase}
                            onChange={(e) => setTariffs({ ...tariffs, foodBase: Number(e.target.value) })}
                          />
                        </div>
                        <div className="form-group">
                          <label className="form-label">Ongkir Per KM (Rp)</label>
                          <input
                            type="number"
                            className="form-input"
                            value={tariffs.foodPerKm}
                            onChange={(e) => setTariffs({ ...tariffs, foodPerKm: Number(e.target.value) })}
                          />
                        </div>
                        <div className="form-group">
                          <label className="form-label">Komisi Merchant (%)</label>
                          <input
                            type="number"
                            className="form-input"
                            value={tariffs.foodCommission}
                            onChange={(e) => setTariffs({ ...tariffs, foodCommission: Number(e.target.value) })}
                          />
                        </div>
                      </div>
                    </div>

                    <div style={{ marginBottom: "20px" }}>
                      <h4 style={{ fontSize: "14px", fontWeight: "700", color: "#f87171", marginBottom: "12px" }}>
                        🚑 AMBULANCE & MEDEVAC MEDIS
                      </h4>
                      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px" }}>
                        <div className="form-group">
                          <label className="form-label">Tarif Darurat Standar (Rp)</label>
                          <input
                            type="number"
                            className="form-input"
                            value={tariffs.ambulanceBase}
                            onChange={(e) => setTariffs({ ...tariffs, ambulanceBase: Number(e.target.value) })}
                          />
                        </div>
                        <div className="form-group">
                          <label className="form-label">Tarif Antar Per KM (Rp)</label>
                          <input
                            type="number"
                            className="form-input"
                            value={tariffs.ambulancePerKm}
                            onChange={(e) => setTariffs({ ...tariffs, ambulancePerKm: Number(e.target.value) })}
                          />
                        </div>
                      </div>
                    </div>

                    <button type="submit" className="btn-primary" style={{ width: "100%", justifyContent: "center" }}>
                      Simpan & Terapkan Perubahan Realtime
                    </button>
                  </form>
                </div>

                {/* Live Fare Calculator / Simulator */}
                <div>
                  <div className="card" style={{ background: "linear-gradient(145deg, rgba(37,99,235,0.1), rgba(6,182,212,0.05))" }}>
                    <h3 style={{ fontSize: "16px", fontWeight: "800", marginBottom: "16px" }}>
                      🧮 Simulator Perhitungan Tarif
                    </h3>

                    <div className="form-group">
                      <label className="form-label">Pilih Layanan Uji Coba</label>
                      <select
                        className="form-input"
                        value={simService}
                        onChange={(e) => setSimService(e.target.value)}
                      >
                        <option value="ride">Bispira Ride 🛵</option>
                        <option value="food">Bispira Food 🍔</option>
                        <option value="ambulance">Ambulance Medevac 🚑</option>
                      </select>
                    </div>

                    <div className="form-group">
                      <label className="form-label">Simulasi Jarak Tempuh ({simDistance} KM)</label>
                      <input
                        type="range"
                        min="1"
                        max="25"
                        step="0.5"
                        value={simDistance}
                        onChange={(e) => setSimDistance(Number(e.target.value))}
                        style={{ width: "100%", accentColor: "#2563eb" }}
                      />
                    </div>

                    <div style={{ background: "rgba(0,0,0,0.3)", borderRadius: "12px", padding: "16px", marginTop: "16px" }}>
                      <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "8px", fontSize: "13px" }}>
                        <span style={{ color: "var(--text-secondary)" }}>Total Ditagih ke User:</span>
                        <strong style={{ fontSize: "16px", color: "var(--text-primary)" }}>
                          Rp {simResult.total.toLocaleString("id-ID")}
                        </strong>
                      </div>
                      <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "8px", fontSize: "13px" }}>
                        <span style={{ color: "var(--text-secondary)" }}>Pendapatan Driver (95% Split):</span>
                        <strong style={{ color: "#34d399" }}>
                          Rp {simResult.driverNet.toLocaleString("id-ID")}
                        </strong>
                      </div>
                      <div style={{ display: "flex", justifyContent: "space-between", fontSize: "13px" }}>
                        <span style={{ color: "var(--text-secondary)" }}>Pendapatan Platform Bispira:</span>
                        <strong style={{ color: "#60a5fa" }}>
                          Rp {simResult.appFee.toLocaleString("id-ID")}
                        </strong>
                      </div>
                    </div>
                  </div>

                  {/* Tariff Audit Log */}
                  <div className="card" style={{ marginTop: "20px" }}>
                    <h4 style={{ fontSize: "13.5px", fontWeight: "700", marginBottom: "10px" }}>
                      Riwayat Audit Perubahan Terakhir
                    </h4>
                    <div style={{ fontSize: "12px", color: "var(--text-muted)", display: "flex", flexDirection: "column", gap: "8px" }}>
                      <div>• <strong>admin@bispira.id</strong> mengubah Bispira Ride per KM: Rp 2.500 &rarr; Rp 2.800 (Hari ini, 10:14)</div>
                      <div>• <strong>superadmin</strong> mengubah Komisi Merchant Food: 20% &rarr; 15% (Kemarin, 16:30)</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* TAB 3: RECONCILIATION */}
          {activeTab === "reconciliation" && (
            <div>
              <div className="page-header">
                <div>
                  <h2 className="page-title">Rekonsiliasi Manual Kode Unik (3-Digit)</h2>
                  <p className="page-desc">
                    Verifikasi pencocokan transfer manual perbankan dengan nominal eksak dan kode unik 3-digit.
                  </p>
                </div>
                <button className="btn-secondary" onClick={() => showToast("🔄 Antrean mutasi bank diperbarui.")}>
                  <RefreshCw size={16} /> Refresh Mutasi
                </button>
              </div>

              <div className="table-wrapper">
                <div className="table-header-bar">
                  <h3 className="table-header-title">Antrean Pembayaran Masuk Belum Diverifikasi</h3>
                  <span className="badge badge-warning">
                    {payments.filter((p) => p.status === "PENDING").length} Menunggu Konfirmasi
                  </span>
                </div>
                <table>
                  <thead>
                    <tr>
                      <th>Payment ID</th>
                      <th>Order ID</th>
                      <th>Nama Pengirim</th>
                      <th>Bank Tujuan</th>
                      <th>Nominal Pokok</th>
                      <th>Kode Unik</th>
                      <th>Nominal Eksak Transfer</th>
                      <th>Aksi Admin</th>
                    </tr>
                  </thead>
                  <tbody>
                    {payments.map((p) => (
                      <tr key={p.id}>
                        <td style={{ fontWeight: "700" }}>{p.id}</td>
                        <td style={{ color: "#60a5fa" }}>{p.orderId}</td>
                        <td>{p.user}</td>
                        <td>
                          <span className="badge badge-info">{p.bank}</span>
                        </td>
                        <td>Rp {p.amount.toLocaleString("id-ID")}</td>
                        <td>
                          <strong style={{ color: "#f59e0b", fontSize: "14px" }}>+{p.code}</strong>
                        </td>
                        <td style={{ fontWeight: "800", color: "#34d399", fontSize: "14px" }}>
                          Rp {p.total.toLocaleString("id-ID")}
                        </td>
                        <td>
                          {p.status === "PENDING" ? (
                            <div style={{ display: "flex", gap: "8px" }}>
                              <button
                                className="btn-primary"
                                style={{ padding: "6px 12px", fontSize: "12px", background: "#10b981" }}
                                onClick={() => handleApprovePayment(p.id)}
                              >
                                Approve ✅
                              </button>
                              <button
                                className="btn-secondary"
                                style={{ padding: "6px 12px", fontSize: "12px", color: "#fb7185" }}
                                onClick={() => handleRejectPayment(p.id)}
                              >
                                Tolak ✖
                              </button>
                            </div>
                          ) : p.status === "VERIFIED" ? (
                            <span className="badge badge-success">Terverifikasi ✅</span>
                          ) : (
                            <span className="badge badge-danger">Ditolak ❌</span>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB 4: BATCH SETTLEMENT */}
          {activeTab === "settlement" && (
            <div>
              <div className="page-header">
                <div>
                  <h2 className="page-title">Pencairan Dana Otomatis (Batch Settlement)</h2>
                  <p className="page-desc">
                    Jadwal batch payout harian pukul 17:00 WIB ke seluruh rekening bank mitra merchant dan dompet driver.
                  </p>
                </div>
                {batchSettlementPending ? (
                  <button className="btn-primary" style={{ background: "#10b981" }} onClick={handleExecuteBatch}>
                    <Banknote size={16} /> Eksekusi Batch Transfer Sekarang
                  </button>
                ) : (
                  <span className="badge badge-success" style={{ padding: "8px 16px", fontSize: "13px" }}>
                    Batch Hari Ini Berhasil Diproses (17:00 WIB)
                  </span>
                )}
              </div>

              <div className="stats-grid">
                <div className="card">
                  <span className="stat-title">Total Nominal Batch Hari Ini</span>
                  <div className="stat-value" style={{ color: "#34d399", marginTop: "8px" }}>
                    Rp 42.850.000
                  </div>
                  <div className="stat-trend trend-neutral">Pencairan Net Setelah Komisi</div>
                </div>
                <div className="card">
                  <span className="stat-title">Penerima Merchant Makanan & Obat</span>
                  <div className="stat-value" style={{ marginTop: "8px" }}>24 Toko</div>
                  <div className="stat-trend trend-up">Total: Rp 28.600.000</div>
                </div>
                <div className="card">
                  <span className="stat-title">Pencairan Saldo Driver (BI-FAST)</span>
                  <div className="stat-value" style={{ marginTop: "8px" }}>34 Driver</div>
                  <div className="stat-trend trend-up">Total: Rp 14.250.000</div>
                </div>
              </div>

              <div className="table-wrapper">
                <div className="table-header-bar">
                  <h3 className="table-header-title">Rincian Antrean Penerima Batch Payout</h3>
                </div>
                <table>
                  <thead>
                    <tr>
                      <th>ID Mitra</th>
                      <th>Nama Entitas</th>
                      <th>Tipe</th>
                      <th>Bank Tujuan & No Rekening</th>
                      <th>Kotor</th>
                      <th>Potongan Biaya</th>
                      <th>Bersih Ditransfer</th>
                      <th>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>MCH-01</td>
                      <td style={{ fontWeight: "700" }}>Ayam Goreng Pak Bareng</td>
                      <td>Merchant Food</td>
                      <td>BCA • 882019231</td>
                      <td>Rp 16.765.000</td>
                      <td style={{ color: "#fb7185" }}>- Rp 2.515.000 (15%)</td>
                      <td style={{ fontWeight: "800", color: "#34d399" }}>Rp 14.250.000</td>
                      <td>
                        <span className={`badge ${batchSettlementPending ? "badge-warning" : "badge-success"}`}>
                          {batchSettlementPending ? "Siap Kirim ⏱️" : "Terkirim ⚡"}
                        </span>
                      </td>
                    </tr>
                    <tr>
                      <td>MCH-02</td>
                      <td style={{ fontWeight: "700" }}>Apotek Medika Sehat 24 Jam</td>
                      <td>Merchant Health</td>
                      <td>Mandiri • 120008819</td>
                      <td>Rp 9.890.000</td>
                      <td style={{ color: "#fb7185" }}>- Rp 990.000 (10%)</td>
                      <td style={{ fontWeight: "800", color: "#34d399" }}>Rp 8.900.000</td>
                      <td>
                        <span className={`badge ${batchSettlementPending ? "badge-warning" : "badge-success"}`}>
                          {batchSettlementPending ? "Siap Kirim ⏱️" : "Terkirim ⚡"}
                        </span>
                      </td>
                    </tr>
                    <tr>
                      <td>DRV-0881</td>
                      <td style={{ fontWeight: "700" }}>Budi Santoso</td>
                      <td>Driver Partner</td>
                      <td>BCA • 8840192381 (BI-FAST)</td>
                      <td>Rp 150.000</td>
                      <td style={{ color: "var(--text-muted)" }}>Rp 0 (Gratis)</td>
                      <td style={{ fontWeight: "800", color: "#34d399" }}>Rp 150.000</td>
                      <td>
                        <span className={`badge ${batchSettlementPending ? "badge-warning" : "badge-success"}`}>
                          {batchSettlementPending ? "Siap Kirim ⏱️" : "Terkirim ⚡"}
                        </span>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB 5: GIS FLEET & FRAUD */}
          {activeTab === "gis" && (
            <div>
              <div className="page-header">
                <div>
                  <h2 className="page-title">GIS Live Fleet Tracking & Deteksi Fake GPS</h2>
                  <p className="page-desc">
                    Pemantauan armada online waktu nyata dan sistem deteksi kecurangan lokasi palsu (mock GPS).
                  </p>
                </div>
                <button className="btn-secondary" onClick={() => showToast("📡 Ping GPS armada disinkronkan.")}>
                  <RefreshCw size={16} /> Perbarui GPS Ping
                </button>
              </div>

              {/* Alert Fraud Banner */}
              <div
                style={{
                  background: "rgba(244, 63, 94, 0.15)",
                  border: "1px solid rgba(244, 63, 94, 0.4)",
                  borderRadius: "14px",
                  padding: "16px 20px",
                  marginBottom: "24px",
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "space-between",
                }}
              >
                <div style={{ display: "flex", alignItems: "center", gap: "14px" }}>
                  <ShieldAlert size={26} color="#fb7185" />
                  <div>
                    <strong style={{ color: "#fb7185", fontSize: "14px" }}>
                      Peringatan Kecurangan Fake GPS Terdeteksi!
                    </strong>
                    <div style={{ fontSize: "12.5px", color: "var(--text-secondary)", marginTop: "2px" }}>
                      Driver <strong>Rian Fahmi (DRV-0551)</strong> terdeteksi anomali kecepatan 148 km/h di area padat Kuningan Barat.
                    </div>
                  </div>
                </div>
                <button
                  className="btn-primary"
                  style={{ background: "#ef4444" }}
                  onClick={() => handleSuspendDriver("DRV-0551")}
                >
                  Suspend Akun Driver Sekarang 🚨
                </button>
              </div>

              {/* Visual Map Representation */}
              <div className="card" style={{ marginBottom: "24px" }}>
                <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "14px" }}>
                  <h3 style={{ fontSize: "15px", fontWeight: "700" }}>Peta Posisi Armada Aktif (Jakarta & Sekitarnya)</h3>
                  <span style={{ fontSize: "12px", color: "var(--text-muted)" }}>OpenStreetMap Live Telemetry</span>
                </div>
                <div
                  style={{
                    background: "#0f172a",
                    border: "1px solid var(--border-subtle)",
                    borderRadius: "12px",
                    height: "260px",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    position: "relative",
                    overflow: "hidden",
                  }}
                >
                  {/* Grid Lines Pattern */}
                  <div
                    style={{
                      position: "absolute",
                      inset: 0,
                      backgroundImage:
                        "radial-gradient(#334155 1.5px, transparent 1.5px), radial-gradient(#1e293b 1.5px, transparent 1.5px)",
                      backgroundSize: "30px 30px",
                      opacity: 0.6,
                    }}
                  />
                  {fleetLocations.map((f, idx) => (
                    <div
                      key={f.id}
                      style={{
                        position: "absolute",
                        top: `${30 + idx * 45}px`,
                        left: `${15 + idx * 22}%`,
                        display: "flex",
                        alignItems: "center",
                        gap: "8px",
                        background: f.fraudFlag ? "rgba(239, 68, 68, 0.9)" : "rgba(30, 41, 59, 0.9)",
                        padding: "6px 12px",
                        borderRadius: "20px",
                        border: `1.5px solid ${f.fraudFlag ? "#f87171" : "#3b82f6"}`,
                        boxShadow: "0 4px 14px rgba(0,0,0,0.5)",
                        cursor: "pointer",
                      }}
                      onClick={() => showToast(`📍 ${f.name} (${f.locName}) - Kec: ${f.speed}`)}
                    >
                      <span>{f.fraudFlag ? "🚨" : f.status === "Medevac" ? "🚑" : "🛵"}</span>
                      <span style={{ fontSize: "11.5px", fontWeight: "700", color: "white" }}>
                        {f.name} ({f.speed})
                      </span>
                    </div>
                  ))}
                </div>
              </div>

              {/* Fleet Table */}
              <div className="table-wrapper">
                <div className="table-header-bar">
                  <h3 className="table-header-title">Daftar Armada & Log Kecepatan</h3>
                </div>
                <table>
                  <thead>
                    <tr>
                      <th>Driver ID</th>
                      <th>Nama Mitra</th>
                      <th>Lokasi Terakhir</th>
                      <th>Kecepatan Terhitung</th>
                      <th>Status</th>
                      <th>Indikasi Fraud</th>
                      <th>Aksi Intervensi</th>
                    </tr>
                  </thead>
                  <tbody>
                    {fleetLocations.map((f) => (
                      <tr key={f.id}>
                        <td>{f.id}</td>
                        <td style={{ fontWeight: "700" }}>{f.name}</td>
                        <td>{f.locName}</td>
                        <td style={{ fontWeight: "700" }}>{f.speed}</td>
                        <td>
                          <span className={`badge ${f.status === "Delivering" ? "badge-info" : f.status === "Anomaly" ? "badge-danger" : "badge-success"}`}>
                            {f.status}
                          </span>
                        </td>
                        <td>
                          {f.fraudFlag ? (
                            <span className="badge badge-danger">ANOMALI GPS ⚠️</span>
                          ) : (
                            <span className="badge badge-success">Aman Valid ✅</span>
                          )}
                        </td>
                        <td>
                          {f.fraudFlag ? (
                            <button
                              className="btn-primary"
                              style={{ padding: "5px 10px", fontSize: "11.5px", background: "#ef4444" }}
                              onClick={() => handleSuspendDriver(f.id)}
                            >
                              Suspend 🚨
                            </button>
                          ) : (
                            <button
                              className="btn-secondary"
                              style={{ padding: "5px 10px", fontSize: "11.5px" }}
                              onClick={() => showToast(`Oper order ke driver ${f.name} siap!`)}
                            >
                              Oper Order
                            </button>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB 6: DRIVER MASTER & KYC */}
          {activeTab === "drivers" && (
            <div>
              <div className="page-header">
                <div>
                  <h2 className="page-title">Driver Master & Verifikasi KYC</h2>
                  <p className="page-desc">
                    Pemeriksaan berkas pendaftaran calon mitra driver (KTP, SIM, STNK, Tipe Kendaraan).
                  </p>
                </div>
                <span className="badge badge-warning" style={{ padding: "8px 14px", fontSize: "13px" }}>
                  {drivers.filter((d) => d.status === "PENDING_KYC").length} Berkas Menunggu Verifikasi
                </span>
              </div>

              <div className="table-wrapper">
                <div className="table-header-bar">
                  <h3 className="table-header-title">Master Data Driver & Verifikasi Dokumen</h3>
                </div>
                <table>
                  <thead>
                    <tr>
                      <th>Driver ID</th>
                      <th>Nama Lengkap</th>
                      <th>No. Handphone</th>
                      <th>Armada</th>
                      <th>Plat Nomor</th>
                      <th>Status SIM & STNK</th>
                      <th>Status Akun</th>
                      <th>Aksi Admin</th>
                    </tr>
                  </thead>
                  <tbody>
                    {drivers.map((d) => (
                      <tr key={d.id}>
                        <td style={{ fontWeight: "700" }}>{d.id}</td>
                        <td style={{ fontWeight: "700" }}>{d.name}</td>
                        <td>{d.phone}</td>
                        <td>
                          <span className="badge badge-info">{d.armada}</span>
                        </td>
                        <td style={{ fontWeight: "800", color: "#f59e0b" }}>{d.plate}</td>
                        <td>
                          <div style={{ fontSize: "11.5px" }}>SIM: {d.sim}</div>
                          <div style={{ fontSize: "11px", color: "var(--text-muted)" }}>{d.stnk}</div>
                        </td>
                        <td>
                          <span
                            className={`badge ${
                              d.status === "ACTIVE"
                                ? "badge-success"
                                : d.status === "PENDING_KYC"
                                ? "badge-warning"
                                : "badge-danger"
                            }`}
                          >
                            {d.status === "ACTIVE"
                              ? "Aktif Siap Order ✅"
                              : d.status === "PENDING_KYC"
                              ? "Menunggu KYC ⏱️"
                              : "Disuspend 🚨"}
                          </span>
                        </td>
                        <td>
                          {d.status === "PENDING_KYC" ? (
                            <div style={{ display: "flex", gap: "6px" }}>
                              <button
                                className="btn-primary"
                                style={{ padding: "6px 10px", fontSize: "11.5px", background: "#10b981" }}
                                onClick={() => handleApproveDriver(d.id)}
                              >
                                Loloskan KYC ✅
                              </button>
                              <button
                                className="btn-secondary"
                                style={{ padding: "6px 10px", fontSize: "11.5px", color: "#fb7185" }}
                                onClick={() => showToast(`Berkas driver ${d.name} diminta perbaikan foto STNK.`)}
                              >
                                Revisi
                              </button>
                            </div>
                          ) : d.status === "ACTIVE" ? (
                            <button
                              className="btn-secondary"
                              style={{ padding: "5px 10px", fontSize: "11.5px", color: "#fb7185" }}
                              onClick={() => handleSuspendDriver(d.id)}
                            >
                              Suspend
                            </button>
                          ) : (
                            <button
                              className="btn-secondary"
                              style={{ padding: "5px 10px", fontSize: "11.5px", color: "#34d399" }}
                              onClick={() => handleApproveDriver(d.id)}
                            >
                              Buka Suspend
                            </button>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB 7: MERCHANT MASTER */}
          {activeTab === "merchants" && (
            <div>
              <div className="page-header">
                <div>
                  <h2 className="page-title">Merchant Master (Food & Health)</h2>
                  <p className="page-desc">
                    Kelola data merchant kuliner dan mitra kesehatan, persentase komisi, dan rekening pencairan.
                  </p>
                </div>
                <button className="btn-primary" onClick={() => showToast("Form tambah merchant baru dibuka.")}>
                  <Plus size={16} /> Tambah Mitra Merchant
                </button>
              </div>

              <div className="table-wrapper">
                <div className="table-header-bar">
                  <h3 className="table-header-title">Daftar Mitra Merchant Terdaftar</h3>
                </div>
                <table>
                  <thead>
                    <tr>
                      <th>Merchant ID</th>
                      <th>Nama Usaha</th>
                      <th>Pemilik</th>
                      <th>Kategori Layanan</th>
                      <th>Kabupaten</th>
                      <th>Rerata Harga Dasar</th>
                      <th>Markup Platform</th>
                      <th>Akumulasi Penjualan</th>
                      <th>Status Toko</th>
                    </tr>
                  </thead>
                  <tbody>
                    {merchants.map((m) => (
                      <tr key={m.id}>
                        <td style={{ fontWeight: "700" }}>{m.id}</td>
                        <td style={{ fontWeight: "700" }}>{m.storeName || m.name}</td>
                        <td style={{ color: "var(--text-muted)" }}>{m.ownerName || "-"}</td>
                        <td>
                          <span className={`badge ${(m.category || "").includes("Food") ? "badge-warning" : "badge-success"}`}>
                            {m.category}
                          </span>
                        </td>
                        <td>{m.kabupaten || m.branch || "Jakarta Selatan"}</td>
                        <td style={{ fontWeight: "800", color: "#38bdf8" }}>
                          Rp {(m.basePriceAvg || 18000).toLocaleString("id-ID")}
                        </td>
                        <td style={{ fontWeight: "800", color: "#60a5fa" }}>
                          {m.markupPercent ? `${m.markupPercent}%` : m.commission || "10%"}
                        </td>
                        <td style={{ fontWeight: "800", color: "#10b981" }}>
                          Rp {(m.accumulatedSales !== undefined ? m.accumulatedSales : (m.wallet || 0)).toLocaleString("id-ID")}
                        </td>
                        <td>
                          <span className="badge badge-success">{m.subscriptionStatus || m.status || "LUNAS BULANAN"}</span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB 8: USERS & WALLET */}
          {activeTab === "users" && (
            <div>
              <div className="page-header">
                <div>
                  <h2 className="page-title">User Master & Dompet Pelanggan</h2>
                  <p className="page-desc">
                    Pemantauan basis pelanggan terdaftar, status dompet digital BispiraPay, dan moderasi akun.
                  </p>
                </div>
              </div>

              <div className="table-wrapper">
                <div className="table-header-bar">
                  <h3 className="table-header-title">Basis Pengguna Aplikasi Pelanggan</h3>
                </div>
                <table>
                  <thead>
                    <tr>
                      <th>User ID</th>
                      <th>Nama Pengguna</th>
                      <th>No. Handphone</th>
                      <th>Saldo BispiraPay</th>
                      <th>Total Order Selesai</th>
                      <th>Status Akun</th>
                      <th>Aksi</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>USR-0921</td>
                      <td style={{ fontWeight: "700" }}>Budi Pratama</td>
                      <td>081299881122</td>
                      <td style={{ fontWeight: "800", color: "#34d399" }}>Rp 420.000</td>
                      <td>48 Transaksi</td>
                      <td><span className="badge badge-success">Aktif Normal</span></td>
                      <td>
                        <button className="btn-secondary" style={{ padding: "5px 10px", fontSize: "11.5px" }} onClick={() => showToast("Detail akun dimuat.")}>
                          Lihat Detail
                        </button>
                      </td>
                    </tr>
                    <tr>
                      <td>USR-0922</td>
                      <td style={{ fontWeight: "700" }}>Siti Rahmawati</td>
                      <td>081388776655</td>
                      <td style={{ fontWeight: "800", color: "#34d399" }}>Rp 1.150.000</td>
                      <td>112 Transaksi</td>
                      <td><span className="badge badge-success">Aktif Normal</span></td>
                      <td>
                        <button className="btn-secondary" style={{ padding: "5px 10px", fontSize: "11.5px" }} onClick={() => showToast("Detail akun dimuat.")}>
                          Lihat Detail
                        </button>
                      </td>
                    </tr>
                    <tr>
                      <td>USR-0401</td>
                      <td style={{ fontWeight: "700" }}>Akun Terindikasi Spam</td>
                      <td>085600998877</td>
                      <td style={{ fontWeight: "800", color: "#fb7185" }}>Rp 0</td>
                      <td>0 Transaksi</td>
                      <td><span className="badge badge-danger">Dibekukan 🔒</span></td>
                      <td>
                        <button className="btn-secondary" style={{ padding: "5px 10px", fontSize: "11.5px", color: "#34d399" }} onClick={() => showToast("Akun dipulihkan.")}>
                          Buka Kunci
                        </button>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB 9: BRANCHES & LICENSES */}
          {activeTab === "branches" && (
            <div>
              <div className="page-header">
                <div>
                  <h2 className="page-title">Cabang Wilayah & Lisensi Operasional</h2>
                  <p className="page-desc">
                    Pengelolaan cabang regional, masa berlaku lisensi operasional, dan hak akses Super Admin vs Regional.
                  </p>
                </div>
                <button className="btn-primary" onClick={() => showToast("Modal buka cabang baru aktif.")}>
                  <Building2 size={16} /> Tambah Kantor Cabang
                </button>
              </div>

              <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(300px, 1fr))", gap: "20px" }}>
                <div className="card">
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: "12px" }}>
                    <div>
                      <h3 style={{ fontSize: "16px", fontWeight: "800" }}>Cabang Jakarta Pusat (Kantor Pusat)</h3>
                      <p style={{ fontSize: "12px", color: "var(--text-muted)" }}>Kode Cabang: BR-JKT-01</p>
                    </div>
                    <span className="badge badge-success">Lisensi Utama HQ</span>
                  </div>
                  <div style={{ fontSize: "13px", color: "var(--text-secondary)", marginBottom: "14px" }}>
                    <div>• Regional Admin: 4 Orang</div>
                    <div>• Mitra Driver Aktif: 210 Driver</div>
                    <div>• Masa Berlaku: Permanen (Enterprise Master)</div>
                  </div>
                  <button className="btn-secondary" style={{ width: "100%", justifyContent: "center" }} onClick={() => showToast("Manajemen cabang Jakarta Pusat dibuka.")}>
                    Kelola Wilayah Operasi
                  </button>
                </div>

                <div className="card">
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: "12px" }}>
                    <div>
                      <h3 style={{ fontSize: "16px", fontWeight: "800" }}>Cabang Surabaya & Sidoarjo</h3>
                      <p style={{ fontSize: "12px", color: "var(--text-muted)" }}>Kode Cabang: BR-SBY-02</p>
                    </div>
                    <span className="badge badge-info">Aktif Operasi</span>
                  </div>
                  <div style={{ fontSize: "13px", color: "var(--text-secondary)", marginBottom: "14px" }}>
                    <div>• Regional Admin: 2 Orang</div>
                    <div>• Mitra Driver Aktif: 125 Driver</div>
                    <div>• Masa Berlaku: 31 Desember 2027</div>
                  </div>
                  <button className="btn-secondary" style={{ width: "100%", justifyContent: "center" }} onClick={() => showToast("Manajemen cabang Surabaya dibuka.")}>
                    Kelola Wilayah Operasi
                  </button>
                </div>

                <div className="card">
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: "12px" }}>
                    <div>
                      <h3 style={{ fontSize: "16px", fontWeight: "800" }}>Cabang Bandung Raya</h3>
                      <p style={{ fontSize: "12px", color: "var(--text-muted)" }}>Kode Cabang: BR-BDG-03</p>
                    </div>
                    <span className="badge badge-info">Aktif Operasi</span>
                  </div>
                  <div style={{ fontSize: "13px", color: "var(--text-secondary)", marginBottom: "14px" }}>
                    <div>• Regional Admin: 2 Orang</div>
                    <div>• Mitra Driver Aktif: 94 Driver</div>
                    <div>• Masa Berlaku: 31 Desember 2027</div>
                  </div>
                  <button className="btn-secondary" style={{ width: "100%", justifyContent: "center" }} onClick={() => showToast("Manajemen cabang Bandung dibuka.")}>
                    Kelola Wilayah Operasi
                  </button>
                </div>
              </div>
            </div>
          )}

          {/* TAB 10: DEVELOPER & LIVE API TESTER */}
          {activeTab === "api-tester" && (
            <div>
              <div className="page-header">
                <div>
                  <h2 className="page-title">Live API Backend Sandbox Tester</h2>
                  <p className="page-desc">
                    Uji coba langsung seluruh integrasi endpoint Next.js untuk <strong>Aplikasi User</strong> dan <strong>Aplikasi Admin</strong> secara realtime.
                  </p>
                </div>
                <div style={{ display: "flex", gap: "10px", alignItems: "center" }}>
                  <div
                    style={{
                      background: "rgba(16, 185, 129, 0.15)",
                      border: "1px solid #10b981",
                      borderRadius: "10px",
                      padding: "8px 16px",
                      display: "flex",
                      alignItems: "center",
                      gap: "10px",
                    }}
                  >
                    <div style={{ fontSize: "11.5px", color: "var(--text-muted)" }}>Saldo User (Davy):</div>
                    <div style={{ fontSize: "16px", fontWeight: "800", color: "#10b981" }}>
                      Rp {testUserBalance.toLocaleString("id-ID")}
                    </div>
                  </div>
                  <button className="btn-secondary" onClick={fetchBackendData}>
                    <RefreshCw size={15} /> Sinkron Data
                  </button>
                </div>
              </div>

              {/* 4 ACTION PANELS */}
              <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(320px, 1fr))", gap: "20px", marginBottom: "24px" }}>
                {/* 1. SNAP BI VIRTUAL ACCOUNT */}
                <div className="card" style={{ padding: "20px" }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "12px" }}>
                    <div style={{ fontSize: "14px", fontWeight: "800" }}>💳 1. Virtual Account (SNAP BI)</div>
                    <span className="badge badge-info">User API</span>
                  </div>
                  <p style={{ fontSize: "12px", color: "var(--text-muted)", marginBottom: "16px" }}>
                    Endpoint: <code>POST /api/v1/va/create</code> & <code>POST /api/v1/webhooks/payment</code>
                  </p>

                  <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
                    <div style={{ display: "flex", gap: "8px" }}>
                      <button
                        className="btn-primary"
                        style={{ flex: 1, fontSize: "12px", padding: "8px" }}
                        onClick={() => handleTestCreateVA("BNI", 100000)}
                      >
                        + VA BNI (100rb)
                      </button>
                      <button
                        className="btn-primary"
                        style={{ flex: 1, fontSize: "12px", padding: "8px", background: "#0066FF" }}
                        onClick={() => handleTestCreateVA("BCA", 250000)}
                      >
                        + VA BCA (250rb)
                      </button>
                    </div>

                    {testVaResult && (
                      <div
                        style={{
                          background: "var(--bg-card-header)",
                          padding: "12px",
                          borderRadius: "8px",
                          fontSize: "12px",
                          marginTop: "8px",
                          border: "1px dashed var(--border-subtle)",
                        }}
                      >
                        <div><strong>No. VA:</strong> <span style={{ color: "#38bdf8", fontWeight: "800" }}>{testVaResult.vaNumber}</span> ({testVaResult.bankCode})</div>
                        <div><strong>Nominal:</strong> Rp {testVaResult.expectedAmount.toLocaleString("id-ID")}</div>
                        <div><strong>Status:</strong> <span className="badge badge-warning" style={{ fontSize: "10px" }}>{testVaResult.status}</span></div>

                        <button
                          className="btn-primary"
                          style={{ width: "100%", marginTop: "10px", background: "#10b981", fontSize: "11.5px", padding: "7px" }}
                          onClick={handleTestSimulatePaidWebhook}
                        >
                          ⚡ Simulasi User Selesai Bayar di ATM (Webhook)
                        </button>
                      </div>
                    )}
                  </div>
                </div>

                {/* 2. BI-FAST INQUIRY & WITHDRAWAL */}
                <div className="card" style={{ padding: "20px" }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "12px" }}>
                    <div style={{ fontSize: "14px", fontWeight: "800" }}>🏦 2. BI-Fast Instant Payout</div>
                    <span className="badge badge-info">User API</span>
                  </div>
                  <p style={{ fontSize: "12px", color: "var(--text-muted)", marginBottom: "16px" }}>
                    Endpoint: <code>POST /disbursements/bank-query</code> & <code>/withdraw</code>
                  </p>

                  <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
                    <div style={{ display: "flex", gap: "8px" }}>
                      <button
                        className="btn-secondary"
                        style={{ flex: 1, fontSize: "12px", padding: "8px" }}
                        onClick={() => handleTestBankInquiry("BNI", "9876543210")}
                      >
                        🔍 Inquiry BNI
                      </button>
                      <button
                        className="btn-secondary"
                        style={{ flex: 1, fontSize: "12px", padding: "8px" }}
                        onClick={() => handleTestBankInquiry("BCA", "1283921020")}
                      >
                        🔍 Inquiry BCA
                      </button>
                    </div>

                    <div style={{ display: "flex", gap: "8px", marginTop: "4px" }}>
                      <button
                        className="btn-primary"
                        style={{ flex: 1, fontSize: "12px", padding: "8px", background: "#f59e0b" }}
                        onClick={() => handleTestWithdraw(50000)}
                      >
                        💸 Tarik Rp 50.000
                      </button>
                      <button
                        className="btn-primary"
                        style={{ flex: 1, fontSize: "12px", padding: "8px", background: "#f59e0b" }}
                        onClick={() => handleTestWithdraw(100000)}
                      >
                        💸 Tarik Rp 100.000
                      </button>
                    </div>
                    <div style={{ fontSize: "11px", color: "var(--text-muted)", textAlign: "center" }}>
                      *Otomatis memotong biaya admin BI-Fast Rp 2.500
                    </div>
                  </div>
                </div>

                {/* 3. MULTI-PARTY SPLIT CHECKOUT */}
                <div className="card" style={{ padding: "20px" }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "12px" }}>
                    <div style={{ fontSize: "14px", fontWeight: "800" }}>🔀 3. Pecah Transaksi 3-Pihak</div>
                    <span className="badge badge-success">Engine Transaksi</span>
                  </div>
                  <p style={{ fontSize: "12px", color: "var(--text-muted)", marginBottom: "16px" }}>
                    Endpoint: <code>POST /api/v1/transactions/split-checkout</code>
                  </p>

                  <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
                    <button
                      className="btn-primary"
                      style={{ fontSize: "12px", padding: "9px" }}
                      onClick={() => handleTestSplitPayment(25000, "BISPIRA RIDE (Ojek Motor)")}
                    >
                      🛵 Order Ride Rp 25.000 (Mitra 90% + Fee 10%)
                    </button>
                    <button
                      className="btn-primary"
                      style={{ fontSize: "12px", padding: "9px", background: "#6366F1" }}
                      onClick={() => handleTestSplitPayment(60000, "BISPIRA FOOD (Resto Geprek)")}
                    >
                      🍔 Order Food Rp 60.000 (Mitra 90% + Fee 10%)
                    </button>

                    <div style={{ fontSize: "11px", color: "var(--text-muted)", marginTop: "4px" }}>
                      Fee 10% platform otomatis dipecah: <strong>70% Pusat</strong> dan <strong>30% Cabang</strong>.
                    </div>
                  </div>
                </div>

                {/* 4. ADMIN QUICK ACTIONS */}
                <div className="card" style={{ padding: "20px" }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "12px" }}>
                    <div style={{ fontSize: "14px", fontWeight: "800" }}>⚙️ 4. Aksi Cepat Admin Backend</div>
                    <span className="badge badge-warning">Admin API</span>
                  </div>
                  <p style={{ fontSize: "12px", color: "var(--text-muted)", marginBottom: "16px" }}>
                    Endpoint: <code>PUT /settings/financial</code> & <code>POST /disbursements/execute-batch</code>
                  </p>

                  <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
                    <button
                      className="btn-secondary"
                      style={{ fontSize: "12px", padding: "9px", justifyContent: "center" }}
                      onClick={handleSaveTariff}
                    >
                      💾 Sinkronkan Konfigurasi Tarif ke Database
                    </button>
                    <button
                      className="btn-primary"
                      style={{ fontSize: "12px", padding: "9px", background: "#8b5cf6", justifyContent: "center" }}
                      onClick={handleExecuteBatch}
                    >
                      ⚡ Eksekusi Batch Payout 17:00 WIB
                    </button>
                  </div>
                </div>
              </div>

              {/* LIVE AUDIT LOG TERMINAL */}
              <div className="card" style={{ padding: "20px" }}>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "12px" }}>
                  <div style={{ fontSize: "14px", fontWeight: "800" }}>📜 Live API Request & Response Stream</div>
                  <button className="btn-secondary" style={{ fontSize: "11.5px", padding: "4px 10px" }} onClick={() => setTestLogs([])}>
                    Bersihkan Log
                  </button>
                </div>

                {testLogs.length === 0 ? (
                  <div style={{ padding: "30px", textAlign: "center", color: "var(--text-muted)", fontSize: "13px" }}>
                    Klik tombol aksi di atas untuk menguji coba eksekusi backend secara realtime. Response JSON akan tampil di sini.
                  </div>
                ) : (
                  <div style={{ display: "flex", flexDirection: "column", gap: "10px", maxHeight: "350px", overflowY: "auto" }}>
                    {testLogs.map((log) => (
                      <div
                        key={log.id}
                        style={{
                          background: "var(--bg-main)",
                          padding: "12px",
                          borderRadius: "8px",
                          border: "1px solid var(--border-subtle)",
                        }}
                      >
                        <div style={{ display: "flex", justifyContent: "space-between", fontSize: "12px", fontWeight: "700", marginBottom: "6px" }}>
                          <span style={{ color: "#38bdf8" }}>▶ [{log.time}] {log.title}</span>
                          <span className="badge badge-success" style={{ fontSize: "10px" }}>HTTP 200 OK</span>
                        </div>
                        <pre
                          style={{
                            margin: 0,
                            padding: "8px",
                            background: "rgba(0,0,0,0.25)",
                            borderRadius: "6px",
                            fontSize: "11px",
                            fontFamily: "monospace",
                            overflowX: "auto",
                            color: "#94a3b8",
                          }}
                        >
                          {JSON.stringify(log.data, null, 2)}
                        </pre>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            </div>
          )}
        </main>
      </div>
    </div>
  );
}
