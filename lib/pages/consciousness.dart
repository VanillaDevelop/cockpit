import 'package:cockpit/components/app_scaffold.dart';
import 'package:cockpit/components/feature_card.dart';
import 'package:cockpit/components/responsive_grid.dart';
import 'package:cockpit/features/stream_of_consciousness/thought_container.dart';
import 'package:cockpit/models/thought.dart';
import 'package:cockpit/utils/firestore.dart';
import 'package:flutter/material.dart';

class ConsciousnessPage extends StatefulWidget {
  const ConsciousnessPage({super.key});

  @override
  State<ConsciousnessPage> createState() => _ConsciousnessPageState();
}

class _ConsciousnessPageState extends State<ConsciousnessPage> {
  List<Thought> _uncategorizedThoughts = [];
  List<Thought> _actionableThoughts = [];
  List<Thought> _actionedThoughts = [];
  List<Thought> _fleetingThoughts = [];

  @override
  void initState() {
    super.initState();
    //We eagerly load up to 10 uncategorized thoughts and actionable thoughts
    getThoughts(limit: 10, type: ThoughtType.uncategorized).then((thoughts) {
      // Need these wacky mount guards because the .then() is mad jank for some reason
      if (!mounted) return;
      setState(() {
        _uncategorizedThoughts = thoughts ?? [];
      });
    });
    getThoughts(limit: 10, type: ThoughtType.actionable).then((thoughts) {
      if (!mounted) return;
      setState(() {
        _actionableThoughts = thoughts ?? [];
      });
    });
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
                  thoughts: _uncategorizedThoughts,
                  thoughtType: ThoughtType.uncategorized,
                  onThoughtDropped: onThoughtDropped,
                  startsOpen: true,
                  onLoadMoreThoughts: onLoadMoreThoughts)),
          FeatureCard(
              title: 'Actionable Thoughts',
              child: ThoughtContainer(
                  thoughts: _actionableThoughts,
                  thoughtType: ThoughtType.actionable,
                  onThoughtDropped: onThoughtDropped,
                  startsOpen: true,
                  onLoadMoreThoughts: onLoadMoreThoughts)),
          FeatureCard(
            title: 'Actioned Thoughts',
            child: ThoughtContainer(
              thoughts: _actionedThoughts,
              thoughtType: ThoughtType.actioned,
              onThoughtDropped: onThoughtDropped,
              startsOpen: false,
              onLoadMoreThoughts: onLoadMoreThoughts,
            ),
          ),
          FeatureCard(
            title: 'Fleeting Thoughts',
            child: ThoughtContainer(
              thoughts: _fleetingThoughts,
              thoughtType: ThoughtType.fleeting,
              onThoughtDropped: onThoughtDropped,
              startsOpen: false,
              onLoadMoreThoughts: onLoadMoreThoughts,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> onLoadMoreThoughts(ThoughtType thoughtType) async {
    //Get oldest thought in the list and get up to 10 more thoughts before that
    final Thought? oldestThought;
    switch (thoughtType) {
      case ThoughtType.uncategorized:
        oldestThought = _uncategorizedThoughts.lastOrNull;
        break;
      case ThoughtType.actionable:
        oldestThought = _actionableThoughts.lastOrNull;
        break;
      case ThoughtType.actioned:
        oldestThought = _actionedThoughts.lastOrNull;
        break;
      case ThoughtType.fleeting:
        oldestThought = _fleetingThoughts.lastOrNull;
        break;
    }

    List<Thought>? thoughts = await getThoughts(
        limit: 10, type: thoughtType, olderThan: oldestThought?.createdAt);

    if (thoughts == null) return false;

    setState(() {
      switch (thoughtType) {
        case ThoughtType.uncategorized:
          _uncategorizedThoughts.addAll(thoughts);
          _uncategorizedThoughts
              .sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
        case ThoughtType.actionable:
          _actionableThoughts.addAll(thoughts);
          _actionableThoughts
              .sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
        case ThoughtType.actioned:
          _actionedThoughts.addAll(thoughts);
          _actionedThoughts.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
        case ThoughtType.fleeting:
          _fleetingThoughts.addAll(thoughts);
          _fleetingThoughts.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
      }
    });

    return true;
  }

  void onThoughtDropped(Thought thought, ThoughtType thoughtType) async {
    if (thought.type == thoughtType) return;

    ThoughtType oldType = thought.type;
    thought.type = thoughtType;

    bool success = await updateThought(thought);
    if (!mounted) return;

    if (success) {
      setState(() {
        switch (oldType) {
          case ThoughtType.uncategorized:
            _uncategorizedThoughts.remove(thought);
            _uncategorizedThoughts
                .sort((a, b) => a.createdAt.compareTo(b.createdAt));
            break;
          case ThoughtType.actionable:
            _actionableThoughts.remove(thought);
            _actionableThoughts
                .sort((a, b) => a.createdAt.compareTo(b.createdAt));
            break;
          case ThoughtType.actioned:
            _actionedThoughts.remove(thought);
            _actionedThoughts
                .sort((a, b) => a.createdAt.compareTo(b.createdAt));
            break;
          case ThoughtType.fleeting:
            _fleetingThoughts.remove(thought);
            _fleetingThoughts
                .sort((a, b) => a.createdAt.compareTo(b.createdAt));
            break;
        }

        switch (thoughtType) {
          case ThoughtType.uncategorized:
            _uncategorizedThoughts.add(thought);
            _uncategorizedThoughts
                .sort((a, b) => a.createdAt.compareTo(b.createdAt));
            break;
          case ThoughtType.actionable:
            _actionableThoughts.add(thought);
            _actionableThoughts
                .sort((a, b) => a.createdAt.compareTo(b.createdAt));
            break;
          case ThoughtType.actioned:
            _actionedThoughts.add(thought);
            _actionedThoughts
                .sort((a, b) => a.createdAt.compareTo(b.createdAt));
            break;
          case ThoughtType.fleeting:
            _fleetingThoughts.add(thought);
            _fleetingThoughts
                .sort((a, b) => a.createdAt.compareTo(b.createdAt));
            break;
        }
      });
    }
  }
}
