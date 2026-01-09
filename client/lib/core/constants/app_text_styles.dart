import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const display = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    height: 1.1,
  );

  static const heading = TextStyle(fontSize: 32, fontWeight: FontWeight.w800);

  static const subheading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const body = TextStyle(fontSize: 14, height: 1.6);
}
