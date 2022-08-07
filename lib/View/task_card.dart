import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_yandex/Model/task.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_yandex/View/task_adder.dart';
import 'package:todo_yandex/ViewModel/task_func.dart';
import 'app_theme.dart';
import 'package:todo_yandex/Model/fucn_for_local.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late Checkbox redCheckBox;
  BorderRadius border = BorderRadius.zero;
  TextStyle doneTextStyle = const TextStyle(
    fontSize: 16,
    height: 20 / 16,
    overflow: TextOverflow.ellipsis,
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
  );

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
    var checkBox = Checkbox(
      value: widget.task.done,
      onChanged: (value) {
        widget.task.done = value!;
        lBox.putAt(widget.index, widget.task);
        setState(() {});
      },
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
      redCheckBox = Checkbox(
        value: widget.task.done,
        focusColor: Colors.red,
        onChanged: (value) {
          widget.task.done = value!;
          lBox.putAt(widget.index, widget.task);
          setState(() {});
        },
        fillColor: MaterialStateProperty.all(Colors.red),
      );
    }

    return Container(
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      padding: widget.taskLocation == TaskLocation.start
          ? const EdgeInsets.only(top: 15)
          : const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: border,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Dismissible(
        key: ValueKey<int>(widget.index),
        background: Container(
          color: Colors.green,
          padding: const EdgeInsets.only(left: 27),
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
          color: Colors.red,
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
            lBox.getAt(widget.index).then((val) {
              widget.task.done = !widget.task.done;
              lBox.putAt(widget.index, widget.task);
            });
            setState(() {});
            return false;
          } else {
            bool result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirm"),
                  content:
                    Text(AppLocalizations.of(context)!.deleteQuestion),
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
              await deleteTask(widget.index, widget.task);
            }
            return false;
          }
        },
        child: ListTile(
          title: Stack(
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
                style: widget.task.done ? doneTextStyle : Themes.body,
                maxLines: 3,
              ),
            ],
          ),
          subtitle: widget.task.deadline != null
              ? Text(
              DateFormat('d MMMM yyyy',
                  AppLocalizations.of(context)!.localeName)
                  .format(widget.task.deadline!),
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                )
              : Container(),
          trailing: IconButton(
            onPressed: () {
              //TODO: Move away this navigator call!!!
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskAdder(
                    created: true,
                    task: widget.task,
                    index: widget.index,
                  ),
                ),
              ).then((value) => setState(() {}));
            },
            icon: const Icon(Icons.info_outline),
          ),
          leading: widget.task.importance == TaskImportance.important
              ? redCheckBox
              : checkBox,
        ),
      ),
    );
  }
}
