import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List<Map<String, dynamic>> toDoList = []; // Use a list of maps
  final _myBox = Hive.box('mybox');

  // Run this method if this is the first time ever opening the app
  void createInitialData() {
    toDoList = [
      {"task": "Add Some Tasks", "completed": false}
    ];
    updateDataBase(); // Save initial data
  }

  // Load the data from the database
  void loadData() {
    List<dynamic>? loadedData =
        _myBox.get("TODOLIST") as List<dynamic>?; // Get data as List<dynamic>
    if (loadedData != null) {
      toDoList = List<Map<String, dynamic>>.from(loadedData.map((item) {
        return {
          "task": item["task"],
          "completed": item["completed"],
        };
      }));
    }
  }

  // Toggle the completion status of a task
  void toggleTaskCompletion(int index) {
    toDoList[index]['completed'] = !toDoList[index]['completed'];
    // Move completed tasks to the end of the list
    toDoList.sort((a, b) {
      if (a['completed'] == b['completed'])
        return 0; // Keep original order for non-completed tasks
      return a['completed'] ? 1 : -1; // Move completed tasks to the end
    });
    updateDataBase();
  }

  // Update the database
  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
