class AppConstants {
  static const String appName = 'GoWithRide';
  static const String appTagline = 'Ride Smarter, Together';
  static const String appVersion = '1.0.0';
  static const String appCurrency = '₦';

  // Subscription tiers
  static const Map<String, double> subscriptionTiers = {
    'Basic': 1000.0,
    'Standard': 2000.0,
    'Premium': 3000.0,
  };

// Add other constants as needed
// API Endpoints
  static const String baseUrl = 'https://api.gowithride.com';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';

  // SharedPref Keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
}