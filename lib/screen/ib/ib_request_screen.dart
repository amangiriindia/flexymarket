import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../constant/user_constant.dart';
import '../../providers/theme_provider.dart';
import '../../service/apiservice/user_service.dart';
import '../../widget/common/main_app_bar.dart';

class IBRequestScreen extends StatefulWidget {
  const IBRequestScreen({Key? key}) : super(key: key);

  @override
  State<IBRequestScreen> createState() => _IBRequestScreenState();
}

class _IBRequestScreenState extends State<IBRequestScreen> {
  final UserService _userService = UserService();
  Map<String, dynamic>? _ibRequestData;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchIBRequestStatus();
  }

  Future<void> _fetchIBRequestStatus() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _userService.getIBRequestStatus();
      setState(() {
        _isLoading = false;
        if (response['success']) {
          _ibRequestData = response['data'];
        } else {
          _errorMessage = response['message'];
          _showSnackBar(_errorMessage!, AppColors.red);
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Network error: Unable to fetch IB request status.';
        _showSnackBar(_errorMessage!, AppColors.red);
      });
    }
  }

  Future<void> _submitIBRequest() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _userService.submitIBRequest();
      setState(() {
        _isLoading = false;
        if (response['success']) {
          _ibRequestData = response['data'];
          _showSnackBar(response['message'], AppColors.green);
        } else {
          _errorMessage = response['message'];
          _showSnackBar(_errorMessage!, AppColors.red);
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Network error: Unable to submit IB request.';
        _showSnackBar(_errorMessage!, AppColors.red);
      });
    }
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
          onPressed: _fetchIBRequestStatus,
        )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const MainAppBar(
        title: 'IB Request',
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
                          'Introducing Broker (IB) Request',
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
                              Icons.info_outline,
                              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                              size: 24.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                'Current Status: ${_ibRequestData != null ? _ibRequestData!['status'] : 'Not Requested'}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: _ibRequestData != null
                                      ? _ibRequestData!['status'] == 'PENDING'
                                      ? AppColors.orange
                                      : _ibRequestData!['status'] == 'APPROVED'
                                      ? AppColors.green
                                      : AppColors.red
                                      : (isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_ibRequestData != null) ...[
                          SizedBox(height: 12.h),
                          Text(
                            'Name: ${_ibRequestData!['name']}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Email: ${_ibRequestData!['email']}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                            ),
                          ),
                          if (_ibRequestData!['remark'] != null) ...[
                            SizedBox(height: 8.h),
                            Text(
                              'Remark: ${_ibRequestData!['remark']}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                              ),
                            ),
                          ],
                          SizedBox(height: 8.h),
                          Text(
                            'Requested At: ${_formatDate(_ibRequestData!['createdAt'])}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                            ),
                          ),
                        ],
                        SizedBox(height: 24.h),
                        if (_ibRequestData == null || _ibRequestData!['status'] != 'PENDING')
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
                              onPressed: _isLoading ? null : _submitIBRequest,
                              child: Text(
                                'Submit IB Request',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
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

  String _formatDate(String? date) {
    if (date == null) return 'N/A';
    try {
      final parsedDate = DateTime.parse(date).toLocal();
      return '${parsedDate.day}-${parsedDate.month}-${parsedDate.year} ${parsedDate.hour}:${parsedDate.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }
}