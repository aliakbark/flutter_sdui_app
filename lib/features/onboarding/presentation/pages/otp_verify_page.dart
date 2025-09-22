import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdui_app/features/onboarding/presentation/states/onboarding_cubit.dart';

class OtpVerifyPage extends StatefulWidget {
  final String phoneNumber;
  final int expiresIn;

  const OtpVerifyPage({
    super.key,
    required this.phoneNumber,
    required this.expiresIn,
  });

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingCubit>().startOtpTimer(widget.expiresIn);
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP';
    }
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    // Check if OTP contains only numbers
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    return null;
  }

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      context.read<OnboardingCubit>().verifyOtp(
        widget.phoneNumber,
        _otpController.text.trim(),
      );
    }
  }

  void _resendOtp() {
    context.read<OnboardingCubit>().resendOtp(widget.phoneNumber);
  }

  void _editPhoneNumber() {
    Navigator.pop(context);
  }

  String _formatOtpTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: const Text('Verify OTP'),
        ),
        centerTitle: true,
      ),
      body: BlocListener<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OtpResendSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Semantics(
                  liveRegion: true,
                  child: const Text('OTP resent successfully!'),
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is OtpVerifySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Semantics(
                  liveRegion: true,
                  child: const Text('OTP verified successfully! Logging you in...'),
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: Semantics(
          label: 'OTP verification form',
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  Semantics(
                    header: true,
                    child: const Text(
                      'Verify Phone Number',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      semanticsLabel: 'Verify Phone Number - Main heading',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Enter the 6-digit code sent to your phone number.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                    semanticsLabel: 'Enter the 6-digit verification code sent to your phone number.',
                  ),
                  const SizedBox(height: 32),
                  // Phone number display with edit button
                  _PhoneNumberDisplay(
                    phoneNumber: widget.phoneNumber,
                    onEdit: _editPhoneNumber,
                  ),
                  const SizedBox(height: 32),
                  BlocSelector<OnboardingCubit, OnboardingState, bool>(
                    selector: (state) => state is OnboardingLoading,
                    builder: (context, isLoading) {
                      return Semantics(
                        textField: true,
                        hint: 'Enter 6-digit verification code. Use 123456 for testing.',
                        child: TextFormField(
                          controller: _otpController,
                          decoration: const InputDecoration(
                            labelText: 'Enter OTP',
                            hintText: '123456',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                            counterText: '',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          maxLength: 6,
                          validator: _validateOtp,
                          enabled: !isLoading,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, letterSpacing: 2),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => !isLoading ? _verifyOtp() : null,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Separate timer widget to prevent unnecessary rebuilds
                  _OtpTimerWidget(formatTime: _formatOtpTime),
                  const SizedBox(height: 32),
                  BlocSelector<OnboardingCubit, OnboardingState, bool>(
                    selector: (state) => state is OnboardingLoading,
                    builder: (context, isLoading) {
                      return Semantics(
                        button: true,
                        hint: isLoading 
                            ? 'Verifying OTP, please wait'
                            : 'Verify the entered OTP code',
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: isLoading
                                ? Semantics(
                                    label: 'Verifying OTP',
                                    child: const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Verify OTP',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _ResendOtpButton(onResend: _resendOtp),
                  const SizedBox(height: 32),
                  const _MockApiInfoCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Separate widget for phone number display to improve code organization
class _PhoneNumberDisplay extends StatelessWidget {
  final String phoneNumber;
  final VoidCallback onEdit;

  const _PhoneNumberDisplay({required this.phoneNumber, required this.onEdit});

  String _formatPhoneNumber(String phone) {
    // Simple formatting - you can enhance this based on your needs
    if (phone.length >= 10) {
      return '+${phone.substring(0, 1)} ${phone.substring(1, 4)}-${phone.substring(4, 7)}-${phone.substring(7)}';
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Phone number display with edit option',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Semantics(
              label: 'Phone icon',
              child: const Icon(Icons.phone, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Semantics(
                label: 'Phone number: ${_formatPhoneNumber(phoneNumber)}',
                child: Text(
                  _formatPhoneNumber(phoneNumber),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Semantics(
              button: true,
              hint: 'Edit phone number and go back to previous screen',
              child: IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, color: Colors.blue),
                tooltip: 'Edit phone number',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Separate timer widget to prevent unnecessary rebuilds of the entire UI
class _OtpTimerWidget extends StatelessWidget {
  final String Function(int) formatTime;

  const _OtpTimerWidget({required this.formatTime});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();

    return ValueListenableBuilder<int>(
      valueListenable: cubit.remainingSecondsNotifier,
      builder: (context, remainingSeconds, child) {
        if (remainingSeconds > 0) {
          return Semantics(
            liveRegion: true,
            label: 'OTP timer: Resend available in ${formatTime(remainingSeconds)}',
            child: Text(
              'Resend OTP in ${formatTime(remainingSeconds)}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }
        return Semantics(
          liveRegion: true,
          label: 'OTP timer expired, you can now resend the OTP',
          child: const Text(
            'You can now resend the OTP',
            style: TextStyle(fontSize: 14, color: Colors.green),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

// Separate resend button widget with optimized state management
class _ResendOtpButton extends StatelessWidget {
  final VoidCallback onResend;

  const _ResendOtpButton({required this.onResend});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();

    return ValueListenableBuilder<bool>(
      valueListenable: cubit.canResendNotifier,
      builder: (context, canResend, child) {
        return BlocSelector<OnboardingCubit, OnboardingState, bool>(
          selector: (state) => state is OnboardingLoading,
          builder: (context, isLoading) {
            return Semantics(
              button: true,
              hint: (isLoading || !canResend) 
                  ? 'Resend OTP button is currently disabled'
                  : 'Resend verification code to your phone number',
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: (isLoading || !canResend) ? null : onResend,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Resend OTP', style: TextStyle(fontSize: 16)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Separate mock API info card for better organization
class _MockApiInfoCard extends StatelessWidget {
  const _MockApiInfoCard();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Development information about mock API behavior',
      child: const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mock API Behavior:',
                style: TextStyle(fontWeight: FontWeight.bold),
                semanticsLabel: 'Mock API Behavior information',
              ),
              SizedBox(height: 8),
              Text('• Use OTP "123456" for successful verification'),
              Text('• Any other OTP will result in an error'),
              Text('• Successful verification will log you in automatically'),
            ],
          ),
        ),
      ),
    );
  }
}
