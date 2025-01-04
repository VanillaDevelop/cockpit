import 'package:cockpit/features/stream_of_consciousness/thought_card.dart';
import 'package:cockpit/models/thought.dart';
import 'package:flutter/material.dart';

//Stateless widget that displays a list of thoughts in a container and allows for a callback when a thought is dropped
//For the component to display the most recent thoughts, see thought_history.dart
class ThoughtContainer extends StatefulWidget {
  final List<Thought> thoughts;
  final ThoughtType thoughtType;
  final Function(Thought thought, ThoughtType thoughtType) onThoughtDropped;
  final Future<bool> Function(ThoughtType thoughtType) onLoadMoreThoughts;
  final bool startsOpen;

  const ThoughtContainer({
    super.key,
    required this.thoughts,
    required this.thoughtType,
    required this.onThoughtDropped,
    required this.onLoadMoreThoughts,
    required this.startsOpen,
  });

  @override
  State<ThoughtContainer> createState() => _ThoughtContainerState();
}

class _ThoughtContainerState extends State<ThoughtContainer> {
  late bool _isOpen;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.startsOpen;
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<Thought>(
      onAcceptWithDetails: (details) {
        widget.onThoughtDropped(details.data, widget.thoughtType);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          constraints: const BoxConstraints(minHeight: 200),
          decoration: BoxDecoration(
            color: candidateData.isNotEmpty
                ? Colors.grey.withOpacity(0.3)
                : Colors.transparent,
          ),
          child: _isOpen ? _buildThoughtContainer() : _buildClosedContainer(),
        );
      },
    );
  }

  Widget _buildThoughtContainer() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.thoughts.length,
      itemBuilder: (context, index) =>
          ThoughtCard(thought: widget.thoughts[index], draggable: true),
    );
  }

  Widget _buildClosedContainer() {
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
              onPressed: () => _loadMoreThoughts(),
              child: const Text('Load Thoughts')),
        ],
      ),
    );
  }

  void _loadMoreThoughts() async {
    bool success = await widget.onLoadMoreThoughts(widget.thoughtType);
    if (success) {
      setState(() {
        _isOpen = true;
      });
    }
  }
}
