import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Markets',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, size: 24.sp),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListView(
          children: [
            SizedBox(height: 10.h),
            _buildSectionHeader('Top Movers'),
            SizedBox(height: 10.h),
            _buildCryptoCard(
              'ETH/USD',
              '\$2,847.23',
              '+5.67%',
              isPositive: true,
              iconPath: 'assets/ethereum.png',
              iconColor: Colors.blue,
            ),
            SizedBox(height: 8.h),
            _buildCryptoCard(
              'BTC/AUD',
              'A\$89,456.78',
              '-2.34%',
              isPositive: false,
              iconPath: 'assets/bitcoin.png',
              iconColor: Colors.orange,
            ),
            SizedBox(height: 20.h),
            _buildSectionHeader('Trading Signals'),
            SizedBox(height: 10.h),
            _buildTradingSignalCard(),
            SizedBox(height: 20.h),
            _buildSectionHeader('Upcoming Events'),
            SizedBox(height: 10.h),
            _buildEventCard(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Show More',
          style: TextStyle(
            color: Color(0xFF00685a),
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildCryptoCard(
      String name,
      String price,
      String change,
      {required bool isPositive,
        required String iconPath,
        required Color iconColor}
      ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: iconColor.withOpacity(0.2),
            child: Icon(
              iconPath == 'assets/ethereum.png' ? Icons.circle : Icons.currency_bitcoin,
              color: iconColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                change,
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.red,
                size: 20.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradingSignalCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ETH/USD Signal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '2h ago',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'ETH under pressure below 1852',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Icon(
            Icons.trending_down,
            color: Colors.red,
            size: 20.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.flag_outlined,
              color: Colors.grey[400],
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cash Earnings YoY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '7 Apr 2025, 14:30 GMT',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}