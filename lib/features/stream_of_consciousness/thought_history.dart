import 'package:cockpit/models/stream_of_consciousness/thought.dart';
import 'package:flutter/material.dart';
import 'package:cockpit/features/stream_of_consciousness/thought_card.dart';

// This component is used to display the last 3 thoughts overall, and to take in new input with an animation.
class ThoughtHistory extends StatefulWidget {
  const ThoughtHistory({
    super.key,
  });

  @override
  ThoughtHistoryState createState() => ThoughtHistoryState();
}

class ThoughtHistoryState extends State<ThoughtHistory> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  //This is the list of thoughts that is currently being displayed
  final List<Thought> _thoughts = [];

  @override
  void initState() {
    super.initState();
  }

  void addThought(Thought thought) {
    //If list of thoughts is empty, set state so that the animated list displays
    if (_thoughts.isEmpty) {
      setState(() {});
    }

    //remove the oldest thought if the list is longer than 2
    if (_thoughts.length > 2) {
      _listKey.currentState?.removeItem(
          0, (context, animation) => ThoughtCard(thought: _thoughts[0]),
          duration: const Duration(milliseconds: 0));
      // Remove the thought from the data source after animation starts
      _thoughts.removeAt(0);
    }

    _thoughts.add(thought);
    _listKey.currentState?.insertItem(
      _thoughts.length - 1,
      duration: const Duration(milliseconds: 600),
    );
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
                onPressed: () {
                  Navigator.pushNamed(context, '/thoughts');
                },
                icon: const Icon(Icons.list_alt),
                tooltip: 'View History',
              ),
            ],
          ),
        ),
        SizedBox(
          height: 310,
          child: _thoughts.isNotEmpty
              ? buildThoughtSummary()
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

  Widget buildThoughtSummary() {
    return ClipRect(
      child: AnimatedList(
        key: _listKey,
        initialItemCount: _thoughts.length,
        itemBuilder: (context, index, animation) => SlideTransition(
          position: Tween(
            begin: const Offset(0.0, 1.0),
            end: const Offset(0.0, 0.0),
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: ThoughtCard(thought: _thoughts[index]),
        ),
      ),
    );
  }
}
