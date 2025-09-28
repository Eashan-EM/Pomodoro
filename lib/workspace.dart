import 'package:flutter/material.dart';
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
      data.createNewWorkspace();
    });
  }

  Widget addWorkBuild() {
    List<WorkData> workspaces = data.workspaces;
    List<Widget> workUI = [];

    for (var work in workspaces) {
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

  void setParentFunc(VoidCallback callback) {

  }

  Widget workspaceBuild(BuildContext context) {
    return Container(
      width: 50, // You can change this to any fixed width
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Center(
        child: addWorkBuild(),
      ),
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
  const WorkspaceAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.pink,
      child: Column(
        children: [],
      ),
    );
  }
}