import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../service/apiservice/auth_service.dart';
import '../auth/login_screen.dart';
import 'verification_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    //_phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all fields',
            style: TextStyle(
              color: Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                  ? AppColors.darkPrimaryText
                  : AppColors.lightPrimaryText,
            ),
          ),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please agree to the Terms of Service and Privacy Policy',
            style: TextStyle(
              color: Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                  ? AppColors.darkPrimaryText
                  : AppColors.lightPrimaryText,
            ),
          ),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call signup API (only email, password, country)
      await _authService.signup(
        _emailController.text,
        _passwordController.text,
        'india', // Fixed as per your API example
      );

      // Send OTP to email
      await _authService.sendOtpToEmail(_emailController.text);

      // Send OTP to phone

      // Navigate to VerificationScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            email: _emailController.text,
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'OTPs sent to email and phone',
            style: TextStyle(
              color: Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                  ? AppColors.darkPrimaryText
                  : AppColors.lightPrimaryText,
            ),
          ),
          backgroundColor: AppColors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
            style: TextStyle(
              color: Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                  ? AppColors.darkPrimaryText
                  : AppColors.lightPrimaryText,
            ),
          ),
          backgroundColor: AppColors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                _buildLogo(isDarkMode),
                SizedBox(height: 20.h),
                _buildTitle(isDarkMode),

                SizedBox(height: 16.h),
                _buildTextField(
                  label: 'Email',
                  controller: _emailController,
                  hintText: 'Enter your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  isDarkMode: isDarkMode,
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  label: 'Password',
                  controller: _passwordController,
                  hintText: 'Create password',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  isDarkMode: isDarkMode,
                ),
                SizedBox(height: 20.h),
                _buildCheckbox(isDarkMode),
                SizedBox(height: 24.h),
                _buildSignUpButton(isDarkMode),
                SizedBox(height: 16.h),
                _buildSignInText(isDarkMode),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FontAwesomeIcons.chartLine,
          color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
          size: 28.sp,
        ),
        SizedBox(width: 8.w),
        Text(
          'Flexy Markets',
          style: TextStyle(
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(bool isDarkMode) {
    return Column(
      children: [
        Text(
          'Create Account',
          style: TextStyle(
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          'Start your trading journey today',
          style: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          style: TextStyle(
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            fontSize: 14.sp,
          ),
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              fontSize: 14.sp,
            ),
            prefixIcon: Icon(
              icon,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              size: 20.sp,
              semanticLabel: label,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _agreedToTerms = !_agreedToTerms;
            });
          },
          borderRadius: BorderRadius.circular(4.r),
          child: SizedBox(
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
                    (states) => states.contains(MaterialState.selected)
                    ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                    : Colors.transparent,
              ),
              side: BorderSide(
                color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              semanticLabel: 'Agree to Terms',
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  fontSize: 12.sp,
                ),
                children: [
                  const TextSpan(text: 'I agree to Flexy Markets\' '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Terms of Service coming soon!',
                              style: TextStyle(
                                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Terms of Service',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 12.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Privacy Policy coming soon!',
                              style: TextStyle(
                                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 12.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(bool isDarkMode) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSignUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
        foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        disabledBackgroundColor:
        (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent).withOpacity(0.5),
        disabledForegroundColor:
        (isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText).withOpacity(0.5),
        elevation: isDarkMode ? 0 : 2,
        minimumSize: Size(double.infinity, 50.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        shadowColor: isDarkMode ? null : AppColors.lightShadow,
      ),
      child: _isLoading
          ? SizedBox(
        width: 24.w,
        height: 24.h,
        child: CircularProgressIndicator(
          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          strokeWidth: 2,
        ),
      )
          : Text(
        'Sign Up',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.white
        ),
      ),
    );
  }

  Widget _buildSignInText(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 14.sp,
          ),
        ),
        TextButton(
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
          child: Text(
            'Sign In',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}