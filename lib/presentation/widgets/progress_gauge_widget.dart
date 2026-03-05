import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/utils/extensions.dart';

class ProgressGaugeWidget extends StatelessWidget {
  final double progress;
  final bool isComplete;
  const ProgressGaugeWidget({
    super.key,
    required this.progress,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return CircularPercentIndicator(
      radius: 100,
      lineWidth: 12,
      percent: progress.clamp(0.0, 1.0),
      animation: false,
      circularStrokeCap: CircularStrokeCap.round,
      linearGradient: const LinearGradient(
        colors: [AppColors.accentPurple, AppColors.accentCyan],
      ),
      backgroundColor: isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.06),
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textWhite : AppColors.textDark,
            ),
          ),
          Text(
            isComplete ? 'Complete!' : 'Loading...',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textGrey : AppColors.textGreyLight,
            ),
          ),
        ],
      ),
    );
  }
}
