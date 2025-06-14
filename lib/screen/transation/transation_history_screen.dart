import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constant/app_color.dart';
import '../../../providers/theme_provider.dart';
import '../../../widget/common/common_app_bar.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> with SingleTickerProviderStateMixin {
  String selectedPeriod = "Last 7 Days";
  final List<String> periods = ["Today", "Last 7 Days", "Last 30 Days", "All Time"];

  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;

  // Sample transaction data
  final List<Map<String, dynamic>> transactions = [
    {
      "period": "Today",
      "items": [
        {
          "type": "Deposit",
          "method": "via Bank Transfer",
          "amount": "+\$2,500.00",
          "status": "Done",
          "isCredit": true,
        },
        {
          "type": "Withdrawal",
          "method": "via UPI",
          "amount": "-\$800.00",
          "status": "Done",
          "isCredit": false,
        },
      ]
    },
    {
      "period": "Yesterday",
      "items": [
        {
          "type": "Deposit",
          "method": "via Crypto",
          "amount": "+\$5,000.00",
          "status": "Done",
          "isCredit": true,
        },
      ]
    },
    {
      "period": "Earlier This Week",
      "items": [
        {
          "type": "Withdrawal",
          "method": "via Bank Transfer",
          "amount": "-\$1,200.00",
          "status": "Done",
          "isCredit": false,
        },
        {
          "type": "Deposit",
          "method": "via UPI",
          "amount": "+\$3,000.00",
          "status": "Done",
          "isCredit": true,
        },
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimations = List.generate(
      transactions.length * 2,
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'Transaction History',
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              _buildFilterRow(isDarkMode),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final periodData = transactions[index];
                    final String period = periodData["period"];
                    final List<Map<String, dynamic>> items = periodData["items"];

                    return FadeTransition(
                      opacity: _fadeAnimations[index],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index > 0)
                            Divider(
                              color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                              thickness: 1,
                              height: 24.h,
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Text(
                              period,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                              semanticsLabel: '$period Transactions',
                            ),
                          ),
                          ...items.asMap().entries.map((entry) {
                            final transaction = entry.value;
                            return FadeTransition(
                              opacity: _fadeAnimations[index + entry.key + 1],
                              child: _buildTransactionCard(transaction, isDarkMode),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: DropdownButton<String>(
            value: selectedPeriod,
            items: periods.map((String period) {
              return DropdownMenuItem<String>(
                value: period,
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedPeriod = newValue;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Period changed to $newValue',
                      style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                    ),
                    backgroundColor: AppColors.green,
                  ),
                );
              }
            },
            underline: const SizedBox(),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              size: 20.sp,
            ),
            dropdownColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(12.r),
            isDense: true,
            style: TextStyle(
              fontSize: 16.sp,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),

          ),
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Opening Filters',
                  style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                ),
                backgroundColor: AppColors.green,
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  size: 20.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                  semanticsLabel: 'Filter Transactions',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        _showTransactionDetailsDialog(transaction, isDarkMode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12.h),
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
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: transaction["isCredit"]
                      ? AppColors.green.withOpacity(0.2)
                      : AppColors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Icon(
                  transaction["isCredit"] ? Icons.arrow_downward : Icons.arrow_upward,
                  color: transaction["isCredit"] ? AppColors.green : AppColors.red,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction["type"],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      transaction["method"],
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction["amount"],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    transaction["status"],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
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

  void _showTransactionDetailsDialog(Map<String, dynamic> transaction, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          title: Text(
            '${transaction["type"]} Details',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amount: ${transaction["amount"]}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Method: ${transaction["method"]}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Status: ${transaction["status"]}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  fontSize: 14.sp,
                ),
                semanticsLabel: 'Close Dialog',
              ),
            ),
          ],
        );
      },
    );
  }
}