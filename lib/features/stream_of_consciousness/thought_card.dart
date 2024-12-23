import 'package:cockpit/models/thought.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ThoughtCard extends StatelessWidget {
  final Thought thought;

  const ThoughtCard({super.key, required this.thought});

  @override
  Widget build(BuildContext context) {
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
