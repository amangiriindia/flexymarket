import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Community',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white, size: 24.sp),
                  onPressed: () {
                    // TODO: Implement search functionality
                  },
                ),
              ],
            ),

            // Create New Group Button
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              sliver: SliverToBoxAdapter(
                child: _buildCreateGroupButton(),
              ),
            ),

            // Popular Trading Groups
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Popular Trading Groups',
                  style: TextStyle(
                    color: Colors.white,
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
                  ),
                  SizedBox(height: 12.h),
                  _buildGroupTile(
                    icon: Icons.currency_bitcoin,
                    title: 'Crypto Signals',
                    members: '8.7K',
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
                    color: Colors.white,
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
                  ),
                  SizedBox(height: 16.h),
                  _buildPostCard(
                    username: 'Sarah Chen',
                    timeAgo: '5 hours ago',
                    content: 'Market analysis for this week\'s crypto movements 🚀',
                    chartImagePath: 'assets/images/community1.png',
                    likes: 2100,
                    comments: 156,
                  ),
                  SizedBox(height: 16.h),
                  _buildPostCard(
                    username: 'John Smith',
                    timeAgo: '2 hours ago',
                    content: 'Just closed a winning trade! 📈 +15.3% profit on EURUSD',
                    chartImagePath: 'assets/images/community2.png',
                    likes: 2100,
                    comments: 156,
                  ),
                  SizedBox(height: 16.h),
                  _buildPostCard(
                    username: 'Sarah Chen',
                    timeAgo: '5 hours ago',
                    content: 'Market analysis for this week\'s crypto movements 🚀',
                    chartImagePath: 'assets/images/community1.png',
                    likes: 2100,
                    comments: 156,
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

  Widget _buildCreateGroupButton() {
    return ElevatedButton(
      onPressed: () {
        // TODO: Implement create new group functionality
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00685a),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Colors.black, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            'Create New Group',
            style: TextStyle(
              color: Colors.black,
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
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFF00685a).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00685a),
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
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$members members',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement join group functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00685a),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Join',
              style: TextStyle(
                color: Colors.black,
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
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
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: Colors.white70,
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
                color: Colors.white,
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
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white70,
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
                  ),
                  SizedBox(width: 16.w),
                  _buildInteractionIcon(
                    icon: Icons.comment_outlined,
                    count: comments,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.share,
                    color: Colors.white70,
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
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 20.sp,
        ),
        SizedBox(width: 6.w),
        Text(
          count.toString(),
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}