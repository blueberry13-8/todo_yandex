import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:todo_yandex/model/task.dart';

final localTasksProvider = Provider((ref) => LocalTasks());

class LocalTasks {
  Future<void> addTaskLocal(TaskContainer task) async {
    await Hive.lazyBox<TaskContainer>('box_for_tasks').add(task);
  }

  Future<void> editTaskLocal(TaskContainer task, int index) async {
    await Hive.lazyBox<TaskContainer>('box_for_tasks').putAt(index, task);
  }

  Future<void> deleteTaskLocal(int index) async {
    await Hive.lazyBox<TaskContainer>('box_for_tasks').deleteAt(index);
  }

  Future<List<TaskContainer>> getTaskListLocal() async {
    List<TaskContainer> list = [];
    for (int i = 0;
        i < Hive.lazyBox<TaskContainer>('box_for_tasks').length;
        i++) {
      list.add((await Hive.lazyBox<TaskContainer>('box_for_tasks').getAt(i))!);
    }
    return list;
  }

  Future<int> getDoneNumLocal() async {
    int res = 0;
    for (int i = 0;
        i < Hive.lazyBox<TaskContainer>('box_for_tasks').length;
        i++) {
      if ((await Hive.lazyBox<TaskContainer>('box_for_tasks').getAt(i))!.done) {
        res++;
      }
    }
    return res;
  }

  static var lBox = Hive.lazyBox<TaskContainer>('box_for_tasks');
}
