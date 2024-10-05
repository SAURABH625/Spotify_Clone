// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnText;
  final double? height;
  const BasicAppButton({
    super.key,
    required this.onPressed,
    required this.btnText,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 80),
      ),
      child: Text(
        btnText,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
