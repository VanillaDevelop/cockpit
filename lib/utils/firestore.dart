import 'package:cockpit/models/thought.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<List<Thought>> getThoughts() async {
  final userId = getUser().uid;
  final thoughts = await _firestore
      .collection('users')
      .doc(userId)
      .collection('thoughts')
      .get();
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
