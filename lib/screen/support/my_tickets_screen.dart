
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../service/apiservice/support_service.dart';
import '../../widget/common/common_app_bar.dart';
import 'create_ticket_screen.dart';
import 'ticket_details_screen.dart';

class MyTicketsScreen extends StatefulWidget {
const MyTicketsScreen({super.key});

@override
State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> with SingleTickerProviderStateMixin {
final SupportService _supportService = SupportService();
String _selectedStatus = 'All';
final List<String> _statusFilters = ['All', 'Open', 'Closed', 'Processing'];
List<Map<String, dynamic>> _allTickets = [];
bool _isLoading = false;
String? _errorMessage;

late AnimationController _animationController;
late List<Animation<double>> _fadeAnimations;

@override
void initState() {
super.initState();
_fetchTickets();
_animationController = AnimationController(
duration: const Duration(milliseconds: 300),
vsync: this,
);
_fadeAnimations = List.generate(
10, // Initial placeholder for animations, updated after fetching
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

Future<void> _fetchTickets() async {
setState(() {
_isLoading = true;
_errorMessage = null;
});

try {
final response = await _supportService.fetchTicketList(
page: 1,
sizePerPage: 10,
status: _selectedStatus == 'All' ? null : _selectedStatus.toUpperCase(),
);
if (response['status'] == true) {
setState(() {
_allTickets = List<Map<String, dynamic>>.from(response['data']['ticketList']).asMap().entries.map((entry) {
final ticket = entry.value;
return {
'serialNo': entry.key + 1,
'enquiryType': _mapPriorityToEnquiryType(ticket['priority']),
'ticketId': 'TCK${ticket['id'].toString().padLeft(5, '0')}',
'title': ticket['subject'],
'status': ticket['status'],
'lastUpdated': ticket['updatedAt'].split('T')[0],
'message': ticket['message'], // For TicketDetailsScreen
};
}).toList();
_fadeAnimations = List.generate(
_allTickets.length,
(index) => Tween<double>(begin: 0.0, end: 1.0).animate(
CurvedAnimation(
parent: _animationController,
curve: Interval(index * 0.1, 1.0, curve: Curves.easeIn),
),
),
);
_animationController.forward(from: 0.0);
_isLoading = false;
});
} else {
setState(() {
_isLoading = false;
_errorMessage = response['message'] ?? 'Failed to fetch tickets';
});
_showSnackBar(_errorMessage!, AppColors.red);
}
} catch (e) {
setState(() {
_isLoading = false;
_errorMessage = e.toString().contains('EACCES')
? 'Server error: Unable to process request. Please try again or contact support.'
    : e.toString();
});
_showSnackBar(_errorMessage!, AppColors.red);
}
}

String _mapPriorityToEnquiryType(String priority) {
switch (priority.toUpperCase()) {
case 'LOW':
return 'General Inquiry';
case 'MEDIUM':
return 'Technical Support';
case 'HIGH':
return 'Payment Issue';
default:
return 'General Inquiry';
}
}

void _showSnackBar(String message, Color backgroundColor) {
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
action: message.contains('Server error')
? SnackBarAction(
label: 'Retry',
textColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
onPressed: _fetchTickets,
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
title: 'My Tickets',
showBackButton: true,
onBackPressed: () {
Navigator.pop(context);
_showSnackBar('Returning to Profile', AppColors.green);
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
child: Stack(
children: [
SingleChildScrollView(
child: Padding(
padding: EdgeInsets.symmetric(horizontal: 24.w),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
SizedBox(height: 16.h),
_buildFilterBar(isDarkMode),
SizedBox(height: 16.h),
_isLoading
? Center(
child: CircularProgressIndicator(
color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
strokeWidth: 3,
),
)
    : _allTickets.isEmpty
? _buildEmptyState(isDarkMode)
    : ListView.builder(
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
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
if (_isLoading)
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

Widget _buildFilterBar(bool isDarkMode) {
return SizedBox(
width: double.infinity, // Constrain the Row to screen width
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Container(
width: 150.w, // Constrain dropdown width
padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
decoration: BoxDecoration(
color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
borderRadius: BorderRadius.circular(24.r),
border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
),
child: DropdownButton<String>(
value: _selectedStatus,
isExpanded: true, // Ensure dropdown fits within container
items: _statusFilters.map((String status) {
return DropdownMenuItem<String>(
value: status,
child: Text(
status,
style: TextStyle(
fontSize: 16.sp,
color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
),
overflow: TextOverflow.ellipsis,
),
);
}).toList(),
onChanged: (String? newValue) {
if (newValue != null) {
setState(() {
_selectedStatus = newValue;
});
_fetchTickets();
_showSnackBar('Status filter changed to $newValue', AppColors.green);
}
},
underline: const SizedBox(),
icon: Icon(
Icons.keyboard_arrow_down,
color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
size: 20.sp,
),
dropdownColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
borderRadius: BorderRadius.circular(12.r),
isDense: true,
style: TextStyle(
fontSize: 16.sp,
color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
),
),
),
_buildSearchBar(isDarkMode),
],
),
);
}

Widget _buildSearchBar(bool isDarkMode) {
return Flexible(
child: GestureDetector(
onTap: () {
_showSnackBar('Search and filter coming soon!', AppColors.green);
},
child: AnimatedContainer(
duration: const Duration(milliseconds: 200),
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
Flexible( // Changed from Expanded to Flexible
child: Text(
'Search tickets...',
style: TextStyle(
color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
fontSize: 14.sp,
),
overflow: TextOverflow.ellipsis,
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
Row(
children: [
Container(
padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
decoration: BoxDecoration(
color: ticket['status'] == 'CLOSED'
? AppColors.green
    : ticket['status'] == 'OPEN'
? AppColors.red
    : AppColors.yellow, // Assuming PROCESSING is yellow
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
const Spacer(),
Icon(Icons.calendar_today, size: 14.sp, color: textColor),
SizedBox(width: 4.w),
Text(
ticket['lastUpdated'],
style: TextStyle(fontSize: 12.sp, color: textColor),
),
],
),
SizedBox(height: 12.h),
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
