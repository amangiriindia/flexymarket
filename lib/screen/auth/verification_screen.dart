import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../constant/app_color.dart';
import '../../../providers/theme_provider.dart';
import '../../service/auth_service.dart';
import '../auth/login_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _emailOtpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _emailFocusNodes = List.generate(6, (_) => FocusNode());
  Timer? _timer;
  int _resendTime = 59;
  bool _canResend = false;
  bool _isEmailVerified = false;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _emailOtpControllers) {
      controller.dispose();
    }
    for (var node in _emailFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTime > 0) {
          _resendTime--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  void _resendCode() async {
    if (_canResend) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _authService.sendOtpToEmail(widget.email);
        for (var controller in _emailOtpControllers) {
          controller.clear();
        }

        setState(() {
          _resendTime = 59;
          _canResend = false;
        });
        _startResendTimer();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Verification code resent to email',
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
  }

  Future<void> _verifyCode() async {
    final code = _emailOtpControllers.map((controller) => controller.text).join();
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter all email OTP digits',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
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
      await _authService.verifyOtpForEmail(widget.email, code);
      setState(() {
        _isEmailVerified = true;
      });

      // Navigate to LoginScreen upon successful email verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Email verified successfully',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
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
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                _buildLogo(isDarkMode),
                SizedBox(height: 20.h),
                _buildVerificationIcon(isDarkMode),
                SizedBox(height: 20.h),
                _buildTitle(isDarkMode),
                SizedBox(height: 30.h),
                _buildOtpSection(
                  isDarkMode: isDarkMode,
                  title: 'Enter the code sent to your email:',
                  subtitle: widget.email,
                  controllers: _emailOtpControllers,
                  focusNodes: _emailFocusNodes,
                  isVerified: _isEmailVerified,
                ),
                SizedBox(height: 40.h),
                _buildResendOption(isDarkMode),
                SizedBox(height: 20.h),
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

  Widget _buildVerificationIcon(bool isDarkMode) {
    return Icon(
      FontAwesomeIcons.shieldHalved,
      color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
      size: 50.sp,
      semanticLabel: 'Verification Icon',
    );
  }

  Widget _buildTitle(bool isDarkMode) {
    return Column(
      children: [
        Text(
          'Verification Code',
          style: TextStyle(
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          'Enter the code sent to your email to continue',
          style: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOtpSection({
    required bool isDarkMode,
    required String title,
    required String subtitle,
    required List<TextEditingController> controllers,
    required List<FocusNode> focusNodes,
    required bool isVerified,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
                (index) => ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: SizedBox(
                width: 50.w,
                height: 50.h,
                child: TextField(
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLength: 1,
                  readOnly: isVerified,
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: isVerified
                        ? AppColors.green.withOpacity(0.2)
                        : isDarkMode
                        ? AppColors.darkCard
                        : AppColors.lightCard,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: isVerified
                            ? AppColors.green
                            : isDarkMode
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: isVerified
                            ? AppColors.green
                            : isDarkMode
                            ? AppColors.darkAccent
                            : AppColors.lightAccent,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (!isVerified) {
                      if (value.isNotEmpty && index < 5) {
                        focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        focusNodes[index - 1].requestFocus();
                      }
                      if (index == 5 && value.isNotEmpty) {
                        bool allFilled = controllers.every((controller) => controller.text.isNotEmpty);
                        if (allFilled) {
                          FocusScope.of(context).unfocus();
                        }
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        ElevatedButton(
          onPressed: isVerified || _isLoading ? null : _verifyCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: isVerified
                ? AppColors.green
                : isDarkMode
                ? AppColors.darkAccent
                : AppColors.lightAccent,
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
          child: _isLoading && !isVerified
              ? SizedBox(
            width: 24.w,
            height: 24.h,
            child: CircularProgressIndicator(
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              strokeWidth: 2,
            ),
          )
              : Text(
            isVerified ? 'Verified' : 'Verify Email',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResendOption(bool isDarkMode) {
    return Column(
      children: [
        TextButton(
          onPressed: _canResend && !_isEmailVerified ? _resendCode : null,
          child: Text(
            'Resend Email Code',
            style: TextStyle(
              color: _canResend && !_isEmailVerified
                  ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                  : (isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            semanticsLabel: 'Resend Email Code',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          _canResend ? '' : 'Resend code in 00:${_resendTime.toString().padLeft(2, '0')}',
          style: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}