import 'package:flutter/material.dart';

class AddTextfield extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  TextInputType textInputType;
  AddTextfield(
      {super.key,
      required this.hint,
      required this.controller,
      this.textInputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(hintText: hint),
    );
  }
}
