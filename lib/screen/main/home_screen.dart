import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../constant/user_constant.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/main_app_bar.dart';
import '../metatrade/meta_trade_list_screen.dart';
import '../transation/deposit_screen.dart';
import '../trade/trade_deatils_screen.dart';
import '../twofa/twofa_setup_screen.dart';
import 'calculator_screen.dart';
import 'market_screen.dart';
import '../user/bank_deatils_screen.dart';
import '../profile/edit_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Check KYC, bank, and 2FA status after the first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVerificationStatus();
    });
  }

  void _checkVerificationStatus() {
    final isKycVerified = UserConstants.KYC_STATUS == "true";
    final isBankVerified = UserConstants.BANK_STATUS == "true";
    final is2FAEnabled = UserConstants.TWO_FA_STATUS == "true";

    if (!isKycVerified || !isBankVerified || !is2FAEnabled) {
      _showVerificationDialog(isKycVerified, isBankVerified, is2FAEnabled);
    }
  }

  void _showVerificationDialog(
    bool isKycVerified,
    bool isBankVerified,
    bool is2FAEnabled,
  ) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    showDialog(
      context: context,
      builder: (context) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            backgroundColor:
                isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            contentPadding: EdgeInsets.zero,
            content: Container(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete Your Profile',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode
                              ? AppColors.darkPrimaryText
                              : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'To fully access all features, please complete the following verifications:',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color:
                          isDarkMode
                              ? AppColors.darkSecondaryText
                              : AppColors.lightSecondaryText,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  if (!isKycVerified)
                    _buildVerificationItem(
                      'KYC Verification',
                      'Complete your KYC to verify your identity.',
                      Icons.verified_user,
                      isDarkMode,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      ),
                    ),
                  if (!isKycVerified && (!isBankVerified || !is2FAEnabled))
                    SizedBox(height: 12.h),
                  if (!isBankVerified)
                    _buildVerificationItem(
                      'Bank Details',
                      'Add and verify your bank details for transactions.',
                      Icons.account_balance,
                      isDarkMode,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BankDetailsScreen(),
                        ),
                      ),
                    ),
                  if (!isBankVerified && !is2FAEnabled) SizedBox(height: 12.h),
                  if (!is2FAEnabled)
                    _buildVerificationItem(
                      '2FA Setup',
                      'Enable two-factor authentication for enhanced security.',
                      Icons.security,
                      isDarkMode,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TwoFASetupScreen(),
                        ),
                      ),
                    ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color:
                                isDarkMode
                                    ? AppColors.darkAccent
                                    : AppColors.lightAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (!isKycVerified) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
                              ),
                            );
                          } else if (!isBankVerified) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BankDetailsScreen(),
                              ),
                            );
                          } else if (!is2FAEnabled) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TwoFASetupScreen(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDarkMode
                                  ? AppColors.darkAccent
                                  : AppColors.lightAccent,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Complete Now',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerificationItem(
    String title,
    String description,
    IconData icon,
    bool isDarkMode,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color:
              isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color:
                isDarkMode
                    ? AppColors.darkBorder
                    : AppColors.lightShadow.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          isDarkMode
                              ? AppColors.darkPrimaryText
                              : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color:
                          isDarkMode
                              ? AppColors.darkSecondaryText
                              : AppColors.lightSecondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20.sp,
              color:
                  isDarkMode
                      ? AppColors.darkPrimaryText
                      : AppColors.lightPrimaryText,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const MainAppBar(title: 'Home', showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                _buildAccountSection(isDarkMode),
                SizedBox(height: 16.h),
                _buildTradingOptions(isDarkMode),
               // SizedBox(height: 24.h),
               // _buildTopMoversSection(isDarkMode),
                SizedBox(height: 24.h),
                _buildLearningCenterSection(isDarkMode),
                SizedBox(height: 24.h),
                _buildTradingSignalsSection(isDarkMode),
                SizedBox(height: 24.h),
                _buildPriceAlertsSection(isDarkMode),
                SizedBox(height: 24.h),
                _buildUpcomingEventsSection(isDarkMode),
                SizedBox(height: 24.h),
                _buildDailyTipSection(isDarkMode),
                SizedBox(height: 24.h),
                _buildTopNewsSection(isDarkMode),
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow:
            isDarkMode
                ? null
                : [
                  BoxShadow(
                    color: AppColors.lightShadow,
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        border:
            isDarkMode
                ? Border.all(color: AppColors.darkBorder, width: 0.5)
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Standard',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          isDarkMode
                              ? AppColors.darkPrimaryText
                              : AppColors.lightPrimaryText,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.sp,
                    color:
                        isDarkMode
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                  ),
                ],
              ),
              Icon(
                Icons.menu,
                size: 24.sp,
                color:
                    isDarkMode
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color:
                      isDarkMode
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Standard',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color:
                        isDarkMode
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
                  'Demo',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(),
              Text(
                '#271295089',
                style: TextStyle(
                  fontSize: 14.sp,
                  color:
                      isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '10,000.00 USD',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color:
                  isDarkMode
                      ? AppColors.darkPrimaryText
                      : AppColors.lightPrimaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingOptions(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildOptionCard(
          Icons.candlestick_chart,
          'MT5',
          isDarkMode,
          targetScreen: MetaTradeListScreen(),
        ),
        _buildOptionCard(
          Icons.account_balance_wallet,
          'Deposit',
          isDarkMode,
          targetScreen: DepositScreen(),
        ),
        _buildOptionCard(
          Icons.calculate,
          'Calculator',
          isDarkMode,
          targetScreen: RiskCalculatorScreen(),
        ),
      ],
    );
  }

  Widget _buildOptionCard(
    IconData icon,
    String title,
    bool isDarkMode, {
    Widget? targetScreen,
  }) {
    return GestureDetector(
      onTap: () {
        if (targetScreen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title functionality coming soon!')),
          );
        }
      },
      child: Container(
        width: 100.w,
        height: 70.h,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12.r),
          border:
              isDarkMode
                  ? Border.all(color: AppColors.darkBorder, width: 0.5)
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28.w,
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color:
                    isDarkMode
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopMoversSection(bool isDarkMode) {
    return Column(
      children: [
        _buildSectionHeader('TOP MOVERS', isDarkMode),
        SizedBox(height: 12.h),
        SizedBox(
          height: 160.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            children: [
              _buildTopMoverCard(
                'XNG/USD',
                '3.7044',
                '+6.06%',
                isPositive: true,
                chartColor:
                    isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                isDarkMode: isDarkMode,
              ),
              SizedBox(width: 12.w),
              _buildTopMoverCard(
                'BTC/XAG',
                '3012.178',
                '-5.66%',
                isPositive: false,
                chartColor: AppColors.red,
                isDarkMode: isDarkMode,
              ),
              SizedBox(width: 12.w),
              _buildTopMoverCard(
                'F',
                '9.85',
                '-1.30%',
                isPositive: false,
                chartColor: AppColors.red,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopMoverCard(
    String symbol,
    String price,
    String change, {
    required bool isPositive,
    required Color chartColor,
    required bool isDarkMode,
  }) {
    return Container(
      width: 150.w,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow:
            isDarkMode
                ? null
                : [
                  BoxShadow(
                    color: AppColors.lightShadow,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12.r,
                backgroundColor: chartColor.withOpacity(0.2),
                child: Icon(Icons.circle, color: chartColor, size: 16.sp),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color:
                        isDarkMode
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            height: 40.h,
            child: CustomPaint(
              painter: MiniChartPainter(chartColor),
              size: Size(double.infinity, 40.h),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            price,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color:
                  isDarkMode
                      ? AppColors.darkPrimaryText
                      : AppColors.lightPrimaryText,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(
                isPositive
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: isPositive ? AppColors.green : AppColors.red,
                size: 16.sp,
              ),
              Text(
                change.replaceAll('+', '').replaceAll('-', ''),
                style: TextStyle(
                  color: isPositive ? AppColors.green : AppColors.red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLearningCenterSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learning Center',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color:
                isDarkMode
                    ? AppColors.darkPrimaryText
                    : AppColors.lightPrimaryText,
          ),
        ),
        SizedBox(height: 16.h),
        _buildLearningCard(
          'BTC Trend Analysis',
          'Learn how to analyze Bitcoin trends using technical indicators.',
          Icons.school,
          isDarkMode,
        ),
        SizedBox(height: 16.h),
        _buildLearningCard(
          'Risk Management',
          'Essential strategies for managing trading risks.',
          Icons.bar_chart,
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildLearningCard(
    String title,
    String description,
    IconData icon,
    bool isDarkMode,
  ) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Learning content coming soon!')),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12.r),
          border:
              isDarkMode
                  ? Border.all(color: AppColors.darkBorder, width: 0.5)
                  : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20.w,
                  color:
                      isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color:
                        isDarkMode
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 14.sp,
                color:
                    isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Read More',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color:
                        isDarkMode
                            ? AppColors.darkAccent
                            : AppColors.lightAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward,
                  size: 16.w,
                  color:
                      isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradingSignalsSection(bool isDarkMode) {
    return Column(
      children: [
        _buildSectionHeader('TRADING SIGNALS', isDarkMode),
        SizedBox(height: 12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 0.w),
          child: Row(
            children: [
              Expanded(
                child: _buildSignalCard(
                  'Gold',
                  '30 MIN',
                  'XAUUSD: further advance',
                  isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  true,
                  isDarkMode,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildSignalCard(
                  'Crude Oil (WTI)',
                  '30 MIN',
                  'USOIL: the downside',
                  AppColors.red,
                  false,
                  isDarkMode,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignalCard(
    String title,
    String timeframe,
    String signal,
    Color buttonColor,
    bool isUptrend,
    bool isDarkMode,
  ) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trading signal details coming soon!')),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow:
              isDarkMode
                  ? null
                  : [
                    BoxShadow(
                      color: AppColors.lightShadow,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          isDarkMode
                              ? AppColors.darkPrimaryText
                              : AppColors.lightPrimaryText,
                    ),
                  ),
                ),
                Text(
                  timeframe,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color:
                        isDarkMode
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'Friday, June 13, 2025 3:39 PM IST',
              style: TextStyle(
                fontSize: 11.sp,
                color:
                    isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              height: 60.h,
              child: CustomPaint(
                painter: TradingChartPainter(isUptrend, isDarkMode),
                size: Size(double.infinity, 60.h),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              signal,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color:
                    isDarkMode
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isUptrend
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.white,
                    size: 16.sp,
                  ),
                  Text(
                    'Intraday',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceAlertsSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Alerts',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color:
                isDarkMode
                    ? AppColors.darkPrimaryText
                    : AppColors.lightPrimaryText,
          ),
        ),
        SizedBox(height: 16.h),
        _buildAlertCard('BTC/USD', Icons.currency_bitcoin, isDarkMode),
        SizedBox(height: 12.h),
        _buildAlertCard('ETH/USD', Icons.generating_tokens, isDarkMode),
      ],
    );
  }

  Widget _buildAlertCard(String pair, IconData icon, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border:
            isDarkMode
                ? Border.all(color: AppColors.darkBorder, width: 0.5)
                : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color:
                      isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18.w, color: AppColors.white),
              ),
              SizedBox(width: 12.w),
              Text(
                pair,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color:
                      isDarkMode
                          ? AppColors.darkPrimaryText
                          : AppColors.lightPrimaryText,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Set Alert functionality coming soon!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor:
                  isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              elevation: 0,
              side: BorderSide(
                color:
                    isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Set Alert',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color:
                    isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsSection(bool isDarkMode) {
    return Column(
      children: [
        _buildSectionHeader('UPCOMING EVENTS', isDarkMode),
        SizedBox(height: 12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 0.w),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
            ),
            boxShadow:
                isDarkMode
                    ? null
                    : [
                      BoxShadow(
                        color: AppColors.lightShadow,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
          ),
          child: Column(
            children: [
              _buildEventItem(
                'Import Prices QoQ',
                'NZ',
                '04:15 - In 4 hours',
                isDarkMode,
              ),
              Divider(
                height: 1,
                color:
                    isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              _buildEventItem(
                'Terms of Trade QoQ',
                'NZ',
                '04:15 - In 4 hours',
                isDarkMode,
              ),
              Divider(
                height: 1,
                color:
                    isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              _buildEventItem(
                'Export Prices QoQ',
                'NZ',
                '04:15 - In 4 hours',
                isDarkMode,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventItem(
    String title,
    String country,
    String time,
    bool isDarkMode,
  ) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor:
                isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            child: Text(
              country,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color:
                        isDarkMode
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      country,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color:
                            isDarkMode
                                ? AppColors.darkSecondaryText
                                : AppColors.lightSecondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    ...List.generate(
                      3,
                      (index) => Container(
                        margin: EdgeInsets.only(right: 2.w),
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          color:
                              index < 2
                                  ? AppColors.orange
                                  : (isDarkMode
                                      ? AppColors.darkSecondaryText
                                      : AppColors.lightSecondaryText),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color:
                            isDarkMode
                                ? AppColors.darkSecondaryText
                                : AppColors.lightSecondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTipSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Tip',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color:
                isDarkMode
                    ? AppColors.darkPrimaryText
                    : AppColors.lightPrimaryText,
          ),
        ),
        SizedBox(height: 16.h),
        _buildDailyTipCard(isDarkMode),
      ],
    );
  }

  Widget _buildDailyTipCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border:
            isDarkMode
                ? Border.all(color: AppColors.darkBorder, width: 0.5)
                : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              'Always set stop-loss orders to protect your trading position from unexpected market movements.',
              style: TextStyle(
                fontSize: 14.sp,
                color:
                    isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.lightbulb,
            size: 24.w,
            color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildTopNewsSection(bool isDarkMode) {
    return Column(
      children: [
        _buildSectionHeader('TOP NEWS', isDarkMode),
        SizedBox(height: 12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 0.w),
          child: Column(
            children: [
              _buildNewsItem(
                'Dow Jones Industrial Average struggles under the weight of fresh tr...',
                '28 minutes ago',
                Icons.show_chart,
                isDarkMode,
              ),
              SizedBox(height: 12.h),
              _buildNewsItem(
                'Ripple price forecast: XRP risks nearly 20% drop if losses extend, targets \$1...',
                'XRPUSD ↓ 0.17% 1 hour ago',
                Icons.currency_bitcoin,
                isDarkMode,
              ),
              SizedBox(height: 12.h),
              _buildNewsItem(
                'WTI Price Forecast: Oil prices climb on weaker USD, geopolitical tension, WTI...',
                'USOIL ↑ 1.22% 1 hour ago',
                Icons.local_gas_station,
                isDarkMode,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewsItem(
    String title,
    String subtitle,
    IconData icon,
    bool isDarkMode,
  ) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('News details coming soon!')),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow:
              isDarkMode
                  ? null
                  : [
                    BoxShadow(
                      color: AppColors.lightShadow,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color:
                    isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: AppColors.orange, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? AppColors.white : Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color:
                          isDarkMode
                              ? AppColors.darkSecondary
                              : AppColors.lightSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color:
                isDarkMode
                    ? AppColors.darkSecondaryText
                    : AppColors.lightSecondaryText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Show more functionality coming soon!'),
              ),
            );
          },
          child: Text(
            'Show more',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
