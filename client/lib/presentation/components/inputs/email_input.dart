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
          // Input container
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),

                  // 👇 Mail icon
                  Icon(
                    Icons.mail_outline,
                    size: 20,
                    color: Colors.grey,
                  ),

                  const SizedBox(width: 8),

                  // Text field
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter your work email',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // CTA button
          const SizedBox(
            height: 48,
            child: PrimaryButton(text: 'Join Waitlist'),
          ),
        ],
      ),
    );
  }
}
