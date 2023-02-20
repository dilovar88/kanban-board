import 'package:hive/hive.dart';
part 'task_duration.g.dart';

@HiveType(typeId: 4)
class TaskDuration  extends HiveObject {

  @HiveField(0)
  DateTime from;

  @HiveField(1)
  DateTime? to;

  TaskDuration({
    required this.from,
    this.to,
  });

  /// Get duration in seconds
  int get seconds => (to ?? DateTime.now()).difference(from).inSeconds;
}
