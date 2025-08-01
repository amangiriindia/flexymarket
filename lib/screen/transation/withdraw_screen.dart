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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [
                      Color(0xFF1A1A1A),
                      Color(0xFF2D2D2D),
                    ]
                        : [
                      Colors.white,
                      Color(0xFFFAFAFA),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isDarkMode
                        ? Color(0xFF333333)
                        : Color(0xFFE8E8E8),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Balance',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '\$${mainBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                      ),
                      semanticsLabel: 'Available Balance \$${mainBalance.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              Text(
                'Choose withdrawal method',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? AppColors.darkPrimaryText
                      : AppColors.lightPrimaryText,
                ),
              ),

              SizedBox(height: 20.h),

              // Bank Withdraw Card
              _buildModernWithdrawalOption(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.account_balance_outlined,
                title: 'Bank Transfer',
                subtitle: '1-3 business days',
                limits: '\$50 - \$2,000',
                fee: 'Free',
                gradientColors: isDarkMode
                    ? [AppColors.darkAccent, AppColors.darkAccent.withOpacity(0.8)]
                    : [AppColors.lightAccent, AppColors.lightAccent.withOpacity(0.8)],
                backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
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

              // Crypto Withdraw Card
              _buildModernWithdrawalOption(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.currency_bitcoin_outlined,
                title: 'Crypto Transfer',
                subtitle: 'Instant transfer',
                limits: '\$10 - \$10M',
                fee: 'Low fees',
                gradientColors: isDarkMode
                    ? [AppColors.orange, AppColors.orange.withOpacity(0.8)]
                    : [AppColors.orange, AppColors.orange.withOpacity(0.8)],
                backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CryptoWithdrawScreen(mainBalance: mainBalance),
                    ),
                  );
                },
              ),

              SizedBox(height: 40.h),

              // Security Info
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Color(0xFF1A1A1A).withOpacity(0.5)
                      : Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDarkMode
                        ? Color(0xFF333333)
                        : Color(0xFFE8E8E8),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Color(0xFF00D4AA).withOpacity(0.2)
                            : Color(0xFF00D4AA).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.security_outlined,
                        size: 20.sp,
                        color: Color(0xFF00D4AA),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Secure & Protected',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode
                                  ? AppColors.darkPrimaryText
                                  : AppColors.lightPrimaryText,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'All transactions are encrypted and secure',
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernWithdrawalOption({
    required BuildContext context,
    required bool isDarkMode,
    required IconData icon,
    required String title,
    required String subtitle,
    required String limits,
    required String fee,
    required List<Color> gradientColors,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 24.sp,
                color: Colors.white,
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
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppColors.darkPrimaryText
                          : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: gradientColors[0].withOpacity(0.1),
                          border: Border.all(
                            color: gradientColors[0].withOpacity(0.3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          limits,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: gradientColors[0],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.green.withOpacity(0.1),
                          border: Border.all(
                            color: AppColors.green.withOpacity(0.3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          fee,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkBorder.withOpacity(0.3)
                    : AppColors.lightBorder.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: isDarkMode
                    ? AppColors.darkSecondaryText
                    : AppColors.lightSecondaryText,
                size: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}