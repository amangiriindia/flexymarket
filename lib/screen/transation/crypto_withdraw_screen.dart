import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../service/apiservice/wallet_service.dart';
import '../../widget/common/common_app_bar.dart';

class CryptoWithdrawScreen extends StatefulWidget {
  final double mainBalance;

  const CryptoWithdrawScreen({
    super.key,
    required this.mainBalance,
  });

  @override
  State<CryptoWithdrawScreen> createState() => _CryptoWithdrawScreenState();
}

class _CryptoWithdrawScreenState extends State<CryptoWithdrawScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController(text: '0.00');
  final _walletAddressController = TextEditingController();
  final _passwordController = TextEditingController();
  final WalletService _walletService = WalletService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _amountController.dispose();
    _walletAddressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleCryptoWithdrawal() async {
    if (!_formKey.currentState!.validate()) return;

    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;
    final walletAddress = _walletAddressController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _walletService.cryptoWithdraw(
        amount: amount,
        walletAddress: walletAddress,
        password: password,
      );

      setState(() => _isLoading = false);

      if (response['status'] == true) {
        _showConfirmationDialog(amount, walletAddress, response['data'] ?? {});
        _showSnackBar(response['message'] ?? 'Withdrawal submitted successfully', AppColors.green, isDarkMode);
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Failed to submit withdrawal';
        });
        _showSnackBar(_errorMessage!, AppColors.red, isDarkMode);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
      _showSnackBar(_errorMessage!, AppColors.red, isDarkMode);
    }
  }

  void _showSnackBar(String message, Color backgroundColor, bool isDarkMode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            fontSize: 14.sp,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  void _showConfirmationDialog(double amount, String walletAddress, Map<String, dynamic> data) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Row(
            children: [
              Icon(
                Icons.currency_bitcoin,
                color: AppColors.green,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Crypto Withdrawal Submitted',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amount: \$${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Wallet Address: ${walletAddress.length > 20 ? '${walletAddress.substring(0, 10)}...${walletAddress.substring(walletAddress.length - 10)}' : walletAddress}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Status: ${data['status'] ?? 'PENDING'}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              if (data['remark'] != null) ...[
                SizedBox(height: 8.h),
                Text(
                  'Remark: ${data['remark']}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to previous screen
                setState(() {
                  _amountController.text = '0.00';
                  _walletAddressController.clear();
                  _passwordController.clear();
                });
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  fontWeight: FontWeight.w600,
                ),
                semanticsLabel: 'Close Confirmation Dialog',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'Crypto Withdrawal',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Balance',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '\$${widget.mainBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                      semanticsLabel: 'Available Balance \$${widget.mainBalance.toStringAsFixed(2)}',
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Enter Amount',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
                        boxShadow: isDarkMode
                            ? null
                            : [
                          BoxShadow(
                            color: AppColors.lightShadow,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            '\$',
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: TextFormField(
                              controller: _amountController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                              ],
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter amount',
                                hintStyle: TextStyle(
                                  fontSize: 20.sp,
                                  color: isDarkMode ? AppColors.darkSecondaryText.withOpacity(0.5) : AppColors.lightSecondaryText.withOpacity(0.5),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an amount';
                                }
                                final amount = double.tryParse(value.replaceAll(',', '')) ?? 0.0;
                                if (amount <= 0) {
                                  return 'Please enter a valid amount';
                                }
                                if (amount > widget.mainBalance) {
                                  return 'Amount exceeds available balance';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Wallet Address',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
                        boxShadow: isDarkMode
                            ? null
                            : [
                          BoxShadow(
                            color: AppColors.lightShadow,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _walletAddressController,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter wallet address (e.g., 0x...)',
                          hintStyle: TextStyle(
                            fontSize: 16.sp,
                            color: isDarkMode ? AppColors.darkSecondaryText.withOpacity(0.5) : AppColors.lightSecondaryText.withOpacity(0.5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a wallet address';
                          }
                          if (!RegExp(r'^0x[a-fA-F0-9]{40}$').hasMatch(value)) {
                            return 'Please enter a valid Ethereum address';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
                        boxShadow: isDarkMode
                            ? null
                            : [
                          BoxShadow(
                            color: AppColors.lightShadow,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            fontSize: 16.sp,
                            color: isDarkMode ? AppColors.darkSecondaryText.withOpacity(0.5) : AppColors.lightSecondaryText.withOpacity(0.5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 32.h),
                    GestureDetector(
                      onTap: _isLoading ? null : _handleCryptoWithdrawal,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: _isLoading
                              ? (isDarkMode ? AppColors.darkAccent.withOpacity(0.5) : AppColors.lightAccent.withOpacity(0.5))
                              : (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: isDarkMode
                              ? null
                              : [
                            BoxShadow(
                              color: AppColors.lightShadow,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? SizedBox(
                            width: 24.sp,
                            height: 24.sp,
                            child: CircularProgressIndicator(
                              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            'Submit Withdrawal',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                            semanticsLabel: 'Submit Withdrawal',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock,
                            size: 16.sp,
                            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'All transactions are secure and encrypted',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                            ),
                            semanticsLabel: 'All transactions are secure and encrypted',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: isDarkMode ? AppColors.darkBackground.withOpacity(0.7) : AppColors.lightBackground.withOpacity(0.7),
                child: Center(
                  child: CircularProgressIndicator(
                    color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                    strokeWidth: 3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}