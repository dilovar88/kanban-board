import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:kanban_board/helpers/helpers.dart';
import 'package:kanban_board/models/task_column.dart';
import 'package:kanban_board/models/task_duration.dart';
import 'package:kanban_board/models/task_user.dart';

import 'package:kanban_board/models/user.dart';
import 'package:uuid/uuid.dart';

import 'package:hive/hive.dart';
part 'task.g.dart';

@HiveType(typeId: 1)
class Task  extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime startTime;

  @HiveField(3)
  int color;

  /// For multiple users tracking
  @HiveField(4)
  List<TaskUser> taskUsers;

  @HiveField(5)
  TaskColumn? taskColumn;

  @HiveField(6)
  DateTime? completedTime;

  @HiveField(7)
  DateTime? movedTime;

  @HiveField(8)
  String? referenceID;

  Task({
    required this.id,
    required this.name,
    required this.startTime,
    required this.color,
    required this.taskUsers,
    this.taskColumn,
    this.completedTime,
    this.movedTime,
    this.referenceID,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  /// Get Current User Task Record
  TaskUser? get taskUser {
    final user = GetIt.instance.get<User>();
    return taskUsers.firstWhereOrNull((element) => element.user == user);
  }

  /// Get Last Duration Record
  TaskDuration? get lastTaskDuration {
    final item = taskUser;

    /// If Not found or duration is empty -> no actions needed
    if (item == null || item.taskDurations.isEmpty){
      return null;
    }

    return item.taskDurations.last;
  }

  /// Get Total Duration in seconds
  int get totalDurationInSec {
    final item = taskUser;
    if (item == null){
      return 0;
    }
    
    int total = 0;
    for (var element in item.taskDurations) { total += element.seconds; }
    return total;
  }

  /// Get All List Durations
  List get taskDurations{
    final TaskUser? item = taskUser;

    if (item == null || item.taskDurations.isEmpty){
      return [];
    }

    return item.taskDurations;
  }

  /// Reset Task Duration
  void resetTaskDurations(){
    final TaskUser? item = taskUser;

    if (item == null || item.taskDurations.isEmpty){
      return;
    }

    item.clearDurations();
  }

  /// Check if Last Duration Record is On (not stopped)
  bool isOn(){
    final duration = lastTaskDuration;
    return duration == null ? false : duration.to == null;
  }

  /// Start the Task (Create New Task Duration Record)
  start(){
    final user = GetIt.instance.get<User>();
    TaskUser? item = taskUser;
    
    /// Create TaskUser record if null
    item ??= TaskUser(id: const Uuid().v1(), user: user, taskDurations: []);

    completedTime = null;
    
    /// New duration added
    item.taskDurations.add(TaskDuration(id: const Uuid().v1(), from: DateTime.now()));
  }

  /// Stop the Task
  stop({bool completed = false}){
    lastTaskDuration?.to ??= DateTime.now();
    
    if (completed){
      completedTime = DateTime.now();
    }
  }

  /// Update parameters from submitted Edit form
  updateFrom(Task task){
    name = task.name;
    startTime = task.startTime;
    color = task.color;
    completedTime = task.completedTime;
  }

  /// Create Instance from Json
  static Task fromJson(Map json) => Task(
    id: json["id"] ?? const Uuid().v1(),
    referenceID: json["name"],
    name: json["name"],
    startTime: json["start_time"] is Timestamp ? (json["start_time"] as Timestamp).toDate() : json["start_time"],
    color: json["color"],

    taskUsers: json.containsKey("task_users") ? (json["task_users"] as List).map((e) => TaskUser.fromJson(e)).toList() : [],
    taskColumn: json.containsKey("task_column") ? TaskColumn.fromJson(json["task_column"]) : null,
    completedTime: json["completed_time"] is Timestamp ? (json["completed_time"] as Timestamp).toDate() : json["completed_time"],
    movedTime: json["moved_time"] is Timestamp ? (json["moved_time"] as Timestamp).toDate() : json["moved_time"],
  );

  toJson() => {
    "id"              : id,
    "name"            : name,
    "start_time"      : startTime,
    "color"           : color,
    "task_users"      : taskUsers.map((e) => e.toJson()).toList(),
    "task_column"     : taskColumn?.toJson(),
    "completed_time"  : completedTime,
    "moved_time"      : movedTime,
  };

  /// Get Durations List for debug
  String getDurations(){
    final TaskUser? item = taskUser;

    if (item == null || item.taskDurations.isEmpty){
      return "";
    }

    return item.taskDurations.map((e) => "${formatTime(e.from)} - ${formatTime(e.to)}").join(", ");
  }

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}

/// Check if task is completed
extension IsCompleted on Task {
  bool get isCompleted => completedTime != null;
}

/// Completed Time (formatted)
extension CompletedTimeFormat on Task {
  String get completedTimeFormatted {

    if (completedTime == null){
      return "";
    }

    // if (startTime.day == completedTime?.day && startTime.difference(completedTime!).inHours < 24){
    //   return formatTime(completedTime);
    // }

    return formatDate(completedTime);
  }
}

/// Start Time (formatted)
extension StartTimeFormatted on Task {
  String get startTimeFormatted => formatDate(startTime);
}

/// Total duration formatted
extension TotalDurationFormatted on Task {
  String get totalDurationFormatted => secondsToHourMinute(totalDurationInSec);
}

/// Users involved in Task separated by comma
extension Users on Task {
  String get users => taskUsers.map((e) => e.user.fullName ).join(", ");
}
