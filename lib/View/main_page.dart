import 'package:flutter/material.dart';
import 'package:todo_yandex/Model/fucn_for_local.dart';
import 'package:todo_yandex/View/app_bar.dart';
import 'package:todo_yandex/View/task_adder.dart';
import 'package:todo_yandex/Model/task.dart';
import 'package:todo_yandex/View/task_card.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_yandex/Model/func_for_backend.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late Future<int> done;
  bool showDone = true;

  @override
  void initState() {
    done = getDoneNumLocal();
    super.initState();
  }

  void callbackSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    API.boolCheckRevision().then((value) {
      if (!value) {
        API.resolveQueue().then((value) {
          setState(() {});
        });
      }
    });
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
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
                    ;
                    callbackSetState();
                  },
                  showDone,
                  minHeight: 88,
                  expandedHeight: 164,
                  doneNum: done,
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
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
                          title: Text(
                            AppLocalizations.of(context)!.newInTheEnd,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 20 / 16,
                              color: Color.fromRGBO(0, 0, 0, 0.3),
                            ),
                          ),
                          leading: const Icon(
                            Icons.add,
                            color: Colors.white,
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
                              width: 10,
                              height: 10,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO: Solve this issue with navigator
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskAdder(
                  created: false,
                  task:
                      TaskContainer(importance: TaskImportance.basic, text: ''),
                  index: -1),
            ),
          ).then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
