import 'package:cockpit/features/stream_of_consciousness/thought_card.dart';
import 'package:cockpit/models/thought.dart';
import 'package:flutter/material.dart';

//Stateless widget that displays a list of thoughts in a container and allows for a callback when a thought is dropped
class ThoughtContainer extends StatelessWidget {
  final List<Thought> thoughts;
  final ThoughtType thoughtType;
  final Function(Thought thought) onThoughtDropped;

  const ThoughtContainer({
    super.key,
    required this.thoughts,
    required this.thoughtType,
    required this.onThoughtDropped,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<Thought>(
      onAcceptWithDetails: (details) {
        onThoughtDropped(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: thoughts.length,
          itemBuilder: (context, index) =>
              ThoughtCard(thought: thoughts[index], draggable: true),
        );
      },
    );
  }
}
