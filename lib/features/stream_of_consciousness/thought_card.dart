import 'package:cockpit/models/stream_of_consciousness/thought.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// A card displaying a single thought
class ThoughtCard extends StatelessWidget {
  final Thought thought;
  final bool draggable;

  const ThoughtCard({
    super.key,
    required this.thought,
    this.draggable = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = buildThoughtCard(context);
    return draggable ? buildDraggableWrapper(card) : card;
  }

  // Wraps the card in a draggable widget
  Widget buildDraggableWrapper(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Draggable<Thought>(
          data: thought,
          feedback: SizedBox(
            width: constraints.maxWidth,
            child: child,
          ),
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: child,
          ),
          child: child,
        );
      },
    );
  }

  // Builds the card as it is displayed in a container
  Widget buildThoughtCard(BuildContext context) {
    final double cardHeight =
        Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.5 * 2;

    return Card(
      color: Theme.of(context).secondaryHeaderColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('dd.MM.yyyy hh:mm a').format(thought.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(),
            SizedBox(
              height: cardHeight,
              child: Text(
                thought.content,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
