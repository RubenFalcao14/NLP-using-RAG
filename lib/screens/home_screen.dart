import 'package:flutter/material.dart';
import 'package:nlp/services/file_service.dart';
import 'package:nlp/services/api_service.dart';
import 'package:nlp/utils/app_styles.dart';
import 'package:nlp/widgets/custom_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FileService fileService = FileService();

  String _response = ''; // <- store the backend response
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

  Future<void> _askQuestion() async {
    setState(() {
      _isLoading = true;
      _response = '';
    });

    final result = await ApiService.askQuestion(fileService.titleController.text);

    setState(() {
      _response = result;
      _isLoading = false;
    });
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
                _mainButton(() => fileService.newChat(context), 'New Chat'),
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
            CustomTextfield(
              maxlength: 100,
              hintText: 'Enter your Prompt',
              controller: fileService.titleController,
            ),
            const SizedBox(height: 10),
            _mainButton(
              fileService.fieldsNotEmpty ? _askQuestion : null,
              'Submit',
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator(color: AppTheme.accent))
            else if (_response.isNotEmpty) ...[
              Text(
                'Answer:',
                style: AppTheme.hintstyle,
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.medium),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _response,
                  style: AppTheme.inputstyle,
                ),
              ),
            ],
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
