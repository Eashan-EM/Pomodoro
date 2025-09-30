import 'package:flutter/material.dart';
import 'package:pomodoro/misc.dart';
import 'package:pomodoro/tasks.dart';
import 'package:pomodoro/data.dart';

class WorkspaceUI extends StatefulWidget {
  const WorkspaceUI({super.key});

  @override
  State<WorkspaceUI> createState() => Workspace();
}

class Workspace extends State<WorkspaceUI> {
  Workspace._privateConstructor();

  static final Workspace _instance = Workspace._privateConstructor();
  final Task tasks = Task();
  final Data data = Data();

  factory Workspace() {
    return _instance;
  }

  void changeWorkspace(int id) {
    setState(() {
      data.workChanged(id);
    });
  }

  void workAdd() {
    setState(() {
      data.createWorkOverlaySet();
      //data.createNewWorkspace();
    });
  }

  Widget addWorkBuild() {
    List<WorkData> workspaces = data.workspaces;
    List<Widget> workUI = [];

    for (var work in workspaces) {
      if (!work.isDeleted) {
      workUI.add(
        IconButton(
          iconSize: 30,
          icon: work.icon,
          onPressed: () {
            changeWorkspace(work.getID());
          },
        )
      );
      }
    }
    workUI.add(
      IconButton(
        iconSize: 30,
        onPressed: () {
          workAdd();
        },
        icon: const Icon(Icons.add)
      )
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: workUI,
    );
  }

  Widget workspaceBuild(BuildContext context) {
    return Container(
      width: 50, // You can change this to any fixed width
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          SizedBox(height: 50),
          if (data.currentWorkID>1)
          Container(
            child: IconButton(
              onPressed: () {
                data.deleteWork();
              },
              icon: const Icon(Icons.delete),
              iconSize: 30,
            )
          ),
          if (data.currentWorkID<=1)
          SizedBox(height: 96),
          if (data.currentWorkID>1)
          Container(
            child: IconButton(
              onPressed: () {
                data.editWork();
              },
              icon: const Icon(Icons.edit),
              iconSize: 30,
            )
          ),
          Expanded(
            child: Center(
              child: addWorkBuild(),
            ),
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        workspaceBuild(context),
        tasks.tasksBuild(data.currentWorkID),
      ],
    );
  }
}

class WorkspaceAdd extends StatelessWidget {
  WorkspaceAdd({super.key});
  final TextEditingController _controller = TextEditingController();
  final Data data = Data();

  @override
  Widget build(BuildContext context) {
    data.newWork["id"] = -1;
    data.newWork["name"] = "New Workspace";
    data.newWork["icon"] = 2;
    return Container(
      width: 340,
      height: 520,
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
                labelText: 'Workspace Name',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10, right: 12)
              ),
            onSubmitted: (text) {
              data.newWork["name"] = text;
            },
            ),
            Padding(
              padding: EdgeInsetsGeometry.only(left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    "Choose Icon",
                    style: TextStyle(
                      fontFamily: "Monospace",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconGrid(),
                  Text(
                    "Repeat Interval",
                    style: TextStyle(
                      fontFamily: "Monospace",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RepeatPicker(),
                  Row(
                   children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          data.createWorkOverlayUnset();
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
                          data.createNewWorkspace();
                          data.workChanged(data.newWork["id"]);
                          data.createWorkOverlayUnset();
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

