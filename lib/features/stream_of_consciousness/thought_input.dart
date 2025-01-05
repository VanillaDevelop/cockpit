import 'package:cockpit/models/stream_of_consciousness/thought.dart';
import 'package:cockpit/utils/firestore.dart';
import 'package:cockpit/utils/flutter_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// This component is used to take in new thoughts, create them in Firestore, and pass the created thought to the parent component
class ThoughtInput extends StatefulWidget {
  final Function(Thought) onThoughtAdded;

  const ThoughtInput({super.key, required this.onThoughtAdded});

  @override
  State<ThoughtInput> createState() => _ThoughtInputState();
}

class _ThoughtInputState extends State<ThoughtInput> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {});
    });

    HardwareKeyboard.instance.addHandler(_handleKeyPress);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyPress);
    _textController.dispose();
    super.dispose();
  }

  bool _handleKeyPress(KeyEvent event) {
    // If the enter key is pressed, we submit the thought unless the shift key is also pressed.
    if (event.logicalKey == LogicalKeyboardKey.enter &&
        !HardwareKeyboard.instance.isShiftPressed &&
        !_isLoading) {
      sendThought(_textController.text);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: _textController,
          // Handle mobile keyboard input when the enter key is pressed
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => sendThought(_textController.text),
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            // Consistent text box border styling
            enabledBorder: buildTextBoxBorder(),
            focusedBorder: buildTextBoxBorder(),
            // Placeholder text
            hintText: 'Enter a new thought...',
            hintStyle: const TextStyle(
              color: Colors.black54,
            ),
          ),
          // Size of the input text box
          maxLines: 2,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          // Only enable the button if the text is not empty and the loading state is not active
          onPressed: (_isLoading || _textController.text.isEmpty)
              ? null
              : () => sendThought(_textController.text),
          child: const Text('Send Thought'),
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

  // Sends the thought to Firestore, updates the UI and passes the thought to the parent component
  void sendThought(String thoughtContent) async {
    if (thoughtContent.isEmpty) return;
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Create the thought object
    final thought = Thought(
      content: thoughtContent,
    );

    // Add the thought to Firestore
    bool success = await addThought(thought);
    if (success) {
      // Pass the thought to the parent component and clear the text box
      widget.onThoughtAdded(thought);
      // Clear the text box and reset the loading state
      setState(() {
        _textController.clear();
        _isLoading = false;
      });
    }

    // Show an error message if the thought was not saved, re-enable button when dismissed
    if (!success && mounted) {
      showError(context,
          'An error occurred while trying to save the thought...Please try again later!',
          onDismiss: () {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }
}
