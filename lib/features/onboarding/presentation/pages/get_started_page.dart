import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdui_app/features/onboarding/data/datasources/onboarding_remote_datasource.dart';
import 'package:flutter_sdui_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:flutter_sdui_app/features/onboarding/presentation/pages/otp_send_page.dart';
import 'package:flutter_sdui_app/features/onboarding/presentation/states/onboarding_cubit.dart';
import 'package:flutter_sdui_app/features/sdui/workflows/onboarding/onboarding_workflow.dart';
import 'package:sdui/sdui.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  'Hey there!\nWelcome to Flutter SDUI Demo App',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Launch SDUI workflow
                      SduiService.navigateToWorkflow(
                        context,
                        OnboardingWorkflow.id,
                        onComplete: () {
                          // Handle workflow completion
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Onboarding completed successfully!',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        onError: (error) {
                          // Handle workflow error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $error'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Start SDUI Onboarding'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => OnboardingCubit(
                              OnboardingRepositoryImpl(
                                OnboardingRemoteDataSource(),
                              ),
                            ),
                            child: const OtpSendPage(),
                          ),
                        ),
                      );
                    },
                    child: const Text('Traditional Onboarding'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
