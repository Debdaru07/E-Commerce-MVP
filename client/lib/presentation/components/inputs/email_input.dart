import 'package:flutter/material.dart';
import '../buttons/primary_button.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 420,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your work email',
              ),
            ),
          ),
          const SizedBox(width: 8),
          const PrimaryButton(text: 'Join Waitlist'),
        ],
      ),
    );
  }
}
