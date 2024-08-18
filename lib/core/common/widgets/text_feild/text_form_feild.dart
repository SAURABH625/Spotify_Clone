import 'package:flutter/material.dart';

class MyTextFormFeild extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final Widget? sufixIcon; // Make prefixIcon nullable

  const MyTextFormFeild({
    Key? key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.sufixIcon, // Updated to be optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      decoration: InputDecoration(
        suffixIcon: sufixIcon,
        hintText: hintText,
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
    );
  }
}
