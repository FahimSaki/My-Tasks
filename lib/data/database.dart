import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tasks/util/mongo_service.dart';

class ToDoDataBase {
  List<Map<String, dynamic>> toDoList = [];
  final _myBox = Hive.box('mybox');

  // Connect to mongodb
  ToDoDataBase() {
    MongoService.connect();
  }

  void createInitialData() {
    toDoList = [
      {"task": "Add Some Tasks", "completed": false}
    ];
    updateDataBase(); // Save initial data
    syncWithRemote(); // Save data in mongodb
  }

  // Load data from local and mongodb
  void loadData() async {
    List<dynamic>? loadedData = _myBox.get("TODOLIST");
    if (loadedData != null) {
      toDoList = List<Map<String, dynamic>>.from(loadedData.map((item) {
        return {
          "task": item["task"],
          "completed": item["completed"],
        };
      }));
    }
    await loadRemoteData();
  }

  void toggleTaskCompletion(int index) async {
    toDoList[index]['completed'] = !toDoList[index]['completed'];
    toDoList.sort((a, b) {
      if (a['completed'] == b['completed']) {
        return 0;
      } else {
        return a['completed'] ? 1 : -1;
      }
    });
    updateDataBase();
    await MongoService.updateTask(toDoList[index]);
  }

  // Update the database local and remote
  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }

  void addTask(Map<String, dynamic> task) async {
    toDoList.add(task);
    updateDataBase();
    await MongoService.insertTask(task);
  }

  void deleteTask(int index) async {
    String taskName = toDoList[index]['task'];
    toDoList.removeAt(index);
    updateDataBase();
    await MongoService.deleteTask(taskName);
  }

  Future<void> loadRemoteData() async {
    List<Map<String, dynamic>> remoteTasks = await MongoService.fetchTasks();
    toDoList = remoteTasks;
    updateDataBase();
  }

  Future<void> syncWithRemote() async {
    for (var task in toDoList) {
      await MongoService.insertTask(task);
    }
  }
}
