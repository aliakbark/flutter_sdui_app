import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'workflow.dart';
import 'theme_tokens.dart';

part 'sdui_config.g.dart';

@JsonSerializable()
class SduiConfig extends Equatable {
  @JsonKey(name: 'app_version_min')
  final String appVersionMin;
  
  @JsonKey(name: 'theme_tokens')
  final ThemeTokens themeTokens;
  
  final List<Workflow> workflows;

  const SduiConfig({
    required this.appVersionMin,
    required this.themeTokens,
    required this.workflows,
  });

  factory SduiConfig.fromJson(Map<String, dynamic> json) =>
      _$SduiConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SduiConfigToJson(this);

  Workflow? getWorkflow(String workflowId) {
    try {
      return workflows.firstWhere((workflow) => workflow.id == workflowId);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [appVersionMin, themeTokens, workflows];
}
