import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nlp/utils/app_styles.dart';
import 'package:nlp/utils/snackbar_utils.dart';
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

  Future<void> handleSubmit() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    final result = await ApiService.askQuestion(_controller.text);

    setState(() {
      _answer = result;
      _isSending = false;
    });

    _controller.clear();
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
            Text(_answer),
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
