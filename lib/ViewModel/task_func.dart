import 'package:todo_yandex/Model/fucn_for_local.dart';
import 'package:todo_yandex/Model/task.dart';
import 'package:todo_yandex/Model/func_for_backend.dart';

Future<void> saveNewTask(
    DateTime? deadline, TaskImportance importance, String text) async {
  TaskContainer task = TaskContainer(text: text, importance: importance);
  if (deadline != null) {
    task.deadline = deadline;
  }
  await addTaskLocal(task);
  await API.addTask(task);
}

Future<void> saveExistsTask(TaskContainer task, int index) async {
  await editTaskLocal(task, index);
  await API.editTask(task);
}

Future<void> deleteTask(int index, TaskContainer task) async {
  await deleteTaskLocal(index);
  await API.deleteTask(task);
}
