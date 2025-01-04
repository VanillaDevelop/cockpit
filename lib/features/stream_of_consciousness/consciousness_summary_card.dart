import 'package:cockpit/features/stream_of_consciousness/thought_history.dart';
import 'package:cockpit/features/stream_of_consciousness/thought_input.dart';
import 'package:cockpit/models/stream_of_consciousness/thought.dart';
import 'package:cockpit/utils/firestore.dart';
import 'package:flutter/material.dart';

// The summary card for the stream of consciousness feature
class ConsciousnessSummaryCard extends StatefulWidget {
  const ConsciousnessSummaryCard({super.key});

  @override
  State<ConsciousnessSummaryCard> createState() =>
      _ConsciousnessSummaryCardState();
}

class _ConsciousnessSummaryCardState extends State<ConsciousnessSummaryCard> {
  // Thought history manages the list of thoughts so that it can handle the animation when a thought is added
  final GlobalKey<ThoughtHistoryState> _thoughtHistoryKey =
      GlobalKey<ThoughtHistoryState>();

  @override
  void initState() {
    super.initState();

    // Load the most recent 3 thoughts
    getThoughts(limit: 3).then((thoughts) {
      if (thoughts == null) return;
      // Add any existing thoughts to the history in order of creation
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

  // When the user creates a thought from the input box, we forward it to the history
  void _onThoughtAdded(Thought thought) {
    _thoughtHistoryKey.currentState?.addThought(thought);
  }
}
