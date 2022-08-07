// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskContainerAdapter extends TypeAdapter<TaskContainer> {
  @override
  final int typeId = 0;

  @override
  TaskContainer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskContainer(
      text: fields[1] as String,
      importance: fields[2] as TaskImportance,
      deadline: fields[3] as DateTime?,
    )
      ..id = fields[0] as int
      ..done = fields[4] as bool
      ..creationTime = fields[5] as int
      ..lastUpdateTime = fields[6] as int;
  }

  @override
  void write(BinaryWriter writer, TaskContainer obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.importance)
      ..writeByte(3)
      ..write(obj.deadline)
      ..writeByte(4)
      ..write(obj.done)
      ..writeByte(5)
      ..write(obj.creationTime)
      ..writeByte(6)
      ..write(obj.lastUpdateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskContainerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskImportanceAdapter extends TypeAdapter<TaskImportance> {
  @override
  final int typeId = 1;

  @override
  TaskImportance read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskImportance.low;
      case 1:
        return TaskImportance.basic;
      case 2:
        return TaskImportance.important;
      default:
        return TaskImportance.low;
    }
  }

  @override
  void write(BinaryWriter writer, TaskImportance obj) {
    switch (obj) {
      case TaskImportance.low:
        writer.writeByte(0);
        break;
      case TaskImportance.basic:
        writer.writeByte(1);
        break;
      case TaskImportance.important:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskImportanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskContainer _$TaskContainerFromJson(Map<String, dynamic> json) =>
    TaskContainer(
      text: json['text'] as String,
      importance: $enumDecode(_$TaskImportanceEnumMap, json['importance']),
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
    )
      ..id = json['id'] as int
      ..done = json['done'] as bool
      ..creationTime = json['created_at'] as int
      ..lastUpdateTime = json['changed_at'] as int;

Map<String, dynamic> _$TaskContainerToJson(TaskContainer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'importance': _$TaskImportanceEnumMap[instance.importance]!,
      'deadline': instance.deadline?.toIso8601String(),
      'done': instance.done,
      'created_at': instance.creationTime,
      'changed_at': instance.lastUpdateTime,
    };

const _$TaskImportanceEnumMap = {
  TaskImportance.low: 0,
  TaskImportance.basic: 1,
  TaskImportance.important: 2,
};
