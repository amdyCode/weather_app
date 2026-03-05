import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/utils/extensions.dart';
import 'package:weather_app/data/models/weather_data.dart';

class MapCardWidget extends StatelessWidget {
  final WeatherData data;
  const MapCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final position = LatLng(data.latitude, data.longitude);
    return Container(
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.08),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentPurple.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: position, zoom: 11),
              markers: {
                Marker(
                  markerId: MarkerId(data.cityName),
                  position: position,
                  infoWindow: InfoWindow(
                    title: data.cityName,
                    snippet:
                        '${data.temperature.round()}°C - ${data.condition}',
                  ),
                ),
              },
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              compassEnabled: true,
            ),
          ),
        );
  }
}