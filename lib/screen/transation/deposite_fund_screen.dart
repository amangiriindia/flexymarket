import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constant/app_color.dart';
import '../../../providers/theme_provider.dart';
import '../../../widget/common/common_app_bar.dart';
import 'deposit_confirmation_screen.dart';

class DepositFundsScreen extends StatefulWidget {
  const DepositFundsScreen({super.key});

  @override
  State<DepositFundsScreen> createState() => _DepositFundsScreenState();
}

class _DepositFundsScreenState extends State<DepositFundsScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController(text: '0.00');
  int _selectedPaymentMethod = 0;

  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;

  final List<PaymentMethodModel> _paymentMethods = [
    PaymentMethodModel(
      name: 'Bank Transfer',
      icon: Icons.account_balance,
      iconColor: AppColors.green,
      processingTime: '10-15 min',
      fee: '0%',
      limit: '\$50,000',
      isRecommended: true,
    ),
    PaymentMethodModel(
      name: 'Visa Card',
      icon: Icons.credit_card,
      iconColor: Colors.blue,
      processingTime: 'Instant',
      fee: '1.5%',
      limit: '\$10,000',
    ),
    PaymentMethodModel(
      name: 'Crypto',
      icon: Icons.currency_bitcoin,
      iconColor: Colors.orange,
      processingTime: 'Instant',
      fee: '0%',
      limit: '\$10,000',
      limitIcon: Icons.all_inclusive,
    ),
    PaymentMethodModel(
      name: 'BinancePay',
      icon: Icons.monetization_on,
      iconColor: Colors.yellow,
      processingTime: 'Instant',
      fee: '0%',
      limit: '\$100,000',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimations = List.generate(
      _paymentMethods.length,
          (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeIn),
        ),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'Deposit Funds',
        showBackButton: true,
        onBackPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Returning to Profile',
                style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
              ),
            ),
          );
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Text(
              'Enter Amount',
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                prefixText: '\$ ',
                prefixStyle: TextStyle(
                  fontSize: 24.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent),
                ),
              ),

            ),
            SizedBox(height: 24.h),
            Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: ListView.builder(
                itemCount: _paymentMethods.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final method = _paymentMethods[index];
                  return FadeTransition(
                    opacity: _fadeAnimations[index],
                    child: _buildPaymentMethodItem(method, index, isDarkMode),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {
                _handleContinue();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                    semanticsLabel: 'Continue with Deposit',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodItem(PaymentMethodModel method, int index, bool isDarkMode) {
    final isSelected = _selectedPaymentMethod == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${method.name} selected',
              style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
            ),
            backgroundColor: AppColors.green,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(8.r),
          border: isSelected
              ? Border.all(color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent, width: 1)
              : Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: method.iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      method.icon,
                      color: method.iconColor,
                      size: 20.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          method.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        if (method.isRecommended)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'Recommended',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 24.w,
                    color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  SizedBox(width: 48.w),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.w,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        method.processingTime,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Row(
                    children: [
                      Icon(
                        Icons.money_off,
                        size: 14.w,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${method.fee} fee',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Row(
                    children: [
                      method.limitIcon != null
                          ? Icon(
                        method.limitIcon,
                        size: 14.w,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      )
                          : Icon(
                        Icons.arrow_upward,
                        size: 14.w,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        method.limit,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }

  void _handleContinue() {
    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText) ?? 0.0;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid amount',
            style: TextStyle(color: Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                ? AppColors.darkPrimaryText
                : AppColors.lightPrimaryText),
          ),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (amount > 100000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Amount exceeds maximum limit of \$100,000',
            style: TextStyle(color: Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                ? AppColors.darkPrimaryText
                : AppColors.lightPrimaryText),
          ),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Proceeding with deposit of \$${amount.toStringAsFixed(2)} via ${_paymentMethods[_selectedPaymentMethod].name}',
          style: TextStyle(color: Provider.of<ThemeProvider>(context, listen: false).isDarkMode
              ? AppColors.darkPrimaryText
              : AppColors.lightPrimaryText),
        ),
        backgroundColor: AppColors.green,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DepositConfirmationScreen(
          amount: amount,
          paymentMethod: _paymentMethods[_selectedPaymentMethod].name,
        ),
      ),
    );
  }
}

class PaymentMethodModel {
  final String name;
  final IconData icon;
  final Color iconColor;
  final String processingTime;
  final String fee;
  final String limit;
  final IconData? limitIcon;
  final bool isRecommended;

  PaymentMethodModel({
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.processingTime,
    required this.fee,
    required this.limit,
    this.limitIcon,
    this.isRecommended = false,
  });
}