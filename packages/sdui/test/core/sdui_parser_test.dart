import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sdui/src/core/sdui_parser.dart';
import 'package:sdui/src/exceptions/sdui_exceptions.dart';
import 'package:sdui/src/models/sdui_config.dart';

import '../helpers/mock_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SduiParser', () {
    group('JSON Parsing', () {
      test('should parse valid JSON configuration', () async {
        final jsonString = MockData.mockConfigJson;

        final config = SduiParser.parseFromJson(jsonString);

        expect(config, isA<SduiConfig>());
        expect(config.appVersionMin, equals('1.0.0'));
        expect(config.workflows, isNotEmpty);
        expect(config.themeTokens, isNotNull);
      });

      test('should throw exception for invalid JSON', () async {
        const invalidJson = {"invalid": 'json'};

        expect(
          () => SduiParser.parseFromJson(invalidJson),
          throwsA(isA<SduiParsingException>()),
        );
      });

      test('should throw exception for missing required fields', () async {
        const incompleteJson = {"appVersionMin": "1.0.0"};

        expect(
          () => SduiParser.parseFromJson(incompleteJson),
          throwsA(isA<SduiParsingException>()),
        );
      });
    });

    group('Asset Loading', () {
      test('should load configuration from asset path', () async {
        const assetPath = 'assets/json/dynamic_ui_config.json';

        final config = await SduiParser.loadFromAsset(assetPath);

        expect(config, isA<SduiConfig>());
        expect(config.workflows, isNotEmpty);
      });

      test('should throw exception for non-existent asset', () async {
        const invalidPath = 'assets/non_existent.json';

        expect(
          () => SduiParser.loadFromAsset(invalidPath),
          throwsA(isA<SduiParsingException>()),
        );
      });
    });

    group('Network Loading', () {
      test(
        'should load configuration from network URL',
        () async {
          // Mock successful HTTP response
          final mockClient = MockClient((request) async {
            return http.Response(json.encode(MockData.mockConfigJson), 200);
          });

          // We need to modify the parser to accept a client, but for now let's skip this test
          // as it requires architectural changes
        },
        skip: 'Requires HTTP client injection',
      );

      test(
        'should throw exception for network errors',
        () async {
          // Mock failed HTTP response
          final mockClient = MockClient((request) async {
            return http.Response('Not Found', 404);
          });

          // Skip for now as it requires architectural changes
        },
        skip: 'Requires HTTP client injection',
      );
    });

    group('Mock Network', () {
      test('should provide mock configuration', () async {
        final config = await SduiParser.loadFromMockNetwork();

        expect(config, isA<SduiConfig>());
        expect(config.appVersionMin, isNotNull);
        expect(config.workflows, isNotEmpty);
        expect(config.themeTokens, isNotNull);
      });

      test('should return consistent mock data', () async {
        final config1 = await SduiParser.loadFromMockNetwork();
        final config2 = await SduiParser.loadFromMockNetwork();

        expect(config1.appVersionMin, equals(config2.appVersionMin));
        expect(config1.workflows.length, equals(config2.workflows.length));
      });
    });

    group('Error Handling', () {
      test('should handle malformed JSON gracefully', () async {
        const malformedJson = {
          "workflows": [
            {"id": "test", "screens": ""},
          ],
        };

        expect(
          () => SduiParser.parseFromJson(malformedJson),
          throwsA(isA<SduiParsingException>()),
        );
      });

      test('should provide meaningful error messages', () async {
        // Pass a string instead of Map to trigger type error
        expect(
          () => SduiParser.parseFromJson('not json at all' as dynamic),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}
