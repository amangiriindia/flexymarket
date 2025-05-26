import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransferMoneyScreen extends StatefulWidget {
  const TransferMoneyScreen({Key? key}) : super(key: key);

  @override
  State<TransferMoneyScreen> createState() => _TransferMoneyScreenState();
}

class _TransferMoneyScreenState extends State<TransferMoneyScreen> {
  final TextEditingController _amountController = TextEditingController(text: "0.00");
  String selectedTransferMethod = "";
  String selectedAccount = "Trading Account (USD)";

  // List of accounts for dropdown
  final List<String> accounts = [
    "Trading Account (USD)",
    "Savings Account (USD)",
    "Crypto Wallet (BTC)",
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),

                // Header with back button
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Transfer Money",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Already white
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Available Balance
                Text(
                  "Available Balance",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[400], // Preserved
                  ),
                ),

                SizedBox(height: 8.h),

                // Balance Amount
                Text(
                  "\$12,450.00",
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Already white
                  ),
                ),

                SizedBox(height: 24.h),

                // Select Transfer Method
                Text(
                  "Select Transfer Method",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Already white
                  ),
                ),

                SizedBox(height: 16.h),

                // Between Accounts Option
                TransferMethodTile(
                  icon: Icon(Icons.sync, color: Color(0xFF00685a), size: 24.sp),
                  title: "Between Accounts",
                  subtitle: "Instant • 0% Fee",
                  isSelected: selectedTransferMethod == "Between Accounts",
                  onTap: () {
                    setState(() {
                      selectedTransferMethod = "Between Accounts";
                    });
                  },
                ),

                SizedBox(height: 12.h),

                // To Another User Option
                TransferMethodTile(
                  icon: Icon(Icons.person, color: Color(0xFF00685a), size: 24.sp),
                  title: "To Another User",
                  subtitle: "Instant • 0% Fee",
                  isSelected: selectedTransferMethod == "To Another User",
                  onTap: () {
                    setState(() {
                      selectedTransferMethod = "To Another User";
                    });
                  },
                ),

                SizedBox(height: 24.h),

                // Enter Amount
                Text(
                  "Enter Amount",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[400], // Preserved
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
                          color: Colors.white, // Already white
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white, // Already white
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Select Account
                Text(
                  "Select Account",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[400], // Preserved
                  ),
                ),

                SizedBox(height: 8.h),

                // Account Dropdown
                GestureDetector(
                  onTap: () {
                    _showAccountDropdown(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedAccount,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white, // Already white
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white, // Already white
                          size: 24.sp,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Transfer Limits
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Color(0xFF00685a),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.black,
                          size: 18.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          "Transfer Limits",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white, // Already white
                          ),
                        ),
                      ),
                      Text(
                        "\$0.01 - \$50,000",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white, // Already white
                        ),
                      ),
                    ],
                  ),
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
                        color: Colors.grey[400], // Preserved
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "All transfers are encrypted and secure",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[400], // Preserved
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Continue Button
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 24.h),
                  child: ElevatedButton(
                    onPressed: () {
                      _handleContinue();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00685a),
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
                        color: Colors.black, // Added black color
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAccountDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: accounts.map((account) {
              return ListTile(
                title: Text(
                  account,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedAccount = account;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _handleContinue() {
    final amountText = _amountController.text;
    final amount = double.tryParse(amountText);

    if (selectedTransferMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please select a transfer method",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter a valid amount",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (amount < 0.01 || amount > 50000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Amount must be between \$0.01 and \$50,000",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simulate transfer action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Transfer of \$${amount.toStringAsFixed(2)} to $selectedAccount via $selectedTransferMethod initiated",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:Color(0xFF00685a),
      ),
    );
  }
}

class TransferMethodTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const TransferMethodTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
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
          border: isSelected
              ? Border.all(color: Color(0xFF00685a), width: 1.5)
              : null,
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
                      color: Colors.white, // Already white
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[400], // Preserved
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.chevron_right,
              color: isSelected ? Color(0xFF00685a) : Colors.grey[400],
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}