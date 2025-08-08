import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../constant/user_constant.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/main_app_bar.dart';
import '../home/home_account_section.dart';
import '../home/home_faq_section.dart';
import '../home/home_news_section.dart';
import '../metatrade/meta_trade_list_screen.dart';
import '../transation/deposit_screen.dart';
import '../twofa/twofa_setup_screen.dart';
import 'calculator_screen.dart';
import '../user/bank_deatils_screen.dart';
import '../profile/edit_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
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
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

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
            backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
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
                      color: isDarkMode
                          ? AppColors.darkPrimaryText
                          : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'To fully access all features, please complete the following verifications:',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode
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
                            color: isDarkMode
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
                          backgroundColor: isDarkMode
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
          color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isDarkMode
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
                      color: isDarkMode
                          ? AppColors.darkPrimaryText
                          : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDarkMode
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
              color: isDarkMode
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
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const MainAppBar(title: 'Home', showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                HomeAccountSection(),
                SizedBox(height: 16.h),
                _buildTradingOptions(isDarkMode),
                SizedBox(height: 24.h),
                _buildMT5FeaturesSection(isDarkMode),
                SizedBox(height: 24.h),
                HomeNewsSection(),
                SizedBox(height: 24.h),
                FAQSection(),
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
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
        }
      },
      child: Container(
        width: 100.w,
        height: 70.h,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12.r),
          border: isDarkMode
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
                color: isDarkMode
                    ? AppColors.darkPrimaryText
                    : AppColors.lightPrimaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMT5FeaturesSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MT5 Platform Features',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode
                ? AppColors.darkPrimaryText
                : AppColors.lightPrimaryText,
          ),
        ),
        SizedBox(height: 16.h),
        _buildFeatureCard(
          'Advanced Charting',
          'Access professional charting tools with 80+ technical indicators and analytical objects.',
          Icons.bar_chart,
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildFeatureCard(
          'One-Click Trading',
          'Execute trades instantly with one-click trading directly from charts.',
          Icons.touch_app,
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildFeatureCard(
          'Multi-Asset Trading',
          'Trade Forex, Stocks, Commodities, Indices, and Cryptocurrencies from one platform.',
          Icons.trending_up,
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
      String title,
      String description,
      IconData icon,
      bool isDarkMode,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: isDarkMode
            ? Border.all(color: AppColors.darkBorder, width: 0.5)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 20.w,
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
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
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}