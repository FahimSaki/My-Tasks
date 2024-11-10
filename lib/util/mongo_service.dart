import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static Db? _db;
  static DbCollection? _collection;

  static Future<void> connect() async {
    _db = Db(
        'mongodb+srv://gabrielbelmont:9cOkUqfpF4tOqDYW@cluster0.baiqv.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0/user/test');
    await _db!.open();
    _collection = _db!.collection('todo_tasks');
  }

  static Future<void> insertTask(Map<String, dynamic> task) async {
    await _collection!.insert(task);
  }

  static Future<List<Map<String, dynamic>>> fetchTasks() async {
    return await _collection!.find().toList();
  }

  static Future<void> updateTask(Map<String, dynamic> task) async {
    await _collection!.update(where.eq('task', task['task']),
        modify.set('completed', task['completed']));
  }

  static Future<void> deleteTask(String taskName) async {
    await _collection!.remove(where.eq('task', taskName));
  }
}
