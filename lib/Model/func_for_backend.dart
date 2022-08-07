import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:todo_yandex/Model/task.dart';

class API {
  static const String _mainAPI = 'https://beta.mrdekk.ru/todobackend/';

  static final queueBox = Hive.box<Map<String, dynamic>>('box_queue_back');

  static Future<bool> boolCheckRevision() async{
    int fromAPI = await getRevision();
    if (fromAPI == -1){
      return true;
    }
    int localRevision = Hive.box<int>('revision').getAt(0)!;
    return fromAPI == localRevision;
  }

  static Future<void> resolveQueue() async {
    if (!(await boolCheckRevision())){
      await Hive.lazyBox<TaskContainer>('box_for_tasks').clear();
      List<TaskContainer> list = await getTasksList();
      for (var x in list){
        await Hive.lazyBox<TaskContainer>('box_for_tasks').add(x);
      }
      await Hive.box<int>('revision').clear();
      await Hive.box<int>('revision').add(await getRevision());
      return;
    }
    while (queueBox.isNotEmpty){
      var item = queueBox.getAt(0);
      if (item!.containsKey('addTask')){
        addTask(TaskContainer.fromJson(item['addTask']));
      } else if (item.containsKey('editTask')){
        editTask(TaskContainer.fromJson(item['editTask']));
      } else {
        deleteTask(TaskContainer.fromJson(item['deleteTask']));
      }
    }
  }

  static Future<int> getRevision() async {
    final uri = Uri.parse('$_mainAPI/list');
    final header = {"Authorization": "Bearer Floikwood"};
    final response = await http.get(uri, headers: header);
    debugPrint(response.statusCode.toString());
    if (response.statusCode != 200) {
      return -1;
      //TODO: Somehow do the error situation
    }
    Map<String, dynamic> ans = jsonDecode(response.body);
    return ans['revision'];
  }

  static Future<List<TaskContainer>> getTasksList() async {
    final uri = Uri.parse('$_mainAPI/list');
    final header = {"Authorization": "Bearer Floikwood"};
    final response = await http.get(uri, headers: header);
    debugPrint(response.statusCode.toString());
    if (response.statusCode != 200) {
      //TODO: Somehow do the error situation
    }
    Map<String, dynamic> ans = jsonDecode(response.body).map();
    List<TaskContainer> list = ans['list'];
    return List<TaskContainer>.from(
        ans['list']((x) => TaskContainer.fromJson(x)));
  }

  static Future<void> updateListOnServer() async {
    //TODO: ...????
  }

  static Future<TaskContainer> getTask(int id) async {
    final uri = Uri.parse('$_mainAPI/list/$id');
    final header = {"Authorization": "Bearer Floikwood"};
    final response = await http.get(uri, headers: header);
    debugPrint(response.statusCode.toString());
    if (response.statusCode != 200) {
      //TODO: Somehow do the error situation
    }
    // if (json.decode(response.body).map()['revision'] != await getRevision()){
    //   resolveQueue();
    //   return errorTask;
    // }
    return TaskContainer.fromJson(json.decode(response.body).map()['element']);
  }

  static Future<TaskContainer> addTask(TaskContainer task) async {
    final uri = Uri.parse('$_mainAPI/list');
    int revision = await getRevision();
    Map<String, String> header = {
      'X-Last-Known-Revision': revision.toString(),
      'Content-Type': 'application/json',
      'Authorization': 'Bearer Floikwood'
    };
    final body = {"element": task.toJson()};
    final response = await http.post(uri, headers: header, body: body);
    debugPrint(response.statusCode.toString());
    if (!(await boolCheckRevision())){
      resolveQueue();
      return errorTask;
    }
    if (response.statusCode != 200) {
      queueBox.add({"addTask": task.toJson()});
      return errorTask;
    }
    return TaskContainer.fromJson(json.decode(response.body).map()['element']);
  }

  static Future<TaskContainer> editTask(TaskContainer task) async {
    final uri = Uri.parse('$_mainAPI/list/${task.id}');
    final header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer Floikwood'
    };
    final body = {"element": task.toJson()};
    final response = await http.put(uri, headers: header, body: body);
    debugPrint(response.statusCode.toString());
    if (!(await boolCheckRevision())){
      resolveQueue();
      return errorTask;
    }
    if (response.statusCode != 200) {
      queueBox.add({"editTask": task.toJson()});
      return errorTask;
    }
    return TaskContainer.fromJson(json.decode(response.body).map()['element']);
  }

  static Future<TaskContainer> deleteTask(TaskContainer task) async {
    final uri = Uri.parse('$_mainAPI/list/${task.id}');
    final header = {"Authorization": "Bearer Floikwood"};
    final response = await http.delete(uri, headers: header);
    debugPrint(response.statusCode.toString());
    if (!(await boolCheckRevision())){
      resolveQueue();
      return errorTask;
    }
    if (response.statusCode != 200) {
      queueBox.add({"deleteTask": task.toJson()});
      return errorTask;
    }
    return TaskContainer.fromJson(json.decode(response.body).map()['element']);
  }
}
