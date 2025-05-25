import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialTradingScreen extends StatefulWidget {
    SocialTradingScreen({super.key});

  @override
  State<SocialTradingScreen> createState() => _SocialTradingScreenState();
}

class _SocialTradingScreenState extends State<SocialTradingScreen> {
  bool isInvestorsView = true;
  double maxLossCap = 5.0;
  String copyAmount = "\$1,000";
  double balancePercentage = 8.6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 16.h),
              _buildSegmentedControl(),
              SizedBox(height: 20.h),
              _buildTradersSection(),
              SizedBox(height: 20.h),
              _buildRiskSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Social Trading',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set to white
          ),
        ),
        IconButton(
          icon: Icon(Icons.settings, color: Colors.white, size: 24.sp), // Added white color
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Settings pressed', style: TextStyle(color: Colors.white))),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSegmentedControl() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isInvestorsView ? Color(0xFF00E676) : Colors.grey.shade800,
              foregroundColor: isInvestorsView ? Colors.white : Colors.white70,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape:   RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
              ),
            ),
            onPressed: () {
              setState(() {
                isInvestorsView = true;
              });
            },
            child: Text(
              'For Investors',
              style: TextStyle(fontSize: 16.sp), // Preserved foregroundColor
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: !isInvestorsView ? Color(0xFF00E676) : Colors.grey.shade800,
              foregroundColor: !isInvestorsView ? Colors.white : Colors.white70,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape:   RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
              ),
            ),
            onPressed: () {
              setState(() {
                isInvestorsView = false;
              });
            },
            child: Text(
              'For Professionals',
              style: TextStyle(fontSize: 16.sp), // Preserved foregroundColor
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTradersSection() {
    if (isInvestorsView) {
      return _buildInvestorsView();
    } else {
      return _buildProfessionalsView();
    }
  }

  Widget _buildInvestorsView() {
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
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set to white
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Filter pressed', style: TextStyle(color: Colors.white))),
                );
              },
              child:   Text(
                'Filter',
                style: TextStyle(color: Color(0xFF00E676)), // Preserved
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
        ),
        SizedBox(height: 12.h),
        _buildTraderCard(
          name: 'Sarah Chen',
          percentage: '+298%',
          winRate: '70%',
          drawdown: '10%',
          followers: '843',
          avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        ),
      ],
    );
  }

  Widget _buildProfessionalsView() {
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
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set to white
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00E676),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Share Strategy pressed', style: TextStyle(color: Colors.white))),
                );
              },
              child: Text(
                'Share Strategy',
                style: TextStyle(fontSize: 14.sp, color: Colors.white), // Set to white
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        _buildPerformanceCard(),
        SizedBox(height: 24.h),
        _buildFollowersSection(),
      ],
    );
  }

  Widget _buildPerformanceCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12.r),
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
                      color: Colors.grey, // Preserved
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '+324%',
                    style: TextStyle(
                      color: Color(0xFF00E676), // Preserved
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Color(0xFF00E676).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '30 days',
                  style: TextStyle(
                    color: Color(0xFF00E676), // Preserved
                    fontWeight: FontWeight.bold,
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
              _MetricColumn(title: 'Win Rate', value: '78%'),
              _MetricColumn(title: 'Drawdown', value: '7.5%'),
              _MetricColumn(title: 'Risk Score', value: 'Medium'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFollowersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Followers',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set to white
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
                      backgroundImage:   NetworkImage('https://randomuser.me/api/portraits/men/71.jpg'),
                    ),
                    Positioned(
                      left: 24.w,
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundImage:   NetworkImage('https://randomuser.me/api/portraits/women/65.jpg'),
                      ),
                    ),
                    Positioned(
                      left: 48.w,
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundImage:   NetworkImage('https://randomuser.me/api/portraits/men/54.jpg'),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 32.w),
                Text(
                  '1,456 followers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.white, // Set to white
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('View All pressed', style: TextStyle(color: Colors.white))),
                );
              },
              child:   Text(
                'View All',
                style: TextStyle(color: Color(0xFF00E676)), // Preserved
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
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12.r),
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
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.white, // Set to white
                        ),
                      ),
                      Text(
                        percentage + ' (30d)',
                        style:   TextStyle(
                          color: Color(0xFF00E676), // Preserved
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00E676),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Copy pressed', style: TextStyle(color: Colors.white))),
                  );
                },
                child: Text(
                  'Copy',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white), // Set to white
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem('Win Rate', winRate),
              _buildMetricItem('Drawdown', drawdown),
              _buildMetricItem('Followers', followers),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400, // Preserved
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white, // Set to white
          ),
        ),
      ],
    );
  }

  Widget _buildRiskSettingsSection() {
    if (!isInvestorsView) return   SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Risk Settings',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set to white
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Maximum Loss Cap',
          style: TextStyle(
            color: Colors.grey, // Preserved
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
                  activeTrackColor: Color(0xFF00E676),
                  inactiveTrackColor: Colors.grey.shade800,
                  thumbColor: Color(0xFF00E676),
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
                color: Color(0xFF00E676), // Preserved
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          'Copy Amount',
          style: TextStyle(
            color: Colors.grey, // Preserved
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                copyAmount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.white, // Set to white
                ),
              ),
              Text(
                '$balancePercentage% of your balance',
                style: TextStyle(
                  color: Colors.grey.shade400, // Preserved
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricColumn extends StatelessWidget {
  final String title;
  final String value;

    _MetricColumn({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade400, // Preserved
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Colors.white, // Set to white
          ),
        ),
      ],
    );
  }
}