import 'package:flutter/material.dart';

class PrimaryInputField extends StatelessWidget {
  final TextEditingController textEditor;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final String label;

  const PrimaryInputField({
    required this.textEditor,
    required this.textInputType,
    required this.textInputAction,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditor,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      cursorColor: Colors.deepPurple,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.grey,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.deepPurple,
            width: 2,
          ),
        ),
      ),
    );
  }
}
