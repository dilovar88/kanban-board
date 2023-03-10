// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskUserAdapter extends TypeAdapter<TaskUser> {
  @override
  final int typeId = 2;

  @override
  TaskUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskUser(
      user: fields[1] as User,
      taskDurations: (fields[0] as List).cast<TaskDuration>(),
    );
  }

  @override
  void write(BinaryWriter writer, TaskUser obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.taskDurations)
      ..writeByte(1)
      ..write(obj.user);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
