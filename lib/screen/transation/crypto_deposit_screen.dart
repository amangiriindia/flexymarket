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
import '../../widget/common/main_app_bar.dart';

class CryptoDepositScreen extends StatefulWidget {
  const CryptoDepositScreen({Key? key}) : super(key: key);

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
      'icon': 'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@1a63530be6e374711a8554f31b17e4cb92c25fa5/svg/color/bnb.svg',
      'color': '#F0B90B'
    },
    {
      'name': 'TRON',
      'symbol': 'TRON',
      'icon': 'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@1a63530be6e374711a8554f31b17e4cb92c25fa5/svg/color/trx.svg',
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
      // Validate response matches request
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
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
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

      // Start payment
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.blue,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            const Text('Confirm Deposit'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network(
                        selectedNetworkData['icon']!,
                        width: 20.w,
                        height: 20.h,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.account_balance_wallet,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Network: $selectedNetwork',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Account: $selectedAccount',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Amount: ${depositAmount.toStringAsFixed(2)} USD',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
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
                color: Colors.grey.shade600,
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
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
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
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showPaymentDetailsDialog() {
    if (paymentData == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.payment,
              color: Colors.blue,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            const Text('Payment Details'),
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
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Amount: ${paymentData!.orderAmount} ${paymentData!.orderCurrency}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Order ID: ${paymentData!.cregisId}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Created: ${_formatTimestamp(paymentData!.createdTime)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
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
                  ),
                ),
                SizedBox(height: 8.h),
                ...paymentData!.paymentInfo.map((info) => Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            info.logoUrl,
                            width: 24.w,
                            height: 24.h,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.currency_bitcoin,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${info.tokenSymbol} (${info.blockchain})',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Amount: ${info.receiveAmount} ${info.receiveCurrency}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Exchange Rate: ${info.exchangeRate}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Payment Address:',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
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
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.copy, size: 16.sp),
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: info.paymentAddress));
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
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.orange.shade700,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Payment expires in:',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.orange.shade700,
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
                        color: Colors.orange.shade700,
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
                color: Colors.grey.shade600,
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
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: const Text('Open Payment'),
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
      appBar: const MainAppBar(
        title: 'Crypto Deposit',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Network Selection
                  _buildSectionLabel('Select Network *', isDarkMode),
                  SizedBox(height: 8.h),
                  _buildNetworkDropdown(isDarkMode),
                  SizedBox(height: 20.h),

                  // Account Selection
                  _buildSectionLabel('To account *', isDarkMode),
                  SizedBox(height: 8.h),
                  _buildAccountDropdown(isDarkMode),
                  SizedBox(height: 20.h),

                  // Amount Input
                  _buildSectionLabel('Amount *', isDarkMode),
                  SizedBox(height: 8.h),
                  _buildAmountInput(isDarkMode),
                  SizedBox(height: 24.h),

                  // Deposit Summary
                  _buildDepositSummary(isDarkMode),
                  SizedBox(height: 24.h),

                  // Confirm Button
                  _buildConfirmButton(isDarkMode),
                ],
              ),
            ),
            if (isProcessingPayment)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              isDarkMode ? AppColors.darkAccent : AppColors.lightAccent),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Processing payment...',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode
                                ? AppColors.darkPrimaryText
                                : AppColors.lightPrimaryText,
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
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
      ),
    );
  }

  Widget _buildNetworkDropdown(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDarkMode
              ? AppColors.darkSecondaryText.withOpacity(0.3)
              : AppColors.lightSecondaryText.withOpacity(0.3),
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedNetwork,
        decoration: InputDecoration(
          hintText: 'Select --',
          hintStyle: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
        style: TextStyle(
          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        ),
        dropdownColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        items: networks.map((network) {
          return DropdownMenuItem<String>(
            value: network['symbol'],
            child: Text(network['name']!),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDarkMode
              ? AppColors.darkSecondaryText.withOpacity(0.3)
              : AppColors.lightSecondaryText.withOpacity(0.3),
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedAccount,
        decoration: InputDecoration(
          hintText: isLoadingAccounts ? 'Loading...' : 'Select --',
          hintStyle: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
        style: TextStyle(
          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        ),
        dropdownColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDarkMode
              ? AppColors.darkSecondaryText.withOpacity(0.3)
              : AppColors.lightSecondaryText.withOpacity(0.3),
        ),
      ),
      child: TextFormField(
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(
          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        ),
        decoration: InputDecoration(
          hintText: '0.00',
          hintStyle: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'USD',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
              ],
            ),
          ),
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
        color: isDarkMode
            ? AppColors.darkAccent.withOpacity(0.1)
            : AppColors.lightAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDarkMode
              ? AppColors.darkAccent.withOpacity(0.3)
              : AppColors.lightAccent.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'To be deposited',
            style: TextStyle(
              fontSize: 14.sp,
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: isEnabled
            ? LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            isDarkMode
                ? AppColors.darkAccent.withOpacity(0.8)
                : AppColors.lightAccent.withOpacity(0.8),
          ],
        )
            : null,
        boxShadow: isEnabled
            ? [
          BoxShadow(
            color: (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: isEnabled ? _onConfirm : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isEnabled && !isProcessingPayment) ...[
                Icon(
                  Icons.check_circle,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
              ],
              if (isProcessingPayment) ...[
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              Text(
                isProcessingPayment ? 'Processing...' : 'Confirm Deposit',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}