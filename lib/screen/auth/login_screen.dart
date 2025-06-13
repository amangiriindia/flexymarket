import 'package:flexy_markets/screen/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'registation_screen.dart';





class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                // Logo and App Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.chartLine,
                      color: Theme.of(context).primaryColor,
                      size: 28.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Flexy Markets',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.h),

                // Email/Phone Field
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: 'Email or Phone',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                      size: 20.sp,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),

                // Password Field
                TextField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.help_outline,
                      color: Colors.grey,
                      size: 20.sp,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.grey,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Login Button
                ElevatedButton(
                  onPressed: () {
                    // Handle login logic
                    print('Email: ${_emailController.text}');
                    print('Password: ${_passwordController.text}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VerificationScreen(phoneNumber: '+91 ••• ••• 4785'),
                      ),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Fingerprint and Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fingerprint,
                      color: Theme.of(context).primaryColor,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      child: Text(
                        'Forgot PIN/Password?',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Divider with text
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade800,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'or continue with',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade800,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Social Login Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Google login
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E1E1E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: Size(0, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'G',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Apple login
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E1E1E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: Size(0, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Icon(
                          Icons.apple,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Sign Up Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to sign up screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}