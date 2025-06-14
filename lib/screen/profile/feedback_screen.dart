import 'package:flexy_markets/screen/profile/support_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constant/app_color.dart';
import '../../../providers/theme_provider.dart';
import '../../../widget/common/common_app_bar.dart';


class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> with SingleTickerProviderStateMixin {
  int rating = 3;
  final TextEditingController feedbackController = TextEditingController();
  bool tradingFeaturesSelected = false;
  bool performanceSelected = false;
  bool uiUxSelected = false;
  bool securitySelected = false;
  bool canContact = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'Feedback',
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      Text(
                        'How would you rate your experience?',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildStarRating(isDarkMode),
                      SizedBox(height: 24.h),
                      _buildFeedbackInput(isDarkMode),
                      SizedBox(height: 24.h),
                      _buildCategorySelection(isDarkMode),
                      SizedBox(height: 24.h),
                      _buildContactPermission(isDarkMode),
                      SizedBox(height: 24.h),
                      _buildSubmitButton(isDarkMode),
                      SizedBox(height: 16.h),
                      _buildSupportLink(isDarkMode),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              rating = index + 1;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(right: 8.w),
            transform: Matrix4.identity()..scale(index < rating ? 1.0 : 0.95),
            child: Icon(
              Icons.star,
              size: 36.sp,
              color: index < rating
                  ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                  : (isDarkMode ? AppColors.darkSurface : AppColors.lightSurface),
              semanticLabel: 'Rate ${index + 1} stars',
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFeedbackInput(bool isDarkMode) {
    return Container(
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
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What could we improve?',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TextField(
              controller: feedbackController,
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                hintStyle: TextStyle(
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  fontSize: 16.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelection(bool isDarkMode) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCategoryButton(
                icon: Icons.trending_up,
                label: 'Trading\nFeatures',
                isSelected: tradingFeaturesSelected,
                onTap: () {
                  setState(() {
                    tradingFeaturesSelected = !tradingFeaturesSelected;
                  });
                },
                isDarkMode: isDarkMode,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildCategoryButton(
                icon: Icons.speed,
                label: 'Performance',
                isSelected: performanceSelected,
                onTap: () {
                  setState(() {
                    performanceSelected = !performanceSelected;
                  });
                },
                isDarkMode: isDarkMode,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildCategoryButton(
                icon: Icons.design_services,
                label: 'UI/UX\nDesign',
                isSelected: uiUxSelected,
                onTap: () {
                  setState(() {
                    uiUxSelected = !uiUxSelected;
                  });
                },
                isDarkMode: isDarkMode,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildCategoryButton(
                icon: Icons.shield,
                label: 'Security',
                isSelected: securitySelected,
                onTap: () {
                  setState(() {
                    securitySelected = !securitySelected;
                  });
                },
                isDarkMode: isDarkMode,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected
              ? Border.all(color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent, width: 1.w)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: isSelected
                  ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                  : (isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: isSelected
                    ? (isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText)
                    : (isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactPermission(bool isDarkMode) {
    return Container(
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          SizedBox(
            width: 24.w,
            height: 24.w,
            child: Checkbox(
              value: canContact,
              onChanged: (value) {
                setState(() {
                  canContact = value ?? false;
                });
              },
              activeColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
              semanticLabel: 'Allow contact for feedback',
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'May we contact you about your feedback?',
              style: TextStyle(
                fontSize: 14.sp,
                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (feedbackController.text.isEmpty ||
              !(tradingFeaturesSelected || performanceSelected || uiUxSelected || securitySelected)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Please fill all required fields',
                  style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                ),
                backgroundColor: AppColors.red,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Feedback submitted successfully!',
                  style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                ),
                backgroundColor: AppColors.green,
              ),
            );
            feedbackController.clear();
            setState(() {
              rating = 3;
              tradingFeaturesSelected = false;
              performanceSelected = false;
              uiUxSelected = false;
              securitySelected = false;
              canContact = false;
            });
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
          'Submit Feedback',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          semanticsLabel: 'Submit Feedback',
        ),
      ),
    );
  }

  Widget _buildSupportLink(bool isDarkMode) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SupportScreen()),
        ),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
            children: [
              const TextSpan(text: 'Need immediate help? '),
              TextSpan(
                text: 'Contact Support',
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}