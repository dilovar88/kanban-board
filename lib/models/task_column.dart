import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_column.g.dart';

@HiveType(typeId: 0)
class TaskColumn  extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int color;

  TaskColumn({
    required this.name,
    required this.color,
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskColumn &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  toJson() => {
    "id"        : id,
    "name"      : name,
    "color"     : color,
  };

  static TaskColumn fromJson(Map json) => TaskColumn(
    id: json["id"] ?? const Uuid().v1(),
    name: json["name"],
    color: json["color"],
  );
}
