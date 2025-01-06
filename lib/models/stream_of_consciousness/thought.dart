import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cockpit/models/stream_of_consciousness/thought_type.dart';

// A single thought as stored in Firestore
class Thought {
  final String? id;
  final String content;
  final DateTime createdAt;
  ThoughtType type;

  // Default constructor requires only the text (Creating a new thought)
  Thought({
    required this.content,
  })  : type = ThoughtType.uncategorized,
        id = null,
        createdAt = DateTime.now();

  // Constructor for loading a thought from Firestore
  Thought._categorized({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.type,
  });

  // Compare thoughts by their ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Thought && other.id == id && id != null;
  }

  // Hash by ID
  @override
  int get hashCode => id.hashCode;

  // Factory method for creating a thought from Firestore
  factory Thought.fromJson(String id, Map<String, dynamic> json) {
    return Thought._categorized(
      id: id,
      content: json['content'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      type: ThoughtType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ThoughtType.uncategorized,
      ),
    );
  }

  // Convert to Firestore format
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'type': type.name,
    };
  }
}
