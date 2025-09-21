import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdui_app/features/onboarding/data/datasources/onboarding_remote_datasource.dart';
import 'package:flutter_sdui_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:flutter_sdui_app/features/onboarding/presentation/pages/otp_send_page.dart';
import 'package:flutter_sdui_app/features/onboarding/presentation/states/onboarding_cubit.dart';

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
                    child: const Text('Get Started'),
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
