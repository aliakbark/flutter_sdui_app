import 'package:sdui/sdui.dart';
import 'package:flutter_sdui_app/core/di/injector.dart';
import 'package:flutter_sdui_app/features/auth/presentation/states/authentication_cubit.dart';
import '../../../services/otp_service.dart';

/// Capability for verifying OTP and triggering authentication
class OtpVerifyCapability implements SduiCapability {
  final OtpService _otpService;
  
  OtpVerifyCapability(this._otpService);

  @override
  String get name => 'auth-otp-verify-v1';

  @override
  Future<SduiCapabilityResult> execute(Map<String, dynamic> params) async {
    final phone = params['phone'] as String?;
    final otp = params['otp'] as String?;

    if (phone == null || phone.isEmpty) {
      return SduiCapabilityResult.error('Phone number is required');
    }

    if (otp == null || otp.isEmpty) {
      return SduiCapabilityResult.error('OTP is required');
    }

    try {
      // Verify OTP using service
      final result = await _otpService.verifyOtp(phone, otp);
      
      // Trigger authentication on successful verification
      final authCubit = sl<AuthenticationCubit>();
      await authCubit.login(phone);
      
      return SduiCapabilityResult.success(
        message: 'OTP verified successfully',
        data: result,
      );
    } catch (e) {
      return SduiCapabilityResult.error('Failed to verify OTP: ${e.toString()}');
    }
  }
}
