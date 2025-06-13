import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/main_app_bar.dart';


class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const CommonAppBar(
        title: 'Community',
        showBackButton: false,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Create New Group Button
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              sliver: SliverToBoxAdapter(
                child: _buildCreateGroupButton(isDarkMode),
              ),
            ),

            // Popular Trading Groups
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Popular Trading Groups',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildGroupTile(
                    icon: Icons.trending_up,
                    title: 'Day Traders Pro',
                    members: '15.2K',
                    isDarkMode: isDarkMode,
                  ),
                  SizedBox(height: 12.h),
                  _buildGroupTile(
                    icon: Icons.currency_bitcoin,
                    title: 'Crypto Signals',
                    members: '8.7K',
                    isDarkMode: isDarkMode,
                  ),
                ]),
              ),
            ),

            // Latest Posts Title
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Text(
                  'Latest Posts',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Posts
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildPostCard(
                    username: 'Aman Giri',
                    timeAgo: '2 hours ago',
                    content: 'Just closed a winning trade! 📈 +15.3% profit on EURUSD',
                    chartImagePath: 'assets/images/community2.png',
                    likes: 2100,
                    comments: 156,
                    isDarkMode: isDarkMode,
                  ),
                  SizedBox(height: 16.h),
                  _buildPostCard(
                    username: 'Sarah Chen',
                    timeAgo: '5 hours ago',
                    content: 'Market analysis for this week\'s crypto movements 🚀',
                    chartImagePath: 'assets/images/community1.png',
                    likes: 2100,
                    comments: 156,
                    isDarkMode: isDarkMode,
                  ),
                  _buildPostCard(
                    username: 'John Smith',
                    timeAgo: '2 hours ago',
                    content: 'Just closed a winning trade! 📈 +15.3% profit on EURUSD',
                    chartImagePath: 'assets/images/community2.png',
                    likes: 2100,
                    comments: 156,
                    isDarkMode: isDarkMode,
                  ),
                  _buildPostCard(
                    username: 'Sarah Chen',
                    timeAgo: '5 hours ago',
                    content: 'Market analysis for this week\'s crypto movements 🚀',
                    chartImagePath: 'assets/images/community1.png',
                    likes: 2100,
                    comments: 156,
                    isDarkMode: isDarkMode,
                  ),
                  SizedBox(height: 16.h),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateGroupButton(bool isDarkMode) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Create New Group functionality coming soon!')),
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
          Icon(Icons.add, color: AppColors.white, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            'Create New Group',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupTile({
    required IconData icon,
    required String title,
    required String members,
    required bool isDarkMode,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: isDarkMode ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
        boxShadow: isDarkMode
            ? null
            : [
          BoxShadow(
            color: AppColors.lightShadow,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$members members',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Join Group functionality coming soon!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Join',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard({
    required String username,
    required String timeAgo,
    required String content,
    required String chartImagePath,
    int? likes,
    int? comments,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: isDarkMode ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
        boxShadow: isDarkMode
            ? null
            : [
          BoxShadow(
            color: AppColors.lightShadow,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: const NetworkImage(
                    'https://via.placeholder.com/40',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Post Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              content,
              style: TextStyle(
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                fontSize: 14.sp,
              ),
            ),
          ),

          // Chart Image
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                chartImagePath,
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200.h,
                    color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Interaction Icons
          if (likes != null && comments != null)
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  _buildInteractionIcon(
                    icon: Icons.favorite_border,
                    count: likes,
                    isDarkMode: isDarkMode,
                  ),
                  SizedBox(width: 16.w),
                  _buildInteractionIcon(
                    icon: Icons.comment_outlined,
                    count: comments,
                    isDarkMode: isDarkMode,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.share,
                    color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInteractionIcon({
    required IconData icon,
    required int count,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          size: 20.sp,
        ),
        SizedBox(width: 6.w),
        Text(
          count.toString(),
          style: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}