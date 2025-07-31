import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../service/apiservice/meta_trade_service.dart';
import '../../widget/common/common_app_bar.dart';

class MetaDepositScreen extends StatefulWidget {
  final String mt5Login;
  final double availableBalance;

  const MetaDepositScreen({
    super.key,
    required this.mt5Login,
    required this.availableBalance,
  });

  @override
  State<MetaDepositScreen> createState() => _MetaDepositScreenState();
}

class _MetaDepositScreenState extends State<MetaDepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  int _selectedType = 2; // Default to type 2 as per cURL
  bool _isLoading = false;
  final MetaTradeService _metaTradeService = MetaTradeService();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submitDeposit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final result = await _metaTradeService.depositMT5Account(
      mt5Login: widget.mt5Login,
      type: _selectedType,
      amount: amount,
    );

    setState(() => _isLoading = false);

    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] ? 'Deposit successful' : result['message'] ?? 'Deposit failed',
          style: TextStyle(
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ),
        backgroundColor: result['success'] ? AppColors.green : AppColors.red,
      ),
    );

    if (result['success']) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'Deposit to MT5 Account',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deposit Details',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  label: 'MT5 Login',
                  value: widget.mt5Login,
                  isDarkMode: isDarkMode,
                  enabled: false,
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  label: 'Current Balance',
                  value: '\$${widget.availableBalance.toStringAsFixed(2)}',
                  isDarkMode: isDarkMode,
                  enabled: false,
                ),
                SizedBox(height: 16.h),
                _buildTypeDropdown(isDarkMode),
                SizedBox(height: 16.h),
                _buildTextField(
                  label: 'Amount',
                  controller: _amountController,
                  isDarkMode: isDarkMode,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                _buildSubmitButton(isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? value,
    TextEditingController? controller,
    bool isDarkMode = false,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: value,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        fontSize: 16.sp,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
    );
  }

  Widget _buildTypeDropdown(bool isDarkMode) {
    return DropdownButtonFormField<int>(
      value: _selectedType,
      decoration: InputDecoration(
        labelText: 'Transaction Type',
        labelStyle: TextStyle(
          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            width: 2,
          ),
        ),
      ),
      items: [
        DropdownMenuItem(value: 2, child: Text('Type 2')),
        DropdownMenuItem(value: 1, child: Text('Type 1')),
        // Add more types if needed based on API documentation
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedType = value);
        }
      },
      style: TextStyle(
        color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        fontSize: 16.sp,
      ),
    );
  }

  Widget _buildSubmitButton(bool isDarkMode) {
    return GestureDetector(
      onTap: _isLoading ? null : _submitDeposit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: _isLoading
              ? (isDarkMode ? AppColors.darkBorder : AppColors.lightBorder)
              : (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent),
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: _isLoading
            ? CircularProgressIndicator(
          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        )
            : Text(
          'Deposit',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}