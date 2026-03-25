class AppConstants {
  // Legacy OpenWeatherMap (backup)
  static const String openWeatherApiKey = 'YOUR_OPEN_WEATHER_API_KEY';
  static const String openWeatherBaseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  // Open-Meteo (prévisions 7 jours + horaires, gratuit)
  static const String openMeteoBaseUrl =
      'https://api.open-meteo.com/v1/forecast';
  static const String openMeteoGeoUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  // Villes du Sénégal
  static const List<String> senegalCities = [
    'Dakar,SN',
    'Thies,SN',
    'Saint-Louis,SN',
    'Kaolack,SN',
    'Ziguinchor,SN',
  ];

  static const List<String> senegalDisplayNames = [
    'Dakar',
    'Thiès',
    'Saint-Louis',
    'Kaolack',
    'Ziguinchor',
  ];

  // Villes du Reste du Monde (5 villes)
  static const List<Map<String, dynamic>> worldCities = [
    {'name': 'London', 'country': 'GB', 'lat': 51.5074, 'lon': -0.1278},
    {'name': 'Tokyo', 'country': 'JP', 'lat': 35.6762, 'lon': 139.6503},
    {'name': 'New York', 'country': 'US', 'lat': 40.7128, 'lon': -74.0060},
    {'name': 'Sydney', 'country': 'AU', 'lat': -33.8688, 'lon': 151.2093},
    {'name': 'Dubai', 'country': 'AE', 'lat': 25.2048, 'lon': 55.2708},
  ];

  static const List<String> loadingMessages = [
    'Nous téléchargeons les données… 📡',
    'Connexion aux stations météo… 🛰️',
    'C\'est presque fini… ⏳',
    'Analyse des données climatiques… 🌍',
    'Plus que quelques secondes… 🚀',
  ];

  static const Duration apiTimeout = Duration(seconds: 60);
}
