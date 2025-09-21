import 'package:flutter_sdui_app/features/onboarding/data/models/otp_send_response.dart';
import 'package:flutter_sdui_app/features/onboarding/data/models/otp_verify_response.dart';

/// Data source class
abstract class BaseOnboardingDataSource {
  /// Send OTP to phone number
  Future<OtpSendResponse> sendOTP(String phone);

  /// Verify OTP for phone number
  Future<OtpVerifyResponse> verifyOTP(String phone, String otp);
}
