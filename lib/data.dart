import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class WorkData {
  int _id = 0;
  Icon icon = Icon(Icons.today);
  int iconNum = 0;
  String name = "";
  bool isNameMutable = false;
  List<TaskData> tasks = [];
  String repeat = "";
  bool isDeleted = false;
  String tasksJson = '';

  WorkData(dynamic data) {
    _id = data["id"];
    icon = getIcon(data["icon"]);
    iconNum = data["icon"];
    name = data["name"];
    repeat = data["repeat"];
    isNameMutable = data["isNameMutable"];
    isDeleted = data["isDeleted"];
    for (var task in data["tasks"]) {
      tasks.add(TaskData(task));
    }
  }

  void removeTask(int id) {
    for (int i=0; i<tasks.length; i++) {
      if (tasks[i].id == id) {
        tasks.removeAt(i);
        break;
      }
    }
    Data().jsonizeAndWrite();
  }
  
  Map<String, dynamic> jsonize() {
    Map<String, dynamic> map = {
      "id": _id,
      "icon": iconNum,
      "name": name,
      "repeat": repeat,
      "isNameMutable": isNameMutable,
      "isDeleted": isDeleted,
      "tasks": taskJsonize()
    };
    return map;
  }

  List<Map<String, dynamic>> taskJsonize() {
    List<Map<String, dynamic>> ret = [];
    for (var task in tasks) {
      ret.add(task.jsonize());
    }
    return ret;
  }

  void delete() {
    isDeleted = true;
    for (int i=tasks.length-1; i>=0; i--) {
      tasks.removeAt(i);
    }
    Data().jsonizeAndWrite();
  }

  int getID() {
    return _id;
  }

  Icon getIcon(int icon) {
    final List<IconData> iconMap = [Icons.today, Icons.calendar_month_sharp, Icons.check_circle, Icons.check_box, Icons.calendar_today, Icons.alarm, Icons.event, Icons.star, Icons.flag, Icons.priority_high, Icons.work, Icons.home, Icons.school, Icons.fitness_center, Icons.shopping_cart, Icons.book, Icons.movie, Icons.music_note, Icons.restaurant, Icons.flight, Icons.directions_car, Icons.pets, Icons.lightbulb, Icons.note, Icons.mail, Icons.phone, Icons.cloud, Icons.bug_report, Icons.lock, Icons.star_border, Icons.label, Icons.hourglass_empty];
    return Icon(iconMap[icon]);
  }

  void update(dynamic data) {
     _id = data["id"];
    icon = getIcon(data["icon"]);
    name = data["name"];
    isNameMutable = data["isNameMutable"];
    for (var task in data["tasks"]) {
      tasks.add(TaskData(task));
    }
    Data().jsonizeAndWrite();
  }

  void updateTask(dynamic task) {
    for (int i=0; i<tasks.length; i++) {
      if (tasks[i].id==task["taskID"]) {
        tasks[i].update(task);
        break;
      }
    }
    Data().jsonizeAndWrite();
  }
}

class TaskData {
  String name = "";
  int id = 0;
  int color = 0;

  TaskData(dynamic task) {
    name = task["name"];
    id = task["taskID"];
    color = task["color"];
  }

  Map<String, dynamic> jsonize() {
    Map<String, dynamic> map = {
      "name": name,
      "taskID": id,
      "color": color,
    };
    return map;
  }

  Color? getColor() {
    List<Color> clrs = [Colors.red.shade300, Colors.green.shade300, Colors.blue.shade300, Colors.yellow.shade300, Colors.purple.shade300, Colors.cyan.shade300];
    return clrs[color];
  }

  void update(dynamic task) {
    name = task["name"];
    color = task["color"];
  }
}

class Data {
  Data._privateConstructor();

  static final Data _instance = Data._privateConstructor();

  factory Data() {
    return _instance;
  }

  String fillSpecialData() {
    return '''
{
  "workspaces": [
    {"id": 0, "icon": 0, "name": "Today", "isNameMutable": false, "repeat": "Daily", "isDeleted": false, "tasks": []},
    {"id": 1, "icon": 1, "name": "Next Week", "isNameMutable": false, "repeat": "Never", "isDeleted": false, "tasks": []}
  ]
}''';
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/appData.json');
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

  Future<bool> fileDoesNotExists() async {
    File file = await _localFile;
    bool fileExists = await file.exists();
    if (!fileExists) {
      await file.create(recursive: true);
    }
    return !fileExists; // Returns true if the file does NOT exist
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return fillSpecialData(); // Return an empty string or handle as appropriate
    }
  }

  int currentWorkID = 0;
  List<WorkData> workspaces = [];
  
  Future<void> readFile() async {
    String jsonString;
    //await writeData(fillSpecialData());
    if (await fileDoesNotExists()) {
      jsonString = fillSpecialData();
      writeData(jsonString);
    } else {
      jsonString = await readData();
    }
    Map<String, dynamic> data = jsonDecode(jsonString);
    for (var work in data["workspaces"]) {
      workspaces.add(WorkData(work));
    }
  }

  void jsonizeAndWrite() {
    Map<String, dynamic> map = {
      "workspaces": List.generate(workspaces.length, (index) {
        return workspaces[index].jsonize();
      })
    };
    writeData(json.encode(map));
  }

  void workChanged(int id) {
    currentWorkID = id;
  }

  bool createWorkOverlay = false;
  void createWorkOverlaySet() {
    createWorkOverlay = true;
    parentUpdate();
  }

  void createWorkOverlayUnset() {
    createWorkOverlay = false;
    parentUpdate();
  }

  bool createTaskOverlay = false;
  dynamic newTask = {
    "taskID": 0,
    "name": "Task Name",
    "color": 0,
  };

  void createTaskOverlaySet({int id=-1, String name="Task Name", int color=0}) {
    newTask["taskID"] = id;
    newTask["name"] = name;
    newTask["color"] = color;
    createTaskOverlay = true;
  }

  void createTaskOverlayUnset() {
    createTaskOverlay = false;
    parentUpdate();
  }

  void createTaskFinalize() {
    if (newTask["taskID"]==-1) {
      newTask["taskID"] = workspaces[currentWorkID].tasks.length;
      workspaces[currentWorkID].tasks.add(TaskData(newTask));
      jsonizeAndWrite();
    } else {
      workspaces[currentWorkID].updateTask(newTask);
    }
    createTaskOverlayUnset();
  }

  Function() parentCallback = () {};
  void setParentUpdate(VoidCallback update) {
    parentCallback = update;
  }
  void parentUpdate() {
    parentCallback();
  }

  dynamic newWork = {
    "id": 0,
    "name": "New Workspace",
    "icon": 2,
    "repeat": "Daily",
    "isNameMutable": true,
    "tasks": [],
    "isDeleted": false,
  };
  void createNewWorkspace() {
    if (newWork["id"]==-1) {
      newWork["id"] = workspaces.length;
      workspaces.add(WorkData(newWork));
      jsonizeAndWrite();
    } else {
        for (int i=0; i<workspaces.length; i++) {
        if (workspaces[i].getID()==newWork["id"]) {
          workspaces[i].update(newWork);
        }
      }
    }
  }

  void deleteWork() {
    workspaces[currentWorkID].delete();
    currentWorkID = 0;
    parentUpdate();
    jsonizeAndWrite();
  }

  void editWork() {
    newWork["id"] = workspaces[currentWorkID].getID();
    newWork["name"] = workspaces[currentWorkID].name;
    newWork["icon"] = workspaces[currentWorkID].iconNum;
    newWork["repeat"] = workspaces[currentWorkID].repeat;
    createWorkOverlaySet();
    jsonizeAndWrite();
  }
}