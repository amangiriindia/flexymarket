import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constant/app_color.dart';
import '../../../providers/theme_provider.dart';
import '../../../widget/common/common_app_bar.dart';

class SocialTradingScreen extends StatefulWidget {
  const SocialTradingScreen({super.key});

  @override
  State<SocialTradingScreen> createState() => _SocialTradingScreenState();
}

class _SocialTradingScreenState extends State<SocialTradingScreen> with SingleTickerProviderStateMixin {
  bool isInvestorsView = true;
  double maxLossCap = 5.0;
  String copyAmount = "\$1,000";
  double balancePercentage = 8.6;

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
      3,
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
      appBar: AppBar(
        title: Text('Social Trading'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Returning to Profile',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: 24.sp),
            color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Opening Settings',
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  backgroundColor: AppColors.green,
                ),
              );
            },
            tooltip: 'Settings',
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeTransition(
                opacity: _fadeAnimations[0],
                child: _buildSegmentedControl(isDarkMode),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeTransition(
                        opacity: _fadeAnimations[1],
                        child: _buildTradersSection(isDarkMode),
                      ),
                      SizedBox(height: 20.h),
                      FadeTransition(
                        opacity: _fadeAnimations[2],
                        child: _buildRiskSettingsSection(isDarkMode),
                      ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isInvestorsView = true;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: isInvestorsView
                    ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                    : (isDarkMode ? AppColors.darkSurface : AppColors.lightSurface),
                borderRadius: BorderRadius.horizontal(left: Radius.circular(12.r)),
              ),
              child: Center(
                child: Text(
                  'For Investors',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isInvestorsView
                        ? (isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText)
                        : (isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                    fontWeight: FontWeight.w600,
                  ),
                  semanticsLabel: 'Select Investors View',
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isInvestorsView = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: !isInvestorsView
                    ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                    : (isDarkMode ? AppColors.darkSurface : AppColors.lightSurface),
                borderRadius: BorderRadius.horizontal(right: Radius.circular(12.r)),
              ),
              child: Center(
                child: Text(
                  'For Professionals',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: !isInvestorsView
                        ? (isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText)
                        : (isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                    fontWeight: FontWeight.w600,
                  ),
                  semanticsLabel: 'Select Professionals View',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTradersSection(bool isDarkMode) {
    return isInvestorsView ? _buildInvestorsView(isDarkMode) : _buildProfessionalsView(isDarkMode);
  }

  Widget _buildInvestorsView(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Traders',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Opening Filters',
                      style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                    ),
                    backgroundColor: AppColors.green,
                  ),
                );
              },
              child: Text(
                'Filter',
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  fontSize: 14.sp,
                ),
                semanticsLabel: 'Filter traders',
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildTraderCard(
          name: 'Alex Thompson',
          percentage: '+457%',
          winRate: '76%',
          drawdown: '8.2%',
          followers: '1.2K',
          avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
          index: 0,
          isDarkMode: isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildTraderCard(
          name: 'Sarah Chen',
          percentage: '+298%',
          winRate: '70%',
          drawdown: '10%',
          followers: '843',
          avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
          index: 1,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildProfessionalsView(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Performance',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Strategy shared successfully',
                      style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                    ),
                    backgroundColor: AppColors.green,
                  ),
                );
              },
              child: Text(
                'Share Strategy',
                style: TextStyle(fontSize: 14.sp),
                semanticsLabel: 'Share Strategy',
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        _buildPerformanceCard(isDarkMode),
        SizedBox(height: 24.h),
        _buildFollowersSection(isDarkMode),
      ],
    );
  }

  Widget _buildPerformanceCard(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Profit',
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '+324%',
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '30 days',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MetricColumn(
                title: 'Win Rate',
                value: '78%',
                isDarkMode: isDarkMode,
              ),
              _MetricColumn(
                title: 'Drawdown',
                value: '7.5%',
                isDarkMode: isDarkMode,
              ),
              _MetricColumn(
                title: 'Risk Score',
                value: 'Medium',
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ],
      ),

    );
  }

  Widget _buildFollowersSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Followers',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundImage: const NetworkImage('https://randomuser.me/api/portraits/men/71.jpg'),
                      onBackgroundImageError: (_, __) => const Icon(Icons.person),
                    ),
                    Positioned(
                      left: 24.w,
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundImage: const NetworkImage('https://randomuser.me/api/portraits/women/65.jpg'),
                        onBackgroundImageError: (_, __) => const Icon(Icons.person),
                      ),
                    ),
                    Positioned(
                      left: 48.w,
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundImage: const NetworkImage('https://randomuser.me/api/portraits/men/54.jpg'),
                        onBackgroundImageError: (_, __) => const Icon(Icons.person),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 32.w),
                Text(
                  '1,456 followers',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Opening Followers List',
                      style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                    ),
                    backgroundColor: AppColors.green,
                  ),
                );
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  fontSize: 14.sp,
                ),
                semanticsLabel: 'View All Followers',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTraderCard({
    required String name,
    required String percentage,
    required String winRate,
    required String drawdown,
    required String followers,
    required String avatarUrl,
    required int index,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: () {
        _showTraderProfileDialog(name, isDarkMode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(1.0),
        padding: EdgeInsets.all(16.w),
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundImage: NetworkImage(avatarUrl),
                      onBackgroundImageError: (_, __) => const Icon(Icons.person),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                        ),
                        Text(
                          '$percentage (30d)',
                          style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                    foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Copied $name\'s strategy',
                          style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                        ),
                        backgroundColor: AppColors.green,
                      ),
                    );
                  },
                  child: Text(
                    'Copy',
                    style: TextStyle(fontSize: 14.sp),
                    semanticsLabel: 'Copy $name',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricItem('Win Rate', winRate, isDarkMode),
                _buildMetricItem('Drawdown', drawdown, isDarkMode),
                _buildMetricItem('Followers', followers, isDarkMode),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, bool isDarkMode) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildRiskSettingsSection(bool isDarkMode) {
    if (!isInvestorsView) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Risk Settings',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Maximum Loss Cap',
          style: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
                  activeTrackColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  inactiveTrackColor: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
                  thumbColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  overlayColor: (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent).withOpacity(0.2),
                ),
                child: Slider(
                  min: 1,
                  max: 20,
                  value: maxLossCap,
                  onChanged: (value) {
                    setState(() {
                      maxLossCap = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '${maxLossCap.toInt()}%',
              style: TextStyle(
                color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          'Copy Amount',
          style: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(8.r),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                copyAmount,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
              Text(
                '$balancePercentage% of your balance',
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showTraderProfileDialog(String name, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          title: Text(
            '$name\'s Profile',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
          content: Text(
            'View detailed performance, trading history, and strategies for $name. (Coming soon)',
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  fontSize: 14.sp,
                ),
                semanticsLabel: 'Close Dialog',
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Copied $name\'s strategy',
                      style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                    ),
                    backgroundColor: AppColors.green,
                  ),
                );
              },
              child: Text(
                'Copy Strategy',
                style: TextStyle(fontSize: 14.sp),
                semanticsLabel: 'Copy $name\'s Strategy',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MetricColumn extends StatelessWidget {
  final String title;
  final String value;
  final bool isDarkMode;

  const _MetricColumn({
    required this.title,
    required this.value,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ),
      ],
    );
  }
}