import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban_board/models/user.dart';

class UserRepository {

  final CollectionReference collection = FirebaseFirestore.instance.collection('users');

  UserRepository();

  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  // 3
  Future<DocumentReference> create(User user) {
    return collection.add(user.toJson());
  }
  // 4
  void update(User user) async {
    await collection.doc(user.id).update(user.toJson());
  }
  // 5
  void delete(User user) async {
    await collection.doc(user.id).delete();
  }
}