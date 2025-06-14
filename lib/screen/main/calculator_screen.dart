import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/common_app_bar.dart';

class RiskCalculatorScreen extends StatefulWidget {
  const RiskCalculatorScreen({super.key});

  @override
  State<RiskCalculatorScreen> createState() => _RiskCalculatorScreenState();
}

class _RiskCalculatorScreenState extends State<RiskCalculatorScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _accountBalanceController = TextEditingController(text: '10000.00');
  final TextEditingController _riskPercentageController = TextEditingController(text: '1.00');
  final TextEditingController _stopLossPipsController = TextEditingController(text: '50');

  double _positionSize = 0.0;
  double _potentialLoss = 0.0;
  String _riskLevel = 'Low Risk';

  late AnimationController _animationController;
  late Animation<double> _positionFadeAnimation;
  late Animation<double> _lossFadeAnimation;
  late Animation<double> _riskFadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _positionFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _lossFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeIn),
      ),
    );
    _riskFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.9, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _accountBalanceController.dispose();
    _riskPercentageController.dispose();
    _stopLossPipsController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calculateRisk() {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final accountBalance = double.tryParse(_accountBalanceController.text.replaceAll(',', '')) ?? 0;
    final riskPercentage = double.tryParse(_riskPercentageController.text) ?? 0;
    final stopLossPips = int.tryParse(_stopLossPipsController.text) ?? 0;

    if (_accountBalanceController.text.isEmpty ||
        _riskPercentageController.text.isEmpty ||
        _stopLossPipsController.text.isEmpty) {
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

    if (accountBalance <= 0 || riskPercentage <= 0 || stopLossPips <= 0) {
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

    final riskAmount = accountBalance * (riskPercentage / 100);
    final positionSize = riskAmount / (stopLossPips * 10);

    setState(() {
      _positionSize = double.parse(positionSize.toStringAsFixed(2));
      _potentialLoss = double.parse(riskAmount.toStringAsFixed(2));
      _riskLevel = riskPercentage <= 1
          ? 'Low Risk'
          : riskPercentage <= 2
          ? 'Medium Risk'
          : 'High Risk';
      _animationController.reset();
      _animationController.forward();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Risk calculated successfully',
          style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
        ),
        backgroundColor: AppColors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text('Risk Calculator'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Returning to Profile',
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
              Icons.help_outline,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              size: 24.sp,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  title: Text(
                    'Risk Calculator Help',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                    semanticsLabel: 'Risk Calculator Help',
                  ),
                  content: Text(
                    'Calculate your trading risk by entering your account balance, risk percentage, and stop loss in pips.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                        ),
                        semanticsLabel: 'Close Help Dialog',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

        body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                _buildInputField(
                  controller: _accountBalanceController,
                  label: 'Account Balance',
                  prefixText: '\$ ',
                  inputType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  semanticsLabel: 'Enter Account Balance',
                  isDarkMode: isDarkMode,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        controller: _riskPercentageController,
                        label: 'Risk Percentage',
                        suffixText: '%',
                        inputType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        semanticsLabel: 'Enter Risk Percentage',
                        isDarkMode: isDarkMode,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildInputField(
                        controller: _stopLossPipsController,
                        label: 'Stop Loss (Pips)',
                        inputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        semanticsLabel: 'Enter Stop Loss in Pips',
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                FadeTransition(
                  opacity: _positionFadeAnimation,
                  child: _buildResultRow(
                    label: 'Position Size',
                    value: '$_positionSize Lots',
                    isDarkMode: isDarkMode,
                    semanticsLabel: 'Position Size: $_positionSize Lots',
                  ),
                ),
                SizedBox(height: 16.h),
                FadeTransition(
                  opacity: _lossFadeAnimation,
                  child: _buildResultRow(
                    label: 'Potential Loss',
                    value: '\$$_potentialLoss',
                    isDarkMode: isDarkMode,
                    semanticsLabel: 'Potential Loss: $_potentialLoss',
                  ),
                ),
                SizedBox(height: 24.h),
                GestureDetector(
                  onTap: _calculateRisk,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        'Calculate',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                        semanticsLabel: 'Calculate Risk',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                FadeTransition(
                  opacity: _riskFadeAnimation,
                  child: _buildRiskLevelIndicator(isDarkMode),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required bool isDarkMode,
    TextInputType inputType = TextInputType.text,
    String? prefixText,
    String? suffixText,
    List<TextInputFormatter>? inputFormatters,
    String? semanticsLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: TextField(
            controller: controller,
            keyboardType: inputType,
            inputFormatters: inputFormatters,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixText: prefixText,
              suffixText: suffixText,
              prefixStyle: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              ),
              suffixStyle: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              ),
            ),

          ),
        ),
      ],
    );
  }

  Widget _buildResultRow({
    required String label,
    required String value,
    required bool isDarkMode,
    String? semanticsLabel,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildRiskLevelIndicator(bool isDarkMode) {
    final riskColor = _riskLevel == 'Low Risk'
        ? AppColors.green
        : _riskLevel == 'Medium Risk'
        ? Colors.orange
        : AppColors.red;
    final flexValue = _riskLevel == 'Low Risk' ? 2 : _riskLevel == 'Medium Risk' ? 4 : 6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Risk Level',
          style: TextStyle(
            fontSize: 16.sp,
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            children: [
              Expanded(
                flex: flexValue,
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: riskColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              Expanded(
                flex: 6 - flexValue,
                child: Container(
                  height: 8.h,
                  color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          _riskLevel,
          style: TextStyle(
            fontSize: 14.sp,
            color: riskColor,
          ),
          semanticsLabel: 'Risk Level: $_riskLevel',
        ),
      ],
    );
  }
}