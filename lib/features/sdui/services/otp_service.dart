/// Service for handling OTP operations
/// Separates business logic from state management
class OtpService {
  /// Send OTP to the provided phone number
  Future<Map<String, dynamic>> sendOtp(String phone) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    return {
      'phone': phone,
      'expires_in': 300,
      'message': 'OTP sent successfully',
    };
  }

  /// Verify the OTP for the provided phone number
  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock verification logic - accept "123456" as valid OTP
    if (otp == '123456') {
      return {
        'phone': phone,
        'authenticated': true,
        'message': 'OTP verified successfully',
      };
    } else {
      throw Exception('Invalid OTP. Please try again.');
    }
  }

  /// Resend OTP to the provided phone number
  Future<Map<String, dynamic>> resendOtp(String phone) async {
    // Reuse the sendOtp method
    return await sendOtp(phone);
  }
}
