// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:my_tasks/data/database.dart';
import 'package:my_tasks/util/dialog_box.dart';
import 'package:my_tasks/util/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the Hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  // Create an instance of AudioPlayer
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    // if this is the first time ever opening the app, the create preset data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      //there already exists data
      db.loadData();
    }
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  // text controller
  final _controller = TextEditingController();

  // List of todo tasks
  //List toDoList = [
  //["Make Tutorial", false],
  //["Do Exercise", false],
  //];

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];

      // Play sound if the task is marked as completed
      if (db.toDoList[index][1] == true) {
        _audioPlayer.play(AssetSource('assets/sounds/task_completed.mp3'));
      }
    });
    db.updateDataBase();
  }

  /* save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop;
    db.updateDataBase();
  }*/

  // save new task
  void saveNewTask() {
    String taskText = _controller.text.trim(); // Get trimmed input text
    if (taskText.isEmpty) {
      // Optionally show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task cannot be empty!'),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Exit the method early if the task is empty
    }

    setState(() {
      db.toDoList.add([taskText, false]);
      _controller.clear(); // Clear the input field after saving
    });
    Navigator.of(context).pop(); // Dismiss the dialog
    db.updateDataBase(); // Update the database
  }

  // create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () {
              Navigator.of(context).pop();
            });
      },
    );
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[500],
        title: Text(
          'TO DO',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        //shape:
        onPressed: createNewTask,
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,
      ),
      body: ListView.builder(
        /*children: [
          ToDoTile(
            taskName: "Do Exerxcise",
            taskCompleted: true,
            onChanged: (p0) {},
          ),
        ],*/
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
