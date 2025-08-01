import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/common_app_bar.dart';
import '../transation/bank_deposit_screen.dart';
import '../transation/crypto_deposit_screen.dart';

class DepositScreen extends StatelessWidget {
  const DepositScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider
        .of<ThemeProvider>(context)
        .isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors
          .lightBackground,
      appBar: CommonAppBar(
        title: 'Deposit Funds',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
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
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.green,
                                AppColors.green.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.add_circle_outline,
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
                                'Fund Your Account',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? AppColors.darkPrimaryText
                                      : AppColors.lightPrimaryText,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Choose your preferred deposit method',
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
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              Text(
                'Deposit Methods',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? AppColors.darkPrimaryText
                      : AppColors.lightPrimaryText,
                ),
              ),

              SizedBox(height: 20.h),

              // Bank Deposit Card
              _buildModernDepositOption(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.account_balance_outlined,
                title: 'Bank Transfer',
                subtitle: '30 min - 1 hour',
                limits: '\$50 - \$2,000',
                fee: 'Free',
                gradientColors: [
                  AppColors.darkAccent,
                  AppColors.darkAccent.withOpacity(0.8)
                ],
                backgroundColor: isDarkMode ? AppColors.darkCard : AppColors
                    .lightCard,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BankDepositScreen()),
                  );
                },
              ),

              SizedBox(height: 16.h),

              // Crypto Deposit Card
              _buildModernDepositOption(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.currency_bitcoin_outlined,
                title: 'Tether (USDT TRC20)',
                subtitle: 'Instant - 15 min',
                limits: '\$10 - \$10M',
                fee: 'Free',
                gradientColors: [
                  AppColors.orange,
                  AppColors.orange.withOpacity(0.8)
                ],
                backgroundColor: isDarkMode ? AppColors.darkCard : AppColors
                    .lightCard,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CryptoDepositScreen()),
                  );
                },
              ),

              SizedBox(height: 32.h),

              // Features Section
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
                child: Column(
                  children: [
                    _buildFeatureRow(
                      isDarkMode: isDarkMode,
                      icon: Icons.security_outlined,
                      title: 'Bank-level Security',
                      subtitle: 'All deposits are encrypted and secure',
                      iconColor: Color(0xFF00D4AA),
                    ),
                    SizedBox(height: 16.h),
                    _buildFeatureRow(
                      isDarkMode: isDarkMode,
                      icon: Icons.flash_on_outlined,
                      title: 'Fast Processing',
                      subtitle: 'Quick verification and instant availability',
                      iconColor: AppColors.orange,
                    ),
                    SizedBox(height: 16.h),
                    _buildFeatureRow(
                      isDarkMode: isDarkMode,
                      icon: Icons.support_agent_outlined,
                      title: '24/7 Support',
                      subtitle: 'Get help anytime with your deposits',
                      iconColor: AppColors.darkAccent,
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

  Widget _buildModernDepositOption({
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
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

  Widget _buildFeatureRow({
    required bool isDarkMode,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: iconColor,
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
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? AppColors.darkPrimaryText
                      : AppColors.lightPrimaryText,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
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
      ],
    );
  }
}