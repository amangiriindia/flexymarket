
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/common_app_bar.dart';
import 'my_tickets_screen.dart';

class TicketDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> ticket;

  const TicketDetailsScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'Ticket Details',
        showBackButton: true,
        onBackPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Returning to My Tickets',
                style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
              ),
            ),
          );
        },
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
                  'Ticket Details',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                Card(
                  color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                  elevation: isDarkMode ? 0 : 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Ticket ID', ticket['ticketId'], isDarkMode),
                        SizedBox(height: 12.h),
                        _buildDetailRow('Enquiry Type', ticket['enquiryType'], isDarkMode),
                        SizedBox(height: 12.h),
                        _buildDetailRow('Title', ticket['title'], isDarkMode),
                        SizedBox(height: 12.h),
                        _buildDetailRow(
                          'Status',
                          ticket['status'],
                          isDarkMode,
                          valueWidget: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: ticket['status'] == 'Resolved' ? AppColors.green : AppColors.red,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              ticket['status'],
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildDetailRow(
                          'Priority',
                          'High', // Mocked, replace with actual data
                          isDarkMode,
                          valueWidget: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'High',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildDetailRow('Last Updated', ticket['lastUpdated'], isDarkMode),
                        SizedBox(height: 12.h),
                        _buildDetailRow(
                          'Description',
                          'Detailed problem description...', // Mocked, replace with actual data
                          isDarkMode,
                          isMultiline: true,
                        ),
                        if (ticket['status'] != 'Resolved') ...[
                          SizedBox(height: 24.h),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Ticket closed successfully',
                                    style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                                  ),
                                  backgroundColor: AppColors.green,
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const MyTicketsScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                              foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                              minimumSize: Size(double.infinity, 50.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                              elevation: isDarkMode ? 0 : 2,
                              shadowColor: AppColors.lightShadow,
                            ),
                            child: Text(
                              'Close Ticket',
                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                              semanticsLabel: 'Close Ticket',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDarkMode, {Widget? valueWidget, bool isMultiline = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150.w,
          child: Text(
            label,
            style: TextStyle(
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: valueWidget ??
              Text(
                value,
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  fontSize: 16.sp,
                ),
                maxLines: isMultiline ? null : 1,
                overflow: isMultiline ? null : TextOverflow.ellipsis,
              ),
        ),
      ],
    );
  }
}