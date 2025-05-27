import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int rating = 3;
  final TextEditingController feedbackController = TextEditingController();

  // Category selection state
  bool tradingFeaturesSelected = false;
  bool performanceSelected = false;
  bool uiUxSelected = false;
  bool securitySelected = false;

  // Contact permission
  bool canContact = false;

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),

            // Main content in a scrollable area
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // Rating section
                    Text(
                      'How would you rate your experience?',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildStarRating(),
                    SizedBox(height: 24.h),

                    // Feedback input section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'What could we improve?',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[400],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: TextField(
                              controller: feedbackController,
                              style: TextStyle(fontSize: 16.sp),
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: 'Share your thoughts...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16.sp,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16.w),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Category selection
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
                            label: 'UI/UX Design',
                            isSelected: uiUxSelected,
                            onTap: () {
                              setState(() {
                                uiUxSelected = !uiUxSelected;
                              });
                            },
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
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Contact permission
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.r),
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
                              activeColor: Color(0xFF00685a),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'May we contact you about your feedback?',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Submit feedback logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00685a),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Submit Feedback',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Support link
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[400],
                          ),
                          children: [
                            const TextSpan(text: 'Need immediate help? '),
                            TextSpan(
                              text: 'Contact Support',
                              style: TextStyle(
                                color: Color(0xFF00685a),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, size: 24.w),
              ),
              SizedBox(width: 24.w),
              Text(
                'Feedback',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ],
          ),
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Color(0xFF00685a)),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(
              Icons.help_outline,
              color: Color(0xFF00685a),
              size: 20.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              rating = index + 1;
            });
          },
          child: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Icon(
              Icons.star,
              size: 32.w,
              color: index < rating
                  ? Color(0xFF00685a)
                  : Colors.grey.shade800,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCategoryButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.grey.shade800
              : Colors.grey.shade900.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected
              ? Border.all(color: Color(0xFF00685a), width: 1)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24.w,
              color: isSelected
                  ? Color(0xFF00685a)
                  : Colors.grey,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}