import 'package:flutter/material.dart';

class TextField2 extends StatelessWidget {
  String text, hintText;
  TextEditingController controller;
  TextInputType? keyboardType;
  void Function(String?)? onSaved;
  FocusNode? focusNode;
  ValueChanged<String>? onFieldSubmitted;
  TextInputAction? textInputAction;
  ValueChanged<String>? onChanged;
  bool obscureText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  String? Function(String?)? validator;

  TextField2(
      {super.key,
      required this.text,
      required this.hintText,
      required this.controller,
       this.onSaved,
      this.focusNode,
      this.onFieldSubmitted,
      this.keyboardType,
      this.textInputAction,
      this.obscureText = false,
      this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      onSaved: onSaved,
      textInputAction: textInputAction,
      focusNode: focusNode,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          labelText: text,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }
}
