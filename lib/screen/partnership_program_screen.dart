import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PartnershipProgramScreen extends StatelessWidget {
  const PartnershipProgramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Partnership Program',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h),
            // Referral Link Section
            _buildReferralLinkCard(),
            SizedBox(height: 16.h),

            // Earnings and Clients Overview
            Row(
              children: [
                Expanded(child: _buildEarningsCard()),
                SizedBox(width: 16.w),
                Expanded(child: _buildClientsCard()),
              ],
            ),
            SizedBox(height: 16.h),

            // Monthly Earnings Chart
            _buildMonthlyEarningsChart(),
            SizedBox(height: 16.h),

            // Recent Clients
            _buildRecentClientsSection(),
            SizedBox(height: 16.h),

            // Request Payout Button
            _buildRequestPayoutButton(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralLinkCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'flexymarkets.com/ref/user123',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement copy to clipboard functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00685a),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Copy',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Earnings',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                '\$8,450',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '+12.5%',
                style: TextStyle(
                  color: const Color(0xFF00685a),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Clients',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                '24',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '+3 this month',
                style: TextStyle(
                  color: const Color(0xFF00685a),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyEarningsChart() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Earnings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Last 6 months',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 120.h,
            child: CustomPaint(
              painter: MonthlyEarningsChartPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentClientsSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Clients',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          _buildClientTile(
            'Alex Thompson',
            'Joined Mar 15',
            '\$2.4K',
            'https://via.placeholder.com/40',
          ),
          SizedBox(height: 12.h),
          _buildClientTile(
            'Sarah Chen',
            'Joined Mar 12',
            '\$1.8K',
            'https://via.placeholder.com/40',
          ),
        ],
      ),
    );
  }

  Widget _buildClientTile(String name, String joinDate, String volume, String avatarUrl) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                joinDate,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        Text(
          volume,
          style: TextStyle(
            color: const Color(0xFF00685a),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 8.w),
        Icon(
          Icons.circle,
          color: const Color(0xFF00685a),
          size: 10.sp,
        ),
      ],
    );
  }

  Widget _buildRequestPayoutButton() {
    return ElevatedButton(
      onPressed: () {
        // TODO: Implement payout request logic
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00685a),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        'Request Payout',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class MonthlyEarningsChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / 6 * 0.8;
    final paint = Paint()
      ..color = const Color(0xFF00685a)
      ..style = PaintingStyle.fill;

    // Sample earnings data (heights)
    final earnings = [0.4, 0.6, 0.3, 0.7, 0.5, 0.6];

    for (int i = 0; i < earnings.length; i++) {
      final left = i * (size.width / 6);
      final top = size.height * (1 - earnings[i]);

      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(
                  left + (size.width / 6 - barWidth) / 2,
                  top,
                  barWidth,
                  size.height * earnings[i]
              ),
              Radius.circular(4.r)
          ),
          paint
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

