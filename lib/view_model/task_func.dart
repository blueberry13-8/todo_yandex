import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:todo_yandex/model/func_for_local.dart';
import 'package:todo_yandex/model/task.dart';
import 'package:todo_yandex/model/func_for_backend.dart';

final tasksFunctionsProvider = Provider((ref) => TaskFunctions(ref: ref));

class TaskFunctions {
  final ProviderRef ref;

  TaskFunctions({required this.ref});

  Future<int> checkRevision() async {
    int fromAPI = await ref.watch(apiProvider).getRevision();
    if (fromAPI == -1) {
      return -1;
    }
    int localRevision;
    try {
      localRevision = Hive.box<int>('revision').getAt(0)!;
    } catch (e) {
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

  Future<void> updateLocalRevision() async {
    await Hive.box<int>('revision').clear();
    await Hive.box<int>('revision')
        .add(await ref.watch(apiProvider).getRevision());
  }

  Future<void> resolveQueue() async {
    if ((await checkRevision()) == 1) {
      debugPrint('резолвим');
      await Hive.lazyBox<TaskContainer>('box_for_tasks').clear();
      List<TaskContainer> list = await ref.watch(apiProvider).getTasksList();
      await updateLocalRevision();
      for (var x in list) {
        await ref.watch(localTasksProvider).addTaskLocal(x);
        //await Hive.lazyBox<TaskContainer>('box_for_tasks').add(x);
      }
      return;
    }
    while (API.queueBox.isNotEmpty) {
      Map<String, dynamic> item = (await API.queueBox.getAt(0))!;
      if (item.containsKey('addTask')) {
        ref.watch(apiProvider).addTask(TaskContainer.fromJson(item['addTask']));
      } else if (item.containsKey('editTask')) {
        ref
            .watch(apiProvider)
            .editTask(TaskContainer.fromJson(item['editTask']));
      } else {
        ref
            .watch(apiProvider)
            .deleteTask(TaskContainer.fromJson(item['deleteTask']));
      }
      await API.queueBox.deleteAt(0);
    }
  }

  Future<void> saveNewTask(
      DateTime? deadline, TaskImportance importance, String text) async {
    TaskContainer task = TaskContainer(text: text, importance: importance);
    if (deadline != null) {
      task.deadline = deadline.millisecondsSinceEpoch;
      task.deadlineDate = deadline;
    }
    if (await checkRevision() == 1) {
      await resolveQueue();
    }
    await ref.watch(localTasksProvider).addTaskLocal(task);
    await ref.watch(apiProvider).addTask(task);
    await updateLocalRevision();
  }

  Future<void> saveExistsTask(TaskContainer task, int index) async {
    if (await checkRevision() == 1) {
      await resolveQueue();
    }
    task.lastUpdateTime = DateTime.now().millisecondsSinceEpoch;
    await ref.watch(localTasksProvider).editTaskLocal(task, index);
    await ref.watch(apiProvider).editTask(task);
    await updateLocalRevision();
  }

  Future<void> deleteTask(int index, TaskContainer task) async {
    if (await checkRevision() == 1) {
      await resolveQueue();
    }
    await ref.watch(localTasksProvider).deleteTaskLocal(index);
    await ref.watch(apiProvider).deleteTask(task);
    await updateLocalRevision();
  }
}
