// ==============================================================================
// BISPIRA Expert, Education & Entertainment App - Production Backend API Service
// ==============================================================================

class ExpertApiService {
  // Live Production Server cPanel URL
  static const String baseUrl = 'https://superapp.agungtrijayaabadi.com/api/v1';

  // Endpoints
  static const String dbStatusUrl = '$baseUrl/db/status';
  static const String ordersUrl = '$baseUrl/orders';
  static const String ledgerCatalogUrl = '$baseUrl/ledger/catalog-ecosystem';
  static const String tariffsUrl = '$baseUrl/ledger/tariffs-and-fees';
  static const String disbursementsUrl = '$baseUrl/disbursements/upcoming';
  static const String withdrawUrl = '$baseUrl/disbursements/withdraw';

  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

