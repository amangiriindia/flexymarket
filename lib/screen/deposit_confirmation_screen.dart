import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DepositConfirmationScreen extends StatelessWidget {
  const DepositConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Bitcoin address for QR code and text display
    const String bitcoinAddress = "bc1qxy2kgdygjrsgtzq2n0yrf2493p83kkfjhx0wlh";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Deposit Confirmation',
          style: TextStyle(color: Colors.white), // Already defined
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Added white color
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Color(0xFF00685a),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.check,
                color:Color(0xFF00685a),
                size: 18.w,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction Summary Card
              _buildCard(
                title: 'Transaction Summary',
                content: Column(
                  children: [
                    _buildSummaryRow(
                      label: 'Amount',
                      value: '100.00 USD',
                    ),
                    SizedBox(height: 16.h),
                    _buildSummaryRow(
                      label: 'Payment Method',
                      value: 'Crypto - BTC',
                      valueIcon: Icon(
                        Icons.currency_bitcoin,
                        color: Color(0xFF00685a),
                        size: 18.w,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildSummaryRow(
                      label: 'Processing Time',
                      value: '2 confirmations',
                    ),
                    SizedBox(height: 16.h),
                    _buildSummaryRow(
                      label: 'Fees',
                      value: '0%',
                      valueColor: Color(0xFF00685a), // Already defined
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Payment Instructions Card
              _buildCard(
                title: 'Payment Instructions',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // QR Code
                    Container(
                      width: 180.w,
                      height: 180.w,
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: QrImageView(
                        data: bitcoinAddress,
                        version: QrVersions.auto,
                        size: 180.w,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        embeddedImage: const AssetImage('assets/bitcoin_logo.png'),
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: Size(40.w, 40.w),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Bitcoin Address Container
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              bitcoinAddress,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'Courier',
                                letterSpacing: 0.5,
                                color: Colors.white, // Added white color
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                const ClipboardData(text: bitcoinAddress),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Address copied to clipboard',
                                    style: TextStyle(color: Colors.white), // Added white color
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.copy,
                              color: Color(0xFF00685a),
                              size: 20.w,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Instructions Text
                    Text(
                      'Send exactly 0.00324 BTC to the address above. Transaction will be credited after 2 network confirmations.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade400, // Already defined
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Confirm Deposit Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    // Confirm deposit action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00685a),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Confirm Deposit',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Already defined
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // Already defined
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Status Bar
              Row(
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    color: Color(0xFF00E676),
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Status: Awaiting Payment',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade400, // Already defined
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // Progress Indicator
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: 0.3,
                  backgroundColor: Colors.grey.shade800,
                  color: Color(0xFF00685a),
                  minHeight: 4.h,
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12.r),
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
                fontWeight: FontWeight.bold,
                color: Colors.white, // Added white color
              ),
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
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade400, // Already defined
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
                color: valueColor ?? Colors.white, // Default to white if valueColor is null
              ),
            ),
          ],
        ),
      ],
    );
  }
}