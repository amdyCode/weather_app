import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/core/utils/extensions.dart';
import 'package:weather_app/presentation/widgets/destination_selector_widget.dart';
import 'package:weather_app/presentation/widgets/floating_particles_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/routes/app_routes.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  DestinationType _selectedDestination = DestinationType.senegal;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppGradients.dark : AppGradients.light,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              FloatingParticlesWidget(size: size),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.black.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              onPressed: context
                                  .read<ThemeProvider>()
                                  .toggleTheme,
                              icon: Icon(
                                isDark
                                    ? Icons.light_mode_rounded
                                    : Icons.dark_mode_rounded,
                                color: isDark
                                    ? AppColors.accentCyan
                                    : AppColors.accentPurple,
                              ),
                            ),
                          )
                          .animate(
                              onPlay: (c) => c.repeat(reverse: true))
                          .shimmer(
                              delay: 2000.ms, duration: 1500.ms),
                    ),

                    const Spacer(flex: 2),

                    // Weather icon
                    Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.accentPurple.withValues(alpha: 0.3),
                                AppColors.accentCyan.withValues(alpha: 0.2),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentPurple.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 40,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text('✨', style: TextStyle(fontSize: 64)),
                          ),
                        )
                        .animate(
                            onPlay: (c) => c.repeat(reverse: true))
                        .moveY(
                          begin: -5,
                          end: 5,
                          duration: 3000.ms,
                          curve: Curves.easeInOut,
                        )
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .scale(
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1, 1),
                          duration: 800.ms,
                          curve: Curves.elasticOut,
                        ),

                    const SizedBox(height: 32),

                    // Title
                    Text(
                          'Choisissez votre destination',
                          style: context.textTheme.headlineMedium?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 32),

                    // Destination selector chips
                    DestinationSelectorWidget(
                      selected: _selectedDestination,
                      onSelect: (type) {
                        setState(() => _selectedDestination = type);
                      },
                    ),

                    const Spacer(flex: 2),

                    // Launch button
                    _buildLaunchButton(context, isDark)
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 600.ms)
                        .slideY(begin: 0.5, end: 0),

                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLaunchButton(BuildContext context, bool isDark) {
    return SizedBox(
          width: double.infinity,
          height: 60,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppGradients.button,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentPurple.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => AppRoutes.goToLoading(
                context,
                destination: _selectedDestination,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lancer la Récupération',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('🚀', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(delay: 3000.ms, duration: 2000.ms);
  }
}
