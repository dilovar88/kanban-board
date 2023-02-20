import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/bloc/task/task_event.dart';
import 'package:kanban_board/bloc/timer/timer_bloc.dart';
import 'package:kanban_board/bloc/timer/timer_event.dart';
import 'package:kanban_board/bloc/timer/timer_state.dart';

import '../../bloc/task/task_bloc.dart';
import '../../helpers/helpers.dart';
import '../../models/task.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimerBloc>(context);
    final width = MediaQuery.of(context).size.width - 50;

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (blocContext, state) => Container(
        width: width,
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(bloc.task.color),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Icon(Icons.drag_indicator),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          bloc.task.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
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
                            bloc.task.startTimeFormatted,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                bloc.task.isCompleted
                    ? completedWidget(context)
                    : uncompletedWidget(state, context)
              ],),
          ],
        ),
      ),
    );
  }

  Widget completedWidget(context) {
    final bloc = BlocProvider.of<TimerBloc>(context);

    return Text(
      bloc.task.totalDurationFormatted,
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget uncompletedWidget(state, context) {
    final bloc = BlocProvider.of<TimerBloc>(context);

    return SizedBox(
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 30,
            child: actions(state, context)
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            /// context.select only listens to smaller part of a state
            /// In this case, it is duration value
            secondsToHourMinute(bloc.state.duration),
            // bloc.select((TimerBloc bloc) => secondsToHourMinute(bloc.state.duration)),
            style: const TextStyle(fontSize: 14),
          ),

          /// show the name of the state for us better understanding
          // Text('${context.select((TimerBloc bloc) => bloc.state)}')
        ],
      ),
    );
  }

  Widget actions(state, context) {
    final bloc = BlocProvider.of<TimerBloc>(context);
    if (state is TimerInitial) {
      return FloatingActionButton(
          backgroundColor: Colors.green,
          child: const Icon(Icons.play_arrow),

          /// changes from current state to TimerStarted state
          onPressed: () =>
              bloc.add(TimerStarted(
                duration: bloc.task.totalDurationInSec,
              )));
    } else if (state is TimerRunInProgress) {
      return FloatingActionButton(
            backgroundColor: Colors.redAccent,
            child: const Icon(Icons.pause),

            /// changes from current state to TimerPaused state
            onPressed: () => bloc
                .add(const TimerPaused()));
    } else if (state is TimerRunPause) {
        return FloatingActionButton(
            backgroundColor: Colors.green,
            child: const Icon(Icons.play_arrow),

            /// changes from current state to TimerRunPause state
            onPressed: () => bloc
                .add(const TimerResumed()));
      } else if (state is TimerRunComplete) {
        return FloatingActionButton(
            child: const Icon(Icons.refresh),
            onPressed: () =>
                bloc.add(TimerReset()));
      }
      return const SizedBox();
  }
}
