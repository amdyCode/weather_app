import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/core/utils/extensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/theme_provider.dart';
import '../widgets/action_buttons_widget.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final errorMessage =
        ModalRoute.of(context)?.settings.arguments as String? ??
        'We\'re having trouble fetching the latest data.\nPlease check your connection or try again.';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppGradients.dark : AppGradients.light,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
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
                      'Weather Status',
                      style: context.textTheme.titleLarge,
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

                const Spacer(flex: 2),

                _buildErrorIcon(isDark)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 32),

                Text(
                  'Oops! 😕',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(fontSize: 32),
                ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                const SizedBox(height: 8),

                Text(
                  'The weather is a bit unpredictable right now.',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: AppColors.accentPurple,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                const SizedBox(height: 16),

                Text(
                  errorMessage,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.6),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

                const Spacer(flex: 1),

                PrimaryActionButton(
                      label: 'Retry 🔄',
                      icon: Icons.refresh_rounded,
                      onPressed: () => AppRoutes.restartLoading(context),
                    )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 500.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 16),

                SecondaryActionButton(
                      label: 'Back to Home 🏠',
                      icon: Icons.home_rounded,
                      onPressed: () => AppRoutes.goToWelcome(context),
                    )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 500.ms)
                    .slideY(begin: 0.3, end: 0),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIcon(bool isDark) {
    return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.redAccent.withValues(alpha: 0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(alpha: 0.15),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Center(child: Text('❌', style: TextStyle(fontSize: 48))),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: -5, end: 5, duration: 3000.ms, curve: Curves.easeInOut);
  }
}
