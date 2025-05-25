import 'package:flexy_markets/screen/calculator_screen.dart'; // Updated import
import 'package:flexy_markets/screen/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'community_screen.dart';
import 'home_screen.dart';
import 'market_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens to display
  final List<Widget> _screens = [
    const WalletScreen(),
    const MarketScreen(),
    const CommunityScreen(),
    const HomeScreen(),
    const RiskCalculatorScreen(), // Replaced ProfileScreen
  ];

  // Handle navigation item tap
  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar() {
    return Container(
      height: 60.h,
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        border: Border(
          top: BorderSide(color: Color(0xFF2E2E2E), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(Icons.home, _selectedIndex == 0, 0), // Home
          _buildNavBarItem(Icons.bar_chart, _selectedIndex == 1, 1), // Market
          _buildNavBarItem(Icons.group, _selectedIndex == 2, 2), // Community
          _buildNavBarItem(Icons.account_balance_wallet, _selectedIndex == 3, 3), // Wallet
          _buildNavBarItem(Icons.calculate, _selectedIndex == 4, 4), // Risk Calculator
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, bool isActive, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: isActive ? const Color(0xFF00C853) : Colors.grey,
        size: 24.sp,
      ),
      onPressed: () => _onNavItemTapped(index),
    );
  }
}