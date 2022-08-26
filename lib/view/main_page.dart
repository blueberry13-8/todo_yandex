import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_yandex/model/func_for_local.dart';
import 'package:todo_yandex/screens/task_adder.dart';
import 'package:todo_yandex/view/main_appbar.dart';
import 'package:todo_yandex/view/task_adder.dart';
import 'package:todo_yandex/model/task.dart';
import 'package:todo_yandex/view/task_card.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../view_model/task_func.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  bool showDone = true;
  bool inResolveProcess = false;

  void callbackSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // if (kDebugMode) {
    //   print(Hive.box<int>('revision').getAt(0)!);
    // }
    if (!inResolveProcess) {
      inResolveProcess = true;
      TaskFunctions.checkRevision().then((value) {
        if (value == 1) {
          TaskFunctions.resolveQueue().then((value) {
            setState(() {
              inResolveProcess = false;
            });
          });
        } else {
          inResolveProcess = false;
        }
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ValueListenableBuilder(
        valueListenable:
            Hive.lazyBox<TaskContainer>('box_for_tasks').listenable(),
        builder: (context, LazyBox<TaskContainer> tasks, _) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                delegate: MySliverAppBar(
                  () {
                    showDone = !showDone;
                    setState(() {});
                  },
                  showDone,
                  minHeight: 88,
                  expandedHeight: 164,
                ),
                pinned: true,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index == tasks.length) {
                      return Container(
                        margin: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          bottom: 36,
                        ),
                        height: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 2),
                            )
                          ],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () {
                            //TODO: Move away this navigator call!!!
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskAdder(
                                  created: false,
                                  task: TaskContainer(
                                      importance: TaskImportance.basic,
                                      text: ''),
                                  index: -1,
                                ),
                              ),
                            ).then((value) => setState(() {}));
                          },
                          title: Container(
                            color: Theme.of(context).primaryColorLight,
                            margin: const EdgeInsets.only(top: 14),
                            child: Text(
                              AppLocalizations.of(context)!.newInTheEnd,
                              style: TextStyle(
                                fontSize: 16,
                                height: 20 / 16,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ),
                          leading: Container(
                            color: Theme.of(context).primaryColorLight,
                            margin: const EdgeInsets.only(
                              left: 19,
                              top: 15,
                              right: 6,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ),
                      );
                    }
                    Future<TaskContainer?> curTask = tasks.getAt(index);
                    return FutureBuilder<TaskContainer?>(
                      future: curTask,
                      builder: (context, task) {
                        if (!task.hasData) {
                          return Container(
                              alignment: Alignment.center,
                              width: 1,
                              height: 1,
                              child: const CircularProgressIndicator());
                        }
                        if (task.data!.done && !showDone) {
                          return const SizedBox(
                            width: 0,
                            height: 0,
                          );
                        }
                        TaskLocation location = TaskLocation.middle;
                        if (index == 0) {
                          location = TaskLocation.start;
                        }
                        return TaskCard(
                          task: task.data!,
                          index: index,
                          taskLocation: location,
                          callback: callbackSetState,
                        );
                      },
                    );
                  },
                  childCount: tasks.length + 1,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, _) {
          return FloatingActionButton(
            onPressed: () {
              ref.read(taskDataProvider.notifier).setTask(TaskContainer(
                    text: '',
                    importance: TaskImportance.basic,
                  ));
              if (ref.read(taskDataProvider).deadlineSwitch) {
                ref.read(taskDataProvider.notifier).setSwitcher();
              }
              //TODO: Solve this issue with navigator
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TaskAdder2()));
            },
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
