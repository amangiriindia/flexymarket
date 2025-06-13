import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CommonAppBar({
    Key? key,
    this.title = 'Markets',
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return AppBar(
      backgroundColor: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: 24.sp,
          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        ),
        onPressed: () => Navigator.pop(context),
      )
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
            size: 24.sp,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
          onPressed: () {
            themeProvider.toggleTheme();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            size: 24.sp,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
          onPressed: () {
            // TODO: Implement notifications
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon!')),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}