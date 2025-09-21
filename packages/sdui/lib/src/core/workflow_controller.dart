import 'package:flutter/material.dart';
import 'package:sdui/src/capabilities/capabilities.dart';
import 'package:sdui/src/exceptions/sdui_exceptions.dart';
import 'package:sdui/src/models/action_config.dart';
import 'package:sdui/src/models/widget_config.dart';
import 'package:sdui/src/models/workflow.dart';
import 'package:sdui/src/validation/field_validator.dart';

/// Controller for managing workflow state and navigation
class SduiWorkflowController extends ChangeNotifier {
  final Workflow workflow;
  final VoidCallback? onComplete;
  final Function(String)? onError;

  SduiScreen? _currentScreen;
  final Map<String, String> _formData = {};
  final Map<String, String> _fieldErrors = {};
  bool _isLoading = false;

  SduiWorkflowController({
    required this.workflow,
    this.onComplete,
    this.onError,
  }) {
    _currentScreen = workflow.getStartScreen();
  }

  // Getters
  SduiScreen? get currentScreen => _currentScreen;

  Map<String, String> get formData => Map.unmodifiable(_formData);

  Map<String, String> get fieldErrors => Map.unmodifiable(_fieldErrors);

  bool get isLoading => _isLoading;

  /// Navigate to a specific screen within the workflow
  void navigateToScreen(String screenId) {
    final SduiScreen? screen = workflow.getScreen(screenId);
    if (screen != null) {
      _currentScreen = screen;
      _clearFieldErrors();
      notifyListeners();
    } else {
      throw SduiRenderingException('Screen not found: $screenId');
    }
  }

  /// Update form field value
  void updateField(String fieldId, String value) {
    _formData[fieldId] = value;

    // Clear error for this field when user starts typing
    if (_fieldErrors.containsKey(fieldId)) {
      _fieldErrors.remove(fieldId);
      notifyListeners();
    }
  }

  /// Get form field value
  String? getFieldValue(String fieldId) {
    return _formData[fieldId];
  }

  /// Get field error message
  String? getFieldError(String fieldId) {
    return _fieldErrors[fieldId];
  }

  /// Validate a specific field
  bool validateField(String fieldId, List<ValidationRule>? rules) {
    final value = _formData[fieldId];
    final error = FieldValidator.validate(value, rules);

    if (error != null) {
      _fieldErrors[fieldId] = error;
      notifyListeners();
      return false;
    } else {
      _fieldErrors.remove(fieldId);
      return true;
    }
  }

  /// Validate all fields in the current screen
  bool validateCurrentScreen() {
    if (_currentScreen == null) return true;

    bool isValid = true;
    _fieldErrors.clear();

    for (final widget in _currentScreen!.widgets) {
      if (widget.id != null && widget.validators != null) {
        final bool fieldValid = validateField(widget.id!, widget.validators);
        if (!fieldValid) isValid = false;
      }
    }

    notifyListeners();
    return isValid;
  }

  /// Execute an action
  Future<void> executeAction(ActionConfig action) async {
    try {
      _setLoading(true);

      switch (action.type) {
        case 'capability.invoke':
          await _executeCapabilityAction(action);
          break;
        case 'navigate':
          _executeNavigateAction(action);
          break;
        case 'show_toast':
          _executeShowToastAction(action);
          break;
        case 'show_dialog':
          _executeShowDialogAction(action);
          break;
        default:
          throw SduiRenderingException('Unknown action type: ${action.type}');
      }
    } catch (e) {
      _handleActionError(e.toString(), action.onError);
    } finally {
      _setLoading(false);
    }
  }

  /// Execute capability action
  Future<void> _executeCapabilityAction(ActionConfig action) async {
    if (action.capability == null) {
      throw SduiCapabilityException('Capability name is required');
    }

    // Resolve parameter references
    final Map<String, dynamic> resolvedParams = _resolveActionParams(
      action.params ?? <String, dynamic>{},
    );

    try {
      final SduiCapabilityResult result = await SduiCapabilityRegistry.execute(
        action.capability!,
        resolvedParams,
      );

      if (result.isSuccess) {
        _handleActionSuccess(action.onSuccess, result.message);
      } else {
        _handleActionError(
          result.message ?? 'Capability execution failed',
          action.onError,
        );
      }
    } catch (e) {
      _handleActionError(e.toString(), action.onError);
    }
  }

  /// Execute navigate action
  void _executeNavigateAction(ActionConfig action) {
    // Navigate to the screen specified in capability field
    if (action.capability != null) {
      navigateToScreen(action.capability!);
    }
    
    // Also handle success result if provided
    _handleActionSuccess(action.onSuccess, null);
  }

  /// Execute show toast action
  void _executeShowToastAction(ActionConfig action) {
    // This would be handled by the parent widget
    _handleActionSuccess(action.onSuccess, null);
  }

  /// Execute show dialog action
  void _executeShowDialogAction(ActionConfig action) {
    // This would be handled by the parent widget
    _handleActionSuccess(action.onSuccess, null);
  }

  /// Handle action success
  void _handleActionSuccess(ActionResult? successResult, String? message) {
    if (successResult == null) return;

    if (successResult.navigate != null) {
      navigateToScreen(successResult.navigate!);
    }

    if (successResult.endWorkflow == true) {
      onComplete?.call();
    }

    // Toast and dialog handling would be done by parent widget
  }

  /// Handle action error
  void _handleActionError(String errorMessage, ActionResult? errorResult) {
    onError?.call(errorMessage);

    if (errorResult?.showToast != null) {
      // Handle error toast
    }

    if (errorResult?.showDialog != null) {
      // Handle error dialog
    }
  }

  /// Resolve parameter references in action params
  Map<String, dynamic> _resolveActionParams(Map<String, dynamic> params) {
    final Map<String, dynamic> resolved = <String, dynamic>{};

    for (final entry in params.entries) {
      final String key = entry.key;
      final dynamic value = entry.value;

      if (key.endsWith('_ref') && value is String) {
        // This is a reference to a form field
        // Convert "phone_ref" -> "phone" and resolve the field value
        final String paramName = key.replaceAll('_ref', '');
        final String fieldId = value;
        resolved[paramName] = _formData[fieldId];
      } else {
        resolved[key] = value;
      }
    }

    return resolved;
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Clear all field errors
  void _clearFieldErrors() {
    _fieldErrors.clear();
  }

  /// Reset workflow to start screen
  void reset() {
    _currentScreen = workflow.getStartScreen();
    _formData.clear();
    _fieldErrors.clear();
    _isLoading = false;
    notifyListeners();
  }

  /// Complete the workflow
  void complete() {
    onComplete?.call();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
