import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Returning to Profile',
                style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
              ),
            ),
          );
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
                  'Flexy Markets is a leading crypto trading platform designed to empower traders with secure, fast, and user-friendly tools to navigate the dynamic world of cryptocurrencies. Established in 2023, we aim to make crypto trading accessible to everyone, from beginners to seasoned investors.',
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
                  'Our mission is to democratize crypto trading by providing a reliable, transparent, and secure platform that prioritizes user experience and financial empowerment. We strive to offer low fees, real-time market data, and robust security measures to help our users succeed.',
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
                      text: 'Bank-grade security with advanced encryption.',
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureItem(
                      icon: Icons.speed,
                      text: 'Instant deposits and withdrawals.',
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureItem(
                      icon: Icons.bar_chart,
                      text: 'Real-time market data and trading tools.',
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureItem(
                      icon: Icons.monetization_on,
                      text: 'Competitive fees starting at 0%.',
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
                index: 2,
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: 16.h),
              _buildSectionCard(
                title: 'Meet Our Team',
                content: SizedBox(
                  height: 120.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildTeamMember(
                        name: 'John Doe',
                        role: 'CEO',
                        icon: FontAwesomeIcons.userTie,
                        isDarkMode: isDarkMode,
                        context: context,
                      ),
                      SizedBox(width: 12.w),
                      _buildTeamMember(
                        name: 'Jane Smith',
                        role: 'CTO',
                        icon: FontAwesomeIcons.userGear,
                        isDarkMode: isDarkMode,
                        context: context,
                      ),
                      SizedBox(width: 12.w),
                      _buildTeamMember(
                        name: 'Alex Brown',
                        role: 'Lead Developer',
                        icon: FontAwesomeIcons.user,
                        isDarkMode: isDarkMode,
                        context: context,
                      ),
                    ],
                  ),
                ),
                index: 3,
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: 16.h),
              _buildSectionCard(
                title: 'Get in Touch',
                content: Column(
                  children: [
                    _buildContactItem(
                      icon: Icons.email,
                      text: 'support@flexymarkets.com',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SupportScreen()),
                        );
                        Clipboard.setData(
                          const ClipboardData(text: 'support@flexymarkets.com'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Email copied to clipboard',
                              style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                            ),
                            backgroundColor: AppColors.green,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      isDarkMode: isDarkMode,
                      semanticLabel: 'Email support',
                    ),
                    SizedBox(height: 12.h),
                    _buildContactItem(
                      icon: Icons.language,
                      text: 'flexymarkets.com',
                      onTap: () async {
                        final Uri url = Uri.parse('https://www.flexymarkets.com');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Could not open website',
                                style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                              ),
                              backgroundColor: AppColors.red,
                            ),
                          );
                        }
                      },
                      isDarkMode: isDarkMode,
                      semanticLabel: 'Visit website',
                    ),
                    SizedBox(height: 12.h),
                    _buildContactItem(
                      icon: FontAwesomeIcons.twitter,
                      text: '@FlexyMarkets on Twitter',
                      onTap: () async {
                        final Uri url = Uri.parse('https://twitter.com/FlexyMarkets');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Could not open Twitter',
                                style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                              ),
                              backgroundColor: AppColors.red,
                            ),
                          );
                        }
                      },
                      isDarkMode: isDarkMode,
                      semanticLabel: 'Visit Twitter',
                    ),
                  ],
                ),
                index: 4,
                isDarkMode: isDarkMode,
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

  Widget _buildSectionCard({
    required String title,
    required Widget content,
    required int index,
    required bool isDarkMode,
  }) {
    return  Container(
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
              blurRadius: 4,
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

  Widget _buildTeamMember({
    required String name,
    required String role,
    required IconData icon,
    required bool isDarkMode,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Bio for $name coming soon',
              style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
            ),
            backgroundColor: AppColors.green,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100.w,
        transform: Matrix4.identity()..scale(1.0),
        child: Column(
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  size: 30.sp,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
              textAlign: TextAlign.center,
              semanticsLabel: 'Team member: $name, $role',
            ),
            Text(
              role,
              style: TextStyle(
                fontSize: 12.sp,
                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
        padding: EdgeInsets.symmetric(vertical: 8.h),
        transform: Matrix4.identity()..scale(1.0),
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final Uri url = Uri.parse('https://www.flexymarkets.com');
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Could not open website',
                  style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                ),
                backgroundColor: AppColors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
          foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'Learn More',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          semanticsLabel: 'Learn More about Flexy Markets',
        ),
      ),
    );
  }
}