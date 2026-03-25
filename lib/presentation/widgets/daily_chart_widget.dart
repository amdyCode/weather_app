import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../../data/models/forecast_data.dart';

class DailyChartWidget extends StatelessWidget {
  final List<DailyForecast> forecasts;
  final int selectedDayIndex;
  final ValueChanged<int> onDaySelected;

  const DailyChartWidget({
    super.key,
    required this.forecasts,
    required this.selectedDayIndex,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

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
              const Text('📊', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Prévisions 7 jours',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LineChart(_buildChart(isDark)),
          ),
          const SizedBox(height: 16),
          _buildDaySelector(context, isDark),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 500.ms);
  }

  LineChartData _buildChart(bool isDark) {
    final maxSpots = <FlSpot>[];
    final minSpots = <FlSpot>[];

    for (int i = 0; i < forecasts.length; i++) {
      maxSpots.add(FlSpot(i.toDouble(), forecasts[i].tempMax));
      minSpots.add(FlSpot(i.toDouble(), forecasts[i].tempMin));
    }

    final allTemps = [
      ...forecasts.map((f) => f.tempMax),
      ...forecasts.map((f) => f.tempMin),
    ];
    final minTemp = allTemps.reduce((a, b) => a < b ? a : b) - 3;
    final maxTemp = allTemps.reduce((a, b) => a > b ? a : b) + 3;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 5,
        getDrawingHorizontalLine: (value) => FlLine(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= forecasts.length) {
                return const SizedBox.shrink();
              }
              final isSelected = index == selectedDayIndex;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  forecasts[index].dayOfWeek,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.accentPurple
                        : (isDark
                            ? AppColors.textGrey
                            : AppColors.textGreyLight),
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 5,
            getTitlesWidget: (value, meta) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '${value.toInt()}°',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.textGrey
                      : AppColors.textGreyLight,
                ),
              ),
            ),
          ),
        ),
        topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (forecasts.length - 1).toDouble(),
      minY: minTemp,
      maxY: maxTemp,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => AppColors.accentPurple.withValues(alpha: 0.9),
          getTooltipItems: (spots) => spots.map((spot) {
            final isMax = spot.barIndex == 0;
            return LineTooltipItem(
              '${isMax ? "Max" : "Min"}: ${spot.y.toStringAsFixed(1)}°',
              const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            );
          }).toList(),
        ),
        handleBuiltInTouches: true,
        touchCallback: (event, response) {
          if (event is FlTapUpEvent && response?.lineBarSpots != null) {
            final spot = response!.lineBarSpots!.first;
            onDaySelected(spot.x.toInt());
          }
        },
      ),
      lineBarsData: [
        // Max temperature line
        LineChartBarData(
          spots: maxSpots,
          isCurved: true,
          curveSmoothness: 0.3,
          color: AppColors.accentPurple,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
              radius: index == selectedDayIndex ? 6 : 3,
              color: AppColors.accentPurple,
              strokeWidth: 2,
              strokeColor: Colors.white,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.accentPurple.withValues(alpha: 0.3),
                AppColors.accentPurple.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
        // Min temperature line
        LineChartBarData(
          spots: minSpots,
          isCurved: true,
          curveSmoothness: 0.3,
          color: AppColors.accentCyan,
          barWidth: 2,
          isStrokeCapRound: true,
          dashArray: [5, 5],
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
              radius: index == selectedDayIndex ? 5 : 2,
              color: AppColors.accentCyan,
              strokeWidth: 2,
              strokeColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDaySelector(BuildContext context, bool isDark) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        itemBuilder: (context, index) {
          final day = forecasts[index];
          final isSelected = index == selectedDayIndex;

          return GestureDetector(
            onTap: () => onDaySelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accentPurple
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.03)),
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? null
                    : Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.08),
                      ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.dayOfWeek,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppColors.textGrey
                              : AppColors.textGreyLight),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(day.weatherEmoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(
                    '${day.tempMax.round()}°',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppColors.textWhite
                              : AppColors.textDark),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
