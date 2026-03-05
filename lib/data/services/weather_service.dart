import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../models/weather_data.dart';

class WeatherService {
  Future<WeatherData> fetchWeather(String cityQuery) async {
    final url = Uri.parse(
      '${AppConstants.openWeatherBaseUrl}'
      '?q=$cityQuery'
      '&appid=${AppConstants.openWeatherApiKey}'
      '&units=metric',
    );

    try {
      final response = await http.get(url).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        return WeatherData.fromJson(json.decode(response.body));
      } else {
        throw WeatherException(
          'Erreur API (${response.statusCode}): '
          'Impossible de charger les données pour $cityQuery',
        );
      }
    } catch (e) {
      if (e is WeatherException) rethrow;
      throw WeatherException('Erreur réseau ou délai dépassé pour $cityQuery.');
    }
  }

  Future<List<WeatherData>> fetchAllCities() async {
    final futures = AppConstants.targetCities.map((city) => fetchWeather(city));
    return await Future.wait(futures);
  }
}

class WeatherException implements Exception {
  final String message;
  const WeatherException(this.message);

  @override
  String toString() => message;
}
