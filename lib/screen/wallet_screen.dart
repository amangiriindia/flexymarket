import 'package:flexy_markets/screen/profile_screen.dart';
import 'package:flexy_markets/screen/trade_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'deposite_fund_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              // Header section with welcome, notification and profile
              _buildHeader(context),
              SizedBox(height: 16.h),
              // Balance card
              _buildBalanceCard(),
              SizedBox(height: 16.h),
              // Action buttons
              _buildActionButtons(context),
              SizedBox(height: 24.h),
              // Top Movers section
              _buildTopMoversSection(),
              // Bottom navigation bar will be at scaffold bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Welcome, Alex',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 24.sp,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 16.sp,
                backgroundImage: const NetworkImage(
                    'https://randomuser.me/api/portraits/men/32.jpg'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '\$11,557.71 USD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Equity
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Equity',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '+\$1,245.32',
                    style: TextStyle(
                      color: const Color(0xFF00C853),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Margin
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Margin',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '-\$245.89',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Deposit Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DepositFundsScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: Size(0, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            icon: Icon(
              Icons.account_balance_wallet_outlined,
              size: 18.sp,
            ),
            label: Text(
              'Deposit',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Trade Now Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TradeScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: Size(0, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            icon: Icon(
              Icons.trending_up,
              size: 18.sp,
            ),
            label: Text(
              'Trade Now',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopMoversSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Movers',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        // ETH/USD - Positive change
        _buildCryptoCard(
          symbol: 'ETH/USD',
          price: '\$2,456.78',
          percentChange: '+5.67%',
          valueChange: '+\$142.35',
          isPositive: true,
          iconData: Icons.currency_bitcoin_rounded,
        ),
        SizedBox(height: 12.h),
        // BTC/AUD - Negative change
        _buildCryptoCard(
          symbol: 'BTC/AUD',
          price: '\$43,567.90',
          percentChange: '-2.34%',
          valueChange: '-\$1,215.67',
          isPositive: false,
          iconData: Icons.currency_bitcoin,
        ),
        SizedBox(height: 12.h),
        // BTC/XAU - Positive change
        _buildCryptoCard(
          symbol: 'BTC/XAU',
          price: '\$56,789.12',
          percentChange: '+1.23%',
          valueChange: '+\$678.90',
          isPositive: true,
          iconData: Icons.account_balance,
        ),
      ],
    );
  }

  Widget _buildCryptoCard({
    required String symbol,
    required String price,
    required String percentChange,
    required String valueChange,
    required bool isPositive,
    required IconData iconData,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Symbol and percentage
          Row(
            children: [
              Icon(
                iconData,
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                symbol,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                percentChange,
                style: TextStyle(
                  color: isPositive ? const Color(0xFF00C853) : Colors.red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // Right side - Price and value change
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
              Text(
                valueChange,
                style: TextStyle(
                  color: isPositive ? const Color(0xFF00C853) : Colors.red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}


