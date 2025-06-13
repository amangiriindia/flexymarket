import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/main_app_bar.dart';
import '../partnership_program_screen.dart';
import '../performance_screen.dart';
import '../permotions_screen.dart';
import '../setting_screen.dart';
import '../social_trading.dart';
import '../support/my_tickets_screen.dart';
import '../support_screen.dart';
import '../transation_history_screen.dart';
import '../transfer_money_screen.dart';
import '../auth/welcome_screen.dart';
import '../about_us_screen.dart';
import '../deposite_fund_screen.dart';
import '../feedback_screen.dart';
import '../withdraw_fund_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String name = "John Doe";
  final String id = "284591";
  final double balance = 188.84;
  final double total = 440.90;
  final int referrals = 28;
  final String email = "john.doe@email.com";

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const MainAppBar(
        title: 'Profile',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                _buildBalanceSection(isDarkMode),
                SizedBox(height: 20.h),
                _buildPersonalDetailsSection(isDarkMode),
                SizedBox(height: 20.h),
                _buildBenefitsSection(isDarkMode),
                SizedBox(height: 20.h),
                _buildSocialTradingSection(isDarkMode),
                SizedBox(height: 20.h),
                _buildSupportSection(isDarkMode),
                SizedBox(height: 20.h),
                Text(
                  "Logged in as $email",
                  style: TextStyle(
                    color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                _buildLogoutButton(isDarkMode),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceSection(bool isDarkMode) {
    return Container(
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
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                child: CircleAvatar(
                  radius: 28.r,
                  backgroundImage: const NetworkImage("https://i.pravatar.cc/150?img=7"),
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  Text(
                    "ID: $id",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildBalanceRow("Balance", "\$$balance USD", isDarkMode),
          SizedBox(height: 12.h),
          _buildBalanceRow("Total", "\$$total USD", isDarkMode),
          SizedBox(height: 12.h),
          _buildBalanceRow("Referrals", "$referrals", isDarkMode),
        ],
      ),
    );
  }

  Widget _buildBalanceRow(String label, String value, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalDetailsSection(bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("View verification details")),
        );
      },
      child: Container(
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
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          leading: Icon(
            Icons.person,
            color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            size: 24.sp,
          ),
          title: Text(
            "Personal Details",
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  "Fully Verified",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color:  isDarkMode ? AppColors.white : Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.chevron_right,
                size: 24.sp,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitsSection(bool isDarkMode) {
    return Container(
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
            "Benefits",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
          SizedBox(height: 16.h),
          _buildBenefitRow(Icons.star, "Premier Client", "Active", isDarkMode),
          SizedBox(height: 12.h),
          _buildBenefitRow(Icons.swap_horiz, "Swap-Free", "Qualified", isDarkMode),
          SizedBox(height: 12.h),
          _buildBenefitRow(Icons.shield, "Negative Balance Protection", "Active", isDarkMode),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String benefit, String status, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              benefit,
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: status == "Active" ? AppColors.green.withOpacity(0.2) : AppColors.orange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialTradingSection(bool isDarkMode) {
    return Container(
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
            "Social Trading",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
          SizedBox(height: 16.h),
          _buildSocialTradingRow(
            "For Traders",
            "Share your strategy",
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SocialTradingScreen()),
              );
            },
            isDarkMode,
          ),
          Divider(
            height: 32.h,
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          _buildSocialTradingRow(
            "For Investors",
            "Copy successful traders",
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  SocialTradingScreen()),
              );
            },
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialTradingRow(String title, String subtitle, VoidCallback onPressed, bool isDarkMode) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
            ],
          ),
          Icon(
            Icons.chevron_right,
            size: 24.sp,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Financial Actions",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ),
        SizedBox(height: 8.h),
        _buildSupportRow(
          Icons.account_balance_wallet,
          "Deposit",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DepositFundsScreen()),
          ),
          isDarkMode,
        ),
        _buildSupportRow(
          Icons.money_off,
          "Withdraw",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WithdrawFundsScreen()),
          ),
          isDarkMode,
        ),
        _buildSupportRow(
          Icons.history,
          "Transaction History",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
          ),
          isDarkMode,
        ),
        _buildSupportRow(
          Icons.swap_horiz,
          "Transfer Money",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TransferMoneyScreen()),
          ),
          isDarkMode,
        ),
        SizedBox(height: 16.h),
        Text(
          "Support & Settings",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ),
        SizedBox(height: 8.h),
        _buildSupportRow(
          Icons.support_agent,
          "Help Center",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SupportScreen()),
          ),
          isDarkMode,
        ),

        _buildSupportRow(
          Icons.support,
          "My Ticket",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyTicketsScreen()),
          ),
          isDarkMode,
        ),
        _buildSupportRow(
          Icons.local_offer,
          "Promotions",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PromotionsScreen()),
          ),
          isDarkMode,
        ),
        _buildSupportRow(
          Icons.lightbulb_outline,
          "Suggest Feature",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedbackScreen()),
          ),
          isDarkMode,
        ),
        _buildSupportRow(
          Icons.star_border,
          "Rate App",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedbackScreen()),
          ),
          isDarkMode,
        ),
        _buildSupportRow(
          Icons.info_outline,
          "About",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutUsScreen()),
          ),
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildSupportRow(IconData icon, String title, VoidCallback onPressed, bool isDarkMode) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
        child: Row(
          children: [
            Icon(
              icon,
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              size: 24.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 24.sp,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        },
        child: Text(
          "Log Out",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}