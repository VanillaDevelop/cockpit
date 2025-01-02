import 'package:cockpit/models/thought.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

    if (draggable) {
      return Draggable<Thought>(
        data: thought,
        feedback: SizedBox(
          width: 400,
          height: 105,
          child: Material(
            color: Colors.transparent,
            child: card,
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: card,
        ),
        child: card,
      );
    }

    return card;
  }

  Card buildThoughtCard(BuildContext context) {
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
