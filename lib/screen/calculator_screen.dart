import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812), // Design size based on iPhone X
//       minTextAdaptation: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Risk Calculator',
//           theme: ThemeData(
//             brightness: Brightness.dark,
//             scaffoldBackgroundColor: Colors.black,
//             primaryColor: Colors.green,
//             inputDecorationTheme: InputDecorationTheme(
//               filled: true,
//               fillColor: Colors.grey[900],
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.r),
//                 borderSide: BorderSide.none,
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.r),
//                 borderSide: BorderSide.none,
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.r),
//                 borderSide: BorderSide(color: Colors.green, width: 2),
//               ),
//             ),
//             textTheme: TextTheme(
//               bodyMedium: TextStyle(color: Colors.white, fontSize: 16.sp),
//             ),
//           ),
//           home: const RiskCalculatorScreen(),
//         );
//       },
//     );
//   }
// }

class RiskCalculatorScreen extends StatefulWidget {
  const RiskCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<RiskCalculatorScreen> createState() => _RiskCalculatorScreenState();
}

class _RiskCalculatorScreenState extends State<RiskCalculatorScreen> {
  // Controllers for text input
  final TextEditingController _accountBalanceController = TextEditingController(text: "10,000.00");
  final TextEditingController _riskPercentageController = TextEditingController(text: "1.00");
  final TextEditingController _stopLossPipsController = TextEditingController(text: "50");

  // Calculated values
  double _positionSize = 2.5;
  double _potentialLoss = 100.00;
  String _riskLevel = "Low Risk";

  void _calculateRisk() {
    // Parse input values
    double accountBalance = double.tryParse(_accountBalanceController.text.replaceAll(',', '')) ?? 0;
    double riskPercentage = double.tryParse(_riskPercentageController.text) ?? 0;
    int stopLossPips = int.tryParse(_stopLossPipsController.text) ?? 0;

    // Validate inputs
    if (accountBalance <= 0 || riskPercentage <= 0 || stopLossPips <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid positive numbers")),
      );
      return;
    }

    // Calculate risk
    double riskAmount = accountBalance * (riskPercentage / 100);

    // Calculate position size (simplified calculation)
    // Assuming 1 lot = $10 per pip for this example
    double positionSize = riskAmount / (stopLossPips * 10);

    setState(() {
      _positionSize = double.parse(positionSize.toStringAsFixed(2));
      _potentialLoss = double.parse(riskAmount.toStringAsFixed(2));

      // Determine risk level
      if (riskPercentage <= 1) {
        _riskLevel = "Low Risk";
      } else if (riskPercentage <= 2) {
        _riskLevel = "Medium Risk";
      } else {
        _riskLevel = "High Risk";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                SizedBox(height: 24.h),

                // Account Balance Input
                _buildInputField(
                  controller: _accountBalanceController,
                  label: "Account Balance",
                  prefixIcon: Icons.account_balance_wallet,
                  inputType: TextInputType.number,
                  prefixText: "\$ ",
                ),
                SizedBox(height: 16.h),

                // Risk and Stop Loss Inputs
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        controller: _riskPercentageController,
                        label: "Risk Percentage",
                        suffixText: "%",
                        inputType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildInputField(
                        controller: _stopLossPipsController,
                        label: "Stop Loss (Pips)",
                        inputType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Calculation Results
                _buildResultRow("Position Size", "${_positionSize} Lots"),
                SizedBox(height: 16.h),
                _buildResultRow("Potential Loss", "\$$_potentialLoss"),
                SizedBox(height: 24.h),

                // Calculate Button
                _buildCalculateButton(),
                SizedBox(height: 24.h),

                // Risk Level Indicator
                _buildRiskLevelIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, size: 24.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Text(
          "Risk Calculator",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        IconButton(
          icon: Icon(Icons.help_outline, size: 24.sp,color: Colors.white),
          onPressed: () {
            // Show help dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Risk Calculator Help"),
                content: Text(
                  "Calculate your trading risk by entering your account balance, "
                      "risk percentage, and stop loss in pips.",
                  style: TextStyle(fontSize: 14.sp),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Close"),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    TextInputType inputType = TextInputType.number,
    IconData? prefixIcon,
    String? prefixText,
    String? suffixText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.sp,
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.green) : null,
        prefixText: prefixText,
        suffixText: suffixText,
        prefixStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        suffixStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: _calculateRisk,
        child: Text(
          "Calculate",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRiskLevelIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Risk Level",
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Expanded(
                flex: _riskLevel == "Low Risk" ? 2 :
                _riskLevel == "Medium Risk" ? 4 : 6,
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: _riskLevel == "Low Risk" ? Colors.green :
                    _riskLevel == "Medium Risk" ? Colors.orange : Colors.red,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              Expanded(
                flex: 6 - (
                    _riskLevel == "Low Risk" ? 2 :
                    _riskLevel == "Medium Risk" ? 4 : 6
                ),
                child: Container(
                  height: 8.h,
                  color: Colors.grey[800],
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
            color: _riskLevel == "Low Risk" ? Colors.green :
            _riskLevel == "Medium Risk" ? Colors.orange : Colors.red,
          ),
        ),
      ],
    );
  }
}