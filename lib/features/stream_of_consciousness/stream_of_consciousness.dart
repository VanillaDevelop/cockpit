import 'package:cockpit/features/stream_of_consciousness/thought_history.dart';
import 'package:cockpit/features/stream_of_consciousness/thought_input.dart';
import 'package:flutter/material.dart';

class StreamOfConsciousness extends StatelessWidget {
  const StreamOfConsciousness({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ThoughtHistory(),
        ThoughtInput(),
      ],
    );
  }
}
