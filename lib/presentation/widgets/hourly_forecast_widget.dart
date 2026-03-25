import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../../data/models/forecast_data.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<HourlyForecast> forecasts;
  final String dayLabel;

  const HourlyForecastWidget({
    super.key,
    required this.forecasts,
    required this.dayLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    if (forecasts.isEmpty) {
      return const SizedBox.shrink();
    }

    // Filtrer pour afficher toutes les 3 heures
    final filtered = <HourlyForecast>[];
    for (int i = 0; i < forecasts.length; i++) {
      if (forecasts[i].dateTime.hour % 3 == 0 || i == 0) {
        filtered.add(forecasts[i]);
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🕐', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Prévisions horaires : $dayLabel',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final h = filtered[index];
                return _buildHourCard(context, h, isDark, index);
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildHourCard(
    BuildContext context,
    HourlyForecast h,
    bool isDark,
    int index,
  ) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColors.accentPurple.withValues(alpha: 0.15),
                  AppColors.accentCyan.withValues(alpha: 0.05),
                ]
              : [
                  AppColors.accentPurple.withValues(alpha: 0.08),
                  AppColors.accentCyan.withValues(alpha: 0.03),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            h.timeLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textGrey : AppColors.textGreyLight,
            ),
          ),
          Text(h.weatherEmoji, style: const TextStyle(fontSize: 24)),
          Text(
            '${h.temperature.round()}°C',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textWhite : AppColors.textDark,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.air_rounded,
                size: 10,
                color: isDark ? AppColors.textGrey : AppColors.textGreyLight,
              ),
              const SizedBox(width: 2),
              Text(
                '${h.windSpeed.round()}',
                style: TextStyle(
                  fontSize: 9,
                  color:
                      isDark ? AppColors.textGrey : AppColors.textGreyLight,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 50 * index), duration: 300.ms)
        .slideX(begin: 0.2, end: 0);
  }
}
