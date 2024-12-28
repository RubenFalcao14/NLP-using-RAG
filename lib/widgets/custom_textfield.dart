import 'package:flutter/material.dart';
import 'package:nlp/utils/app_styles.dart';

class CustomTextfield extends StatefulWidget {
  final int maxlength;
  final int? maxlines;
  final String hintText;
  final TextEditingController controller;

  const CustomTextfield({super.key, required this.maxlength, this.maxlines, required this.hintText, required this.controller});

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
      focusNode : _focusNode,
      onEditingComplete: ()=> FocusScope.of(context).nextFocus(),
      controller: widget.controller,
      maxLength: widget.maxlength,
      maxLines: widget.maxlines,
      keyboardType: TextInputType.multiline,
      cursorColor: AppTheme.accent,
      style: AppTheme.inputstyle,
      decoration: InputDecoration(
        hintStyle: AppTheme.hintstyle,
        hintText: widget.hintText,
        suffixIcon: _copyButton(context),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.accent,
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.medium,
          )
        ),
        counterStyle: AppTheme.counterstyle,
      ),
    );
  }
  IconButton _copyButton(BuildContext context){
    return IconButton(
      onPressed: (){}, 
      color: AppTheme.accent,
      icon: Icon(Icons.content_copy_rounded,),
    );
  }
}