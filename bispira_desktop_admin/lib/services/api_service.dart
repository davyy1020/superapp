// ==============================================================================
// BISPIRA Desktop Admin - Production Backend API Service
// ==============================================================================

class DesktopAdminApiService {
  // Live Production Server cPanel URL
  static const String baseUrl = 'https://superapp.agungtrijayaabadi.com/api/v1';

  // Endpoints
  static const String dbStatusUrl = '$baseUrl/db/status';
  static const String dashboardStatsUrl = '$baseUrl/admin/dashboard/stats';
  static const String branchesUrl = '$baseUrl/admin/branches';
  static const String merchantsUrl = '$baseUrl/admin/merchants';
  static const String driversPendingUrl = '$baseUrl/admin/drivers/verification-pending';
  static const String disbursementsBatchUrl = '$baseUrl/admin/disbursements/execute-batch';
  static const String upcomingDisbursementsUrl = '$baseUrl/admin/disbursements/upcoming';
  static const String ledgerRevenueMatrixUrl = '$baseUrl/ledger/revenue-sharing-matrix';
  static const String ledgerProfitSharingUrl = '$baseUrl/ledger/profit-sharing';
  static const String ledgerTransactionsUrl = '$baseUrl/ledger/transactions';

  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

