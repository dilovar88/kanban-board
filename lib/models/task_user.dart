import 'package:kanban_board/models/user.dart';
import 'task_duration.dart';
import 'package:hive/hive.dart';

part 'task_user.g.dart';

@HiveType(typeId: 2)
class TaskUser extends HiveObject {

  /// Period from Start to pause/stop durations
  @HiveField(0)
  List<TaskDuration> taskDurations;

  @HiveField(1)
  User user;

  TaskUser({
    required this.user,
    required this.taskDurations,
  });

  /// Reset Durations
  clearDurations(){
    taskDurations.clear();
  }

  @override
  String toString() {
    // TODO: implement toString
    return "User: ${user.toString()}, Task Durations: ${taskDurations.length}";
  }
}
