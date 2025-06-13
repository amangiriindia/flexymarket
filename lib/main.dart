import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screen/auth/welcome_screen.dart';
import 'screen/base/main_screen.dart';
import 'constant/app_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        splitScreenMode: true,
        builder: (context, child) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flexy Markets',
            theme: themeProvider.isDarkMode ? _darkTheme : _lightTheme,
            home: child,
          );
        },
        child: const WelcomeScreen(),
      ),
    );
  }

  // Light theme using AppColors
  ThemeData get _lightTheme => ThemeData(
    primaryColor: AppColors.lightAccent,
    scaffoldBackgroundColor: AppColors.lightBackground,
    fontFamily: 'Roboto',
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightPrimaryText,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    ),
    iconTheme: IconThemeData(color: AppColors.lightPrimaryText),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightPrimaryText),
      bodyMedium: TextStyle(color: AppColors.lightSecondaryText),
    ),
  );

  // Dark theme using AppColors
  ThemeData get _darkTheme => ThemeData(
    primaryColor: AppColors.darkAccent,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: 'Roboto',
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkPrimaryText,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    ),
    iconTheme: IconThemeData(color: AppColors.darkPrimaryText),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkPrimaryText),
      bodyMedium: TextStyle(color: AppColors.darkSecondaryText),
    ),
  );
}