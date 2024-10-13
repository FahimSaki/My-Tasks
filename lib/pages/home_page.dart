import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tasks/util/dialog_box.dart';
import 'package:my_tasks/util/todo_tile.dart';
import 'package:my_tasks/data/database.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Hive box instance for storing data
  final _myBox = Hive.box('mybox');

  // Text controller for the dialog input
  final _controller = TextEditingController();

  // Audio player instance for playing sounds
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Database instance for managing to-do list
  final ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    super.initState();
    // Initialize data if the to-do list is null
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // Load existing data
      db.loadData();
    }
  }

  // Method to handle checkbox change
  void _checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toggleTaskCompletion(index);
      // Play sound if task is completed
      if (db.toDoList[index]['completed']) {
        _audioPlayer.play(AssetSource('sounds/task_completed.mp3'));
      }
    });
  }

  // Method to save a new task
  void _saveNewTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        // Add new task to the list
        db.toDoList.add({"task": _controller.text, "completed": false});
        // Clear the text field
        _controller.clear();
        // Update the database
        db.updateDataBase();
      });
      // Close the dialog
      Navigator.of(context).pop();
    }
  }

  // Method to create a new task dialog
  void _createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: _saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // Method to delete a task
  void _deleteTask(int index) {
    setState(() {
      // Remove task from the list
      db.toDoList.removeAt(index);
      // Update the database
      db.updateDataBase();
      // Play sound on task deletion
      _audioPlayer.play(AssetSource('sounds/task_deleted.mp3'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[500],
        title: const Text(
          'TO DO',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        elevation: 2,
        onPressed: _createNewTask,
        child: const Icon(
          Icons.add,
          size: 35,
          color: Colors.black,
        ),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index]['task'],
            taskCompleted: db.toDoList[index]['completed'],
            onChanged: (value) => _checkBoxChanged(value, index),
            deleteFunction: (context) => _deleteTask(index),
          );
        },
      ),
    );
  }
}
