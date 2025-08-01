import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constant/app_color.dart';
import '../../constant/user_constant.dart';
import '../../providers/theme_provider.dart';
import '../../service/websocketservice/deposit_websocket_service.dart';
import '../../service/apiservice/meta_trade_service.dart';
import '../../widget/common/common_app_bar.dart';

class CryptoDepositScreen extends StatefulWidget {
  const CryptoDepositScreen({super.key});

  @override
  State<CryptoDepositScreen> createState() => _CryptoDepositScreenState();
}

class _CryptoDepositScreenState extends State<CryptoDepositScreen> {
  String? selectedNetwork;
  String? selectedAccount;
  final TextEditingController _amountController = TextEditingController();
  final MetaTradeService _metaTradeService = MetaTradeService();
  final WebSocketService _webSocketService = WebSocketService();

  List<Map<String, dynamic>> mt5Accounts = [];
  bool isLoadingAccounts = false;
  bool isProcessingPayment = false;
  PaymentData? paymentData;

  // Static networks
  final List<Map<String, String>> networks = [
    {
      'name': 'BINANCE',
      'symbol': 'BINANCE',
      'color': '#F0B90B'
    },
    {
      'name': 'TRON',
      'symbol': 'TRON',
      'color': '#FF060A'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadMT5Accounts();
    _initializeWebSocket();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _webSocketService.disconnect();
    super.dispose();
  }

  Future<void> _loadMT5Accounts() async {
    setState(() {
      isLoadingAccounts = true;
    });

    try {
      final response = await _metaTradeService.getMT5AccountList();
      if (response['success']) {
        setState(() {
          mt5Accounts = List<Map<String, dynamic>>.from(
              response['data']['mt5AccountList'] ?? []);
        });
      } else {
        _showErrorSnackBar(response['message']);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load MT5 accounts: ${e.toString()}');
    } finally {
      setState(() {
        isLoadingAccounts = false;
      });
    }
  }

  void _initializeWebSocket() {
    _webSocketService.onPaymentReady = (data) {
      final receivedData = PaymentData.fromJson(data);
      if (receivedData.orderAmount == _amountController.text &&
          receivedData.paymentInfo.any((info) => info.blockchain.contains(selectedNetwork!))) {
        setState(() {
          isProcessingPayment = false;
          paymentData = receivedData;
        });
        _showPaymentDetailsDialog();
      } else {
        setState(() {
          isProcessingPayment = false;
        });
        _showErrorSnackBar('Received invalid payment data');
      }
    };

    _webSocketService.onPaymentStatus = (data) {
      final status = data['status']?.toString() ?? 'Unknown';
      setState(() {
        isProcessingPayment = false;
      });
      if (status == 'success') {
        _showSuccessSnackBar('Payment completed successfully');
      } else {
        _showErrorSnackBar('Payment status: $status');
      }
    };

    _webSocketService.onError = (error) {
      setState(() {
        isProcessingPayment = false;
      });
      _showErrorSnackBar('WebSocket Error: $error');
    };

    _webSocketService.onDisconnected = () {
      setState(() {
        isProcessingPayment = false;
      });
      _showErrorSnackBar('Connection lost. Please try again.');
    };
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  double get depositAmount {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    return amount;
  }

  Future<void> _connectWebSocketAndStartPayment() async {
    setState(() {
      isProcessingPayment = true;
    });

    try {
      if (!_webSocketService.isConnected) {
        await _webSocketService.connect();
      }
      _webSocketService.startPayment(
        network: selectedNetwork!,
        amount: depositAmount,
      );
    } catch (e) {
      setState(() {
        isProcessingPayment = false;
      });
      _showErrorSnackBar('Failed to process payment: $e');
    }
  }

  void _onConfirm() {
    if (selectedNetwork == null) {
      _showErrorSnackBar('Please select a network');
      return;
    }
    if (selectedAccount == null) {
      _showErrorSnackBar('Please select an account');
      return;
    }
    if (_amountController.text.isEmpty || depositAmount <= 0) {
      _showErrorSnackBar('Please enter a valid amount');
      return;
    }

    final selectedNetworkData = networks.firstWhere(
          (network) => network['symbol'] == selectedNetwork,
    );

    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.green,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Confirm Deposit',
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
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.currency_bitcoin,
                        size: 20.sp,
                        color: Color(int.parse(selectedNetworkData['color']!.replaceFirst('#', '0xff'))),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Network: ${selectedNetworkData['name']}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Account: $selectedAccount',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Amount: ${depositAmount.toStringAsFixed(2)} USD',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: isProcessingPayment
                ? null
                : () {
              Navigator.pop(context);
              _connectWebSocketAndStartPayment();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: isProcessingPayment
                ? SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            )
                : Text(
              'Confirm',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDetailsDialog() {
    if (paymentData == null) return;

    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.payment,
              color: AppColors.green,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Payment Details',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Amount: ${paymentData!.orderAmount} ${paymentData!.orderCurrency}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Order ID: ${paymentData!.cregisId}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Created: ${_formatTimestamp(paymentData!.createdTime)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              if (paymentData!.paymentInfo.isNotEmpty) ...[
                Text(
                  'Payment Information:',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                SizedBox(height: 8.h),
                ...paymentData!.paymentInfo.map((info) => Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.currency_bitcoin,
                            size: 24.sp,
                            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${info.tokenSymbol} (${info.blockchain})',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Amount: ${info.receiveAmount} ${info.receiveCurrency}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Exchange Rate: ${info.exchangeRate}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Payment Address:',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                info.paymentAddress,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontFamily: 'monospace',
                                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.copy, size: 16.sp),
                              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: info.paymentAddress));
                                _showSuccessSnackBar('Address copied to clipboard');
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppColors.orange,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Payment expires in:',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _formatExpireTime(paymentData!.expireTime),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                paymentData = null;
              });
            },
            child: Text(
              'Close',
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              ),
            ),
          ),
          if (paymentData!.checkoutUrl.isNotEmpty)
            ElevatedButton(
              onPressed: () async {
                final url = Uri.parse(paymentData!.checkoutUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                  _showSuccessSnackBar('Payment URL opened');
                } else {
                  _showErrorSnackBar('Could not launch payment URL');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Open Payment',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatExpireTime(int expireTime) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final timeLeft = expireTime - now;

    if (timeLeft <= 0) {
      return 'Expired';
    }

    final hours = timeLeft ~/ (1000 * 60 * 60);
    final minutes = (timeLeft % (1000 * 60 * 60)) ~/ (1000 * 60);
    final seconds = (timeLeft % (1000 * 60)) ~/ 1000;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'Crypto Deposit',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Network Selection
                  _buildSectionLabel('Select Network *', isDarkMode),
                  SizedBox(height: 8.h),
                  _buildNetworkDropdown(isDarkMode),
                  SizedBox(height: 24.h),
                  // Account Selection
                  _buildSectionLabel('To Account *', isDarkMode),
                  SizedBox(height: 8.h),
                  _buildAccountDropdown(isDarkMode),
                  SizedBox(height: 24.h),
                  // Amount Input
                  _buildSectionLabel('Amount *', isDarkMode),
                  SizedBox(height: 8.h),
                  _buildAmountInput(isDarkMode),
                  SizedBox(height: 24.h),
                  // Deposit Summary
                  _buildDepositSummary(isDarkMode),
                  SizedBox(height: 32.h),
                  // Confirm Button
                  _buildConfirmButton(isDarkMode),
                  SizedBox(height: 24.h),
                  // Secure Transaction Note
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
                ],
              ),
            ),
            if (isProcessingPayment)
              Container(
                color: isDarkMode ? AppColors.darkBackground.withOpacity(0.7) : AppColors.lightBackground.withOpacity(0.7),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(16.r),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              isDarkMode ? AppColors.darkAccent : AppColors.lightAccent),
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Processing payment...',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text, bool isDarkMode) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
      ),
    );
  }

  Widget _buildNetworkDropdown(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
        ),
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
      child: DropdownButtonFormField<String>(
        value: selectedNetwork,
        decoration: InputDecoration(
          hintText: 'Select Network',
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: isDarkMode ? AppColors.darkSecondaryText.withOpacity(0.5) : AppColors.lightSecondaryText.withOpacity(0.5),
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: 16.sp,
          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        ),
        dropdownColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        items: networks.map((network) {
          return DropdownMenuItem<String>(
            value: network['symbol'],
            child: Row(
              children: [
                Icon(
                  Icons.currency_bitcoin,
                  size: 20.sp,
                  color: Color(int.parse(network['color']!.replaceFirst('#', '0xff'))),
                ),
                SizedBox(width: 8.w),
                Text(network['name']!),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedNetwork = value;
          });
        },
      ),
    );
  }

  Widget _buildAccountDropdown(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
        ),
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
      child: DropdownButtonFormField<String>(
        value: selectedAccount,
        decoration: InputDecoration(
          hintText: isLoadingAccounts ? 'Loading...' : 'Select Account',
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: isDarkMode ? AppColors.darkSecondaryText.withOpacity(0.5) : AppColors.lightSecondaryText.withOpacity(0.5),
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: 16.sp,
          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        ),
        dropdownColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        items: mt5Accounts.map((account) {
          return DropdownMenuItem<String>(
            value: account['Login'].toString(),
            child: Text('${account['Login']} - ${account['Name']}'),
          );
        }).toList(),
        onChanged: isLoadingAccounts
            ? null
            : (value) {
          setState(() {
            selectedAccount = value;
          });
        },
      ),
    );
  }

  Widget _buildAmountInput(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
        ),
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
          hintText: '0.00',
          hintStyle: TextStyle(
            fontSize: 20.sp,
            color: isDarkMode ? AppColors.darkSecondaryText.withOpacity(0.5) : AppColors.lightSecondaryText.withOpacity(0.5),
          ),
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 8.w),
            child: Text(
              '\$',
              style: TextStyle(
                fontSize: 20.sp,
                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              ),
            ),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text(
              'USD',
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              ),
            ),
          ),
          suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildDepositSummary(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'To be deposited',
            style: TextStyle(
              fontSize: 16.sp,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                depositAmount.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
              Text(
                '.${(depositAmount % 1 * 100).toStringAsFixed(0).padLeft(2, '0')} USD',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(bool isDarkMode) {
    final bool isEnabled = selectedNetwork != null &&
        selectedAccount != null &&
        depositAmount > 0 &&
        !isLoadingAccounts &&
        !isProcessingPayment;

    return GestureDetector(
      onTap: isEnabled ? _onConfirm : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isEnabled
              ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
              : (isDarkMode ? AppColors.darkAccent.withOpacity(0.5) : AppColors.lightAccent.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: isEnabled && !isDarkMode
              ? [
            BoxShadow(
              color: AppColors.lightShadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isProcessingPayment)
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                ),
              if (!isProcessingPayment)
                Icon(
                  Icons.check_circle,
                  color: AppColors.white,
                  size: 20.sp,
                ),
              SizedBox(width: 8.w),
              Text(
                isProcessingPayment ? 'Processing...' : 'Confirm Deposit',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}