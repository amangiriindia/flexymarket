import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constant/app_color.dart';
import '../../../providers/theme_provider.dart';
import '../../../widget/common/common_app_bar.dart';

class CryptoTradingScreen extends StatefulWidget {
  const CryptoTradingScreen({super.key});

  @override
  State<CryptoTradingScreen> createState() => _CryptoTradingScreenState();
}

class _CryptoTradingScreenState extends State<CryptoTradingScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _priceController = TextEditingController(text: '82595.55');
  final TextEditingController _amountController = TextEditingController(text: '0.1');
  final TextEditingController _usdAmountController = TextEditingController(text: '1000.00');
  final TextEditingController _stopLossController = TextEditingController(text: '82000.00');
  final TextEditingController _takeProfitController = TextEditingController(text: '83500.00');
  bool isMarketSelected = true;
  double _currentPrice = 82595.55;
  double _volume = 2400000000;
  double _balance = 11557.71;
  double _potentialLoss = 614.67;
  double _potentialProfit = 885.33;

  late AnimationController _animationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<double> _priceFadeAnimation;
  late Animation<double> _chartFadeAnimation;
  late Animation<double> _tabsFadeAnimation;
  late Animation<double> _formFadeAnimation;
  late Animation<double> _buttonsFadeAnimation;
  late Animation<double> _positionsFadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.3, curve: Curves.easeIn)),
    );
    _priceFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.1, 0.4, curve: Curves.easeIn)),
    );
    _chartFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.2, 0.5, curve: Curves.easeIn)),
    );
    _tabsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.3, 0.6, curve: Curves.easeIn)),
    );
    _formFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.4, 0.7, curve: Curves.easeIn)),
    );
    _buttonsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.5, 0.8, curve: Curves.easeIn)),
    );
    _positionsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.6, 0.9, curve: Curves.easeIn)),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _amountController.dispose();
    _usdAmountController.dispose();
    _stopLossController.dispose();
    _takeProfitController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _validateAndUpdateLimitForm() {
    final usdAmount = double.tryParse(_usdAmountController.text) ?? 0;
    final stopLoss = double.tryParse(_stopLossController.text) ?? 0;
    final takeProfit = double.tryParse(_takeProfitController.text) ?? 0;
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    if (_usdAmountController.text.isEmpty ||
        _stopLossController.text.isEmpty ||
        _takeProfitController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all fields',
            style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
          ),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (usdAmount <= 0 || stopLoss <= 0 || takeProfit <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter valid positive numbers',
            style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
          ),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (usdAmount > _balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Amount exceeds available balance',
            style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
          ),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (stopLoss >= _currentPrice || takeProfit <= _currentPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Stop Loss must be below and Take Profit above current price',
            style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
          ),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    setState(() {
      _potentialLoss = (_currentPrice - stopLoss) * (usdAmount / _currentPrice);
      _potentialProfit = (takeProfit - _currentPrice) * (usdAmount / _currentPrice);
    });
  }

  void _setAllocation(double percentage) {
    final amount = (_balance * percentage) / 100;
    _usdAmountController.text = amount.toStringAsFixed(2);
    _validateAndUpdateLimitForm();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: FadeTransition(
          opacity: _headerFadeAnimation,
          child: AppBar(
            title: Text('BTC/USD'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Returning to Markets',
                      style: TextStyle(
                        color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                    ),
                    backgroundColor: AppColors.red,
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.star_border,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  size: 24.sp,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Add to favorites coming soon!',
                        style: TextStyle(
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                      backgroundColor: AppColors.green,
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  size: 24.sp,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'More options coming soon!',
                        style: TextStyle(
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                      backgroundColor: AppColors.green,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),


      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FadeTransition(
                opacity: _priceFadeAnimation,
                child: _buildPriceSection(isDarkMode),
              ),
              FadeTransition(
                opacity: _chartFadeAnimation,
                child: _buildChartArea(isDarkMode),
              ),
              FadeTransition(
                opacity: _tabsFadeAnimation,
                child: _buildOrderTabs(isDarkMode),
              ),
              FadeTransition(
                opacity: _formFadeAnimation,
                child: _buildTradingForm(isDarkMode),
              ),
              FadeTransition(
                opacity: _buttonsFadeAnimation,
                child: _buildActionButtons(isDarkMode),
              ),
              FadeTransition(
                opacity: _positionsFadeAnimation,
                child: _buildAdditionalInfo(isDarkMode),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '\$${_currentPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
                semanticsLabel: 'Current price: ${_currentPrice.toStringAsFixed(2)} USD',
              ),
              SizedBox(width: 8.w),
              Text(
                '+2.34%',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.green,
                ),
                semanticsLabel: 'Price change: +2.34 percent',
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Vol: ${_volume / 1000000000}B USD',
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
            semanticsLabel: 'Volume: ${_volume / 1000000000} billion USD',
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildTimeframeChip('1m', isDarkMode),
              SizedBox(width: 8.w),
              _buildTimeframeChip('5m', isDarkMode),
              SizedBox(width: 8.w),
              _buildTimeframeChip('15m', isDarkMode),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Indicators coming soon!',
                        style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                      ),
                      backgroundColor: AppColors.green,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
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
                        'Indicators',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                        semanticsLabel: 'Add Indicators',
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
          SnackBar(
            content: Text(
              '$text timeframe selected',
              style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
            ),
            backgroundColor: AppColors.green,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
          semanticsLabel: 'Select $text timeframe',
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
                  SnackBar(
                    content: Text(
                      'Market order selected',
                      style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                    ),
                    backgroundColor: AppColors.green,
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isMarketSelected
                      ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                      : (isDarkMode ? AppColors.darkCard : AppColors.lightCard),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    bottomLeft: Radius.circular(8.r),
                  ),
                  border: Border.all(
                    color: isMarketSelected
                        ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                        : (isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Market',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                  semanticsLabel: 'Select Market Order',
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
                  SnackBar(
                    content: Text(
                      'Limit order selected',
                      style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                    ),
                    backgroundColor: AppColors.green,
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: !isMarketSelected
                      ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                      : (isDarkMode ? AppColors.darkCard : AppColors.lightCard),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.r),
                    bottomRight: Radius.circular(8.r),
                  ),
                  border: Border.all(
                    color: !isMarketSelected
                        ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                        : (isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Limit',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                  semanticsLabel: 'Select Limit Order',
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: isMarketSelected ? _buildMarketForm(isDarkMode) : _buildLimitForm(isDarkMode),
    );
  }

  Widget _buildMarketForm(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(
          label: 'Price (USD)',
          controller: _priceController,
          isDarkMode: isDarkMode,
          isEditable: false,
          semanticsLabel: 'Current Price',
        ),
        SizedBox(height: 12.h),
        _buildFormField(
          label: 'Amount (BTC)',
          controller: _amountController,
          isDarkMode: isDarkMode,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,8}'))],
          semanticsLabel: 'Enter BTC Amount',
        ),
      ],
    );
  }

  Widget _buildLimitForm(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(
          label: 'Amount (USD)',
          controller: _usdAmountController,
          isDarkMode: isDarkMode,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
          semanticsLabel: 'Enter USD Amount',
          onChanged: (_) => _validateAndUpdateLimitForm(),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Balance: \$${(_balance).toStringAsFixed(2)} USD',
              style: TextStyle(
                fontSize: 14.sp,
                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              ),
              semanticsLabel: 'Available balance: ${_balance.toStringAsFixed(2)} USD',
            ),
            Row(
              children: [
                _buildAllocationChip(10, isDarkMode),
                SizedBox(width: 8.w),
                _buildAllocationChip(25, isDarkMode),
                SizedBox(width: 8.w),
                _buildAllocationChip(50, isDarkMode),
                SizedBox(width: 8.w),
                _buildAllocationChip(100, isDarkMode),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildFormField(
          label: 'Stop Loss (USD)',
          controller: _stopLossController,
          isDarkMode: isDarkMode,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
          semanticsLabel: 'Enter Stop Loss',
          onChanged: (_) => _validateAndUpdateLimitForm(),
        ),
        SizedBox(height: 4.h),
        Text(
          'Potential Loss: \$${(_potentialLoss).toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.red,
          ),
          semanticsLabel: 'Potential loss: ${_potentialLoss.toStringAsFixed(2)} USD',
        ),
        SizedBox(height: 16.h),
        _buildFormField(
          label: 'Take Profit (USD)',
          controller: _takeProfitController,
          isDarkMode: isDarkMode,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
          semanticsLabel: 'Enter Take Profit',
          onChanged: (_) => _validateAndUpdateLimitForm(),
        ),
        SizedBox(height: 4.h),
        Text(
          'Potential Profit: \$${(_potentialProfit).toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.green,
          ),
          semanticsLabel: 'Potential profit: ${_potentialProfit.toStringAsFixed(2)} USD',
        ),
        SizedBox(height: 16.h),
        Text(
          'Market Sentiment',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
          semanticsLabel: 'Market Sentiment',
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
                  child: Container(color: AppColors.green),
                ),
                Expanded(
                  flex: 36,
                  child: Container(color: AppColors.red),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              'Buy 64%',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.green,
              ),
              semanticsLabel: 'Buy sentiment: 64 percent',
            ),
            const Spacer(),
            Text(
              'Sell 36%',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.red,
              ),
              semanticsLabel: 'Sell sentiment: 36 percent',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAllocationChip(double percentage, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        _setAllocation(percentage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${percentage.toStringAsFixed(0)}% allocation selected',
              style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
            ),
            backgroundColor: AppColors.green,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Text(
          '${percentage.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 14.sp,
            color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
          ),
          semanticsLabel: 'Select ${percentage.toStringAsFixed(0)} percent allocation',
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required bool isDarkMode,
    bool isEditable = true,
    bool showPrefix = true,
    List<TextInputFormatter>? inputFormatters,
    String? semanticsLabel,
    Function(String)? onChanged,
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
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
            boxShadow: isDarkMode
                ? null
                : [
              BoxShadow(
                color: AppColors.lightShadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (showPrefix)
                Text(
                  label.contains('USD') ? '\$' : '',
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
                  inputFormatters: inputFormatters,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: onChanged,

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
            child: GestureDetector(
              onTap: () {
                final amount = double.tryParse(_amountController.text) ?? 0;
                final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
                if (isMarketSelected && (amount <= 0 || _amountController.text.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please enter a valid BTC amount',
                        style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                      ),
                      backgroundColor: AppColors.red,
                    ),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Buy order placed!',
                      style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                    ),
                    backgroundColor: AppColors.green,
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    isMarketSelected ? 'Buy' : 'Buy BTC',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                    semanticsLabel: 'Buy BTC',
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: GestureDetector(
              onTap: () {
                final amount = double.tryParse(_amountController.text) ?? 0;
                final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
                if (isMarketSelected && (amount <= 0 || _amountController.text.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please enter a valid BTC amount',
                        style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                      ),
                      backgroundColor: AppColors.red,
                    ),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Sell order placed!',
                      style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                    ),
                    backgroundColor: AppColors.red,
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    isMarketSelected ? 'Sell' : 'Sell BTC',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                    semanticsLabel: 'Sell BTC',
                  ),
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Text(
              'Open Positions',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
              semanticsLabel: 'Open Positions',
            ),
          ),
          _buildPositionItem(
            'BTC/USD',
            '0.15 BTC',
            '+\$521.34',
            '+2.34%',
            isProfit: true,
            isDarkMode: isDarkMode,
            animation: _positionsFadeAnimation,
          ),
          Divider(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
            height: 1,
          ),
          _buildPositionItem(
            'ETH/USD',
            '2.5 ETH',
            '-\$123.45',
            '-1.12%',
            isProfit: false,
            isDarkMode: isDarkMode,
            animation: _positionsFadeAnimation,
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
        required Animation<double> animation,
      }) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'View $pair position details coming soon!',
              style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
            ),
            backgroundColor: AppColors.green,
          ),
        );
      },
      child: FadeTransition(
        opacity: animation,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
            boxShadow: isDarkMode
                ? null
                : [
              BoxShadow(
                color: AppColors.lightShadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
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

        ),
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

    final Paint gridPaint = Paint()
      ..color = (isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText).withOpacity(0.5)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final Paint labelPaint = Paint()
      ..color = isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText
      ..style = PaintingStyle.fill;

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

    // Draw grid lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

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

    // Draw Y-axis price labels (mock)
    final priceLevels = [60, 100, 140, 180, 220];
    for (int i = 0; i < priceLevels.length; i++) {
      final y = size.height - priceLevels[i];
      final textSpan = TextSpan(
        text: '\$${priceLevels[i]}',
        style: TextStyle(
          fontSize: 10.sp,
          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}