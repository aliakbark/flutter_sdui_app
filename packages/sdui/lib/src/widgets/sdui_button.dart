import 'package:flutter/material.dart';

import '../core/workflow_controller.dart';
import '../models/theme_tokens.dart';
import '../models/widget_config.dart';

class SduiButton extends StatelessWidget {
  final WidgetConfig config;
  final ThemeTokens themeTokens;
  final SduiWorkflowController controller;

  const SduiButton({
    super.key,
    required this.config,
    required this.themeTokens,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final properties = config.properties ?? <String, dynamic>{};
    final label = config.label ?? properties['label'] as String? ?? 'Button';
    final style = config.style ?? properties['style'] as String?;
    final fullWidth = properties['fullWidth'] as bool? ?? true;
    final semanticLabel = properties['semanticLabel'] as String?;
    final semanticHint = properties['semanticHint'] as String?;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final isLoading = controller.isLoading;

        Widget button = Semantics(
          button: true,
          label: semanticLabel ?? label,
          hint:
              semanticHint ??
              (isLoading
                  ? 'Button is loading, please wait'
                  : 'Tap to ${label.toLowerCase()}'),
          child: _buildButton(context, label, style, isLoading),
        );

        if (fullWidth) {
          button = SizedBox(
            width: double.infinity,
            height: 48, // Ensure minimum touch target size
            child: button,
          );
        }

        return button;
      },
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    String? style,
    bool isLoading,
  ) {
    final onPressed = isLoading ? null : () => _handleButtonPress(context);

    switch (style?.toLowerCase()) {
      case 'secondary':
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: themeTokens.getPrimaryColor(),
            side: BorderSide(color: themeTokens.getPrimaryColor()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(themeTokens.getRadiusMd()),
            ),
            padding: EdgeInsets.symmetric(
              vertical: themeTokens.getSpaceMd(),
              horizontal: themeTokens.getSpaceMd() * 1.5,
            ),
          ),
          child: _buildButtonChild(label, isLoading),
        );
      case 'text':
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: themeTokens.getPrimaryColor(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(themeTokens.getRadiusMd()),
            ),
            padding: EdgeInsets.symmetric(
              vertical: themeTokens.getSpaceMd(),
              horizontal: themeTokens.getSpaceMd() * 1.5,
            ),
          ),
          child: _buildButtonChild(label, isLoading),
        );
      default: // primary
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: themeTokens.getPrimaryColor(),
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(themeTokens.getRadiusMd()),
            ),
            padding: EdgeInsets.symmetric(
              vertical: themeTokens.getSpaceMd(),
              horizontal: themeTokens.getSpaceMd() * 1.5,
            ),
          ),
          child: _buildButtonChild(label, isLoading),
        );
    }
  }

  Widget _buildButtonChild(String label, bool isLoading) {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                config.style?.toLowerCase() == 'secondary' ||
                        config.style?.toLowerCase() == 'text'
                    ? themeTokens.getPrimaryColor()
                    : Colors.white,
              ),
            ),
          ),
          SizedBox(width: themeTokens.getSpaceSm()),
          Text(
            'Loading...',
            style: TextStyle(
              fontFamily: themeTokens.getFontFamily(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Text(
      label,
      style: TextStyle(
        fontFamily: themeTokens.getFontFamily(),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  void _handleButtonPress(BuildContext context) async {
    if (config.action == null) return;

    // Validate current screen before executing action
    final isValid = controller.validateCurrentScreen();
    if (!isValid) {
      // Show validation errors - they're already displayed in the UI
      return;
    }

    // Execute action - error handling is done in the controller
    await controller.executeAction(config.action!);
  }
}
