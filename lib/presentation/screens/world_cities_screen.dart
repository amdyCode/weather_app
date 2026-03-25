import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/utils/extensions.dart';
import '../../data/models/forecast_data.dart';
import '../../core/routes/app_routes.dart';

class WorldCitiesScreen extends StatelessWidget {
  const WorldCitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final cities =
        ModalRoute.of(context)!.settings.arguments as List<ForecastData>;

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
                      '🌍 Reste du Monde',
                      style: context.textTheme.headlineMedium,
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
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Sélectionnez une ville',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: AppColors.accentPurple,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    return _buildCityCard(context, cities[index], isDark, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityCard(
    BuildContext context,
    ForecastData city,
    bool isDark,
    int index,
  ) {
    return GestureDetector(
      onTap: () => AppRoutes.goToForecastDetail(context, city),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
          ),
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
        child: Row(
          children: [
            // Weather icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accentPurple.withValues(alpha: 0.2),
                    AppColors.accentCyan.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  city.currentEmoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${city.cityName}, ${city.country}',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    city.currentDescription,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textGrey
                          : AppColors.textGreyLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.air_rounded,
                        size: 12,
                        color: isDark
                            ? AppColors.textGrey
                            : AppColors.textGreyLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${city.windSpeed.round()} km/h',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textGrey
                              : AppColors.textGreyLight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.water_drop_rounded,
                        size: 12,
                        color: isDark
                            ? AppColors.textGrey
                            : AppColors.textGreyLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${city.humidity}%',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textGrey
                              : AppColors.textGreyLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${city.currentTemp.round()}°',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textWhite : AppColors.textDark,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.accentPurple,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 100 * index),
          duration: 400.ms,
        )
        .slideX(begin: 0.1, end: 0);
  }
}
