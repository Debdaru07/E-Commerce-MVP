import 'package:flutter/material.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_text_styles.dart';

class FilterToolbar extends StatelessWidget {
  final String hintText;
  final List<String> filters;
  final int activeIndex;

  const FilterToolbar({
    super.key,
    required this.hintText,
    required this.filters,
    this.activeIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: AppTextStyles.body,
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.textSecondary),
                hintText: hintText,
                hintStyle: AppTextStyles.caption,
                filled: true,
                fillColor: AppColors.backgroundDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ...List.generate(
            filters.length,
            (index) => _chip(
              filters[index],
              active: index == activeIndex,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, {bool active = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.backgroundDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: active ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
