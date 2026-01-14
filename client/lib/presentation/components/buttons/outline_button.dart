import 'package:flutter/material.dart';

class OutlineButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OutlineButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed, // 👈 PASS THROUGH
      child: Text(text),
    );
  }
}
