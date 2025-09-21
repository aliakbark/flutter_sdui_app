import 'package:flutter/material.dart';
import '../models/widget_config.dart';
import '../models/theme_tokens.dart';
import '../core/workflow_controller.dart';
import '../core/sdui_renderer.dart';
import '../utils/type_utils.dart';

class SduiContainer extends StatelessWidget {
  final WidgetConfig config;
  final ThemeTokens themeTokens;
  final SduiWorkflowController controller;

  const SduiContainer({
    Key? key,
    required this.config,
    required this.themeTokens,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final properties = config.properties as Map<String, dynamic>? ?? {};
    final padding = TypeUtils.toDouble(properties['padding']) ?? themeTokens.getSpaceMd();
    final margin = TypeUtils.toDouble(properties['margin']) ?? 0.0;
    final backgroundColor = properties['backgroundColor'] as String?;
    final borderRadius = TypeUtils.toDouble(properties['borderRadius']) ?? themeTokens.getRadiusMd();
    final width = TypeUtils.toDouble(properties['width']);
    final height = TypeUtils.toDouble(properties['height']);

    Widget child = const SizedBox.shrink();
    
    if (config.children != null && config.children!.isNotEmpty) {
      if (config.children!.length == 1) {
        child = SduiRenderer.renderWidget(config.children!.first, themeTokens, controller);
      } else {
        // Multiple children, wrap in column
        child = Column(
          children: config.children!
              .map((childConfig) => SduiRenderer.renderWidget(childConfig, themeTokens, controller))
              .toList(),
        );
      }
    }

    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.all(margin),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor != null 
            ? _parseColor(backgroundColor) ?? themeTokens.getBgColor()
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }

  /// Parse color from string
  Color? _parseColor(String? colorString) {
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
}
