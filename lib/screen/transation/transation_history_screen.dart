
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constant/app_color.dart';
import '../../../providers/theme_provider.dart';
import '../../service/apiservice/wallet_service.dart';
import '../../../widget/common/common_app_bar.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> with SingleTickerProviderStateMixin {
  final WalletService _walletService = WalletService();
  String selectedPeriod = "All Time";
  final List<String> periods = ["Today", "Last 7 Days", "Last 30 Days", "All Time"];
  List<Map<String, dynamic>> transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimations = List.generate(
      10, // Initial placeholder for animations, updated after fetching
          (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeIn),
        ),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _walletService.fetchUserTransactionList(page: 1, sizePerPage: 10);
      if (response['status'] == true) {
        setState(() {
          transactions = List<Map<String, dynamic>>.from(response['data']['usersList']);
          // Update animations based on actual transaction count
          _fadeAnimations = List.generate(
            transactions.length * 2,
                (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(index * 0.1, 1.0, curve: Curves.easeIn),
              ),
            ),
          );
          _animationController.forward(from: 0.0);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = response['message'] ?? 'Failed to fetch transactions';
        });
        _showSnackBar(_errorMessage!, AppColors.red);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().contains('EACCES')
            ? 'Server error: Unable to process request. Please try again or contact support.'
            : e.toString();
      });
      _showSnackBar(_errorMessage!, AppColors.red);
    }
  }

  List<Map<String, dynamic>> _getFilteredTransactions() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Group transactions by period
    final groupedTransactions = <String, List<Map<String, dynamic>>>{};
    for (var period in periods) {
      groupedTransactions[period] = [];
    }

    for (var tx in transactions) {
      final txDate = DateTime.parse(tx['createdAt']).toLocal();
      final period = _getPeriodForDate(txDate, today);
      groupedTransactions[period]!.add({
        'type': tx['transactionType'] == 'CLIENT-DEPOSIT' ? 'Deposit' : 'Withdrawal',
        'method': _mapPaymentMethod(tx['paymentMethods']),
        'amount': (tx['transactionType'] == 'CLIENT-DEPOSIT' ? '+' : '-') +
            '\$${tx['amount'].toStringAsFixed(2)}',
        'status': tx['status'],
        'isCredit': tx['transactionType'] == 'CLIENT-DEPOSIT',
        'remark': tx['remark'],
      });
    }

    // Filter by selected period
    if (selectedPeriod == 'All Time') {
      return groupedTransactions.entries
          .where((entry) => entry.value.isNotEmpty)
          .map((entry) => {'period': entry.key, 'items': entry.value})
          .toList();
    } else {
      return [
        if (groupedTransactions[selectedPeriod]!.isNotEmpty)
          {'period': selectedPeriod, 'items': groupedTransactions[selectedPeriod]}
      ];
    }
  }

  String _getPeriodForDate(DateTime txDate, DateTime today) {
    final diff = today.difference(txDate).inDays;
    if (txDate.year == today.year && txDate.month == today.month && txDate.day == today.day) {
      return 'Today';
    } else if (diff <= 7) {
      return 'Last 7 Days';
    } else if (diff <= 30) {
      return 'Last 30 Days';
    } else {
      return 'All Time';
    }
  }

  String _mapPaymentMethod(String? paymentMethod) {
    switch (paymentMethod) {
      case 'BANK':
        return 'via Bank Transfer';
      case 'UPI':
        return 'via UPI';
      case 'CRYPTO':
        return 'via Crypto';
      default:
        return 'via Unknown';
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
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
        action: message.contains('Server error')
            ? SnackBarAction(
          label: 'Retry',
          textColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
          onPressed: _fetchTransactions,
        )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final filteredTransactions = _getFilteredTransactions();

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'Transaction History',
        showBackButton: true,
        onBackPressed: () {
          Navigator.pop(context);
          _showSnackBar('Returning to Profile', AppColors.green);
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  _buildFilterRow(isDarkMode),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: _isLoading
                        ? Center(
                      child: CircularProgressIndicator(
                        color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                        strokeWidth: 3,
                      ),
                    )
                        : filteredTransactions.isEmpty
                        ? Center(
                      child: Text(
                        'No transactions found for this period.',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        ),
                      ),
                    )
                        : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final periodData = filteredTransactions[index];
                        final String period = periodData['period'];
                        final List<Map<String, dynamic>> items = periodData['items'];

                        return FadeTransition(
                          opacity: _fadeAnimations[index],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index > 0)
                                Divider(
                                  color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                                  thickness: 1,
                                  height: 24.h,
                                ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                child: Text(
                                  period,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: isDarkMode
                                        ? AppColors.darkSecondaryText
                                        : AppColors.lightSecondaryText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  semanticsLabel: '$period Transactions',
                                ),
                              ),
                              ...items.asMap().entries.map((entry) {
                                final transaction = entry.value;
                                return FadeTransition(
                                  opacity: _fadeAnimations[index + entry.key + 1],
                                  child: _buildTransactionCard(transaction, isDarkMode),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 100.h),
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

  Widget _buildFilterRow(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: DropdownButton<String>(
            value: selectedPeriod,
            items: periods.map((String period) {
              return DropdownMenuItem<String>(
                value: period,
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedPeriod = newValue;
                });
                _showSnackBar('Period changed to $newValue', AppColors.green);
              }
            },
            underline: const SizedBox(),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              size: 20.sp,
            ),
            dropdownColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(12.r),
            isDense: true,
            style: TextStyle(
              fontSize: 16.sp,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _showSnackBar('Opening Filters', AppColors.green);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  size: 20.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                  semanticsLabel: 'Filter Transactions',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        _showTransactionDetailsDialog(transaction, isDarkMode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
          boxShadow: isDarkMode
              ? null
              : [
            BoxShadow(
              color: AppColors.lightShadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: transaction['isCredit']
                      ? AppColors.green.withOpacity(0.2)
                      : AppColors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Icon(
                  transaction['isCredit'] ? Icons.arrow_downward : Icons.arrow_upward,
                  color: transaction['isCredit'] ? AppColors.green : AppColors.red,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction['type'],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      transaction['method'],
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction['amount'],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    transaction['status'],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDetailsDialog(Map<String, dynamic> transaction, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          title: Text(
            '${transaction['type']} Details',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amount: ${transaction['amount']}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Method: ${transaction['method']}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Status: ${transaction['status']}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Remark: ${transaction['remark']}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  fontSize: 14.sp,
                ),
                semanticsLabel: 'Close Dialog',
              ),
            ),
          ],
        );
      },
    );
  }
}