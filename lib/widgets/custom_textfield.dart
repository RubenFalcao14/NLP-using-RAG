import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nlp/utils/app_styles.dart';
import 'package:nlp/utils/snackbar_utils.dart';

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

  void copyToClipboard(context, String text){
    Clipboard.setData(ClipboardData(text: text));
    //SnackBarUtils.showSnackbar(context, Icons.content_copy, 'Copied Text');
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
      onPressed: widget.controller.text.isNotEmpty ? () => copyToClipboard(context, widget.controller.text) : null, 
      color: AppTheme.accent,
      splashColor: AppTheme.accent,
      disabledColor: AppTheme.medium,
      splashRadius: 20,
      icon: Icon(Icons.send,),
    );
  }
}