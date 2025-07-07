import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../constant/app_color.dart';

import '../../providers/theme_provider.dart';
import '../constant/user_constant.dart';
import '../screen/auth/welcome_screen.dart';
import '../screen/base/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Load user data from SharedPreferences
    await UserConstants.loadUserData();

    // Wait for 2 seconds to show the splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Check if token exists
    if (UserConstants.TOKEN != null && UserConstants.TOKEN!.isNotEmpty) {
      // Navigate to MainScreen if token exists
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      // Navigate to WelcomeScreen if no token
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 100.w, // Responsive width
                height: 100.h, // Responsive height
                fit: BoxFit.contain,
                semanticLabel: 'App Logo',
              ),

            ],
          ),
        ),
      ),
    );
  }
}
