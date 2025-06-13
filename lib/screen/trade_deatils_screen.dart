


import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';


class CryptoTradingScreen extends StatefulWidget {
  const CryptoTradingScreen({super.key});

  @override
  State<CryptoTradingScreen> createState() => _CryptoTradingScreenState();
}

class _CryptoTradingScreenState extends State<CryptoTradingScreen> {
  final TextEditingController _priceController = TextEditingController(text: "82,595.55");
  final TextEditingController _amountController = TextEditingController(text: "0.1");
  final TextEditingController _usdAmountController = TextEditingController(text: "1,000.00");
  final TextEditingController _stopLossController = TextEditingController(text: "82,000.00");
  final TextEditingController _takeProfitController = TextEditingController(text: "83,500.00");
  bool isMarketSelected = true;

  @override
  void dispose() {
    _priceController.dispose();
    _amountController.dispose();
    _usdAmountController.dispose();
    _stopLossController.dispose();
    _takeProfitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildPriceSection(isDarkMode),
              _buildChartArea(isDarkMode),
              _buildOrderTabs(isDarkMode),
              _buildTradingForm(isDarkMode),
              _buildActionButtons(isDarkMode),
              _buildAdditionalInfo(isDarkMode),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }



    Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                "BTC/USD",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 24.sp),
            ],
          ),
          Row(
            children: [
              Icon(Icons.star_border, color: Colors.white, size: 24.sp),
              SizedBox(width: 16.w),
              Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "82,595.55",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                "+2.34%",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            "Vol: 2.4B USD",
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildTimeframeChip("1m", isDarkMode),
              SizedBox(width: 8.w),
              _buildTimeframeChip("5m", isDarkMode),
              SizedBox(width: 8.w),
              _buildTimeframeChip("15m", isDarkMode),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Indicators coming soon!')),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_graph,
                        size: 16.sp,
                        color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Indicators",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframeChip(String text, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$text timeframe selected')),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ),
      ),
    );
  }

  Widget _buildChartArea(bool isDarkMode) {
    return Container(
      height: 200.h,
      width: double.infinity,
      color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
      child: CustomPaint(
        painter: CandlestickChartPainter(isDarkMode: isDarkMode),
      ),
    );
  }

  Widget _buildOrderTabs(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isMarketSelected = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Market order selected')),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isMarketSelected
                      ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                      : (isDarkMode ? AppColors.darkCard : AppColors.lightCard),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.r),
                    bottomLeft: Radius.circular(4.r),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Market",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isMarketSelected = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Limit order selected')),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: !isMarketSelected
                      ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                      : (isDarkMode ? AppColors.darkCard : AppColors.lightCard),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4.r),
                    bottomRight: Radius.circular(4.r),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Limit",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingForm(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: isMarketSelected ? _buildMarketForm(isDarkMode) : _buildLimitForm(isDarkMode),
    );
  }

  Widget _buildMarketForm(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField("Price", _priceController, isDarkMode, isEditable: false),
        SizedBox(height: 12.h),
        _buildFormField("Amount (BTC)", _amountController, isDarkMode),
      ],
    );
  }

  Widget _buildLimitForm(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField("Amount (USD)", _usdAmountController, isDarkMode),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: Text(
                "Balance: 11,557.71 USD",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('10% allocation selected')),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  "10%",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          "Stop Loss",
          style: TextStyle(
            fontSize: 14.sp,
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
        ),
        SizedBox(height: 8.h),
        _buildFormField("", _stopLossController, isDarkMode, showPrefix: false),
        SizedBox(height: 4.h),
        Text(
          "Potential Loss: \$614.67",
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.red,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "Take Profit",
          style: TextStyle(
            fontSize: 14.sp,
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
        ),
        SizedBox(height: 8.h),
        _buildFormField("", _takeProfitController, isDarkMode, showPrefix: false),
        SizedBox(height: 4.h),
        Text(
          "Potential Profit: \$885.33",
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.green,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "Market Sentiment",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: Container(
            height: 6.h,
            child: Row(
              children: [
                Expanded(
                  flex: 64,
                  child: Container(
                    color: AppColors.green,
                  ),
                ),
                Expanded(
                  flex: 36,
                  child: Container(
                    color: AppColors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              "Buy 64%",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.green,
              ),
            ),
            const Spacer(),
            Text(
              "Sell 36%",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormField(
      String label,
      TextEditingController controller,
      bool isDarkMode, {
        bool isEditable = true,
        bool showPrefix = true,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
          ),
        if (label.isNotEmpty) SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              if (showPrefix)
                Text(
                  label.contains("USD") ? "\$" : "",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: isEditable,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buy functionality coming soon!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                isMarketSelected ? "Buy" : "Buy BTC",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sell functionality coming soon!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                isMarketSelected ? "Sell" : "Sell BTC",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(bool isDarkMode) {
    if (isMarketSelected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Open Positions",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          _buildPositionItem(
            "BTC/USD",
            "0.15 BTC",
            "+\$521.34",
            "+2.34%",
            isProfit: true,
            isDarkMode: isDarkMode,
          ),
          Divider(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
            height: 1,
          ),
          _buildPositionItem(
            "ETH/USD",
            "2.5 ETH",
            "-\$123.45",
            "-1.12%",
            isProfit: false,
            isDarkMode: isDarkMode,
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildPositionItem(
      String pair,
      String amount,
      String priceChange,
      String percentChange, {
        required bool isProfit,
        required bool isDarkMode,
      }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: Colors.transparent,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pair,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                priceChange,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: isProfit ? AppColors.green : AppColors.red,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                percentChange,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isProfit ? AppColors.green : AppColors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CandlestickChartPainter extends CustomPainter {
  final bool isDarkMode;

  CandlestickChartPainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint greenPaint = Paint()
      ..color = AppColors.green
      ..style = PaintingStyle.fill;

    final Paint redPaint = Paint()
      ..color = AppColors.red
      ..style = PaintingStyle.fill;

    final Paint wickPaint = Paint()
      ..color = isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Sample data for candlesticks: [x, openY, closeY, highY, lowY]
    final List<List<double>> candlesticks = [
      [20, 70, 90, 60, 100],
      [50, 90, 70, 60, 100],
      [80, 120, 150, 110, 160],
      [110, 150, 130, 120, 160],
      [140, 130, 160, 120, 170],
      [170, 160, 140, 130, 170],
      [200, 140, 160, 130, 170],
      [230, 160, 190, 150, 200],
      [260, 190, 170, 160, 200],
      [290, 170, 200, 160, 210],
      [320, 200, 230, 190, 240],
      [350, 230, 250, 220, 260],
    ];

    for (final candle in candlesticks) {
      final double x = candle[0];
      final double open = candle[1];
      final double close = candle[2];
      final double high = candle[4];
      final double low = candle[3];

      // Draw wick
      canvas.drawLine(
        Offset(x, size.height - high),
        Offset(x, size.height - low),
        wickPaint,
      );

      // Draw body
      final double bodyTop = size.height - math.max(open, close);
      final double bodyBottom = size.height - math.min(open, close);
      final double bodyHeight = bodyBottom - bodyTop;

      final Paint bodyPaint = open > close ? redPaint : greenPaint;

      canvas.drawRect(
        Rect.fromLTWH(x - 6, bodyTop, 12, bodyHeight),
        bodyPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}