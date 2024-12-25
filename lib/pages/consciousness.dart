import 'package:cockpit/components/app_scaffold.dart';
import 'package:cockpit/components/feature_card.dart';
import 'package:cockpit/components/responsive_grid.dart';
import 'package:flutter/material.dart';

class ConsciousnessPage extends StatelessWidget {
  const ConsciousnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: ResponsiveGrid(
        desktopColumns: 4,
        children: [
          FeatureCard(
            title: 'Uncategorized Thoughts',
            child: Placeholder(),
          ),
          FeatureCard(
            title: 'Actionable Thoughts',
            child: Placeholder(),
          ),
          FeatureCard(
            title: 'Actioned Thoughts',
            child: Placeholder(),
          ),
          FeatureCard(
            title: 'Passing Thoughts',
            child: Placeholder(),
          ),
        ],
      ),
    );
  }
}
