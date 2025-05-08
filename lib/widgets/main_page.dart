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

  void handleSubmit() async {
    if (_controller.text.isEmpty) return;

    final result = await ApiService.askQuestion(_controller.text);
    setState(() {
      _answer = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RAG App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextfield(
              maxlength: 200,
              maxlines: null,
              hintText: 'Enter your question...',
              controller: _controller,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: handleSubmit,
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            Text(
              'Answer:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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

  const CustomTextfield({
    super.key,
    required this.maxlength,
    this.maxlines,
    required this.hintText,
    required this.controller,
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
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      controller: widget.controller,
      maxLength: widget.maxlength,
      maxLines: widget.maxlines,
      keyboardType: TextInputType.multiline,
      cursorColor: AppTheme.accent,
      style: AppTheme.inputstyle,
      decoration: InputDecoration(
        hintStyle: AppTheme.hintstyle,
        hintText: widget.hintText,
        suffixIcon: _enterButton(context),
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
    );
  }

  IconButton _enterButton(BuildContext context) {
    return IconButton(
      onPressed: widget.controller.text.isNotEmpty
          ? () async {
              String result =
                  await ApiService.askQuestion(widget.controller.text);
              print(result); // or setState(() => _response = result);
            }
          : null,
      color: AppTheme.accent,
      splashColor: AppTheme.accent,
      disabledColor: AppTheme.medium,
      splashRadius: 20,
      icon: Icon(Icons.send),
    );
  }
}
