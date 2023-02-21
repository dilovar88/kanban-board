import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban_board/models/task.dart';
import 'package:kanban_board/models/task_column.dart';

class TaskRepository {

  final CollectionReference collection = FirebaseFirestore.instance.collection('tasks');

  TaskRepository();

  /// Load all tasks
  Future<List<Task>> loadTasks() async{
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collection.get();

    try {
      // Get data from docs and convert map to List
      final data = querySnapshot.docs.map((doc) =>
      Task.fromJson(doc.data() as Map)
        ..referenceID = doc.id).toList();

      return data;
    }
    catch(e){
      print(e);
    }

    return [];
  }

  /// Get Stream
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  /// Create Task
  Future<DocumentReference?>? create(Task task) async{
    try {
      final data = await collection.add(task.toJson());
      /// set reference id
      task.referenceID = data.id;
      return data;
    }
    catch(e){
      print(e);
    }

    return null;
  }

  /// Update
  Future update(Task task) async {
    try {
      if (task.referenceID != null) {
        await collection.doc(task.referenceID).update(task.toJson());
      }
    }
    catch(e){
      print(e);
    }
  }

  /// Delete
  Future delete(Task task) async {
    try {
      if (task.referenceID != null) {
        await collection.doc(task.referenceID).delete();
      }
    }
    catch(e){
      print(e);
    }
  }
}