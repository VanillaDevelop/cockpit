import 'package:cockpit/features/stream_of_consciousness/thought_card.dart';
import 'package:flutter/material.dart';

class StreamOfConsciousness extends StatelessWidget {
  const StreamOfConsciousness({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildThoughtHistory(context),
        buildTextBox(),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Send Thought'),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Builds the history of recent thoughts
  Column buildThoughtHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Thoughts',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.list_alt),
                tooltip: 'View History',
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 240,
          child: Column(
            children: [
              ThoughtCard(),
              ThoughtCard(),
              ThoughtCard(),
            ],
          ),
        )
      ],
    );
  }

  // Builds the input text box
  Padding buildTextBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: buildTextBoxBorder(),
          focusedBorder: buildTextBoxBorder(),
          hintText: 'Enter a new thought...',
          hintStyle: const TextStyle(
            color: Colors.black54,
          ),
        ),
        maxLines: 2,
      ),
    );
  }

  // Builds the border for the text box
  OutlineInputBorder buildTextBoxBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: Colors.black12,
      ),
    );
  }
}
