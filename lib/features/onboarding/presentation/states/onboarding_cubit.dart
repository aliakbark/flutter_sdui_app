import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdui_app/core/enums/api_response_status.dart';
import 'package:flutter_sdui_app/features/auth/presentation/states/authentication_cubit.dart';
import 'package:flutter_sdui_app/core/di/injector.dart';
import 'package:flutter_sdui_app/features/onboarding/data/models/otp_send_response.dart';
import 'package:flutter_sdui_app/features/onboarding/data/models/otp_verify_response.dart';
import 'package:flutter_sdui_app/features/onboarding/domain/repositories/base_onboarding_repository.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final BaseOnboardingRepository _onboardingRepository;
  Timer? _otpTimer;
  int _otpRemainingSeconds = 0;
  bool _canResendOtp = false;

  // Add notifiers for UI updates
  final ValueNotifier<int> remainingSecondsNotifier = ValueNotifier(0);
  final ValueNotifier<bool> canResendNotifier = ValueNotifier(false);

  OnboardingCubit(this._onboardingRepository)
    : super(const OnboardingInitial());

  /// Getter to check if OTP can be resent
  bool get canResendOtp => _canResendOtp;

  /// Getter for remaining seconds
  int get remainingSeconds => _otpRemainingSeconds;

  @override
  Future<void> close() {
    _otpTimer?.cancel();

    remainingSecondsNotifier.dispose();
    canResendNotifier.dispose();

    return super.close();
  }

  /// Sends OTP to the provided phone number
  Future<void> sendOtp(String phone) async {
    try {
      emit(const OnboardingLoading());

      final OtpSendResponse response = await _onboardingRepository.sendOtp(
        phone,
      );

      if (response.status == APIResponseStatus.ok) {
        emit(OtpSendSuccess(response));
      } else {
        emit(const OnboardingError('Failed to send OTP'));
      }
    } catch (e) {
      emit(OnboardingError('Failed to send OTP: ${e.toString()}'));
    }
  }

  /// Verifies the OTP for the provided phone number
  Future<void> verifyOtp(String phone, String otp) async {
    try {
      emit(const OnboardingLoading());

      final response = await _onboardingRepository.verifyOtp(phone, otp);

      if (response.status == APIResponseStatus.ok) {
        emit(OtpVerifySuccess(response));

        // Trigger authentication after successful OTP verification
        final AuthenticationCubit authCubit = sl<AuthenticationCubit>();
        await authCubit.login(phone);
      } else {
        emit(const OnboardingError('Invalid OTP'));
      }
    } catch (e) {
      emit(const OnboardingError('Invalid OTP'));
    }
  }

  /// Resends OTP to the provided phone number
  Future<void> resendOtp(String phone) async {
    try {
      emit(const OnboardingLoading());

      final OtpSendResponse response = await _onboardingRepository.sendOtp(
        phone,
      );

      if (response.status == APIResponseStatus.ok) {
        emit(OtpResendSuccess(response));
        startOtpTimer(response.expiresIn);
      } else {
        emit(const OnboardingError('Failed to resend OTP'));
      }
    } catch (e) {
      emit(OnboardingError('Failed to resend OTP: ${e.toString()}'));
    }
  }

  /// Starts the OTP countdown timer
  void startOtpTimer(int seconds) {
    _otpTimer?.cancel();
    _otpRemainingSeconds = seconds;
    _canResendOtp = false;

    // Update notifiers
    remainingSecondsNotifier.value = _otpRemainingSeconds;
    canResendNotifier.value = _canResendOtp;

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _otpRemainingSeconds--;
      remainingSecondsNotifier.value = _otpRemainingSeconds;

      if (_otpRemainingSeconds <= 0) {
        timer.cancel();
        _canResendOtp = true;
        canResendNotifier.value = _canResendOtp;
      }
    });
  }

  /// Resets the OTP timer
  void resetOtpTimer() {
    _otpTimer?.cancel();
    _otpRemainingSeconds = 0;
    _canResendOtp = false;

    remainingSecondsNotifier.value = _otpRemainingSeconds;
    canResendNotifier.value = _canResendOtp;

    emit(const OnboardingInitial());
  }

  /// Resets the state to the initial
  void reset() {
    _otpTimer?.cancel();
    _otpRemainingSeconds = 0;
    _canResendOtp = false;

    remainingSecondsNotifier.value = _otpRemainingSeconds;
    canResendNotifier.value = _canResendOtp;

    emit(const OnboardingInitial());
  }
}
