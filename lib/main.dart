import 'package:flutter/material.dart';
import 'package:pomodoro/workspace.dart';
import 'package:pomodoro/tasks.dart';
import 'package:pomodoro/data.dart';
import 'dart:ui';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade100),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Workspace workspace = Workspace();
  final Task tasks = Task();
  final Data data = Data();

  void addTask() {
    setState(() {
      data.createTaskOverlaySet();
    });
  }

  void updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    data.setParentUpdate(updateUI);
    return Scaffold(
      body: Stack(
        children: [
          WorkspaceUI(),
          if (data.createWorkOverlay || data.createTaskOverlay)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.00, sigmaY: 3.0), // Adjust blur here
              child: Container(
                color: Color.fromRGBO(255, 255, 255, 0.2),
              ),
            ),
          if (data.createWorkOverlay)
            Center(
              child: WorkspaceAdd(),
            ),
          if (data.createTaskOverlay)
            Center(
              child: TaskAdd(),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {addTask();},
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
