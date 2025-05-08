import 'package:flutter/material.dart';
import 'package:nlp/utils/app_styles.dart';
import 'package:nlp/services/api_service.dart';

class RagScreen extends StatefulWidget {
  const RagScreen({super.key});

  @override
  State<RagScreen> createState() => _RagScreenState();
}

class _RagScreenState extends State<RagScreen> {
  final TextEditingController _controller = TextEditingController();
  String _answer = '';
  bool _isSending = false;

  List<Map<String, dynamic>> _messages = []; // <- Declaring the messages list

  // Function to handle the submission of the user's question
  void handleSubmit() async {
    if (_controller.text.isEmpty) return;

    // Add the user's message to the list of messages
    setState(() {
      _messages.add({'text': _controller.text, 'isUser': true});
    });

    // Set the sending flag to true while waiting for the response
    setState(() {
      _isSending = true;
    });

    // Fetch the AI response
    final result = await ApiService.askQuestion(_controller.text);

    // Add the AI's response to the list of messages
    setState(() {
      _messages.add({'text': result, 'isUser': false});
      _isSending = false; // Set sending flag back to false
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RAG App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextfield(
              maxlength: 200,
              maxlines: null,
              hintText: 'Enter your question...',
              controller: _controller,
              onSendPressed: handleSubmit,
              isSending: _isSending,
            ),
            const SizedBox(height: 20),
            const Text(
              'Answer:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Displaying the answer from the backend
            Text(_answer),

            // Displaying chat messages
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUserMessage = message['isUser'];

                  return Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: isUserMessage ? AppTheme.accent : AppTheme.medium,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        message['text'],
                        style: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextfield extends StatefulWidget {
  final int maxlength;
  final int? maxlines;
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onSendPressed;
  final bool isSending;

  const CustomTextfield({
    super.key,
    required this.maxlength,
    this.maxlines,
    required this.hintText,
    required this.controller,
    required this.onSendPressed,
    required this.isSending,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      controller: widget.controller,
      maxLength: widget.maxlength,
      maxLines: widget.maxlines,
      keyboardType: TextInputType.multiline,
      cursorColor: AppTheme.accent,
      style: AppTheme.inputstyle,
      decoration: InputDecoration(
        hintStyle: AppTheme.hintstyle,
        hintText: widget.hintText,
        suffixIcon: IconButton(
          onPressed: widget.controller.text.isNotEmpty && !widget.isSending
              ? widget.onSendPressed
              : null,
          icon: widget.isSending
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.accent,
                  ),
                )
              : const Icon(Icons.send),
          color: AppTheme.accent,
          disabledColor: AppTheme.medium,
          splashRadius: 20,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.accent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.medium,
          ),
        ),
        counterStyle: AppTheme.counterstyle,
      ),
      onChanged: (text) {
        setState(() {}); // Rebuild to enable/disable send button
      },
    );
  }
}
