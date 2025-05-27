import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class CryptoTradingScreen extends StatefulWidget {
  const CryptoTradingScreen({Key? key}) : super(key: key);

  @override
  State<CryptoTradingScreen> createState() => _CryptoTradingScreenState();
}

class _CryptoTradingScreenState extends State<CryptoTradingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _priceController = TextEditingController(text: "82,595.55");
  final TextEditingController _amountController = TextEditingController(text: "0.1");
  final TextEditingController _usdAmountController = TextEditingController(text: "1,000.00");
  final TextEditingController _stopLossController = TextEditingController(text: "82,000.00");
  final TextEditingController _takeProfitController = TextEditingController(text: "83,500.00");
  bool isMarketSelected = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _priceController.dispose();
    _amountController.dispose();
    _usdAmountController.dispose();
    _stopLossController.dispose();
    _takeProfitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              _buildHeader(),
          
              // Price and Chart
              _buildPriceSection(),
          
              // Chart Area
              _buildChartArea(),
          
              // Tab section
              _buildOrderTabs(),
          
              // Trading Form
              _buildTradingForm(),
          
              // Buy/Sell Buttons
              _buildActionButtons(),
          
              // Open Positions or Additional Info
              _buildAdditionalInfo(),
          

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

  Widget _buildPriceSection() {
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
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                "+2.34%",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            "Vol: 2.4B USD",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildTimeframeChip("1m"),
              SizedBox(width: 8.w),
              _buildTimeframeChip("5m"),
              SizedBox(width: 8.w),
              _buildTimeframeChip("15m"),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.auto_graph, size: 16.sp, color: Colors.white),
                    SizedBox(width: 4.w),
                    Text(
                      "Indicators",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframeChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildChartArea() {
    return Container(
      height: 200.h,
      width: double.infinity,
      color: Color(0xFF0A1929),
      child: CustomPaint(
        painter: CandlestickChartPainter(),
      ),
    );
  }

  Widget _buildOrderTabs() {
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
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isMarketSelected ? Color(0xFF00685a) : Color(0xFF1E1E1E),
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
                    color: isMarketSelected ? Colors.white : Colors.white,
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
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: !isMarketSelected ? Color(0xFF00685a) : Color(0xFF1E1E1E),
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
                    color: !isMarketSelected ? Colors.white : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: isMarketSelected ? _buildMarketForm() : _buildLimitForm(),
    );
  }

  Widget _buildMarketForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField("Price", _priceController, isEditable: false),
        SizedBox(height: 12.h),
        _buildFormField("Amount (BTC)", _amountController),
      ],
    );
  }

  Widget _buildLimitForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField("Amount (USD)", _usdAmountController),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: Text(
                "Balance: 11,557.71 USD",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[400],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                "10%",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xFF00685a),
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
            color: Colors.grey[400],
          ),
        ),
        SizedBox(height: 8.h),
        _buildFormField("", _stopLossController, showPrefix: false),
        SizedBox(height: 4.h),
        Text(
          "Potential Loss: \$614.67",
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.red,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "Take Profit",
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[400],
          ),
        ),
        SizedBox(height: 8.h),
        _buildFormField("", _takeProfitController, showPrefix: false),
        SizedBox(height: 4.h),
        Text(
          "Potential Profit: \$885.33",
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "Market Sentiment",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  flex: 36,
                  child: Container(
                    color: Colors.red,
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
                color: Colors.green,
              ),
            ),
            Spacer(),
            Text(
              "Sell 36%",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, {bool isEditable = true, bool showPrefix = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[400],
            ),
          ),
        if (label.isNotEmpty) SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              if (showPrefix)
                Text(
                  label.contains("USD") ? "\$" : "",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: isEditable,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
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

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
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

  Widget _buildAdditionalInfo() {
    // If we're in market view, show open positions
    // If in limit view, this section could be empty or show something else
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
                color: Colors.white,
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
          ),
          Divider(color: Colors.grey.withOpacity(0.2), height: 1),
          _buildPositionItem(
            "ETH/USD",
            "2.5 ETH",
            "-\$123.45",
            "-1.12%",
            isProfit: false,
          ),
        ],
      );
    } else {
      return SizedBox(); // Empty space for limit view
    }
  }

  Widget _buildPositionItem(String pair, String amount, String priceChange, String percentChange, {required bool isProfit}) {
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
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                priceChange,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: isProfit ? Color(0xFF00E676) : Colors.red,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                percentChange,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isProfit ? Color(0xFF00E676) : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, "Home"),
          _buildNavItem(Icons.show_chart, "Trade", isSelected: true),
          _buildNavItem(Icons.account_balance_wallet, "Wallet"),
          _buildNavItem(Icons.person, "Profile"),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? Color(0xFF00685a) : Colors.grey,
          size: 24.sp,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isSelected ? Color(0xFF00685a) : Colors.grey,
          ),
        ),
      ],
    );
  }
}

// Custom painter for the candlestick chart
class CandlestickChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint greenPaint = Paint()
      ..color = Color(0xFF00685a)
      ..style = PaintingStyle.fill;

    final Paint redPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final Paint wickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Sample data for candlesticks
    // Each candlestick is [x, openY, closeY, highY, lowY]
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
      final double low = candle[3];
      final double high = candle[4];

      // Draw wick
      canvas.drawLine(
        Offset(x, size.height - high),
        Offset(x, size.height - low),
        wickPaint,
      );

      // Draw body
      final double bodyTop = size.height - Math.max(open, close);
      final double bodyBottom = size.height - Math.min(open, close);
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

// Import a math library for using max function
class Math {
  static double max(double a, double b) => a > b ? a : b;
  static double min(double a, double b) => a < b ? a : b;
}