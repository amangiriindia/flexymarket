import 'package:flexy_markets/screen/partnership_program_screen.dart';
import 'package:flexy_markets/screen/performance_screen.dart';
import 'package:flexy_markets/screen/permotions_screen.dart';
import 'package:flexy_markets/screen/setting_screen.dart';
import 'package:flexy_markets/screen/social_trading.dart';
import 'package:flexy_markets/screen/support_screen.dart';
import 'package:flexy_markets/screen/transation_history_screen.dart';
import 'package:flexy_markets/screen/transfer_money_screen.dart';
import 'package:flexy_markets/screen/welcome_screen.dart';
import 'package:flexy_markets/screen/withdraw_fund_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'about_us_screen.dart';
import 'deposite_fund_screen.dart';
import 'feedback_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock data
  final String name = "John Doe";
  final String id = "284591";
  final double balance = 188.84;
  final double total = 440.90;
  final int referrals = 28;
  final String email = "john.doe@email.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                // Header with profile and settings
                _buildHeader(),
                SizedBox(height: 20.h),
                // Balance section
                _buildBalanceSection(),
                SizedBox(height: 20.h),
                // Personal details section
                _buildPersonalDetailsSection(),
                SizedBox(height: 20.h),
                // Benefits section
                _buildBenefitsSection(),
                SizedBox(height: 20.h),
                // Social Trading section
                _buildSocialTradingSection(),
                SizedBox(height: 20.h),
                // Support and other options
                _buildSupportSection(),
                SizedBox(height: 20.h),
                // Logged in info
                Text(
                  "Logged in as $email",
                  style: TextStyle(
                    color: Colors.grey, // Already defined
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                // Log out button
                _buildLogoutButton(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Profile",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Already defined
          ),
        ),
        IconButton(
          icon: Icon(Icons.settings, size: 24.sp, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Settings pressed")));
          },
        ),
      ],
    );
  }

  Widget _buildBalanceSection() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundColor: Colors.teal,
                child: CircleAvatar(
                  radius: 28.r,
                  backgroundImage: const NetworkImage(
                    "https://i.pravatar.cc/150?img=7", // Placeholder avatar
                  ),
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
                      color: Colors.white, // Already defined
                    ),
                  ),
                  Text(
                    "ID: $id",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey, // Already defined
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                _buildBalanceRow("Balance", "\$$balance USD"),
                SizedBox(height: 12.h),
                _buildBalanceRow("Total", "\$$total USD"),
                SizedBox(height: 12.h),
                _buildBalanceRow("Referrals", "$referrals"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey, // Already defined
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Already defined
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalDetailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Icon(Icons.person, color: Color(0xFF00685a), size: 24.sp),
        title: Text(
          "Personal Details",
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white, // Updated: Added white color
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(.3),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                "Fully Verified",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00685a), // Already defined
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.chevron_right, size: 24.sp),
          ],
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Personal Details pressed")),
          );
        },
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Benefits",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Updated: Added white color
            ),
          ),
          SizedBox(height: 16.h),
          _buildBenefitRow("Premier Client", "Active"),
          SizedBox(height: 12.h),
          _buildBenefitRow("Swap-Free", "Qualified"),
          SizedBox(height: 12.h),
          _buildBenefitRow("Negative Balance Protection", "Active"),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(String benefit, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          benefit,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white, // Updated: Added white color
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color:
                status == "Active"
                    ? Colors.green.withOpacity(.2)
                    : Colors.green.withOpacity(.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00685a), // Updated: Added white color
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialTradingSection() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Social Trading",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Updated: Added white color
            ),
          ),
          SizedBox(height: 16.h),
          _buildSocialTradingRow("For Traders", "Share your strategy", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>SocialTradingScreen()),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("For Traders pressed")),
            );
          }),
          SizedBox(height: 16.h),
          _buildSocialTradingRow(
            "For Investors",
            "Copy successful traders",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>SocialTradingScreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("For Investors pressed")),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSocialTradingRow(
    String title,
    String subtitle,
    VoidCallback onPressed,
  ) {
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
                  color: Colors.white, // Updated: Added white color
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey, // Already defined
                ),
              ),
            ],
          ),
          Icon(Icons.chevron_right, size: 24.sp, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Column(
      children: [
        _buildSupportRow(Icons.support_agent, "Help Center", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SupportScreen()),
          );
        }),
        _buildSupportRow(Icons.local_offer, "Promotions", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PromotionsScreen()),
          );
        }),
        _buildSupportRow(Icons.lightbulb_outline, "Suggest Feature", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedbackScreen()),
          );
        }),
        _buildSupportRow(Icons.account_balance_wallet, "Deposit", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DepositFundsScreen()),
          );
        }),
        _buildSupportRow(Icons.money_off, "Withdraw", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WithdrawFundsScreen()),
          );
        }),
        _buildSupportRow(Icons.history, "Transaction History", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
          );
        }),
        _buildSupportRow(Icons.swap_horiz, "Transfer Money", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TransferMoneyScreen()),
          );
        }),
        _buildSupportRow(Icons.star_border, "Rate App", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedbackScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Opening Rate App")),
          );
        }),
        _buildSupportRow(Icons.info_outline, "About", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutUsScreen()),
          );
        }),
      ],
    );
  }

  Widget _buildSupportRow(IconData icon, String title, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        leading: Icon(icon, color:Color(0xFF00685a), size: 24.sp),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white, // Updated: Added white color
          ),
        ),
        trailing: Icon(Icons.chevron_right, size: 24.sp, color: Colors.white),
        onTap: onPressed,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Logged out")));
        },
        child: Text(
          "Log Out",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Already defined
          ),
        ),
      ),
    );
  }
}
