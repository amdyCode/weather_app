import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/core/utils/extensions.dart';
import 'package:weather_app/presentation/widgets/city_progress_widget.dart';
import 'package:weather_app/presentation/widgets/progress_gauge_widget.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/weather_data.dart';
import '../../data/services/weather_service.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  double _progress = 0.0;
  int _messageIndex = 0;
  Timer? _messageTimer;
  bool _isComplete = false;
  int _cityFetched = 0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() async {
    _messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        _messageIndex =
            (_messageIndex + 1) % AppConstants.loadingMessages.length;
      });
    });

    try {
      final service = WeatherService();
      final List<WeatherData> results = [];

      for (int i = 0; i < AppConstants.targetCities.length; i++) {
        final query = AppConstants.targetCities[i];
        final data = await service.fetchWeather(query);
        results.add(data);

        if (mounted) {
          setState(() {
            _cityFetched = i + 1;
            _progress = _cityFetched / AppConstants.targetCities.length;
          });
        }
      }

      if (mounted) {
        setState(() {
          _progress = 1.0;
          _isComplete = true;
        });
        _messageTimer?.cancel();

        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            AppRoutes.goToDashboard(context, results);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        _messageTimer?.cancel();
        AppRoutes.goToError(context, e.toString());
      }
    }
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

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

              const Spacer(flex: 1),

              // Title
              Text(
                '⛅ Weather Update',
                style: context.textTheme.headlineLarge,
              ).animate().fadeIn(duration: 500.ms),

              const SizedBox(height: 48),

              ProgressGaugeWidget(isComplete: _isComplete, progress: _progress)
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                  ),

              const SizedBox(height: 40),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  _isComplete
                      ? 'BOOM 💥 Données prêtes !'
                      : AppConstants.loadingMessages[_messageIndex],
                  key: ValueKey<String>(
                    _isComplete
                        ? 'complete'
                        : AppConstants.loadingMessages[_messageIndex],
                  ),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: _isComplete
                        ? AppColors.accentCyan
                        : (isDark
                              ? AppColors.textGrey
                              : AppColors.textGreyLight),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 32),

              // City progress
              CityProgressWidget(cityFetched: _cityFetched),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
