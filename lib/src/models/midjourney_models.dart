import 'package:json_annotation/json_annotation.dart';

part 'midjourney_models.g.dart';

@JsonSerializable()
class ImagineResponse {
  final int code;
  final String description;
  final Map<String, dynamic> properties;
  final dynamic result;

  ImagineResponse({
    required this.code,
    required this.description,
    required this.properties,
    required this.result,
  });

  factory ImagineResponse.fromJson(Map<String, dynamic> json) =>
      _$ImagineResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$ImagineResponseToJson(this);
}

@JsonSerializable()
class Button {
  final String customId;
  final String emoji;
  final String label;
  final int style;
  final int type;

  Button({
    required this.customId,
    required this.emoji,
    required this.label,
    required this.style,
    required this.type,
  });

  factory Button.fromJson(Map<String, dynamic> json) => _$ButtonFromJson(json);
  
  Map<String, dynamic> toJson() => _$ButtonToJson(this);
}

@JsonSerializable()
class TaskStatus {
  final String id;
  final String status;
  final String progress;
  final String? failReason;
  final List<Button>? buttons;

  TaskStatus({
    required this.id,
    required this.status,
    required this.progress,
    this.failReason,
    this.buttons,
  });

  factory TaskStatus.fromJson(Map<String, dynamic> json) =>
      _$TaskStatusFromJson(json);
  
  Map<String, dynamic> toJson() => _$TaskStatusToJson(this);
}

@JsonSerializable()
class ActionRequest {
  final bool chooseSameChannel;
  final String customId;
  final String taskId;
  final Map<String, dynamic> accountFilter;
  final String notifyHook;
  final String state;

  ActionRequest({
    required this.chooseSameChannel,
    required this.customId,
    required this.taskId,
    required this.accountFilter,
    required this.notifyHook,
    required this.state,
  });

  Map<String, dynamic> toJson() => _$ActionRequestToJson(this);
} 