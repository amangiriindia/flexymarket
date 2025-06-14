import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Search and filter coming soon!',
                          style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                        ),
                        backgroundColor: AppColors.green,
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()..scale(1.0),
                    height: 48.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
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
                    fontSize: 16.sp,
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
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'WhatsApp chat coming soon!',
                              style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                            ),
                            backgroundColor: AppColors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.whatsapp,
                            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Start Chat via WhatsApp',
                            style: TextStyle(
                              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Email Support Button
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Email support coming soon!',
                              style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                            ),
                            backgroundColor: AppColors.green,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        side: BorderSide(
                          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                          width: 1.w,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
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
                    SizedBox(height: 16.h),

                    // My Tickets Button
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyTicketsScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.support_agent,
                            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'View My Tickets',
                            style: TextStyle(
                              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            semanticsLabel: 'View My Tickets',
                          ),
                        ],
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
                    SizedBox(height: 100.h), // Space for consistency
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
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          _faqs[index]['title']!,
          style: TextStyle(
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          _expandedStates[index] ? Icons.remove : Icons.add,
          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
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
                fontSize: 12.sp,
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