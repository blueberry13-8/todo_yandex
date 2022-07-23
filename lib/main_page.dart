import 'package:flutter/material.dart';
import 'package:todo_yandex/temp_navigation.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key, required this.title}) : super(key: key);

  final String title;
  //int doneTasksCnt = 0;

  //List<>

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 32, ),),
          Row(
            children: [
      //        Text('Выполнено - $doneTasksCnt'),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.remove_red_eye),
              )
            ],
          ),
          Container(
            // child: ListView.builder(
            //   itemCount: ,
            //   itemBuilder: (BuildContext context, int index) {
            //
            //   },
            // ),
          ),
        ],
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: addNewTask,
        child: Icon(Icons.add),
      ),
    );
  }
}


// class TasksPage extends StatefulWidget {
//   const TasksPage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<TasksPage> createState() => _TasksPageState();
// }
//
// class _TasksPageState extends State<TasksPage> {
//   int doneTasksCnt = 0;
//
//   List<>
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Text(widget.title),
//           Row(
//             children: [
//               Text('Выполнено - $doneTasksCnt'),
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.remove_red_eye),
//               )
//             ],
//           ),
//           Container(
//             child: ListView.builder(
//               itemCount: ,
//               itemBuilder: (BuildContext context, int index) {
//
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
