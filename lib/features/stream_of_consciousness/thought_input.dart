import 'package:another_flushbar/flushbar.dart';
import 'package:cockpit/models/stream_of_consciousness/thought.dart';
import 'package:cockpit/utils/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            controller: _textController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            onSubmitted: null,
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
              onPressed: (_isLoading || _textController.text.isEmpty)
                  ? null
                  : () {
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

  void sendThought(String thoughtContent) async {
    if (thoughtContent.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final thought = Thought(
      content: thoughtContent,
    );

    bool success = await addThought(thought);
    if (success) {
      widget.onThoughtAdded(thought);
      setState(() {
        _textController.clear();
        _isLoading = false;
      });
    } else {
      showError(
          'An error occurred while trying to save the thought...Please try again later!');
    }
  }

  void showError(String message) {
    Flushbar(
      title: 'Error',
      message: message,
      icon: const Icon(
        Icons.error_outline,
        color: Colors.red,
      ),
      leftBarIndicatorColor: Colors.red,
      duration: const Duration(seconds: 3),
      onStatusChanged: (status) {
        if (status == FlushbarStatus.DISMISSED) {
          setState(() {
            _isLoading = false;
          });
        }
      },
    ).show(context);
  }
}
