import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'base/main_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const VerificationScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // Controllers for each digit
  final List<TextEditingController> _controllers = List.generate(
      6,
          (_) => TextEditingController()
  );

  // Focus nodes for each digit
  final List<FocusNode> _focusNodes = List.generate(
      6,
          (_) => FocusNode()
  );

  // Timer for resend countdown
  Timer? _timer;
  int _resendTime = 59; // 59 seconds countdown
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
      // Clear all fields
      for (var controller in _controllers) {
        controller.clear();
      }

      // Reset timer
      setState(() {
        _resendTime = 59;
        _canResend = false;
      });

      // Start timer again
      _startResendTimer();

      // Add actual resend logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification code resent'),
          backgroundColor: Color(0xFF00685a),
        ),
      );
    }
  }

  void _verifyCode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  MainScreen(),
      ),
    );
    // Get the full code
    // String code = _controllers.map((controller) => controller.text).join();
    //
    // // Check if code is complete
    // if (code.length == 6) {
    //   // Add verification logic here
    //   print('Verifying code: $code');
    //
    //   // For demo purposes, show a success message
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Verification successful'),
    //       backgroundColor: Color(0xFF00C853),
    //     ),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Please enter all digits'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
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
              color: const Color(0xFF00685a),
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),

                // Verification Icon
                Icon(
                  Icons.mark_email_read,
                  color: const Color(0xFF00685a),
                  size: 50.sp,
                ),

                SizedBox(height: 20.h),

                // Verification Title
                Text(
                  'Verification Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8.h),

                // Subtitle with phone number
                Text(
                  'Enter the code we sent to:',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 4.h),

                // Phone number
                Text(
                  widget.phoneNumber,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 30.h),

                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                        (index) => SizedBox(
                      width: 45.w,
                      height: 45.w,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: Colors.grey.shade800,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: const Color(0xFF00685a),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: Colors.grey.shade800,
                              width: 1,
                            ),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          // Auto focus to next field
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          }

                          // Auto verify when all digits are entered
                          if (index == 5 && value.isNotEmpty) {
                            // Check if all fields are filled
                            bool allFilled = _controllers.every(
                                    (controller) => controller.text.isNotEmpty
                            );

                            if (allFilled) {
                              // Remove focus from the field
                              FocusScope.of(context).unfocus();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                // Verify Button
                ElevatedButton(
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00685a),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Verify Code',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Resend Code
                TextButton(
                  onPressed: _canResend ? _resendCode : null,
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      color: _canResend ? const Color(0xFF00685a) : Colors.grey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                // Timer
                Text(
                  _canResend ? '' : 'Resend code in 00:${_resendTime.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

