import 'package:sdui/src/models/widget_config.dart';
import 'package:sdui/src/exceptions/sdui_exceptions.dart';

class FieldValidator {
  /// Validate a field value against a list of validation rules
  static String? validate(String? value, List<ValidationRule>? rules) {
    if (rules == null || rules.isEmpty) return null;

    for (final rule in rules) {
      final error = _validateRule(value, rule);
      if (error != null) return error;
    }

    return null;
  }

  /// Validate a single rule
  static String? _validateRule(String? value, ValidationRule rule) {
    switch (rule.type.toLowerCase()) {
      case 'required':
        return _validateRequired(value, rule.message);
      case 'regex':
        return _validateRegex(value, rule.pattern, rule.message);
      case 'length':
        return _validateLength(value, rule.min, rule.max, rule.message);
      case 'email':
        return _validateEmail(value, rule.message);
      case 'phone':
        return _validatePhone(value, rule.message);
      default:
        throw SduiValidationException(
          'Unknown validation rule type: ${rule.type}',
        );
    }
  }

  /// Validate required field
  static String? _validateRequired(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  /// Validate regex pattern
  static String? _validateRegex(
    String? value,
    String? pattern,
    String message,
  ) {
    if (value == null || value.isEmpty) return null;
    if (pattern == null) return null;

    try {
      final regex = RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return message;
      }
    } catch (e) {
      throw SduiValidationException('Invalid regex pattern: $pattern');
    }

    return null;
  }

  /// Validate length constraints
  static String? _validateLength(
    String? value,
    int? min,
    int? max,
    String message,
  ) {
    if (value == null) return null;

    final length = value.length;

    if (min != null && length < min) {
      return message;
    }

    if (max != null && length > max) {
      return message;
    }

    return null;
  }

  /// Validate email format
  static String? _validateEmail(String? value, String message) {
    if (value == null || value.isEmpty) return null;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return message;
    }

    return null;
  }

  /// Validate phone number format
  static String? _validatePhone(String? value, String message) {
    if (value == null || value.isEmpty) return null;

    // Basic phone validation - can be customized
    final phoneRegex = RegExp(r'^\+?[0-9]{9,15}$');

    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s-()]'), ''))) {
      return message;
    }

    return null;
  }

  /// Validate multiple fields at once
  static Map<String, String> validateFields(
    Map<String, String?> fieldValues,
    Map<String, List<ValidationRule>> fieldRules,
  ) {
    final errors = <String, String>{};

    for (final entry in fieldValues.entries) {
      final fieldId = entry.key;
      final value = entry.value;
      final rules = fieldRules[fieldId];

      final error = validate(value, rules);
      if (error != null) {
        errors[fieldId] = error;
      }
    }

    return errors;
  }
}
