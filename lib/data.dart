import 'dart:convert';

import 'package:flutter/material.dart';

class WorkData {
  int _id = 0;
  Icon icon = Icon(Icons.today);
  String name = "";
  bool isNameMutable = false;
  List<TaskData> tasks = [];

  WorkData(dynamic data) {
    _id = data["id"];
    icon = getIcon(data["icon"]);
    name = data["name"];
    isNameMutable = data["isNameMutable"];
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
  }
  
  int getID() {
    return _id;
  }

  Icon getIcon(String icon) {
    final Map<String, IconData> iconMap = {
      'today': Icons.today,
      'calendar_month_sharp': Icons.calendar_month_sharp,
      'create': Icons.workspaces_outline,
    };
    return Icon(iconMap[icon]);
  }

  void updateTask(dynamic task) {
    for (int i=0; i<tasks.length; i++) {
      if (tasks[i].id==task["taskID"]) {
        tasks[i].update(task);
        break;
      }
    }
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
  Data._privateConstructor() {
    readFile();
  }

  static final Data _instance = Data._privateConstructor();

  factory Data() {
    return _instance;
  }

  String fillSpecialData() {
    return '{"workspaces": [{"id": 0, "icon": "today", "name": "Today", "isNameMutable": false, "tasks": []}, {"id": 1, "icon": "calendar_month_sharp", "name": "Next Week", "isNameMutable": false, "tasks": []}]}';
  }

  int currentWorkID = 0;
  List<WorkData> workspaces = [];
  void readFile() async {
    String jsonString = fillSpecialData();
    Map<String, dynamic> data = jsonDecode(jsonString);
    for (var work in data["workspaces"]) {
      workspaces.add(WorkData(work));
    }
  }

  void workChanged(int id) {
    currentWorkID = id;
  }

  bool createWorkOverlay = false;
  void createWorkOverlaySet() {
    createWorkOverlay = true;
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

  void createNewWorkspace() {
    dynamic create = {
      "id": workspaces.length,
      "icon": "create",
      "name": "New Workspace",
      "isNameMutable": true,
      "tasks": []
    };
    workspaces.add(WorkData(create));
  }
}