import 'package:flexy_markets/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 22.sp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Icon(
              FontAwesomeIcons.chartLine,
              color: Theme.of(context).primaryColor,
              size: 22.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Flexy Markets',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),

                // Create Account Title
                Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8.h),

                // Subtitle
                Text(
                  'Start your trading journey today',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.h),

                // Phone Number Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Phone Number',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                // Phone Number Field
                TextField(
                  controller: _phoneController,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    hintText: 'Enter phone number',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    suffixIcon: Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Theme.of(context).primaryColor,
                      size: 20.sp,
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Email Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                // Email Field
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  ),
                ),

                SizedBox(height: 16.h),

                // Password Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                // Password Field
                TextField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    hintText: 'Create password',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.grey,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Terms and Conditions Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Theme.of(context).primaryColor;
                            }
                            return Colors.transparent;
                          },
                        ),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                            ),
                            children: [
                              const TextSpan(text: 'I agree to Flexy Markets\' '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: const Color(0xFF00C853),
                                  fontSize: 12.sp,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: const Color(0xFF00C853),
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Sign Up Button
                ElevatedButton(
                  onPressed: _agreedToTerms ? () {
                    // Handle registration logic
                    print('Phone: ${_phoneController.text}');
                    print('Email: ${_emailController.text}');
                    print('Password: ${_passwordController.text}');
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
                    disabledForegroundColor: Colors.white.withOpacity(0.5),
                    elevation: 0,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to login screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

