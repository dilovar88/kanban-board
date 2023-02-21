// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_column.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskColumnAdapter extends TypeAdapter<TaskColumn> {
  @override
  final int typeId = 0;

  @override
  TaskColumn read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskColumn(
      name: fields[1] as String,
      color: fields[2] as int,
      id: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskColumn obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskColumnAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
