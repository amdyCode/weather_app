import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/core/routes/app_routes.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/theme/app_gradients.dart';
import 'package:weather_app/core/utils/extensions.dart';
import 'package:weather_app/presentation/widgets/destination_selector_widget.dart';

class StartButtonWidget extends StatelessWidget {
  const StartButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => AppRoutes.goToLoading(context, destination: DestinationType.senegal),
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
                    'Start the Experience',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('✨', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(delay: 3000.ms, duration: 2000.ms);
  }
}
