import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'widget_config.dart';

part 'workflow.g.dart';

@JsonSerializable()
class Workflow extends Equatable {
  final String id;

  @JsonKey(name: 'start_screen')
  final String startScreen;

  final List<SduiScreen> screens;

  const Workflow({
    required this.id,
    required this.startScreen,
    required this.screens,
  });

  factory Workflow.fromJson(Map<String, dynamic> json) =>
      _$WorkflowFromJson(json);

  Map<String, dynamic> toJson() => _$WorkflowToJson(this);

  SduiScreen? getScreen(String screenId) {
    try {
      return screens.firstWhere((screen) => screen.id == screenId);
    } catch (e) {
      return null;
    }
  }

  SduiScreen? getStartScreen() => getScreen(startScreen);

  @override
  List<Object?> get props => [id, startScreen, screens];
}

@JsonSerializable()
class SduiScreen extends Equatable {
  final String id;
  final String title;
  final List<WidgetConfig> widgets;

  const SduiScreen({
    required this.id,
    required this.title,
    required this.widgets,
  });

  factory SduiScreen.fromJson(Map<String, dynamic> json) =>
      _$SduiScreenFromJson(json);

  Map<String, dynamic> toJson() => _$SduiScreenToJson(this);

  @override
  List<Object?> get props => [id, title, widgets];
}
