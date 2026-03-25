import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/core/utils/extensions.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/routes/app_routes.dart';
import '../../data/services/weather_service.dart';
import '../../presentation/widgets/destination_selector_widget.dart';

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
  Timer? _progressTimer;
  bool _isComplete = false;
  String _statusText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLoading();
    });
  }

  void _startLoading() async {
    final destination =
        ModalRoute.of(context)?.settings.arguments as DestinationType? ??
            DestinationType.senegal;

    _messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        _messageIndex =
            (_messageIndex + 1) % AppConstants.loadingMessages.length;
      });
    });

    // Simulate smooth progress loading up to 90%
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) return;
      setState(() {
        if (_progress < 0.9) {
          _progress += 0.01;
        }
      });
    });

    try {
      final service = WeatherService();

      if (destination == DestinationType.senegal) {
        // Mode Sénégal: géolocalisation + prévisions
        setState(() => _statusText = 'Obtention de la position & météo…');

        final forecast = await service.fetchCurrentLocationForecast();

        if (mounted) {
          setState(() {
            _progress = 1.0;
            _isComplete = true;
          });
          _messageTimer?.cancel();
          _progressTimer?.cancel();

          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              AppRoutes.goToForecastDetail(context, forecast);
            }
          });
        }
      } else {
        // Mode Reste du Monde: 5 villes
        setState(() => _statusText = 'Chargement des villes mondiales…');

        final worldCities = await service.fetchWorldCities();

        if (mounted) {
          setState(() {
            _progress = 1.0;
            _isComplete = true;
          });
          _messageTimer?.cancel();
          _progressTimer?.cancel();

          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              AppRoutes.goToWorldCities(context, worldCities);
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        _messageTimer?.cancel();
        _progressTimer?.cancel();
        AppRoutes.goToError(context, e.toString());
      }
    }
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _progressTimer?.cancel();
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
                '⛅ Météo en cours…',
                style: context.textTheme.headlineLarge,
              ).animate().fadeIn(duration: 500.ms),

              const SizedBox(height: 48),

              // Progress animation
              _buildProgressIndicator(isDark),

              const SizedBox(height: 40),

              // Status/message
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

              if (_statusText.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  _statusText,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.accentPurple,
                  ),
                ),
              ],

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(bool isDark) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: _progress,
                strokeWidth: 6,
                backgroundColor: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _isComplete ? AppColors.accentCyan : AppColors.accentPurple,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              _isComplete ? '✅' : '${(_progress * 100).round()}%',
              style: TextStyle(
                fontSize: _isComplete ? 32 : 20,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textWhite : AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 600.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        );
  }
}
