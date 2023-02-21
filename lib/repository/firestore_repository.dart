import 'package:kanban_board/repository/task_repository.dart';
import 'package:kanban_board/repository/user_repository.dart';

class FirestoreRepository {
  static final FirestoreRepository _instance = FirestoreRepository._internal();

  /// Singleton class
  factory FirestoreRepository() {
    return _instance;
  }

  FirestoreRepository._internal();

  final TaskRepository taskRepository = TaskRepository();
  final UserRepository userRepository = UserRepository();
}