import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/utils/extensions.dart';
import 'package:weather_app/data/models/weather_data.dart';

class TemperatureCardWidget extends StatelessWidget {
  final WeatherData data;
  const TemperatureCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.cardDark, AppColors.surfaceDark]
              : [AppColors.cardLight, Colors.white],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPurple.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(data.weatherEmoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 8),
          Text(
            '${data.temperature.round()}°',
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textWhite : AppColors.textDark,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'High: ${data.tempHigh.round()}°  Low: ${data.tempLow.round()}°',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.textGrey : AppColors.textGreyLight,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }
}
