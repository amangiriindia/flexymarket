
import 'package:flutter/material.dart';

import 'screen/welcome_screen.dart';

void main() {
  runApp(const FlexTradeApp());
}

class FlexTradeApp extends StatelessWidget {
  const FlexTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFF00E676),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00E676),
          onPrimary: Colors.black,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: Colors.white70),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}