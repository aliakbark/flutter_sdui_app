import 'package:flutter/material.dart';
import 'package:flutter_sdui_app/features/onboarding/core/onboarding_widget_keys.dart';

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
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                key: OnboardingWidgetKeys.getStartedButton,
                onPressed: () {
                  // Navigate to the onboarding flow
                },
                child: const Text('Get Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
