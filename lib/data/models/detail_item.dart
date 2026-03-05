import 'package:flutter/material.dart';

class DetailItem {
  final IconData icon;
  final String label;
  final String value;
  final String trend;
  final IconData trendIcon;
  final Color trendColor;

  const DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.trend,
    required this.trendIcon,
    required this.trendColor,
  });
}