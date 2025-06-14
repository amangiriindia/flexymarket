import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/common_app_bar.dart';

enum NotificationType { trade, system, promotion }

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String description;
  final String timestamp;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isRead = false,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      type: NotificationType.trade,
      title: 'Trade Executed',
      description: 'Your BTC/USD buy order of 0.1 BTC was executed at \$82,595.55.',
      timestamp: '2 hours ago',
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      type: NotificationType.system,
      title: 'System Update',
      description: 'Platform maintenance scheduled for June 15, 2025, at 2:00 AM IST.',
      timestamp: '5 hours ago',
      isRead: true,
    ),
    NotificationItem(
      id: '3',
      type: NotificationType.promotion,
      title: 'New Promotion',
      description: 'Get 10% bonus on your next deposit until June 20, 2025.',
      timestamp: '1 day ago',
      isRead: false,
    ),
    NotificationItem(
      id: '4',
      type: NotificationType.trade,
      title: 'Trade Closed',
      description: 'Your ETH/USD sell order of 2.5 ETH was closed with a profit of \$123.45.',
      timestamp: '2 days ago',
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      type: NotificationType.system,
      title: 'Security Alert',
      description: 'New login detected from a new device. Verify your account.',
      timestamp: '3 days ago',
      isRead: false,
    ),
  ];

  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimations = List.generate(
      _notifications.length,
          (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.1 * index, 0.3 + 0.1 * index, curve: Curves.easeIn),
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

  void _markAsRead(String id) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    setState(() {
      final index = _notifications.indexWhere((item) => item.id == id);
      if (index != -1) {
        _notifications[index].isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'View notification details coming soon!',
          style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
        ),
        backgroundColor: AppColors.green,
      ),
    );
  }

  void _clearNotifications() {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    setState(() {
      _notifications.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'All notifications cleared',
          style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
        ),
        backgroundColor: AppColors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text('Notifications'),

        actions: [
          if (_notifications.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.delete,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                size: 24.sp,
              ),
              onPressed: _clearNotifications,

            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: _notifications.isEmpty
              ? _buildEmptyState(isDarkMode)
              : SingleChildScrollView(
            child: Column(
              children: List.generate(
                _notifications.length,
                    (index) => FadeTransition(
                  opacity: _fadeAnimations[index],
                  child: _buildNotificationItem(_notifications[index], isDarkMode),
                ),
              ),
            ),
          ),
        ),
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
            Icons.notifications_none,
            size: 48.sp,
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
          SizedBox(height: 16.h),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 16.sp,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
            semanticsLabel: 'No notifications available',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem item, bool isDarkMode) {
    IconData icon;
    Color iconColor;
    switch (item.type) {
      case NotificationType.trade:
        icon = Icons.swap_horiz;
        iconColor = AppColors.green;
        break;
      case NotificationType.system:
        icon = Icons.info;
        iconColor = isDarkMode ? AppColors.darkAccent : AppColors.lightAccent;
        break;
      case NotificationType.promotion:
        icon = Icons.local_offer;
        iconColor = AppColors.red;
        break;
    }

    return GestureDetector(
      onTap: () => _markAsRead(item.id),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
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
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: iconColor,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.timestamp,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (!item.isRead)
              Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                ),
              ),
          ],
        ),
      ),
    );
  }
}