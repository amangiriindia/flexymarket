import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../screenutils/notification_screen.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? leadingIcon;

  const MainAppBar({
    super.key,
    this.title = 'Markets',
    this.showBackButton = false,
    this.onBackPressed,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return AppBar(
      backgroundColor:
      isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
      elevation: 0,
      toolbarHeight: 50.h,
      leadingWidth: 80.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: Image.asset(
          isDarkMode
              ? 'assets/images/logo_dark.png' // ✅ Dark mode logo
              : 'assets/images/logo.png',      // ✅ Light mode logo
          width: 80.w,
          height: 50.h,
          fit: BoxFit.contain,
          semanticLabel: 'App Logo',
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode
              ? AppColors.darkPrimaryText
              : AppColors.lightPrimaryText,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
            size: 28.sp,
            color: isDarkMode
                ? AppColors.darkPrimaryText
                : AppColors.lightPrimaryText,
            semanticLabel: 'Toggle Theme',
          ),
          onPressed: () {
            themeProvider.toggleTheme();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            size: 28.sp,
            color: isDarkMode
                ? AppColors.darkPrimaryText
                : AppColors.lightPrimaryText,
            semanticLabel: 'Notifications',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificationScreen()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.h);
}
