import 'package:flutter_sdui_app/features/onboarding/data/datasources/base_onboarding_datasource.dart';
import 'package:flutter_sdui_app/features/onboarding/data/models/otp_send_response.dart';
import 'package:flutter_sdui_app/features/onboarding/data/models/otp_verify_response.dart';

class OnboardingRemoteDataSource extends BaseOnboardingDataSource {


  @override
  Future<OtpSendResponse> sendOTP(String phone) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Mock response - always successful with 300 seconds expiry
    final mockResponse = {'status': 'ok', 'expires_in': 8};

    return OtpSendResponse.fromJson(mockResponse);
  }

  @override
  Future<OtpVerifyResponse> verifyOTP(String phone, String otp) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    // Mock logic - only accept "123456" as a valid OTP
    final mockResponse = otp == '123456'
        ? {'status': 'ok'}
        : {'status': 'error'};

    return OtpVerifyResponse.fromJson(mockResponse);
  }
}
