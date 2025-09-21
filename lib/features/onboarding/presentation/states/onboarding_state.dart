part of 'onboarding_cubit.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

class OtpSendSuccess extends OnboardingState {
  final OtpSendResponse response;

  const OtpSendSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class OtpResendSuccess extends OnboardingState {
  final OtpSendResponse response;

  const OtpResendSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class OtpVerifySuccess extends OnboardingState {
  final OtpVerifyResponse response;

  const OtpVerifySuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object?> get props => [message];
}
