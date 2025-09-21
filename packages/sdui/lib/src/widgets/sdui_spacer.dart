import 'package:flutter/material.dart';
import '../models/widget_config.dart';
import '../models/theme_tokens.dart';
import '../utils/type_utils.dart';

class SduiSpacer extends StatelessWidget {
  final WidgetConfig config;
  final ThemeTokens themeTokens;

  const SduiSpacer({
    super.key,
    required this.config,
    required this.themeTokens,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> properties =
        config.properties ?? <String, dynamic>{};
    final double height =
        TypeUtils.toDouble(properties['height']) ?? themeTokens.getSpaceMd();
    final double? width = TypeUtils.toDouble(properties['width']);

    return SizedBox(height: height, width: width);
  }
}
