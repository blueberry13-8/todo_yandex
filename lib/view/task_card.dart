import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_yandex/model/task.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_yandex/view_model/task_func.dart';
import '../navigation/controller.dart';
import '../navigation/routes.dart';
import '../screens/task_adder.dart';
import 'package:todo_yandex/model/func_for_local.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'app_theme.dart';

class TaskCard extends StatefulWidget {
  const TaskCard(
      {Key? key,
      required this.task,
      required this.index,
      required this.taskLocation,
      required this.callback})
      : super(key: key);

  final TaskContainer task;
  final int index;
  final TaskLocation taskLocation;
  final Function callback;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late SvgPicture textImportance;
  late Widget redCheckBox;
  BorderRadius border = BorderRadius.zero;

  @override
  Widget build(BuildContext context) {
    if (widget.taskLocation == TaskLocation.start) {
      border = const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      );
    } else if (widget.taskLocation == TaskLocation.end) {
      border = const BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      );
    }
    var checkBox = Container(
      width: 14,
      height: 14,
      margin: const EdgeInsets.only(
        left: 19,
        top: 15,
        right: 15,
      ),
      child: Consumer(
        builder: (context, ref, _){
          return Checkbox(
            activeColor: Colors.green,
            checkColor: Theme.of(context).backgroundColor,
            side: BorderSide(
              color: Theme.of(context).disabledColor,
              width: 2,
            ),
            value: widget.task.done,
            onChanged: (value) {
              widget.task.done = value!;
              // LocalSave.lBox.putAt(widget.index, widget.task);
              // API.editTask(widget.task);
              ref.watch(tasksFunctionsProvider).saveExistsTask(widget.task, widget.index).then((value) {
                setState(() {});
              });
            },
          );
        },
      ),
    );
    if (widget.task.importance == TaskImportance.low) {
      textImportance = SvgPicture.asset(
        'assets/low.svg',
        width: 10,
        height: 16,
      );
    } else if (widget.task.importance == TaskImportance.important) {
      textImportance = SvgPicture.asset(
        'assets/high.svg',
        width: 10,
        height: 14,
      );
      redCheckBox = Container(
        width: 14,
        height: 14,
        margin: const EdgeInsets.only(
          left: 19,
          top: 15,
          right: 15,
        ),
        color:
            Color.fromRGBO(Themes.colorR, Themes.colorG, Themes.colorB, 0.16),
        child: Consumer(
          builder: (context, ref, _){
            return Checkbox(
              value: widget.task.done,
              activeColor: Colors.green,
              checkColor: Theme.of(context).backgroundColor,
              side: BorderSide(
                color:
                Color.fromRGBO(Themes.colorR, Themes.colorG, Themes.colorB, 1),
                width: 2,
              ),
              onChanged: (value) {
                widget.task.done = value!;
                // LocalSave.lBox.putAt(widget.index, widget.task);
                // API.editTask(widget.task);
                ref.watch(tasksFunctionsProvider).saveExistsTask(widget.task, widget.index)
                    .then((value) {
                  setState(() {});
                });
              },
            );
          },
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: border,
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.outer,
            color: Theme.of(context).shadowColor,
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Consumer(
        builder: (context, ref, _){
          return Dismissible(
            key: ValueKey<int>(widget.index),
            background: Container(
              color: Colors.green,
              padding: const EdgeInsets.only(left: 27),
              alignment: Alignment.centerLeft,
              child: Row(
                children: const [
                  Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            secondaryBackground: Container(
              color: Color.fromRGBO(Themes.colorR, Themes.colorG, Themes.colorB, 1),
              padding: const EdgeInsets.only(right: 27),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            confirmDismiss: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                LocalTasks.lBox.getAt(widget.index).then((val) {
                  widget.task.done = !widget.task.done;
                  ref.watch(tasksFunctionsProvider).saveExistsTask(widget.task, widget.index);
                });
                setState(() {});
                return false;
              } else {
                bool result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.confirmDelete),
                      content: Text(AppLocalizations.of(context)!.deleteQuestion),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(AppLocalizations.of(context)!.delete)),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(AppLocalizations.of(context)!.no),
                        ),
                      ],
                    );
                  },
                );
                if (result) {
                  await ref.watch(tasksFunctionsProvider).deleteTask(widget.index, widget.task);
                }
                return false;
              }
            },
            child: widget.task.deadlineDate == null
                ? ListTile(
              contentPadding: EdgeInsets.zero,
              title: Container(
                margin: const EdgeInsets.only(top: 14),
                child: Stack(
                  children: [
                    widget.task.importance != TaskImportance.basic
                        ? Container(
                        margin: const EdgeInsets.only(top: 3),
                        child: textImportance)
                        : const Text(''),
                    Text(
                      widget.task.importance == TaskImportance.basic
                          ? widget.task.text
                          : '    ${widget.task.text}',
                      style: widget.task.done
                          ? Theme.of(context).textTheme.bodyText2!
                          : Theme.of(context).textTheme.bodyText1!,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              trailing: Consumer(
                builder: (context, ref, _) {
                  return IconButton(
                    onPressed: () {
                      ref
                          .read(taskDataProvider.notifier)
                          .setTask(widget.task);
                      if (ref.read(taskDataProvider).deadlineSwitch &&
                          widget.task.deadlineDate == null ||
                          !ref.read(taskDataProvider).deadlineSwitch &&
                              widget.task.deadlineDate != null) {
                        ref.read(taskDataProvider.notifier).setSwitcher();
                      }
                      ref.read(taskIndexProvider.state).state = widget.index;
                      ref.read(taskCreatedProvider.state).state = true;
                      try {
                        AppMetrica.reportEvent('Opened TaskAdder page');
                      } catch (e) {
                        debugPrint('AppMetrica: Cannot report event');
                      }
                      NavigationController().pushNamed(Routes.editor);
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).disabledColor,
                    ),
                  );
                },
              ),
              leading: widget.task.importance == TaskImportance.important
                  ? redCheckBox
                  : checkBox,
            )
                : ListTile(
              contentPadding: EdgeInsets.zero,
              title: Container(
                margin: const EdgeInsets.only(top: 14),
                child: Stack(
                  children: [
                    widget.task.importance != TaskImportance.basic
                        ? Container(
                        margin: const EdgeInsets.only(top: 3),
                        child: textImportance)
                        : const Text(''),
                    Text(
                      widget.task.importance == TaskImportance.basic
                          ? widget.task.text
                          : '    ${widget.task.text}',
                      style: widget.task.done
                          ? Theme.of(context).textTheme.bodyText2!
                          : Theme.of(context).textTheme.bodyText1!,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              subtitle: widget.task.deadline != null
                  ? Text(
                DateFormat('d MMMM yyyy',
                    AppLocalizations.of(context)!.localeName)
                    .format(widget.task.deadlineDate!),
                style: Theme.of(context).textTheme.subtitle2,
              )
                  : const SizedBox(
                width: 0,
                height: 0,
              ),
              trailing: Consumer(
                builder: (context, ref, _) {
                  return IconButton(
                    onPressed: () {
                      ref
                          .read(taskDataProvider.notifier)
                          .setTask(widget.task);
                      if (ref.read(taskDataProvider).deadlineSwitch &&
                          widget.task.deadlineDate == null ||
                          !ref.read(taskDataProvider).deadlineSwitch &&
                              widget.task.deadlineDate != null) {
                        ref.read(taskDataProvider.notifier).setSwitcher();
                      }
                      ref.read(taskIndexProvider.notifier).state =
                          widget.index;
                      ref.read(taskCreatedProvider.notifier).state = true;
                      try {
                        AppMetrica.reportEvent('Opened TaskAdder page');
                      } catch (e) {
                        debugPrint('AppMetrica: Cannot report event');
                      }
                      NavigationController().pushNamed(Routes.editor);
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).disabledColor,
                    ),
                  );
                },
              ),
              leading: widget.task.importance == TaskImportance.important
                  ? redCheckBox
                  : checkBox,
            ),
          );
        },
      ),
    );
  }
}
