import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/utils/extensions.dart';

class FloatingParticlesWidget extends StatelessWidget {
  final Size size;
  const FloatingParticlesWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final particleColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : AppColors.accentPurple.withValues(alpha: 0.05);
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: size.height * 0.1,
          left: size.width * 0.1,
          child: _particle(60, particleColor),
        ),
        Positioned(
          top: size.height * 0.3,
          right: size.width * 0.05,
          child: _particle(80, particleColor),
        ),
        Positioned(
          bottom: size.height * 0.2,
          left: size.width * 0.15,
          child: _particle(50, particleColor),
        ),
        Positioned(
          bottom: size.height * 0.35,
          right: size.width * 0.2,
          child: _particle(70, particleColor),
        ),
      ],
    );
  }
}

Widget _particle(double size, Color color) {
  return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      )
      .animate(onPlay: (c) => c.repeat(reverse: true))
      .moveY(
        begin: -10,
        end: 10,
        duration: (2000 + size * 20).ms,
        curve: Curves.easeInOut,
      )
      .fadeIn(duration: 1000.ms);
}
