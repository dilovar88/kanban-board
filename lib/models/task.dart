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
  final String _id = const Uuid().v1();

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

  Task({
    required this.name,
    required this.startTime,
    required this.color,
    required this.taskUsers,
    this.taskColumn,
    this.completedTime,
    this.movedTime
  });

  String get id => _id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;

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
    item ??= TaskUser(user: user, taskDurations: []);

    completedTime = null;
    
    /// New duration added
    item.taskDurations.add(TaskDuration(from: DateTime.now()));
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
    name: json["name"],
    color: json["color"],
    startTime: json["start_time"],
    taskUsers: json.containsKey("task_users") ? json["task_users"] as List<TaskUser> : [],
  );

  /// To Json for print
  toJson() => {
    "name"  : name,
    "color"  : color,
    "start_date_time" : startTime,
    "task_users"      : taskUsers.join(","),
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
