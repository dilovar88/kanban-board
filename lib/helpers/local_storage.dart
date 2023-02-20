import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:kanban_board/helpers/helpers.dart';
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

  Box<User>? userBox;
  Box<Task>? taskBox;

  LocalStorage._internal();

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

  createUser({required User user}) async {
    await userBox?.add(user);
  }

  saveTask({required Task task}) async{
    await taskBox?.add(task);
  }
}