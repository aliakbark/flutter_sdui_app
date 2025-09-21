/// This class contains all the API endpoints used in the application.
class ApiEndpoints {
  // Base URL for API requests
  static const String baseUrl = 'https://api.example.com';

  // server-driven UI config endpoint
  static const String sduiConfig = '/sdui-config';

  // Auth endpoints
  static const String authOtpSend = '/auth-otp-send-v1';
  static const String authOtpVerify = '/auth-otp-verify-v1';
}
