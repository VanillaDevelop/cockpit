import 'package:cockpit/models/thought.dart';
import 'package:flutter/material.dart';
import 'package:cockpit/features/stream_of_consciousness/thought_card.dart';

class ThoughtHistory extends StatelessWidget {
  final List<Thought> thoughts;

  const ThoughtHistory({
    super.key,
    required this.thoughts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Thoughts',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.list_alt),
                tooltip: 'View History',
              ),
            ],
          ),
        ),
        SizedBox(
          height: 310,
          child: thoughts.isNotEmpty
              ? buildThoughtSummary(thoughts)
              : buildEmptyThoughtPlaceholder(),
        )
      ],
    );
  }

  Widget buildEmptyThoughtPlaceholder() {
    return const Center(
      child: Text(
        'No thoughts, head empty...',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget buildThoughtSummary(List<Thought> thoughts) {
    return ListView.builder(
      itemCount: thoughts.length,
      itemBuilder: (context, index) {
        return ThoughtCard(thought: thoughts[index]);
      },
    );
  }
}
