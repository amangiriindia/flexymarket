import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constant/app_color.dart';
import '../../../providers/theme_provider.dart';
import '../../../widget/common/common_app_bar.dart';
import 'support_screen.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'About Us',
        showBackButton: true,
        onBackPressed: () {
          Navigator.pop(context);
          _showSuccessSnackBar(context, 'Returning to Profile', isDarkMode);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: 'Who We Are',
                content: Text(
                  'Flexy Markets is a premier cryptocurrency trading platform launched in 2024, dedicated to providing a secure, efficient, and intuitive trading experience. We empower users worldwide to engage with digital assets through cutting-edge technology and a commitment to transparency.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    height: 1.5,
                  ),
                ),
                index: 0,
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: 16.h),
              _buildSectionCard(
                title: 'Our Mission',
                content: Text(
                  'At Flexy Markets, our mission is to make cryptocurrency trading accessible and secure for all. We aim to provide a trusted platform with low fees, real-time insights, and robust security to help users achieve their financial goals.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    height: 1.5,
                  ),
                ),
                index: 1,
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: 16.h),
              _buildSectionCard(
                title: 'Why Choose Flexy Markets?',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeatureItem(
                      icon: Icons.security,
                      text: 'Advanced encryption and multi-factor authentication for top-tier security.',
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureItem(
                      icon: Icons.speed,
                      text: 'Fast and seamless deposits and withdrawals.',
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureItem(
                      icon: Icons.bar_chart,
                      text: 'Real-time market data with advanced trading tools.',
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureItem(
                      icon: Icons.monetization_on,
                      text: 'Low trading fees starting at 0.1%.',
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
                index: 2,
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: 16.h),
              _buildSectionCard(
                title: 'Get in Touch',
                content: Column(
                  children: [
                    _buildContactItem(
                      icon: Icons.email,
                      text: 'support@flexymarket.com',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SupportScreen()),
                        );
                        Clipboard.setData(const ClipboardData(text: 'support@flexymarket.com'));
                        _showSuccessSnackBar(context, 'Email copied to clipboard', isDarkMode);
                      },
                      isDarkMode: isDarkMode,
                      semanticLabel: 'Email support',
                    ),
                    SizedBox(height: 12.h),
                    _buildContactItem(
                      icon: Icons.chat,
                      text: 'Chat via WhatsApp',
                      onTap: () async {
                        final Uri url = Uri.parse('https://web.whatsapp.com/');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                          _showSuccessSnackBar(context, 'Opening WhatsApp Web', isDarkMode);
                        } else {
                          _showErrorSnackBar(context, 'Could not open WhatsApp Web', isDarkMode);
                        }
                      },
                      isDarkMode: isDarkMode,
                      semanticLabel: 'Chat via WhatsApp',
                    ),
                    SizedBox(height: 12.h),
                    _buildContactItem(
                      icon: Icons.language,
                      text: 'flexymarkets.com',
                      onTap: () async {
                        final Uri url = Uri.parse('https://www.flexymarkets.com');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                          _showSuccessSnackBar(context, 'Opening website', isDarkMode);
                        } else {
                          _showErrorSnackBar(context, 'Could not open website', isDarkMode);
                        }
                      },
                      isDarkMode: isDarkMode,
                      semanticLabel: 'Visit website',
                    ),
                  ],
                ),
                index: 3,
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: 16.h),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      size: 16.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'All communications are secure and encrypted',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                      semanticsLabel: 'All communications are secure and encrypted',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              _buildLearnMoreButton(context, isDarkMode),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message, bool isDarkMode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message, bool isDarkMode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget content,
    required int index,
    required bool isDarkMode,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: isDarkMode
            ? null
            : [
          BoxShadow(
            color: AppColors.lightShadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
            semanticsLabel: '$title section',
          ),
          SizedBox(height: 12.h),
          content,
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String text,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
          size: 20.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
            semanticsLabel: text,
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required bool isDarkMode,
    required String semanticLabel,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
          boxShadow: isDarkMode
              ? null
              : [
            BoxShadow(
              color: AppColors.lightShadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
                semanticsLabel: semanticLabel,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearnMoreButton(BuildContext context, bool isDarkMode) {
    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse('https://www.flexymarkets.com');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          _showSuccessSnackBar(context, 'Opening website', isDarkMode);
        } else {
          _showErrorSnackBar(context, 'Could not open website', isDarkMode);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: isDarkMode
              ? null
              : [
            BoxShadow(
              color: AppColors.lightShadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Learn More',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
            semanticsLabel: 'Learn More about Flexy Markets',
          ),
        ),
      ),
    );
  }
}