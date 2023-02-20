import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:kanban_board/models/task.dart';
import 'package:kanban_board/models/task_column.dart';

@immutable
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

@immutable
class TaskShowUserPage extends TaskEvent {
  const TaskShowUserPage();
}

@immutable
class TaskCreateUser extends TaskEvent {
  final Map params;

  const TaskCreateUser({required this.params});
}

@immutable
class TaskLoadData extends TaskEvent {
  const TaskLoadData();
}

@immutable
class TaskShowData extends TaskEvent {
  const TaskShowData();
}

@immutable
class TaskShowReportsView extends TaskEvent {
  const TaskShowReportsView();
}

@immutable
class TaskShowCreateView extends TaskEvent {
  const TaskShowCreateView();
}

@immutable
class TaskCreate extends TaskEvent {
  final Task task;
  final TaskColumn taskColumn;
  const TaskCreate({required this.task, required this.taskColumn});

  @override
  List<Object> get props => [task];
}

@immutable
class TaskShowEditView extends TaskEvent {
  final Task task;
  const TaskShowEditView({required this.task});

  @override
  List<Object> get props => [task];
}

@immutable
class TaskSave extends TaskEvent {
  final Task task;
  final TaskColumn taskColumn;
  final bool updateMovedTime;
  const TaskSave({required this.task, required this.taskColumn, required this.updateMovedTime});

  @override
  List<Object> get props => [task];
}


@immutable
class TaskShowAppBarActions extends TaskEvent {
  final Task task;
  const TaskShowAppBarActions({required this.task});

  @override
  List<Object> get props => [task];
}

@immutable
class TaskRemove extends TaskEvent {
  final Task task;
  const TaskRemove({required this.task});

  @override
  List<Object> get props => [task];
}

@immutable
class TaskComplete extends TaskEvent {
  final Task task;
  const TaskComplete({required this.task});

  @override
  List<Object> get props => [task];
}
