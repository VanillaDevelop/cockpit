import 'package:cockpit/models/thought.dart';
import 'package:cockpit/utils/firestore.dart';
import 'package:flutter/material.dart';
import 'package:cockpit/features/stream_of_consciousness/thought_card.dart';

class ThoughtHistory extends StatefulWidget {
  const ThoughtHistory({
    super.key,
  });

  @override
  State<ThoughtHistory> createState() => _ThoughtHistoryState();
}

class _ThoughtHistoryState extends State<ThoughtHistory> {
  List<Thought> recentThoughts = [];

  @override
  void initState() {
    super.initState();

    getThoughts().then((thoughts) {
      recentThoughts = thoughts;
      recentThoughts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      setState(() {
        recentThoughts = recentThoughts.length < 3
            ? recentThoughts
            : recentThoughts.sublist(0, 3);
      });
    });
  }

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
          height: 240,
          child: recentThoughts.isNotEmpty
              ? buildThoughtSummary(recentThoughts)
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
