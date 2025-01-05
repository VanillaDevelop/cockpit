import 'package:cockpit/models/stream_of_consciousness/thought.dart';
import 'package:flutter/material.dart';
import 'package:cockpit/features/stream_of_consciousness/thought_card.dart';

// This component is used to display the last 3 thoughts overall, and to take in new input with an animation.
class RecentThoughts extends StatefulWidget {
  const RecentThoughts({
    super.key,
  });

  @override
  RecentThoughtsState createState() => RecentThoughtsState();
}

class RecentThoughtsState extends State<RecentThoughts> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  //This is the list of thoughts that is currently being displayed
  final List<Thought> _thoughts = [];

  @override
  void initState() {
    super.initState();
  }

  void addThought(Thought thought) {
    //remove the oldest thought if the list already contains 3 thoughts
    if (_thoughts.length == 3) {
      //Remove without an animation, so that we can see the new thought appear
      _listKey.currentState?.removeItem(
          0, (context, animation) => ThoughtCard(thought: _thoughts[0]),
          duration: const Duration(milliseconds: 0));
      // Remove the thought from the data source after animation starts
      _thoughts.removeAt(0);
    }

    //Add the new thought to the list
    _thoughts.add(thought);
    //Add the new thought to the list with an animation
    _listKey.currentState?.insertItem(
      _thoughts.length - 1,
      duration: const Duration(milliseconds: 600),
    );

    //If the list contains 1 thought, update the state so that the animated list displays
    if (_thoughts.length == 1) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeaderBar(context),
        SizedBox(
          //"Magic number" that is equivalent to 3 thoughts plus some spacing
          height: 310,
          child: _thoughts.isNotEmpty
              ? buildThoughtSummary()
              : buildEmptyThoughtPlaceholder(),
        )
      ],
    );
  }

  // Builds the header bar with the title and a button to navigate to the full history
  Widget buildHeaderBar(BuildContext context) {
    return Padding(
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
          //Button to navigate to the full history
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/thoughts');
            },
            icon: const Icon(Icons.list_alt),
            tooltip: 'View History',
          ),
        ],
      ),
    );
  }

  // Builds the placeholder text that is displayed when there are no thoughts
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

  // Builds the animated list of thoughts
  Widget buildThoughtSummary() {
    //ClipRect prevents the animation from extending beyond the container
    return ClipRect(
      child: AnimatedList(
        key: _listKey,
        initialItemCount: _thoughts.length,
        // Slide in the new item from the bottom
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
