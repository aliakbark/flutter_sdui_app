// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WidgetConfig _$WidgetConfigFromJson(Map<String, dynamic> json) => WidgetConfig(
  type: json['type'] as String,
  id: json['id'] as String?,
  label: json['label'] as String?,
  style: json['style'] as String?,
  properties: json['props'] as Map<String, dynamic>?,
  action: json['action'] == null
      ? null
      : ActionConfig.fromJson(json['action'] as Map<String, dynamic>),
  validators: (json['validators'] as List<dynamic>?)
      ?.map((e) => ValidationRule.fromJson(e as Map<String, dynamic>))
      .toList(),
  children: (json['children'] as List<dynamic>?)
      ?.map((e) => WidgetConfig.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WidgetConfigToJson(WidgetConfig instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'label': instance.label,
      'style': instance.style,
      'props': instance.properties,
      'action': instance.action,
      'validators': instance.validators,
      'children': instance.children,
    };

ValidationRule _$ValidationRuleFromJson(Map<String, dynamic> json) =>
    ValidationRule(
      type: json['type'] as String,
      pattern: json['pattern'] as String?,
      min: (json['min'] as num?)?.toInt(),
      max: (json['max'] as num?)?.toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$ValidationRuleToJson(ValidationRule instance) =>
    <String, dynamic>{
      'type': instance.type,
      'pattern': instance.pattern,
      'min': instance.min,
      'max': instance.max,
      'message': instance.message,
    };
