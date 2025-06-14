import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/common_app_bar.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({Key? key}) : super(key: key);

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> with SingleTickerProviderStateMixin {
  final List<PromotionItem> promotions = [
    PromotionItem(
      title: "No Deposit Bonus",
      description: "Get \$50 bonus instantly when you open a new trading account. No deposit required.",
      bonus: "\$50",
      buttonText: "Claim Now",
      badge: "New",
      isBadgeVisible: true,
    ),
    PromotionItem(
      title: "50% Deposit Bonus",
      description: "Get 50% bonus on your first deposit. Maximum bonus up to \$1000.",
      bonus: "50%",
      buttonText: "Claim Now",
      badge: "Popular",
      isBadgeVisible: true,
      additionalInfo: "Minimum deposit \$100",
    ),
    PromotionItem(
      title: "1:1000 Leverage",
      description: "Trade with up to 1:1000 leverage on major forex pairs.",
      bonus: "1:1000",
      buttonText: "Claim Now",
      badge: "Limited",
      isBadgeVisible: true,
      additionalInfo: "High risk trading",
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
      promotions.length,
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
        title: 'Promotions',
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.separated(
                  itemCount: promotions.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _fadeAnimations[index],
                      child: _buildPromotionCard(promotions[index], isDarkMode),
                    );
                  },
                ),
              ),
              _buildFooterNotice(isDarkMode),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionCard(PromotionItem promotion, bool isDarkMode) {
    return GestureDetector(
      onTap: () => _showClaimDialog(promotion.title, isDarkMode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
        transform: Matrix4.identity()..scale(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPromotionHeader(promotion, isDarkMode),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promotion.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    promotion.bonus,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                    ),
                  ),
                  if (promotion.additionalInfo != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        promotion.additionalInfo!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        ),
                      ),
                    ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                        foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: () => _showClaimDialog(promotion.title, isDarkMode),
                      child: Text(
                        promotion.buttonText,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        semanticsLabel: 'Claim ${promotion.title}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionHeader(PromotionItem promotion, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(
            _getIconForPromotion(promotion.title),
            color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            promotion.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
          const Spacer(),
          if (promotion.isBadgeVisible)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                promotion.badge,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFooterNotice(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              "All promotions subject to our terms and conditions. Trading carries significant risks. Please trade responsibly.",
              style: TextStyle(
                fontSize: 12.sp,
                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClaimDialog(String promotionTitle, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          title: Text(
            "Claim $promotionTitle",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
          content: Text(
            "Are you sure you want to claim this promotion? Please review the terms and conditions carefully.",
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
              child: Text(
                "Confirm",
                style: TextStyle(fontSize: 14.sp),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "$promotionTitle claimed successfully!",
                      style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                    ),
                    backgroundColor: AppColors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  IconData _getIconForPromotion(String title) {
    switch (title) {
      case "No Deposit Bonus":
        return Icons.monetization_on_outlined;
      case "50% Deposit Bonus":
        return Icons.percent;
      case "1:1000 Leverage":
        return Icons.trending_up;
      default:
        return Icons.card_giftcard;
    }
  }
}

class PromotionItem {
  final String title;
  final String description;
  final String bonus;
  final String buttonText;
  final String badge;
  final bool isBadgeVisible;
  final String? additionalInfo;

  PromotionItem({
    required this.title,
    required this.description,
    required this.bonus,
    required this.buttonText,
    required this.badge,
    this.isBadgeVisible = false,
    this.additionalInfo,
  });
}