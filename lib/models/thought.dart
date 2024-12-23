enum ThoughtType {
  uncategorized,
  actionable,
  actioned,
  fleeting,
}

class Thought {
  final String id;
  final String content;
  final DateTime createdAt;
  final ThoughtType type;

  Thought({
    required this.id,
    required this.content,
    required this.createdAt,
  }) : type = ThoughtType.uncategorized;

  Thought._categorized({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.type,
  });

  factory Thought.fromJson(Map<String, dynamic> json) {
    return Thought._categorized(
      id: json['id'],
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
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'type': type.name,
    };
  }
}
