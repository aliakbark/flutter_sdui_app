// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionConfig _$ActionConfigFromJson(Map<String, dynamic> json) => ActionConfig(
  type: json['type'] as String,
  capability: json['capability'] as String?,
  params: json['params'] as Map<String, dynamic>?,
  onSuccess: json['on_success'] == null
      ? null
      : ActionResult.fromJson(json['on_success'] as Map<String, dynamic>),
  onError: json['on_error'] == null
      ? null
      : ActionResult.fromJson(json['on_error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ActionConfigToJson(ActionConfig instance) =>
    <String, dynamic>{
      'type': instance.type,
      'capability': instance.capability,
      'params': instance.params,
      'on_success': instance.onSuccess,
      'on_error': instance.onError,
    };

ActionResult _$ActionResultFromJson(Map<String, dynamic> json) => ActionResult(
  navigate: json['navigate'] as String?,
  showToast: json['show_toast'] as String?,
  showDialog: json['show_dialog'] == null
      ? null
      : DialogConfig.fromJson(json['show_dialog'] as Map<String, dynamic>),
  endWorkflow: json['end_workflow'] as bool?,
);

Map<String, dynamic> _$ActionResultToJson(ActionResult instance) =>
    <String, dynamic>{
      'navigate': instance.navigate,
      'show_toast': instance.showToast,
      'show_dialog': instance.showDialog,
      'end_workflow': instance.endWorkflow,
    };

DialogConfig _$DialogConfigFromJson(Map<String, dynamic> json) =>
    DialogConfig(title: json['title'] as String, body: json['body'] as String);

Map<String, dynamic> _$DialogConfigToJson(DialogConfig instance) =>
    <String, dynamic>{'title': instance.title, 'body': instance.body};
