import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../constant/app_color.dart';
import '../../../providers/theme_provider.dart';
import '../../../service/wallet_service.dart';
import '../../../widget/common/common_app_bar.dart';

class BankDepositScreen extends StatefulWidget {
  const BankDepositScreen({super.key});

  @override
  State<BankDepositScreen> createState() => _DepositFundsScreenState();
}

class _DepositFundsScreenState extends State<BankDepositScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController(text: '0.00');
  final TextEditingController _transactionReferenceController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final WalletService _walletService = WalletService();
  File? _selectedImage;
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _transactionReferenceController.dispose();
    _remarkController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _showSnackBar('Image selected successfully', AppColors.green, Provider.of<ThemeProvider>(context, listen: false).isDarkMode);
    }
  }

  Future<void> _handleDeposit() async {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText) ?? 0.0;
    final transactionReference = _transactionReferenceController.text.trim();
    final remark = _remarkController.text.trim();

    if (amount <= 0) {
      _showSnackBar('Please enter a valid amount', AppColors.red, isDarkMode);
      return;
    }

    if (amount > 100000) {
      _showSnackBar('Amount exceeds maximum limit of \$100,000', AppColors.red, isDarkMode);
      return;
    }

    if (transactionReference.isEmpty) {
      _showSnackBar('Please enter a transaction reference', AppColors.red, isDarkMode);
      return;
    }

    if (remark.isEmpty) {
      _showSnackBar('Please enter a remark', AppColors.red, isDarkMode);
      return;
    }

    if (_selectedImage == null) {
      _showSnackBar('Please select an image', AppColors.red, isDarkMode);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _walletService.submitDepositRequest(
        amount: amount,
        transactionReference: transactionReference,
        remark: remark,
        image: _selectedImage,
      );
      if (response['status'] == true) {
        setState(() {
          _isLoading = false;
        });
        _showConfirmationDialog(amount, transactionReference, remark, response['data']);
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = response['message'] ?? 'Failed to submit deposit request';
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

  void _showConfirmationDialog(double amount, String transactionReference, String remark, Map<String, dynamic> data) {
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
                'Deposit Submitted',
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
                'Transaction Reference: $transactionReference',
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
                'Status: ${data['status'] ?? 'PENDING'}',
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
                  _transactionReferenceController.clear();
                  _remarkController.clear();
                  _selectedImage = null;
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
        title: 'Bank Deposit',
        showBackButton: true,
        onBackPressed: () {
          Navigator.pop(context);
          _showSnackBar('Returning to Profile', AppColors.green, isDarkMode);
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
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
                      'Transaction Reference',
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
                        controller: _transactionReferenceController,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter transaction reference (e.g., sdfsdfg122)',
                          hintStyle: TextStyle(
                            fontSize: 16.sp,
                            color: isDarkMode ? AppColors.darkSecondaryText.withOpacity(0.5) : AppColors.lightSecondaryText.withOpacity(0.5),
                          ),
                        ),
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
                          hintText: 'Enter remark (e.g., Deposit for investment)',
                          hintStyle: TextStyle(
                            fontSize: 16.sp,
                            color: isDarkMode ? AppColors.darkSecondaryText.withOpacity(0.5) : AppColors.lightSecondaryText.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Upload Proof of Payment',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
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
                            Icon(
                              _selectedImage == null ? Icons.upload_file : Icons.image,
                              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                _selectedImage == null ? 'Select an image' : 'Image selected: ${_selectedImage!.path.split('/').last}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                                ),
                              ),
                            ),
                            if (_selectedImage != null)
                              IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: AppColors.red,
                                  size: 20.sp,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedImage = null;
                                  });
                                  _showSnackBar('Image removed', AppColors.green, isDarkMode);
                                },
                              ),
                          ],
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
                    SizedBox(height: 32.h),
                    GestureDetector(
                      onTap: _isLoading ? null : _handleDeposit,
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
                            'Submit Deposit',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                            ),
                            semanticsLabel: 'Submit Deposit',
                          ),
                        ),
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