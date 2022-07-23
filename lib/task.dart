import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

enum TaskImportance {
  low,
  basic,
  important,
}

@JsonSerializable()
class TaskContainer {
  @JsonKey(name: 'id', required: true)
  late final id = const Uuid().v1();
  @JsonKey(name: 'text', required: true)
  String text = "";
  @JsonKey(name: 'importance', required: true)
  TaskImportance importance = TaskImportance.basic;
  @JsonKey(name: 'deadline', required: false)
  int? deadline;
  @JsonKey(name: 'done', required: true)
  bool done = false;
  @JsonKey(name: 'created_at', required: true)
  final creationTime = DateTime.now().toUtc().millisecondsSinceEpoch;
  @JsonKey(name: 'updated_at', required: true)
  var lastUpdateTime = DateTime.now().toUtc().millisecondsSinceEpoch;

  TaskContainer(
      {required this.text,
      required this.importance,
      this.deadline}) {
//    id = const Uuid().v1();
  }

  factory TaskContainer.fromJson(Map<String, dynamic> json) =>
      _$TaskContainerFromJson(json);

  Map<String, dynamic> toJson() => _$TaskContainerToJson(this);
}
