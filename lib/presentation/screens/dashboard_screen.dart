import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/core/utils/extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/weather_data.dart';

import '../widgets/weather_card_widget.dart';
import '../widgets/action_buttons_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final weatherList =
        ModalRoute.of(context)?.settings.arguments as List<WeatherData>;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppGradients.dark : AppGradients.light,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => AppRoutes.goToWelcome(context),
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: isDark
                            ? AppColors.textWhite
                            : AppColors.textDark,
                      ),
                    ),
                    Text(
                      '🌍 Weather Results',
                      style: context.textTheme.headlineMedium,
                    ),
                    IconButton(
                      onPressed: context.read<ThemeProvider>().toggleTheme,
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
                  'Top City Insights',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.accentPurple,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Weather cards list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: weatherList.length,
                  itemBuilder: (context, index) {
                    return WeatherCardWidget(
                      data: weatherList[index],
                      index: index,
                      onTap: () =>
                          AppRoutes.goToDetail(context, weatherList[index]),
                    );
                  },
                ),
              ),

              // Restart button
              Padding(
                padding: const EdgeInsets.all(20),
                child: PrimaryActionButton(
                  label: 'Recommencer 🔄',
                  icon: Icons.refresh_rounded,
                  onPressed: () => AppRoutes.restartLoading(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
