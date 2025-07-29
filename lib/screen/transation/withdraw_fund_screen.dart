import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../constant/app_color.dart';
import '../../../providers/theme_provider.dart';
import '../../service/apiservice/wallet_service.dart';
import '../../../widget/common/common_app_bar.dart';

class WithdrawFundsScreen extends StatefulWidget {
  final double mainBalance;

  const WithdrawFundsScreen({super.key, required this.mainBalance});

  @override
  State<WithdrawFundsScreen> createState() => _WithdrawFundsScreenState();
}

class _WithdrawFundsScreenState extends State<WithdrawFundsScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController(text: '0.00');
  final TextEditingController _remarkController = TextEditingController();
  final WalletService _walletService = WalletService();
  String selectedMethod = '';
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;

  final List<Map<String, dynamic>> withdrawalMethods = [
    {
      'title': 'Bank Transfer',
      'subtitle': '1-3 business days • Free',
      'icon': Icons.account_balance,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimations = List.generate(
      withdrawalMethods.length,
          (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
        ),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _remarkController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleWithdrawal() async {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText) ?? 0.0;
    final remark = _remarkController.text.trim();

    if (amount <= 0) {
      _showSnackBar('Please enter a valid amount', AppColors.red, isDarkMode);
      return;
    }

    if (amount > widget.mainBalance) {
      _showSnackBar('Amount exceeds available balance', AppColors.red, isDarkMode);
      return;
    }

    if (selectedMethod.isEmpty) {
      _showSnackBar('Please select a withdrawal method', AppColors.red, isDarkMode);
      return;
    }

    if (remark.isEmpty) {
      _showSnackBar('Please enter a remark', AppColors.red, isDarkMode);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _walletService.submitWithdrawalRequest(amount, remark);
      if (response['status'] == true) {
        setState(() {
          _isLoading = false;
        });
        _showConfirmationDialog(amount, remark, response['data']);
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = response['message'] ?? 'Failed to submit withdrawal request';
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

  void _showConfirmationDialog(double amount, String remark, Map<String, dynamic> data) {
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
                FontAwesomeIcons.checkCircle,
                color: AppColors.green,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Withdrawal Submitted',
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
                'Method: $selectedMethod',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Remark: $remark',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Status: ${data['status']}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              if (data['transactionReference'] != null) ...[
                SizedBox(height: 8.h),
                Text(
                  'Reference: ${data['transactionReference']}',
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
                setState(() {
                  _amountController.text = '0.00';
                  _remarkController.clear();
                  selectedMethod = '';
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
        title: 'Withdraw Funds',
        showBackButton: true,
        onBackPressed: () {
          Navigator.pop(context);
          _showSnackBar('Returning to Wallet', AppColors.green, isDarkMode);
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
                          child: TextField(
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Remark',
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
                    child: TextField(
                      controller: _remarkController,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter remark (e.g., Withdrawal for savings)',
                        hintStyle: TextStyle(
                          fontSize: 16.sp,
                          color: isDarkMode ? AppColors.darkSecondaryText.withOpacity(0.5) : AppColors.lightSecondaryText.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Select Withdrawal Method',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ...withdrawalMethods.asMap().entries.map((entry) {
                    final index = entry.key;
                    final method = entry.value;
                    return FadeTransition(
                      opacity: _fadeAnimations[index],
                      child: WithdrawalMethodTile(
                        icon: Icon(
                          method['icon'],
                          color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                          size: 24.sp,
                        ),
                        title: method['title'],
                        subtitle: method['subtitle'],
                        isSelected: selectedMethod == method['title'],
                        onTap: () {
                          setState(() {
                            selectedMethod = method['title'];
                          });
                          _showSnackBar('${method['title']} selected', AppColors.green, isDarkMode);
                        },
                      ),
                    );
                  }).toList(),
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
                  SizedBox(height: 32.h),
                  GestureDetector(
                    onTap: _isLoading ? null : _handleWithdrawal,
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
                ],
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

class WithdrawalMethodTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const WithdrawalMethodTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected
              ? Border.all(color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent, width: 2)
              : Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
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
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.chevron_right,
              color: isSelected
                  ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                  : (isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}