import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/common_app_bar.dart';
import 'crypto_withdraw_screen.dart';
import 'withdraw_fund_screen.dart';


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
                'Choose Withdrawal Method',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
                semanticsLabel: 'Choose Withdrawal Method',
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                label: 'Available Balance',
                value: '\$${mainBalance.toStringAsFixed(2)}',
                isDarkMode: isDarkMode,
                enabled: false,
              ),
              SizedBox(height: 24.h),
              _buildWithdrawalOption(
                context: context,
                label: 'Bank Withdraw',
                subtitle: '1-3 business days • Free',
                icon: Icons.account_balance,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WithdrawFundsScreen(
                      mainBalance: mainBalance,
                    ),
                  ),
                ),
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: 16.h),
              _buildWithdrawalOption(
                context: context,
                label: 'Crypto Withdraw',
                subtitle: 'Instant • Low fees',
                icon: Icons.currency_bitcoin,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CryptoWithdrawScreen(
                      mainBalance: mainBalance,
                    ),
                  ),
                ),
                isDarkMode: isDarkMode,
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

  Widget _buildTextField({
    required String label,
    required String value,
    required bool isDarkMode,
    bool enabled = true,
  }) {
    return TextFormField(
      initialValue: value,
      enabled: enabled,
      style: TextStyle(
        color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        fontSize: 16.sp,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
    );
  }

  Widget _buildWithdrawalOption({
    required BuildContext context,
    required String label,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow: isDarkMode
              ? null
              : [
            BoxShadow(
              color: AppColors.lightShadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              size: 24.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
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