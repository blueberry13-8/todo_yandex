import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:todo_yandex/model/task.dart';
import 'package:todo_yandex/view_model/task_func.dart';

class API {
  static const String _mainAPI = 'https://beta.mrdekk.ru/todobackend/';

  static final queueBox = Hive.lazyBox<Map<String, dynamic>>('box_queue_back');

  static Future<int> getRevision() async {
    final uri = Uri.parse('$_mainAPI/list');
    final header = {"Authorization": "Bearer Floikwood"};
    http.Response response;
    try {
      response = await http.get(uri, headers: header);
    } catch (e) {
      return -1;
    }
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
    List<TaskContainer> ans = List<TaskContainer>.from(
        jsonDecode(response.body)['list']
            .map((x) => TaskContainer.fromJson(x)));
    return ans;
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
    if ((await TaskFunctions.checkRevision()) == 1) {
      await TaskFunctions.resolveQueue();
    }
    final uri = Uri.parse('$_mainAPI/list');
    int revision = await getRevision();
    Map<String, String> header = {
      'X-Last-Known-Revision': revision.toString(),
      'Content-Type': 'application/json',
      'Authorization': 'Bearer Floikwood'
    };
    final body = jsonEncode({"element": task.toJson()});
    http.Response response;
    try {
      response = await http.post(uri, headers: header, body: body);
      if (response.statusCode != 200) {
        queueBox.add({"addTask": jsonEncode(task.toJson())});
        return errorTask;
      }
    } catch (e) {
      queueBox.add({"addTask": jsonEncode(task.toJson())});
      return errorTask;
    }
    await TaskFunctions.updateLocalRevision();
    return TaskContainer.fromJson(json.decode(response.body)['element']);
  }

  static Future<TaskContainer> editTask(TaskContainer task) async {
    if ((await TaskFunctions.checkRevision()) == 1) {
      await TaskFunctions.resolveQueue();
    }
    final uri = Uri.parse('$_mainAPI/list/${task.id}');
    int revision = await getRevision();
    Map<String, String> header = {
      'X-Last-Known-Revision': revision.toString(),
      'Content-Type': 'application/json',
      'Authorization': 'Bearer Floikwood'
    };
    final body = jsonEncode({"element": task.toJson()});
    http.Response response;
    try {
      response = await http.put(uri, headers: header, body: body);
      if (response.statusCode != 200) {
        queueBox.add({"editTask": task.toJson()});
        return errorTask;
      }
    } catch (e) {
      queueBox.add({"editTask": task.toJson()});
      return errorTask;
    }
    await TaskFunctions.updateLocalRevision();
    return TaskContainer.fromJson(json.decode(response.body)['element']);
  }

  static Future<TaskContainer> deleteTask(TaskContainer task) async {
    if ((await TaskFunctions.checkRevision()) == 1) {
      await TaskFunctions.resolveQueue();
    }
    final uri = Uri.parse('$_mainAPI/list/${task.id}');
    int revision = await getRevision();
    Map<String, String> header = {
      'X-Last-Known-Revision': revision.toString(),
      'Authorization': 'Bearer Floikwood'
    };
    http.Response response;
    try{
      response = await http.delete(uri, headers: header);
      if (response.statusCode != 200) {
        queueBox.add({"deleteTask": task.toJson()});
        return errorTask;
      }
    }catch(e){
      queueBox.add({"deleteTask": task.toJson()});
      return errorTask;
    }
    await TaskFunctions.updateLocalRevision();
    return TaskContainer.fromJson(json.decode(response.body)['element']);
  }
}
