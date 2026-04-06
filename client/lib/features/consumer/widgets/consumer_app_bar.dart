import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_text_styles.dart';

class ConsumerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ConsumerAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.backgroundDark.withOpacity(0.85),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          child: Row(
            children: [
              // ───────────────── LEFT ─────────────────
              Row(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.shopping_bag,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'STORE',
                    style: AppTextStyles.sectionTitle,
                  ),
                ],
              ),

              // ───────────────── CENTER ─────────────────
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: _SearchField(),
                  ),
                ),
              ),

              // ───────────────── RIGHT ─────────────────
              Row(
                children: [
                  const _IconButtonWithDot(
                    icon: Icons.notifications,
                    showDot: true,
                  ),
                  const SizedBox(width: 8),
                  const _IconButtonWithBadge(
                    icon: Icons.shopping_cart,
                    count: 3,
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 28,
                    width: 1,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  const SizedBox(width: 12),
                  _ProfileButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: 'Search for products, brands, and more...',
        hintStyle: AppTextStyles.body.copyWith(
          color: AppColors.textSecondary,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textSecondary,
          size: 20,
        ),
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _IconButtonWithBadge extends StatelessWidget {
  final IconData icon;
  final int count;

  const _IconButtonWithBadge({
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _IconButton(icon: icon),
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            height: 18,
            width: 18,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              count.toString(),
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;

  const _IconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
      ),
      child: Icon(
        icon,
        size: 20,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
            ),
            image: const DecorationImage(
              image: NetworkImage(
                'https://i.pravatar.cc/150?img=3',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Alex M.',
          style: AppTextStyles.subheading,
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.expand_more,
          size: 18,
          color: Colors.grey,
        ),
      ],
    );
  }
}

class _IconButtonWithDot extends StatelessWidget {
  final IconData icon;
  final bool showDot;

  const _IconButtonWithDot({
    required this.icon,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _IconButton(icon: icon),
        if (showDot)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              height: 8,
              width: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
