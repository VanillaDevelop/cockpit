import 'package:cockpit/components/app_scaffold.dart';
import 'package:cockpit/components/feature_card.dart';
import 'package:cockpit/components/number_tooltip.dart';
import 'package:cockpit/components/responsive_grid.dart';
import 'package:cockpit/features/stream_of_consciousness/thought_container.dart';
import 'package:cockpit/models/stream_of_consciousness/thought.dart';
import 'package:cockpit/models/stream_of_consciousness/thought_category_container.dart';
import 'package:cockpit/models/stream_of_consciousness/thought_type.dart';
import 'package:cockpit/utils/firestore.dart';
import 'package:cockpit/utils/flutter_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    setThoughtCounts();
  }

  void setThoughtCounts() async {
    //Set all the thought counts
    _thoughtContainers[ThoughtType.uncategorized]!.thoughtCount =
        await getThoughtCount(ThoughtType.uncategorized);
    _thoughtContainers[ThoughtType.actionable]!.thoughtCount =
        await getThoughtCount(ThoughtType.actionable);
    _thoughtContainers[ThoughtType.actioned]!.thoughtCount =
        await getThoughtCount(ThoughtType.actioned);
    _thoughtContainers[ThoughtType.fleeting]!.thoughtCount =
        await getThoughtCount(ThoughtType.fleeting);

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ResponsiveGrid(
        adjustToScreenHeight: true,
        desktopColumns: 4,
        desktopBreakpoint: 1200,
        children: [
          FeatureCard(
            title: 'Uncategorized Thoughts',
            trailing: [
              const SizedBox(width: 8),
              NumberTooltip(
                tooltipText:
                    'You have ${_thoughtContainers[ThoughtType.uncategorized]!.thoughtCount} uncategorized thoughts!',
                count:
                    _thoughtContainers[ThoughtType.uncategorized]!.thoughtCount,
                color: Colors.lightBlue,
              ),
            ],
            child: ThoughtContainer(
                thoughtCategoryContainer:
                    _thoughtContainers[ThoughtType.uncategorized]!,
                onThoughtDropped: onThoughtDropped,
                onLoadMoreThoughts: loadNextThoughts),
          ),
          FeatureCard(
            title: 'Actionable Thoughts',
            trailing: [
              const SizedBox(width: 8),
              NumberTooltip(
                tooltipText:
                    'You have ${_thoughtContainers[ThoughtType.actionable]!.thoughtCount} actionable thoughts!',
                count: _thoughtContainers[ThoughtType.actionable]!.thoughtCount,
                color: Colors.lightBlue,
              ),
            ],
            child: ThoughtContainer(
                thoughtCategoryContainer:
                    _thoughtContainers[ThoughtType.actionable]!,
                onThoughtDropped: onThoughtDropped,
                onLoadMoreThoughts: loadNextThoughts),
          ),
          FeatureCard(
            title: 'Actioned Thoughts',
            trailing: [
              const SizedBox(width: 8),
              NumberTooltip(
                tooltipText:
                    'You have ${_thoughtContainers[ThoughtType.actioned]!.thoughtCount} actioned thoughts!',
                count: _thoughtContainers[ThoughtType.actioned]!.thoughtCount,
                color: Colors.lightBlue,
              ),
            ],
            child: ThoughtContainer(
              thoughtCategoryContainer:
                  _thoughtContainers[ThoughtType.actioned]!,
              onThoughtDropped: onThoughtDropped,
              onLoadMoreThoughts: loadNextThoughts,
            ),
          ),
          FeatureCard(
            title: 'Fleeting Thoughts',
            trailing: [
              const SizedBox(width: 8),
              NumberTooltip(
                tooltipText:
                    'You have ${_thoughtContainers[ThoughtType.fleeting]!.thoughtCount} fleeting thoughts!',
                count: _thoughtContainers[ThoughtType.fleeting]!.thoughtCount,
                color: Colors.lightBlue,
              ),
            ],
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
    setState(() {
      _thoughtContainers[thoughtType]!.loading = true;
    });

    //For safety we clear the thoughts if the container is not visible (there should be no loaded thoughts in a hidden container)
    if (!_thoughtContainers[thoughtType]!.visible) {
      _thoughtContainers[thoughtType]!.thoughts.clear();
    }
    //Then we get the oldest thought in the container and load up to 10 more thoughts before that. If the container is empty, we load the most recent 10 thoughts
    final Timestamp? olderThan =
        _thoughtContainers[thoughtType]!.nextPageTimestamp;

    List<Thought>? newThoughts =
        await getThoughts(limit: 11, type: thoughtType, olderThan: olderThan);

    if (newThoughts == null && mounted) {
      showError(context,
          'An error occurred while trying to load additional thoughts...Please try again later!');
      return false;
    } else if (mounted) {
      setState(() {
        // We set the hasNextPage flag to true if we got 11 thoughts, which means there are more thoughts to load
        // We show the next 10 thoughts and hide the loading indicator
        _thoughtContainers[thoughtType]!.hasNextPage =
            newThoughts!.length == 11;
        _thoughtContainers[thoughtType]!.nextPageTimestamp =
            _thoughtContainers[thoughtType]!.hasNextPage
                ? Timestamp.fromDate(newThoughts[9].createdAt)
                : null;
        _thoughtContainers[thoughtType]!.visible = true;

        //Remove any thoughts that are already in the container - this might happen if the user moves a thought to a different category and then loads more thoughts
        newThoughts.removeWhere((thought) =>
            _thoughtContainers[thoughtType]!.thoughts.contains(thought));
        //Add and sort thoughts
        _thoughtContainers[thoughtType]!.thoughts.addAll(
            newThoughts.length == 11
                ? newThoughts.sublist(0, 10)
                : newThoughts);
        _thoughtContainers[thoughtType]!
            .thoughts
            .sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _thoughtContainers[thoughtType]!.loading = false;
      });
    }

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
        _thoughtContainers[oldType]!.thoughtCount -= 1;
        _thoughtContainers[thoughtType]!.thoughts.add(thought);
        _thoughtContainers[thoughtType]!.thoughtCount += 1;
        _thoughtContainers[thoughtType]!
            .thoughts
            .sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    } else if (mounted) {
      showError(context,
          'An error occurred while trying to update the thought...Please try again later!');
    }
  }
}
