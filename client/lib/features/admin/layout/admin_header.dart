import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          bottom: BorderSide(color: AppColors.borderDark),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Dashboard',
            style: AppTextStyles.sectionTitle,
          ),
          const Spacer(),
          const _SearchBar(),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.notifications),
            color: AppColors.textSecondary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 40,
      child: TextField(
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: 'Search users, dealers, products...',
          hintStyle: AppTextStyles.caption,
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: AppColors.textSecondary,
          ),
          filled: true,
          fillColor: const Color(0xFF292348),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
