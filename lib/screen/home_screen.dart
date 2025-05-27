import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';




class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                // App Bar
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.home, size: 24.w, color: Colors.white),
                          SizedBox(width: 16.w),
                          Text(
                            'Market Insights',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.notifications, size: 24.w, color: Color(0xFF00685a)),
                    ],
                  ),
                ),

                // Trading Options
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildOptionCard(Icons.show_chart, 'Trading'),
                    _buildOptionCard(Icons.account_balance_wallet, 'Deposit'),
                    _buildOptionCard(Icons.calculate, 'Calculator'),
                  ],
                ),

                // Learning Center Section
                SizedBox(height: 24.h),
                Text(
                  'Learning Center',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),

                // BTC Trend Analysis Card
                _buildLearningCard(
                  'BTC Trend Analysis',
                  'Learn how to analyze Bitcoin trends using technical indicators.',
                  Icons.school,
                ),

                SizedBox(height: 16.h),

                // Risk Management Card
                _buildLearningCard(
                  'Risk Management',
                  'Essential strategies for managing trading risks.',
                  Icons.bar_chart,
                ),

                // Price Alerts Section
                SizedBox(height: 24.h),
                Text(
                  'Price Alerts',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),

                // BTC/USD Alert
                _buildAlertCard('BTC/USD', Icons.currency_bitcoin),

                SizedBox(height: 12.h),

                // ETH/USD Alert
                _buildAlertCard('ETH/USD', Icons.generating_tokens),

                // Daily Tip Section
                SizedBox(height: 24.h),
                Text(
                  'Daily Tip',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),

                // Daily Tip Card
                _buildDailyTipCard(),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(IconData icon, String title) {
    return Container(
      width: 100.w,
      height: 70.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28.w,
            color: Color(0xFF00685a),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningCard(String title, String description, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20.w,
                color: Color(0xFF00685a),
              ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[400],
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
                  color:Color(0xFF00685a),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.arrow_forward,
                size: 16.w,
                color:Color(0xFF00685a),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(String pair, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF00685a),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 18.w,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                pair,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Color(0xFF00685a),
              elevation: 0,
              side: const BorderSide(color:Color(0xFF00685a)),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTipCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              'Always set stop-loss orders to protect your trading position from unexpected market movements.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[400],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.lightbulb,
            size: 24.w,
            color: Color(0xFF00685a),
          ),
        ],
      ),
    );
  }
}