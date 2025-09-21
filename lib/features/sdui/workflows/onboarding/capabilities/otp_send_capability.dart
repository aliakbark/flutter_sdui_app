import 'package:sdui/sdui.dart';
import '../../../services/otp_service.dart';

/// Capability for sending OTP to phone number
class OtpSendCapability implements SduiCapability {
  final OtpService _otpService;

  OtpSendCapability(this._otpService);

  @override
  String get name => 'auth-otp-send-v1';

  @override
  Future<SduiCapabilityResult> execute(Map<String, dynamic> params) async {
    final phone = params['phone'] as String?;

    if (phone == null || phone.isEmpty) {
      return SduiCapabilityResult.error('Phone number is required');
    }

    try {
      final result = await _otpService.sendOtp(phone);

      return SduiCapabilityResult.success(
        message: 'OTP sent successfully to $phone',
        data: result,
      );
    } catch (e) {
      return SduiCapabilityResult.error('Failed to send OTP: ${e.toString()}');
    }
  }
}
