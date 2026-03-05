import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/data/models/detail_item.dart';
import 'package:weather_app/data/models/weather_data.dart';
import 'weather_detail_card.dart';

class WeatherDetailsGrid extends StatelessWidget {
  final WeatherData data;
  const WeatherDetailsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final details = [
      DetailItem(
        icon: Icons.air_rounded,
        label: 'Wind Speed',
        value: '${data.windSpeed.round()} km/h',
        trend: 'trending_up +2%',
        trendIcon: Icons.trending_up,
        trendColor: Colors.greenAccent,
      ),
      DetailItem(
        icon: Icons.wb_sunny_rounded,
        label: 'UV Index',
        value: data.uvIndex <= 2
            ? 'Low ${data.uvIndex}'
            : data.uvIndex <= 5
            ? 'Medium ${data.uvIndex}'
            : 'High ${data.uvIndex}',
        trend: 'Stable',
        trendIcon: Icons.remove,
        trendColor: Colors.orangeAccent,
      ),
      DetailItem(
        icon: Icons.speed_rounded,
        label: 'Pressure',
        value: '${data.pressure.round()} hPa',
        trend: 'trending_down -1%',
        trendIcon: Icons.trending_down,
        trendColor: Colors.redAccent,
      ),
      DetailItem(
        icon: Icons.visibility_rounded,
        label: 'Visibility',
        value: '${data.visibility.round()} km',
        trend: 'Excellent',
        trendIcon: Icons.check_circle_outline,
        trendColor: Colors.greenAccent,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: details.length,
      itemBuilder: (context, index) {
        return WeatherDetailCard(item: details[index])
            .animate()
            .fadeIn(delay: (100 * index).ms, duration: 400.ms)
            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
      },
    );
  }
}
