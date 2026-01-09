import 'package:flutter/material.dart';

class OutlineButtonWidget extends StatelessWidget {
  final String text;
  const OutlineButtonWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: Text(text),
    );
  }
}
