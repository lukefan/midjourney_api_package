// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'midjourney_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImagineResponse _$ImagineResponseFromJson(Map<String, dynamic> json) =>
    ImagineResponse(
      code: (json['code'] as num).toInt(),
      description: json['description'] as String,
      properties: json['properties'] as Map<String, dynamic>,
      result: json['result'],
    );

Map<String, dynamic> _$ImagineResponseToJson(ImagineResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'description': instance.description,
      'properties': instance.properties,
      'result': instance.result,
    };

Button _$ButtonFromJson(Map<String, dynamic> json) => Button(
      customId: json['customId'] as String,
      emoji: json['emoji'] as String,
      label: json['label'] as String,
      style: (json['style'] as num).toInt(),
      type: (json['type'] as num).toInt(),
    );

Map<String, dynamic> _$ButtonToJson(Button instance) => <String, dynamic>{
      'customId': instance.customId,
      'emoji': instance.emoji,
      'label': instance.label,
      'style': instance.style,
      'type': instance.type,
    };

TaskStatus _$TaskStatusFromJson(Map<String, dynamic> json) => TaskStatus(
      id: json['id'] as String,
      status: json['status'] as String,
      progress: json['progress'] as String,
      failReason: json['failReason'] as String?,
      buttons: (json['buttons'] as List<dynamic>?)
          ?.map((e) => Button.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$TaskStatusToJson(TaskStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'progress': instance.progress,
      'failReason': instance.failReason,
      'buttons': instance.buttons,
      'imageUrl': instance.imageUrl,
    };

ActionRequest _$ActionRequestFromJson(Map<String, dynamic> json) =>
    ActionRequest(
      chooseSameChannel: json['chooseSameChannel'] as bool,
      customId: json['customId'] as String,
      taskId: json['taskId'] as String,
      accountFilter: json['accountFilter'] as Map<String, dynamic>,
      notifyHook: json['notifyHook'] as String,
      state: json['state'] as String,
    );

Map<String, dynamic> _$ActionRequestToJson(ActionRequest instance) =>
    <String, dynamic>{
      'chooseSameChannel': instance.chooseSameChannel,
      'customId': instance.customId,
      'taskId': instance.taskId,
      'accountFilter': instance.accountFilter,
      'notifyHook': instance.notifyHook,
      'state': instance.state,
    };
