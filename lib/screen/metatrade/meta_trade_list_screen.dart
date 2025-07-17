import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../service/meta_trade_service.dart';
import '../../widget/common/common_app_bar.dart';
import 'create_meta_trade_screen.dart';

class MT5Account {
  final String login; // Changed from id to login
  final String planName;
  final double balance;
  final String leverage;
  final String spread;
  final String commission;
  final String status;
  final String creationDate;

  MT5Account({
    required this.login,
    required this.planName,
    required this.balance,
    required this.leverage,
    required this.spread,
    required this.commission,
    required this.status,
    required this.creationDate,
  });

  factory MT5Account.fromJson(Map<String, dynamic> json) {
    return MT5Account(
      login: json['Login'] ?? '',
      planName: json['Group']?.split('\\').last ?? 'Unknown', // Extract plan name from Group (e.g., "Dev\Dev" -> "Dev")
      balance: double.tryParse(json['Balance'] ?? '0.00') ?? 0.00,
      leverage: '1:${json['Leverage'] ?? '0'}',
      spread: 'From 0.20', // API doesn't provide spread, using default
      commission: json['CommissionDaily'] == '0.00' && json['CommissionMonthly'] == '0.00'
          ? 'No commission'
          : '${json['CommissionDaily']}/${json['CommissionMonthly']}',
      status: json['Status']?.isEmpty ?? true ? 'Active' : json['Status'], // Default to Active if empty
      creationDate: (json['createdAt'] ?? '').split('T').first,
    );
  }
}

class MetaTradeListScreen extends StatefulWidget {
  const MetaTradeListScreen({super.key});

  @override
  State<MetaTradeListScreen> createState() => _MetaTradeListScreenState();
}

class _MetaTradeListScreenState extends State<MetaTradeListScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<bool> _expandedStates = [];
  List<MT5Account> _accounts = [];
  bool _isLoading = true;
  final MetaTradeService _metaTradeService = MetaTradeService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fetchAccounts();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchAccounts() async {
    setState(() => _isLoading = true);
    final result = await _metaTradeService.getMT5AccountList();
    setState(() {
      _isLoading = false;
      if (result['success'] && result['data'] != null) {
        _accounts = (result['data']['mt5AccountList'] as List)
            .map((account) => MT5Account.fromJson(account))
            .toList();
        _expandedStates.clear();
        _expandedStates.addAll(List.generate(_accounts.length, (_) => false));
        _animationController.forward();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'],
              style: TextStyle(color: AppColors.white),
            ),
            backgroundColor: AppColors.red,
          ),
        );
      }
    });
  }

  void _toggleExpansion(int index) {
    setState(() {
      _expandedStates[index] = !_expandedStates[index];
    });
  }

  void _navigateToCreateAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateMetaAccountScreen()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening Create Account',
          style: TextStyle(
            color: Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                ? AppColors.darkPrimaryText
                : AppColors.lightPrimaryText,
          ),
        ),
        backgroundColor: AppColors.green,
      ),
    );
  }

  void _showFeatureSnackBar(String feature) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature coming soon!',
          style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
        ),
        backgroundColor: AppColors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'MT5 Accounts',
        showBackButton: true,
        onBackPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Returning to Profile',
                style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
              ),
              backgroundColor: AppColors.red,
            ),
          );
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your MT5 Accounts',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
                semanticsLabel: 'Your MT5 Accounts',
              ),
              SizedBox(height: 16.h),
              _isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                ),
              )
                  : _accounts.isEmpty
                  ? _buildEmptyState(isDarkMode)
                  : _buildAccountList(isDarkMode),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateAccount,
        backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
        child: Icon(
          Icons.add,
          size: 24.sp,
          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        ),
        tooltip: 'Create New Account',
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 24.h),
          Icon(
            Icons.account_balance_wallet,
            size: 80.sp,
            color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            semanticLabel: 'No accounts icon',
          ),
          SizedBox(height: 16.h),
          Text(
            'No MT5 accounts found',
            style: TextStyle(
              fontSize: 16.sp,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
            semanticsLabel: 'No MT5 accounts found',
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: _navigateToCreateAccount,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Create New Account',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
                semanticsLabel: 'Create New Account',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountList(bool isDarkMode) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _accounts.length,
      itemBuilder: (context, index) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(0.1 * index, 0.3 + 0.1 * index, curve: Curves.easeIn),
            ),
          ),
          child: _buildAccountCard(_accounts[index], index, isDarkMode),
        );
      },
    );
  }

  Widget _buildAccountCard(MT5Account account, int index, bool isDarkMode) {
    final isExpanded = _expandedStates[index];

    return GestureDetector(
      onTap: () => _toggleExpansion(index),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login: ${account.login}', // Changed from ID to Login
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          account.planName,
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
                        '\$${account.balance.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        account.leverage,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 24.sp,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ],
              ),
              if (isExpanded) ...[
                Divider(
                  height: 16.h,
                  color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                _buildDetailRow('Spread', account.spread, isDarkMode),
                _buildDetailRow('Commission', account.commission, isDarkMode),
                _buildDetailRow('Status', account.status, isDarkMode),
                _buildDetailRow('Creation Date', account.creationDate, isDarkMode),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton('Deposit', () => _showFeatureSnackBar('Deposit'), isDarkMode),
                    _buildActionButton('Withdraw', () => _showFeatureSnackBar('Withdraw'), isDarkMode),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed, bool isDarkMode) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
              semanticsLabel: label,
            ),
          ),
        ),
      ),
    );
  }


}