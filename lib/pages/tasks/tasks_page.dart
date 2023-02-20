import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:kanban_board/bloc/task/task_bloc.dart';
import 'package:kanban_board/bloc/task/task_event.dart';
import 'package:kanban_board/bloc/timer/timer_bloc.dart';
import 'package:kanban_board/models/user.dart';
import 'package:kanban_board/pages/reports_page.dart';
import 'package:kanban_board/pages/tasks/create_edit_task_page.dart';
import 'package:kanban_board/pages/tasks/task_column_dropzone_widget.dart';
import 'package:kanban_board/pages/user_page.dart';
import 'package:kanban_board/widgets/loading_overlay.dart';

import '../../bloc/task/task_state.dart';
import '../../bloc/timer/timer_event.dart';
import '../../helpers/local_storage.dart';
import '../../helpers/locator.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// Check if User exists and register
    if (registerUserIfExists()){
      /// Load previously saved data
      BlocProvider.of<TaskBloc>(context).add(const TaskLoadData());
    }
    else {
      /// Show user page
      BlocProvider.of<TaskBloc>(context).add(const TaskShowUserPage());
    }
  }

  final LoadingOverlay _loadingOverlay = LoadingOverlay();

  void handleClick(BuildContext context, String value) {
    switch (value) {
      case 'English':
        setState(() {
          context.setLocale(const Locale('en', 'US'));
          Intl.defaultLocale = context.locale.languageCode;
        });
        break;
      case 'Russian':
        setState(() {
          context.setLocale(const Locale('ru', 'RU'));
          Intl.defaultLocale = context.locale.languageCode;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (kDebugMode) {
          print(state);
        }
      if (state is TaskInitial) {
        if (state.loading) {
          _loadingOverlay.show(context);
        } else {
          _loadingOverlay.hide();
        }
      }
    },
    builder: (context, state) {
      /// Initial Tasks Board View
      if (state is TaskInitial || state is TaskAppBarActions) {
        return Scaffold(
            appBar: state is TaskAppBarActions ? actionsAppBar(context, state) : initialAppBar(context),
            backgroundColor: const Color(0xFFF7F7F7),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                 BlocProvider.of<TaskBloc>(context).add(const TaskShowCreateView());
               },
              child: const Icon(Icons.add),
            ),
            body: Stack(
              children: [
                SafeArea(
                  child: ListView(
                    children: [
                      TaskColumnDropzoneWidget()
                    ],
                  ),
                ),
              ],
            )
        );
      }
      /// Create New Task View
      else if (state is TaskCreateView) {
        return CreateEditTaskPage();
      }
      /// Edit Task View
      else if (state is TaskEditView) {
        return CreateEditTaskPage(task: state.task);
      }
      /// Reports View
      else if (state is TaskReportsView) {
        return ReportsPage();
      }
      /// User View
      else if (state is TaskUserPage) {
        return UserPage();
      }
      ///
      else {
        return const Text("Unknown State");
      }
    });
  }

  /// Initial App bar
  AppBar initialAppBar(BuildContext context) {
    return AppBar(
              title: const Text("kanban_board").tr(),
              leading: IconButton(onPressed: () => BlocProvider.of<TaskBloc>(context).add(const TaskShowReportsView())
                   , icon: const Icon(Icons.insert_chart)),
              actions: <Widget>[
                PopupMenuButton<String>(
                  icon: const Icon(Icons.language),
                  onSelected: (value) => handleClick(context, value),
                  itemBuilder: (BuildContext context) {
                    return {'English', 'Russian'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
                //
          );
  }

  /// App bar that has Task actions (Edit, delete)
  AppBar actionsAppBar(BuildContext context, TaskAppBarActions state) {
    final bloc = BlocProvider.of<TaskBloc>(context);
    return AppBar(
      backgroundColor: Colors.blueGrey,
              title: Text(state.task.name),
              leading: IconButton(onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("are_you_sure").tr(),
                      content: const Text("continue_removing").tr(),
                      actions: [
                        TextButton(
                          child: Text("no".tr()),
                          onPressed:  () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text("yes".tr()),
                          onPressed:  () {
                            bloc.add(TaskRemove(task: state.task));
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              }
                   , icon: const Icon(Icons.delete_forever)),
              actions: <Widget>[
                IconButton(onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("are_you_sure").tr(),
                        content: const Text("mark_task_as_completed").tr(),
                        actions: [
                          TextButton(
                            child: Text("no".tr()),
                            onPressed:  () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text("yes".tr()),
                            onPressed:  () {
                              bloc.add(TaskComplete(task: state.task));
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              , icon: const Icon(Icons.check)),



                IconButton(onPressed: () => bloc.add(TaskShowEditView(task: state.task))
                     , icon: const Icon(Icons.edit)),
                TextButton(onPressed: () => bloc.add(const TaskShowData()),
                    child: const Text("cancel", style: TextStyle(color: Colors.white),).tr())
              ],
                //
          );
  }
}



