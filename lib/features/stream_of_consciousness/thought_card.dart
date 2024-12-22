import 'package:flutter/material.dart';

class ThoughtCard extends StatelessWidget {
  const ThoughtCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: SizedBox(
          width: double.infinity,
          child: Text('Thought'),
        ),
      ),
    );
  }
}
