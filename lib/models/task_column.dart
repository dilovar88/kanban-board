import 'package:hive/hive.dart';
part 'task_column.g.dart';

@HiveType(typeId: 0)
class TaskColumn  extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int color;

  TaskColumn({
    required this.name,
    required this.color,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskColumn &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
