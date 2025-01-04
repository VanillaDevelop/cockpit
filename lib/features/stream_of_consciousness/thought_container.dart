import 'package:cockpit/features/stream_of_consciousness/thought_card.dart';
import 'package:cockpit/models/stream_of_consciousness/thought.dart';
import 'package:cockpit/models/stream_of_consciousness/thought_category_container.dart';
import 'package:cockpit/models/stream_of_consciousness/thought_type.dart';
import 'package:flutter/material.dart';

//Stateless widget that displays a list of thoughts in a container and provides feedback to its parent
//when a thought is dropped or when the user wants to load more thoughts
class ThoughtContainer extends StatelessWidget {
  final ThoughtCategoryContainer thoughtCategoryContainer;
  final Function(Thought thought, ThoughtType thoughtType) onThoughtDropped;
  final Future<bool> Function(ThoughtType thoughtType) onLoadMoreThoughts;

  const ThoughtContainer({
    super.key,
    required this.thoughtCategoryContainer,
    required this.onThoughtDropped,
    required this.onLoadMoreThoughts,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<Thought>(
      onAcceptWithDetails: (details) {
        onThoughtDropped(details.data, thoughtCategoryContainer.thoughtType);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          constraints: const BoxConstraints(minHeight: 200),
          decoration: BoxDecoration(
            color: candidateData.isNotEmpty
                ? Colors.grey.withOpacity(0.3)
                : Colors.transparent,
          ),
          child: thoughtCategoryContainer.visible
              ? _buildThoughtContainer()
              : _buildHiddenContainer(context),
        );
      },
    );
  }

  Widget _buildThoughtContainer() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: thoughtCategoryContainer.thoughts.length,
      itemBuilder: (context, index) => ThoughtCard(
          thought: thoughtCategoryContainer.thoughts[index], draggable: true),
    );
  }

  Widget _buildHiddenContainer(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Thoughts in this category are not displayed by default',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Icon(
            Icons.lock,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          ElevatedButton(
              onPressed: () =>
                  onLoadMoreThoughts(thoughtCategoryContainer.thoughtType),
              child: const Text('Load Thoughts')),
        ],
      ),
    );
  }
}
