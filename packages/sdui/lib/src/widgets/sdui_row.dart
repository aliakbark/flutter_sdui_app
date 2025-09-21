import 'package:flutter/material.dart';
import '../models/widget_config.dart';
import '../models/theme_tokens.dart';
import '../core/workflow_controller.dart';
import '../core/sdui_renderer.dart';
import '../utils/type_utils.dart';

class SduiRow extends StatelessWidget {
  final WidgetConfig config;
  final ThemeTokens themeTokens;
  final SduiWorkflowController controller;

  const SduiRow({
    Key? key,
    required this.config,
    required this.themeTokens,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final properties = config.properties as Map<String, dynamic>? ?? {};
    final spacing =
        TypeUtils.toDouble(properties['spacing']) ?? themeTokens.getSpaceMd();
    final mainAxisAlignment = _getMainAxisAlignment(
      properties['mainAxisAlignment'] as String?,
    );
    final crossAxisAlignment = _getCrossAxisAlignment(
      properties['crossAxisAlignment'] as String?,
    );

    final children = config.children ?? [];

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final childConfig = entry.value;

        final widget = SduiRenderer.renderWidget(
          childConfig,
          themeTokens,
          controller,
        );

        // Add spacing between children (except for the last one)
        if (index < children.length - 1) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: spacing),
              child: widget,
            ),
          );
        } else {
          return Expanded(child: widget);
        }
      }).toList(),
    );
  }

  MainAxisAlignment _getMainAxisAlignment(String? alignment) {
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

  CrossAxisAlignment _getCrossAxisAlignment(String? alignment) {
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
        return CrossAxisAlignment.center;
    }
  }
}
