import 'package:flutter/material.dart';

class AppColors {
  // Light mode colors
  static const Color lightBackground = Color(0xFFF5F5F5); // Colors.grey[100]
  static const Color lightSurface = Colors.white;
  static const Color lightCard = Colors.white;
  static const Color lightPrimaryText = Colors.black;
  static const Color lightSecondaryText = Color(0xFF757575); // Colors.grey[600]
  static const Color lightBorder = Color(0xFFE0E0E0); // Colors.grey[200]
  static const Color lightAccent = Color(0xFF00685a);
  static const Color lightShadow = Color(0x1F000000); // Colors.grey.withOpacity(0.1)
  static const Color lightChartBackground = Color(0xFFF5F5F5); // Colors.grey[100] for chart
  static const Color lightSignalButton = Color(0xFF00685a);
  static const Color lightNewsIconBackground = Color(0x1FFF9800); // Colors.orange.withOpacity(0.1)
  static const Color lightNewsIcon = Colors.orange;

  // Dark mode colors
  static const Color darkBackground = Colors.black;
  static const Color darkSurface = Color(0xFF212121); // Colors.grey[900]
  static const Color darkCard = Color(0xFF212121); // Colors.grey[850]
  static const Color darkPrimaryText = Colors.white;
  static const Color darkSecondaryText = Color(0xFFB0BEC5); // Colors.grey[400]
  static const Color darkBorder = Color(0xFF616161); // Colors.grey[700]
  static const Color darkAccent = Color(0xFF00685a); // Colors.blue[400]
  static const Color darkChartBackground = Colors.black; // Colors.black for chart
  static const Color darkSignalButton = Color(0xFF00685a); // Colors.blue[400]
  static const Color darkNewsIconBackground = Color(0x1FFF9800); // Colors.orange.withOpacity(0.1)
  static const Color darkNewsIcon = Colors.orange;

  // Static colors (used in both modes)
  static const Color green = Colors.green;
  static const Color red = Colors.red;
  static const Color white = Colors.white;
  static const Color orange = Colors.orange;

  static var darkSecondary = Color(0xFF00685a);

  static var lightSecondary = Color(0xFF00685a);
}