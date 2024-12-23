import 'package:cockpit/models/thought.dart';
import 'package:flutter/material.dart';

class ThoughtCard extends StatelessWidget {
  final Thought thought;

  const ThoughtCard({super.key, required this.thought});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: double.infinity,
          height: Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.5 * 2,
          child: Text(
            thought.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
