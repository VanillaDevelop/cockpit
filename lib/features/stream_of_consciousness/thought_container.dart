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
    return Expanded(
      child: DragTarget<Thought>(
        // Relay drop of thought to parent
        onAcceptWithDetails: (details) {
          onThoughtDropped(details.data, thoughtCategoryContainer.thoughtType);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              // Show a grey background if the user is hovering over the container
              color: candidateData.isNotEmpty
                  ? Colors.grey.withOpacity(0.3)
                  : Colors.transparent,
            ),
            // If the thoughts are not visible, render a placeholder instead that allows the user to load more thoughts
            child: thoughtCategoryContainer.visible
                ? _buildThoughtContainer(context)
                : _buildHiddenContainer(context),
          );
        },
      ),
    );
  }

  // Build the container that displays the thoughts
  Widget _buildThoughtContainer(BuildContext context) {
    if (thoughtCategoryContainer.thoughts.isEmpty) {
      return Center(
        child: Text(
          'No thoughts in this category',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      );
    }

    return ListView.builder(
      itemCount: thoughtCategoryContainer.thoughts.length + 1,
      itemBuilder: (context, index) {
        return index == thoughtCategoryContainer.thoughts.length
            ? _buildLoadMoreSection()
            : ThoughtCard(
                thought: thoughtCategoryContainer.thoughts[index],
                draggable: true,
              );
      },
    );
  }

  Widget _buildLoadMoreSection() {
    if (thoughtCategoryContainer.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (thoughtCategoryContainer.hasNextPage) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              onLoadMoreThoughts(thoughtCategoryContainer.thoughtType);
            },
            child: const Text('Load more thoughts')),
      );
    }

    return const SizedBox.shrink();
  }

  // Build the container that notifies the user that the thoughts in this category are hidden
  Widget _buildHiddenContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            'Thoughts in this category are not displayed by default. Please click the button below to load them.',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 10),
          Icon(
            Icons.lock,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () =>
                  onLoadMoreThoughts(thoughtCategoryContainer.thoughtType),
              child: const Text('Load Thoughts')),
        ],
      ),
    );
  }
}
