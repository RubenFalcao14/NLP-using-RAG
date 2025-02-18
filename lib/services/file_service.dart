import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nlp/utils/snackbar_utils.dart';

class FileService {
  final TextEditingController titleController = TextEditingController();

  bool fieldsNotEmpty = false;

  File? _selectedFiled;
  String _selectedDirectory = '';
  
  void savedContent(context) async{
    final title = titleController.text;

    final textContent = "Title:\n\n$title";

    try{
      if(_selectedFiled != null){
        await _selectedFiled!.writeAsString(textContent);
      } else{
        
      }

  }catch(e){
    SnackBarUtils.showSnackbar(context, Icons.error, 'File not saved');
  }
  }

}