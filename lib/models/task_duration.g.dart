// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_duration.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskDurationAdapter extends TypeAdapter<TaskDuration> {
  @override
  final int typeId = 4;

  @override
  TaskDuration read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskDuration(
      id: fields[0] as String,
      from: fields[1] as DateTime,
      to: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskDuration obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.from)
      ..writeByte(2)
      ..write(obj.to);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskDurationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
