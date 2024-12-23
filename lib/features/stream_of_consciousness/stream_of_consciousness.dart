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
  List<Thought> recentThoughts = [];

  @override
  void initState() {
    super.initState();

    getThoughts().then((thoughts) {
      recentThoughts = thoughts;
      setState(() {
        _cleanAndSortThoughts();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ThoughtHistory(thoughts: recentThoughts),
        ThoughtInput(onThoughtAdded: _onThoughtAdded),
      ],
    );
  }

  void _cleanAndSortThoughts() {
    recentThoughts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    recentThoughts = recentThoughts.length < 3
        ? recentThoughts
        : recentThoughts.sublist(0, 3);
  }

  void _onThoughtAdded(Thought thought) {
    setState(() {
      recentThoughts.add(thought);
      _cleanAndSortThoughts();
    });
  }
}
