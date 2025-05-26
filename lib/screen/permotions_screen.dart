import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({Key? key}) : super(key: key);

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  // Promotions data
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              SizedBox(height: 16.h),

              // Promotions List
              Expanded(
                child: ListView.separated(
                  itemCount: promotions.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    return _buildPromotionCard(promotions[index]);
                  },
                ),
              ),

              // Footer Notice
              _buildFooterNotice(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, size: 24.sp),
          onPressed: () {
            // Handle back navigation
            Navigator.of(context).pop();
          },
        ),
        SizedBox(width: 8.w),
        Text(
          "Promotions",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionCard(PromotionItem promotion) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Promotion Header with Badge
          _buildPromotionHeader(promotion),

          // Promotion Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  promotion.description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 12.h),

                // Bonus Amount
                Text(
                  promotion.bonus,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color:Color(0xFF00685a),
                  ),
                ),

                // Additional Info if exists
                if (promotion.additionalInfo != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      promotion.additionalInfo!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                SizedBox(height: 16.h),

                // Claim Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00685a),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () {
                      // Handle claim action
                      _showClaimDialog(promotion.title);
                    },
                    child: Text(
                      promotion.buttonText,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionHeader(PromotionItem promotion) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),

      child: Row(
        children: [
          Icon(
            _getIconForPromotion(promotion.title),
            color: Color(0xFF00685a),
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            promotion.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          if (promotion.isBadgeVisible)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Color(0xFF00685a),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                promotion.badge,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFooterNotice() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              "All promotions subject to our terms and conditions. Trading carries significant risks. Please trade responsibly.",
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClaimDialog(String promotionTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Claim $promotionTitle"),
          content: Text(
            "Are you sure you want to claim this promotion? "
                "Please review the terms and conditions carefully.",
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00685a),
              ),
              child: const Text("Confirm"),
              onPressed: () {
                // Implement claim logic
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$promotionTitle claimed successfully!"),
                    backgroundColor:Color(0xFF00685a),
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