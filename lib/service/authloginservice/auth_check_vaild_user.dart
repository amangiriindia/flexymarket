import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../screen/auth/login_screen.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}

Future<void> checkValidUser(int statusCode) async {
  if (statusCode == 401) {
    // Show toast message
    Fluttertoast.showToast(
      msg:
          "We detected that your account is already logged in on another device. Please log in again.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP, // You can change this to BOTTOM, CENTER, etc.
      fontSize: 12.0,
    );
    //
    // Clear user session
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate back to the SplashScreen
    NavigationService.navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}
