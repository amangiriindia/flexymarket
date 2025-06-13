import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constant/app_color.dart';
import '../../../providers/theme_provider.dart';
import '../../widget/common/main_app_bar.dart';


class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String _selectedFilter = '7 Days';

  final List<Map<String, dynamic>> _mockTransactions = [
    {
      'type': 'Deposit',
      'amount': '+\$1,000.00',
      'date': '2025-06-10',
      'status': 'Completed',
      'isPositive': true,
    },
    {
      'type': 'Trade',
      'amount': '-\$500.00',
      'date': '2025-06-09',
      'status': 'Completed',
      'isPositive': false,
    },
    {
      'type': 'Withdraw',
      'amount': '-\$200.00',
      'date': '2025-06-08',
      'status': 'Pending',
      'isPositive': false,
    },
    {
      'type': 'Deposit',
      'amount': '+\$2,500.00',
      'date': '2025-05-15',
      'status': 'Completed',
      'isPositive': true,
    },
    {
      'type': 'Trade',
      'amount': '+\$750.00',
      'date': '2025-04-20',
      'status': 'Completed',
      'isPositive': true,
    },
    {
      'type': 'Withdraw',
      'amount': '-\$1,000.00',
      'date': '2025-03-10',
      'status': 'Completed',
      'isPositive': false,
    },
  ];

  List<Map<String, dynamic>> _getFilteredTransactions() {
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

    return _mockTransactions.where((tx) {
      final txDate = DateTime.parse(tx['date']);
      return (tx['type'] == 'Deposit' || tx['type'] == 'Withdraw') &&
          (txDate.isAfter(startDate) || txDate.isAtSameMomentAs(startDate));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final filteredTransactions = _getFilteredTransactions();

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const MainAppBar(
        title: 'Wallet',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
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
              Expanded(
                child: filteredTransactions.isEmpty
                    ? Center(
                  child: Text(
                    'No deposit or withdraw transactions found for this period.',
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      fontSize: 16.sp,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final tx = filteredTransactions[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _buildTransactionCard(
                        type: tx['type'],
                        amount: tx['amount'],
                        date: tx['date'],
                        status: tx['status'],
                        isPositive: tx['isPositive'],
                        isDarkMode: isDarkMode,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
            color: AppColors.lightShadow,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '\$11,557.71 USD',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Equity',
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '+\$1,245.32',
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Margin',
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '-\$245.89',
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Deposit functionality coming soon!')),
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Withdraw functionality coming soon!')),
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
              Icon(
                icon,
                size: 18.sp,
                color: AppColors.white,
              ),
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
    final filters = ['7 Days', '1 Month', '3 Months', '6 Months'];
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
                  border: isDarkMode ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
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
                child: Icon(
                  icon,
                  color: color,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    date,
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
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
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
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