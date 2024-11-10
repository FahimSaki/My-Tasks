import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static Db? _db;
  static DbCollection? _collection;

  static Future<void> connect() async {
    try {
      String connectionString =
          'mongodb+srv://gabrielbelmont:9cOkUqfpF4tOqDYW@cluster0.baiqv.mongodb.net/todo_app?retryWrites=true&w=majority';
      _db = Db(connectionString);
      await _db!.open();
      _collection = _db!.collection('todo_tasks');
      print("MongoDB connected");
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    }
  }

  static Future<void> insertTask(Map<String, dynamic> task) async {
    try {
      await _collection!.insert(task);
      print("Task inserted");
    } catch (e) {
      print("Error inserting task: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchTasks() async {
    try {
      return await _collection!.find().toList();
    } catch (e) {
      print("Error fetching tasks: $e");
      return [];
    }
  }

  static Future<void> updateTask(Map<String, dynamic> task) async {
    try {
      await _collection!.update(
        where.eq('task', task['task']),
        modify.set('completed', task['completed']),
      );
      print("Task updated");
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  static Future<void> deleteTask(String taskName) async {
    try {
      await _collection!.remove(where.eq('task', taskName));
      print("Task deleted");
    } catch (e) {
      print("Error deleting task: $e");
    }
  }
}
