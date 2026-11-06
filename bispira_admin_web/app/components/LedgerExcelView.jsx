"use client";

import React, { useState, useEffect } from "react";
import {
  FileSpreadsheet,
  Download,
  Search,
  Filter,
  RefreshCw,
  TrendingUp,
  CreditCard,
  Building2,
  Users,
  ShieldCheck,
  Calendar,
  Layers,
  Banknote
} from "lucide-react";

export default function LedgerExcelView({ showToast }) {
  const [activeSubTab, setActiveSubTab] = useState("sheet1");
  const [searchQuery, setSearchQuery] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [dataStore, setDataStore] = useState({
    sheet1: null,
    sheet2: null,
    sheet3: null,
    sheet4: null,
    sheet5: null,
    sheet6: null,
    sheet7: null,
    sheet8: null,
    sheet9: null,
    sheet10: null,
    sheet12: null,
    formulir_penjual: null,
  });

  const fmtRupiah = (val) => {
    if (val === undefined || val === null) return "Rp 0";
    return "Rp " + Number(val).toLocaleString("id-ID");
  };

  const fetchSheetData = async (sheetKey) => {
    setIsLoading(true);
    let endpoint = "";
    if (sheetKey === "sheet1") endpoint = "/api/v1/ledger/transactions";
    else if (sheetKey === "sheet2") endpoint = "/api/v1/ledger/seller-driver-accumulations";
    else if (sheetKey === "sheet3") endpoint = "/api/v1/ledger/driver-wallets";
    else if (sheetKey === "sheet4") endpoint = "/api/v1/ledger/seller-bank-accounts";
    else if (sheetKey === "sheet5") endpoint = "/api/v1/ledger/disbursement-accumulations";
    else if (sheetKey === "sheet6") endpoint = "/api/v1/ledger/disbursements-per-bank";
    else if (sheetKey === "sheet7") endpoint = "/api/v1/ledger/profit-sharing";
    else if (sheetKey === "sheet8") endpoint = "/api/v1/ledger/regional-licenses";
    else if (sheetKey === "sheet9") endpoint = "/api/v1/ledger/tariffs-and-fees";
    else if (sheetKey === "sheet10") endpoint = "/api/v1/ledger/catalog-ecosystem";
    else if (sheetKey === "sheet12") endpoint = "/api/v1/ledger/revenue-sharing-matrix";
    else if (sheetKey === "formulir_penjual") endpoint = "/api/v1/merchant/forms";

    try {
      const res = await fetch(endpoint);
      const json = await res.json();
      if (json.status === "SUCCESS") {
        setDataStore((prev) => ({ ...prev, [sheetKey]: json.data }));
      }
    } catch (err) {
      console.error("Failed to fetch ledger sheet:", err);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    if (!dataStore[activeSubTab]) {
      fetchSheetData(activeSubTab);
    }
  }, [activeSubTab]);

  const handleRefresh = () => {
    fetchSheetData(activeSubTab);
    if (showToast) showToast("🔄 Data Ledger Excel berhasil diperbarui!");
  };

  const subTabs = [
    { key: "sheet1", title: "1. Detail Transaksi", desc: "125 Trx • 21 Kolom • Rp 26.611.839", badge: "Sheet 1" },
    { key: "sheet2", title: "2. Akumulasi Mitra", desc: "68 Mitra • 9 Kolom • Rp 30.342.050", badge: "Sheet 2" },
    { key: "sheet3", title: "3. Saldo Wallet Driver", desc: "50 Driver • 4 Pilar Mutasi", badge: "Sheet 3" },
    { key: "sheet4", title: "4. Master Rekening", desc: "68 Rekening • 9 Bank Operasional", badge: "Sheet 4" },
    { key: "sheet5", title: "5. Akumulasi Pencairan", desc: "Senin & Kamis • Net Rp 30.211.550", badge: "Sheet 5" },
    { key: "sheet6", title: "6. Pencairan Per Bank", desc: "12 Bank Superadmin (9 Aktif + 3 Cadangan)", badge: "Sheet 6" },
    { key: "sheet7", title: "7. Bagi Hasil Daerah", desc: "29 Wilayah • 75:25, 100:0, 20:80", badge: "Sheet 7" },
    { key: "sheet8", title: "8. Profil Lisensi", desc: "12 Lisensi • 261 Toko • 346 Driver • 101 Event", badge: "Sheet 8" },
    { key: "sheet9", title: "9. Pengaturan Tarif & Fees", desc: "5 Parameter Armada • Markup 10% • Fees Rp 500", badge: "Sheet 9" },
    { key: "sheet10", title: "10 & 11. Katalog Ekosistem", desc: "12 Kategori • Sebaran Front End & Back End", badge: "Sheet 10-11" },
    { key: "sheet12", title: "12. Matriks Pendapatan & Split", desc: "16 Cluster Pendapatan • Matriks Split Kerjasama", badge: "Sheet 12" },
    { key: "formulir_penjual", title: "Formulir Penjual (22 Form)", desc: "22 Sheet Master Formulir Registrasi & Input Produk", badge: "22 Form" },
  ];

  return (
    <div>
      {/* PAGE HEADER */}
      <div className="page-header" style={{ marginBottom: "20px" }}>
        <div>
          <h2 className="page-title" style={{ display: "flex", alignItems: "center", gap: "10px" }}>
            <FileSpreadsheet size={24} style={{ color: "#10b981" }} />
            Buku Kas & Ledger Hyperlocal Marketplace (Sheet 1 - 12 Lengkap)
          </h2>
          <p className="page-desc">
            Sistem akuntansi, ledger mutasi transaksi, bagi hasil 10% markup, saldo wallet driver, master 9 bank operasional, batch pencairan dana, profil lisensi daerah, pengaturan tarif & fees, katalog 12 cluster ekosistem, serta matriks pendapatan superadmin sesuai buku besar Excel.
          </p>
        </div>
        <div style={{ display: "flex", gap: "10px" }}>
          <button className="btn-secondary" onClick={handleRefresh} disabled={isLoading}>
            <RefreshCw size={16} className={isLoading ? "animate-spin" : ""} /> Refresh
          </button>
        </div>
      </div>

      {/* SUBTAB NAVIGATION STRIP */}
      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(180px, 1fr))",
          gap: "10px",
          marginBottom: "20px",
        }}
      >
        {subTabs.map((st) => {
          const isAct = activeSubTab === st.key;
          return (
            <div
              key={st.key}
              onClick={() => setActiveSubTab(st.key)}
              style={{
                cursor: "pointer",
                padding: "12px 14px",
                borderRadius: "12px",
                border: isAct ? "2px solid #2563eb" : "1px solid var(--border-subtle)",
                background: isAct ? "rgba(37, 99, 235, 0.12)" : "var(--bg-card)",
                transition: "all 0.2s ease",
              }}
            >
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "4px" }}>
                <span style={{ fontSize: "12px", fontWeight: "800", color: isAct ? "#38bdf8" : "var(--text-main)" }}>
                  {st.title}
                </span>
                <span
                  style={{
                    fontSize: "10px",
                    fontWeight: "700",
                    padding: "2px 6px",
                    borderRadius: "6px",
                    background: isAct ? "#2563eb" : "rgba(255,255,255,0.08)",
                    color: "#ffffff",
                  }}
                >
                  {st.badge}
                </span>
              </div>
              <div style={{ fontSize: "11px", color: "var(--text-muted)" }}>{st.desc}</div>
            </div>
          );
        })}
      </div>

      {/* SEARCH AND FILTER BAR */}
      <div className="table-header-bar" style={{ marginBottom: "16px" }}>
        <div style={{ display: "flex", alignItems: "center", gap: "10px", flex: 1, maxWidth: "420px" }}>
          <div style={{ position: "relative", width: "100%" }}>
            <Search size={16} style={{ position: "absolute", left: "12px", top: "11px", color: "var(--text-muted)" }} />
            <input
              type="text"
              className="form-input"
              style={{ paddingLeft: "36px" }}
              placeholder="Cari transaksi, toko, driver, atau bank..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>
        </div>
        <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
          <span style={{ fontSize: "12px", color: "var(--text-muted)" }}>
            Regulasi Excel Baru: <strong>Markup 10% • Biaya Layanan Rp 500 • Biaya Aplikasi Rp 500</strong>
          </span>
        </div>
      </div>

      {/* RENDER ACTIVE SHEET */}
      {isLoading ? (
        <div style={{ padding: "60px", textAlign: "center", color: "var(--text-muted)" }}>
          <RefreshCw size={32} className="animate-spin" style={{ margin: "0 auto 12px", color: "#2563eb" }} />
          <div>Memuat data Buku Kas Excel...</div>
        </div>
      ) : (
        <>
          {activeSubTab === "sheet1" && renderSheet1(dataStore.sheet1, searchQuery, fmtRupiah)}
          {activeSubTab === "sheet2" && renderSheet2(dataStore.sheet2, searchQuery, fmtRupiah)}
          {activeSubTab === "sheet3" && renderSheet3(dataStore.sheet3, searchQuery, fmtRupiah)}
          {activeSubTab === "sheet4" && renderSheet4(dataStore.sheet4, searchQuery, fmtRupiah)}
          {activeSubTab === "sheet5" && renderSheet5(dataStore.sheet5, searchQuery, fmtRupiah)}
          {activeSubTab === "sheet6" && renderSheet6(dataStore.sheet6, searchQuery, fmtRupiah)}
          {activeSubTab === "sheet7" && renderSheet7(dataStore.sheet7, searchQuery, fmtRupiah)}
          {activeSubTab === "sheet8" && renderSheet8(dataStore.sheet8, searchQuery, fmtRupiah)}
          {activeSubTab === "sheet9" && renderSheet9(dataStore.sheet9, searchQuery, fmtRupiah)}
          {activeSubTab === "sheet10" && renderSheet10(dataStore.sheet10, searchQuery, fmtRupiah)}
          {activeSubTab === "sheet12" && renderSheet12(dataStore.sheet12, searchQuery, fmtRupiah)}
          {activeSubTab === "formulir_penjual" && <FormulirPenjualRenderer data={dataStore.formulir_penjual} search={searchQuery} />}
        </>
      )}
    </div>
  );
}

// -------------------------------------------------------------
// SHEET 1: DETAIL TRANSAKSI (21 KOLOM)
// -------------------------------------------------------------
function renderSheet1(data, search, fmt) {
  if (!data) return null;
  const rows = (data.transactions || []).filter((r) => {
    if (!search) return true;
    const q = search.toLowerCase();
    return (
      (r.nama_pembeli && r.nama_pembeli.toLowerCase().includes(q)) ||
      (r.layanan_produk && r.layanan_produk.toLowerCase().includes(q)) ||
      (r.penjual_merchant_driver && r.penjual_merchant_driver.toLowerCase().includes(q)) ||
      (r.bank && r.bank.toLowerCase().includes(q))
    );
  });
  const summary = data.totalSummary || {};

  return (
    <div>
      {/* KPI METRICS CARDS */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: "14px", marginBottom: "20px" }}>
        <div className="stat-card">
          <div className="stat-label">Total Transaksi Selesai</div>
          <div className="stat-value">{summary.total_transaksi || 125}</div>
          <div className="stat-sub">125 Baris Data Trx Terverifikasi</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Bayar Pembeli (Gross)</div>
          <div className="stat-value" style={{ color: "#38bdf8" }}>{fmt(summary.total_bayar_pembeli || 26611839)}</div>
          <div className="stat-sub">Harga Resmi + Layanan + Ongkir + Kode</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Biaya Layanan Trx</div>
          <div className="stat-value" style={{ color: "#f59e0b" }}>{fmt(summary.total_biaya_layanan || 62500)}</div>
          <div className="stat-sub">Rp 500 x 125 Transaksi</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Biaya Aplikasi Bispira</div>
          <div className="stat-value" style={{ color: "#10b981" }}>{fmt(summary.total_biaya_aplikasi || 62500)}</div>
          <div className="stat-sub">Rp 500 x 125 Transaksi</div>
        </div>
      </div>

      {/* DATA TABLE (HORIZONTAL SCROLLABLE) */}
      <div className="table-wrapper" style={{ overflowX: "auto", maxHeight: "650px" }}>
        <table style={{ minWidth: "2100px", fontSize: "11.5px" }}>
          <thead>
            <tr style={{ background: "var(--bg-card-header)", borderBottom: "2px solid var(--border-subtle)" }}>
              <th style={{ width: "45px" }}>No</th>
              <th style={{ width: "95px" }}>Tanggal</th>
              <th style={{ width: "75px" }}>Jam WIB</th>
              <th style={{ width: "120px" }}>Nama Pembeli</th>
              <th style={{ width: "180px" }}>Layanan / Produk</th>
              <th style={{ width: "180px" }}>Penjual / Driver</th>
              <th style={{ width: "130px" }}>Wilayah Kab/Kota</th>
              <th style={{ width: "100px" }}>Provinsi</th>
              <th style={{ width: "95px" }}>Bank</th>
              <th style={{ width: "110px" }}>Metode Bayar</th>
              <th style={{ textAlign: "right" }}>Harga Dasar</th>
              <th style={{ textAlign: "right" }}>Mark Up 10%</th>
              <th style={{ textAlign: "right" }}>Harga Resmi</th>
              <th style={{ textAlign: "right" }}>Biaya Layanan</th>
              <th style={{ textAlign: "right" }}>Biaya Aplikasi</th>
              <th style={{ textAlign: "right" }}>Biaya Angkut</th>
              <th style={{ textAlign: "right" }}>Kode Unik</th>
              <th style={{ textAlign: "right", color: "#38bdf8", fontWeight: "800" }}>Total Bayar</th>
              <th style={{ textAlign: "right", color: "#10b981", fontWeight: "800" }}>Hak Net Toko</th>
              <th style={{ textAlign: "right", color: "#f59e0b", fontWeight: "800" }}>Hak Net Driver</th>
              <th style={{ textAlign: "right", color: "#a855f7", fontWeight: "800" }}>Net Platform</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => (
              <tr key={r.no || i} style={{ borderBottom: "1px solid var(--border-subtle)" }}>
                <td>{r.no}</td>
                <td>{r.tanggal}</td>
                <td>{r.jam_wib}</td>
                <td style={{ fontWeight: "700" }}>{r.nama_pembeli}</td>
                <td>{r.layanan_produk}</td>
                <td>{r.penjual_merchant_driver}</td>
                <td>{r.wilayah_kab_kota}</td>
                <td>{r.provinsi}</td>
                <td>
                  <span className="badge badge-info">{r.bank}</span>
                </td>
                <td>
                  <span className={`badge ${r.metode_bayar === "Transfer Bank" ? "badge-success" : "badge-warning"}`}>
                    {r.metode_bayar}
                  </span>
                </td>
                <td style={{ textAlign: "right" }}>{fmt(r.harga_dasar)}</td>
                <td style={{ textAlign: "right" }}>{fmt(r.mark_up_10_percent)}</td>
                <td style={{ textAlign: "right" }}>{fmt(r.harga_resmi)}</td>
                <td style={{ textAlign: "right" }}>{fmt(r.biaya_layanan)}</td>
                <td style={{ textAlign: "right" }}>{fmt(r.biaya_aplikasi)}</td>
                <td style={{ textAlign: "right" }}>{fmt(r.biaya_angkut)}</td>
                <td style={{ textAlign: "right" }}>{r.kode_unik_bank ? `Rp ${r.kode_unik_bank}` : "-"}</td>
                <td style={{ textAlign: "right", fontWeight: "800", color: "#38bdf8" }}>{fmt(r.total_bayar_pembeli)}</td>
                <td style={{ textAlign: "right", color: "#10b981" }}>{fmt(r.hak_net_toko_warung)}</td>
                <td style={{ textAlign: "right", color: "#f59e0b" }}>{fmt(r.hak_net_driver)}</td>
                <td style={{ textAlign: "right", color: "#a855f7" }}>{fmt(r.pendapatan_bersih_platform)}</td>
              </tr>
            ))}
          </tbody>
          <tfoot>
            <tr style={{ background: "rgba(37, 99, 235, 0.15)", fontWeight: "900", borderTop: "2px solid #2563eb" }}>
              <td colSpan={10} style={{ textAlign: "center" }}>TOTAL REKAPITULASI EXCEL (BARIS 130)</td>
              <td style={{ textAlign: "right" }}>{fmt(summary.total_harga_dasar)}</td>
              <td style={{ textAlign: "right" }}>{fmt(summary.total_markup)}</td>
              <td style={{ textAlign: "right" }}>{fmt(summary.total_harga_resmi)}</td>
              <td style={{ textAlign: "right" }}>{fmt(summary.total_biaya_layanan)}</td>
              <td style={{ textAlign: "right" }}>{fmt(summary.total_biaya_aplikasi)}</td>
              <td style={{ textAlign: "right" }}>{fmt(summary.total_biaya_angkut)}</td>
              <td style={{ textAlign: "right" }}>{fmt(summary.total_kode_unik)}</td>
              <td style={{ textAlign: "right", color: "#38bdf8" }}>{fmt(summary.total_bayar_pembeli)}</td>
              <td style={{ textAlign: "right", color: "#10b981" }}>{fmt(summary.total_hak_net_toko)}</td>
              <td style={{ textAlign: "right", color: "#f59e0b" }}>{fmt(summary.total_hak_net_driver)}</td>
              <td style={{ textAlign: "right", color: "#a855f7" }}>{fmt(summary.total_net_platform)}</td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  );
}

// -------------------------------------------------------------
// SHEET 2: AKUMULASI PENJUAL & DRIVER (9 KOLOM)
// -------------------------------------------------------------
function renderSheet2(data, search, fmt) {
  if (!data) return null;
  const rows = (data.accumulations || []).filter((r) => {
    if (!search) return true;
    const q = search.toLowerCase();
    return (
      (r.nama_penjual_merchant_driver && r.nama_penjual_merchant_driver.toLowerCase().includes(q)) ||
      (r.kategori_bisnis && r.kategori_bisnis.toLowerCase().includes(q))
    );
  });
  const summary = data.totalSummary || {};

  return (
    <div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: "14px", marginBottom: "20px" }}>
        <div className="stat-card">
          <div className="stat-label">Total Mitra Penerima</div>
          <div className="stat-value">{summary.total_entitas || 68}</div>
          <div className="stat-sub">68 Mitra Toko, Warung & Driver</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Akumulasi Dasar</div>
          <div className="stat-value" style={{ color: "#38bdf8" }}>{fmt(summary.total_akumulasi_dasar || 27690000)}</div>
          <div className="stat-sub">100% Hak Dasar Merchant/Driver</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Hak Penjual Gross</div>
          <div className="stat-value" style={{ color: "#10b981" }}>{fmt(summary.total_hak_penjual_gross || 30342050)}</div>
          <div className="stat-sub">Total Hak Sebelum Potongan Biaya Trx</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Biaya Skema Trx</div>
          <div className="stat-value" style={{ color: "#f59e0b" }}>{fmt(summary.total_biaya_layanan_trx || 62500)}</div>
          <div className="stat-sub">Rp 500 per transaksi</div>
        </div>
      </div>

      <div className="table-wrapper" style={{ overflowX: "auto", maxHeight: "650px" }}>
        <table style={{ minWidth: "1200px", fontSize: "12px" }}>
          <thead>
            <tr style={{ background: "var(--bg-card-header)", borderBottom: "2px solid var(--border-subtle)" }}>
              <th style={{ width: "50px" }}>No</th>
              <th>Nama Penjual / Merchant / Driver</th>
              <th style={{ width: "140px" }}>Kategori Bisnis</th>
              <th style={{ width: "90px", textAlign: "center" }}>Total Trx</th>
              <th style={{ textAlign: "right" }}>Akumulasi Harga Dasar</th>
              <th style={{ textAlign: "right" }}>Akumulasi Biaya Angkut</th>
              <th style={{ textAlign: "right" }}>Akumulasi Komisi Mkt</th>
              <th style={{ textAlign: "right", color: "#10b981", fontWeight: "800" }}>Total Hak Gross</th>
              <th style={{ textAlign: "right", color: "#f59e0b" }}>Biaya Skema Trx</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => (
              <tr key={r.no || i} style={{ borderBottom: "1px solid var(--border-subtle)" }}>
                <td>{r.no}</td>
                <td style={{ fontWeight: "700" }}>{r.nama_penjual_merchant_driver}</td>
                <td>
                  <span className="badge badge-purple">{r.kategori_bisnis}</span>
                </td>
                <td style={{ textAlign: "center", fontWeight: "800" }}>{r.total_trx}</td>
                <td style={{ textAlign: "right" }}>{fmt(r.akumulasi_harga_dasar)}</td>
                <td style={{ textAlign: "right" }}>{fmt(r.akumulasi_biaya_angkut)}</td>
                <td style={{ textAlign: "right" }}>{fmt(r.akumulasi_komisi_marketplace)}</td>
                <td style={{ textAlign: "right", fontWeight: "800", color: "#10b981" }}>{fmt(r.total_hak_penjual_gross)}</td>
                <td style={{ textAlign: "right", color: "#f59e0b" }}>{fmt(r.biaya_layanan_trx_500)}</td>
              </tr>
            ))}
          </tbody>
          <tfoot>
            <tr style={{ background: "rgba(37, 99, 235, 0.15)", fontWeight: "900", borderTop: "2px solid #2563eb" }}>
              <td colSpan={3} style={{ textAlign: "center" }}>TOTAL AKUMULASI EXCEL (BARIS 73)</td>
              <td style={{ textAlign: "center" }}>{summary.total_trx_keseluruhan || 125}</td>
              <td style={{ textAlign: "right" }}>{fmt(summary.total_akumulasi_dasar)}</td>
              <td style={{ textAlign: "right" }}>{fmt(summary.total_akumulasi_angkut)}</td>
              <td style={{ textAlign: "right" }}>{fmt(summary.total_akumulasi_komisi)}</td>
              <td style={{ textAlign: "right", color: "#10b981" }}>{fmt(summary.total_hak_penjual_gross)}</td>
              <td style={{ textAlign: "right", color: "#f59e0b" }}>{fmt(summary.total_biaya_layanan_trx)}</td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  );
}

// -------------------------------------------------------------
// SHEET 3: SALDO WALLET DRIVER (8 KOLOM)
// -------------------------------------------------------------
function renderSheet3(data, search, fmt) {
  if (!data) return null;
  const rows = (data.driverWallets || []).filter((r) => {
    if (!search) return true;
    const q = search.toLowerCase();
    return (
      (r.nama_driver && r.nama_driver.toLowerCase().includes(q)) ||
      (r.moda_transportasi && r.moda_transportasi.toLowerCase().includes(q))
    );
  });
  const summary = data.totalSummary || {};

  return (
    <div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: "14px", marginBottom: "20px" }}>
        <div className="stat-card">
          <div className="stat-label">Total Terdaftar Driver</div>
          <div className="stat-value">{summary.total_driver || 50}</div>
          <div className="stat-sub">50 Driver Seluruh Moda</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Top Up Saldo</div>
          <div className="stat-value" style={{ color: "#38bdf8" }}>{fmt(summary.total_top_up_saldo || 3100000)}</div>
          <div className="stat-sub">Min. Rp 50.000 / Top Up</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Cicilan Atribut</div>
          <div className="stat-value" style={{ color: "#ef4444" }}>{fmt(summary.total_potongan_cicilan_atribut || 25000)}</div>
          <div className="stat-sub">Rp 5.000 / hari (Helm & Jaket)</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Threshold Menerima Order Cash</div>
          <div className="stat-value" style={{ color: "#10b981" }}>Rp 10.000</div>
          <div className="stat-sub">Wajib ada saldo untuk potong platform share</div>
        </div>
      </div>

      <div className="table-wrapper" style={{ overflowX: "auto", maxHeight: "650px" }}>
        <table style={{ minWidth: "1150px", fontSize: "12px" }}>
          <thead>
            <tr style={{ background: "var(--bg-card-header)", borderBottom: "2px solid var(--border-subtle)" }}>
              <th style={{ width: "50px" }}>No</th>
              <th>Nama Driver</th>
              <th style={{ width: "160px" }}>Moda Transportasi</th>
              <th style={{ textAlign: "right", color: "#38bdf8" }}>Total Top Up</th>
              <th style={{ textAlign: "right", color: "#ef4444" }}>Potongan Cicilan Atribut</th>
              <th style={{ textAlign: "right", color: "#f59e0b" }}>Potongan Order Cash</th>
              <th style={{ textAlign: "right", color: "#10b981" }}>Komisi Non-Cash</th>
              <th style={{ textAlign: "right", fontWeight: "900", color: "#ffffff" }}>Saldo Akhir</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => (
              <tr key={r.no || i} style={{ borderBottom: "1px solid var(--border-subtle)" }}>
                <td>{r.no}</td>
                <td style={{ fontWeight: "700" }}>{r.nama_driver}</td>
                <td>
                  <span className="badge badge-info">{r.moda_transportasi}</span>
                </td>
                <td style={{ textAlign: "right", color: "#38bdf8" }}>{fmt(r.total_top_up_saldo)}</td>
                <td style={{ textAlign: "right", color: "#ef4444" }}>{fmt(r.potongan_cicilan_atribut)}</td>
                <td style={{ textAlign: "right", color: "#f59e0b" }}>{fmt(r.potongan_order_cash_pembeli)}</td>
                <td style={{ textAlign: "right", color: "#10b981" }}>{fmt(r.komisi_penghasilan_non_cash)}</td>
                <td style={{ textAlign: "right", fontWeight: "800", color: r.saldo_akhir_wallet < 10000 ? "#ef4444" : "#10b981" }}>
                  {fmt(r.saldo_akhir_wallet)}
                </td>
              </tr>
            ))}
          </tbody>
          <tfoot>
            <tr style={{ background: "rgba(37, 99, 235, 0.15)", fontWeight: "900", borderTop: "2px solid #2563eb" }}>
              <td colSpan={3} style={{ textAlign: "center" }}>TOTAL WALLET DRIVER EXCEL (BARIS 55)</td>
              <td style={{ textAlign: "right", color: "#38bdf8" }}>{fmt(summary.total_top_up_saldo)}</td>
              <td style={{ textAlign: "right", color: "#ef4444" }}>{fmt(summary.total_potongan_cicilan_atribut)}</td>
              <td style={{ textAlign: "right", color: "#f59e0b" }}>{fmt(summary.total_potongan_order_cash)}</td>
              <td style={{ textAlign: "right", color: "#10b981" }}>{fmt(summary.total_komisi_non_cash)}</td>
              <td style={{ textAlign: "right", color: "#ffffff" }}>{fmt(summary.total_saldo_akhir_wallet)}</td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  );
}

// -------------------------------------------------------------
// SHEET 4: MASTER REKENING PENJUAL (7 KOLOM)
// -------------------------------------------------------------
function renderSheet4(data, search, fmt) {
  if (!data) return null;
  const rows = (data.accounts || []).filter((r) => {
    if (!search) return true;
    const q = search.toLowerCase();
    return (
      (r.nama_toko_warung_driver && r.nama_toko_warung_driver.toLowerCase().includes(q)) ||
      (r.nama_pemilik && r.nama_pemilik.toLowerCase().includes(q)) ||
      (r.nama_bank_operasional && r.nama_bank_operasional.toLowerCase().includes(q)) ||
      (r.nomor_rekening && r.nomor_rekening.includes(q))
    );
  });

  return (
    <div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: "14px", marginBottom: "20px" }}>
        <div className="stat-card">
          <div className="stat-label">Total Rekening Master</div>
          <div className="stat-value">{rows.length}</div>
          <div className="stat-sub">68 Rekening Toko & Driver</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Bank Operasional Aktif</div>
          <div className="stat-value" style={{ color: "#38bdf8" }}>9 Bank</div>
          <div className="stat-sub">BCA, Mandiri, BRI, BNI, BSI, Jateng, Jatim, DKI, BJB</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Status Verifikasi</div>
          <div className="stat-value" style={{ color: "#10b981" }}>100% Valid</div>
          <div className="stat-sub">Terdaftar Resmi di Cabang Utama</div>
        </div>
      </div>

      <div className="table-wrapper" style={{ overflowX: "auto", maxHeight: "650px" }}>
        <table style={{ minWidth: "1100px", fontSize: "12px" }}>
          <thead>
            <tr style={{ background: "var(--bg-card-header)", borderBottom: "2px solid var(--border-subtle)" }}>
              <th style={{ width: "50px" }}>No</th>
              <th>Nama Toko / Warung / Driver</th>
              <th>Nama Pemilik Rekening</th>
              <th style={{ width: "130px" }}>Kategori Entitas</th>
              <th style={{ width: "140px" }}>Nama Bank Operasional</th>
              <th style={{ width: "160px" }}>Nomor Rekening</th>
              <th style={{ width: "140px" }}>Cabang / Kota</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => (
              <tr key={r.no || i} style={{ borderBottom: "1px solid var(--border-subtle)" }}>
                <td>{r.no}</td>
                <td style={{ fontWeight: "700" }}>{r.nama_toko_warung_driver}</td>
                <td>{r.nama_pemilik}</td>
                <td>
                  <span className="badge badge-purple">{r.kategori_entitas}</span>
                </td>
                <td>
                  <span className="badge badge-info">{r.nama_bank_operasional}</span>
                </td>
                <td style={{ fontWeight: "800", letterSpacing: "0.5px" }}>{r.nomor_rekening}</td>
                <td>{r.cabang_kota}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

// -------------------------------------------------------------
// SHEET 5: AKUMULASI DANA PENCAIRAN (8 KOLOM)
// -------------------------------------------------------------
function renderSheet5(data, search, fmt) {
  if (!data) return null;
  const rows = (data.accumulations || []).filter((r) => {
    if (!search) return true;
    const q = search.toLowerCase();
    return (
      (r.nama_penjual_driver && r.nama_penjual_driver.toLowerCase().includes(q)) ||
      (r.bank_tujuan && r.bank_tujuan.toLowerCase().includes(q))
    );
  });
  const summary = data.totalSummary || {};

  return (
    <div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: "14px", marginBottom: "20px" }}>
        <div className="stat-card">
          <div className="stat-label">Jadwal Pencairan Rutin</div>
          <div className="stat-value" style={{ color: "#38bdf8", fontSize: "17px" }}>Senin & Kamis</div>
          <div className="stat-sub">17.00 - 23.59 WIB (Batch Transfer)</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Hak Penjual Gross</div>
          <div className="stat-value" style={{ color: "#10b981" }}>{fmt(summary.total_hak_gross || 30342050)}</div>
          <div className="stat-sub">Sebelum potongan biaya layanan</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Biaya Transfer Pencairan</div>
          <div className="stat-value" style={{ color: "#ef4444" }}>{fmt(summary.total_biaya_pencairan || 68000)}</div>
          <div className="stat-sub">Rp 1.000 x 68 Transfer</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Net Dana Dicairkan</div>
          <div className="stat-value" style={{ color: "#38bdf8", fontWeight: "900" }}>{fmt(summary.total_net_pencairan || 30211550)}</div>
          <div className="stat-sub">Gross - Layanan Trx - Biaya Transfer</div>
        </div>
      </div>

      <div className="table-wrapper" style={{ overflowX: "auto", maxHeight: "650px" }}>
        <table style={{ minWidth: "1200px", fontSize: "12px" }}>
          <thead>
            <tr style={{ background: "var(--bg-card-header)", borderBottom: "2px solid var(--border-subtle)" }}>
              <th style={{ width: "50px" }}>No</th>
              <th>Nama Penjual / Driver</th>
              <th style={{ width: "130px" }}>Bank Tujuan</th>
              <th style={{ textAlign: "right" }}>Total Hak Gross</th>
              <th style={{ textAlign: "right", color: "#f59e0b" }}>Biaya Layanan Trx (Rp 500)</th>
              <th style={{ textAlign: "right", color: "#ef4444" }}>Biaya Pencairan (Rp 1.000)</th>
              <th style={{ textAlign: "right", fontWeight: "900", color: "#38bdf8" }}>Total Net Pencairan</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => (
              <tr key={r.no || i} style={{ borderBottom: "1px solid var(--border-subtle)" }}>
                <td>{r.no}</td>
                <td style={{ fontWeight: "700" }}>{r.nama_penjual_driver}</td>
                <td>
                  <span className="badge badge-info">{r.bank_tujuan}</span>
                </td>
                <td style={{ textAlign: "right" }}>{fmt(r.total_hak_penjual_gross)}</td>
                <td style={{ textAlign: "right", color: "#f59e0b" }}>{fmt(r.biaya_layanan_trx)}</td>
                <td style={{ textAlign: "right", color: "#ef4444" }}>{fmt(r.biaya_pencairan)}</td>
                <td style={{ textAlign: "right", fontWeight: "800", color: "#38bdf8" }}>{fmt(r.total_net_pencairan)}</td>
              </tr>
            ))}
          </tbody>
          <tfoot>
            <tr style={{ background: "rgba(37, 99, 235, 0.15)", fontWeight: "900", borderTop: "2px solid #2563eb" }}>
              <td colSpan={3} style={{ textAlign: "center" }}>TOTAL NET PENCAIRAN EXCEL (BARIS 73)</td>
              <td style={{ textAlign: "right" }}>{fmt(summary.total_hak_gross)}</td>
              <td style={{ textAlign: "right", color: "#f59e0b" }}>{fmt(summary.total_biaya_layanan_trx)}</td>
              <td style={{ textAlign: "right", color: "#ef4444" }}>{fmt(summary.total_biaya_pencairan)}</td>
              <td style={{ textAlign: "right", color: "#38bdf8" }}>{fmt(summary.total_net_pencairan)}</td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  );
}

// -------------------------------------------------------------
// SHEET 6: REKAPITULASI PENCAIRAN PER BANK (7 KOLOM)
// -------------------------------------------------------------
function renderSheet6(data, search, fmt) {
  if (!data) return null;
  const rows = (data.disbursements || []).filter((r) => {
    if (!search) return true;
    const q = search.toLowerCase();
    return r.nama_bank_superadmin && r.nama_bank_superadmin.toLowerCase().includes(q);
  });
  const summary = data.totalSummary || {};

  return (
    <div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: "14px", marginBottom: "20px" }}>
        <div className="stat-card">
          <div className="stat-label">Total Bank Terdaftar</div>
          <div className="stat-value">12 Bank</div>
          <div className="stat-sub">9 Bank Aktif + 3 Bank Cadangan</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Penerima Mitra</div>
          <div className="stat-value" style={{ color: "#38bdf8" }}>68 Mitra</div>
          <div className="stat-sub">Terdistribusi di 9 Bank Aktif</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Net Disbursed Seluruh Bank</div>
          <div className="stat-value" style={{ color: "#10b981" }}>{fmt(summary.total_net_disbursement || 30211550)}</div>
          <div className="stat-sub">Kliring Batch Superadmin</div>
        </div>
      </div>

      <div className="table-wrapper" style={{ overflowX: "auto", maxHeight: "650px" }}>
        <table style={{ minWidth: "1050px", fontSize: "12px" }}>
          <thead>
            <tr style={{ background: "var(--bg-card-header)", borderBottom: "2px solid var(--border-subtle)" }}>
              <th style={{ width: "50px" }}>No</th>
              <th>Nama Bank Superadmin</th>
              <th style={{ width: "150px", textAlign: "center" }}>Jumlah Mitra / Penjual</th>
              <th style={{ textAlign: "right" }}>Total Pencairan Gross</th>
              <th style={{ textAlign: "right", color: "#f59e0b" }}>Total Biaya Layanan Trx</th>
              <th style={{ textAlign: "right", color: "#ef4444" }}>Total Biaya Pencairan</th>
              <th style={{ textAlign: "right", fontWeight: "900", color: "#10b981" }}>Net Inflow / Disbursement</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => (
              <tr key={r.no || i} style={{ borderBottom: "1px solid var(--border-subtle)" }}>
                <td>{r.no}</td>
                <td style={{ fontWeight: "700" }}>
                  Bank {r.nama_bank_superadmin}{" "}
                  {r.jumlah_mitra_penjual === 0 && <span style={{ fontSize: "10.5px", color: "var(--text-muted)" }}>(Cadangan)</span>}
                </td>
                <td style={{ textAlign: "center", fontWeight: "800" }}>{r.jumlah_mitra_penjual}</td>
                <td style={{ textAlign: "right" }}>{fmt(r.total_pencairan_gross)}</td>
                <td style={{ textAlign: "right", color: "#f59e0b" }}>{fmt(r.total_biaya_layanan_trx)}</td>
                <td style={{ textAlign: "right", color: "#ef4444" }}>{fmt(r.total_biaya_pencairan)}</td>
                <td style={{ textAlign: "right", fontWeight: "800", color: "#10b981" }}>{fmt(r.net_inflow_disbursement)}</td>
              </tr>
            ))}
          </tbody>
          <tfoot>
            <tr style={{ background: "rgba(37, 99, 235, 0.15)", fontWeight: "900", borderTop: "2px solid #2563eb" }}>
              <td colSpan={2} style={{ textAlign: "center" }}>TOTAL REKAPITULASI BANK (BARIS 17)</td>
              <td style={{ textAlign: "center" }}>{summary.total_mitra || 68}</td>
              <td style={{ textAlign: "right" }}>{fmt(summary.total_pencairan_gross)}</td>
              <td style={{ textAlign: "right", color: "#f59e0b" }}>{fmt(summary.total_biaya_layanan_trx)}</td>
              <td style={{ textAlign: "right", color: "#ef4444" }}>{fmt(summary.total_biaya_pencairan)}</td>
              <td style={{ textAlign: "right", color: "#10b981" }}>{fmt(summary.total_net_disbursement)}</td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  );
}

// -------------------------------------------------------------
// SHEET 7: BAGI HASIL PUSAT & DAERAH (8 KOLOM)
// -------------------------------------------------------------
function renderSheet7(data, search, fmt) {
  if (!data) return null;
  const rawRows = data.profitSharing || data.rows || [];
  const rows = rawRows.filter((r) => {
    if (!search) return true;
    const q = search.toLowerCase();
    const kab = (r.wilayah_kab_kota || r.wilayahKabKota || '').toLowerCase();
    const prov = (r.provinsi || '').toLowerCase();
    const status = (r.status_skema_kerjasama || r.statusSkemaKerjasama || '').toLowerCase();
    return kab.includes(q) || prov.includes(q) || status.includes(q);
  });
  const summary = data.totalSummary || data.total || {};

  const getSchemeBadge = (scheme) => {
    if ((scheme || '').includes('75%:25%')) return 'badge-info';
    if ((scheme || '').includes('100%:0%')) return 'badge-success';
    if ((scheme || '').includes('20%:80%')) return 'badge-warning';
    return 'badge-purple';
  };

  return (
    <div>
      {/* 4 KPI SUMMARY CARDS */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: "14px", marginBottom: "20px" }}>
        <div className="stat-card">
          <div className="stat-label">Total Wilayah Kab / Kota</div>
          <div className="stat-value">{summary.totalWilayah || 29}</div>
          <div className="stat-sub">29 Cabang Regional Aktif</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Net Profit Superadmin</div>
          <div className="stat-value" style={{ color: "#38bdf8" }}>{fmt(summary.totalNetProfitSuperadmin || 4354766)}</div>
          <div className="stat-sub">Formula: SUMIF Sheet 1 Kolom U</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Porsi Pusat (87.75%)</div>
          <div className="stat-value" style={{ color: "#10b981" }}>{fmt(summary.totalPorsiPusat || 3821480.45)}</div>
          <div className="stat-sub">Pusat 75% • Tanpa Kerjasama 100%</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Porsi Admin Daerah (12.25%)</div>
          <div className="stat-value" style={{ color: "#f59e0b" }}>{fmt(summary.totalPorsiAdminDaerah || 533285.55)}</div>
          <div className="stat-sub">Hak Bagi Hasil Admin Cabang Lokal</div>
        </div>
      </div>

      {/* DATA TABLE (8 KOLOM SESUAI EXCEL SHEET 7) */}
      <div className="table-wrapper" style={{ overflowX: "auto", maxHeight: "650px" }}>
        <table style={{ minWidth: "1200px", fontSize: "12px" }}>
          <thead>
            <tr style={{ background: "var(--bg-card-header)", borderBottom: "2px solid var(--border-subtle)" }}>
              <th style={{ width: "50px" }}>No</th>
              <th>Wilayah Kab / Kota</th>
              <th style={{ width: "130px" }}>Provinsi</th>
              <th style={{ width: "240px" }}>Status Skema Kerjasama</th>
              <th style={{ textAlign: "right" }}>Net Profit Superadmin</th>
              <th style={{ textAlign: "right", color: "#10b981", fontWeight: "800" }}>Porsi Pusat (Rp)</th>
              <th style={{ textAlign: "right", color: "#f59e0b", fontWeight: "800" }}>Porsi Admin Daerah (Rp)</th>
              <th style={{ width: "150px" }}>Jadwal Pembayaran</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => {
              const kab = r.wilayah_kab_kota || r.wilayahKabKota;
              const status = r.status_skema_kerjasama || r.statusSkemaKerjasama;
              const netProfit = r.net_profit_superadmin ?? r.netProfitSuperadmin ?? 0;
              const porsiPusat = r.porsi_pusat ?? r.porsiPusat ?? 0;
              const porsiDaerah = r.porsi_admin_daerah ?? r.porsiAdminDaerah ?? 0;
              const jadwal = r.jadwal_pembayaran || r.jadwalPembayaran || "Tgl 1 Awal Bulan";

              return (
                <tr key={r.no || i} style={{ borderBottom: "1px solid var(--border-subtle)" }}>
                  <td>{r.no}</td>
                  <td style={{ fontWeight: "700" }}>{kab}</td>
                  <td>{r.provinsi}</td>
                  <td>
                    <span className={`badge ${getSchemeBadge(status)}`}>
                      {status}
                    </span>
                  </td>
                  <td style={{ textAlign: "right", fontWeight: "700" }}>{fmt(netProfit)}</td>
                  <td style={{ textAlign: "right", fontWeight: "800", color: "#10b981" }}>{fmt(porsiPusat)}</td>
                  <td style={{ textAlign: "right", fontWeight: "800", color: (porsiDaerah > 0 ? "#f59e0b" : "var(--text-muted)") }}>
                    {porsiDaerah > 0 ? fmt(porsiDaerah) : "Rp 0"}
                  </td>
                  <td>
                    <span style={{ fontSize: "11px", fontWeight: "700", color: "var(--text-muted)" }}>
                      📅 {jadwal}
                    </span>
                  </td>
                </tr>
              );
            })}
          </tbody>
          <tfoot>
            <tr style={{ background: "rgba(37, 99, 235, 0.15)", fontWeight: "900", borderTop: "2px solid #2563eb" }}>
              <td colSpan={2} style={{ textAlign: "center" }}>TOTAL REKAPITULASI BAGI HASIL (BARIS 34)</td>
              <td>-</td>
              <td>{summary.totalWilayah || summary.total_wilayah || 29} Wilayah</td>
              <td style={{ textAlign: "right", color: "#38bdf8" }}>{fmt(summary.totalNetProfitSuperadmin || summary.total_net_profit_superadmin || 4354766)}</td>
              <td style={{ textAlign: "right", color: "#10b981" }}>{fmt(summary.totalPorsiPusat || summary.total_porsi_pusat || 3821480.45)}</td>
              <td style={{ textAlign: "right", color: "#f59e0b" }}>{fmt(summary.totalPorsiAdminDaerah || summary.total_porsi_admin_daerah || 533285.55)}</td>
              <td>Tgl 1 Awal Bulan</td>
            </tr>
          </tfoot>
        </table>
      </div>

      {/* MASTER REGULASI SKEMA KONTRAK REFERENCE (BARIS 38-43 EXCEL) */}
      <div style={{ marginTop: "24px", background: "var(--bg-card)", padding: "18px", borderRadius: "14px", border: "1px solid var(--border-subtle)" }}>
        <div style={{ fontSize: "13px", fontWeight: "800", color: "#38bdf8", marginBottom: "12px", display: "flex", alignItems: "center", gap: "8px" }}>
          <span>📜</span> Master Regulasi Skema Kerjasama Pusat & Daerah (Baris 38-43 Excel Sheet 7)
        </div>
        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(280px, 1fr))", gap: "12px" }}>
          <div style={{ padding: "12px", borderRadius: "10px", background: "rgba(37, 99, 235, 0.08)", border: "1px solid rgba(37, 99, 235, 0.25)" }}>
            <div style={{ fontWeight: "800", color: "#60a5fa", fontSize: "12px" }}>1. Kerjasama Pusat & Daerah (75%:25%)</div>
            <div style={{ fontSize: "11px", color: "var(--text-muted)", marginTop: "3px" }}>Cabang daerah berlisensi resmi. Pembagian Net Profit Superadmin 75% Pusat : 25% Admin Daerah.</div>
          </div>
          <div style={{ padding: "12px", borderRadius: "10px", background: "rgba(16, 185, 129, 0.08)", border: "1px solid rgba(16, 185, 129, 0.25)" }}>
            <div style={{ fontWeight: "800", color: "#34d399", fontSize: "12px" }}>2. Tanpa Kerjasama (100%:0%)</div>
            <div style={{ fontSize: "11px", color: "var(--text-muted)", marginTop: "3px" }}>Wilayah operasional langsung Superadmin Pusat tanpa cabang lokal. Hak Pusat 100%.</div>
          </div>
          <div style={{ padding: "12px", borderRadius: "10px", background: "rgba(245, 158, 11, 0.08)", border: "1px solid rgba(245, 158, 11, 0.25)" }}>
            <div style={{ fontWeight: "800", color: "#fbbf24", fontSize: "12px" }}>3. Event Mandiri Daerah (20%:80%)</div>
            <div style={{ fontSize: "11px", color: "var(--text-muted)", marginTop: "3px" }}>Event lomba atau inisiasi mandiri daerah (contoh: Kab. Subang). Pembagian 20% Pusat : 80% Daerah.</div>
          </div>
          <div style={{ padding: "12px", borderRadius: "10px", background: "rgba(147, 51, 234, 0.08)", border: "1px solid rgba(147, 51, 234, 0.25)" }}>
            <div style={{ fontWeight: "800", color: "#c084fc", fontSize: "12px" }}>4. Evoting Populer Pusat & Daerah (60%:40%)</div>
            <div style={{ fontSize: "11px", color: "var(--text-muted)", marginTop: "3px" }}>Polling berbayar atau voting kolaborasi Pusat dan Daerah. Pusat 60% : Daerah 40%.</div>
          </div>
          <div style={{ padding: "12px", borderRadius: "10px", background: "rgba(13, 148, 136, 0.08)", border: "1px solid rgba(13, 148, 136, 0.25)" }}>
            <div style={{ fontWeight: "800", color: "#2dd4bf", fontSize: "12px" }}>5. Evoting Populer Mandiri Pusat (100%:0%)</div>
            <div style={{ fontSize: "11px", color: "var(--text-muted)", marginTop: "3px" }}>Voting nasional inisiasi langsung Pusat. Hak Pusat 100%.</div>
          </div>
        </div>
      </div>
    </div>
  );
}


// -------------------------------------------------------------
// SHEET 8: PROFIL LISENSI DAERAH (11 KOLOM)
// -------------------------------------------------------------
function renderSheet8(data, search, fmt) {
  if (!data) return null;
  const rawRows = data.licenses || data.rows || [];
  const rows = rawRows.filter((r) => {
    if (!search) return true;
    const q = search.toLowerCase();
    const nama = (r.nama_pembeli_lisensi || r.namaPembeliLisensi || "").toLowerCase();
    const kab = (r.kabupaten_kota || r.kabupatenKota || "").toLowerCase();
    const bank = (r.rekening_bank_aktif || r.rekeningBankAktif || "").toLowerCase();
    const pemilik = (r.nama_pemilik_rekening || r.namaPemilikRekening || "").toLowerCase();
    return nama.includes(q) || kab.includes(q) || bank.includes(q) || pemilik.includes(q);
  });
  const summary = data.totalSummary || data.total || {};

  const getBankBadgeStyle = (bank) => {
    const b = (bank || "").toUpperCase();
    if (b.includes("BCA")) return { bg: "rgba(0, 102, 204, 0.15)", color: "#38bdf8", border: "#0284c7" };
    if (b.includes("MANDIRI")) return { bg: "rgba(0, 51, 102, 0.2)", color: "#60a5fa", border: "#2563eb" };
    if (b.includes("BRI")) return { bg: "rgba(0, 82, 156, 0.2)", color: "#93c5fd", border: "#3b82f6" };
    if (b.includes("BNI")) return { bg: "rgba(241, 90, 36, 0.15)", color: "#fb923c", border: "#ea580c" };
    if (b.includes("BSI")) return { bg: "rgba(0, 163, 157, 0.15)", color: "#2dd4bf", border: "#0d9488" };
    if (b.includes("JATENG")) return { bg: "rgba(220, 38, 38, 0.15)", color: "#f87171", border: "#dc2626" };
    if (b.includes("JATIM")) return { bg: "rgba(22, 163, 74, 0.15)", color: "#4ade80", border: "#16a34a" };
    if (b.includes("DKI")) return { bg: "rgba(234, 88, 12, 0.15)", color: "#fdba74", border: "#c2410c" };
    if (b.includes("BJB")) return { bg: "rgba(37, 99, 235, 0.15)", color: "#818cf8", border: "#4f46e5" };
    return { bg: "rgba(100, 116, 139, 0.15)", color: "#cbd5e1", border: "#64748b" };
  };

  return (
    <div>
      {/* 4 KPI SUMMARY CARDS */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: "14px", marginBottom: "20px" }}>
        <div className="stat-card">
          <div className="stat-label">Pemegang Lisensi Resmi</div>
          <div className="stat-value" style={{ color: "#38bdf8" }}>{summary.totalLisensi || 12} Kab/Kota</div>
          <div className="stat-sub">12 Wilayah Lisensi Aktif</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Penjual / Toko Binaan</div>
          <div className="stat-value" style={{ color: "#10b981" }}>{summary.totalPenjualAktif || 261} Toko</div>
          <div className="stat-sub">Tersebar di 12 Wilayah Cabang</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Armada Driver Aktif</div>
          <div className="stat-value" style={{ color: "#f59e0b" }}>{summary.totalDriverAktif || 346} Driver</div>
          <div className="stat-sub">Driver Lokal Binaan Daerah</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Total Event Daerah</div>
          <div className="stat-value" style={{ color: "#a855f7" }}>{summary.totalSemuaEvent || 101} Event</div>
          <div className="stat-sub">46 Bispira • 29 Kompetisi • 26 E-Voting</div>
        </div>
      </div>

      {/* DATA TABLE (11 KOLOM SESUAI EXCEL SHEET 8) */}
      <div className="table-wrapper" style={{ overflowX: "auto", maxHeight: "650px" }}>
        <table style={{ minWidth: "1250px", fontSize: "12px" }}>
          <thead>
            <tr style={{ background: "var(--bg-card-header)", borderBottom: "2px solid var(--border-subtle)" }}>
              <th style={{ width: "45px" }}>No</th>
              <th>Nama Pembeli Lisensi</th>
              <th>Kabupaten / Kota</th>
              <th style={{ width: "100px" }}>No WA</th>
              <th style={{ width: "130px" }}>Rekening Bank</th>
              <th>Nama Pemilik Rekening</th>
              <th style={{ textAlign: "center", color: "#10b981", fontWeight: "800" }}>Penjual Aktif</th>
              <th style={{ textAlign: "center", color: "#f59e0b", fontWeight: "800" }}>Driver Aktif</th>
              <th style={{ textAlign: "center", color: "#38bdf8" }}>Event Bispira</th>
              <th style={{ textAlign: "center", color: "#ec4899" }}>Kompetisi</th>
              <th style={{ textAlign: "center", color: "#a855f7" }}>E-Voting</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => {
              const bankName = r.rekening_bank_aktif || r.rekeningBankAktif || "-";
              const bStyle = getBankBadgeStyle(bankName);
              const namaPembeli = r.nama_pembeli_lisensi || r.namaPembeliLisensi || "-";
              const kabKota = r.kabupaten_kota || r.kabupatenKota || "-";
              const noWa = r.no_wa_telepon || r.noWaTelepon || "6221";
              const namaPemilik = r.nama_pemilik_rekening || r.namaPemilikRekening || "-";
              const penjual = r.jumlah_penjual_aktif ?? r.jumlahPenjualAktif ?? 0;
              const driver = r.jumlah_driver_aktif ?? r.jumlahDriverAktif ?? 0;
              const eventBispira = r.jumlah_event_bispira ?? r.jumlahEventBispira ?? 0;
              const kompetisi = r.jumlah_event_kompetisi ?? r.jumlahEventKompetisi ?? 0;
              const evoting = r.jumlah_event_evoting ?? r.jumlahEventEvoting ?? 0;

              return (
                <tr key={r.no || i} style={{ borderBottom: "1px solid var(--border-subtle)" }}>
                  <td>{r.no}</td>
                  <td style={{ fontWeight: "700" }}>{namaPembeli}</td>
                  <td style={{ fontWeight: "600", color: "#38bdf8" }}>{kabKota}</td>
                  <td>
                    <span style={{ fontFamily: "monospace", fontSize: "11px", color: "var(--text-muted)" }}>
                      {noWa}
                    </span>
                  </td>
                  <td>
                    <span
                      style={{
                        padding: "3px 8px",
                        borderRadius: "6px",
                        fontSize: "11px",
                        fontWeight: "700",
                        background: bStyle.bg,
                        color: bStyle.color,
                        border: `1px solid ${bStyle.border}`,
                      }}
                    >
                      {bankName}
                    </span>
                  </td>
                  <td>{namaPemilik}</td>
                  <td style={{ textAlign: "center", fontWeight: "800", color: "#10b981" }}>
                    {penjual}
                  </td>
                  <td style={{ textAlign: "center", fontWeight: "800", color: "#f59e0b" }}>
                    {driver}
                  </td>
                  <td style={{ textAlign: "center", fontWeight: "700", color: "#38bdf8" }}>
                    {eventBispira}
                  </td>
                  <td style={{ textAlign: "center", fontWeight: "700", color: "#ec4899" }}>
                    {kompetisi}
                  </td>
                  <td style={{ textAlign: "center", fontWeight: "700", color: "#a855f7" }}>
                    {evoting}
                  </td>
                </tr>
              );
            })}
          </tbody>
          <tfoot>
            <tr style={{ background: "rgba(37, 99, 235, 0.15)", fontWeight: "900", borderTop: "2px solid #2563eb" }}>
              <td colSpan={3} style={{ textAlign: "center" }}>TOTAL REKAPITULASI (BARIS 17 EXCEL SHEET 8)</td>
              <td>-</td>
              <td>12 Akun Bank</td>
              <td>12 Pemilik</td>
              <td style={{ textAlign: "center", color: "#10b981" }}>{summary.totalPenjualAktif || summary.total_penjual_aktif || 261}</td>
              <td style={{ textAlign: "center", color: "#f59e0b" }}>{summary.totalDriverAktif || summary.total_driver_aktif || 346}</td>
              <td style={{ textAlign: "center", color: "#38bdf8" }}>{summary.totalEventBispira || summary.total_event_bispira || 46}</td>
              <td style={{ textAlign: "center", color: "#ec4899" }}>{summary.totalEventKompetisi || summary.total_event_kompetisi || 29}</td>
              <td style={{ textAlign: "center", color: "#a855f7" }}>{summary.totalEventEvoting || summary.total_event_evoting || 26}</td>
            </tr>
          </tfoot>
        </table>
      </div>

      {/* INFORMASI KEBIJAKAN LISENSI DAERAH */}
      <div style={{ marginTop: "24px", background: "var(--bg-card)", padding: "18px", borderRadius: "14px", border: "1px solid var(--border-subtle)" }}>
        <div style={{ fontSize: "13px", fontWeight: "800", color: "#38bdf8", marginBottom: "12px", display: "flex", alignItems: "center", gap: "8px" }}>
          <span>🏢</span> Hak & Wewenang Pemegang Lisensi Resmi Kabupaten/Kota
        </div>
        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(280px, 1fr))", gap: "12px" }}>
          <div style={{ padding: "12px", borderRadius: "10px", background: "rgba(16, 185, 129, 0.08)", border: "1px solid rgba(16, 185, 129, 0.25)" }}>
            <div style={{ fontWeight: "800", color: "#34d399", fontSize: "12px" }}>Bagi Hasil Tetap 25% (atau 80% Event)</div>
            <div style={{ fontSize: "11px", color: "var(--text-muted)", marginTop: "3px" }}>Disalurkan langsung ke rekening perbankan aktif setiap tanggal 1 awal bulan sesuai rekap Sheet 7.</div>
          </div>
          <div style={{ padding: "12px", borderRadius: "10px", background: "rgba(37, 99, 235, 0.08)", border: "1px solid rgba(37, 99, 235, 0.25)" }}>
            <div style={{ fontWeight: "800", color: "#60a5fa", fontSize: "12px" }}>Pengelolaan Mitra Lokal</div>
            <div style={{ fontSize: "11px", color: "var(--text-muted)", marginTop: "3px" }}>Mengelola penjual & driver di wilayah kabupaten/kota masing-masing dengan pembinaan komprehensif.</div>
          </div>
          <div style={{ padding: "12px", borderRadius: "10px", background: "rgba(245, 158, 11, 0.08)", border: "1px solid rgba(245, 158, 11, 0.25)" }}>
            <div style={{ fontWeight: "800", color: "#fbbf24", fontSize: "12px" }}>Otorisasi Event & E-Voting Mandiri</div>
            <div style={{ fontSize: "11px", color: "var(--text-muted)", marginTop: "3px" }}>Berhak menyelenggarakan kompetisi, event expo Bispira, dan voting berbayar dengan porsi pendapatan 80%.</div>
          </div>
        </div>
      </div>
    </div>
  );
}

// -------------------------------------------------------------
// SHEET 9: PENGATURAN TARIF & FEES REVISI (5 PARAMETER ARMADA)
// -------------------------------------------------------------
function renderSheet9(data, search, fmt) {
  if (!data) return null;
  const rideHailing = data.ride_hailing || [];
  const merchant = data.merchant_settings || {};
  const fees = data.consumer_and_ecosystem_fees || {};
  const sharing = data.regional_branch_profit_sharing || {};

  return (
    <div>
      {/* 4 KPI SUMMARY CARDS */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: "14px", marginBottom: "20px" }}>
        <div className="stat-card">
          <div className="stat-label">Biaya Aplikasi Konsumen</div>
          <div className="stat-value" style={{ color: "#38bdf8" }}>{fmt(fees.biaya_aplikasi_konsumen || 500)}</div>
          <div className="stat-sub">Flat per transaksi (Kolom N Sheet 1)</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Biaya Layanan Platform</div>
          <div className="stat-value" style={{ color: "#10b981" }}>{fmt(fees.biaya_layanan_platform || 500)}</div>
          <div className="stat-sub">Flat per transaksi (Kolom N Sheet 1)</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Markup Konsumen Resmi</div>
          <div className="stat-value" style={{ color: "#f59e0b" }}>{merchant.markup_persen || 10}%</div>
          <div className="stat-sub">Harga Dasar × 1.10 (Kolom L Sheet 1)</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Biaya Pencairan (Payout)</div>
          <div className="stat-value" style={{ color: "#ec4899" }}>{fmt(fees.biaya_pencairan_payout_fee || 1000)}</div>
          <div className="stat-sub">Per transfer pencairan mitra (Sheet 5)</div>
        </div>
      </div>

      {/* TABEL PARAMETER PERJALANAN & RIDE HAILING (SHEET 9 SECTION A) */}
      <div className="table-wrapper" style={{ overflowX: "auto", marginBottom: "24px" }}>
        <div style={{ padding: "14px 18px", background: "var(--bg-card-header)", borderBottom: "1px solid var(--border-subtle)", fontWeight: "800", fontSize: "13px", color: "#38bdf8" }}>
          🚗 Parameter Perjalanan, Logistik & Ride Hailing (Section A Excel Sheet 9)
        </div>
        <table style={{ minWidth: "1100px", fontSize: "12px" }}>
          <thead>
            <tr style={{ background: "rgba(255,255,255,0.02)", borderBottom: "2px solid var(--border-subtle)" }}>
              <th>Layanan Armada</th>
              <th style={{ textAlign: "right" }}>Tarif Dasar</th>
              <th style={{ textAlign: "right" }}>Minimum Order</th>
              <th style={{ width: "220px" }}>Regulasi Wilayah / Zona</th>
              <th style={{ textAlign: "center", color: "#10b981" }}>Hak Driver</th>
              <th style={{ textAlign: "center", color: "#38bdf8" }}>Komisi Platform</th>
              <th style={{ textAlign: "center" }}>Charge Reguler</th>
              <th style={{ textAlign: "center", color: "#a855f7" }}>Charge Premium 30 Hari</th>
            </tr>
          </thead>
          <tbody>
            {rideHailing.map((rh, idx) => (
              <tr key={rh.id || idx} style={{ borderBottom: "1px solid var(--border-subtle)" }}>
                <td style={{ fontWeight: "700" }}>{rh.name}</td>
                <td style={{ textAlign: "right", fontWeight: "800", color: "#38bdf8" }}>
                  {rh.tarif_per_km ? `${fmt(rh.tarif_per_km)} / KM` : `${fmt(rh.biaya_antar_dasar)} dasar`}
                </td>
                <td style={{ textAlign: "right", fontWeight: "700" }}>
                  {fmt(rh.biaya_min_perjalanan_3km || rh.biaya_min_perjalanan_4km || rh.biaya_min_perjalanan_5km)}
                </td>
                <td style={{ fontSize: "11px", color: "var(--text-muted)" }}>
                  {rh.wilayah_i_tarif ? (
                    <div>
                      <div>• {rh.wilayah_i_tarif}</div>
                      <div>• {rh.wilayah_ii_tarif}</div>
                    </div>
                  ) : (
                    <span>Tarif Seragam Nasional</span>
                  )}
                </td>
                <td style={{ textAlign: "center", fontWeight: "800", color: "#10b981" }}>
                  {rh.driver_share_percent}% Ongkir
                </td>
                <td style={{ textAlign: "center", fontWeight: "800", color: "#38bdf8" }}>
                  {rh.platform_commission_percent}%
                </td>
                <td style={{ textAlign: "center", fontWeight: "700" }}>
                  {fmt(rh.charge_driver_reguler)} / order
                </td>
                <td style={{ textAlign: "center", fontWeight: "800", color: "#a855f7" }}>
                  {fmt(rh.charge_driver_premium_30hari)}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* INFORMASI KEBIJAKAN MERCHANT & KODE UNIK (SECTIONS B, C, D) */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(320px, 1fr))", gap: "16px" }}>
        <div style={{ background: "var(--bg-card)", padding: "18px", borderRadius: "14px", border: "1px solid var(--border-subtle)" }}>
          <div style={{ fontWeight: "800", fontSize: "13px", color: "#10b981", marginBottom: "10px" }}>
            🏪 Merchant & Toko (Section B Excel Sheet 9)
          </div>
          <div style={{ fontSize: "12px", lineHeight: "1.7", color: "var(--text-muted)" }}>
            <div>• <strong>Markup Konsumen:</strong> {merchant.markup_persen || 10}% dari harga dasar toko</div>
            <div>• <strong>Komisi Penjualan:</strong> {merchant.komisi_penjualan_persen || 5}% (Hak Bersih Toko 95%)</div>
            <div>• <strong>Biaya Transaksi Reguler:</strong> {fmt(merchant.charge_merchant_reguler || 500)} / order</div>
            <div>• <strong>Opsi Akun Premium:</strong> {fmt(merchant.charge_merchant_premium_30hari || 15000)} / 30 hari</div>
          </div>
        </div>

        <div style={{ background: "var(--bg-card)", padding: "18px", borderRadius: "14px", border: "1px solid var(--border-subtle)" }}>
          <div style={{ fontWeight: "800", fontSize: "13px", color: "#f59e0b", marginBottom: "10px" }}>
            🔑 Kode Unik & Verifikasi (Section C Excel Sheet 9)
          </div>
          <div style={{ fontSize: "12px", lineHeight: "1.7", color: "var(--text-muted)" }}>
            <div>• <strong>Rentang Kode Unik:</strong> {fees.nominal_kode_unik || "000-999"}</div>
            <div>• <strong>Masa Berlaku:</strong> {fees.masa_berlaku_kode_unik_menit || 30} Menit</div>
            <div>• <strong>Payout Fee:</strong> {fmt(fees.biaya_pencairan_payout_fee || 1000)} per batch penarikan</div>
            <div>• <strong>Threshold Top Up Driver:</strong> Minimal Rp 50.000</div>
          </div>
        </div>

        <div style={{ background: "var(--bg-card)", padding: "18px", borderRadius: "14px", border: "1px solid var(--border-subtle)" }}>
          <div style={{ fontWeight: "800", fontSize: "13px", color: "#38bdf8", marginBottom: "10px" }}>
            🤝 Bagi Hasil Lisensi Cabang (Section D Excel Sheet 9)
          </div>
          <div style={{ fontSize: "12px", lineHeight: "1.7", color: "var(--text-muted)" }}>
            <div>• <strong>Kerjasama Standar:</strong> {sharing.profit_share_pusat_persen || 75}% Pusat : {sharing.profit_share_cabang_wilayah_persen || 25}% Daerah</div>
            <div>• <strong>Event Mandiri Daerah:</strong> {sharing.event_mandiri_pusat_persen || 20}% Pusat : {sharing.event_mandiri_cabang_wilayah_persen || 80}% Daerah</div>
            <div>• <strong>Event Nasional Pusat:</strong> {sharing.event_nasional_pusat_persen || 90}% Pusat : {sharing.event_nasional_cabang_persen || 10}% Daerah</div>
            <div>• <strong>Jadwal Pembayaran:</strong> {sharing.jadwal_pembayaran || "Tgl 1 Awal Bulan"}</div>
          </div>
        </div>
      </div>
    </div>
  );
}

// -------------------------------------------------------------
// SHEET 10 & 11: KATALOG EKOSISTEM (12 CLUSTER PRODUK)
// -------------------------------------------------------------
function renderSheet10(data, search) {
  if (!data) return null;
  const clusters = (data.clusters || []).filter((c) => {
    if (!search) return true;
    const q = search.toLowerCase();
    const matchName = c.cluster_name && c.cluster_name.toLowerCase().includes(q);
    const matchFE = (c.frontend_items || []).some((item) => item.toLowerCase().includes(q));
    const matchBE = (c.backend_items || []).some((item) => item.toLowerCase().includes(q));
    return matchName || matchFE || matchBE;
  });

  return (
    <div>
      <div style={{ marginBottom: "16px", padding: "14px 18px", background: "rgba(37, 99, 235, 0.1)", borderRadius: "12px", border: "1px solid rgba(37, 99, 235, 0.25)" }}>
        <div style={{ fontWeight: "800", color: "#60a5fa", fontSize: "13px" }}>
          📦 Katalog Sebaran Produk Induk dan Anak Hyperlocal Bispira (Sheet 10 & 11)
        </div>
        <div style={{ fontSize: "11.5px", color: "var(--text-muted)", marginTop: "4px" }}>
          Memetakan 12 kategori cluster layanan: integrasi tampilan <strong>Front End Pembeli (Sheet 11)</strong> dan otorisasi <strong>Back End Penjual & Merchant (Sheet 10)</strong>.
        </div>
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(360px, 1fr))", gap: "16px" }}>
        {clusters.map((c) => (
          <div key={c.cluster_no} style={{ background: "var(--bg-card)", padding: "18px", borderRadius: "14px", border: "1px solid var(--border-subtle)" }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "12px" }}>
              <div style={{ fontWeight: "800", fontSize: "13.5px", color: "#38bdf8" }}>
                {c.cluster_no}. {c.cluster_name}
              </div>
              <span className="badge badge-info">{c.frontend_items.length} Layanan</span>
            </div>

            {/* FRONT END ITEMS */}
            <div style={{ marginBottom: "12px" }}>
              <div style={{ fontSize: "11px", fontWeight: "700", color: "#10b981", textTransform: "uppercase", marginBottom: "6px" }}>
                📱 Front End Pembeli (Sheet 11):
              </div>
              <div style={{ display: "flex", flexWrap: "wrap", gap: "6px" }}>
                {(c.frontend_items || []).map((fi, i) => (
                  <span
                    key={i}
                    style={{
                      fontSize: "11px",
                      padding: "3px 8px",
                      borderRadius: "6px",
                      background: "rgba(16, 185, 129, 0.12)",
                      color: "#34d399",
                      border: "1px solid rgba(16, 185, 129, 0.25)",
                    }}
                  >
                    {fi}
                  </span>
                ))}
              </div>
            </div>

            {/* BACK END ITEMS */}
            <div>
              <div style={{ fontSize: "11px", fontWeight: "700", color: "#f59e0b", textTransform: "uppercase", marginBottom: "6px" }}>
                ⚙️ Back End Penjual & Merchant (Sheet 10):
              </div>
              <div style={{ display: "flex", flexWrap: "wrap", gap: "6px" }}>
                {(c.backend_items || []).map((bi, i) => (
                  <span
                    key={i}
                    style={{
                      fontSize: "11px",
                      padding: "3px 8px",
                      borderRadius: "6px",
                      background: "rgba(245, 158, 11, 0.12)",
                      color: "#fbbf24",
                      border: "1px solid rgba(245, 158, 11, 0.25)",
                    }}
                  >
                    {bi}
                  </span>
                ))}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

// -------------------------------------------------------------
// SHEET 12: MATRIKS PENDAPATAN SUPERADMIN & BAGI HASIL
// -------------------------------------------------------------
function renderSheet12(data, search, fmt) {
  if (!data) return null;
  const matrix = (data.matrix || []).filter((m) => {
    if (!search) return true;
    const q = search.toLowerCase();
    return (
      (m.bidang_cluster && m.bidang_cluster.toLowerCase().includes(q)) ||
      (m.penjual && m.penjual.toLowerCase().includes(q))
    );
  });

  return (
    <div>
      <div style={{ marginBottom: "16px", padding: "14px 18px", background: "rgba(16, 185, 129, 0.1)", borderRadius: "12px", border: "1px solid rgba(16, 185, 129, 0.25)" }}>
        <div style={{ fontWeight: "800", color: "#34d399", fontSize: "13px" }}>
          📊 Pedoman Pendapatan Superadmin Per Transaksi & Peta Split Bagi Hasil (Sheet Pendapatan Superadmin)
        </div>
        <div style={{ fontSize: "11.5px", color: "var(--text-muted)", marginTop: "4px" }}>
          Pedoman 16 cluster pendapatan intermediasi: markup, biaya layanan, biaya aplikasi reguler/premium, kode unik bank, komisi, biaya pencairan, dan peta bagi hasil pusat & daerah (75:25, 100:0, 20:80, 60:40).
        </div>
      </div>

      <div className="table-wrapper" style={{ overflowX: "auto", maxHeight: "650px" }}>
        <table style={{ minWidth: "1350px", fontSize: "12px" }}>
          <thead>
            <tr style={{ background: "var(--bg-card-header)", borderBottom: "2px solid var(--border-subtle)" }}>
              <th style={{ width: "40px" }}>No</th>
              <th>Bidang Cluster</th>
              <th>Entitas Penjual</th>
              <th>Markup</th>
              <th style={{ textAlign: "right" }}>Biaya Layanan</th>
              <th style={{ textAlign: "right" }}>Aplikasi Reguler</th>
              <th style={{ textAlign: "right", color: "#a855f7" }}>Aplikasi Premium</th>
              <th style={{ textAlign: "center" }}>Komisi Platform</th>
              <th style={{ textAlign: "right" }}>Biaya Pencairan</th>
              <th style={{ textAlign: "center", color: "#10b981", fontWeight: "800" }}>Pusat (Kerjasama)</th>
              <th style={{ textAlign: "center", color: "#f59e0b", fontWeight: "800" }}>Daerah (Kerjasama)</th>
              <th style={{ textAlign: "center", color: "#38bdf8" }}>Split Event Mandiri</th>
            </tr>
          </thead>
          <tbody>
            {matrix.map((m, idx) => (
              <tr key={m.no || idx} style={{ borderBottom: "1px solid var(--border-subtle)" }}>
                <td>{m.no}</td>
                <td style={{ fontWeight: "700" }}>{m.bidang_cluster}</td>
                <td>
                  <span className="badge badge-info">{m.penjual || "Mitra Bispira"}</span>
                </td>
                <td style={{ fontWeight: "700", color: "#f59e0b" }}>
                  {typeof m.markup === "number" ? `${(m.markup * 100).toFixed(0)}%` : m.markup || "10%"}
                </td>
                <td style={{ textAlign: "right" }}>{m.biaya_layanan}</td>
                <td style={{ textAlign: "right" }}>{m.biaya_aplikasi_reguler}</td>
                <td style={{ textAlign: "right", fontWeight: "700", color: "#a855f7" }}>
                  {m.biaya_aplikasi_premium_30hari}
                </td>
                <td style={{ textAlign: "center", fontWeight: "800", color: "#38bdf8" }}>
                  {typeof m.komisi === "number" ? `${(m.komisi * 100).toFixed(1)}%` : m.komisi}
                </td>
                <td style={{ textAlign: "right" }}>{m.biaya_pencairan}</td>
                <td style={{ textAlign: "center", fontWeight: "800", color: "#10b981" }}>
                  {typeof m.bagi_hasil_kerjasama?.pusat === "number"
                    ? `${(m.bagi_hasil_kerjasama.pusat * 100).toFixed(0)}%`
                    : m.bagi_hasil_kerjasama?.pusat}
                </td>
                <td style={{ textAlign: "center", fontWeight: "800", color: "#f59e0b" }}>
                  {typeof m.bagi_hasil_kerjasama?.daerah === "number"
                    ? `${(m.bagi_hasil_kerjasama.daerah * 100).toFixed(0)}%`
                    : m.bagi_hasil_kerjasama?.daerah}
                </td>
                <td style={{ textAlign: "center", fontWeight: "700", color: "#38bdf8" }}>
                  {typeof m.bagi_hasil_event_mandiri?.pusat === "number"
                    ? `${(m.bagi_hasil_event_mandiri.pusat * 100).toFixed(0)}% : ${(m.bagi_hasil_event_mandiri.daerah * 100).toFixed(0)}%`
                    : "20% : 80%"}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

// -------------------------------------------------------------
// FORMULIR PENJUAL MASTER (22 SHEET FORMULIR PENDAFTARAN & INPUT PRODUK)
// -------------------------------------------------------------
function FormulirPenjualRenderer({ data, search }) {
  const [selectedSheet, setSelectedSheet] = React.useState('PENDAFTARAN MERCHANT');
  
  if (!data || !data.sheets) {
    return (
      <div style={{ padding: "40px", textAlign: "center", color: "var(--text-muted)" }}>
        Memuat data 22 Formulir Penjual...
      </div>
    );
  }

  const sheets = data.sheets || [];
  const fullCatalog = data.fullCatalog || {};
  const currentSheetData = fullCatalog[selectedSheet] || { rows: [] };
  const rows = currentSheetData.rows || [];

  const filteredRows = rows.filter((r) => {
    if (!search) return true;
    const q = search.toLowerCase();
    return r.some((cell) => cell !== null && cell !== undefined && String(cell).toLowerCase().includes(q));
  });

  const getBadgeStyle = (val) => {
    const s = String(val).toLowerCase();
    if (s.includes('unggah') || s.includes('foto') || s.includes('gambar')) return { bg: 'rgba(236, 72, 153, 0.15)', color: '#f472b6', border: '#db2777' };
    if (s.includes('rupiah') || s.includes('harga') || s.includes('tarif')) return { bg: 'rgba(16, 185, 129, 0.15)', color: '#34d399', border: '#059669' };
    if (s.includes('dropdown') || s.includes('pilihan')) return { bg: 'rgba(56, 189, 248, 0.15)', color: '#38bdf8', border: '#0284c7' };
    if (s.includes('gps') || s.includes('peta') || s.includes('lokasi')) return { bg: 'rgba(245, 158, 11, 0.15)', color: '#fbbf24', border: '#d97706' };
    if (s.includes('otp') || s.includes('verifikasi')) return { bg: 'rgba(168, 85, 247, 0.15)', color: '#c084fc', border: '#9333ea' };
    return { bg: 'rgba(255, 255, 255, 0.05)', color: 'var(--text-muted)', border: 'var(--border-subtle)' };
  };

  return (
    <div>
      {/* 4 KPI SUMMARY CARDS */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: "14px", marginBottom: "20px" }}>
        <div className="stat-card">
          <div className="stat-label">Total Formulir Penjual</div>
          <div className="stat-value" style={{ color: "#38bdf8" }}>22 Formulir</div>
          <div className="stat-sub">Workbook: FORMULIR PENJUAL.xlsx</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Formulir Terpilih</div>
          <div className="stat-value" style={{ color: "#10b981", fontSize: "16px", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
            {selectedSheet}
          </div>
          <div className="stat-sub">{rows.length} Baris Spesifikasi Kolom</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Cakupan Ekosistem</div>
          <div className="stat-value" style={{ color: "#f59e0b" }}>Barang & Jasa</div>
          <div className="stat-sub">Merchant, Driver, Profesi, Event, E-Voting</div>
        </div>
        <div className="stat-card">
          <div className="stat-label">Sistem Pembayaran</div>
          <div className="stat-value" style={{ color: "#ec4899" }}>Escrow & QR</div>
          <div className="stat-sub">Jadwal Pencairan: Senin & Kamis</div>
        </div>
      </div>

      {/* 22 SHEET SELECTOR CHIPS */}
      <div style={{ marginBottom: "18px", background: "var(--bg-card)", padding: "14px", borderRadius: "14px", border: "1px solid var(--border-subtle)" }}>
        <div style={{ fontSize: "12px", fontWeight: "800", color: "#38bdf8", marginBottom: "10px", display: "flex", alignItems: "center", gap: "6px" }}>
          <span>📋</span> Pilih Lembar Formulir Penjual & Merchant (22 Kategori):
        </div>
        <div style={{ display: "flex", flexWrap: "wrap", gap: "8px" }}>
          {sheets.map((s) => {
            const isSel = selectedSheet === s.sheet_name;
            return (
              <button
                key={s.sheet_name}
                onClick={() => setSelectedSheet(s.sheet_name)}
                style={{
                  padding: "6px 12px",
                  borderRadius: "8px",
                  fontSize: "11px",
                  fontWeight: isSel ? "800" : "600",
                  cursor: "pointer",
                  background: isSel ? "#2563eb" : "rgba(255, 255, 255, 0.05)",
                  color: isSel ? "#ffffff" : "var(--text-muted)",
                  border: isSel ? "1px solid #3b82f6" : "1px solid var(--border-subtle)",
                  transition: "all 0.15s ease",
                }}
              >
                {s.sheet_name}
              </button>
            );
          })}
        </div>
      </div>

      {/* TABLE DATA DISPLAY FOR SELECTED SHEET */}
      <div className="table-wrapper" style={{ overflowX: "auto", maxHeight: "650px" }}>
        <div style={{ padding: "12px 18px", background: "var(--bg-card-header)", borderBottom: "1px solid var(--border-subtle)", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <div style={{ fontWeight: "800", fontSize: "13px", color: "#38bdf8" }}>
            📑 Rincian Kolom & Spesifikasi Input: {selectedSheet}
          </div>
          <span className="badge badge-info">{filteredRows.length} Kolom / Baris</span>
        </div>
        <table style={{ minWidth: "900px", fontSize: "12px" }}>
          <thead>
            <tr style={{ background: "rgba(255,255,255,0.02)", borderBottom: "2px solid var(--border-subtle)" }}>
              {rows[0] && rows[0].map((col, idx) => (
                <th key={idx} style={{ textAlign: idx === 0 ? "center" : "left", width: idx === 0 ? "50px" : "auto" }}>
                  {col !== null && col !== undefined ? String(col) : `Kolom ${idx + 1}`}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {filteredRows.slice(1).map((r, rIdx) => (
              <tr key={rIdx} style={{ borderBottom: "1px solid var(--border-subtle)" }}>
                {r.map((cell, cIdx) => {
                  const bStyle = getBadgeStyle(cell);
                  return (
                    <td key={cIdx} style={{ textAlign: cIdx === 0 ? "center" : "left" }}>
                      {cIdx === 1 ? (
                        <span style={{ fontWeight: "700" }}>{cell !== null && cell !== undefined ? String(cell) : "-"}</span>
                      ) : cIdx === 2 && cell ? (
                        <span
                          style={{
                            padding: "3px 8px",
                            borderRadius: "6px",
                            fontSize: "11px",
                            fontWeight: "700",
                            background: bStyle.bg,
                            color: bStyle.color,
                            border: `1px solid ${bStyle.border}`,
                          }}
                        >
                          {String(cell)}
                        </span>
                      ) : (
                        <span>{cell !== null && cell !== undefined ? String(cell) : "-"}</span>
                      )}
                    </td>
                  );
                })}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
