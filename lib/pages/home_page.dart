import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tasks/util/dialog_box.dart';
import 'package:my_tasks/util/todo_tile.dart';
import 'package:my_tasks/data/database.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:my_tasks/util/mongo_service.dart';

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
    // Load tasks from MongoDB
    _loadTasksFromMongo();
  }

  // Method to load tasks from MongoDB
  Future<void> _loadTasksFromMongo() async {
    var tasks = await MongoService.fetchTasks();
    setState(() {
      db.toDoList = tasks.map((task) {
        return {"task": task["task"], "completed": task["completed"]};
      }).toList();
    });
  }

  // Method to handle checkbox change
  void _checkBoxChanged(bool? value, int index) async {
    setState(() {
      db.toggleTaskCompletion(index);
      // Play sound if task is completed
      if (db.toDoList[index]['completed']) {
        _audioPlayer.play(AssetSource('sounds/task_completed.mp3'));
      }
    });
    // Update task in MongoDB
    await MongoService.updateTask(db.toDoList[index]);
  }

  // Method to save a new task
  void _saveNewTask() async {
    if (_controller.text.isNotEmpty) {
      var newTask = {"task": _controller.text, "completed": false};
      setState(() {
        db.addTask(newTask);
        _controller.clear();
      });
      Navigator.of(context).pop();
      // Insert task into MongoDB
      await MongoService.insertTask(newTask);
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
  void _deleteTask(int index) async {
    var taskToDelete = db.toDoList[index]["task"];
    setState(() {
      db.deleteTask(index);
      _audioPlayer.play(AssetSource('sounds/task_deleted.mp3'));
    });
    // Delete task from MongoDB
    await MongoService.deleteTask(taskToDelete);
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
