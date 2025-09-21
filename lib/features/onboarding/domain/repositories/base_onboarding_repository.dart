import 'package:flutter_sdui_app/features/onboarding/data/models/otp_send_response.dart';
import 'package:flutter_sdui_app/features/onboarding/data/models/otp_verify_response.dart';

/// Base class for Onboarding repositories.
abstract class BaseOnboardingRepository {
  /// Sends an OTP to the given phone number.
  Future<OtpSendResponse> sendOtp(String phone);

  /// Verifies the OTP for the given phone number.
  Future<OtpVerifyResponse> verifyOtp(String phone, String otp);
}
