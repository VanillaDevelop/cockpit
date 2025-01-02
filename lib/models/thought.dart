enum ThoughtType {
  uncategorized,
  actionable,
  actioned,
  fleeting,
}

class Thought {
  final String? id;
  final String content;
  final DateTime createdAt;
  ThoughtType type;

  Thought({
    this.id,
    required this.content,
    required this.createdAt,
  }) : type = ThoughtType.uncategorized;

  Thought._categorized({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.type,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Thought && other.createdAt == createdAt;
  }

  @override
  int get hashCode => createdAt.hashCode;

  factory Thought.fromJson(String id, Map<String, dynamic> json) {
    return Thought._categorized(
      id: id,
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      type: ThoughtType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ThoughtType.uncategorized,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'type': type.name,
    };
  }
}
