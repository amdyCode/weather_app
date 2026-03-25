import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/utils/extensions.dart';

class MapCardWidget extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String cityName;
  final double temperature;
  final String condition;

  const MapCardWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.temperature,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final position = LatLng(latitude, longitude);
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
                  markerId: MarkerId(cityName),
                  position: position,
                  infoWindow: InfoWindow(
                    title: cityName,
                    snippet:
                        '${temperature.round()}°C - $condition',
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