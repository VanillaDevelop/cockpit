import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final String title;

  const FeatureCard(
      {super.key,
      required this.child,
      required this.title,
      this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.lightBlue,
                  ),
            ),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }
}
