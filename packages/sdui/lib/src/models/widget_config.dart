import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'action_config.dart';

part 'widget_config.g.dart';

@JsonSerializable()
class WidgetConfig extends Equatable {
  final String type;
  final String? id;
  final String? label;
  final String? style;
  @JsonKey(name: 'props')
  final Map<String, dynamic>? properties;
  final ActionConfig? action;
  final List<ValidationRule>? validators;
  final List<WidgetConfig>? children;

  const WidgetConfig({
    required this.type,
    this.id,
    this.label,
    this.style,
    this.properties,
    this.action,
    this.validators,
    this.children,
  });

  factory WidgetConfig.fromJson(Map<String, dynamic> json) =>
      _$WidgetConfigFromJson(json);

  Map<String, dynamic> toJson() => _$WidgetConfigToJson(this);

  @override
  List<Object?> get props => [
        type,
        id,
        label,
        style,
        properties,
        action,
        validators,
        children,
      ];
}

@JsonSerializable()
class ValidationRule extends Equatable {
  final String type;
  final String? pattern;
  final int? min;
  final int? max;
  final String message;

  const ValidationRule({
    required this.type,
    this.pattern,
    this.min,
    this.max,
    required this.message,
  });

  factory ValidationRule.fromJson(Map<String, dynamic> json) =>
      _$ValidationRuleFromJson(json);

  Map<String, dynamic> toJson() => _$ValidationRuleToJson(this);

  @override
  List<Object?> get props => [type, pattern, min, max, message];
}
