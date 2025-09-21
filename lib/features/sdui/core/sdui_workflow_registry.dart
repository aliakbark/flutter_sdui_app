import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter_sdui_app/features/sdui/workflows/onboarding/onboarding_workflow.dart';
import 'package:sdui/sdui.dart';

/// Simple registry for all SDUI workflows and capabilities
class SDUIWorkflowRegistry {
  static bool _initialized = false;

  // Map workflow IDs to their capability registration functions
  static final Map<String, Function> _workflowCapabilities = {
    OnboardingWorkflow.id: OnboardingWorkflow.registerCapabilities,
    // Future workflows can be added here
  };

  /// Initialize SDUI and register workflows based on config
  static Future<void> initialize({
    String? assetPath,
    String? networkUrl,
    SduiConfig? config,
  }) async {
    if (_initialized) return;

    // Initialize SDUI service
    await SduiService.initialize(
      assetPath: assetPath,
      networkUrl: networkUrl,
      config: config,
    );

    // Register capabilities only for workflows present in config
    _registerWorkflowCapabilities();

    _initialized = true;
  }

  /// Register capabilities for workflows that exist in the loaded config
  static void _registerWorkflowCapabilities() {
    final List<Workflow> loadedWorkflows = SduiService.config?.workflows ?? [];

    for (final Workflow workflow in loadedWorkflows) {
      final Function? registerFunction = _workflowCapabilities[workflow.id];
      if (registerFunction != null) {
        registerFunction.call();
        dev.log(
          'SDUI: Registered capabilities for workflow: ${workflow.id}',
          name: 'SDUIWorkflowRegistry',
        );
      } else {
        dev.log(
          'SDUI: No capabilities found for workflow: ${workflow.id}',
          name: 'SDUIWorkflowRegistry',
        );
      }
    }

    if (loadedWorkflows.isEmpty) {
      dev.log(
        'SDUI: No workflows found in config to register capabilities for.',
        name: 'SDUIWorkflowRegistry',
      );
    }
  }

  static bool get isInitialized => _initialized && SduiService.isInitialized;

  static void reset() {
    SduiService.reset();
    _initialized = false;
  }
}
