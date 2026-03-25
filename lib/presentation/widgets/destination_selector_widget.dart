import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';

enum DestinationType { senegal, world }

class DestinationSelectorWidget extends StatelessWidget {
  final DestinationType selected;
  final ValueChanged<DestinationType> onSelect;

  const DestinationSelectorWidget({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 12,
      children: [
        _buildChip(
          context,
          label: 'Sénégal',
          icon: '🇸🇳',
          type: DestinationType.senegal,
          isDark: isDark,
        ),
        _buildChip(
          context,
          label: 'Reste du monde',
          icon: '🌍',
          type: DestinationType.world,
          isDark: isDark,
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 400.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required String icon,
    required DestinationType type,
    required bool isDark,
  }) {
    final isSelected = selected == type;

    return GestureDetector(
      onTap: () => onSelect(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentPurple
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.05)),
          borderRadius: BorderRadius.circular(30),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.1),
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentPurple.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: context.textTheme.labelLarge?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.textGrey : AppColors.textGreyLight),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
