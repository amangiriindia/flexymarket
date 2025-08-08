import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../main/community_screen.dart';
import '../main/home_screen.dart';
import '../main/profile_screen.dart';
import '../main/trade_screen.dart';
import '../main/wallet_screen.dart';
import '../metatrade/meta_trade_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    // const TradeScreen(),
    // const CommunityScreen(),
    MetaTradeListScreen(),
    const WalletScreen(),
    const ProfileScreen(),
  ];

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.stacked_line_chart, 'label': 'MT5'},
    {'icon': Icons.account_balance_wallet, 'label': 'Wallet'},
    {'icon': Icons.person, 'label': 'Profile'},
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: _screens[_selectedIndex],
      bottomNavigationBar: buildBottomNavigationBar(isDarkMode),
    );
  }

  Widget buildBottomNavigationBar(bool isDarkMode) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        border: Border(
          top: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
        boxShadow: isDarkMode
            ? null
            : [
          BoxShadow(
            color: AppColors.lightShadow.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _navItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _buildNavBarItem(
            icon: item['icon'],
            label: item['label'],
            isActive: _selectedIndex == index,
            index: index,
            isDarkMode: isDarkMode,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavBarItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required int index,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                  : (isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
              size: 24.sp,
              semanticLabel: label,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                    : (isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                fontSize: 12.sp,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}