import 'package:flexy_markets/screen/transation/withdraw_fund_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/common_app_bar.dart';
import 'crypto_withdraw_screen.dart';

class WithdrawScreen extends StatelessWidget {
  final double mainBalance;

  const WithdrawScreen({
    super.key,
    required this.mainBalance,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'Withdraw Funds',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Balance',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '\$${mainBalance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
                semanticsLabel: 'Available Balance \$${mainBalance.toStringAsFixed(2)}',
              ),
              SizedBox(height: 16.h),
              Text(
                'Choose a withdrawal method',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              SizedBox(height: 24.h),
              _buildWithdrawalOption(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.account_balance,
                title: 'Bank Withdraw',
                subtitle: '1-3 business days • Free',
                limits: '50 - 2,000 USD',
                gradientColors: isDarkMode
                    ? [AppColors.darkAccent.withOpacity(0.8), AppColors.darkAccent]
                    : [AppColors.lightAccent.withOpacity(0.8), AppColors.lightAccent],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WithdrawFundsScreen(mainBalance: mainBalance),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
              _buildWithdrawalOption(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.currency_bitcoin,
                title: 'Crypto Withdraw',
                subtitle: 'Instant • Low fees',
                limits: '10 - 10M USD',
                gradientColors: isDarkMode
                    ? [AppColors.darkAccent.withOpacity(0.8), AppColors.darkAccent]
                    : [AppColors.lightAccent.withOpacity(0.8), AppColors.lightAccent],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CryptoWithdrawScreen(mainBalance: mainBalance),
                    ),
                  );
                },
              ),
              SizedBox(height: 24.h),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      size: 16.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'All transactions are secure and encrypted',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                      semanticsLabel: 'All transactions are secure and encrypted',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWithdrawalOption({
    required BuildContext context,
    required bool isDarkMode,
    required IconData icon,
    required String title,
    required String subtitle,
    required String limits,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow: isDarkMode
              ? [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 8, offset: const Offset(0, 4))]
              : [BoxShadow(color: AppColors.lightShadow.withOpacity(0.5), spreadRadius: 2, blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Limits: $limits',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText.withOpacity(0.8) : AppColors.lightSecondaryText.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}