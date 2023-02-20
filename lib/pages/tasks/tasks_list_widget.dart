import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/bloc/task/task_bloc.dart';
import 'package:kanban_board/bloc/timer/timer_bloc.dart';
import 'package:kanban_board/models/task_column.dart';
import 'package:kanban_board/pages/tasks/task_widget.dart';

import '../../bloc/task/task_event.dart';
import '../../models/task.dart';

class TasksListWidget extends StatelessWidget {
  const TasksListWidget(
      {required this.draggableKey, Key? key, required this.taskColumn})
      : super(key: key);
  final GlobalKey draggableKey;
  final TaskColumn taskColumn;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TaskBloc>(context);
    final tasks = bloc.getTasks(taskColumn);

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(3.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return LongPressDraggable<Task>(
          data: task,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: DraggingListItem(
            bloc: bloc,
            dragKey: draggableKey,
            task: task,
          ),
          child: Card(
              elevation: 1,
              key: UniqueKey(),
              child: BlocProvider<TimerBloc>(
                  create: (_) => TimerBloc(task: task),
                  child: const TaskWidget())),
        );
      },
    );
  }
}

/// Draggable Effect (Square color when long press)
class DraggingListItem extends StatelessWidget {
  const DraggingListItem({
    super.key,
    required this.task,
    required this.dragKey,
    required this.bloc,
  });

  final TaskBloc bloc;
  final Task task;
  final GlobalKey dragKey;

  @override
  Widget build(BuildContext context) {
    bloc.add(TaskShowAppBarActions(task: task));

    return FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: DragTaskWidget(task: task));
  }
}

/// Drag Task Widget
class DragTaskWidget extends StatelessWidget {
  const DragTaskWidget(
      {super.key, required this.task, this.isDepressed = false});

  final Task task;
  final bool isDepressed;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 50;

    return Container(
      width: width,
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(2.0),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                        height: isDepressed ? 25 : 35,
                        width: isDepressed ? 25 : 35,
                        child: ColoredBox(
                          color: Color(task.color),
                        )),
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.name,
                      style: const TextStyle(
                          fontSize: 16, color: Colors.black54, inherit: false),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          task.startTimeFormatted,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              inherit: false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
