import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class WithdrawFundsScreen extends StatefulWidget {
  const WithdrawFundsScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawFundsScreen> createState() => _WithdrawFundsScreenState();
}

class _WithdrawFundsScreenState extends State<WithdrawFundsScreen> {
  final TextEditingController _amountController = TextEditingController(text: "0.00");
  String selectedMethod = "";

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

              // Top navigation
              Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
                  SizedBox(width: 12.w),
                  Text(
                    "Withdraw Funds",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              // Available Balance
              Text(
                "Available Balance",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[400],
                ),
              ),

              SizedBox(height: 8.h),

              // Balance Amount
              Text(
                "\$12,450.00",
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 24.h),

              // Enter Amount
              Text(
                "Enter Amount",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[400],
                ),
              ),

              SizedBox(height: 8.h),

              // Amount input field
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Text(
                      "\$",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        style: TextStyle(
                          fontSize: 20.sp,
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

              SizedBox(height: 24.h),

              // Select Withdrawal Method
              Text(
                "Select Withdrawal Method",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 16.h),

              // Bank Transfer Option
              WithdrawalMethodTile(
                icon: Icon(Icons.account_balance, color: Colors.green, size: 24.sp),
                title: "Bank Transfer",
                subtitle: "1-3 business days • Free",
                onTap: () {
                  setState(() {
                    selectedMethod = "Bank Transfer";
                  });
                },
              ),

              SizedBox(height: 12.h),

              // Crypto Option
              WithdrawalMethodTile(
                icon: Icon(Icons.currency_bitcoin, color: Colors.green, size: 24.sp),
                title: "Crypto",
                subtitle: "Instant • Free",
                onTap: () {
                  setState(() {
                    selectedMethod = "Crypto";
                  });
                },
              ),

              SizedBox(height: 12.h),

              // UPI Option
              WithdrawalMethodTile(
                icon: Icon(Icons.smartphone, color: Colors.green, size: 24.sp),
                title: "UPI",
                subtitle: "Instant • Free",
                onTap: () {
                  setState(() {
                    selectedMethod = "UPI";
                  });
                },
              ),

              SizedBox(height: 16.h),

              // Security note
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      size: 16.sp,
                      color: Colors.grey[400],
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "All transactions are encrypted",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),

              // Continue Button
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 24.h),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00E676),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WithdrawalMethodTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const WithdrawalMethodTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}