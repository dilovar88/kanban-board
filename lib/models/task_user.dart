import 'package:kanban_board/models/user.dart';
import 'package:uuid/uuid.dart';
import 'task_duration.dart';
import 'package:hive/hive.dart';

part 'task_user.g.dart';

@HiveType(typeId: 2)
class TaskUser extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  User user;

  /// Period from Start to pause/stop durations
  @HiveField(2)
  List<TaskDuration> taskDurations;

  TaskUser({
    required this.id,
    required this.user,
    required this.taskDurations,
  });

  /// Reset Durations
  clearDurations(){
    taskDurations.clear();
  }

  toJson() => {
    "id"              : id,
    "user"            : user.toJson(),
    "task_durations"  : taskDurations.map((e) => e.toJson()),
  };

  static TaskUser fromJson(Map json) => TaskUser(
    id: json["id"] ?? const Uuid().v1(),
    user: User.fromJson(json["user"]),
    taskDurations: json.containsKey("task_durations") ? (json["task_durations"] as List).map((e) => TaskDuration.fromJson(e)).toList() : [],
  );

  @override
  String toString() {
    // TODO: implement toString
    return "User: ${user.toString()}, Task Durations: ${taskDurations.length}";
  }
}
