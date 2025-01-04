import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final String title;
  final bool constrainHeight;

  const FeatureCard({
    super.key,
    required this.child,
    required this.title,
    this.color = Colors.white,
    this.constrainHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: constrainHeight ? constraints.maxHeight : null,
        child: Card(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.lightBlue,
                      ),
                ),
                const Divider(),
                constrainHeight ? Expanded(child: child) : child,
              ],
            ),
          ),
        ),
      );
    });
  }
}
