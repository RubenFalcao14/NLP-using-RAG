import 'package:flutter/material.dart';
import 'package:nlp/widgets/custom_textfield.dart';
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
