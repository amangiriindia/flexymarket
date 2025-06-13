
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/common_app_bar.dart';
import 'my_tickets_screen.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _category, _title, _priority, _description;
  final List<String> _categories = [
    'General Inquiry',
    'Technical Support',
    'Payment Issue',
    'Trading Issue',
    'Withdrawal Inquiry'
  ];
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  void _submitTicket() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ticket created successfully',
            style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
          ),
          backgroundColor: AppColors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyTicketsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'Create Ticket',
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
                  'Create New Ticket',
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fill Details',
                            style: TextStyle(
                              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Divider(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
                          SizedBox(height: 16.h),
                          Wrap(
                            spacing: 16.w,
                            runSpacing: 16.h,
                            children: [
                              SizedBox(
                                width: 300.w,
                                child: DropdownButtonFormField<String>(
                                  decoration: _inputDecoration(isDarkMode, 'Category *'),
                                  items: _categories
                                      .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ))
                                      .toList(),
                                  onChanged: (value) => _category = value,
                                  validator: (value) => value == null ? 'Please select a category' : null,
                                  style: TextStyle(
                                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                                    fontSize: 14.sp,
                                  ),
                                  dropdownColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                                  icon: Icon(Icons.arrow_drop_down, color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                                ),
                              ),
                              SizedBox(
                                width: 300.w,
                                child: TextFormField(
                                  decoration: _inputDecoration(isDarkMode, 'Title *'),
                                  onSaved: (value) => _title = value,
                                  validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                                  style: TextStyle(
                                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 300.w,
                                child: DropdownButtonFormField<String>(
                                  decoration: _inputDecoration(isDarkMode, 'Priority *'),
                                  items: _priorities
                                      .map((priority) => DropdownMenuItem(
                                    value: priority,
                                    child: Text(priority),
                                  ))
                                      .toList(),
                                  onChanged: (value) => _priority = value,
                                  validator: (value) => value == null ? 'Please select a priority' : null,
                                  style: TextStyle(
                                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                                    fontSize: 14.sp,
                                  ),
                                  dropdownColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                                  icon: Icon(Icons.arrow_drop_down, color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  decoration: _inputDecoration(isDarkMode, 'Describe your problem *'),
                                  maxLines: 5,
                                  onSaved: (value) => _description = value,
                                  validator: (value) => value!.isEmpty ? 'Please describe the problem' : null,
                                  style: TextStyle(
                                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          ElevatedButton(
                            onPressed: _submitTicket,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                              foregroundColor: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                              minimumSize: Size(double.infinity, 50.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                              elevation: isDarkMode ? 0 : 2,
                              shadowColor: AppColors.lightShadow,
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                              semanticsLabel: 'Submit Ticket',
                            ),
                          ),
                        ],
                      ),
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

  InputDecoration _inputDecoration(bool isDarkMode, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
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
        borderSide: BorderSide(color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColors.red, width: 2),
      ),
      errorStyle: TextStyle(color: AppColors.red, fontSize: 12.sp),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
  }
}