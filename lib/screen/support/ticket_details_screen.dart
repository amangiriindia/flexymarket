import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../service/support_service.dart';
import '../../widget/common/common_app_bar.dart';
import 'my_tickets_screen.dart';

class TicketDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> ticket;

  const TicketDetailsScreen({super.key, required this.ticket});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  final SupportService _supportService = SupportService();
  Map<String, dynamic>? _ticketDetails;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTicketDetails();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _fetchTicketDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _supportService.fetchTicketDetails(int.parse(widget.ticket['ticketId'].replaceAll('TCK', '')));
      if (response['status'] == true) {
        setState(() {
          _ticketDetails = {
            'ticketId': widget.ticket['ticketId'],
            'enquiryType': widget.ticket['enquiryType'],
            'title': response['data']['subject'],
            'status': response['data']['status'],
            'priority': response['data']['priority'],
            'messages': List<Map<String, dynamic>>.from(response['data']['message']),
            'lastUpdated': response['data']['updatedAt'].split('T')[0],
          };
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = response['message'] ?? 'Failed to fetch ticket details';
        });
        _showSnackBar(_errorMessage!, AppColors.red, retry: true);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().contains('EACCES')
            ? 'Server error: Unable to process request. Please try again or contact support.'
            : e.toString();
      });
      _showSnackBar(_errorMessage!, AppColors.red, retry: true);
    }
  }

  Future<void> _closeTicket() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await _supportService.closeTicket(int.parse(widget.ticket['ticketId'].replaceAll('TCK', '')));
      if (response['status'] == true) {
        _showSnackBar('Ticket closed successfully', AppColors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyTicketsScreen()),
        );
      } else {
        setState(() {
          _isSubmitting = false;
        });
        _showSnackBar(response['message'] ?? 'Failed to close ticket', AppColors.red, retry: true);
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      final errorMessage = e.toString().contains('EACCES')
          ? 'Server error: Unable to process request. Please try again or contact support.'
          : e.toString();
      _showSnackBar(errorMessage, AppColors.red, retry: true);
    }
  }

  Future<void> _sendReply() async {
    if (_replyController.text.trim().isEmpty) {
      _showSnackBar('Please enter a reply message', AppColors.red);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await _supportService.sendReply(
        int.parse(widget.ticket['ticketId'].replaceAll('TCK', '')),
        _replyController.text.trim(),
      );
      if (response['status'] == true) {
        setState(() {
          _ticketDetails!['messages'].add({
            'sender': 'user',
            'text': _replyController.text.trim(),
            'time': response['data']['updatedAt'],
          });
          _ticketDetails!['lastUpdated'] = response['data']['updatedAt'].split('T')[0];
          _replyController.clear();
          _isSubmitting = false;
        });
        _showSnackBar('Reply sent successfully', AppColors.green);
      } else {
        setState(() {
          _isSubmitting = false;
        });
        _showSnackBar(response['message'] ?? 'Failed to send reply', AppColors.red, retry: true);
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      final errorMessage = e.toString().contains('EACCES')
          ? 'Server error: Unable to process request. Please try again or contact support.'
          : e.toString();
      _showSnackBar(errorMessage, AppColors.red, retry: true);
    }
  }

  void _showSnackBar(String message, Color backgroundColor, {bool retry = false}) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            fontSize: 14.sp,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        action: retry
            ? SnackBarAction(
          label: 'Retry',
          textColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
          onPressed: _fetchTicketDetails,
        )
            : null,
      ),
    );
  }

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
          _showSnackBar('Returning to My Tickets', AppColors.green);
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
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
                    if (_isLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                          strokeWidth: 3,
                        ),
                      )
                    else if (_errorMessage != null)
                      Column(
                        children: [
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 16.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: _fetchTicketDetails,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                              foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            ),
                            child: Text(
                              'Retry',
                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                            elevation: isDarkMode ? 0 : 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow('Ticket ID', _ticketDetails!['ticketId'], isDarkMode),
                                  SizedBox(height: 12.h),
                                  _buildDetailRow('Enquiry Type', _ticketDetails!['enquiryType'], isDarkMode),
                                  SizedBox(height: 12.h),
                                  _buildDetailRow('Title', _ticketDetails!['title'], isDarkMode),
                                  SizedBox(height: 12.h),
                                  _buildDetailRow(
                                    'Status',
                                    _ticketDetails!['status'],
                                    isDarkMode,
                                    valueWidget: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: _ticketDetails!['status'] == 'CLOSED'
                                            ? AppColors.green
                                            : _ticketDetails!['status'] == 'OPEN'
                                            ? AppColors.red
                                            : AppColors.yellow,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        _ticketDetails!['status'],
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
                                    _ticketDetails!['priority'],
                                    isDarkMode,
                                    valueWidget: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: _ticketDetails!['priority'] == 'HIGH'
                                            ? AppColors.red
                                            : _ticketDetails!['priority'] == 'MEDIUM'
                                            ? AppColors.yellow
                                            : AppColors.green,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        _ticketDetails!['priority'],
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildDetailRow('Last Updated', _ticketDetails!['lastUpdated'], isDarkMode),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Messages',
                            style: TextStyle(
                              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _ticketDetails!['messages'].length,
                            itemBuilder: (context, index) {
                              final message = _ticketDetails!['messages'][index];
                              final isUser = message['sender'] == 'user';
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Align(
                                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: 250.w),
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                                          : (isDarkMode ? AppColors.darkCard : AppColors.lightCard),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message['text'],
                                          style: TextStyle(
                                            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          message['time'].split('T')[0],
                                          style: TextStyle(
                                            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 16.h),
                          if (_ticketDetails!['status'] != 'CLOSED') ...[
                            TextField(
                              controller: _replyController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Type your reply...',
                                hintStyle: TextStyle(
                                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                                  fontSize: 14.sp,
                                ),
                                filled: true,
                                fillColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                suffixIcon: IconButton(
                                  onPressed: _isSubmitting ? null : _sendReply,
                                  icon: Icon(
                                    Icons.send,
                                    color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: _isSubmitting ? null : _closeTicket,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                                foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                                minimumSize: Size(double.infinity, 50.h),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                elevation: isDarkMode ? 0 : 2,
                                shadowColor: AppColors.lightShadow,
                              ),
                              child: _isSubmitting
                                  ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                                ),
                              )
                                  : Text(
                                'Close Ticket',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                                semanticsLabel: 'Close Ticket',
                              ),
                            ),
                          ],
                          SizedBox(height: 20.h),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            if (_isLoading || _isSubmitting)
              Container(
                color: isDarkMode ? AppColors.darkBackground.withOpacity(0.7) : AppColors.lightBackground.withOpacity(0.7),
                child: Center(
                  child: CircularProgressIndicator(
                    color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                    strokeWidth: 3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDarkMode, {Widget? valueWidget}) {
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
        ),
      ],
    );
  }
}