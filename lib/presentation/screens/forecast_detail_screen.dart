import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/utils/extensions.dart';
import '../../data/models/forecast_data.dart';
import '../widgets/daily_chart_widget.dart';
import '../widgets/hourly_forecast_widget.dart';
import '../widgets/map_card_widget.dart';

class ForecastDetailScreen extends StatefulWidget {
  const ForecastDetailScreen({super.key});

  @override
  State<ForecastDetailScreen> createState() => _ForecastDetailScreenState();
}

class _ForecastDetailScreenState extends State<ForecastDetailScreen> {
  int _selectedDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final data = ModalRoute.of(context)!.settings.arguments as ForecastData;

    final selectedDay = data.dailyForecasts[_selectedDayIndex];
    final hourlyForDay = data.hourlyForDay(selectedDay.date);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppGradients.dark : AppGradients.light,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildAppBar(context, isDark, themeProvider, data),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildCurrentWeather(context, isDark, data),
                      const SizedBox(height: 24),
                      _buildInfoCards(context, isDark, data),
                      const SizedBox(height: 24),
                      DailyChartWidget(
                        forecasts: data.dailyForecasts,
                        selectedDayIndex: _selectedDayIndex,
                        onDaySelected: (index) {
                          setState(() => _selectedDayIndex = index);
                        },
                      ),
                      const SizedBox(height: 20),
                      HourlyForecastWidget(
                        key: ValueKey(_selectedDayIndex),
                        forecasts: hourlyForDay,
                        dayLabel: _getDayLabel(selectedDay),
                      ),
                      const SizedBox(height: 24),
                      _buildLocationCard(context, isDark, data),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    bool isDark,
    ThemeProvider themeProvider,
    ForecastData data,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: isDark ? AppColors.textWhite : AppColors.textDark,
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Météo Mag',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '°C',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textGrey
                        : AppColors.textGreyLight,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: themeProvider.toggleTheme,
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: isDark ? AppColors.accentCyan : AppColors.accentPurple,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather(
    BuildContext context,
    bool isDark,
    ForecastData data,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentPurple.withValues(alpha: isDark ? 0.3 : 0.15),
            AppColors.accentCyan.withValues(alpha: isDark ? 0.15 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.my_location_rounded,
                size: 16,
                color: AppColors.accentPurple,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${data.cityName}, ${data.country}',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const SizedBox(width: 22),
              Expanded(
                child: Text(
                  data.sublocality.isNotEmpty && data.locality.isNotEmpty
                      ? '${data.sublocality}, ${data.locality}'
                      : (data.locality.isNotEmpty
                          ? data.locality
                          : '${data.latitude.toStringAsFixed(4)}° N, ${data.longitude.abs().toStringAsFixed(4)}° ${data.longitude >= 0 ? "E" : "W"}'),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textGrey : AppColors.textGreyLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${data.currentTemp.round()}°C',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textWhite : AppColors.textDark,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${data.currentEmoji} ${data.currentDescription}',
            style: context.textTheme.titleMedium?.copyWith(
              color: AppColors.accentPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildInfoCards(BuildContext context, bool isDark, ForecastData data) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoTile(
            context,
            isDark,
            icon: Icons.air_rounded,
            label: 'Vent',
            value: '${data.windSpeed.round()} km/h',
            color: AppColors.accentCyan,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoTile(
            context,
            isDark,
            icon: Icons.water_drop_rounded,
            label: 'Humidité',
            value: '${data.humidity}%',
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoTile(
            context,
            isDark,
            icon: Icons.thermostat_rounded,
            label: 'Pression',
            value: '${data.pressure.round()} hPa',
            color: AppColors.accentPurple,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildInfoTile(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textWhite : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? AppColors.textGrey : AppColors.textGreyLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(
    BuildContext context,
    bool isDark,
    ForecastData data,
  ) {
    return Container(
      width: double.infinity,
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
              const Text('📍', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Carte de localisation',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MapCardWidget(
            latitude: data.latitude,
            longitude: data.longitude,
            cityName: data.locality.isNotEmpty ? data.locality : data.cityName,
            temperature: data.currentTemp,
            condition: data.currentDescription,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
  }

  String _getDayLabel(DailyForecast day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dayDate = DateTime(day.date.year, day.date.month, day.date.day);

    if (dayDate.isAtSameMomentAs(today)) return "Aujourd'hui";
    if (dayDate.isAtSameMomentAs(today.add(const Duration(days: 1)))) {
      return 'Demain';
    }
    return '${day.dayOfWeek} ${day.date.day}/${day.date.month}';
  }
}
