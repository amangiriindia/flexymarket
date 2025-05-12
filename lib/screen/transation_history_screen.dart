import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String selectedPeriod = "Last 7 Days";

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),

              // Header with back button
              Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
                  SizedBox(width: 12.w),
                  Text(
                    "Transaction History",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Filter row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Period selector
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedPeriod,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),

                  // Filter button
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list,
                          color: Color(0xFF00E676),
                          size: 20.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "Filter",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Transaction list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final periodData = transactions[index];
                    final String period = periodData["period"];
                    final List<Map<String, dynamic>> items = periodData["items"];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Period header
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Text(
                            period,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Transactions for this period
                        ...items.map((transaction) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            decoration: BoxDecoration(
                              color: Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.r),
                              child: Row(
                                children: [
                                  // Transaction icon (up or down arrow)
                                  Container(
                                    width: 36.w,
                                    height: 36.h,
                                    decoration: BoxDecoration(
                                      color: transaction["isCredit"]
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(18.r),
                                    ),
                                    child: Icon(
                                      transaction["isCredit"]
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color: transaction["isCredit"]
                                          ? Colors.green
                                          : Colors.red,
                                      size: 20.sp,
                                    ),
                                  ),

                                  SizedBox(width: 12.w),

                                  // Transaction details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          transaction["type"],
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          transaction["method"],
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Amount and status
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        transaction["amount"],
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: transaction["isCredit"]
                                              ? Colors.white
                                              : Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        transaction["status"],
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Color(0xFF00E676),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}