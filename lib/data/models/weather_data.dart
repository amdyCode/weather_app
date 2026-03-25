class WeatherData {
  final String cityName;
  final String country;
  final double temperature;
  final int humidity;
  final String condition;
  final String icon;
  final double windSpeed;
  final double pressure;
  final double visibility;
  final int uvIndex;
  final double tempHigh;
  final double tempLow;
  final double latitude;
  final double longitude;
  final String sublocality;
  final String locality;

  const WeatherData({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.humidity,
    required this.condition,
    required this.icon,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    required this.uvIndex,
    required this.tempHigh,
    required this.tempLow,
    required this.latitude,
    required this.longitude,
    this.sublocality = '',
    this.locality = '',
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'] as String,
      country: json['sys']['country'] as String,
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      condition: json['weather'][0]['main'] as String,
      icon: json['weather'][0]['icon'] as String,
      windSpeed: (json['wind']['speed'] as num).toDouble() * 3.6, // m/s to km/h
      pressure: (json['main']['pressure'] as num).toDouble(),
      visibility:
          ((json['visibility'] ?? 10000) as num).toDouble() /
          1000, // meters to km
      uvIndex: _calculateMockUv((json['clouds']['all'] ?? 0) as int),
      tempHigh: (json['main']['temp_max'] as num).toDouble(),
      tempLow: (json['main']['temp_min'] as num).toDouble(),
      latitude: (json['coord']['lat'] as num).toDouble(),
      longitude: (json['coord']['lon'] as num).toDouble(),
      sublocality: json['sublocality'] ?? '',
      locality: json['locality'] ?? '',
    );
  }

  static int _calculateMockUv(int cloudCover) {
    return (((100 - cloudCover.clamp(0, 100)) / 100) * 8 + 1).round();
  }

  String get weatherEmoji {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return '☀️';
      case 'cloudy':
      case 'overcast':
        return '☁️';
      case 'partly cloudy':
        return '⛅';
      case 'rainy':
      case 'rain':
        return '🌧️';
      case 'storm':
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'fog':
      case 'mist':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  int get conditionColorValue {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return 0xFFFFB74D;
      case 'cloudy':
      case 'overcast':
        return 0xFF90A4AE;
      case 'partly cloudy':
        return 0xFFFFCC80;
      case 'rainy':
      case 'rain':
        return 0xFF42A5F5;
      case 'storm':
      case 'thunderstorm':
        return 0xFFEF5350;
      case 'snow':
        return 0xFFE0E0E0;
      default:
        return 0xFF81D4FA;
    }
  }
}
