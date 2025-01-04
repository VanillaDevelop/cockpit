import 'package:cockpit/components/app_scaffold.dart';
import 'package:cockpit/components/feature_card.dart';
import 'package:cockpit/components/responsive_grid.dart';
import 'package:cockpit/features/stream_of_consciousness/thought_container.dart';
import 'package:cockpit/models/stream_of_consciousness/thought.dart';
import 'package:cockpit/models/stream_of_consciousness/thought_category_container.dart';
import 'package:cockpit/models/stream_of_consciousness/thought_type.dart';
import 'package:cockpit/utils/firestore.dart';
import 'package:flutter/material.dart';

// The overview page for the stream of consciousness
class ConsciousnessOverviewPage extends StatefulWidget {
  const ConsciousnessOverviewPage({super.key});

  @override
  State<ConsciousnessOverviewPage> createState() =>
      _ConsciousnessOverviewPageState();
}

class _ConsciousnessOverviewPageState extends State<ConsciousnessOverviewPage> {
  // The current state of each thought category container
  final Map<ThoughtType, ThoughtCategoryContainer> _thoughtContainers =
      ThoughtCategoryContainer.createDefaultContainers();

  @override
  void initState() {
    super.initState();
    //We eagerly load up to 10 uncategorized thoughts and actionable thoughts
    loadNextThoughts(ThoughtType.uncategorized);
    loadNextThoughts(ThoughtType.actionable);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ResponsiveGrid(
        desktopColumns: 4,
        children: [
          FeatureCard(
              title: 'Uncategorized Thoughts',
              child: ThoughtContainer(
                  thoughtCategoryContainer:
                      _thoughtContainers[ThoughtType.uncategorized]!,
                  onThoughtDropped: onThoughtDropped,
                  onLoadMoreThoughts: loadNextThoughts)),
          FeatureCard(
              title: 'Actionable Thoughts',
              child: ThoughtContainer(
                  thoughtCategoryContainer:
                      _thoughtContainers[ThoughtType.actionable]!,
                  onThoughtDropped: onThoughtDropped,
                  onLoadMoreThoughts: loadNextThoughts)),
          FeatureCard(
            title: 'Actioned Thoughts',
            child: ThoughtContainer(
              thoughtCategoryContainer:
                  _thoughtContainers[ThoughtType.actioned]!,
              onThoughtDropped: onThoughtDropped,
              onLoadMoreThoughts: loadNextThoughts,
            ),
          ),
          FeatureCard(
            title: 'Fleeting Thoughts',
            child: ThoughtContainer(
              thoughtCategoryContainer:
                  _thoughtContainers[ThoughtType.fleeting]!,
              onThoughtDropped: onThoughtDropped,
              onLoadMoreThoughts: loadNextThoughts,
            ),
          ),
        ],
      ),
    );
  }

  // Helper function which loads the next 10 thoughts for a category and updates the state
  Future<bool> loadNextThoughts(ThoughtType thoughtType) async {
    //For safety we clear the thoughts if the container is not visible (there should be no loaded thoughts in a hidden container)
    if (!_thoughtContainers[thoughtType]!.visible) {
      _thoughtContainers[thoughtType]!.thoughts.clear();
    }
    //Then we get the oldest thought in the container and load up to 10 more thoughts before that. If the container is empty, we load the most recent 10 thoughts
    final DateTime? olderThan =
        _thoughtContainers[thoughtType]!.thoughts.lastOrNull?.createdAt;

    List<Thought>? newThoughts =
        await getThoughts(limit: 10, type: thoughtType, olderThan: olderThan);
    if (newThoughts == null) {
      //TODO error when fetching
      return false;
    }

    if (!mounted) return true;
    setState(() {
      _thoughtContainers[thoughtType]!.visible = true;
      _thoughtContainers[thoughtType]!.thoughts.addAll(newThoughts);
      _thoughtContainers[thoughtType]!
          .thoughts
          .sort((a, b) => a.createdAt.compareTo(b.createdAt));
      _thoughtContainers[thoughtType]!.loading = false;
    });

    return true;
  }

  // Callback function to move a thought to a new category (Thought is the dropped thought, thoughtType is the new category)
  void onThoughtDropped(Thought thought, ThoughtType thoughtType) async {
    // Shortcut for if the source and destination category is the same
    if (thought.type == thoughtType) return;

    // Update the thought type
    ThoughtType oldType = thought.type;
    thought.type = thoughtType;

    // Update the thought in Firestore
    bool success = await updateThought(thought);

    if (success && mounted) {
      setState(() {
        _thoughtContainers[oldType]!.thoughts.remove(thought);
        _thoughtContainers[thoughtType]!.thoughts.add(thought);
        _thoughtContainers[thoughtType]!
            .thoughts
            .sort((a, b) => a.createdAt.compareTo(b.createdAt));
      });
    } else if (mounted) {
      //TODO error when updating
    }
  }
}
