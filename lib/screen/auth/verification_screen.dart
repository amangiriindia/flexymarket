import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../constant/app_color.dart';
import '../../../providers/theme_provider.dart';
import '../base/main_screen.dart';


class VerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const VerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  Timer? _timer;
  int _resendTime = 59;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
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

  void _resendCode() {
    if (_canResend) {
      for (var controller in _controllers) {
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
            'Verification code resent',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.green,
        ),
      );
    }
  }

  void _verifyCode() {
    String code = _controllers.map((controller) => controller.text).join();
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    if (code.length == 6) {
      print('Verifying code: $code');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification successful',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
          backgroundColor: AppColors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter all digits',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
          backgroundColor: AppColors.red,
        ),
      );
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
                _buildOtpFields(isDarkMode),
                SizedBox(height: 40.h),
                _buildVerifyButton(isDarkMode),
                SizedBox(height: 20.h),
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
            color:
            isDarkMode
                ? AppColors.darkPrimaryText
                : AppColors.lightPrimaryText,
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
          'Enter the code we sent to:',
          style: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Text(
          widget.phoneNumber,
          style: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOtpFields(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
            (index) => ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: SizedBox(
            width: 50.w,
            height: 50.h,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              maxLength: 1,
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1,
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                if (value.isNotEmpty && index < 5) {
                  _focusNodes[index + 1].requestFocus();
                } else if (value.isEmpty && index > 0) {
                  _focusNodes[index - 1].requestFocus();
                }
                if (index == 5 && value.isNotEmpty) {
                  bool allFilled = _controllers.every((controller) => controller.text.isNotEmpty);
                  if (allFilled) {
                    FocusScope.of(context).unfocus();
                  }
                }
              },
            ///  semanticsLabel: 'OTP Digit ${index + 1}',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton(bool isDarkMode) {
    return ElevatedButton(
      onPressed: _verifyCode,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
        foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        elevation: isDarkMode ? 0 : 2,
        minimumSize: Size(double.infinity, 50.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        shadowColor: isDarkMode ? null : AppColors.lightShadow,
      ),
      child: Text(
        'Verify Code',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        semanticsLabel: 'Verify Code',
      ),
    );
  }

  Widget _buildResendOption(bool isDarkMode) {
    return Column(
      children: [
        TextButton(
          onPressed: _canResend ? _resendCode : null,
          child: Text(
            'Resend Code',
            style: TextStyle(
              color: _canResend
                  ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                  : (isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            semanticsLabel: 'Resend Code',
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