import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import '../../core/constants/app_constants.dart';
import '../models/forecast_data.dart';

class WeatherService {
  Future<ForecastData> fetchForecast({
    required double lat,
    required double lon,
    required String cityName,
    required String country,
    String locality = '',
    String sublocality = '',
  }) async {
    final url = Uri.parse(
      '${AppConstants.openMeteoBaseUrl}'
      '?latitude=$lat'
      '&longitude=$lon'
      '&current=temperature_2m,weather_code,wind_speed_10m,surface_pressure'
      '&daily=temperature_2m_max,temperature_2m_min,weather_code'
      '&hourly=temperature_2m,weather_code,wind_speed_10m,relative_humidity_2m'
      '&timezone=auto'
      '&forecast_days=7',
    );

    try {
      final response = await http.get(url).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ForecastData.fromOpenMeteo(
          json,
          cityName: cityName,
          country: country,
          exactLatitude: lat,
          exactLongitude: lon,
          locality: locality,
          sublocality: sublocality,
        );
      } else {
        throw WeatherException(
          'Erreur API (${response.statusCode}): '
          'Impossible de charger les données pour $cityName',
        );
      }
    } catch (e) {
      if (e is WeatherException) rethrow;
      throw WeatherException('Erreur réseau ou délai dépassé pour $cityName.');
    }
  }

  /// Récupérer la position actuelle et les prévisions
  Future<ForecastData> fetchCurrentLocationForecast() async {
    final position = await _getCurrentPosition();

    // Reverse geocoding via Open-Meteo
    String cityName = 'Ma Position';
    String country = 'SN';

    try {
      final geoUrl = Uri.parse(
        '${AppConstants.openMeteoGeoUrl}'
        '?latitude=${position.latitude}'
        '&longitude=${position.longitude}'
        '&count=1'
        '&language=fr',
      );
      final geoResponse = await http
          .get(geoUrl)
          .timeout(const Duration(seconds: 5));
      if (geoResponse.statusCode == 200) {
        final geoData = jsonDecode(geoResponse.body);
        if (geoData['results'] != null &&
            (geoData['results'] as List).isNotEmpty) {
          final result = geoData['results'][0];
          cityName = result['name'] ?? 'Ma Position';
          country = result['country_code'] ?? 'SN';
        }
      }
    } catch (_) {
      // Ignore open-meteo geocoding errors, use default name
    }

    String locality = '';
    String sublocality = '';
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        locality = place.locality ?? '';
        sublocality = place.subLocality ?? '';
        if (cityName == 'Ma Position' && locality.isNotEmpty) {
          cityName = locality;
        }
      }
    } catch (_) {
      // Ignore reverse geocoding errors
    }

    return fetchForecast(
      lat: position.latitude,
      lon: position.longitude,
      cityName: cityName,
      country: country,
      locality: locality,
      sublocality: sublocality,
    );
  }

  Future<List<ForecastData>> fetchWorldCities() async {
    final futures = AppConstants.worldCities.map(
      (city) => fetchForecast(
        lat: (city['lat'] as num).toDouble(),
        lon: (city['lon'] as num).toDouble(),
        cityName: city['name'] as String,
        country: city['country'] as String,
      ),
    );
    return Future.wait(futures);
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw WeatherException('Les services de localisation sont désactivés.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw WeatherException('Permission de localisation refusée.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw WeatherException(
        'Permission de localisation refusée de manière permanente.',
      );
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } on TimeoutException {
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return lastKnown;
      }
      throw const WeatherException(
        'Impossible d\'obtenir la position. Délai dépassé.',
      );
    } catch (e) {
      throw WeatherException(
        'Erreur lors de la récupération de la position: $e',
      );
    }
  }
}

class WeatherException implements Exception {
  final String message;
  const WeatherException(this.message);

  @override
  String toString() => message;
}
