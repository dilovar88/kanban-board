import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/helpers/helpers.dart';
import 'package:kanban_board/models/task.dart';

import '../bloc/task/task_bloc.dart';
import '../bloc/task/task_event.dart';
import '../helpers/locator.dart';
import 'package:to_csv/to_csv.dart' as exportCSV;

class ReportsPage extends StatelessWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TaskBloc>(context);
    final list = bloc.getCompletedTasks();

    return Scaffold(
        appBar: AppBar(
          title: const Text("report").tr(),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                BlocProvider.of<TaskBloc>(context).add(const TaskShowData()),
          ),
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(8)),
              child: TextButton(
                child: const Text(
                  'Export to CSV',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (bloc.tasksList.isNotEmpty) {
                    exportCSV.myCSV(
                        csvHeader, csvContent(tasksList: bloc.tasksList));
                  }
                },
              ),
            )),
          body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, index) => Card(
              child: ListTile(
                title: Text(list[index].name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${"started".tr()}: ${list[index].startTimeFormatted}"),
                    Text(
                        "${"completed".tr().ucFirst()}: ${list[index].completedTimeFormatted}"),
                    Text("${"users".tr()}: ${list[index].users}"),
                  ],
                ),
                trailing: Column(
                  children: [
                    const Icon(Icons.timer_sharp),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(list[index].totalDurationFormatted, style: const TextStyle(fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
