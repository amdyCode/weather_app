import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/utils/extensions.dart';
import 'package:weather_app/data/models/weather_data.dart';

class UvCardWidget extends StatelessWidget {
  final WeatherData data;
  const UvCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final uvPercent = (data.uvIndex / 11).clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'UV Index Progress',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: uvPercent,
              minHeight: 8,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation<Color>(
                uvPercent < 0.3
                    ? Colors.greenAccent
                    : uvPercent < 0.6
                    ? Colors.orangeAccent
                    : Colors.redAccent,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.uvIndex <= 2
                ? 'The UV index is low for the rest of the day. No protection required. ☀️'
                : data.uvIndex <= 5
                ? 'Moderate UV exposure. Consider wearing sunscreen outdoors. 🧴'
                : 'High UV index! Apply sunscreen and wear protective clothing. ⚠️',
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}