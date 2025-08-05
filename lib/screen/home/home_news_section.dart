import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';

class HomeNewsSection extends StatefulWidget {
  const HomeNewsSection({super.key});

  @override
  State<HomeNewsSection> createState() => _HomeNewsSectionState();
}

class _HomeNewsSectionState extends State<HomeNewsSection> {
  List<dynamic> newsItems = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    try {
      final response = await http.get(
        Uri.parse('https://backend.axiontrust.com/news/news/?page=1&limit=10'),
      );
      if (response.statusCode == 200) {
        setState(() {
          newsItems = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load news: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching news: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _launchNewsUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch news website')),
      );
    }
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDarkMode
                ? AppColors.darkSecondaryText
                : AppColors.lightSecondaryText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        GestureDetector(
          onTap: () => _launchNewsUrl('https://flexymarkets.com/'),
          child: Text(
            'Show more',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsItem(
      String title,
      String subtitle,
      bool isDarkMode,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow: isDarkMode
              ? null
              : [
            BoxShadow(
              color: AppColors.lightShadow,
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.article, color: AppColors.orange, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? AppColors.white : Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDarkMode
                          ? AppColors.darkSecondary
                          : AppColors.lightSecondary,
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(
      children: [
        _buildSectionHeader('TOP NEWS', isDarkMode),
        SizedBox(height: 12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 0.w),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
            child: Text(
              errorMessage!,
              style: TextStyle(
                fontSize: 14.sp,
                color: isDarkMode
                    ? AppColors.darkSecondaryText
                    : AppColors.lightSecondaryText,
              ),
            ),
          )
              : Column(
            children: newsItems.map((news) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildNewsItem(
                  news['headline'],
                  '${news['source']} • ${news['time']}',
                  isDarkMode,
                      () => _launchNewsUrl(news['url']),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}