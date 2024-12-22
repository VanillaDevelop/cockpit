import 'package:cockpit/components/app_scaffold.dart';
import 'package:cockpit/components/feature_card.dart';
import 'package:cockpit/components/responsive_grid.dart';
import 'package:cockpit/features/stream_of_consciousness.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: ResponsiveGrid(children: [
        FeatureCard(
          title: 'Stream of Consciousness',
          child: StreamOfConsciousness(),
        ),
        FeatureCard(
          title: 'Tasks',
          child: Text('Placeholder - Tasks'),
        ),
        FeatureCard(
          title: 'Consumable Tracker',
          child: Text('Placeholder - Consumable Tracker'),
        ),
        FeatureCard(
          title: 'Air Quality',
          child: Text('Placeholder - Air Quality'),
        ),
        FeatureCard(
          title: 'Automation Buttons',
          child: Text('Placeholder - Automation Buttons'),
        ),
        FeatureCard(
          title: 'Placeholder',
          child: Text('Placeholder'),
        ),
      ]),
    );
  }
}
