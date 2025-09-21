import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/sdui_config.dart';
import '../exceptions/sdui_exceptions.dart';

class SduiParser {
  /// Load and parse SDUI configuration from asset
  static Future<SduiConfig> loadFromAsset(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return SduiConfig.fromJson(jsonMap);
    } catch (e) {
      throw SduiParsingException('Failed to load config from asset: $e');
    }
  }

  /// Load and parse SDUI configuration from network
  static Future<SduiConfig> loadFromNetwork(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode != 200) {
        throw SduiParsingException(
          'Failed to load config from network: ${response.statusCode}',
        );
      }

      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      return SduiConfig.fromJson(jsonMap);
    } catch (e) {
      if (e is SduiParsingException) rethrow;
      throw SduiParsingException('Failed to load config from network: $e');
    }
  }

  /// Parse SDUI configuration from JSON map
  static SduiConfig parseFromJson(Map<String, dynamic> json) {
    try {
      return SduiConfig.fromJson(json);
    } catch (e) {
      throw SduiParsingException('Failed to parse SDUI config: $e');
    }
  }

  /// Mock network response for testing
  static Future<SduiConfig> loadFromMockNetwork() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return the same config as the asset for demo purposes
    return loadFromAsset('assets/json/dynamic_ui_config.json');
  }
}
