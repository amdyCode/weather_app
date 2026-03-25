/// Prévision journalière (1 jour)
class DailyForecast {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final int weatherCode;

  const DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
  });

  String get dayOfWeek {
    const days = ['LUN', 'MAR', 'MER', 'JEU', 'VEN', 'SAM', 'DIM'];
    return days[date.weekday - 1];
  }

  String get weatherEmoji => _weatherCodeToEmoji(weatherCode);
  String get weatherDescription => _weatherCodeToDescription(weatherCode);
}

/// Prévision horaire
class HourlyForecast {
  final DateTime dateTime;
  final double temperature;
  final int weatherCode;
  final double windSpeed;
  final int humidity;

  const HourlyForecast({
    required this.dateTime,
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
    required this.humidity,
  });

  String get timeLabel =>
      '${dateTime.hour.toString().padLeft(2, '0')}:00';

  String get weatherEmoji => _weatherCodeToEmoji(weatherCode);
}

/// Données complètes de prévision pour une localisation
class ForecastData {
  final String cityName;
  final String country;
  final double latitude;
  final double longitude;
  final String sublocality;
  final String locality;
  final double currentTemp;
  final int currentWeatherCode;
  final double windSpeed;
  final int humidity;
  final double pressure;
  final List<DailyForecast> dailyForecasts;
  final List<HourlyForecast> hourlyForecasts;

  const ForecastData({
    required this.cityName,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.sublocality = '',
    this.locality = '',
    required this.currentTemp,
    required this.currentWeatherCode,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
    required this.dailyForecasts,
    required this.hourlyForecasts,
  });

  String get currentEmoji => _weatherCodeToEmoji(currentWeatherCode);
  String get currentDescription =>
      _weatherCodeToDescription(currentWeatherCode);

  /// Filtrer les prévisions horaires pour un jour donné
  List<HourlyForecast> hourlyForDay(DateTime day) {
    return hourlyForecasts
        .where(
          (h) =>
              h.dateTime.year == day.year &&
              h.dateTime.month == day.month &&
              h.dateTime.day == day.day,
        )
        .toList();
  }

  factory ForecastData.fromOpenMeteo(
    Map<String, dynamic> json, {
    required String cityName,
    required String country,
    required double exactLatitude,
    required double exactLongitude,
    String locality = '',
    String sublocality = '',
  }) {
    final currentWeather = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;
    final hourly = json['hourly'] as Map<String, dynamic>;

    final dailyDates = (daily['time'] as List).cast<String>();
    final dailyTempMax = (daily['temperature_2m_max'] as List)
        .map((e) => (e as num).toDouble())
        .toList();
    final dailyTempMin = (daily['temperature_2m_min'] as List)
        .map((e) => (e as num).toDouble())
        .toList();
    final dailyWeatherCodes =
        (daily['weather_code'] as List).map((e) => (e as num).toInt()).toList();

    final hourlyTimes = (hourly['time'] as List).cast<String>();
    final hourlyTemps = (hourly['temperature_2m'] as List)
        .map((e) => (e as num).toDouble())
        .toList();
    final hourlyWeatherCodes = (hourly['weather_code'] as List)
        .map((e) => (e as num).toInt())
        .toList();
    final hourlyWindSpeeds = (hourly['wind_speed_10m'] as List)
        .map((e) => (e as num).toDouble())
        .toList();
    final hourlyHumidities = (hourly['relative_humidity_2m'] as List)
        .map((e) => (e as num).toInt())
        .toList();

    return ForecastData(
      cityName: cityName,
      country: country,
      latitude: exactLatitude,
      longitude: exactLongitude,
      locality: locality,
      sublocality: sublocality,
      currentTemp: (currentWeather['temperature_2m'] as num).toDouble(),
      currentWeatherCode: (currentWeather['weather_code'] as num).toInt(),
      windSpeed: (currentWeather['wind_speed_10m'] as num).toDouble(),
      humidity: hourlyHumidities.isNotEmpty ? hourlyHumidities[0] : 0,
      pressure: (currentWeather['surface_pressure'] as num).toDouble(),
      dailyForecasts: List.generate(
        dailyDates.length,
        (i) => DailyForecast(
          date: DateTime.parse(dailyDates[i]),
          tempMax: dailyTempMax[i],
          tempMin: dailyTempMin[i],
          weatherCode: dailyWeatherCodes[i],
        ),
      ),
      hourlyForecasts: List.generate(
        hourlyTimes.length,
        (i) => HourlyForecast(
          dateTime: DateTime.parse(hourlyTimes[i]),
          temperature: hourlyTemps[i],
          weatherCode: hourlyWeatherCodes[i],
          windSpeed: hourlyWindSpeeds[i],
          humidity: hourlyHumidities[i],
        ),
      ),
    );
  }
}

// ── Helpers WMO Weather Code ──

String _weatherCodeToEmoji(int code) {
  if (code == 0) return '☀️';
  if (code <= 3) return '⛅';
  if (code <= 48) return '🌫️';
  if (code <= 57) return '🌧️';
  if (code <= 67) return '🌧️';
  if (code <= 77) return '❄️';
  if (code <= 82) return '🌧️';
  if (code <= 86) return '❄️';
  if (code <= 99) return '⛈️';
  return '🌤️';
}

String _weatherCodeToDescription(int code) {
  if (code == 0) return 'Ciel dégagé';
  if (code <= 3) return 'Partiellement nuageux';
  if (code <= 48) return 'Brouillard';
  if (code <= 57) return 'Bruine';
  if (code <= 67) return 'Pluie';
  if (code <= 77) return 'Neige';
  if (code <= 82) return 'Averse';
  if (code <= 86) return 'Averse de neige';
  if (code <= 99) return 'Orage';
  return 'Inconnu';
}
