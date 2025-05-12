import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({Key? key}) : super(key: key);

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  String selectedAccount = "All Real Accounts";

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
                // Back button and Title
                _buildHeader(),
                SizedBox(height: 16.h),
          
                // Account Dropdown
                _buildAccountDropdown(),
                SizedBox(height: 16.h),
          
                // Summary and Flexy Benefits
                // Summary and Flexy Benefits
                _buildTabRow(),
                SizedBox(height: 24.h),
          
                // Performance Circle
                _buildPerformanceCircle(),
                SizedBox(height: 24.h),
          
                // Protection and Swap-Free Sections
                _buildProtectionSections(),
                SizedBox(height: 24.h),
          
                // No Activity Section
                _buildNoActivitySection(),
                SizedBox(height: 24.h),
          
                // Start Trading Button
                _buildStartTradingButton(),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, size: 24.sp),
          onPressed: () {
            // Handle back navigation
            Navigator.of(context).pop();
          },
        ),
        SizedBox(width: 8.w),
        Text(
          "Performance",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Updated: Added white color
          ),
        ),
      ],
    );
  }

  Widget _buildAccountDropdown() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedAccount,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white, // Updated: Added white color
            ),
          ),
          Icon(Icons.arrow_drop_down, size: 24.sp),
        ],
      ),
    );
  }

  Widget _buildTabRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                "Summary",
                style: TextStyle(
                  color: Colors.white, // Already defined
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                "Flexy Benefits",
                style: TextStyle(
                  color: Colors.grey, // Already defined
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceCircle() {
    return Center(
      child: Container(
        width: 250.w,
        height: 250.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.green,
            width: 10.r,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "929.88",
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Already defined
                ),
              ),
              Text(
                "USD",
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.grey, // Already defined
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProtectionSections() {
    return Column(
      children: [
        _buildProtectionRow(
          icon: Icons.shield_outlined,
          title: "Negative Balance Protection",
          status: "Active",
        ),
        SizedBox(height: 16.h),
        _buildProtectionRow(
          icon: Icons.swap_horiz,
          title: "Swap-Free",
          status: "Available",
        ),
      ],
    );
  }

  Widget _buildProtectionRow({
    required IconData icon,
    required String title,
    required String status,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.green,
                size: 24.sp,
              ),
              SizedBox(width: 16.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white, // Updated: Added white color
                ),
              ),
            ],
          ),
          Icon(
            Icons.check,
            color: Colors.green,
            size: 24.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildNoActivitySection() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.bar_chart,
            color: Colors.grey,
            size: 64.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            "No activity found",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey, // Already defined
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartTradingButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: () {
          // Start trading functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Start Trading")),
          );
        },
        child: Text(
          "Start Trading",
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