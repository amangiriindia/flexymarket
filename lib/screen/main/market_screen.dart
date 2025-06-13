import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/main_app_bar.dart';


class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  bool _isDarkMode = false;


  @override
  Widget build(BuildContext context) {

    final _isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      backgroundColor: _isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: MainAppBar(
        title: 'Market',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            _buildAccountSection(),
            SizedBox(height: 16.h),
            _buildTopMoversSection(),
            SizedBox(height: 16.h),
            _buildTradingSignalsSection(),
            SizedBox(height: 16.h),
            _buildUpcomingEventsSection(),
            SizedBox(height: 16.h),
            _buildTopNewsSection(),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: _isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: _isDarkMode
            ? null
            : [
          BoxShadow(
            color: AppColors.lightShadow,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: _isDarkMode ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Standard',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: _isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.sp,
                    color: _isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ],
              ),
              Icon(
                Icons.menu,
                size: 24.sp,
                color: _isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Standard',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: _isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Demo',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(),
              Text(
                '#271295089',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: _isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
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
              color: _isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopMoversSection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _buildSectionHeader('TOP MOVERS'),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 160.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            children: [
              _buildTopMoverCard(
                'XNG/USD',
                '3.7044',
                '+6.06%',
                isPositive: true,
                chartColor: _isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              ),
              SizedBox(width: 12.w),
              _buildTopMoverCard(
                'BTC/XAG',
                '3012.178',
                '-5.66%',
                isPositive: false,
                chartColor: AppColors.red,
              ),
              SizedBox(width: 12.w),
              _buildTopMoverCard(
                'F',
                '9.85',
                '-1.30%',
                isPositive: false,
                chartColor: AppColors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopMoverCard(
      String symbol,
      String price,
      String change, {
        required bool isPositive,
        required Color chartColor,
      }) {
    return Container(
      width: 150.w,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: _isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: _isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: _isDarkMode
            ? null
            : [
          BoxShadow(
            color: AppColors.lightShadow,
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12.r,
                backgroundColor: chartColor.withOpacity(0.2),
                child: Icon(
                  Icons.circle,
                  color: chartColor,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: _isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            height: 40.h,
            child: CustomPaint(
              painter: MiniChartPainter(chartColor),
              size: Size(double.infinity, 40.h),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            price,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(
                isPositive ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: isPositive ? AppColors.green : AppColors.red,
                size: 16.sp,
              ),
              Text(
                change.replaceAll('+', '').replaceAll('-', ''),
                style: TextStyle(
                  color: isPositive ? AppColors.green : AppColors.red,
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

  Widget _buildTradingSignalsSection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _buildSectionHeader('TRADING SIGNALS'),
        ),
        SizedBox(height: 12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(
                child: _buildSignalCard(
                  'Gold',
                  '30 MIN',
                  'XAUUSD: further advance',
                  _isDarkMode ? AppColors.darkSignalButton : AppColors.lightSignalButton,
                  true,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildSignalCard(
                  'Crude Oil (WTI)',
                  '30 MIN',
                  'USOIL: the downside',
                  AppColors.red,
                  false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignalCard(String title, String timeframe, String signal, Color buttonColor, bool isUptrend) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: _isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: _isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: _isDarkMode
            ? null
            : [
          BoxShadow(
            color: AppColors.lightShadow,
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: _isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              ),
              Text(
                timeframe,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: _isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Monday, June 2, 2025 5:42:10 PM CET',
            style: TextStyle(
              fontSize: 11.sp,
              color: _isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 60.h,
            child: CustomPaint(
              painter: TradingChartPainter(isUptrend, _isDarkMode),
              size: Size(double.infinity, 60.h),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            signal,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: _isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isUptrend ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.white,
                  size: 16.sp,
                ),
                Text(
                  'Intraday',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsSection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _buildSectionHeader('UPCOMING EVENTS'),
        ),
        SizedBox(height: 12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: _isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: _isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
            boxShadow: _isDarkMode
                ? null
                : [
              BoxShadow(
                color: AppColors.lightShadow,
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildEventItem('Import Prices QoQ', 'NZ', '04:15 - In 4 hours'),
              Divider(height: 1, color: _isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
              _buildEventItem('Terms of Trade QoQ', 'NZ', '04:15 - In 4 hours'),
              Divider(height: 1, color: _isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
              _buildEventItem('Export Prices QoQ', 'NZ', '04:15 - In 4 hours'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventItem(String title, String country, String time) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: _isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            child: Text(
              country,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
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
                    fontWeight: FontWeight.w500,
                    color: _isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      country,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: _isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    ...List.generate(
                      3,
                          (index) => Container(
                        margin: EdgeInsets.only(right: 2.w),
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          color: index < 2
                              ? AppColors.orange
                              : (_isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: _isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNewsSection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _buildSectionHeader('TOP NEWS'),
        ),
        SizedBox(height: 12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              _buildNewsItem(
                'Dow Jones Industrial Average struggles under the weight of fresh tr...',
                '28 minutes ago',
                Icons.show_chart,
              ),
              SizedBox(height: 12.h),
              _buildNewsItem(
                'Ripple price forecast: XRP risks nearly 20% drop if losses extend, targets \$1...',
                'XRPUSD ↓ 0.17% 1 hour ago',
                Icons.currency_bitcoin,
              ),
              SizedBox(height: 12.h),
              _buildNewsItem(
                'WTI Price Forecast: Oil prices climb on weaker USD, geopolitical tension, WTI...',
                'USOIL ↑ 1.22% 1 hour ago',
                Icons.local_gas_station,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewsItem(String title, String subtitle, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: _isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: _isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: _isDarkMode
            ? null
            : [
          BoxShadow(
            color: AppColors.lightShadow,
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: _isDarkMode ? AppColors.darkNewsIconBackground : AppColors.lightNewsIconBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: AppColors.orange,
              size: 24.sp,
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
                    fontWeight: FontWeight.w500,
                    color: _isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: _isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
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
            color: _isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          'Show more',
          style: TextStyle(
            color: _isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24.sp,
          color: isSelected
              ? (_isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText)
              : (_isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isSelected
                ? (_isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText)
                : (_isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class MiniChartPainter extends CustomPainter {
  final Color color;

  MiniChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.4, size.height * 0.3);
    path.lineTo(size.width * 0.6, size.height * 0.6);
    path.lineTo(size.width * 0.8, size.height * 0.2);
    path.lineTo(size.width, size.height * 0.1);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TradingChartPainter extends CustomPainter {
  final bool isUptrend;
  final bool isDarkMode;

  TradingChartPainter(this.isUptrend, this.isDarkMode);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeColor = isUptrend ? AppColors.green : AppColors.red;
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 10; i++) {
      final x = (size.width / 10) * i + (size.width / 20);
      final high = size.height * 0.1;
      final low = size.height * 0.9;
      final open = size.height * (isUptrend ? 0.7 : 0.3);
      final close = size.height * (isUptrend ? 0.3 : 0.7);

      canvas.drawLine(Offset(x, high), Offset(x, low), paint);

      final bodyPaint = Paint()
        ..color = strokeColor
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(x - 3, open, 6, close - open),
        bodyPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}