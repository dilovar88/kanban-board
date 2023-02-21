import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:kanban_board/models/task_column.dart';
import 'package:kanban_board/models/task_duration.dart';
import 'package:kanban_board/models/task_user.dart';
import 'package:kanban_board/models/user.dart';
import 'package:path_provider/path_provider.dart';

import '../models/task.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();

  /// Singleton class
  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();

  Box<User>? userBox;
  Box<Task>? taskBox;


  /// Initialize Hive Local Database
  init() async{
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      await Directory('${appDocDir.path}/db').create(recursive: true);
      /// Initiate Hive database
      Hive.init("${appDocDir.path}/db");

      /// Register adapters
      Hive.registerAdapter(TaskAdapter());
      Hive.registerAdapter(TaskColumnAdapter());
      Hive.registerAdapter(TaskUserAdapter());
      Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(TaskDurationAdapter());

      /// Create box for storing Tasks List
      // await Hive.deleteBoxFromDisk("tasks");
      // await Hive.deleteBoxFromDisk("user");
      taskBox =  await Hive.openBox("tasks");
      userBox =  await Hive.openBox("user");
    }
    catch (e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Load locally saved tasks
  List<Task> loadTasks(){
    /// Get List From Box
    Iterable<Task>? tasks = LocalStorage().taskBox?.values;
    return tasks?.toList() ?? [];
  }

  /// Create new task
  createTask({required Task task}) async{
    await taskBox?.add(task);
  }

  /// Create new user
  createUser({required User user}) async {
    await userBox?.add(user);
  }


}