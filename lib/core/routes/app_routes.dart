import 'package:flutter/material.dart';
import '../../data/models/forecast_data.dart';
import '../../presentation/screens/welcome_screen.dart';
import '../../presentation/screens/loading_screen.dart';
import '../../presentation/screens/forecast_detail_screen.dart';
import '../../presentation/screens/world_cities_screen.dart';
import '../../presentation/screens/error_screen.dart';
import '../../presentation/widgets/destination_selector_widget.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String loading = '/loading';
  static const String forecastDetail = '/forecast-detail';
  static const String worldCities = '/world-cities';
  static const String error = '/error';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return _buildRoute(const WelcomeScreen(), settings);
      case loading:
        return _buildRoute(const LoadingScreen(), settings);
      case forecastDetail:
        return _buildRoute(const ForecastDetailScreen(), settings);
      case worldCities:
        return _buildRoute(const WorldCitiesScreen(), settings);
      case error:
        return _buildRoute(const ErrorScreen(), settings);
      default:
        return _buildRoute(const WelcomeScreen(), settings);
    }
  }

  static MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  static void goToLoading(
    BuildContext context, {
    required DestinationType destination,
  }) {
    Navigator.pushNamed(context, loading, arguments: destination);
  }

  static void goToForecastDetail(BuildContext context, ForecastData data) {
    Navigator.pushReplacementNamed(context, forecastDetail, arguments: data);
  }

  static void goToWorldCities(
    BuildContext context,
    List<ForecastData> cities,
  ) {
    Navigator.pushReplacementNamed(context, worldCities, arguments: cities);
  }

  static void goToError(BuildContext context, String message) {
    Navigator.pushReplacementNamed(context, error, arguments: message);
  }

  static void goToWelcome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  static void restartLoading(
    BuildContext context, {
    DestinationType destination = DestinationType.senegal,
  }) {
    Navigator.pushReplacementNamed(
      context,
      loading,
      arguments: destination,
    );
  }
}
