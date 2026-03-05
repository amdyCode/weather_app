import 'package:flutter/material.dart';
import '../../data/models/weather_data.dart';
import '../../presentation/screens/welcome_screen.dart';
import '../../presentation/screens/loading_screen.dart';
import '../../presentation/screens/dashboard_screen.dart';
import '../../presentation/screens/city_detail_screen.dart';
import '../../presentation/screens/error_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String loading = '/loading';
  static const String dashboard = '/dashboard';
  static const String detail = '/detail';
  static const String error = '/error';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return _buildRoute(const WelcomeScreen(), settings);
      case loading:
        return _buildRoute(const LoadingScreen(), settings);
      case dashboard:
        return _buildRoute(const DashboardScreen(), settings);
      case detail:
        return _buildRoute(const CityDetailScreen(), settings);
      case error:
        return _buildRoute(const ErrorScreen(), settings);
      default:
        return _buildRoute(const WelcomeScreen(), settings);
    }
  }

  static MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  static void goToLoading(BuildContext context) {
    Navigator.pushNamed(context, loading);
  }

  static void goToDashboard(BuildContext context, List<WeatherData> data) {
    Navigator.pushReplacementNamed(context, dashboard, arguments: data);
  }

  static void goToDetail(BuildContext context, WeatherData data) {
    Navigator.pushNamed(context, detail, arguments: data);
  }

  static void goToError(BuildContext context, String message) {
    Navigator.pushReplacementNamed(context, error, arguments: message);
  }

  static void goToWelcome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  static void restartLoading(BuildContext context) {
    Navigator.pushReplacementNamed(context, loading);
  }
}
