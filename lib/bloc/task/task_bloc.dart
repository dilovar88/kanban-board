import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kanban_board/bloc/task/task_event.dart';
import 'package:kanban_board/bloc/task/task_state.dart';
import 'package:kanban_board/helpers/constants.dart';
import 'package:uuid/uuid.dart';
import '../../helpers/local_storage.dart';
import '../../helpers/locator.dart';
import '../../models/task.dart';
import '../../models/task_column.dart';
import '../../models/task_user.dart';
import '../../models/user.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState>{
  List<Task> tasksList = [];

  List<Task> getTasks(TaskColumn taskColumn) =>
      tasksList.where((task) => task.taskColumn == taskColumn)
        .sorted((a, b) => a.movedTime != null && b.movedTime != null && a.movedTime!.isBefore(b.movedTime!) ? 1 : 0)
        .toList();

  bool hasTasks(TaskColumn taskColumn) =>
      tasksList.firstWhereOrNull((task) => task.taskColumn == taskColumn) != null;

  TaskBloc() : super(const TaskInitial()){

    /// Load Initial Data: columns, tasks
    on<TaskLoadData>((event, emit) async{
      createInitialTaskColumns();

      tasksList = await loadTasks();

      emit(const TaskInitial());
    });

    /// Show Initial Page
    on<TaskShowData>((event, emit) async{
      emit(const TaskInitial());
    });

    /// Show Add Task View
    on<TaskShowUserPage>((event, emit) {
      emit(const TaskUserPage());
    });

    /// Load Initial Data: columns, tasks
    on<TaskCreateUser>((event, emit) async{

      createUser(params: event.params);

      createInitialTaskColumns();

      tasksList = await loadTasks();

      emit(const TaskInitial());
    });

    /// Show Add Task View
    on<TaskShowReportsView>((event, emit) {
      emit(const TaskReportsView());
    });

    /// Show Add Task View
    on<TaskShowCreateView>((event, emit) {
      emit(const TaskCreateView());
    });

    /// Add Task Save Event
    on<TaskCreate>((event, emit) {

        /// set Task Column
        event.task.taskColumn = event.taskColumn;

        event.task.id = const Uuid().v1();

        /// Set completed to now
        if (event.taskColumn.name == completed){
          event.task.completedTime = DateTime.now();
        }

        /// Add task to list of tasks
        addTaskToList(task: event.task);

        /// Show Initial Page
        emit(const TaskInitial());
    });

    /// Show Edit Task View
    on<TaskShowEditView>((event, emit) {
      emit(TaskEditView(task: event.task));
    });

    on<TaskShowAppBarActions>((event, emit) {
      emit(TaskAppBarActions(task: event.task));
    });

    on<TaskRemove>((event, emit) {

      if (tasksList.contains(event.task)){
        tasksList.remove(event.task);

        deleteTask(task: event.task);
      }

      emit(const TaskInitial());
    });

    on<TaskComplete>((event, emit) {
      emit(const TaskInitial(loading: true));

      event.task.taskColumn = completedTaskColumn;
      /// Stop Last Task Duration
      event.task.stop(completed: true);

      /// Moved Time
      event.task.movedTime = DateTime.now();

      /// save to DB
      saveTask(task: event.task);

      emit(const TaskInitial());
    });

    /// Edit Task Save Event
    on<TaskSave>((event, emit) async{
      emit(const TaskInitial(loading: true));

      /// update Task column
      event.task.taskColumn = event.taskColumn;

      /// Moved Time
      if (event.updateMovedTime) {
        event.task.movedTime = DateTime.now();
      }

      /// Stop Timer when task is moved to completed column
      if (event.taskColumn.name == completed){
        event.task.stop(completed: true);
      }
      else {
        event.task.completedTime = null;
      }

      /// save to DB
      saveTask(task: event.task);

      emit(const TaskInitial());
    });
  }

  addTaskToList({required Task task}) {
    // final tasks = getIt.get<List<Task>>();

    if (tasksList.contains(task)){
      return;
    }

    /// Get Current User
    final user = GetIt.instance.get<User>();

    /// Add Current User to Task's Users List
    task.taskUsers.add(TaskUser(id: const Uuid().v1(), user: user, taskDurations: []));

    /// Add task To Task List
    tasksList.add(task);

    /// Save task in DB
    createTask(task: task);
  }

  List<Task> getCompletedTasks(){
    return tasksList.where((element) => element.isCompleted).toList();
  }


}