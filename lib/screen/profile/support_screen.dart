import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/common_app_bar.dart';
import '../support/my_tickets_screen.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> _faqs = [
    {
      'title': 'How to deposit funds?',
      'content': 'To deposit funds, navigate to the "Wallet" section in the app, select "Deposit", choose your preferred payment method, and follow the instructions to complete the transaction.'
    },
    {
      'title': 'Withdrawal processing time?',
      'content': 'Withdrawal requests are typically processed within 1-3 business days, depending on the payment method and verification status of your account.'
    },
    {
      'title': 'Account verification process',
      'content': 'To verify your account, submit a government-issued ID and proof of address in the "Profile" section. Verification usually takes 24-48 hours.'
    },
  ];

  late List<bool> _expandedStates;
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _expandedStates = List.generate(_faqs.length, (_) => false);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimations = List.generate(
      _faqs.length,
          (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeIn),
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

  void _launchWhatsApp() async {
    // Try WhatsApp deep link first
    final whatsappUrl = Uri.parse('https://wa.me/?text=Support%20Request');
    final fallbackUrl = Uri.parse('https://web.whatsapp.com/');
    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
        _showSuccessSnackBar('Opening WhatsApp');
      } else if (await canLaunchUrl(fallbackUrl)) {
        await launchUrl(fallbackUrl, mode: LaunchMode.platformDefault);
        _showSuccessSnackBar('Opening WhatsApp Web');
      } else {
        _showErrorSnackBar('No WhatsApp or browser found to open the link');
      }
    } catch (e) {
      _showErrorSnackBar('Error launching WhatsApp: $e');
      debugPrint('WhatsApp launch error: $e');
    }
  }

  void _launchEmail() async {
    final emailUrl = Uri.parse('mailto:support@flexymarket.com?subject=Support%20Request');
    try {
      if (await canLaunchUrl(emailUrl)) {
        await launchUrl(emailUrl, mode: LaunchMode.externalApplication);
        _showSuccessSnackBar('Opening email client');
      } else {
        _showErrorSnackBar('No email client found to open the link');
      }
    } catch (e) {
      _showErrorSnackBar('Error launching email: $e');
      debugPrint('Email launch error: $e');
    }
  }

  void _showErrorSnackBar(String message) {
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

  void _showSuccessSnackBar(String message) {
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'Support',
        showBackButton: true,
        onBackPressed: () {
          Navigator.pop(context);
          _showSuccessSnackBar('Returning to Profile');
        },
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Support Availability
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Available 24/7',
                      style: TextStyle(
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search FAQs
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              sliver: SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    _showSuccessSnackBar('Search and filter coming soon!');
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 48.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                          size: 20.sp,
                          semanticLabel: 'Search FAQs',
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Search FAQs...',
                            style: TextStyle(
                              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.filter_list,
                          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                          size: 20.sp,
                          semanticLabel: 'Filter FAQs',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Frequently Asked Questions
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // FAQ Expansion Tiles
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => FadeTransition(
                    opacity: _fadeAnimations[index],
                    child: _buildFAQTile(index, isDarkMode),
                  ),
                  childCount: _faqs.length,
                ),
              ),
            ),

            // Contact Support Buttons
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    // WhatsApp Support Button
                    GestureDetector(
                      onTap: _launchWhatsApp,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat,
                              color: AppColors.white,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Start Chat via WhatsApp',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'End-to-end encrypted',
                      style: TextStyle(
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Email Support Button
                    GestureDetector(
                      onTap: _launchEmail,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Email Support',
                              style: TextStyle(
                                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // My Tickets Button
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyTicketsScreen()),
                      ),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.support_agent,
                              color: AppColors.white,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'View My Tickets',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              semanticsLabel: 'View My Tickets',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Average Response Time
                    Text(
                      'Average response time: 2 minutes',
                      style: TextStyle(
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Secure Transaction Note
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
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile(int index, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
      child: ExpansionTile(
        title: Text(
          _faqs[index]['title']!,
          style: TextStyle(
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          _expandedStates[index] ? Icons.remove : Icons.add,
          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          size: 20.sp,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _expandedStates[index] = expanded;
          });
        },
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Text(
              _faqs[index]['content']!,
              style: TextStyle(
                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
        collapsedBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}