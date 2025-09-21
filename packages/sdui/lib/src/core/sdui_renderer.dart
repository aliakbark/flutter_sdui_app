import 'package:flutter/material.dart';
import '../models/widget_config.dart';
import '../models/theme_tokens.dart';
import '../core/workflow_controller.dart';
import '../widgets/sdui_text.dart';
import '../widgets/sdui_text_field.dart';
import '../widgets/sdui_button.dart';
import '../widgets/sdui_row.dart';
import '../widgets/sdui_column.dart';
import '../widgets/sdui_container.dart';
import '../widgets/sdui_spacer.dart';
import '../widgets/sdui_otp_field.dart';
import '../exceptions/sdui_exceptions.dart';

class SduiRenderer {
  /// Render a widget from configuration
  static Widget renderWidget(
    WidgetConfig config,
    ThemeTokens themeTokens,
    SduiWorkflowController controller,
  ) {
    try {
      switch (config.type.toLowerCase()) {
        case 'text':
          return SduiText(config: config, themeTokens: themeTokens);
        case 'textfield':
          return SduiTextField(
            config: config,
            themeTokens: themeTokens,
            controller: controller,
          );
        case 'button':
          return SduiButton(
            config: config,
            themeTokens: themeTokens,
            controller: controller,
          );
        case 'row':
          return SduiRow(
            config: config,
            themeTokens: themeTokens,
            controller: controller,
          );
        case 'otpfield':
          return SduiOtpField(
            config: config,
            themeTokens: themeTokens,
            controller: controller,
          );
        case 'column':
          return SduiColumn(
            config: config,
            themeTokens: themeTokens,
            controller: controller,
          );
        case 'container':
          return SduiContainer(
            config: config,
            themeTokens: themeTokens,
            controller: controller,
          );
        case 'spacer':
          return SduiSpacer(config: config, themeTokens: themeTokens);
        default:
          return _renderUnsupportedWidget(config.type);
      }
    } catch (e) {
      throw SduiRenderingException(
        'Failed to render widget ${config.type}: $e',
      );
    }
  }

  /// Render unsupported widget placeholder
  static Widget _renderUnsupportedWidget(String type) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[100],
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Unsupported widget: $type',
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Parse color from string
  static Color? _parseColor(String? colorString) {
    if (colorString == null) return null;

    try {
      // Remove # if present
      String hexColor = colorString.replaceAll('#', '');

      // Add alpha if not present
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }

      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return null;
    }
  }

  /// Get main axis alignment from string
  static MainAxisAlignment _getMainAxisAlignment(String? alignment) {
    switch (alignment?.toLowerCase()) {
      case 'start':
        return MainAxisAlignment.start;
      case 'end':
        return MainAxisAlignment.end;
      case 'center':
        return MainAxisAlignment.center;
      case 'spaceBetween':
      case 'space_between':
        return MainAxisAlignment.spaceBetween;
      case 'spaceAround':
      case 'space_around':
        return MainAxisAlignment.spaceAround;
      case 'spaceEvenly':
      case 'space_evenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  /// Get cross axis alignment from string
  static CrossAxisAlignment _getCrossAxisAlignment(String? alignment) {
    switch (alignment?.toLowerCase()) {
      case 'start':
        return CrossAxisAlignment.start;
      case 'end':
        return CrossAxisAlignment.end;
      case 'center':
        return CrossAxisAlignment.center;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      case 'baseline':
        return CrossAxisAlignment.baseline;
      default:
        return CrossAxisAlignment.start;
    }
  }
}
