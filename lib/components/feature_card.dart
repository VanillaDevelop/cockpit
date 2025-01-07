import 'package:flutter/material.dart';

// A simple component that wraps a widget in a card with a title
class FeatureCard extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? trailing;

  const FeatureCard({
    super.key,
    required this.child,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.lightBlue,
                      ),
                ),
                ...trailing ?? [],
              ],
            ),
            const Divider(),
            child
          ],
        ),
      ),
    );
  }
}
