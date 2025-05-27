import 'package:flexy_markets/screen/trade_deatils_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({super.key});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  int _selectedTabIndex = 0;
  int _selectedBottomNavIndex = 1; // Trade tab selected by default

  final List<String> _tabLabels = ['Favorites', 'Most Traded', 'Top Movers', 'Majors'];

  final List<Map<String, dynamic>> _marketData = [
    {
      'name': 'Bitcoin',
      'symbol': 'BTC/USD',
      'price': 82595.55,
      'change': 2.34,
      'icon': Icons.currency_bitcoin,
      'iconColor': Colors.orange,
    },
    {
      'name': 'Gold',
      'symbol': 'XAU/USD',
      'price': 2184.30,
      'change': -0.45,
      'icon': Icons.attach_money,
      'iconColor': Colors.amber,
    },
    {
      'name': 'Apple Inc',
      'symbol': 'AAPL',
      'price': 172.40,
      'change': 1.23,
      'icon': Icons.apple,
      'iconColor': Colors.white,
    },
    {
      'name': 'Euro',
      'symbol': 'EUR/USD',
      'price': 1.0845,
      'change': 0.12,
      'icon': Icons.euro,
      'iconColor': Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
     
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(
        'Trade',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Set to white
        ),
      ),
      centerTitle: false,
      actions: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: Colors.grey[700],
                child: Icon(Icons.person, size: 18.sp, color: Colors.white), // Added white color
              ),
              SizedBox(width: 8.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YoForex Premium',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // Set to white
                    ),
                  ),
                ],
              ),
              Icon(Icons.keyboard_arrow_down, size: 20.sp, color: Colors.white), // Added white color
              SizedBox(width: 8.w),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildSearchBar(),
        _buildTabBar(),
        Expanded(
          child: _buildMarketList(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Search pressed', style: TextStyle(color: Colors.white))),
                );
              },
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 12.w),
                    Icon(Icons.search, size: 20.sp, color: Colors.grey), // Preserved
                    SizedBox(width: 8.w),
                    Text(
                      'Search markets',
                      style: TextStyle(
                        color: Colors.grey, // Preserved
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sort pressed', style: TextStyle(color: Colors.white))),
              );
            },
            child: Row(
              children: [
                Icon(Icons.sort, size: 20.sp, color: Colors.white), // Set to white
                SizedBox(width: 4.w),
                Text(
                  'Sort',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white, // Set to white
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50.h,
      child: Row(
        children: List.generate(
          _tabLabels.length,
              (index) => Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        _tabLabels[index],
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: _selectedTabIndex == index
                              ? (index == 0 ? Color(0xFF00685a) : Colors.white) // Preserved, default white for selected
                              : Colors.grey, // Preserved
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 2.h,
                    color: _selectedTabIndex == index
                        ? (index == 0 ? Color(0xFF00685a) : Colors.white) // Changed to white for consistency
                        : Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMarketList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 8.h),
      itemCount: _marketData.length,
      itemBuilder: (context, index) {
        final market = _marketData[index];
        final isPositiveChange = market['change'] >= 0;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        market['icon'],
                        size: 24.sp,
                        color: market['iconColor'], // Preserved
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            market['name'],
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white, // Set to white
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            market['symbol'],
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey, // Preserved
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatPrice(market['price']),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Set to white
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${isPositiveChange ? '+' : ''}${market['change'].toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isPositiveChange ? Color(0xFF00E676) : Colors.red, // Preserved, updated green
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40.h,
                      child: ElevatedButton(
                        onPressed: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>   CryptoTradingScreen()
                              ,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Buy pressed', style: TextStyle(color: Colors.white))),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Buy',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white, // Set to white
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: SizedBox(
                      height: 40.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>   CryptoTradingScreen()
                              ,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sell pressed', style: TextStyle(color: Colors.white))),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Sell',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white, // Set to white
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }




  String _formatPrice(double price) {
    if (price >= 1000) {
      return price.toStringAsFixed(2);
    } else {
      return price.toStringAsFixed(4);
    }
  }
}