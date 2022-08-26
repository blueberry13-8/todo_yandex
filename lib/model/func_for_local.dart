import 'package:hive/hive.dart';
import 'package:todo_yandex/model/task.dart';

class LocalTasks {
  static Future<void> addTaskLocal(TaskContainer task) async {
    await Hive.lazyBox<TaskContainer>('box_for_tasks').add(task);
  }

  static Future<void> editTaskLocal(TaskContainer task, int index) async {
    await Hive.lazyBox<TaskContainer>('box_for_tasks').putAt(index, task);
  }

  static Future<void> deleteTaskLocal(int index) async {
    await Hive.lazyBox<TaskContainer>('box_for_tasks').deleteAt(index);
  }

  static Future<List<TaskContainer>> getTaskListLocal() async {
    List<TaskContainer> list = [];
    for (int i = 0;
        i < Hive.lazyBox<TaskContainer>('box_for_tasks').length;
        i++) {
      list.add((await Hive.lazyBox<TaskContainer>('box_for_tasks').getAt(i))!);
    }
    return list;
  }

  static Future<int> getDoneNumLocal() async {
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
