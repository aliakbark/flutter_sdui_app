import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sdui/src/core/sdui_service.dart';
import 'package:sdui/src/models/sdui_config.dart';
import 'package:sdui/src/widgets/sdui_workflow_widget.dart';

import '../helpers/mock_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SduiService', () {
    setUp(() {
      SduiService.reset();
    });

    tearDown(() {
      SduiService.reset();
    });

    group('Initialization', () {
      test('should initialize with config', () async {
        final config = MockData.mockSduiConfig;

        await SduiService.initialize(config: config);

        expect(SduiService.isInitialized, isTrue);
        expect(SduiService.config, equals(config));
      });

      test('should initialize with mock network', () async {
        await SduiService.initializeWithMockNetwork();

        expect(SduiService.isInitialized, isTrue);
        expect(SduiService.config, isNotNull);
      });

      test('should throw error when no parameters provided', () async {
        expect(() => SduiService.initialize(), throwsA(isA<ArgumentError>()));
      });

      test('should not be initialized initially', () {
        expect(SduiService.isInitialized, isFalse);
        expect(SduiService.config, isNull);
      });
    });

    group('Workflow Management', () {
      setUp(() async {
        await SduiService.initialize(config: MockData.mockSduiConfig);
      });

      test('should get workflow by ID', () {
        final workflow = SduiService.getWorkflow('user_onboarding');

        expect(workflow, isNotNull);
        expect(workflow!.id, equals('user_onboarding'));
      });

      test('should return null for non-existent workflow', () {
        final workflow = SduiService.getWorkflow('non_existent');

        expect(workflow, isNull);
      });

      test('should get available workflow IDs', () {
        final workflowIds = SduiService.getAvailableWorkflows();

        expect(workflowIds, contains('user_onboarding'));
        expect(workflowIds.length, equals(1));
      });
    });

    group('Widget Creation', () {
      setUp(() async {
        await SduiService.initialize(config: MockData.mockSduiConfig);
      });

      testWidgets('should create workflow widget', (WidgetTester tester) async {
        final widget = SduiService.createWorkflowWidget(
          workflowId: 'user_onboarding',
        );

        expect(widget, isNotNull);

        await tester.pumpWidget(MaterialApp(home: widget));
        expect(find.byType(SduiWorkflowWidget), findsOneWidget);
      });

      testWidgets('should show error for non-existent workflow', (
        WidgetTester tester,
      ) async {
        final widget = SduiService.createWorkflowWidget(
          workflowId: 'non_existent',
        );

        await tester.pumpWidget(MaterialApp(home: widget));
        expect(find.text('Workflow not found: non_existent'), findsOneWidget);
      });
    });

    group('Error Handling', () {
      test('should throw error when accessing uninitialized service', () {
        expect(
          () => SduiService.getWorkflow('test'),
          throwsA(isA<StateError>()),
        );
      });

      test(
        'should throw error when creating widget from uninitialized service',
        () {
          expect(
            () => SduiService.createWorkflowWidget(workflowId: 'test'),
            throwsA(isA<StateError>()),
          );
        },
      );
    });

    group('Service Management', () {
      test('should reload configuration', () async {
        await SduiService.initialize(config: MockData.mockSduiConfig);
        expect(SduiService.isInitialized, isTrue);

        final newConfig = SduiConfig(
          appVersionMin: '2.0.0',
          themeTokens: MockData.mockThemeTokens,
          workflows: [],
        );

        await SduiService.reload(config: newConfig);

        expect(SduiService.config!.appVersionMin, equals('2.0.0'));
        expect(SduiService.config!.workflows, isEmpty);
      });

      test('should reset service state', () async {
        await SduiService.initialize(config: MockData.mockSduiConfig);
        expect(SduiService.isInitialized, isTrue);

        SduiService.reset();

        expect(SduiService.isInitialized, isFalse);
        expect(SduiService.config, isNull);
      });
    });
  });
}
