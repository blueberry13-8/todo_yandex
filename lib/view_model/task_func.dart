import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:todo_yandex/model/func_for_local.dart';
import 'package:todo_yandex/model/task.dart';
import 'package:todo_yandex/model/func_for_backend.dart';

class TaskFunctions {
  static Future<int> checkRevision() async {
    int fromAPI = await API.getRevision();
    if (fromAPI == -1) {
      return -1;
    }
    int localRevision;
    try {
      localRevision = Hive.box<int>('revision').getAt(0)!;
    } catch (e){
      localRevision = 0;
    }
    if (fromAPI == localRevision) {
      return 0;
    }
    if (fromAPI > localRevision) {
      return 1;
    }
    return -1;
  }

  static Future<void> updateLocalRevision() async {
    await Hive.box<int>('revision').clear();
    await Hive.box<int>('revision').add(await API.getRevision());
  }

  static Future<void> resolveQueue() async {
    if ((await checkRevision()) == 1) {
      debugPrint('резолвим');
      await Hive.lazyBox<TaskContainer>('box_for_tasks').clear();
      List<TaskContainer> list = await API.getTasksList();
      await updateLocalRevision();
      for (var x in list) {
        await LocalTasks.addTaskLocal(x);
        //await Hive.lazyBox<TaskContainer>('box_for_tasks').add(x);
      }
      return;
    }
    while (API.queueBox.isNotEmpty) {
      Map<String, dynamic> item = (await API.queueBox.getAt(0))!;
      if (item.containsKey('addTask')) {
        API.addTask(TaskContainer.fromJson(item['addTask']));
      } else if (item.containsKey('editTask')) {
        API.editTask(TaskContainer.fromJson(item['editTask']));
      } else {
        API.deleteTask(TaskContainer.fromJson(item['deleteTask']));
      }
      await API.queueBox.deleteAt(0);
    }
  }

  static Future<void> saveNewTask(
      DateTime? deadline, TaskImportance importance, String text) async {
    TaskContainer task = TaskContainer(text: text, importance: importance);
    if (deadline != null) {
      task.deadline = deadline.millisecondsSinceEpoch;
      task.deadlineDate = deadline;
    }
    await LocalTasks.addTaskLocal(task);
    await API.addTask(task);
  }

  static Future<void> saveExistsTask(TaskContainer task, int index) async {
    task.lastUpdateTime = DateTime.now().millisecondsSinceEpoch;
    await LocalTasks.editTaskLocal(task, index);
    await API.editTask(task);
  }

  static Future<void> deleteTask(int index, TaskContainer task) async {
    await LocalTasks.deleteTaskLocal(index);
    await API.deleteTask(task);
  }
}
