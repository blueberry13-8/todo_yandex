// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:todo_yandex/model/task.dart';
// import 'package:todo_yandex/view_model/task_func.dart';
// import '../view/adder_appbar.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class TaskAdder extends StatefulWidget {
//   const TaskAdder(
//       {Key? key,
//       required this.created,
//       required this.task,
//       required this.index})
//       : super(key: key);
//
//   final bool created;
//   final TaskContainer task;
//   final int index;
//
//   @override
//   State<TaskAdder> createState() => _TaskAdderState();
// }
//
// class _TaskAdderState extends State<TaskAdder> {
//   TextEditingController controller = TextEditingController();
//   TaskImportance importance = TaskImportance.basic;
//   String importanceStr = '';
//   bool deadlineSwitch = false;
//   String deadlineDate = '';
//
//   @override
//   void initState() {
//     if (widget.created) {
//       importance = widget.task.importance;
//       controller.text = widget.task.text;
//       if (widget.task.deadline != null) {
//         deadlineSwitch = true;
//         selectedDate = widget.task.deadlineDate!;
//       }
//     }
//     super.initState();
//   }
//
//   DateTime selectedDate = DateTime.utc(1900);
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         firstDate: DateTime(2015, 8),
//         lastDate: DateTime(2101));
//     if (picked != null &&
//         (selectedDate.year == 1900 || picked != selectedDate)) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }
//
//   bool _saveProcess = false;
//
//   void _saveTask() {
//     if (_saveProcess) {
//       return;
//     }
//     _saveProcess = true;
//     if (widget.created) {
//       widget.task.importance = importance;
//       widget.task.text = controller.value.text;
//       if (deadlineSwitch) {
//         widget.task.deadlineDate = selectedDate;
//         widget.task.deadline = selectedDate.millisecondsSinceEpoch;
//       } else {
//         widget.task.deadline = null;
//       }
//       TaskFunctions.saveExistsTask(widget.task, widget.index)
//           .then((value) => Navigator.pop(context));
//     } else {
//       if (deadlineSwitch) {
//         TaskFunctions.saveNewTask(
//                 selectedDate, importance, controller.value.text)
//             .then((value) => Navigator.pop(context));
//       } else {
//         TaskFunctions.saveNewTask(null, importance, controller.value.text)
//             .then((value) => Navigator.pop(context));
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.created) {
//       deadlineDate =
//           DateFormat('d MMMM yyyy', AppLocalizations.of(context)!.localeName)
//               .format(selectedDate);
//       if (importance == TaskImportance.low) {
//         importanceStr = AppLocalizations.of(context)!.low;
//       } else if (importance == TaskImportance.important) {
//         importanceStr = AppLocalizations.of(context)!.high;
//       } else {
//         importanceStr = AppLocalizations.of(context)!.no;
//       }
//     } else {
//       importanceStr = AppLocalizations.of(context)!.no;
//     }
//     return GestureDetector(
//       onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF7F6F2),
//         body: CustomScrollView(
//           slivers: [
//             SliverPersistentHeader(
//               delegate: AdderSliverAppBar(
//                 backFunc: () {
//                   Navigator.pop(context);
//                 },
//                 saveFunc: _saveTask,
//                 minHeight: 67,
//                 expandedHeight: 68,
//               ),
//               pinned: true,
//             ),
//             SliverToBoxAdapter(
//               child: Container(
//                 padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
//                 child: Column(
//                   children: [
//                     Material(
//                       shadowColor: const Color(0xFF000000),
//                       elevation: 2,
//                       borderRadius: BorderRadius.circular(10),
//                       child: TextField(
//                         focusNode: FocusNode(
//                           descendantsAreFocusable: false,
//                           descendantsAreTraversable: false,
//                         ),
//                         controller: controller,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           focusColor: Colors.white,
//                           hoverColor: Colors.white,
//                           hintText: AppLocalizations.of(context)!.hintTextField,
//                           hintStyle: Theme.of(context).textTheme.bodyText1,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         minLines: 4,
//                         maxLines: null,
//                         style: Theme.of(context).textTheme.bodyText1,
//                       ),
//                     ),
//                     PopupMenuButton(
//                       itemBuilder: (BuildContext context) => <PopupMenuEntry>[
//                         PopupMenuItem(
//                           value: 0,
//                           child: Text(
//                             AppLocalizations.of(context)!.no,
//                             style: Theme.of(context).textTheme.bodyText1,
//                           ),
//                           onTap: () {
//                             importanceStr = AppLocalizations.of(context)!.no;
//                             importance = TaskImportance.basic;
//                             setState(() {});
//                           },
//                         ),
//                         PopupMenuItem(
//                           value: 1,
//                           child: Text(
//                             AppLocalizations.of(context)!.low,
//                             style: Theme.of(context).textTheme.bodyText1,
//                           ),
//                           onTap: () {
//                             importanceStr = AppLocalizations.of(context)!.low;
//                             importance = TaskImportance.low;
//                             setState(() {});
//                           },
//                         ),
//                         PopupMenuItem(
//                           value: 2,
//                           onTap: () {
//                             importanceStr =
//                                 '!! ${AppLocalizations.of(context)!.high}';
//                             importance = TaskImportance.important;
//                             setState(() {});
//                           },
//                           textStyle: const TextStyle(color: Colors.red),
//                           child: Text(
//                             '!! ${AppLocalizations.of(context)!.high}',
//                             style: Theme.of(context).textTheme.bodyText1,
//                           ),
//                         ),
//                       ],
//                       child: ListTile(
//                         title: Text(AppLocalizations.of(context)!.importance),
//                         subtitle: Text(importanceStr),
//                       ),
//                     ),
//                     const Divider(
//                       height: 0.5,
//                       thickness: 1,
//                       indent: 16,
//                       endIndent: 16,
//                     ),
//                     ListTile(
//                       title: Text(AppLocalizations.of(context)!.doneBy),
//                       trailing: Switch(
//                         onChanged: (newValue) {
//                           if (newValue) {
//                             selectedDate = DateTime.now();
//                             _selectDate(context).then((value) {
//                               setState(() {
//                                 deadlineDate = DateFormat(
//                                         'd MMMM yyyy',
//                                         AppLocalizations.of(context)!
//                                             .localeName)
//                                     .format(selectedDate);
//                               });
//                             });
//                           } else {
//                             deadlineDate = '';
//                           }
//                           setState(() {
//                             deadlineSwitch = newValue;
//                           });
//                         },
//                         value: deadlineSwitch,
//                       ),
//                       subtitle: Text(
//                         deadlineDate,
//                         style: const TextStyle(color: Colors.blue),
//                       ),
//                     ),
//                     const Divider(
//                       thickness: 1,
//                       height: 0.5,
//                     ),
//                     ListTile(
//                       textColor: widget.created ? Colors.red : Colors.grey,
//                       onTap: () async {
//                         if (!widget.created) {
//                           return;
//                         }
//                         bool result = await showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text(
//                                   AppLocalizations.of(context)!.confirmDelete),
//                               content: Text(
//                                   AppLocalizations.of(context)!.deleteQuestion),
//                               actions: <Widget>[
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.of(context).pop(true),
//                                   child: Text(
//                                       AppLocalizations.of(context)!.delete),
//                                 ),
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.of(context).pop(false),
//                                   child: Text(
//                                     AppLocalizations.of(context)!.no,
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                         if (result) {
//                           TaskFunctions.deleteTask(widget.index, widget.task)
//                               .then((value) => Navigator.pop(context));
//                         }
//                       },
//                       title: Text(
//                         AppLocalizations.of(context)!.delete,
//                         style: Theme.of(context).textTheme.button,
//                       ),
//                       leading: Icon(
//                         Icons.delete,
//                         color: widget.created ? Colors.red : Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 100,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
