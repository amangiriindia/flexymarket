import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? leadingIcon;

  const CommonAppBar({
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
      leading:
          showBackButton
              ? IconButton(
                icon:
                    leadingIcon ??
                    Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color:
                          isDarkMode
                              ? AppColors.darkSurface
                              : AppColors.lightSurface,
                      semanticLabel: 'Back',
                    ),
                onPressed:
                    onBackPressed ??
                    () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Returning to previous screen',
                            style: TextStyle(
                              color:
                                  isDarkMode
                                      ? AppColors.darkPrimaryText
                                      : AppColors.lightPrimaryText,
                            ),
                          ),
                        ),
                      );
                    },
              )
              : null,
      title: Text(
        title,
        style: TextStyle(
          color:
              isDarkMode
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
            size: 24.sp,
            color:
                isDarkMode
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
            size: 24.sp,
            color:
                isDarkMode
                    ? AppColors.darkPrimaryText
                    : AppColors.lightPrimaryText,
            semanticLabel: 'Notifications',
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Notifications coming soon!',
                  style: TextStyle(
                    color:
                        isDarkMode
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                  ),
                ),
                backgroundColor: AppColors.green,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
