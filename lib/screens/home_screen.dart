import 'package:flutter/material.dart';
import 'package:nlp/services/file_service.dart';
import 'package:nlp/services/api_service.dart';
import 'package:nlp/utils/app_styles.dart';
import 'package:nlp/widgets/chat_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FileService fileService = FileService();
  List<Map<String, dynamic>> _messages = []; // Store messages
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    addListeners();
  }

  @override
  void dispose() {
    removeListeners();
    super.dispose();
  }

  void addListeners() {
    List<TextEditingController> controllers = [
      fileService.titleController
    ];

    for (TextEditingController controller in controllers) {
      controller.addListener(_onFieldChanged);
    }
  }

  void removeListeners() {
    List<TextEditingController> controllers = [
      fileService.titleController
    ];

    for (TextEditingController controller in controllers) {
      controller.removeListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() {
    setState(() {
      fileService.fieldsNotEmpty =
          fileService.titleController.text.isNotEmpty;
    });
  }

  void handleNewChat() {
  setState(() {
    _messages.clear();        // Clear all conversation messages
    fileService.titleController.clear();      // Clear the text field
  });
}


  // Add the function to handle user input and AI's response
  Future<void> handleSubmit() async {
    if (fileService.titleController.text.isEmpty) return;

    // Add user's message to the list
    setState(() {
      _messages.add({
        'text': fileService.titleController.text,
        'isUser': true,
      });
      _isLoading = true;  // Set loading state when sending
    });

    // Send the request to the API and get the AI's response
    final result = await ApiService.askQuestion(fileService.titleController.text);

    // Add AI's response to the list
    setState(() {
      _messages.add({
        'text': result,
        'isUser': false,
      });
      _isLoading = false; // Reset loading state
    });

    // Clear the input field after submission
    fileService.titleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _mainButton(() {
                  fileService.newChat(context);
                  handleNewChat();
                }, 'New Chat'),

                Row(
                  children: [
                    _actionButton(() => fileService.loadFile(context), Icons.file_upload),
                    const SizedBox(width: 8),
                    _actionButton(() => fileService.newDirectory(context), Icons.folder),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),

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

            // Text input field
            CustomTextfield(
              maxlength: 100,
              hintText: 'Enter your Prompt',
              controller: fileService.titleController,
              onSendPressed: handleSubmit,  // Using the handleSubmit function
              isSending: _isLoading,  // Show loading indicator if sending
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton _mainButton(Function()? onPressed, String text) {
    return ElevatedButton(
      onPressed: onPressed,
      style: _buttonStyle(),
      child: Text(text),
    );
  }

  IconButton _actionButton(Function()? onPressed, IconData icon) {
    return IconButton(
      onPressed: onPressed,
      splashRadius: 20,
      splashColor: AppTheme.accent,
      icon: Icon(
        icon,
        color: AppTheme.medium,
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppTheme.accent,
      foregroundColor: AppTheme.dark,
      disabledBackgroundColor: AppTheme.disabledBackgroundColor,
      disabledForegroundColor: AppTheme.disabledForegroundColor,
    );
  }
}
