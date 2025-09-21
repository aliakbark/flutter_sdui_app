import 'package:flutter_test/flutter_test.dart';
import 'package:sdui/src/capabilities/capabilities.dart';
import 'package:sdui/src/core/workflow_controller.dart';
import 'package:sdui/src/exceptions/sdui_exceptions.dart';
import 'package:sdui/src/models/action_config.dart';
import 'package:sdui/src/models/widget_config.dart';
import 'package:sdui/src/models/workflow.dart';

import '../helpers/mock_data.dart';

void main() {
  group('SduiWorkflowController', () {
    late SduiWorkflowController controller;
    late Workflow workflow;

    setUp(() {
      SduiCapabilityRegistry.clear();
      workflow = MockData.mockWorkflow;
      controller = SduiWorkflowController(workflow: workflow);
    });

    tearDown(() {
      SduiCapabilityRegistry.clear();
      controller.dispose();
    });

    group('Initialization', () {
      test('should initialize with start screen', () {
        expect(controller.currentScreen, isNotNull);
        expect(controller.currentScreen?.id, equals('welcome_screen'));
        expect(controller.isLoading, isFalse);
        expect(controller.formData, isEmpty);
        expect(controller.fieldErrors, isEmpty);
      });

      test('should call callbacks when provided', () {
        bool completeCalled = false;
        String? errorMessage;

        final controllerWithCallbacks = SduiWorkflowController(
          workflow: workflow,
          onComplete: () => completeCalled = true,
          onError: (error) => errorMessage = error,
        );

        controllerWithCallbacks.complete();
        expect(completeCalled, isTrue);

        controllerWithCallbacks.onError?.call('Test error');
        expect(errorMessage, equals('Test error'));

        controllerWithCallbacks.dispose();
      });
    });

    group('Screen Navigation', () {
      test('should navigate to valid screen', () {
        controller.navigateToScreen('form_screen');

        expect(controller.currentScreen?.id, equals('form_screen'));
      });

      test('should throw exception for invalid screen', () {
        expect(
          () => controller.navigateToScreen('non_existent_screen'),
          throwsA(isA<SduiRenderingException>()),
        );
      });

      test('should clear field errors when navigating', () {
        // Set some field errors
        controller.updateField('email', 'invalid');
        controller.validateField('email', [
          const ValidationRule(type: 'email', message: 'Invalid email'),
        ]);

        expect(controller.fieldErrors, isNotEmpty);

        // Navigate to another screen
        controller.navigateToScreen('form_screen');

        expect(controller.fieldErrors, isEmpty);
      });
    });

    group('Form Data Management', () {
      test('should update and retrieve field values', () {
        controller.updateField('email', 'test@example.com');
        controller.updateField('name', 'John Doe');

        expect(controller.getFieldValue('email'), equals('test@example.com'));
        expect(controller.getFieldValue('name'), equals('John Doe'));
        expect(controller.getFieldValue('non_existent'), isNull);
      });

      test('should clear field error when updating field', () {
        // Set field error
        controller.updateField('email', 'invalid');
        controller.validateField('email', [
          const ValidationRule(type: 'email', message: 'Invalid email'),
        ]);

        expect(controller.getFieldError('email'), isNotNull);

        // Update field should clear error
        controller.updateField('email', 'valid@example.com');

        expect(controller.getFieldError('email'), isNull);
      });

      test('should return immutable copies of data', () {
        controller.updateField('test', 'value');

        final formData = controller.formData;
        final fieldErrors = controller.fieldErrors;

        // These should be unmodifiable
        expect(() => formData['new'] = 'value', throwsUnsupportedError);
        expect(() => fieldErrors['new'] = 'error', throwsUnsupportedError);
      });
    });

    group('Field Validation', () {
      test('should validate individual field', () {
        controller.updateField('email', 'invalid-email');

        final isValid = controller.validateField('email', [
          const ValidationRule(type: 'email', message: 'Invalid email'),
        ]);

        expect(isValid, isFalse);
        expect(controller.getFieldError('email'), equals('Invalid email'));
      });

      test('should pass validation for valid field', () {
        controller.updateField('email', 'valid@example.com');

        final isValid = controller.validateField('email', [
          const ValidationRule(type: 'email', message: 'Invalid email'),
        ]);

        expect(isValid, isTrue);
        expect(controller.getFieldError('email'), isNull);
      });

      test('should validate current screen fields', () {
        // Navigate to form screen which has validation rules
        controller.navigateToScreen('form_screen');

        // Set invalid values
        controller.updateField('email_field', 'invalid');
        controller.updateField('name_field', '');

        final isValid = controller.validateCurrentScreen();

        expect(isValid, isFalse);
        expect(controller.fieldErrors, isNotEmpty);
      });

      test('should pass validation when all fields are valid', () {
        controller.navigateToScreen('form_screen');

        // Set valid values
        controller.updateField('email_field', 'valid@example.com');
        controller.updateField('name_field', 'John Doe');

        final isValid = controller.validateCurrentScreen();

        expect(isValid, isTrue);
        expect(controller.fieldErrors, isEmpty);
      });
    });

    group('Action Execution', () {
      test('should execute capability action successfully', () async {
        // Register a mock capability
        final mockCapability = MockCapability();
        SduiCapabilityRegistry.register(mockCapability);

        const action = ActionConfig(
          type: 'capability.invoke',
          capability: 'mock_capability',
          params: {'test': 'value'},
        );

        await controller.executeAction(action);

        expect(controller.isLoading, isFalse);
      });

      test('should handle capability action failure', () async {
        // Register a mock capability that fails
        final mockCapability = MockErrorCapability();
        SduiCapabilityRegistry.register(mockCapability);

        String? errorMessage;
        final controllerWithError = SduiWorkflowController(
          workflow: workflow,
          onError: (error) => errorMessage = error,
        );

        const action = ActionConfig(
          type: 'capability.invoke',
          capability: 'mock_error',
        );

        await controllerWithError.executeAction(action);

        expect(errorMessage, isNotNull);
        expect(controllerWithError.isLoading, isFalse);

        controllerWithError.dispose();
      });

      test('should execute navigate action', () async {
        const action = ActionConfig(
          type: 'navigate',
          capability: 'form_screen',
        );

        await controller.executeAction(action);

        expect(controller.currentScreen?.id, equals('form_screen'));
      });

      test('should execute show_toast action', () async {
        const action = ActionConfig(
          type: 'show_toast',
          params: {'message': 'Success!'},
        );

        // Should not throw
        await controller.executeAction(action);
        expect(controller.isLoading, isFalse);
      });

      test('should execute show_dialog action', () async {
        const action = ActionConfig(
          type: 'show_dialog',
          params: {'title': 'Alert', 'message': 'Something happened'},
        );

        // Should not throw
        await controller.executeAction(action);
        expect(controller.isLoading, isFalse);
      });

      test('should throw exception for unknown action type', () async {
        const action = ActionConfig(type: 'unknown_action');

        String? errorMessage;
        final controllerWithError = SduiWorkflowController(
          workflow: workflow,
          onError: (error) => errorMessage = error,
        );

        await controllerWithError.executeAction(action);

        expect(errorMessage, contains('Unknown action type'));

        controllerWithError.dispose();
      });

      test('should resolve parameter references', () async {
        final mockCapability = MockCapability();
        SduiCapabilityRegistry.register(mockCapability);

        // Set form data
        controller.updateField('user_email', 'test@example.com');
        controller.updateField('user_name', 'John Doe');

        const action = ActionConfig(
          type: 'capability.invoke',
          capability: 'mock_capability',
          params: {
            'email_ref': 'user_email',
            'name_ref': 'user_name',
            'static_value': 'test',
          },
        );

        await controller.executeAction(action);

        // The capability should have received resolved parameters
        expect(controller.isLoading, isFalse);
      });

      test('should handle action success with workflow completion', () async {
        bool completeCalled = false;
        final controllerWithComplete = SduiWorkflowController(
          workflow: workflow,
          onComplete: () => completeCalled = true,
        );

        const action = ActionConfig(
          type: 'navigate',
          onSuccess: ActionResult(endWorkflow: true),
        );

        await controllerWithComplete.executeAction(action);

        expect(completeCalled, isTrue);

        controllerWithComplete.dispose();
      });
    });

    group('Loading State', () {
      test('should set loading state during action execution', () async {
        final mockCapability = MockSlowCapability();
        SduiCapabilityRegistry.register(mockCapability);

        const action = ActionConfig(
          type: 'capability.invoke',
          capability: 'mock_slow',
        );

        final future = controller.executeAction(action);

        // Should be loading during execution
        expect(controller.isLoading, isTrue);

        await future;

        // Should not be loading after completion
        expect(controller.isLoading, isFalse);
      });
    });

    group('Reset and Complete', () {
      test('should reset workflow to initial state', () {
        // Make some changes
        controller.navigateToScreen('form_screen');
        controller.updateField('email', 'test@example.com');
        controller.validateField('email', [
          const ValidationRule(type: 'required', message: 'Required'),
        ]);

        // Reset
        controller.reset();

        expect(controller.currentScreen?.id, equals('welcome_screen'));
        expect(controller.formData, isEmpty);
        expect(controller.fieldErrors, isEmpty);
        expect(controller.isLoading, isFalse);
      });

      test('should complete workflow', () {
        bool completeCalled = false;
        final controllerWithComplete = SduiWorkflowController(
          workflow: workflow,
          onComplete: () => completeCalled = true,
        );

        controllerWithComplete.complete();

        expect(completeCalled, isTrue);

        controllerWithComplete.dispose();
      });
    });
  });
}

/// Mock capability for testing
class MockCapability extends SduiCapability {
  @override
  String get name => 'mock_capability';

  @override
  Future<SduiCapabilityResult> execute(Map<String, dynamic>? params) async {
    return SduiCapabilityResult.success(data: {'result': 'success'});
  }
}

/// Mock error capability for testing
class MockErrorCapability extends SduiCapability {
  @override
  String get name => 'mock_error';

  @override
  Future<SduiCapabilityResult> execute(Map<String, dynamic>? params) async {
    return SduiCapabilityResult.error('Mock error occurred');
  }
}

/// Mock slow capability for testing loading states
class MockSlowCapability extends SduiCapability {
  @override
  String get name => 'mock_slow';

  @override
  Future<SduiCapabilityResult> execute(Map<String, dynamic>? params) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return SduiCapabilityResult.success(data: {'result': 'slow_success'});
  }
}
