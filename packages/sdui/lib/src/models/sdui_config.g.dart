// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdui_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SduiConfig _$SduiConfigFromJson(Map<String, dynamic> json) => SduiConfig(
  appVersionMin: json['app_version_min'] as String,
  themeTokens: ThemeTokens.fromJson(
    json['theme_tokens'] as Map<String, dynamic>,
  ),
  workflows: (json['workflows'] as List<dynamic>)
      .map((e) => Workflow.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SduiConfigToJson(SduiConfig instance) =>
    <String, dynamic>{
      'app_version_min': instance.appVersionMin,
      'theme_tokens': instance.themeTokens,
      'workflows': instance.workflows,
    };
