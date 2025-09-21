import 'package:flutter/material.dart';
import '../models/widget_config.dart';
import '../models/theme_tokens.dart';

class SduiText extends StatelessWidget {
  final WidgetConfig config;
  final ThemeTokens themeTokens;

  const SduiText({
    Key? key,
    required this.config,
    required this.themeTokens,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final properties = config.properties as Map<String, dynamic>? ?? {};
    final text = properties['text'] as String? ?? '';
    final style = properties['style'] as String?;
    final align = properties['align'] as String?;

    return Text(
      text,
      style: _getTextStyle(context, style),
      textAlign: _getTextAlign(align),
    );
  }

  TextStyle _getTextStyle(BuildContext context, String? style) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: themeTokens.getTextColor(),
      fontFamily: themeTokens.getFontFamily(),
    );

    switch (style?.toLowerCase()) {
      case 'headline':
        return baseStyle?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ) ?? const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
      case 'title':
        return baseStyle?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
      case 'subtitle':
        return baseStyle?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ) ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
      case 'caption':
        return baseStyle?.copyWith(
          fontSize: 12,
          color: Colors.grey[600],
        ) ?? TextStyle(fontSize: 12, color: Colors.grey[600]);
      default:
        return baseStyle ?? const TextStyle();
    }
  }

  TextAlign _getTextAlign(String? align) {
    switch (align?.toLowerCase()) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      case 'justify':
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }
}
