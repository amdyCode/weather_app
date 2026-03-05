class AppConstants {
  static const String openWeatherApiKey = 'YOUR_OPEN_WEATHER_API_KEY';
  static const String openWeatherBaseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  static const List<String> targetCities = [
    'Dakar,SN',
    'Thies,SN',
    'Saint-Louis,SN',
    'Kaolack,SN',
    'Ziguinchor,SN',
  ];

  static const List<String> cityDisplayNames = [
    'Dakar',
    'Thiès',
    'Saint-Louis',
    'Kaolack',
    'Ziguinchor',
  ];

  static const List<String> loadingMessages = [
    'Nous téléchargeons les données… 📡',
    'Connexion aux stations météo… 🛰️',
    'C\'est presque fini… ⏳',
    'Analyse des données climatiques… 🌍',
    'Plus que quelques secondes… 🚀',
  ];

  static const Duration apiTimeout = Duration(seconds: 10);
}
