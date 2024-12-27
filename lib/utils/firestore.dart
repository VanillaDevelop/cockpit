import 'package:cockpit/models/thought.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<List<Thought>> getThoughts(
    {int limit = 0, ThoughtType? type, DateTime? olderThan}) async {
  final userId = getUser().uid;
  var query = _firestore
      .collection('users')
      .doc(userId)
      .collection('thoughts')
      .orderBy('createdAt', descending: true);

  if (type != null) {
    query = query.where('type', isEqualTo: type.name);
  }

  if (olderThan != null) {
    query = query.where('createdAt', isLessThan: olderThan);
  }

  if (limit > 0) {
    query = query.limit(limit);
  }

  final thoughts = await query.get();
  return thoughts.docs.map((doc) => Thought.fromJson(doc.data())).toList();
}

Future<bool> addThought(Thought thought) async {
  final userId = getUser().uid;
  bool success = await _firestore
      .collection('users')
      .doc(userId)
      .collection('thoughts')
      .add(thought.toJson())
      .then((value) => true)
      .catchError((error) => false);
  return success;
}

User getUser() {
  final user = _auth.currentUser;
  if (user == null) {
    throw Exception('User not found');
  }
  return user;
}
