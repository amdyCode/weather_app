import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_constants.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/utils/extensions.dart';

class CityProgressWidget extends StatelessWidget {
  final int cityFetched;
  const CityProgressWidget({super.key, required this.cityFetched});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fetching Global Cities',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          ...List.generate(AppConstants.senegalDisplayNames.length, (index) {
            final isFetched = index < cityFetched;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFetched
                          ? AppColors.accentPurple
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.black.withValues(alpha: 0.06)),
                    ),
                    child: isFetched
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppConstants.senegalDisplayNames[index],
                    style: TextStyle(
                      fontSize: 15,
                      color: isFetched
                          ? (isDark ? AppColors.textWhite : AppColors.textDark)
                          : (isDark
                                ? AppColors.textGrey
                                : AppColors.textGreyLight),
                      fontWeight: isFetched
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  if (isFetched)
                    const Text(
                      '✓',
                      style: TextStyle(
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
