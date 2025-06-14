import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/common_app_bar.dart';
import 'create_ticket_screen.dart';
import 'ticket_details_screen.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _allTickets = [
    {
      'serialNo': 1,
      'enquiryType': 'General Inquiry',
      'ticketId': 'TCK12345',
      'title': 'Account Verification Issue',
      'status': 'Closed',
      'lastUpdated': '2024-02-28',
    },
    {
      'serialNo': 2,
      'enquiryType': 'Technical Support',
      'ticketId': 'TCK12346',
      'title': 'Platform Login Error',
      'status': 'Closed',
      'lastUpdated': '2024-02-27',
    },
    {
      'serialNo': 3,
      'enquiryType': 'Payment Issue',
      'ticketId': 'TCK12347',
      'title': 'Deposit Not Reflected',
      'status': 'Closed',
      'lastUpdated': '2024-02-26',
    },
    {
      'serialNo': 4,
      'enquiryType': 'Trading Issue',
      'ticketId': 'TCK12348',
      'title': 'Order Execution Delay',
      'status': 'Open',
      'lastUpdated': '2024-02-25',
    },
    {
      'serialNo': 5,
      'enquiryType': 'Withdrawal Inquiry',
      'ticketId': 'TCK12349',
      'title': 'Withdrawal Request Pending',
      'status': 'Open',
      'lastUpdated': '2024-02-24',
    },
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
      _allTickets.length,
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
        title: 'My Tickets',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateTicketScreen()),
        ),
        backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
        foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: const Icon(Icons.add, semanticLabel: 'Create New Ticket'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                _buildSearchBar(isDarkMode),
                SizedBox(height: 16.h),
                _allTickets.isEmpty
                    ? _buildEmptyState(isDarkMode)
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _allTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = _allTickets[index];
                    return FadeTransition(
                      opacity: _fadeAnimations[index],
                      child: _buildTicketCard(ticket, isDarkMode),
                    );
                  },
                ),
                SizedBox(height: 100.h), // Space for FAB
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return GestureDetector(
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
              semanticLabel: 'Search Tickets',
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Search tickets...',
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
              semanticLabel: 'Filter Tickets',
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            size: 40.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'No tickets found',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateTicketScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              minimumSize: Size(120.w, 40.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Text(
              'Create Ticket',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              semanticsLabel: 'Create New Ticket',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket, bool isDarkMode) {
    final textColor = isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText;
    final cardColor = isDarkMode ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TicketDetailsScreen(ticket: ticket)),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
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
            // Row 1: Title
            Text(
              ticket['title'],
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),

            // Row 2: Status and Date
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: ticket['status'] == 'Closed' ? AppColors.green : AppColors.red,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    ticket['status'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.calendar_today, size: 14.sp, color: textColor),
                SizedBox(width: 4.w),
                Text(
                  ticket['lastUpdated'],
                  style: TextStyle(fontSize: 12.sp, color: textColor),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Row 3: Other Info
            Wrap(
              spacing: 16.w,
              runSpacing: 8.h,
              children: [
                _buildInfoItem(Icons.confirmation_number, 'ID', ticket['ticketId'], textColor),
                _buildInfoItem(Icons.question_answer, 'Enquiry', ticket['enquiryType'], textColor),
                _buildInfoItem(Icons.numbers, 'Serial', ticket['serialNo'].toString(), textColor),
              ],
            ),
            SizedBox(height: 12.h),

            // Row 4: View Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TicketDetailsScreen(ticket: ticket)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  foregroundColor: textColor,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                icon: Icon(Icons.visibility, size: 16.sp),
                label: Text(
                  'View',
                  style: TextStyle(fontSize: 13.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: textColor),
        SizedBox(width: 4.w),
        Text(
          '$label: $value',
          style: TextStyle(fontSize: 13.sp, color: textColor),
        ),
      ],
    );
  }


}