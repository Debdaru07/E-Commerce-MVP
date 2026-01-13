import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';

class StatusPill extends StatelessWidget {
  final String status;

  const StatusPill(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'Active':
        color = Colors.greenAccent;
        break;
      case 'Pending':
        color = Colors.orangeAccent;
        break;
      case 'Suspended':
        color = Colors.redAccent;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(color: color),
      ),
    );
  }
}
