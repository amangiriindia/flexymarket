import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackBar('Please fill all fields');
      return;
    }

    if (!_agreedToTerms) {
      _showErrorSnackBar('Please agree to the Terms and Conditions');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call signup API (email, password, country)
      await _authService.signup(
        _emailController.text,
        _passwordController.text,
        'india',
      );

      // Send OTP to email
      await _authService.sendOtpToEmail(_emailController.text);

      // Navigate to VerificationScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            email: _emailController.text,
          ),
        ),
      );

      _showSuccessSnackBar('OTP sent to email');
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  Future<void> _launchTerms() async {
    final url = Uri.parse('https://flexymarkets.com/legal_documents/TERM%20AND%20CONDITION.pdf');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        _showSuccessSnackBar('Opening Terms and Conditions');
      } else {
        _showErrorSnackBar('Could not open Terms and Conditions');
      }
    } catch (e) {
      _showErrorSnackBar('Error opening Terms and Conditions: $e');
      debugPrint('Terms launch error: $e');
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
                SizedBox(height: 16.h),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock,
                        size: 16.sp,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'All communications are secure and encrypted',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        ),
                        semanticsLabel: 'All communications are secure and encrypted',
                      ),
                    ],
                  ),
                ),
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
              semanticLabel: 'Agree to Terms and Conditions',
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
                      onTap: _launchTerms,
                      child: Text(
                        'Terms and Conditions',
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
    return GestureDetector(
      onTap: _isLoading ? null : _handleSignUp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: _isLoading
              ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent).withOpacity(0.5)
              : (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: isDarkMode
              ? null
              : [
            BoxShadow(
              color: AppColors.lightShadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: _isLoading
              ? SizedBox(
            width: 24.w,
            height: 24.h,
            child: CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 2,
            ),
          )
              : Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
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
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
            _showSuccessSnackBar('Navigating to Login');
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