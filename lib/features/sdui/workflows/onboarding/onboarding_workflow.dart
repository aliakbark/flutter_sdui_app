import 'package:flutter_sdui_app/features/sdui/services/otp_service.dart';
import 'package:sdui/sdui.dart';
import 'capabilities/otp_send_capability.dart';
import 'capabilities/otp_verify_capability.dart';

/// Registration for onboarding workflow capabilities
class OnboardingWorkflow {
  /// Unique ID for the onboarding workflow
  static final String id = 'onboarding_v1';

  static void registerCapabilities() {
    final otpService = OtpService();

    SduiService.registerCapabilities([
      OtpSendCapability(otpService),
      OtpVerifyCapability(otpService),
    ]);
  }
}
