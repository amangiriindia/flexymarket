import 'package:flexy_markets/widget/common/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import '../../constant/app_color.dart';
import '../../constant/user_constant.dart';
import '../../providers/theme_provider.dart';
import '../../service/apiservice/user_service.dart';
import '../../widget/common/main_app_bar.dart';

class TwoFASetupScreen extends StatefulWidget {
  const TwoFASetupScreen({Key? key}) : super(key: key);

  @override
  State<TwoFASetupScreen> createState() => _TwoFASetupScreenState();
}

class _TwoFASetupScreenState extends State<TwoFASetupScreen> {
  final UserService _userService = UserService();
  final TextEditingController _otpController = TextEditingController();
  Map<String, dynamic>? _twoFAData;
  bool _isLoading = false;
  String? _errorMessage;
  bool _is2FAEnabled = UserConstants.TWO_FA_STATUS == "true";

  @override
  void initState() {
    super.initState();
    if (!_is2FAEnabled) {
      _fetch2FASetup();
    }
  }

  Future<void> _fetch2FASetup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _userService.setup2FA();
      setState(() {
        _isLoading = false;
        if (response['success']) {
          _twoFAData = response['data'];
        } else {
          _errorMessage = response['message'];
          if (_errorMessage == '2FA already enabled!') {
            _is2FAEnabled = true;
            UserConstants.updateTwoFAStatus("true");
          } else {
            _showSnackBar(_errorMessage!, AppColors.red);
          }
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Network error: Unable to fetch 2FA setup.';
        _showSnackBar(_errorMessage!, AppColors.red);
      });
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) {
      _showSnackBar('Please enter a valid 6-digit OTP', AppColors.red);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _userService.setup2FA(otp: _otpController.text);
      setState(() {
        _isLoading = false;
        if (response['success']) {
          _is2FAEnabled = true;
          UserConstants.updateTwoFAStatus("true");
          _otpController.clear();
          _showSnackBar(response['message'], AppColors.green);
        } else {
          _errorMessage = response['message'];
          _showSnackBar(_errorMessage!, AppColors.red);
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Network error: Unable to verify OTP.';
        _showSnackBar(_errorMessage!, AppColors.red);
      });
    }
  }

  void _copySecretKey(String secret) {
    Clipboard.setData(ClipboardData(text: secret));
    _showSnackBar('Secret key copied to clipboard', AppColors.green);
  }

  void _showSnackBar(String message, Color backgroundColor) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            fontSize: 14.sp,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        action: message.contains('Network error')
            ? SnackBarAction(
          label: 'Retry',
          textColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
          onPressed: _fetch2FASetup,
        )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const CommonAppBar(
        title: '2FA Setup',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(12.r),
                      border: isDarkMode ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
                      boxShadow: isDarkMode
                          ? null
                          : [
                        BoxShadow(
                          color: AppColors.lightShadow,
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Two-Factor Authentication (2FA)',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                              size: 24.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                'Status: ${_is2FAEnabled ? 'Enabled' : 'Disabled'}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: _is2FAEnabled ? AppColors.green : AppColors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!_is2FAEnabled) ...[
                          SizedBox(height: 16.h),
                          Text(
                            'Scan the QR code below using Google Authenticator or copy the secret key to set up 2FA.',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          if (_twoFAData != null && _twoFAData!['qr'] != null)
                            Center(
                              child: Image.memory(
                                base64Decode(_twoFAData!['qr'].split(',')[1]),
                                width: 200.w,
                                height: 200.w,
                              ),
                            ),
                          SizedBox(height: 16.h),
                          if (_twoFAData != null && _twoFAData!['secret'] != null)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _twoFAData!['secret'],
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.copy,
                                    color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                                    size: 20.sp,
                                  ),
                                  onPressed: () => _copySecretKey(_twoFAData!['secret']),
                                ),
                              ],
                            ),
                          SizedBox(height: 16.h),
                          TextField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: InputDecoration(
                              labelText: 'Enter OTP',
                              labelStyle: TextStyle(
                                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                              ),
                              filled: true,
                              fillColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: isDarkMode ? AppColors.darkBorder : AppColors.lightShadow,
                                ),
                              ),
                              counterText: '',
                            ),
                            style: TextStyle(
                              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.green,
                                foregroundColor: AppColors.white,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: _isLoading ? null : _verifyOTP,
                              child: Text(
                                'Verify OTP',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: isDarkMode
                    ? AppColors.darkBackground.withOpacity(0.7)
                    : AppColors.lightBackground.withOpacity(0.7),
                child: Center(
                  child: CircularProgressIndicator(
                    color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                    strokeWidth: 3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}