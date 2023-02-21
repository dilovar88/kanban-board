// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      name: fields[1] as String,
      startTime: fields[2] as DateTime,
      color: fields[3] as int,
      taskUsers: (fields[4] as List).cast<TaskUser>(),
      taskColumn: fields[5] as TaskColumn?,
      completedTime: fields[6] as DateTime?,
      movedTime: fields[7] as DateTime?,
      referenceID: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.taskUsers)
      ..writeByte(5)
      ..write(obj.taskColumn)
      ..writeByte(6)
      ..write(obj.completedTime)
      ..writeByte(7)
      ..write(obj.movedTime)
      ..writeByte(8)
      ..write(obj.referenceID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
