import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_duration.g.dart';

@HiveType(typeId: 4)
class TaskDuration  extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime from;

  @HiveField(2)
  DateTime? to;

  TaskDuration({
    required this.id,
    required this.from,
    this.to,
  });

  toJson() => {
    "id"      : id,
    "from"    : from,
    "to"      : to,
  };

  static TaskDuration fromJson(Map json) => TaskDuration(
    id: json["id"] ?? const Uuid().v1(),
    from: json["from"] is Timestamp ? (json["from"] as Timestamp).toDate() : json["from"],
    to: json["to"] is Timestamp ? (json["to"] as Timestamp).toDate() : json["to"],
  );

  /// Get duration in seconds
  int get seconds => (to ?? DateTime.now()).difference(from).inSeconds;
}
