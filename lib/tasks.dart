import 'package:flutter/material.dart';
import 'package:pomodoro/data.dart';
import 'package:pomodoro/misc.dart';

class Task {
  Task._privateConstructor();

  static final Task _instance = Task._privateConstructor();
  Data data = Data();
  int id = 0;

  factory Task() {
    return _instance;
  }

  Widget addPaddingUI() {
    return Padding(padding: EdgeInsetsGeometry.directional(top: 25, bottom: 20));
  }

  Widget addNameCardUI() {
    WorkData work = data.workspaces[id];
    return Card(
      elevation: 0,
      color: Colors.white, // or match your scaffold background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.all(12),
                  child:Transform.scale(
                    scale: 1.6, // scales the icon 2x
                    child: work.icon, // original size
                  ),
                ),
                //if (!work.isNameMutable)
                  Text(
                    work.name,
                    style: TextStyle(
                      fontFamily: "Monospace",
                      fontSize: 30.0,
                    ),
                  ),
              ]
            ),

          ],
        ),
      ),
    );
  }

  Widget addTaskaUI() {
    List<TaskData> tasks = data.workspaces[data.currentWorkID].tasks;
    List<Widget> taskUI = [];
    for (var task in tasks) {
      taskUI.add(
        Row(
          children: [
            Expanded(
              child: Dismissible(
                key: Key(task.id.toString()),
                direction: DismissDirection.horizontal, // slide left to delete
                background: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.black),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.edit, color: Colors.black),
                ),
                confirmDismiss: (direction) async {
                  if (direction==DismissDirection.endToStart) {
                    data.createTaskOverlaySet(id: task.id, name: task.name, color: task.color);
                    data.parentUpdate();
                    return false;
                  }
                  return true;
                },
                onDismissed: (direction) {
                  if (direction!=DismissDirection.endToStart) {
                    data.workspaces[data.currentWorkID].removeTask(task.id);
                  }
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 4,
                    color: task.getColor(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Padding (
                          padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                          child: Text(
                            task.name,
                            style: TextStyle(
                              fontFamily: "Monospace",
                              fontSize: 18.0
                            )
                          )
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  )
                )
              )
            )
          ]
        ),
      );
    }
    return Column(
      children: taskUI,
    );
  }

  Widget tasksBuild(int id) {
    this.id = id;
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            addPaddingUI(),
            addNameCardUI(),
            addTaskaUI(),
          ],
        ),
      ),
    );
  }
}

class TaskAdd extends StatelessWidget {
  TaskAdd({super.key});
  final TextEditingController _controller = TextEditingController();
  final Data data = Data();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      height: 300,
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
              labelText: 'Task Name',
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 10, right: 12)
            ),
            onSubmitted: (text) {
              data.newTask["name"] = text;
            },
            ),
            Padding(
              padding: EdgeInsetsGeometry.only(left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Colour",
                    style: TextStyle(
                      fontFamily: "Monospace",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  ColorPickerRow(),
                  SizedBox(height: 10),
                  Text(
                    "Remind Me At",
                    style: TextStyle(
                      fontFamily: "Monospace",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                   children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          data.createTaskOverlayUnset();
                        },
                        style: TextButton.styleFrom(
                          side: BorderSide(
                            color: Colors.red, // Border color
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Cancel")
                      )
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          data.createTaskFinalize();
                        },
                        style: TextButton.styleFrom(
                          side: BorderSide(
                            color: Colors.green, // Border color
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Add")
                      )
                    ), 
                   ], 
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}