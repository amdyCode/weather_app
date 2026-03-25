import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/presentation/widgets/map_card_widget.dart';
import 'package:weather_app/presentation/widgets/uv_card_widget.dart';
import 'package:weather_app/presentation/widgets/weather_details_grid.dart';
import 'package:weather_app/presentation/widgets/temperature_card_widget.dart';
import 'package:weather_app/core/utils/extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/theme_provider.dart';
import '../../data/models/weather_data.dart';

class CityDetailScreen extends StatelessWidget {
  const CityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final data = ModalRoute.of(context)!.settings.arguments as WeatherData;

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: isDark
                            ? AppColors.textWhite
                            : AppColors.textDark,
                      ),
                    ),
                    Text(
                      '${data.cityName}, ${data.country}',
                      style: context.textTheme.titleLarge,
                    ),
                    IconButton(
                      onPressed: themeProvider.toggleTheme,
                      icon: Icon(
                        isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: isDark
                            ? AppColors.accentCyan
                            : AppColors.accentPurple,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      Center(
                        child: Text(
                          '${data.weatherEmoji} ${data.condition} • ${data.temperature.round()}°C',
                          style: context.textTheme.titleMedium?.copyWith(
                            color: isDark
                                ? AppColors.textGrey
                                : AppColors.textGreyLight,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Center(
                        child: Text(
                          'Today\'s Forecast',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.accentPurple,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      TemperatureCardWidget(data: data),

                      const SizedBox(height: 20),

                      WeatherDetailsGrid(data: data),

                      const SizedBox(height: 20),

                      UvCardWidget(data: data).animate().fadeIn(delay: 500.ms, duration: 400.ms),

                      const SizedBox(height: 24),

                      Text(
                        '📍 Live Location Map',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 12),

                      MapCardWidget(
                        latitude: data.latitude,
                        longitude: data.longitude,
                        cityName: data.locality.isNotEmpty ? data.locality : data.cityName,
                        temperature: data.temperature,
                        condition: data.condition,
                      )
                          .animate()
                          .fadeIn(delay: 600.ms, duration: 500.ms)
                          .slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 24),
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
}
