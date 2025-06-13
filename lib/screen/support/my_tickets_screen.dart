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
                SizedBox(height: 20.h),
                Text(
                  'My Tickets',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                _buildSearchBar(isDarkMode),
                SizedBox(height: 16.h),
                _buildListHeader(isDarkMode),
                SizedBox(height: 8.h),
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

  Widget _buildListHeader(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Text(
              'Serial No.',
              style: TextStyle(
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              'Enquiry Type',
              style: TextStyle(
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Text(
              'Ticket ID',
              style: TextStyle(
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Text(
              'Title',
              style: TextStyle(
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Text(
              'Status',
              style: TextStyle(
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              'Last Updated',
              style: TextStyle(
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(
            flex: 1,
            child: Text(
              'Action',
              style: TextStyle(
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TicketDetailsScreen(ticket: ticket)),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: isDarkMode
              ? null
              : [
            BoxShadow(
              color: AppColors.lightShadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        transform: Matrix4.identity()..scale(1.0),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 40.w),
                  child: Text(
                    ticket['serialNo'].toString(),
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 80.w),
                  child: Text(
                    ticket['enquiryType'],
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      fontSize: 14.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 60.w),
                  child: Text(
                    ticket['ticketId'],
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 100.w),
                  child: Text(
                    ticket['title'],
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      fontSize: 14.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 60.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: ticket['status'] == 'Closed' ? AppColors.green : AppColors.red,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      ticket['status'],
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 80.w),
                  child: Text(
                    ticket['lastUpdated'],
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 40.w),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TicketDetailsScreen(ticket: ticket)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                      foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      minimumSize: Size(40.w, 32.h),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: Text(
                      'View',
                      style: TextStyle(fontSize: 12.sp),
                      semanticsLabel: 'View Ticket ${ticket['ticketId']}',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}