import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_yandex/screens/task_adder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/task.dart';
import '../view/main_appbar.dart';
import '../view/task_card.dart';
import '../view_model/task_func.dart';

class MainPageNotifier extends ChangeNotifier {
  bool showDone = true;
  bool isResolveWorking = false;

  void setShowMode() {
    showDone = !showDone;
    notifyListeners();
  }

  void setResolveWork() {
    isResolveWorking = !isResolveWorking;
    notifyListeners();
  }

  void rebuild() {
    notifyListeners();
  }
}

final mainPageDataProvider =
    ChangeNotifierProvider<MainPageNotifier>((ref) => MainPageNotifier());

class TasksPage2 extends ConsumerWidget {
  const TasksPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TaskFunctions.checkRevision().then((value) async {
      if (value == 1) {
        await TaskFunctions.resolveQueue();
        ref.read(mainPageDataProvider.notifier).rebuild();
      }
    });
    bool showDone = ref.watch(mainPageDataProvider).showDone;

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
                    ref.read(mainPageDataProvider.notifier).rebuild();
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
                            ref
                                .read(taskDataProvider.notifier)
                                .setTask(TaskContainer(
                                  text: '',
                                  importance: TaskImportance.basic,
                                ));
                            if (ref.read(taskDataProvider).deadlineSwitch) {
                              ref.read(taskDataProvider.notifier).setSwitcher();
                            }
                            //TODO: Solve this issue with navigator
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TaskAdder2()));
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
                          callback: () =>
                              ref.read(mainPageDataProvider.notifier).rebuild(),
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
