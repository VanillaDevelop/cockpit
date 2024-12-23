import 'package:cockpit/models/thought.dart';
import 'package:cockpit/utils/firestore.dart';
import 'package:flutter/material.dart';

class ThoughtInput extends StatefulWidget {
  const ThoughtInput({super.key});

  @override
  State<ThoughtInput> createState() => _ThoughtInputState();
}

class _ThoughtInputState extends State<ThoughtInput> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            controller: _textController,
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
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            child: ElevatedButton(
              onPressed: () {
                sendThought(_textController.text);
              },
              child: const Text('Send Thought'),
            ),
          ),
        ),
      ],
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

  void sendThought(String thoughtContent) {
    if (thoughtContent.isEmpty) return;

    final thought = Thought(
      content: thoughtContent,
      createdAt: DateTime.now(),
    );

    addThought(thought);
  }
}
