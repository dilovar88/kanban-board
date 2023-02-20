import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/models/task_column.dart';
import 'package:kanban_board/pages/tasks/tasks_list_widget.dart';

import '../../bloc/task/task_bloc.dart';

class TaskColumnWidget extends StatelessWidget {
  const TaskColumnWidget({
    super.key,
    required this.draggableKey,
    required this.taskColumn,
    this.highlighted = false,
    this.hasItems = false,
  });

  final GlobalKey draggableKey;
  final TaskColumn taskColumn;
  final bool highlighted;
  final bool hasItems;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TaskBloc>(context);
    final tasks = bloc.getTasks(taskColumn);
    final textColor = highlighted ? Colors.white : Colors.black;

    return Transform.scale(
      scale: highlighted ? 1.04 : 1.0,
      child: Material(
        elevation: highlighted ? 6.0 : 4.0,
        borderRadius: BorderRadius.circular(10.0),
        color: highlighted ? Colors.green[400] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(taskColumn.color),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      taskColumn.name.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: textColor,
                        fontWeight:
                        hasItems ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: hasItems,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    child: Column(
                      children: [
                        Text("${tasks.length} ${getTaskLabel(tasks.length)}",
                          style:TextStyle(color: textColor,fontSize: 16.0),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Visibility(visible: hasItems, child: TasksListWidget(taskColumn: taskColumn, draggableKey: draggableKey,))
            ],
          ),
        ),
      ),
    );
  }

  getTaskLabel(int taskLen){
    return "task${taskLen != 1 ? 's' : ''}".tr();
  }
}
