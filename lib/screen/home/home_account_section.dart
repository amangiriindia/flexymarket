import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../service/apiservice/wallet_service.dart';


class HomeAccountSection extends StatefulWidget {
  const HomeAccountSection({Key? key}) : super(key: key);

  @override
  State<HomeAccountSection> createState() => _HomeAccountSectionState();
}

class _HomeAccountSectionState extends State<HomeAccountSection> {
  final WalletService _walletService = WalletService();
  Map<String, dynamic>? _assetData;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userDataResponse = await _walletService.fetchUserData();

      if (userDataResponse['status'] == true) {
        setState(() {
          _assetData = userDataResponse['data']['assetData'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = userDataResponse['message'] ?? 'Failed to fetch user data';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching data: ${e.toString()}';
      });
    }
  }

  // Helper function to safely extract num values from _assetData
  double _getBalanceValue(String key) {
    if (_assetData == null || _assetData![key] == null) {
      return 0.0;
    }
    return (_assetData![key] is num) ? (_assetData![key] as num).toDouble() : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
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
        border: isDarkMode
            ? Border.all(color: AppColors.darkBorder, width: 0.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with account type and menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Account Balance',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? AppColors.darkPrimaryText
                          : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  if (_isLoading)
                    SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isDarkMode
                            ? AppColors.darkAccent
                            : AppColors.lightAccent,
                      ),
                    ),
                ],
              ),
              GestureDetector(
                onTap: _fetchUserData,
                child: Icon(
                  Icons.refresh,
                  size: 20.sp,
                  color: isDarkMode
                      ? AppColors.darkPrimaryText
                      : AppColors.lightPrimaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Account type badges
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.darkBackground
                      : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Standard',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Live',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Main balance display
          if (_errorMessage != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Balance Unavailable',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.red,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 16.sp,
                      color: AppColors.red,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        'Failed to load balance',
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _fetchUserData,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Retry',
                        style: TextStyle(
                          color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Text(
              '\$${_getBalanceValue('mainBalance').toStringAsFixed(2)} USD',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? AppColors.darkPrimaryText
                    : AppColors.lightPrimaryText,
              ),
            ),

          SizedBox(height: 16.h),

          // Quick stats section
          if (_assetData != null && _errorMessage == null)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickStat(
                    label: 'Total Deposit',
                    value: '\$${_getBalanceValue('totalDeposit').toStringAsFixed(2)}',
                    icon: Icons.arrow_downward,
                    color: AppColors.green,
                    isDarkMode: isDarkMode,
                  ),
                  SizedBox(width: 12.w),
                  _buildQuickStat(
                    label: 'Total Withdrawal',
                    value: '\$${_getBalanceValue('totalWithdrawal').toStringAsFixed(2)}',
                    icon: Icons.arrow_upward,
                    color: AppColors.red,
                    isDarkMode: isDarkMode,
                  ),
                  SizedBox(width: 12.w),
                  _buildQuickStat(
                    label: 'IB Income',
                    value: '\$${_getBalanceValue('totalIBIncome').toStringAsFixed(2)}',
                    icon: Icons.trending_up,
                    color: AppColors.green,
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickStat({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDarkMode,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDarkMode
              ? AppColors.darkBorder
              : AppColors.lightShadow.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(
              icon,
              size: 12.sp,
              color: color,
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.darkSecondaryText
                      : AppColors.lightSecondaryText,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}