import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constant/app_color.dart';
import '../../../providers/theme_provider.dart';
import '../../service/apiservice/wallet_service.dart';
import '../../widget/common/main_app_bar.dart';
import '../transation/deposit_screen.dart';
import '../transation/withdraw_fund_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletService _walletService = WalletService();
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _assetData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final transactionResponse = await _walletService.fetchTransactionList(
        page: 1,
        sizePerPage: 10,
      );
      final userDataResponse = await _walletService.fetchUserData();

      if (transactionResponse['status'] == true && userDataResponse['status'] == true) {
        setState(() {
          _transactions = List<Map<String, dynamic>>.from(
            transactionResponse['data']['depositWithdrawList'],
          );
          _assetData = userDataResponse['data']['assetData'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = transactionResponse['status'] == false
              ? (transactionResponse['message'] ?? 'Failed to fetch transactions')
              : (userDataResponse['message'] ?? 'Failed to fetch user data');
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
    if (_selectedFilter == 'All') {
      return _transactions.where((tx) {
        return tx['transactionType'] == 'DEPOSIT' || tx['transactionType'] == 'WITHDRAW';
      }).toList();
    }

    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedFilter) {
      case '7 Days':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case '1 Month':
        startDate = now.subtract(const Duration(days: 30));
        break;
      case '3 Months':
        startDate = now.subtract(const Duration(days: 90));
        break;
      case '6 Months':
        startDate = now.subtract(const Duration(days: 180));
        break;
      default:
        startDate = now.subtract(const Duration(days: 7));
    }

    return _transactions.where((tx) {
      final txDate = DateTime.parse(tx['createdAt']);
      return (tx['transactionType'] == 'DEPOSIT' || tx['transactionType'] == 'WITHDRAW') &&
          (txDate.isAfter(startDate) || txDate.isAtSameMomentAs(startDate));
    }).toList();
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
          onPressed: _fetchData,
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
      appBar: const MainAppBar(title: 'Wallet', showBackButton: true),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBalanceCard(isDarkMode),
                  SizedBox(height: 16.h),
                  _buildActionButtons(context, isDarkMode),
                  SizedBox(height: 24.h),
                  Text(
                    'Transaction List',
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildFilterBar(isDarkMode),
                  SizedBox(height: 16.h),
                  _isLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                      strokeWidth: 3,
                    ),
                  )
                      : filteredTransactions.isEmpty
                      ? Center(
                    child: Text(
                      'No deposit or withdraw transactions found.',
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText,
                        fontSize: 16.sp,
                      ),
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final tx = filteredTransactions[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _buildTransactionCard(
                          type: tx['transactionType'] == 'DEPOSIT' ? 'Deposit' : 'Withdraw',
                          amount: (tx['transactionType'] == 'DEPOSIT' ? '+' : '-') +
                              '\$${double.parse(tx['amount']).toStringAsFixed(2)}',
                          date: tx['createdAt'].split('T')[0],
                          status: tx['status'],
                          isPositive: tx['transactionType'] == 'DEPOSIT',
                          isDarkMode: isDarkMode,
                          remark: tx['remark'],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: isDarkMode
                    ? AppColors.darkBackground.withOpacity(0.7)
                    : AppColors.lightBackground.withOpacity(0.7),
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

  Widget _buildBalanceCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: isDarkMode ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
        boxShadow: isDarkMode
            ? null
            : [
          BoxShadow(
            color: AppColors.lightShadow.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallet Overview',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _assetData != null
                ? '\$${(_assetData!['mainBalance'] as num).toStringAsFixed(2)} USD'
                : '\$0.00 USD',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildBalanceItem(
                  label: 'Total Deposit',
                  value: _assetData != null
                      ? '\$${(_assetData!['totalDeposit'] as num).toStringAsFixed(2)}'
                      : '\$0.00',
                  isDarkMode: isDarkMode,
                  color: AppColors.green,
                ),
                SizedBox(width: 8.w),
                _buildBalanceItem(
                  label: 'Total Withdrawal',
                  value: _assetData != null
                      ? '\$${(_assetData!['totalWithdrawal'] as num).toStringAsFixed(2)}'
                      : '\$0.00',
                  isDarkMode: isDarkMode,
                  color: AppColors.red,
                ),
                SizedBox(width: 8.w),
                _buildBalanceItem(
                  label: 'Meta Deposit',
                  value: _assetData != null
                      ? '\$${(_assetData!['totalMetaDeposit'] as num).toStringAsFixed(2)}'
                      : '\$0.00',
                  isDarkMode: isDarkMode,
                  color: AppColors.green,
                ),
                SizedBox(width: 8.w),
                _buildBalanceItem(
                  label: 'Meta Withdrawal',
                  value: _assetData != null
                      ? '\$${(_assetData!['totalMetaWithdrawal'] as num).toStringAsFixed(2)}'
                      : '\$0.00',
                  isDarkMode: isDarkMode,
                  color: AppColors.red,
                ),
                SizedBox(width: 8.w),
                _buildBalanceItem(
                  label: 'Internal Transfer',
                  value: _assetData != null
                      ? '\$${(_assetData!['totalInternalTransfer'] as num).toStringAsFixed(2)}'
                      : '\$0.00',
                  isDarkMode: isDarkMode,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
                SizedBox(width: 8.w),
                _buildBalanceItem(
                  label: 'IB Income',
                  value: _assetData != null
                      ? '\$${(_assetData!['totalIBIncome'] as num).toStringAsFixed(2)}'
                      : '\$0.00',
                  isDarkMode: isDarkMode,
                  color: AppColors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem({
    required String label,
    required String value,
    required bool isDarkMode,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightShadow.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          context,
          icon: Icons.account_balance_wallet_outlined,
          label: 'Deposit',
          isDarkMode: isDarkMode,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DepositScreen()),
            );
          },
        ),
        SizedBox(width: 8.w),
        _buildActionButton(
          context,
          icon: Icons.arrow_downward,
          label: 'Withdraw',
          isDarkMode: isDarkMode,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WithdrawFundsScreen(
                  mainBalance: _assetData != null
                      ? (_assetData!['mainBalance'] as num).toDouble()
                      : 0.0,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required bool isDarkMode,
        required VoidCallback onPressed,
      }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50.h,
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent).withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18.sp, color: AppColors.white),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
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

  Widget _buildFilterBar(bool isDarkMode) {
    final filters = ['All', '7 Days', '1 Month', '3 Months', '6 Months'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                      : (isDarkMode ? AppColors.darkCard : AppColors.lightCard),
                  borderRadius: BorderRadius.circular(20.r),
                  border: isDarkMode
                      ? Border.all(color: AppColors.darkBorder, width: 0.5)
                      : null,
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.white
                        : (isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionCard({
    required String type,
    required String amount,
    required String date,
    required String status,
    required bool isPositive,
    required bool isDarkMode,
    required String remark,
  }) {
    final isDeposit = type == 'Deposit';
    final icon = isDeposit ? Icons.arrow_downward : Icons.arrow_upward;
    final color = isDeposit ? AppColors.green : AppColors.red;

    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: isDarkMode ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
        boxShadow: isDarkMode
            ? null
            : [
          BoxShadow(
            color: AppColors.lightShadow,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.darkPrimaryText
                          : AppColors.lightPrimaryText,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    date,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    remark,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: color,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                status,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.darkSecondaryText
                      : AppColors.lightSecondaryText,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}