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
    return Draggable<Thought>(
      data: thought,
      feedback: SizedBox(
        width: 400,
        height: 105,
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.5, child: child),
      child: child,
    );
  }

  // Builds the card as it is displayed in a container
  Widget buildThoughtCard(BuildContext context) {
    return Card(
      color: Theme.of(context).secondaryHeaderColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat('dd.MM.yyyy hh:mm a').format(thought.createdAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Divider(),
            SizedBox(
              width: double.infinity,
              // The height is set so that it fits exactly 2 lines. Any remaining text is cut off with ellipsis.
              height:
                  Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.5 * 2,
              child: Text(
                thought.content,
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
