
import 'package:flexy_markets/screen/auth/registation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String?> _images = [
    'assets/images/splash.png',
    'assets/images/splash.png',
    'assets/images/splash.png',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildLogo(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 150.w,
          height: 100.h,
          fit: BoxFit.contain,
          semanticLabel: 'App Logo',
        ),

      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.h),

              SizedBox(height: 30.h),

              SizedBox(height: 30.h),
              //
              _buildLogo( isDarkMode ),
              SizedBox(height: 30.h),
              Text(
                "Trade with Confidence",
                style: TextStyle(
                  fontSize: 24.sp,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                "Real-time data, advanced tools.",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationScreen(),
                    ),
                  );

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Navigating to Login',
                        style: TextStyle(
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

