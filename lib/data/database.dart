// ignore_for_file: unused_field

import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];
  // reference the box
  final _myBox = Hive.box('mybox');

  // run this method if this is the first time ever opening the app
  void createInitialData() {
    ["Add Some Tasks", true];
  }

// load the data from database

  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

// update the database

  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
