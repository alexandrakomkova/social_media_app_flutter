import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final Key textFieldKey;
  final String initialValue;
  final String hintText;
  bool obscureText;
  String? Function(String?)? validator;
  void Function(String)? onChanged;


  AuthTextField({
    required this.textFieldKey,
    required this.initialValue,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // controller: _emailController,
      key: textFieldKey,
      initialValue: initialValue,
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0)
          ),
          errorStyle: TextStyle(fontSize: 12.0)
      ),
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
