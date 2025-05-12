import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'deposit_confirmation_screen.dart';

class DepositFundsScreen extends StatefulWidget {
  const DepositFundsScreen({Key? key}) : super(key: key);

  @override
  State<DepositFundsScreen> createState() => _DepositFundsScreenState();
}

class _DepositFundsScreenState extends State<DepositFundsScreen> {
  final TextEditingController _amountController = TextEditingController(text: '0.00');
  int _selectedPaymentMethod = 0;

  final List<PaymentMethodModel> _paymentMethods = [
    PaymentMethodModel(
      name: 'Bank Transfer',
      icon: Icons.account_balance,
      iconColor: Colors.green,
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
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Deposit Funds',
          style: TextStyle(color: Colors.white), // Already defined
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Added white color
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // Amount input section
            Text(
              'Enter Amount',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[400], // Already defined
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white, // Added white color
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
              ),
            ),
            SizedBox(height: 24.h),

            // Payment methods section
            Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white, // Added white color
              ),
            ),
            SizedBox(height: 12.h),

            // Payment method options
            Expanded(
              child: ListView.builder(
                itemCount: _paymentMethods.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final method = _paymentMethods[index];
                  return _buildPaymentMethodItem(method, index);
                },
              ),
            ),

            // Continue button
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  // Handle deposit

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DepositConfirmationScreen(),
                    ),
                  );

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00E676),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Already defined
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodItem(PaymentMethodModel method, int index) {
    final isSelected = _selectedPaymentMethod == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8.r),
          border: isSelected
              ? Border.all(color: Color(0xFF00E676), width: 1)
              : null,
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
                            color: Colors.white, // Added white color
                          ),
                        ),
                        SizedBox(width: 8.w),
                        if (method.isRecommended)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF00E676),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'Recommended',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Already defined
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 24.w,
                    color: Colors.grey, // Preserved as grey
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  SizedBox(width: 48.w),
                  // Processing time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.w,
                        color: Colors.grey, // Preserved as grey
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        method.processingTime,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey, // Preserved as grey
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  // Fee
                  Row(
                    children: [
                      Icon(
                        Icons.money_off,
                        size: 14.w,
                        color: Colors.grey, // Preserved as grey
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        method.fee + ' fee',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey, // Preserved as grey
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  // Limit
                  Row(
                    children: [
                      method.limitIcon != null
                          ? Icon(
                        method.limitIcon,
                        size: 14.w,
                        color: Colors.grey, // Preserved as grey
                      )
                          : Icon(
                        Icons.arrow_upward,
                        size: 14.w,
                        color: Colors.grey, // Preserved as grey
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        method.limit,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey, // Preserved as grey
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