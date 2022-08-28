import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_yandex/model/task.dart';
import 'package:todo_yandex/navigation/controller.dart';
import 'package:todo_yandex/view_model/task_func.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../navigation/routes.dart';
import '../view/adder_appbar.dart';
import '../view/app_theme.dart';

final taskCreatedProvider = StateProvider<bool>((ref) => false);

final taskIndexProvider = StateProvider<int>((ref) => -1);

class TaskData extends ChangeNotifier {
  TaskContainer task =
      TaskContainer(text: '', importance: TaskImportance.basic);

  bool deadlineSwitch = false;

  TaskData();

  void setTask(TaskContainer taskContainer) {
    task = taskContainer;
    if (task.deadlineDate != null) {
      deadlineSwitch = true;
    } else {
      deadlineSwitch = false;
    }
    notifyListeners();
  }

  void setSwitcher() {
    deadlineSwitch = !deadlineSwitch;
    notifyListeners();
  }
}

final taskDataProvider = ChangeNotifierProvider<TaskData>((ref) => TaskData());

String _lastText = '';

class TaskAdder extends ConsumerWidget {
  TaskAdder({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(taskIndexProvider);
    final created = ref.watch(taskCreatedProvider);
    final task = ref.watch(taskDataProvider).task;
    bool deadlineSwitcher = ref.watch(taskDataProvider).deadlineSwitch;
    String importanceStr = AppLocalizations.of(context)!.no;
    _controller.text = _lastText != '' ? _lastText : task.text;
    if (task.deadlineDate != null && !deadlineSwitcher) {
      deadlineSwitcher = true;
      ref.read(taskDataProvider).deadlineSwitch = true;
    } else if (task.deadlineDate == null) {
      deadlineSwitcher = false;
      ref.read(taskDataProvider).deadlineSwitch = false;
    }
    if (task.importance == TaskImportance.low) {
      importanceStr = AppLocalizations.of(context)!.low;
    } else if (task.importance == TaskImportance.important) {
      importanceStr = AppLocalizations.of(context)!.high;
    }
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: AdderSliverAppBar(
                saveFunc: () {
                  NavigationController().pushNamed(Routes.animation);
                  final tasksFunc = ref.watch(tasksFunctionsProvider);
                  saveTask(created, task, index, tasksFunc).then((value) {
                    NavigationController().pop();
                    NavigationController().pop();
                  });
                },
                minHeight: 67,
                expandedHeight: 68,
                backFunc: () {
                  _lastText = '';
                },
              ),
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                child: Column(
                  children: [
                    Material(
                      shadowColor: Theme.of(context).shadowColor,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: TextField(
                        focusNode: FocusNode(
                          descendantsAreFocusable: false,
                          descendantsAreTraversable: false,
                        ),
                        controller: _controller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).primaryColorLight,
                          focusColor: Theme.of(context).primaryColorLight,
                          hoverColor: Theme.of(context).primaryColorLight,
                          hintText: AppLocalizations.of(context)!.hintTextField,
                          hintStyle: Theme.of(context).textTheme.headline5,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        minLines: 4,
                        maxLines: null,
                        style: Theme.of(context).textTheme.bodyText1,
                        onChanged: (value) {
                          _lastText = value;
                          //_controller.text = '';
                        },
                      ),
                    ),
                    PopupMenuButton(
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          value: 0,
                          child: Text(
                            AppLocalizations.of(context)!.no,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          onTap: () {
                            task.importance = TaskImportance.basic;
                            ref.read(taskDataProvider.notifier).setTask(task);
                          },
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: Text(
                            AppLocalizations.of(context)!.low,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          onTap: () {
                            task.importance = TaskImportance.low;
                            ref.read(taskDataProvider.notifier).setTask(task);
                          },
                        ),
                        PopupMenuItem(
                          value: 2,
                          onTap: () {
                            task.importance = TaskImportance.important;
                            ref.read(taskDataProvider.notifier).setTask(task);
                          },
                          child: Text(
                            '!! ${AppLocalizations.of(context)!.high}',
                            style: TextStyle(
                              fontSize: 16,
                              height: 20 / 16,
                              overflow: TextOverflow.ellipsis,
                              color: Color.fromRGBO(Themes.colorR,
                                  Themes.colorG, Themes.colorB, 1),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.importance,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        subtitle: task.importance != TaskImportance.important
                            ? Text(
                                importanceStr,
                                style: Theme.of(context).textTheme.subtitle1,
                              )
                            : Text(
                                '!! $importanceStr',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                      ),
                    ),
                    const Divider(
                      height: 0.5,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.doneBy,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      trailing: Switch(
                        onChanged: (newValue) async {
                          if (newValue) {
                            task.deadlineDate =
                                await _selectDate(context, task.deadlineDate);
                            ref.read(taskDataProvider.notifier).setTask(task);
                          } else {
                            task.deadlineDate = null;
                            ref.read(taskDataProvider.notifier).setTask(task);
                          }
                          deadlineSwitcher = newValue;
                          // ref.read(taskDataProvider.notifier).setSwitcher();
                        },
                        value: deadlineSwitcher,
                      ),
                      subtitle: Text(
                        task.deadlineDate != null
                            ? DateFormat('d MMMM yyyy',
                                    AppLocalizations.of(context)!.localeName)
                                .format(task.deadlineDate!)
                            : '',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      height: 0.5,
                      indent: 0,
                      endIndent: 0,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      textColor: created
                          ? Color.fromRGBO(
                              Themes.colorR, Themes.colorG, Themes.colorB, 1)
                          : Theme.of(context).disabledColor,
                      onTap: () async {
                        if (!created) {
                          return;
                        }
                        bool result = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                AppLocalizations.of(context)!.confirmDelete,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              content: Text(
                                AppLocalizations.of(context)!.deleteQuestion,
                                style: TextStyle(
                                    fontSize: 16,
                                    height: 20 / 16,
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context).primaryColorDark),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text(
                                    AppLocalizations.of(context)!.delete,
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(
                                    AppLocalizations.of(context)!.no,
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (result) {
                          NavigationController().pushNamed(Routes.animation);
                          ref
                              .watch(tasksFunctionsProvider)
                              .deleteTask(index, task)
                              .then((value) {
                            NavigationController().pop();
                            NavigationController().pop();
                          });
                        }
                      },
                      title: Text(
                        AppLocalizations.of(context)!.delete,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          height: 24 / 14,
                        ),
                      ),
                      leading: Icon(
                        Icons.delete,
                        color: created
                            ? Color.fromRGBO(
                                Themes.colorR, Themes.colorG, Themes.colorB, 1)
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime? date) async {
    date ??= DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && (date.year == 1900 || picked != date)) {
      date = picked;
      return date;
    }
    return null;
  }

  Future<void> saveTask(bool created, TaskContainer task, int index,
      TaskFunctions taskFunctions) async {
    if (task.deadlineDate != null) {
      task.deadline = task.deadlineDate!.millisecondsSinceEpoch;
    } else {
      task.deadline = null;
    }
    task.text = _controller.value.text;
    _lastText = '';
    if (created) {
      await taskFunctions.saveExistsTask(task, index);
    } else {
      await taskFunctions.saveNewTask(
          task.deadlineDate, task.importance, task.text);
    }
    _controller.text = '';
  }
}
