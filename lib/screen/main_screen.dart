import 'package:flexy_markets/screen/profile_screen.dart';
import 'package:flexy_markets/screen/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    const HomeScreen(),
    const MarketScreen(),
    const PublicScreen(),
    const WalletScreen(),
    const ProfileScreen(),
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
          _buildNavBarItem(Icons.home, _selectedIndex == 0, 0),
          _buildNavBarItem(Icons.bar_chart, _selectedIndex == 1, 1),
          _buildNavBarItem(Icons.public, _selectedIndex == 2, 2),
          _buildNavBarItem(Icons.show_chart, _selectedIndex == 3, 3),
          _buildNavBarItem(Icons.person, _selectedIndex == 4, 4),
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






// Chart Screen
class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Chart Screen',
          style: TextStyle(fontSize: 24.sp, color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF121212),
    );
  }
}

// Public Screen
class PublicScreen extends StatelessWidget {
  const PublicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Public Screen',
          style: TextStyle(fontSize: 24.sp, color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF121212),
    );
  }
}


