// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workflow _$WorkflowFromJson(Map<String, dynamic> json) => Workflow(
  id: json['id'] as String,
  startScreen: json['start_screen'] as String,
  screens: (json['screens'] as List<dynamic>)
      .map((e) => SduiScreen.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WorkflowToJson(Workflow instance) => <String, dynamic>{
  'id': instance.id,
  'start_screen': instance.startScreen,
  'screens': instance.screens,
};

SduiScreen _$SduiScreenFromJson(Map<String, dynamic> json) => SduiScreen(
  id: json['id'] as String,
  title: json['title'] as String,
  widgets: (json['widgets'] as List<dynamic>)
      .map((e) => WidgetConfig.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SduiScreenToJson(SduiScreen instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'widgets': instance.widgets,
    };
