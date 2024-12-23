import 'package:cockpit/features/stream_of_consciousness/thought_history.dart';
import 'package:cockpit/features/stream_of_consciousness/thought_input.dart';
import 'package:cockpit/models/thought.dart';
import 'package:cockpit/utils/firestore.dart';
import 'package:flutter/material.dart';

class StreamOfConsciousness extends StatefulWidget {
  const StreamOfConsciousness({super.key});

  @override
  State<StreamOfConsciousness> createState() => _StreamOfConsciousnessState();
}

class _StreamOfConsciousnessState extends State<StreamOfConsciousness> {
  final GlobalKey<ThoughtHistoryState> _thoughtHistoryKey =
      GlobalKey<ThoughtHistoryState>();

  @override
  void initState() {
    super.initState();

    getThoughts().then((thoughts) {
      thoughts = _cleanAndSortThoughts(thoughts);
      for (int i = thoughts.length - 1; i >= 0; i--) {
        _thoughtHistoryKey.currentState?.addThought(thoughts[i]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ThoughtHistory(key: _thoughtHistoryKey),
        ThoughtInput(onThoughtAdded: _onThoughtAdded),
      ],
    );
  }

  List<Thought> _cleanAndSortThoughts(List<Thought> thoughts) {
    thoughts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    thoughts = thoughts.length < 3 ? thoughts : thoughts.sublist(0, 3);
    return thoughts;
  }

  void _onThoughtAdded(Thought thought) {
    _thoughtHistoryKey.currentState?.addThought(thought);
  }
}
