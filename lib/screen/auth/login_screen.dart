import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../constant/common_utills.dart';
import '../../constant/user_constant.dart';
import '../../providers/theme_provider.dart';
import '../../service/apiservice/auth_service.dart';
import '../base/main_screen.dart';
import 'registation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login using AuthService

  // Login using AuthService
  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      CommonUtils.showMessage('Please enter username and password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final responseData = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );

      // Save user data using UserConstants
      await UserConstants.storeUserData(responseData);
      CommonUtils.showMessage(responseData['message'], backgroundColor: Colors.green);
      // Navigate to MainScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
      );
    } catch (e) {
      // Show error toast
      CommonUtils.showMessage(e.toString(), backgroundColor: Colors.red);
      //
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
      backgroundColor:
      isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                _buildLogo(isDarkMode),
                SizedBox(height: 50.h),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Username',
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.text,
                  isDarkMode: isDarkMode,
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                      size: 20.sp,
                    ),
                  ),
                  isDarkMode: isDarkMode,
                ),
                SizedBox(height: 24.h),
                _buildLoginButton(isDarkMode),
                SizedBox(height: 16.h),
                _buildFingerprintAndForgot(isDarkMode),
                SizedBox(height: 16.h),
                _buildDivider(isDarkMode),
                SizedBox(height: 16.h),
                _buildSocialButtons(isDarkMode),
                SizedBox(height: 24.h),
                _buildSignUpText(isDarkMode),
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
            color:
            isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    required bool isDarkMode,
  }) {
    return TextField(
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
          color: isDarkMode
              ? AppColors.darkSecondaryText
              : AppColors.lightSecondaryText,
          fontSize: 14.sp,
        ),
        prefixIcon: Icon(
          icon,
          color: isDarkMode
              ? AppColors.darkSecondaryText
              : AppColors.lightSecondaryText,
          size: 20.sp,
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
    );
  }

  Widget _buildLoginButton(bool isDarkMode) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
        foregroundColor:
        isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        elevation: isDarkMode ? 0 : 2,
        minimumSize: Size(double.infinity, 50.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        shadowColor: isDarkMode ? null : AppColors.lightShadow,
      ),
      child: _isLoading
          ? SizedBox(
        width: 20.w,
        height: 20.h,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isDarkMode
                ? AppColors.darkPrimaryText
                : AppColors.lightPrimaryText,
          ),
        ),
      )
          : Text(
        'Login',
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,color:  AppColors.white),
      ),
    );
  }

  Widget _buildFingerprintAndForgot(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Fingerprint login coming soon!',
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText,
                  ),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              Icons.fingerprint,
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              size: 24.sp,
              semanticLabel: 'Fingerprint Login',
            ),
          ),
        ),
        SizedBox(width: 8.w),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Forgot password functionality coming soon!',
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText,
                  ),
                ),
              ),
            );
          },
          child: Text(
            'Forgot PIN/Password?',
            style: TextStyle(
              color: isDarkMode
                  ? AppColors.darkSecondaryText
                  : AppColors.lightSecondaryText,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'or continue with',
            style: TextStyle(
              color: isDarkMode
                  ? AppColors.darkSecondaryText
                  : AppColors.lightSecondaryText,
              fontSize: 12.sp,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Google login coming soon!',
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                      ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                foregroundColor:
                isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                elevation: 0,
                minimumSize: Size(0, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Icon(
                FontAwesomeIcons.google,
                size: 20.sp,
                color: AppColors.red,
                semanticLabel: 'Google Login',
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Apple login coming soon!',
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                      ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                foregroundColor:
                isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                elevation: 0,
                minimumSize: Size(0, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Icon(
                Icons.apple,
                size: 24.sp,
                color: isDarkMode
                    ? AppColors.darkPrimaryText
                    : AppColors.lightPrimaryText,
                semanticLabel: 'Apple Login',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpText(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(
            color: isDarkMode
                ? AppColors.darkSecondaryText
                : AppColors.lightSecondaryText,
            fontSize: 14.sp,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegistrationScreen(),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Navigating to Sign Up',
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText,
                  ),
                ),
              ),
            );
          },
          child: Text(
            'Sign Up',
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