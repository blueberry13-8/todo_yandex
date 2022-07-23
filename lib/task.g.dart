// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskContainer _$TaskContainerFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['text', 'importance', 'done', 'updated_at'],
  );
  return TaskContainer(
    text: json['text'] as String,
    importance: $enumDecode(_$TaskImportanceEnumMap, json['importance']),
    deadline: json['deadline'] as int?,
  )
    ..done = json['done'] as bool
    ..lastUpdateTime = json['updated_at'] as int;
}

Map<String, dynamic> _$TaskContainerToJson(TaskContainer instance) =>
    <String, dynamic>{
      'text': instance.text,
      'importance': _$TaskImportanceEnumMap[instance.importance]!,
      'deadline': instance.deadline,
      'done': instance.done,
      'updated_at': instance.lastUpdateTime,
    };

const _$TaskImportanceEnumMap = {
  TaskImportance.low: 'low',
  TaskImportance.basic: 'basic',
  TaskImportance.important: 'important',
};
