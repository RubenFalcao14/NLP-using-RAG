import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nlp/utils/snackbar_utils.dart';
import 'package:file_picker/file_picker.dart';

class FileService {
  final TextEditingController titleController = TextEditingController();

  bool fieldsNotEmpty = false;

  File? _selectedFiled;
  String _selectedDirectory = '';
  
  void saveContent(context) async{
    final title = titleController.text;

    final textContent = "Title:\n\n$title";

    try{
      if(_selectedFiled != null){
        await _selectedFiled!.writeAsString(textContent);
      } else{
        final todayDate = getTodayDate();
        String metadataDirPath = _selectedDirectory;
        if(metadataDirPath.isEmpty){
          final directory = await FilePicker.platform.getDirectoryPath();
          _selectedDirectory = metadataDirPath = directory!;
        }
        final filePath = '$metadataDirPath/$todayDate - $title - Metadata.txt';
        final newFile = File(filePath); 
        await newFile.writeAsString(textContent);
      }
    SnackBarUtils.showSnackbar(context, Icons.check_circle, 'File saved successfully');
  }catch(e){
    SnackBarUtils.showSnackbar(context, Icons.error, 'File not saved');
  }
  }

  static String getTodayDate(){
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedDate = formatter.format(now);
    return formattedDate;
  }
}