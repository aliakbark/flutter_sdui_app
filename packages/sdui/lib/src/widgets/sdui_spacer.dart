import 'package:flutter/material.dart';
import '../models/widget_config.dart';
import '../models/theme_tokens.dart';
import '../utils/type_utils.dart';

class SduiSpacer extends StatelessWidget {
  final WidgetConfig config;
  final ThemeTokens themeTokens;

  const SduiSpacer({
    Key? key,
    required this.config,
    required this.themeTokens,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final properties = config.properties as Map<String, dynamic>? ?? {};
    final height = TypeUtils.toDouble(properties['height']) ?? themeTokens.getSpaceMd();
    final width = TypeUtils.toDouble(properties['width']);

    return SizedBox(
      height: height,
      width: width,
    );
  }
}
