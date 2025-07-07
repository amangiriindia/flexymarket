import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../service/user_service.dart';

class LoginHistoryScreen extends StatefulWidget {
  const LoginHistoryScreen({super.key});

  @override
  State<LoginHistoryScreen> createState() => _LoginHistoryScreenState();
}

class _LoginHistoryScreenState extends State<LoginHistoryScreen> {
  final UserService _userService = UserService();
  List<dynamic> _loginHistory = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLoginHistory();
  }

  Future<void> _fetchLoginHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _userService.getLoginHistory(
        page: 1,
        sizePerPage: 10,
      );
      if (response['status'] == true) {
        setState(() {
          _loginHistory = response['data']['loginHistory'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Failed to load login history';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
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
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color:
                isDarkMode
                    ? AppColors.darkPrimaryText
                    : AppColors.lightPrimaryText,
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Login History',
          style: TextStyle(
            color:
                isDarkMode
                    ? AppColors.darkPrimaryText
                    : AppColors.lightPrimaryText,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isDarkMode),
              SizedBox(height: 24.h),
              Expanded(
                child:
                    _isLoading
                        ? Center(
                          child: CircularProgressIndicator(
                            color:
                                isDarkMode
                                    ? AppColors.darkAccent
                                    : AppColors.lightAccent,
                            strokeWidth: 3,
                          ),
                        )
                        : _errorMessage != null
                        ? Center(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 16.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                        : _loginHistory.isEmpty
                        ? Center(
                          child: Text(
                            'No login history available',
                            style: TextStyle(
                              color:
                                  isDarkMode
                                      ? AppColors.darkSecondaryText
                                      : AppColors.lightSecondaryText,
                              fontSize: 16.sp,
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: _loginHistory.length,
                          itemBuilder: (context, index) {
                            final history = _loginHistory[index];
                            return _buildLoginHistoryCard(history, isDarkMode);
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FontAwesomeIcons.history,
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

  Widget _buildLoginHistoryCard(dynamic history, bool isDarkMode) {
    final timestamp = DateTime.parse(history['timestamp']);
    final formattedDate = DateFormat(
      'MMM d, yyyy – HH:mm',
    ).format(timestamp.toLocal());

    return Card(
      color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
      elevation: isDarkMode ? 0 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color:
                      isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color:
                        isDarkMode
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.computer,
                  color:
                      isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    history['device'] ?? 'Unknown Device',
                    style: TextStyle(
                      color:
                          isDarkMode
                              ? AppColors.darkSecondaryText
                              : AppColors.lightSecondaryText,
                      fontSize: 14.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color:
                      isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  history['ipAddress'] ?? 'Unknown IP',
                  style: TextStyle(
                    color:
                        isDarkMode
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
