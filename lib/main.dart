
import 'package:flexy_markets/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'screen/welcome_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flexy Markets',
          theme: ThemeData(
            primaryColor: const Color(0xFF00C853),
            scaffoldBackgroundColor: Colors.black,
            fontFamily: 'Roboto',
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            ),
          ),

          home: child,
        );
      },
      child: MainScreen(),
    );
  }
}