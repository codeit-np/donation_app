import 'package:flutter/material.dart';

Widget inputText(
  TextEditingController controller,
  String hintText,
  IconData icon,
  bool obsecure,
  bool validate,
  TextInputType textInputType,
) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon),
      fillColor: Colors.white,
      filled: true,
    ),
    validator: (value) => validate == true
        ? value.isEmpty
            ? 'required'
            : null
        : null,
    obscureText: obsecure,
    keyboardType: textInputType,
  );
}
