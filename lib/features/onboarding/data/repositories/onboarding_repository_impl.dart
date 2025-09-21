import 'package:flutter_sdui_app/features/onboarding/data/datasources/base_onboarding_datasource.dart';
import 'package:flutter_sdui_app/features/onboarding/data/models/otp_send_response.dart';
import 'package:flutter_sdui_app/features/onboarding/data/models/otp_verify_response.dart';
import 'package:flutter_sdui_app/features/onboarding/domain/repositories/base_onboarding_repository.dart';

/// Onboarding repository implementation.
class OnboardingRepositoryImpl implements BaseOnboardingRepository {
  final BaseOnboardingDataSource _onboardingDataSource;

  OnboardingRepositoryImpl(this._onboardingDataSource);

  @override
  Future<OtpSendResponse> sendOtp(String phone) {
    return _onboardingDataSource.sendOTP(phone);
  }

  @override
  Future<OtpVerifyResponse> verifyOtp(String phone, String otp) {
    return _onboardingDataSource.verifyOTP(phone, otp);
  }
}
