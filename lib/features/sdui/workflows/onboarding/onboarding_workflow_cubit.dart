import '../../core/state/base_workflow_cubit.dart';
import '../../services/otp_service.dart';

/// Onboarding workflow cubit for SDUI flows
/// Delegates business logic to OtpService (Single Responsibility Principle)
class OnboardingWorkflowCubit extends BaseWorkflowCubit {
  final OtpService _otpService;

  OnboardingWorkflowCubit(this._otpService);

  /// Send OTP to the provided phone number
  Future<void> sendOtp(String phone) async {
    setLoading();

    try {
      final result = await _otpService.sendOtp(phone);
      setSuccess(data: result);
    } catch (e) {
      setError('Failed to send OTP: ${e.toString()}');
    }
  }

  /// Verify the OTP for the provided phone number
  Future<void> verifyOtp(String phone, String otp) async {
    setLoading();

    try {
      final result = await _otpService.verifyOtp(phone, otp);
      setSuccess(data: result);
    } catch (e) {
      setError(e.toString());
    }
  }

  /// Resend OTP to the provided phone number
  Future<void> resendOtp(String phone) async {
    setLoading();

    try {
      final result = await _otpService.resendOtp(phone);
      setSuccess(data: result);
    } catch (e) {
      setError('Failed to resend OTP: ${e.toString()}');
    }
  }
}
