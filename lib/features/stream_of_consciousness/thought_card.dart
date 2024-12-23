import 'package:flutter/material.dart';

class ThoughtCard extends StatelessWidget {
  const ThoughtCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: double.infinity,
          height: Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.5 * 2,
          child: const Text(
            'Thought ThoughtThoughtThoughtThoughtThoughtThoughtThoughtThoughtThoughtThoughtThought',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
