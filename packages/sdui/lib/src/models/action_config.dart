import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'action_config.g.dart';

@JsonSerializable()
class ActionConfig extends Equatable {
  final String type;
  final String? capability;
  final Map<String, dynamic>? params;
  
  @JsonKey(name: 'on_success')
  final ActionResult? onSuccess;
  
  @JsonKey(name: 'on_error')
  final ActionResult? onError;

  const ActionConfig({
    required this.type,
    this.capability,
    this.params,
    this.onSuccess,
    this.onError,
  });

  factory ActionConfig.fromJson(Map<String, dynamic> json) =>
      _$ActionConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ActionConfigToJson(this);

  @override
  List<Object?> get props => [type, capability, params, onSuccess, onError];
}

@JsonSerializable()
class ActionResult extends Equatable {
  final String? navigate;
  
  @JsonKey(name: 'show_toast')
  final String? showToast;
  
  @JsonKey(name: 'show_dialog')
  final DialogConfig? showDialog;
  
  @JsonKey(name: 'end_workflow')
  final bool? endWorkflow;

  const ActionResult({
    this.navigate,
    this.showToast,
    this.showDialog,
    this.endWorkflow,
  });

  factory ActionResult.fromJson(Map<String, dynamic> json) =>
      _$ActionResultFromJson(json);

  Map<String, dynamic> toJson() => _$ActionResultToJson(this);

  @override
  List<Object?> get props => [navigate, showToast, showDialog, endWorkflow];
}

@JsonSerializable()
class DialogConfig extends Equatable {
  final String title;
  final String body;

  const DialogConfig({
    required this.title,
    required this.body,
  });

  factory DialogConfig.fromJson(Map<String, dynamic> json) =>
      _$DialogConfigFromJson(json);

  Map<String, dynamic> toJson() => _$DialogConfigToJson(this);

  @override
  List<Object?> get props => [title, body];
}
