import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdui_app/features/onboarding/presentation/states/onboarding_cubit.dart';
import 'package:flutter_sdui_app/features/onboarding/presentation/pages/otp_verify_page.dart';

class OtpSendPage extends StatefulWidget {
  const OtpSendPage({super.key});

  @override
  State<OtpSendPage> createState() => _OtpSendPageState();
}

class _OtpSendPageState extends State<OtpSendPage> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      context.read<OnboardingCubit>().sendOtp(_phoneController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final OnboardingCubit onboardingCubit = context.read<OnboardingCubit>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Semantics(
          header: true,
          child: const Text('Phone Verification'),
        ),
      ),
      body: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (BuildContext context, OnboardingState state) {
          if (state is OnboardingError) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Semantics(
                    liveRegion: true,
                    child: Text(state.message),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else if (state is OtpSendSuccess) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Semantics(
                    liveRegion: true,
                    child: Text(
                      'OTP sent successfully! Expires in ${state.response.expiresIn} seconds',
                    ),
                  ),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (newContext) => BlocProvider.value(
                    value: onboardingCubit,
                    child: OtpVerifyPage(
                      phoneNumber: _phoneController.text.trim(),
                      expiresIn: state.response.expiresIn,
                    ),
                  ),
                ),
              );
            }
          }
        },
        builder: (BuildContext context, OnboardingState state) {
          return Semantics(
            label: 'Phone number verification form',
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
                        'Verify Your Phone Number',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        semanticsLabel: 'Verify Your Phone Number - Main heading',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'We\'ll send you a verification code to confirm your phone number.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                      semanticsLabel: 'We will send you a verification code to confirm your phone number.',
                    ),
                    const SizedBox(height: 48),
                    Semantics(
                      textField: true,
                      hint: 'Enter your phone number to receive verification code',
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter your phone number',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: _validatePhoneNumber,
                        enabled: state is! OnboardingLoading,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => state is! OnboardingLoading ? _sendOtp() : null,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Semantics(
                      button: true,
                      hint: state is OnboardingLoading 
                          ? 'Sending verification code, please wait'
                          : 'Send verification code to your phone number',
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: state is OnboardingLoading ? null : _sendOtp,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: state is OnboardingLoading
                              ? Semantics(
                                  label: 'Sending verification code',
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
                                  'Send OTP',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Semantics(
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
                              Text(
                                '• Send OTP: Always returns success with 300s expiry',
                              ),
                              Text('• Verify OTP: Success only if OTP is "123456"'),
                              Text('• Network delays are simulated'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
