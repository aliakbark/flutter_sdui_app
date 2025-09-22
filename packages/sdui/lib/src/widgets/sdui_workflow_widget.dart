import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:sdui/src/core/sdui_renderer.dart';
import 'package:sdui/src/core/workflow_controller.dart';
import 'package:sdui/src/models/theme_tokens.dart';
import 'package:sdui/src/models/workflow.dart';

class SduiWorkflowWidget extends StatefulWidget {
  final Workflow workflow;
  final ThemeTokens themeTokens;
  final VoidCallback? onComplete;
  final Function(String)? onError;

  const SduiWorkflowWidget({
    super.key,
    required this.workflow,
    required this.themeTokens,
    this.onComplete,
    this.onError,
  });

  @override
  State<SduiWorkflowWidget> createState() => _SduiWorkflowWidgetState();
}

class _SduiWorkflowWidgetState extends State<SduiWorkflowWidget> {
  late SduiWorkflowController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SduiWorkflowController(
      workflow: widget.workflow,
      onComplete: widget.onComplete,
      onError: _handleError,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleError(String error) {
    widget.onError?.call(error);

    // Show error snackbar with proper context validation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      try {
        final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
        if (scaffoldMessenger == null) return;

        scaffoldMessenger.clearSnackBars();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                if (mounted) {
                  ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
                }
              },
            ),
          ),
        );
      } catch (e) {
        // Log error but don't throw to prevent cascading errors
        dev.log('Error showing snackbar: $e', name: 'SduiWorkflowWidget');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final SduiScreen? currentScreen = _controller.currentScreen;

        if (currentScreen == null) {
          return const Center(child: Text('No screen to display'));
        }

        return Scaffold(
          backgroundColor: widget.themeTokens.getBgColor(),
          appBar: AppBar(
            title: Text(
              currentScreen.title,
              style: TextStyle(
                color: widget.themeTokens.getTextColor(),
                fontFamily: widget.themeTokens.getFontFamily(),
              ),
            ),
            backgroundColor: widget.themeTokens.getBgColor(),
            elevation: 0,
            iconTheme: IconThemeData(color: widget.themeTokens.getTextColor()),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(widget.themeTokens.getSpaceMd()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: currentScreen.widgets.map((widgetConfig) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: widget.themeTokens.getSpaceMd(),
                            ),
                            child: SduiRenderer.renderWidget(
                              widgetConfig,
                              widget.themeTokens,
                              _controller,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Standalone page wrapper for SDUI workflows
class SduiWorkflowPage extends StatelessWidget {
  final String workflowId;
  final Workflow workflow;
  final ThemeTokens themeTokens;
  final VoidCallback? onComplete;
  final Function(String)? onError;

  const SduiWorkflowPage({
    super.key,
    required this.workflowId,
    required this.workflow,
    required this.themeTokens,
    this.onComplete,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return SduiWorkflowWidget(
      workflow: workflow,
      themeTokens: themeTokens,
      onComplete: onComplete ?? () => Navigator.of(context).pop(),
      onError: onError,
    );
  }
}
