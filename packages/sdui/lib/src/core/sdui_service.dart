import 'package:flutter/material.dart';
import 'package:sdui/src/capabilities/capabilities.dart';
import 'package:sdui/src/core/sdui_parser.dart';
import 'package:sdui/src/models/sdui_config.dart';
import 'package:sdui/src/models/workflow.dart';
import 'package:sdui/src/widgets/sdui_workflow_widget.dart';

/// High-level service for SDUI operations
class SduiService {
  static SduiConfig? _config;
  static bool _initialized = false;

  /// Initialize SDUI service with configuration
  static Future<void> initialize({
    String? assetPath,
    String? networkUrl,
    SduiConfig? config,
  }) async {
    if (config != null) {
      _config = config;
    } else if (assetPath != null) {
      _config = await SduiParser.loadFromAsset(assetPath);
    } else if (networkUrl != null) {
      _config = await SduiParser.loadFromNetwork(networkUrl);
    } else {
      throw ArgumentError(
        'Must provide either config, assetPath, or networkUrl',
      );
    }

    _initialized = true;
  }

  /// Initialize with mock network data
  static Future<void> initializeWithMockNetwork() async {
    _config = await SduiParser.loadFromMockNetwork();
    _initialized = true;
  }

  /// Register capabilities
  static void registerCapabilities(List<SduiCapability> capabilities) {
    for (final capability in capabilities) {
      SduiCapabilityRegistry.register(capability);
    }
  }

  /// Get workflow by ID
  static Workflow? getWorkflow(String workflowId) {
    _ensureInitialized();
    return _config?.getWorkflow(workflowId);
  }

  /// Create workflow widget
  static Widget createWorkflowWidget({
    required String workflowId,
    VoidCallback? onComplete,
    Function(String)? onError,
  }) {
    _ensureInitialized();

    final Workflow? workflow = getWorkflow(workflowId);
    if (workflow == null) {
      return Center(child: Text('Workflow not found: $workflowId'));
    }

    return SduiWorkflowWidget(
      workflow: workflow,
      themeTokens: _config!.themeTokens,
      onComplete: onComplete,
      onError: onError,
    );
  }

  /// Create workflow page
  static Widget createWorkflowPage({
    required String workflowId,
    VoidCallback? onComplete,
    Function(String)? onError,
  }) {
    _ensureInitialized();

    final workflow = getWorkflow(workflowId);
    if (workflow == null) {
      return Scaffold(
        body: Center(child: Text('Workflow not found: $workflowId')),
      );
    }

    return SduiWorkflowPage(
      workflowId: workflowId,
      workflow: workflow,
      themeTokens: _config!.themeTokens,
      onComplete: onComplete,
      onError: onError,
    );
  }

  /// Navigate to workflow
  static void navigateToWorkflow(
    BuildContext context,
    String workflowId, {
    VoidCallback? onComplete,
    Function(String)? onError,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => createWorkflowPage(
          workflowId: workflowId,
          onComplete: onComplete ?? () => Navigator.of(context).pop(),
          onError: onError,
        ),
      ),
    );
  }

  /// Get current configuration
  static SduiConfig? get config => _config;

  /// Check if service is initialized
  static bool get isInitialized => _initialized;

  /// Get available workflow IDs
  static List<String> getAvailableWorkflows() {
    _ensureInitialized();
    return _config?.workflows.map((w) => w.id).toList() ?? [];
  }

  /// Reload configuration
  static Future<void> reload({
    String? assetPath,
    String? networkUrl,
    SduiConfig? config,
  }) async {
    await initialize(
      assetPath: assetPath,
      networkUrl: networkUrl,
      config: config,
    );
  }

  /// Clear configuration and reset
  static void reset() {
    _config = null;
    _initialized = false;
    SduiCapabilityRegistry.clear();
  }

  static void _ensureInitialized() {
    if (!_initialized || _config == null) {
      throw StateError(
        'SduiService not initialized. Call SduiService.initialize() first.',
      );
    }
  }
}
