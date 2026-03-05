import 'package:flutter/material.dart';
import 'package:weather_app/core/utils/extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/detail_item.dart';

class WeatherDetailCard extends StatelessWidget {
  final DetailItem item;

  const WeatherDetailCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.all(16),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(item.icon, color: AppColors.accentPurple, size: 24),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textGrey : AppColors.textGreyLight,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              item.value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textWhite : AppColors.textDark,
              ),
            ),
          ),
          Row(
            children: [
              Icon(item.trendIcon, size: 14, color: item.trendColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  item.trend,
                  style: TextStyle(fontSize: 11, color: item.trendColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
