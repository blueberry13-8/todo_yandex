import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
enum TaskImportance {
  @HiveField(0)
  @JsonValue(0)
  low,
  @HiveField(1)
  @JsonValue(1)
  basic,
  @HiveField(2)
  @JsonValue(2)
  important,
}

@HiveType(typeId: 0)
@JsonSerializable()
class TaskContainer {
  @HiveField(0)
  int id = DateTime.now().toUtc().millisecondsSinceEpoch;

  @HiveField(1)
  String text = "";

  @HiveField(2)
  TaskImportance importance = TaskImportance.basic;

  @HiveField(3)
  DateTime? deadline;

  @HiveField(4)
  bool done = false;

  @HiveField(5)
  @JsonKey(name: 'created_at')
  int creationTime = DateTime.now().toUtc().millisecondsSinceEpoch;

  @HiveField(6)
  @JsonKey(name: 'changed_at')
  int lastUpdateTime = DateTime.now().toUtc().millisecondsSinceEpoch;

  TaskContainer({required this.text, required this.importance, this.deadline});

  factory TaskContainer.fromJson(Map<String, dynamic> json) =>
      _$TaskContainerFromJson(json);

  Map<String, dynamic> toJson() => _$TaskContainerToJson(this);
}

enum TaskLocation {
  start,
  middle,
  end,
}

TaskContainer errorTask = TaskContainer(
  text: '~!@!~@~!@~!@@!~@!~87987979834435468',
  importance: TaskImportance.basic,
);