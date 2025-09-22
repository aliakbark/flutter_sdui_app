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
        title: Semantics(
          header: true,
          child: Text(AppLocalizations.of(context)!.appTitle),
        ),
        actions: const [LanguageSwitcher()],
      ),
      body: SafeArea(
        child: Semantics(
          label: 'Welcome screen with onboarding options',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Semantics(
                    header: true,
                    child: Text(
                      AppLocalizations.of(context)!.welcomeMessage,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                      semanticsLabel:
                          'Welcome to the application. Choose an onboarding option below.',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Semantics(
                      button: true,
                      hint:
                          'Start server-driven user interface onboarding process',
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            // Launch SDUI workflow
                            SduiService.navigateToWorkflow(
                              context,
                              OnboardingWorkflow.id,
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.startSduiOnboarding,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Semantics(
                      button: true,
                      hint:
                          'Start traditional onboarding process with phone verification',
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
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
                            AppLocalizations.of(context)!.normalOnboarding,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
