import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdui_app/core/shared/presentation/widgets/language_switcher.dart';
import 'package:flutter_sdui_app/features/onboarding/data/datasources/onboarding_remote_datasource.dart';
import 'package:flutter_sdui_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:flutter_sdui_app/features/onboarding/presentation/pages/otp_send_page.dart';
import 'package:flutter_sdui_app/features/onboarding/presentation/states/onboarding_cubit.dart';
import 'package:flutter_sdui_app/features/sdui/workflows/onboarding/onboarding_workflow.dart';
import 'package:flutter_sdui_app/l10n/app_localizations.dart';
import 'package:sdui/sdui.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: const [LanguageSwitcher()],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.welcomeMessage,
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
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                )!.onboardingCompleted,
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        onError: (error) {
                          // Handle workflow error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                )!.errorMessage(error.toString()),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.startSduiOnboarding,
                    ),
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
                    child: Text(
                      AppLocalizations.of(context)!.traditionalOnboarding,
                    ),
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
