import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../constant/app_color.dart';
import '../../../providers/theme_provider.dart';
import '../../../widget/common/common_app_bar.dart';

class DepositConfirmationScreen extends StatefulWidget {
  final double amount;
  final String paymentMethod;

  const DepositConfirmationScreen({
    super.key,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  State<DepositConfirmationScreen> createState() => _DepositConfirmationScreenState();
}

class _DepositConfirmationScreenState extends State<DepositConfirmationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _summaryFadeAnimation;
  late Animation<double> _instructionsFadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _summaryFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _instructionsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeIn),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    const String bitcoinAddress = 'bc1qxy2kgdygjrsgtzq2n0yrf2493p83kkfjhx0wlh';
    final bool isCrypto = widget.paymentMethod.toLowerCase().contains('crypto');
    final String instructions = isCrypto
        ? 'Send exactly ${(widget.amount / 30000).toStringAsFixed(5)} BTC to the address above. Transaction will be credited after 2 network confirmations.'
        : 'Please transfer \$${widget.amount.toStringAsFixed(2)} to the provided account details. Transaction will be credited after verification.';
    final String accountDetails = isCrypto
        ? bitcoinAddress
        : 'Bank: Example Bank\nAccount: 1234-5678-9012-3456\nSWIFT: EXBKUS33';

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'Deposit Confirmation',
        showBackButton: true,
        onBackPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Returning to Deposit',
                style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
              ),
            ),
          );
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeTransition(
                opacity: _summaryFadeAnimation,
                child: _buildCard(
                  title: 'Transaction Summary',
                  content: Column(
                    children: [
                      _buildSummaryRow(
                        label: 'Amount',
                        value: '\$${widget.amount.toStringAsFixed(2)} USD',
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: 16.h),
                      _buildSummaryRow(
                        label: 'Payment Method',
                        value: widget.paymentMethod,
                        valueIcon: Icon(
                          isCrypto ? Icons.currency_bitcoin : Icons.account_balance,
                          color: AppColors.green,
                          size: 18.w,
                        ),
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: 16.h),
                      _buildSummaryRow(
                        label: 'Processing Time',
                        value: isCrypto ? '2 confirmations' : '1-3 business days',
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: 16.h),
                      _buildSummaryRow(
                        label: 'Fees',
                        value: '0%',
                        valueColor: AppColors.green,
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                  isDarkMode: isDarkMode,
                  semanticsLabel: 'Transaction Summary Card',
                ),
              ),
              SizedBox(height: 16.h),
              FadeTransition(
                opacity: _instructionsFadeAnimation,
                child: _buildCard(
                  title: 'Payment Instructions',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (isCrypto)
                        Container(
                          width: 180.w,
                          height: 180.w,
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                          child: QrImageView(
                            data: bitcoinAddress,
                            version: QrVersions.auto,
                            size: 180.w,
                            backgroundColor: AppColors.white,
                            foregroundColor: isDarkMode ? AppColors.darkBackground : Colors.black,
                          ),

                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            accountDetails,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Courier',
                              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                isCrypto ? bitcoinAddress : accountDetails,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'Courier',
                                  letterSpacing: 0.5,
                                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: isCrypto ? bitcoinAddress : accountDetails));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isCrypto ? 'Address copied to clipboard' : 'Account details copied to clipboard',
                                      style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                                    ),
                                    backgroundColor: AppColors.green,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.copy,
                                color: AppColors.green,
                                size: 20.w,
                                semanticLabel: isCrypto ? 'Copy Bitcoin Address' : 'Copy Account Details',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        instructions,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                        semanticsLabel: 'Payment Instructions',
                      ),
                    ],
                  ),
                  isDarkMode: isDarkMode,
                  semanticsLabel: 'Payment Instructions Card',
                ),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deposit of \$${widget.amount.toStringAsFixed(2)} via ${widget.paymentMethod} confirmed',
                        style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                      ),
                      backgroundColor: AppColors.green,
                    ),
                  );
                  // Pop to ProfileScreen or MainScreen
                  Navigator.popUntil(context, (route) => route.settings.name == 'ProfileScreen' || route.isFirst);
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
                      'Confirm Deposit',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                      semanticsLabel: 'Confirm Deposit',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deposit cancelled',
                        style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                      ),
                      backgroundColor: AppColors.red,
                    ),
                  );
                  Navigator.pop(context); // Pop to DepositFundsScreen
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                      semanticsLabel: 'Cancel Deposit',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    color: AppColors.green,
                    size: 20.w,
                    semanticLabel: 'Awaiting Payment',
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Status: Awaiting Payment',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                    semanticsLabel: 'Status: Awaiting Payment',
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: 0.3,
                  backgroundColor: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
                  color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  minHeight: 4.h,
                  semanticsLabel: 'Payment Progress',
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required Widget content,
    required bool isDarkMode,
    String? semanticsLabel,
  }) {
    return Container(
      width: double.infinity,
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
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
              semanticsLabel: title,
            ),
            SizedBox(height: 16.h),
            content,
          ],
        ),
      ),

    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    Widget? valueIcon,
    Color? valueColor,
    required bool isDarkMode,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
        ),
        Row(
          children: [
            if (valueIcon != null) ...[
              valueIcon,
              SizedBox(width: 4.w),
            ],
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: valueColor ?? (isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
              ),
            ),
          ],
        ),
      ],

    );
  }
}