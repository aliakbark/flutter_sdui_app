import 'package:flutter/material.dart';
import 'package:flutter_sdui_app/features/onboarding/presentation/pages/get_started_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(title: 'Flutter SDUI Demo App', home: GetStartedPage());
}
