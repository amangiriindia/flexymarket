import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/main_app_bar.dart';
import '../trade_deatils_screen.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({super.key});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  int _selectedTabIndex = 0;

  final List<String> _tabLabels = [
    'Favorites',
    'Most traded',
    'Top Movers',
    'Majors',
  ];

  final List<Map<String, dynamic>> _marketData = [
    {
      'name': 'Bitcoin vs US Dollar',
      'symbol': 'BTC',
      'price': 104420.89,
      'change': -1.21,
      'icon': Icons.currency_bitcoin,
      'hasChart': true,
    },
    {
      'name': 'Gold vs US Dollar',
      'symbol': 'XAU/USD',
      'price': 3372.847,
      'change': 1.89,
      'icon': Icons.attach_money,
      'hasChart': true,
    },
    {
      'name': 'Apple Inc.',
      'symbol': 'AAPL',
      'price': 201.37,
      'change': 1.07,
      'icon': Icons.apple,
      'hasChart': true,
    },
    {
      'name': 'Euro vs US Dollar',
      'symbol': 'EUR/USD',
      'price': 1.14273,
      'change': 0.66,
      'icon': Icons.euro,
      'hasChart': true,
    },
    {
      'name': 'Great Britain Pound vs US Dollar',
      'symbol': 'GBP/USD',
      'price': 1.35257,
      'change': 0.43,
      'icon': Icons.currency_pound,
      'hasChart': true,
    },
    {
      'name': 'US Dollar vs Japanese Yen',
      'symbol': 'USD/JPY',
      'price': 142.915,
      'change': -0.61,
      'icon': Icons.currency_yen,
      'hasChart': true,
    },
    {
      'name': 'USTEC',
      'symbol': 'USTEC',
      'price': 21479.11,
      'change': 0.85,
      'icon': Icons.trending_up,
      'hasChart': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const CommonAppBar(title: 'Trade', showBackButton: false),
      body: _buildBody(isDarkMode),
    );
  }

  Widget _buildBody(bool isDarkMode) {
    return Column(
      children: [
        _buildAccountInfo(isDarkMode),
        _buildTabBar(isDarkMode),
        _buildSortSection(isDarkMode),
        Expanded(child: _buildMarketList(isDarkMode)),
      ],
    );
  }

  Widget _buildAccountInfo(bool isDarkMode) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow:
            isDarkMode
                ? null
                : [
                  BoxShadow(
                    color: AppColors.lightShadow,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Standard',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color:
                      isDarkMode
                          ? AppColors.darkPrimaryText
                          : AppColors.lightPrimaryText,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color:
                    isDarkMode
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText,
              ),
              const Spacer(),
              Icon(
                Icons.menu,
                color:
                    isDarkMode
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color:
                      isDarkMode
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Standard',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color:
                        isDarkMode
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Demo',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '#271295089',
                style: TextStyle(
                  fontSize: 12.sp,
                  color:
                      isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '10,000.00 USD',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color:
                  isDarkMode
                      ? AppColors.darkPrimaryText
                      : AppColors.lightPrimaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDarkMode) {
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${_tabLabels[index]} tab selected',
                      style: TextStyle(
                        color:
                            isDarkMode
                                ? AppColors.darkPrimaryText
                                : AppColors.lightPrimaryText,
                      ),
                    ),
                  ),
                );
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
                          color:
                              _selectedTabIndex == index
                                  ? (isDarkMode
                                      ? AppColors.darkPrimaryText
                                      : AppColors.lightPrimaryText)
                                  : (isDarkMode
                                      ? AppColors.darkSecondaryText
                                      : AppColors.lightSecondaryText),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 2.h,
                    color:
                        _selectedTabIndex == index
                            ? (isDarkMode
                                ? AppColors.darkPrimaryText
                                : AppColors.lightPrimaryText)
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

  Widget _buildSortSection(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color:
                  isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'Sorted manually',
              style: TextStyle(
                fontSize: 14.sp,
                color:
                    isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Edit pressed',
                    style: TextStyle(
                      color:
                          isDarkMode
                              ? AppColors.darkPrimaryText
                              : AppColors.lightPrimaryText,
                    ),
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color:
                        isDarkMode
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.edit,
                  size: 16.sp,
                  color:
                      isDarkMode
                          ? AppColors.darkPrimaryText
                          : AppColors.lightPrimaryText,
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Search functionality coming soon!',
                    style: TextStyle(
                      color:
                          isDarkMode
                              ? AppColors.darkPrimaryText
                              : AppColors.lightPrimaryText,
                    ),
                  ),
                ),
              );
            },
            child: Icon(
              Icons.search,
              size: 24.sp,
              color:
                  isDarkMode
                      ? AppColors.darkPrimaryText
                      : AppColors.lightPrimaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketList(bool isDarkMode) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: _marketData.length,
      itemBuilder: (context, index) {
        final market = _marketData[index];
        final isPositiveChange = market['change'] >= 0;

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow:
                isDarkMode
                    ? null
                    : [
                      BoxShadow(
                        color: AppColors.lightShadow,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16.w),
            leading: Container(
              width: 40.w,
              height: 40.w,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: (isDarkMode
                        ? AppColors.darkAccent
                        : AppColors.lightAccent)
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                market['icon'],
                size: 24.sp,
                color:
                    isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              ),
            ),
            title: Text(
              market['symbol'],
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color:
                    isDarkMode
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText,
              ),
            ),
            subtitle: Text(
              market['name'],
              style: TextStyle(
                fontSize: 12.sp,
                color:
                    isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60.w,
                  height: 30.h,
                  child: CustomPaint(
                    painter: MiniChartPainter(
                      color: isPositiveChange ? AppColors.green : AppColors.red,
                      isPositive: isPositiveChange,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatPrice(market['price']),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode
                                ? AppColors.darkPrimaryText
                                : AppColors.lightPrimaryText,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositiveChange
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 12.sp,
                          color:
                              isPositiveChange
                                  ? AppColors.green
                                  : AppColors.red,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${market['change'].abs().toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color:
                                isPositiveChange
                                    ? AppColors.green
                                    : AppColors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CryptoTradingScreen(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return price.toStringAsFixed(2);
    } else {
      return price.toStringAsFixed(5);
    }
  }
}

class MiniChartPainter extends CustomPainter {
  final Color color;
  final bool isPositive;
  final bool isDarkMode;

  MiniChartPainter({
    required this.color,
    required this.isPositive,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    final path = Path();

    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(
        size.width * 0.8,
        isPositive ? size.height * 0.2 : size.height * 0.8,
      ),
      Offset(size.width, isPositive ? size.height * 0.1 : size.height * 0.9),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    final dotPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 1.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
