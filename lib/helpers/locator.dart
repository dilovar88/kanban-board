import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kanban_board/helpers/constants.dart';
import 'package:kanban_board/helpers/local_storage.dart';
import 'package:kanban_board/models/task_column.dart';
import 'package:kanban_board/models/user.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../repository/firestore_repository.dart';

GetIt getIt = GetIt.instance;

late final FirestoreRepository repository;

/// setup singleton variables
void setup() {
  getIt.registerSingleton<FirestoreRepository>(FirestoreRepository());
  repository = getIt.get<FirestoreRepository>();
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

/// Load tasks
Future<List<Task>> loadTasks() async{
  // return await repository.taskRepository.loadTasks();

  /// locally saved
  return LocalStorage().loadTasks();
}

Future deleteTask({required Task task}) async{

  await repository.taskRepository.delete(task);

  /// Locally
  task.delete();
}

Future saveTask({required Task task}) async{
  /// save in Firestore
  await repository.taskRepository.update(task);

  /// Save locally
  task.save();
}

Future createTask({required Task task}) async{

  /// Save in Firestore
  await repository.taskRepository.create(task);

  /// Save locally
  LocalStorage().createTask(task: task);
}

Future createUser({required Map params}) async{
  User user = User(id: const Uuid().v1(), accountName: params["account_name"] ?? "", firstName: params["first_name"] ?? "", lastName: params["last_name"] ?? "");

  /// Save in Firestore
  await repository.userRepository.create(user);

  getIt.registerSingleton(user);

  /// Save locally
  LocalStorage().createUser(user: user);
}

/// Find Column by Name
TaskColumn findTaskColumnByName({required String name}) {
  return getIt
      .get<List<TaskColumn>>()
      .firstWhere((element) => element.name == name);
}

/// Create initial columns
void createInitialTaskColumns() {
  final toDoColumn = TaskColumn(id: const Uuid().v1(), name: toDo, color: Colors.red[300]!.value);
  final inProgressColumn = TaskColumn(id: const Uuid().v1(),name: inProgress, color: Colors.blue[300]!.value);
  final completedColumn = TaskColumn(id: const Uuid().v1(),name: completed  , color: Colors.green[300]!.value);

  getIt.get<List<TaskColumn>>().addAll([
    toDoColumn,
    inProgressColumn,
    completedColumn,
  ]);
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