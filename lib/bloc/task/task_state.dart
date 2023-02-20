import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:kanban_board/models/task.dart';

@immutable
abstract class TaskState extends Equatable {
  const TaskState();

  /// state instants compare each other
  @override
  List<Object> get props => [];
}

@immutable
class TaskInitial extends TaskState{
  final bool loading;
  const TaskInitial({this.loading = false});

  @override
  List<Object> get props => [loading];

  @override
  String toString() {
    return "$runtimeType | Loading: $loading";
  }
}

@immutable
class TaskUserPage extends TaskState{
  const TaskUserPage();
}

@immutable
class TaskReportsView extends TaskState{
  const TaskReportsView();
}

@immutable
class TaskCreateView extends TaskState{
  const TaskCreateView();
}

@immutable
class TaskEditView extends TaskState{
  final Task task;
  const TaskEditView({required this.task});

  @override
  List<Object> get props => [task];
}

@immutable
class TaskAppBarActions extends TaskState{
  final Task task;
  const TaskAppBarActions({required this.task});

  @override
  List<Object> get props => [task];
}

