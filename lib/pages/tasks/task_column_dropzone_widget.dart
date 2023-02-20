import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kanban_board/pages/tasks/task_column_widget.dart';

import '../../bloc/task/task_bloc.dart';
import '../../bloc/task/task_event.dart';
import '../../models/task.dart';
import '../../models/task_column.dart';

class TaskColumnDropzoneWidget extends StatelessWidget {
  TaskColumnDropzoneWidget({Key? key}) : super(key: key);

  final List<TaskColumn> _taskColumns = GetIt.instance.get<List<TaskColumn>>();
  final GlobalKey _draggableKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TaskBloc>(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: _taskColumns.map((item) => _buildTaskColumnWithDropZone(item, bloc)).toList(),
      ),
    );
  }

  Widget _buildTaskColumnWithDropZone(TaskColumn taskColumn, TaskBloc bloc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: DragTarget<Task>(
        builder: (context, candidateItems, rejectedItems) {
          return TaskColumnWidget(
            draggableKey: _draggableKey,
            hasItems: bloc.hasTasks(taskColumn), // taskColumn.tasks.isNotEmpty,
            highlighted: candidateItems.isNotEmpty,
            taskColumn: taskColumn,
          );
        },
        onWillAccept: (task) => task?.taskColumn != taskColumn,
        onAccept: (task) {
          /// save Task after moving to another task column
          bloc.add(TaskSave(task: task, taskColumn: taskColumn, updateMovedTime: true));
        },
      ),
    );
  }
}
