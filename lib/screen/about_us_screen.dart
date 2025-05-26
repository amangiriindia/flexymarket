import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'About Us',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Section
              _buildSectionCard(
                title: 'Who We Are',
                content: Text(
                  'Flexy Markets is a leading crypto trading platform designed to empower traders with secure, fast, and user-friendly tools to navigate the dynamic world of cryptocurrencies. Established in 2023, we aim to make crypto trading accessible to everyone, from beginners to seasoned investors.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Mission Section
              _buildSectionCard(
                title: 'Our Mission',
                content: Text(
                  'Our mission is to democratize crypto trading by providing a reliable, transparent, and secure platform that prioritizes user experience and financial empowerment. We strive to offer low fees, real-time market data, and robust security measures to help our users succeed.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Features Section
              _buildSectionCard(
                title: 'Why Choose Flexy Markets?',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeatureItem(
                      icon: Icons.security,
                      text: 'Bank-grade security with advanced encryption.',
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureItem(
                      icon: Icons.speed,
                      text: 'Instant deposits and withdrawals.',
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureItem(
                      icon: Icons.bar_chart,
                      text: 'Real-time market data and trading tools.',
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureItem(
                      icon: Icons.monetization_on,
                      text: 'Competitive fees starting at 0%.',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Team Section
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
                      ),
                      SizedBox(width: 12.w),
                      _buildTeamMember(
                        name: 'Jane Smith',
                        role: 'CTO',
                        icon: FontAwesomeIcons.userGear,
                      ),
                      SizedBox(width: 12.w),
                      _buildTeamMember(
                        name: 'Alex Brown',
                        role: 'Lead Developer',
                        icon: FontAwesomeIcons.user,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Contact Section
              _buildSectionCard(
                title: 'Get in Touch',
                content: Column(
                  children: [
                    _buildContactItem(
                      icon: Icons.email,
                      text: 'support@flexymarkets.com',
                      onTap: () async {
                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          path: 'support@flexymarkets.com',
                        );
                        if (await canLaunchUrl(emailUri)) {
                          await launchUrl(emailUri);
                        } else {
                          Clipboard.setData(
                            const ClipboardData(
                              text: 'support@flexymarkets.com',
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Email copied to clipboard',
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 12.h),
                    _buildContactItem(
                      icon: Icons.language,
                      text: 'flexymarkets.com',
                      onTap: () async {
                        final Uri url = Uri.parse(
                          'https://www.flexymarkets.com',
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                    ),
                    SizedBox(height: 12.h),
                    _buildContactItem(
                      icon: FontAwesomeIcons.twitter, // Updated to Font Awesome
                      text: '@FlexyMarkets on Twitter',
                      onTap: () async {
                        final Uri url = Uri.parse(
                          'https://twitter.com/FlexyMarkets',
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          content,
        ],
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text,}) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF00685a), size: 20.sp),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14.sp, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required IconData icon,
  }) {
    return Container(
      width: 100.w,
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade800,
            ),
            child: Center(
              child: FaIcon(icon, color: Color(0xFF00685a), size: 30.sp),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            role,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF00685a), size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20.sp),
          ],
        ),
      ),
    );
  }
}
