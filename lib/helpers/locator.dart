import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kanban_board/helpers/constants.dart';
import 'package:kanban_board/helpers/local_storage.dart';
import 'package:kanban_board/models/task_column.dart';
import 'package:kanban_board/models/user.dart';
import '../models/task.dart';

GetIt getIt = GetIt.instance;

/// setup singleton variables
void setup() {
  getIt.registerSingleton<List<TaskColumn>>([]);
}

/// Register singleton user if exists in DB
bool registerUserIfExists(){
  if (LocalStorage().userBox!.isNotEmpty){
    getIt.registerSingleton(LocalStorage().userBox!.values.first);
    return true;
  }

  return false;
}

createUser({required Map params}) async{
  User user = User(accountName: params["account_name"] ?? "", firstName: params["first_name"] ?? "", lastName: params["last_name"] ?? "");
  LocalStorage().createUser(user: user);

  getIt.registerSingleton(user);
}

/// Find Column by Name
TaskColumn findTaskColumnByName({required String name}) {
  return getIt
      .get<List<TaskColumn>>()
      .firstWhere((element) => element.name == name);
}

/// Create initial columns
 createInitialTaskColumns() async {
  final toDoColumn = TaskColumn(name: toDo, color: Colors.red[300]!.value);
  final inProgressColumn = TaskColumn(name: inProgress, color: Colors.blue[300]!.value);
  final completedColumn = TaskColumn(name: completed  , color: Colors.green[300]!.value);

  getIt.get<List<TaskColumn>>().addAll([
    toDoColumn,
    inProgressColumn,
    completedColumn,
  ]);

  // await LocalStorage().taskBox?.clear(); return;

  /// Get List From Box
  Iterable<Task>? tasks = LocalStorage().taskBox?.values;
  return tasks?.toList() ?? [];
}

TaskColumn get completedTaskColumn => getIt.get<List<TaskColumn>>().firstWhere((element) => element.name == completed);

/// Get Header for Export to CSV File
List<String> get csvHeader => [
  "task".tr(),
  "started".tr(),
  "completed".tr(),
  "duration".tr(),
  "users".tr(),
];

/// Get Content for Export to CSV File
List<List<String>> csvContent({required List<Task> tasksList}) {
  var list = [csvHeader];
  
  for (var task in tasksList) {
    list.add([
      task.name,
      task.startTimeFormatted,
      task.completedTimeFormatted,
      task.totalDurationFormatted,
      task.users
    ]);
  }

  return list;
}